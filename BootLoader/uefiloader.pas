program uefiloader;

{$MODE FPC}

uses uefi,tydqfs,binarybase,bootconfig;

var proccontent:array[1..67108864] of byte;
    procsize:dword;
    
function efi_main(ImageHandle:efi_handle;systemtable:Pefi_system_table):efi_status;[public,alias:'_mainCRTStartup'];
var {For checking elf file}
    fsi:tydqfs_system_info;
    edl:efi_disk_list;
    sfsp:Pefi_simple_file_system_protocol;
    fp:Pefi_file_protocol;
    efsl:efi_file_system_list;
    i,count:natuint;
    status:efi_status;
    finfo:efi_file_info;
    finfosize:natuint;
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
begin  
 {Initialize the uefi loader}
 compheap_initialize; sysheap_initialize;
 efi_console_initialize(systemtable,efi_bck_black,efi_lightgrey,500);
 efi_console_enable_mouse_blink(systemtable,false,0);
 edl:=efi_disk_tydq_get_fs_list(systemtable);
 fsi:=tydq_fs_systeminfo_read(edl);
 freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
 efsl:=efi_list_all_file_system(systemtable,0);
 i:=1; count:=efsl.file_system_count;
 gpl:=efi_graphics_initialize(systemtable);
 efi_graphics_get_maxwidth_maxheight_and_maxdepth(gpl,1);
 {Detect the kernel file}
 while(i<=count) do
  begin
   sfsp:=(efsl.file_system_content+i-1)^;
   sfsp^.OpenVolume(sfsp,fp);
   fp^.Open(fp,fp,'\EFI\SYSTEM\kernelmain.elf',efi_file_mode_read,efi_file_system);
   fp^.SetPosition(fp,0);
   finfosize:=sizeof(efi_file_info);
   fp^.GetInfo(fp,@efi_file_info_id,finfosize,finfo);
   procsize:=finfo.filesize;
   status:=fp^.efiRead(fp,procsize,proccontent);
   if(status=efi_success) then break;
  end;
 if(i>count) then
  begin
   efi_console_output_string(systemtable,'Boot failed,the kernel does not exist.'#10);
   while(True) do;
  end;
 {Initialize the kernel parameter}
 loaderscreenconfig.screen_is_graphics:=fsi.header.tydqgraphics;
 loaderscreenconfig.screen_address:=(gpl.graphics_item^)^.Mode^.FrameBufferBase;
 loaderscreenconfig.screen_width:=(gpl.graphics_item^)^.Mode^.Info^.HorizontalResolution;
 loaderscreenconfig.screen_height:=(gpl.graphics_item^)^.Mode^.Info^.VerticalResolution;
 {Free the system heap}
 freemem(gpl.graphics_item); gpl.graphics_count:=0;
 freemem(efsl.file_system_content); efsl.file_system_count:=0;
 {Check the elf kernel}
 bool[1]:=Pelf64_header(@proccontent)^.elf64_identify[1]=Byte(#$7F);
 bool[2]:=Pelf64_header(@proccontent)^.elf64_identify[2]=Byte('E');
 bool[3]:=Pelf64_header(@proccontent)^.elf64_identify[3]=Byte('L');
 bool[4]:=Pelf64_header(@proccontent)^.elf64_identify[4]=Byte('F');
 if not(bool[1] and bool[2] and bool[3] and bool[4]) then
  begin
   efi_console_output_string(systemtable,'Boot failed,the kernel is not the elf format file.'#10);
   while(True) do;
  end;
 bool[1]:=Pelf64_header(@proccontent)^.elf64_identify[5]=Byte(#$2);
 if(bool[1]=false) then
  begin
   efi_console_output_string(systemtable,'Boot failed,the kernel is not the elf 64-bit format file.'#10);
   while(True) do;
  end;
 {Load the elf kernel}
 header:=Pelf64_header(@proccontent)^;
 program_headers:=@proccontent+header.elf64_program_header_offset;
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
 PageCount:=(HighAddress-LowAddress) shr 12+1;
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
     SourceStart:=Pointer(@proccontent+(program_headers+i-1)^.program_offset);
     DestStart:=Pointer((program_headers+i-1)^.program_virtual_address+RelocateOffset);
     Move(DestStart^,SourceStart^,(program_headers+i-1)^.program_file_size);
    end;
  end;
 KernelEntry:=Pointer(header.elf64_entry+RelocateOffset);
 efi_console_enable_mouse_blink(systemtable,false,0);
 {Set the parameter for kernel}
 initparam:=allocmem(sizeof(sys_parameter_item));
 initparam^.item_content:=@loaderscreenconfig;
 initparam^.item_size:=sizeof(screen_config);
 param:=sys_parameter_construct(initparam,1);
 {Execute the elf file}
 func.func:=sys_function(KernelEntry);
 funcandparam:=sys_parameter_and_function_construct(param,func,sizeof(return_config));
 partstr:=UintToWhex(Qword(@funcandparam.parameter_parameter));
 efi_console_output_string(systemtable,partstr);
 efi_console_output_string(systemtable,#10);
 Wstrfree(partstr);
 res:=sys_parameter_function_execute(funcandparam);
 {Free the memory}
 sys_parameter_and_function_free(funcandparam);
 SystemTable^.BootServices^.FreePages(KernelRelocateBase,PageCount);
 while True do;
 efi_main:=efi_success;
end;

begin
end.
