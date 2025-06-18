program kernel;

{$MODE ObjFPC}{$H+}

uses uefi,acpi,graphics,console;

type kernel_param=packed record
                  ScreenAddress:Pointer;
                  ScreenColor:boolean;
                  ScreenWidth:dword;
                  ScreenHeight:dword;
                  ACPIRsdpAddress:Pointer;
                  end;

procedure kernel_main(param:kernel_param);
var testarray1,testarray2:array of Natuint;
    ptr:Dword;
    i,j,len:Natuint;
    kconsole:console_screen;
    tempstr:string;
begin
 testarray1:=[1,3,7,13,21,31];
 testarray2:=copy(testarray1,1,3);
 ptr:=graph_heap_allocmem(1,1,param.ScreenWidth,param.ScreenHeight,true);
 kconsole:=console_screen.Create(param.ScreenWidth div 16,param.ScreenHeight div 20,1,1);
 tempstr:='A';
 for i:=1 to 40 do
  begin
   tempstr:=tempstr+'A';
  end;
 kconsole.AddString('ABCDEFGHIJKLMN',graph_color_yellow);
 kconsole.DrawConsole(ptr,1);
 graph_heap_output_screen;
 kconsole.Destroy;
 tempstr:='';
 while True do;
end;
function efi_main(ImageHandle:efi_handle;systemtable:Pefi_system_table):efi_status;{$ifdef cpux86_64}MS_ABI_Default;{$endif}{$ifdef cpui386}cdecl;{$endif}[public,alias:'_start'];
var graphlist:efi_graphics_list;
    param:kernel_param;
    memmap:efi_memory_map;
    smemmap:efi_memory_map_simple;
    memres:efi_memory_map_result;
begin  
 {Initialize the parameters}
 param.ScreenAddress:=nil; param.ScreenColor:=false; 
 param.ScreenWidth:=0; param.ScreenHeight:=0;
 param.ACPIRsdpAddress:=nil;
 {Initialize uefi environment}
 efi_initialize(ImageHandle,systemtable);
 {Initialize the uefi loader}
 efi_console_initialize(efi_bck_black,efi_lightgrey,0);
 efi_console_output_string('Welcome to TYDQ bootloader!'#10);
 {Initialize the Graphics}
 graphlist:=efi_graphics_initialize;
 efi_graphics_get_maxwidth_maxheight_and_maxdepth(graphlist,1);
 if(graphlist.graphics_count>0) then
  begin
   efi_console_output_string('Graphics initializing......'#10);
   {If the Graphics have graphics item,the initialize the graphics}
   param.ScreenAddress:=Pointer((graphlist.graphics_item^)^.Mode^.FrameBufferBase);
   param.ScreenColor:=((graphlist.graphics_item^)^.Mode^.Info^.PixelFormat=PixelRedGreenBlueReserved8BitPerColor);
   param.ScreenWidth:=(graphlist.graphics_item^)^.Mode^.Info^.HorizontalResolution;
   param.ScreenHeight:=(graphlist.graphics_item^)^.Mode^.Info^.VerticalResolution;
   if(param.ScreenAddress=nil) or (param.ScreenWidth=0) or (param.ScreenHeight=0) then
    begin
     efi_console_output_string('ERROR:Screen does not exist,graphics initialization failed.'#10);
     while True do;
    end;
  end
 else
  begin
   efi_console_output_string('ERROR:No Graphics Exists,Booting failed.'#10);
   while True do;
  end;
 {Initialize the Memory}
 efi_console_output_string('Memory Initializing......'#10);
 efi_console_output_string('Initalizating System Heap......'#10);
 memmap:=efi_loader_get_memory_map;
 smemmap:=efi_loader_handle_memory_map(memmap);
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size div 4);
 if(memres.memory_size=0) then
  begin
   efi_console_output_string('ERROR:System Heap intialization failed!');
  end;
 sysheap:=heap_initialize(memres.memory_start,memres.memory_start+memres.memory_size-1,3,3,2,8);
 efi_console_output_string('Initalizating Graphics Heap......'#10);
 memres:=efi_loader_find_suitable_memory_map(smemmap,smemmap.memory_total_size div 4);
 if(memres.memory_size=0) then
  begin
   efi_console_output_string('ERROR:Graphics Heap intialization failed!');
  end;
 graph_heap_initialize(memres.memory_start,memres.memory_start+memres.memory_size-1,12,
 param.ScreenWidth,param.ScreenHeight,param.ScreenAddress,param.ScreenColor);
 param.ACPIRsdpAddress:=efi_get_cpu_info_from_acpi_table;
 {Then Free the Memory of unused}
 efi_freemem(memmap.memory_descriptor);
 efi_freemem(smemmap.memory_start);
 efi_freemem(smemmap.memory_size);
 efi_graphics_free(graphlist);
 {Exit boot services}
 efi_console_output_string('Exit the Boot Services......'#10);
 efi_loader_exit_boot_services;
 {Enable the FPU in loongarch(LoongArch Only)}
 {$IFDEF CPULOONGARCH64}
 asm
  li.w        $t0, 0x1
  csrxchg     $t0, $t0, 0x2
 end;
 {$ENDIF}
 kernel_main(param);
 {Enter the kernel}
 efi_main:=efi_success;
end;
begin
end.
