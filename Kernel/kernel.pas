program kernel;

{$MODE FPC}

uses uefi,binarybase,graphics,device,acpi,kernelbase;

function kernel_timer(param:Pointer):Pointer;
var ptr:Pointer;
    xpos,ypos:Integer;
begin
 ptr:=PPointer(param)^;
 xpos:=graph_heap_get_x_position(ptr); ypos:=graph_heap_get_y_position(ptr);
 graph_heap_edit_canva(ptr,xpos+160,ypos+160,true);
 graph_heap_output_screen;
 kernel_timer:=nil;
end;
procedure kernel_main;[public,alias:'kernel_main'];
var ptr1,ptr2,ptr3,ptr4:Pointer;
    request:acpi_request;
begin
 ptr4:=graph_heap_allocmem(gheap.screen_width,gheap.screen_height,1,1,true);
 ptr1:=graph_heap_allocmem(640,480,1,1,true);
 ptr2:=graph_heap_allocmem(960,720,641,481,true);
 ptr3:=graph_heap_allocmem(640,480,1281,961,true);
 graph_heap_draw_block(ptr4,1,1,gheap.screen_width,gheap.screen_height,graph_color_red);
 graph_heap_draw_eclipse(ptr1,1,1,240,360,graph_color_yellow);
 graph_heap_draw_fanshape(ptr2,480,360,300,60,120,graph_color_green);
 graph_heap_draw_block(ptr3,200,1,240,480,graph_color_blue);
 graph_heap_output_screen;
 kernel_handle_function_init(@kernel_timer);
 kernel_handle_function_add_param(Pointer(ptr1));
 request.requestrootclass:=acpi_request_x86_local_apic;
 request.requestsubclass:=acpi_request_x86_local_apic_timer;
 request.requestAPICIndex:=1;
 request.requestTimer:=10;
 request.requestTimerStatus:=0;
 request.requestNumber:=33;
 acpi_cpu_request_interrupt(os_cpuinfo,request);
 while True do;
 graph_heap_freemem(ptr2);
 graph_heap_freemem(ptr1);
 graph_heap_freemem(ptr4);
 graph_heap_freemem(ptr3); 
end;
function efi_main(ImageHandle:efi_handle;systemtable:Pefi_system_table):efi_status;{$ifdef cpux86_64}MS_ABI_Default;{$endif}{$ifdef cpui386}cdecl;{$endif}[public,alias:'_start'];
    {For UEFI Memory}
var memmap:efi_memory_map;
    smemmap:efi_memory_map_simple;
    memres:efi_memory_map_result;
    {For Graphics}
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
 graphaddress:=0;
 {Initialize the PCI device list}
 efi_console_output_string('Device initializing......'#10);
 devlist:=efi_device_list_initialize;
 {Obtain the graph list}
 graphlist:=efi_graphics_initialize;
 efi_graphics_get_maxwidth_maxheight_and_maxdepth(graphlist,1);
 if(graphlist.graphics_count>0) then
  begin
   efi_console_output_string('GPU initializing......'#10);
   {If the graphlist have graph item,then normally initialize}
   graphaddress:=(graphlist.graphics_item^)^.Mode^.FrameBufferBase;
   graphwidth:=(graphlist.graphics_item^)^.Mode^.Info^.HorizontalResolution;
   graphheight:=(graphlist.graphics_item^)^.Mode^.Info^.VerticalResolution;
   if((graphlist.graphics_item^)^.Mode^.Info^.PixelFormat=PixelRedGreenBlueReserved8BitPerColor) then 
   graphcolortype:=1 
   else 
   graphcolortype:=0;
   if(graphwidth=0) or (graphheight=0) then 
    begin
     efi_console_output_string('Graphics initialization failed.'#10); while True do;
    end;
  end
 else
  begin
   {else initialize empty}
   graphaddress:=0; graphwidth:=0; graphheight:=0; graphcolortype:=0;
   efi_console_output_string('Graphics initialization failed.'#10); while True do;
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
 compheap_initialize(Natuint(memres.memory_start),memres.memory_size,16);
 {Set the system heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size shr 1);
 if(memres.memory_size=0) then
  begin
   efi_console_output_string('System Heap Error!'#10);
   while True do;
  end;
 sysheap_initialize(Natuint(memres.memory_start),memres.memory_size,16);
 {Set the executable heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size shr 3);
 if(memres.memory_size=0) then
  begin
   efi_console_output_string('Executable Heap Error!'#10);
   while True do;
  end;
 exeheap_initialize(Natuint(memres.memory_start),memres.memory_size,16);
 {Set the graphics heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size shr 2); 
 if(memres.memory_size=0) then
  begin
   efi_console_output_string('Graphics Heap Error!'#10);
   while True do;
  end;
 if(graphaddress=0) then
 graph_heap_initialize(memres.memory_start,memres.memory_size,8,graphwidth,graphheight,true,graphcolortype,nil)
 else
 graph_heap_initialize(memres.memory_start,memres.memory_size,8,graphwidth,graphheight,false,graphcolortype,
 Pointer(graphaddress));
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
   if(iocount=0) or (iolist=nil) then
    begin
     inc(i); continue;
    end;
   {Create the device object}
   devobj:=device_list_construct_device_object(tempdevitem.ClassCode[1],tempdevitem.ClassCode[2],tempdevitem.ClassCode[3],
   tempdevitem.manufracturer,tempdevitem.device,iolist,iocount);
   {Add the device object to device list}
   device_list_add_item(os_devlist,devobj);
   {Free the solo device object}
   FreeMem(iolist); iocount:=0;
   FreeMem(devobj.io); devobj.iocount:=0;
   inc(i);
  end;
 efi_Console_output_string('All Device initialized!'#10);
 {Clear the list of memory map}
 efi_freemem(memmap.memory_descriptor);
 efi_freemem(smemmap.memory_start);
 efi_freemem(smemmap.memory_size);
 efi_graphics_free(graphlist);
 efi_device_list_free(devlist);
 {Generate the cpu info}
 efi_console_output_string('Get the Processor information......'#10);
 os_cpuinfo:=efi_get_cpu_info_from_acpi_table;
 efi_console_output_string('Processor information got!'#10);
 {Exit boot services}
 efi_console_output_string('Exit the Boot Services......'#10);
 efi_loader_exit_boot_services(memmap);
 {Enable the FPU in loongarch(LoongArch Only)}
 {$IFDEF CPULOONGARCH64}
 asm
  li.w        $t0, 0x1
  csrxchg     $t0, $t0, 0x2
 end;
 {$ENDIF}
 {Enter the kernel}
 kernel_initialize;
 kernel_main;
 efi_main:=efi_success;
end;

begin
end.
