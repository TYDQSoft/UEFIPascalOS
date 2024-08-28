program uefiloader;

{$MODE FPC}

uses uefi,binarybase,bootconfig,graphics;
    
function efi_main(ImageHandle:efi_handle;systemtable:Pefi_system_table):efi_status;{$ifdef cpux86_64}MS_ABI_Default;{$endif}{$ifdef cpui386}cdecl;{$endif}[public,alias:'_start'];
var {For checking elf file}
    sfsp:Pefi_simple_file_system_protocol;
    fp:Pefi_file_protocol;
    efsl:efi_file_system_list;
    i,j,count,procindex:natuint;
    status:efi_status;
    finfo:efi_file_info;
    finfosize:natuint;
    proccontent:Pointer;
    procsize:natuint;
    partstr:PWideChar;
    gpl:efi_graphics_list;
    isgraphics:boolean;
    loaderscreenconfig:screen_config;
    {For elf structure}
    header:elf64_header;
    program_headers:^elf64_program_header;
    LowAddress,HighAddress:qword;
    PageCount:qword;
    KernelRelocateBase:qword;
    RelocateOffset:qword;
    ZeroStart:^qword;
    SourceStart,DestStart:^byte;
    KernelEntry:Pointer;
    bool:array[1..4] of boolean;
    {For loading elf files}
    initparam:Psys_parameter_item;
    param:sys_parameter;
    func:sys_parameter_function;
    funcandparam:sys_parameter_function_and_parameter;
    res:Pointer;
    {For memory initializtion}
    memorymap:efi_memory_map;
    memoryavailable:efi_memory_result;
    addressoffset:natuint;
    allocaddress:natuint;
