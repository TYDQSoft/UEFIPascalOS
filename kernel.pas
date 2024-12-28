program kernel;

{$MODE FPC}

uses uefi,binarybase,bootconfig,graphics,acpi;
    
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
    acpilist:efi_acpi_table_list;
    acpitree:Pacpi_hardware_tree;
    i:qword;
begin  
 {Initialize uefi environment}
 efi_initialize(ImageHandle,systemtable);
 {Initialize the uefi loader}
 efi_console_initialize(efi_bck_black,efi_lightgrey,0);
 efi_console_output_string('Welcome to TYDQ bootloader!'#10);
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
 {Obtain the ACPI Table}
 efi_console_output_string('ACPI initializing......'#10);
 acpilist:=efi_get_acpi_table_list;
 {Initialize the memory map of UEFI}
 efi_console_output_string('Memory initializing......'#10);
 memmap:=efi_loader_get_memory_map;
 smemmap:=efi_loader_handle_memory_map(memmap);
 {Set the compiler heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,1 shl 22);
 compheap_initialize(Natuint(memres.memory_start),memres.memory_size,128);
 {Set the system heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size shr 2);
 sysheap_initialize(Natuint(memres.memory_start),memres.memory_size,128);
 {Set the executable heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size shr 2);
 exeheap_initialize(Natuint(memres.memory_start),memres.memory_size,128);
 {Set the graphics heap}
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size shr 2); 
 graph_heap_initialize(Natuint(memres.memory_start),memres.memory_size,4096,graphwidth,graphheight,graphaddress,graphcolortype);
 {Set the ACPI hardware}
 efi_console_output_string('Preparing the ACPI hardware......'#10);
 for i:=1 to acpilist.count do acpitree:=acpi_start_analyze_hardware((acpilist.content+i-1)^);
 {Clear the list of memory map}
 efi_freemem(memmap.memory_descriptor);
 efi_freemem(smemmap.memory_start);
 efi_freemem(smemmap.memory_size);
 efi_free_acpi_table_list(acpilist);
 efi_graphics_free(graphlist);
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
