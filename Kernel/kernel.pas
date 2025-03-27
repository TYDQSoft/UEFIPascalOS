program kernel;

{$MODE FPC}

uses uefi,binarybase,graphics,device;
    
var os_devlist:device_object_list;

procedure kernel_main;[public,alias:'kernel_main'];
var ptr:Pgraph_item;
begin
 ptr:=graph_heap_allocmem(1,1,graph_heap.screen_width,graph_heap.screen_height,true);
 graph_heap_draw_block(ptr,1,1,graph_heap.screen_width,graph_heap.screen_height,graph_yellow);
 graph_heap_output_screen;
 graph_heap_freemem(ptr);
end;
function efi_main(ImageHandle:efi_handle;systemtable:Pefi_system_table):efi_status;{$ifdef cpux86_64}MS_ABI_Default;{$endif}{$ifdef cpui386}cdecl;{$endif}[public,alias:'_start'];
var memmap:efi_memory_map;
    smemmap:efi_memory_map_simple;
    memres:efi_memory_map_result;
    graphlist:efi_graphics_list;
    graphaddress:natuint=0;
    graphwidth,graphheight:dword;
    graphcolortype:byte;
    i,j:dword;
    {For device convertion only}
    devlist:efi_device_list;
    tempdevitem:efi_pci_configuration_space;
    devobj:device_object;
    iolist:Pdevice_io_info;
    iocount:Byte;
begin  
 {Initialize uefi environment}
 efi_initialize(ImageHandle,systemtable);
 {Initialize the uefi loader}
 efi_console_initialize(efi_bck_black,efi_lightgrey,0);
 efi_console_output_string('Welcome to TYDQ bootloader!'#10);
 {Initialize the PCI device list}
 efi_console_output_string('Device initializing......'#10);
 devlist:=efi_device_list_initialize;
 {Obtain the graph list}
 graphlist:=efi_graphics_initialize;
 efi_graphics_get_maxwidth_maxheight_and_maxdepth(graphlist,1);
 graphaddress:=(graphlist.graphics_item^)^.Mode^.FrameBufferBase;
 graphwidth:=(graphlist.graphics_item^)^.Mode^.Info^.HorizontalResolution;
 graphheight:=(graphlist.graphics_item^)^.Mode^.Info^.VerticalResolution;
 if((graphlist.graphics_item^)^.Mode^.Info^.PixelFormat=PixelRedGreenBlueReserved8BitPerColor) then graphcolortype:=1 else graphcolortype:=0;
 if(graphaddress=0) or (graphwidth=0) or (graphheight=0) then 
  begin
   efi_console_output_string('Graphics initialization failed.'#10);
   while True do;
  end;
 {Initialize the memory map of UEFI}
 efi_console_output_string('Memory initializing......'#10);
 memmap:=efi_loader_get_memory_map;
 smemmap:=efi_loader_handle_memory_map(memmap); 
 {Set the compiler heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,1 shl 22);
 if(memres.memory_size=0) then
  begin
   efi_console_output_string('Compiler Heap Error!'#10);
   while True do;
  end;
 compheap_initialize(Natuint(memres.memory_start),memres.memory_size,128);
 {Set the system heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size shr 1);
 if(memres.memory_size=0) then
  begin
   efi_console_output_string('System Heap Error!'#10);
   while True do;
  end;
 sysheap_initialize(Natuint(memres.memory_start),memres.memory_size,128);
 {Set the executable heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size shr 3);
 if(memres.memory_size=0) then
  begin
   efi_console_output_string('Executable Heap Error!'#10);
   while True do;
  end;
 exeheap_initialize(Natuint(memres.memory_start),memres.memory_size,128);
 {Set the graphics heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size shr 2); 
 if(memres.memory_size=0) then
  begin
   efi_console_output_string('Graphics Heap Error!'#10);
   while True do;
  end;
 graph_heap_initialize(Natuint(memres.memory_start),memres.memory_size,4096,graphwidth,graphheight,graphaddress,graphcolortype);
 {Convert the PCI device list to OS's device list}
 i:=1;
 os_devlist:=device_list_initialize;
 while(i<=devlist.pcicount)do
  begin
   {Get the PCI item of temporary PCI device list}
   tempdevitem:=(devlist.pci+i-1)^;
   {Create the io list}
   j:=1; iolist:=nil; iocount:=0;
   while(j<=6)do
    begin
     if(tempdevitem.AddrStart[j]<>0) and (tempdevitem.AddrEnd[j]<>0) and (tempdevitem.AddrClass[j]=$00) then
      begin
       inc(iocount);
       ReallocMem(iolist,iocount*sizeof(device_io_info));
       (iolist+iocount-1)^.ismmio:=true;
       (iolist+iocount-1)^.ioaddress.address_start:=Pointer(tempdevitem.AddrStart[j]);
       (iolist+iocount-1)^.ioaddress.address_end:=Pointer(tempdevitem.AddrEnd[j]);
       (iolist+iocount-1)^.ioaddress.address_offset:=tempdevitem.AddrOffset[j];
      end;
     inc(j);
    end;
   if(iocount=0) then
    begin
     inc(i); continue;
    end
   else
    begin
     efi_console_output_string('Vaild MMIO Device!'#10);
    end;
   {Create the device object}
   devobj:=device_list_construct_device_object(tempdevitem.ClassCode[1],tempdevitem.ClassCode[2],tempdevitem.ClassCode[3],
   tempdevitem.manufracturer,tempdevitem.device,iolist,iocount);
   {Add the device object to device list}
   device_list_add_item(os_devlist,devobj);
   {Free the solo device object}
   FreeMem(iolist); iocount:=0;
   FreeMem(devobj.name); FreeMem(devobj.io); devobj.iocount:=0;
   inc(i);
  end;
 efi_Console_output_string('All Device initialized!'#10);
 while True do;
 {Clear the list of memory map}
 efi_freemem(memmap.memory_descriptor);
 efi_freemem(smemmap.memory_start);
 efi_freemem(smemmap.memory_size);
 efi_graphics_free(graphlist);
 efi_device_list_free(devlist);
 {Exit boot services}
 efi_console_output_string('Exit the Boot Services......'#10);
 efi_loader_exit_boot_services(memmap);
 {Enter the kernel}
 kernel_main;
 while True do;
 efi_main:=efi_success;
end;

begin
end.