begin  
 {Initialize uefi environment}
 efi_initialize(ImageHandle,systemtable);
 {Initialize the uefi loader}
 efi_console_initialize(efi_bck_black,efi_lightgrey,0);
 efsl:=efi_list_all_file_system(2);
 i:=0; count:=efsl.file_system_count;
 efi_console_output_string('Welcome to TYDQ bootloader!'#10);
 {Detect the kernel file}
 while(i<=count) do
  begin
   inc(i);
   if(i>count) then break;
   sfsp:=(efsl.file_system_content+i-1)^;
   sfsp^.OpenVolume(sfsp,fp);
   status:=fp^.Open(fp,fp,'\EFI\SYSTEM\kernelmain.elf',efi_file_mode_read,0);
   if(status<>efi_success) then continue;
   finfosize:=sizeof(efi_file_info);
   fp^.GetInfo(fp,@efi_file_info_id,finfosize,finfo); 
   procsize:=finfo.FileSize;
   fp^.SetPosition(fp,0);
   proccontent:=efi_allocmem(procsize);
   for j:=1 to procsize do 
    begin
     procindex:=1;
     fp^.efiRead(fp,procindex,(proccontent+j-1)^);
    end;
   fp^.Close(fp);
   if(status=efi_success) then break;
  end;
 if(i>count) then
  begin
   efi_console_output_string('Boot failed,the kernel does not exist.'#10);
   while(True) do;
  end;
 {Initialize the kernel parameter}
 gpl:=efi_graphics_initialize;
 if(gpl.graphics_count=0) then
  begin
   efi_console_output_string('Boot failed,Graphics screen does not exist.'#10);
   while(True) do;
  end;
 efi_graphics_get_maxwidth_maxheight_and_maxdepth(gpl,1);
 loaderscreenconfig.screen_is_graphics:=false;
 loaderscreenconfig.screen_address:=(gpl.graphics_item^)^.Mode^.FrameBufferBase;
 loaderscreenconfig.screen_width:=(gpl.graphics_item^)^.Mode^.Info^.HorizontalResolution;
 loaderscreenconfig.screen_height:=(gpl.graphics_item^)^.Mode^.Info^.VerticalResolution;
 if((gpl.graphics_item^)^.Mode^.Info^.PixelFormat=PixelBlueGreenRedReserved8BitPerColor) then 
 loaderscreenconfig.screen_type:=0
 else if((gpl.graphics_item^)^.Mode^.Info^.PixelFormat=PixelBlueGreenRedReserved8BitPerColor) then 
 loaderscreenconfig.screen_type:=1;
 if(loaderscreenconfig.screen_address=0) then
  begin
   efi_console_output_string('Boot failed,FrameBuffer does not exist.'#10);
   while(True) do;
  end;
 {Free the system heap}
 efi_freemem(gpl.graphics_item); gpl.graphics_count:=0;
 efi_freemem(efsl.file_system_content); efsl.file_system_count:=0;
 {Check the elf kernel}
 bool[1]:=Pelf64_header(proccontent)^.elf64_identify[1]=Byte(#$7F);
 bool[2]:=Pelf64_header(proccontent)^.elf64_identify[2]=Byte('E');
 bool[3]:=Pelf64_header(proccontent)^.elf64_identify[3]=Byte('L');
 bool[4]:=Pelf64_header(proccontent)^.elf64_identify[4]=Byte('F');
 if not(bool[1] and bool[2] and bool[3] and bool[4]) then
  begin
   efi_console_output_string('Boot failed,the kernel is not the elf format file.'#10);
   while(True) do;
  end;
 bool[1]:=Pelf64_header(proccontent)^.elf64_identify[5]=Byte(#$2);
 if(bool[1]=false) then
  begin
   efi_console_output_string('Boot failed,the kernel is not the elf 64-bit format file.'#10);
   while(True) do;
  end;
 {Load the elf kernel}
 header:=Pelf64_header(proccontent)^;
 program_headers:=proccontent+header.elf64_program_header_offset;
 LowAddress:=$FFFFFFFFFFFFFFFF; HighAddress:=0;
 for i:=1 to header.elf64_program_header_number do
  begin
   if((program_headers+i-1)^.program_type=elf_program_table_load) then
    begin
     if(LowAddress>(program_headers+i-1)^.program_physical_address) then
      begin
       LowAddress:=(program_headers+i-1)^.program_physical_address;
      end;
     if(HighAddress<(program_headers+i-1)^.program_physical_address+(program_headers+i-1)^.program_memory_size) then
      begin
       HighAddress:=(program_headers+i-1)^.program_physical_address+(program_headers+i-1)^.program_memory_size;
      end;
    end;
  end;
 PageCount:=(HighAddress-LowAddress) div 4096+2;
 SystemTable^.BootServices^.AllocatePages(AllocateAnyPages,efiLoaderCode,PageCount,KernelRelocateBase);
 RelocateOffset:=kernelRelocateBase-LowAddress;
 Zerostart:=Pointer(KernelRelocateBase);
 for i:=1 to PageCount shl 9 do 
  begin
   (Zerostart+i-1)^:=$0000000000000000;
  end;
 for i:=1 to header.elf64_program_header_number do
  begin
   if((program_headers+i-1)^.program_type=elf_program_table_load) then
    begin
     SourceStart:=Pointer(proccontent+(program_headers+i-1)^.program_offset);
     DestStart:=Pointer((program_headers+i-1)^.program_virtual_address+RelocateOffset);
     Move(SourceStart^,DestStart^,(program_headers+i-1)^.program_file_size);
    end;
  end;
 KernelEntry:=Pointer(header.elf64_entry+RelocateOffset);
 {For memory allocation only}
 memorymap:=efi_loader_get_memory_map;
 memoryavailable:=efi_loader_get_memory_available(memorymap);
 if(memoryavailable.memory_size<1 shl 20+(1 shl 12)*sizeof(heap_segment)+(1 shl 28)*sizeof(graphics_item)+(1 shl 18)*sizeof(graphics_segment)+loaderscreenconfig.screen_width*loaderscreenconfig.screen_height*sizeof(graphics_color)+1 shl 22+(1 shl 16)*sizeof(heap_segment)) then
  begin
   efi_console_output_string('Error:memory size does not enough to start this operating system.'#10);
   while True do;
  end;
 compheap_initialize(Pointer(memoryavailable.memory_address),1 shl 20,1 shl 12);
 addressoffset:=1 shl 20+(1 shl 12)*sizeof(heap_segment);
 graphics_heap_initialize(Pointer(memoryavailable.memory_address+addressoffset),1 shl 28,1 shl 18,loaderscreenconfig.screen_width,loaderscreenconfig.screen_height,Pointer(loaderscreenconfig.screen_address),loaderscreenconfig.screen_type);
 addressoffset:=addressoffset+(1 shl 28)*sizeof(graphics_item)+(1 shl 18)*sizeof(graphics_segment)+loaderscreenconfig.screen_width*loaderscreenconfig.screen_height*sizeof(graphics_color);
 if(addressoffset+8 shl 30<memoryavailable.memory_size) then
  begin
   sysheap_initialize(Pointer(memoryavailable.memory_address+addressoffset),1 shl 32,1 shl 24);
   addressoffset:=addressoffset+1 shl 32+(1 shl 24)*sizeof(heap_segment);
  end
 else if(addressoffset+4 shl 30<memoryavailable.memory_size) then
  begin
   sysheap_initialize(Pointer(memoryavailable.memory_address+addressoffset),1 shl 31,1 shl 23);
   addressoffset:=addressoffset+1 shl 31+(1 shl 23)*sizeof(heap_segment);
  end
 else if(addressoffset+2 shl 30<memoryavailable.memory_size) then
  begin
   sysheap_initialize(Pointer(memoryavailable.memory_address+addressoffset),1 shl 28,1 shl 22);
   addressoffset:=addressoffset+1 shl 28+(1 shl 22)*sizeof(heap_segment);
  end
 else if(addressoffset+1 shl 30<memoryavailable.memory_size) then
  begin
   sysheap_initialize(Pointer(memoryavailable.memory_address+addressoffset),1 shl 25,1 shl 19);
   addressoffset:=addressoffset+1 shl 25+(1 shl 19)*sizeof(heap_segment);
  end
 else
  begin
   sysheap_initialize(Pointer(memoryavailable.memory_address+addressoffset),1 shl 22,1 shl 16);
   addressoffset:=addressoffset+1 shl 22+(1 shl 16)*sizeof(heap_segment);
  end;
 {Set the parameter for kernel}
 initparam:=allocmem(sizeof(sys_parameter_item)*3);
 initparam^.item_content:=@compheap;
 initparam^.item_size:=sizeof(heap_record);
 (initparam+1)^.item_content:=@graphheap;
 (initparam+1)^.item_size:=sizeof(graphics_heap);
 (initparam+2)^.item_content:=@sysheap;
 (initparam+2)^.item_size:=sizeof(heap_record);
 param:=sys_parameter_construct(initparam,3);
 {Execute the elf file}
 efi_console_output_string('Entering the kernel......'#10);
 func.func:=sys_function(KernelEntry);
 funcandparam:=sys_parameter_and_function_construct(param,func,sizeof(natuint));
 sys_parameter_function_execute(funcandparam);
 {Free the memory}
 sysheap.contentused:=0; sysheap.segmentcount:=0;
 graphheap.contentused:=0; graphheap.segmentcount:=0;
 compheap.contentused:=0; compheap.segmentcount:=0;
 efi_console_output_string('Kernel successfully loaded!'#10);
 while True do;
 efi_main:=efi_success;
end;

begin
end.
