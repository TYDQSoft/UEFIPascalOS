library uefiinstaller;

{$MODE FPC}

uses uefi,tydqfs,graphics;

procedure efi_console_main(systemtable:Pefi_system_table);[public,alias:'efi_console_main'];
var restartbool:boolean;
    efslext:efi_file_system_list_ext;
    i,j:natuint;
    realsize,realsize2,restsize:qword;
    size:natuint;
    probsize,probsize2,probrestsize:extended;
    procunit,procunit2:byte;
    sfsp:Pefi_simple_file_system_protocol;
    fp:Pefi_file_protocol;
    fsi:efi_file_info;
    sfsi:efi_file_system_info;
    bp:Pefi_block_io_protocol;
    moll:efi_manual_operation_lists_list;
    edl,edl2:efi_disk_list;
    procsize:qword;
    procnum,procnum2,procnum3:natuint;
    procstr,procstr2,procstr3:PWideChar;
    fsh:tydqfs_header;
    {For initialize system info and environment variable list}
    havesysinfo,haveenvirvar:boolean;
    tydqfsi:tydqfs_system_info;
    tydqevl:tydqfs_environment_variable_list;
label label1,label2,label3,label4,label5,label6,label7,label8,label9,label10;
begin
 compheap_initialize; sysheap_initialize;
 efi_console_initialize(systemtable,efi_bck_black,efi_lightgrey,500);
 efi_system_restart_information_off(systemtable,false,restartbool);
 efslext:=efi_list_all_file_system_ext(systemtable);
 if(efslext.fsrwcount=0) then
  begin
   efi_console_output_string(systemtable,'Welcome to TYDQ System Console Installer!'#10);
   efi_console_output_string(systemtable,'The stage 1:Zone the disk to be installed to.'#10);
   edl:=efi_detect_disk_write_ability(systemtable);
   if(edl.disk_count=0) then
    begin
     freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
     efi_console_output_string(systemtable,'Error:no disk can be zoned in your computer.'#10);
     while(True) do;
    end;
   if(edl.disk_count>1) then efi_console_output_string(systemtable,'The disks which can be installed to:'#10)
   else if(edl.disk_count=1) then efi_console_output_string(systemtable,'The disk which can be installed to:'#10);
   for i:=1 to edl.disk_count do
    begin
     bp:=(edl.disk_block_content+i-1)^;
     realsize:=(bp^.Media^.LastBlock+1)*bp^.Media^.BlockSize;
     if(realsize>=1 shl 40) then
      begin
       probsize:=realsize/(1 shl 40); procunit:=4;
      end
     else if(realsize>=1 shl 30) then
      begin
       probsize:=realsize/(1 shl 30); procunit:=3;
      end
     else if(realsize>=1 shl 20) then
      begin
       probsize:=realsize/(1 shl 20); procunit:=2;
      end
     else if(realsize>=1 shl 10) then
      begin
       probsize:=realsize/(1 shl 10); procunit:=1;
      end
     else 
      begin
       probsize:=realsize; procunit:=0;
      end;
     procstr:=UintToPWChar(i);
     efi_console_output_string(systemtable,'Disk ');
     efi_console_output_string(systemtable,procstr);
     efi_console_output_string(systemtable,' - Size:');
     Wstrfree(procstr);
     procstr:=ExtendedToPWChar(probsize,2);
     efi_console_output_string(systemtable,procstr);
     case procunit of 
     4:efi_console_output_string(systemtable,'TiB'#10);
     3:efi_console_output_string(systemtable,'GiB'#10);
     2:efi_console_output_string(systemtable,'MiB'#10);
     1:efi_console_output_string(systemtable,'KiB'#10);
     0:efi_console_output_string(systemtable,'B'#10);
     end;
     Wstrfree(procstr);
    end;
   efi_console_output_string(systemtable,'Select the disk index to install the system:');
   efi_console_read_string(systemtable,procstr);
   procnum:=PWCharToUint(procstr);
   Wstrfree(procstr);
   while(procnum=0) or (procnum>edl.disk_count) do
    begin 
     efi_console_output_string(systemtable,'Error:disk index invaild.'#10);
     efi_console_output_string(systemtable,'Select the disk index to install the system:');
     efi_console_read_string(systemtable,procstr);
     procnum:=PWCharToUint(procstr);
     Wstrfree(procstr);
    end;
   moll.content:=allocmem(sizeof(efi_manual_operation_list)*edl.disk_count);
   moll.count:=edl.disk_count; i:=1;
   while(i<=moll.count) do
    begin
     bp:=(edl.disk_block_content+i-1)^;
     restsize:=(bp^.Media^.LastBlock-2)*bp^.Media^.BlockSize-1 shl 15;
     probrestsize:=restsize/(1 shl 20);
     efi_console_output_string(systemtable,'Do you want to format the disk ');
     procstr:=UintToPWChar(i);
     efi_console_output_string(systemtable,procstr);
     Wstrfree(procstr);
     efi_console_output_string(systemtable,' manually(Y or y is yes,other is no)?'#10);
     efi_console_output_string(systemtable,'Your answer:');
     efi_console_read_string(systemtable,procstr);
     if(WstrcmpL(procstr,'Y')=0) or (WstrcmpL(procstr,'y')=0) then
      begin
       if(i=procnum) then efi_console_output_string(systemtable,'Input the total count of zone in disk(count must be 2-128):')
       else efi_console_output_string(systemtable,'Input the total count of zone in disk(count must be 1-128):');
       efi_console_read_string(systemtable,procstr2);
       procnum2:=PWCharToUint(procstr2);
       Wstrfree(procstr2);
       if(i=procnum) then
        begin
         while(procnum2<=1) or (procnum2>128) do
          begin
           efi_console_output_string(systemtable,'Error:total count invaild.'#10);
           efi_console_output_string(systemtable,'Input the total count of zone in disk(count must be 2-128):');
           efi_console_read_string(systemtable,procstr2);
           procnum2:=PWCharToUint(procstr2);
           Wstrfree(procstr2);
          end;
        end
       else 
        begin
         while(procnum2<=0) or (procnum2>128) do
          begin
           efi_console_output_string(systemtable,'Error:total count invaild.'#10);
           efi_console_output_string(systemtable,'Input the total count of zone in disk(count must be 1-128):');
           efi_console_read_string(systemtable,procstr2);
           procnum2:=PWCharToUint(procstr2);
           Wstrfree(procstr2);
          end;
        end;
       (moll.content+i-1)^.count:=procnum2;
       for j:=1 to procnum2 do
        begin
         efi_console_output_string(systemtable,'Disk ');
         procstr3:=UintToPWChar(i);
         efi_console_output_string(systemtable,procstr3);
         Wstrfree(procstr3);
         efi_console_output_string(systemtable,' rest size:');
         probrestsize:=restsize/(1 shl 20);
         procstr3:=ExtendedToPWChar(probrestsize,2);
         efi_console_output_string(systemtable,procstr3);
         Wstrfree(procstr3);
         efi_console_output_string(systemtable,'GiB');
         efi_console_output_string(systemtable,#10);
         efi_console_output_string(systemtable,'Input the size of disk partition ');
         procstr3:=UintToPWChar(j);
         efi_console_output_string(systemtable,procstr3);
         Wstrfree(procstr3);
         efi_console_output_string(systemtable,'(in MiB,unsigned integer):');
         efi_console_read_string(systemtable,procstr3);
         (moll.content+i-1)^.size[j]:=PWCharToUint(procstr3);
         Wstrfree(procstr3);
         restsize:=restsize-(moll.content+i-1)^.size[j] shl 20;
        end;
      end
     else 
      begin
       efi_console_output_string(systemtable,'Disk ');
       procstr:=UintToPWChar(i);
       efi_console_output_string(systemtable,procstr);
       Wstrfree(procstr);
       efi_console_output_string(systemtable,' formatting will be automatically.'#10);
       if(i=procnum) then
        begin
         (moll.content+i-1)^.size[1]:=128;
         (moll.content+i-1)^.size[2]:=(restsize-128 shl 20) shr 20;
         (moll.content+i-1)^.count:=2;
        end
       else
        begin
         (moll.content+i-1)^.size[1]:=(restsize-128 shl 20) shr 20;
         (moll.content+i-1)^.count:=1;
        end;
      end;
     inc(i);
    end;
   efi_install_cdrom_to_hard_disk(systemtable,edl,procnum,false,moll);
   efi_console_output_string(systemtable,'Installer stage 1 completed!Now you can enter stage 2!'#10);
   freemem(moll.content); moll.count:=0;
   freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
   freemem(efslext.fsrwcontent); freemem(efslext.fsrcontent); efslext.fsrwcount:=0; 
   efi_reset_system_warm(systemtable);
  end
 else 
  begin
   havesysinfo:=false; haveenvirvar:=false;
   if(restartbool) then efi_console_output_string(systemtable,'You are in installer stage 2,Now let us install the whole system to your computer!'#10)
   else efi_console_output_string(systemtable,'Welcome to TYDQ console installer!Now let us directly install the system to your computer.'#10);
   if(efslext.fsrcount>1) then efi_console_output_string(systemtable,'Cdroms are:'#10)
   else if(efslext.fsrcount>0) then efi_console_output_string(systemtable,'Cdrom is:'#10);
   for i:=1 to efslext.fsrcount do
    begin
     efi_console_output_string(systemtable,'Index ');
     procstr:=UintToPWChar(i);
     efi_console_output_string(systemtable,procstr);
     Wstrfree(procstr);
     efi_console_output_string(systemtable,' - Size:');
     sfsp:=(efslext.fsrcontent+i-1)^;
     sfsp^.OpenVolume(sfsp,fp);
     size:=sizeof(efi_file_system_info);
     fp^.GetInfo(fp,@efi_file_system_info_id,size,sfsi);
     probsize:=sfsi.VolumeSize/(1 shl 20);
     procstr:=ExtendedToPWChar(probsize,2);
     efi_console_output_string(systemtable,procstr);
     efi_console_output_string(systemtable,'MiB'#10);
     Wstrfree(procstr);
    end;
   if(efslext.fsrwcount>1) then efi_console_output_string(systemtable,'EFI system partitions are:'#10)
   else if(efslext.fsrwcount>0) then efi_console_output_string(systemtable,'EFI system partition is:'#10);
   for i:=1 to efslext.fsrwcount do
    begin
     efi_console_output_string(systemtable,'Index ');
     procstr:=UintToPWChar(i);
     efi_console_output_string(systemtable,procstr);
     Wstrfree(procstr);
     efi_console_output_string(systemtable,' - Size:');
     sfsp:=(efslext.fsrwcontent+i-1)^;
     sfsp^.OpenVolume(sfsp,fp);
     size:=sizeof(efi_file_system_info);
     fp^.GetInfo(fp,@efi_file_system_info_id,size,sfsi);
     probsize:=sfsi.VolumeSize/(1 shl 20);
     procstr:=ExtendedToPWChar(probsize,2);
     efi_console_output_string(systemtable,procstr);
     efi_console_output_string(systemtable,'MiB'#10);
     Wstrfree(procstr);
    end;
   edl:=efi_disk_empty_list(systemtable); 
   if(edl.disk_count>1) then efi_console_output_string(systemtable,'Empty disks which can be formatted to:'#10)
   else if(edl.disk_count>0) then efi_console_output_string(systemtable,'Empty disk which can be formatted to:'#10);
   for i:=1 to edl.disk_count do
    begin
     bp:=(edl.disk_block_content+i-1)^;
     realsize:=(bp^.Media^.LastBlock+1)*bp^.Media^.BlockSize;
     efi_console_output_string(systemtable,'Index ');
     procstr:=UintToPWChar(i);
     efi_console_output_string(systemtable,procstr);
     Wstrfree(procstr);
     efi_console_output_string(systemtable,' - Size:');
     if(realsize>=1 shl 40) then
      begin
       probsize:=realsize/(1 shl 40); procunit:=2;
      end
     else if(realsize>=1 shl 30) then
      begin
       probsize:=realsize/(1 shl 30); procunit:=1;
      end
     else 
      begin
       probsize:=realsize/(1 shl 20); procunit:=0;
      end;
     procstr:=ExtendedToPWChar(probsize,2);
     efi_console_output_string(systemtable,procstr);
     case procunit of 
     2:efi_console_output_string(systemtable,'TiB'#10);
     1:efi_console_output_string(systemtable,'GiB'#10);
     0:efi_console_output_string(systemtable,'MiB'#10);
     end;
     freemem(procstr);
    end;
   edl2:=efi_disk_tydq_get_fs_list(systemtable);
   if(edl2.disk_count>1) then efi_console_output_string(systemtable,'Formatted TYDQ file system disks:'#10)
   else if(edl2.disk_count>0) then efi_console_output_string(systemtable,'Formatted TYDQ file system disk:'#10)
   else if(edl2.disk_count=0) then efi_console_output_string(systemtable,'No formatted TYDQ file system available.'#10);
   havesysinfo:=tydq_fs_systeminfo_exists(edl2);
   haveenvirvar:=tydq_fs_environment_variable_exists(edl2);
   for i:=1 to edl2.disk_count do
    begin
     fsh:=tydq_fs_read_header(edl2,i);
     efi_console_output_string(systemtable,'TYDQ file system ');
     procstr:=UintToPWChar(i);
     efi_console_output_string(systemtable,procstr);
     Wstrfree(procstr);
     efi_console_output_string(systemtable,':'#10);
     efi_console_output_string(systemtable,'Disk Name:');
     efi_console_output_string(systemtable,@fsh.RootName);
     realsize:=fsh.maxsize;
     if(realsize>=1 shl 40) then
      begin
       probsize:=realsize/(1 shl 40); procunit:=4;
      end
     else if(realsize>=1 shl 30) then
      begin
       probsize:=realsize/(1 shl 30); procunit:=3;
      end
     else if(realsize>=1 shl 20) then
      begin
       probsize:=realsize/(1 shl 20); procunit:=2;
      end
     else if(realsize>=1 shl 10) then
      begin
       probsize:=realsize/(1 shl 10); procunit:=1;
      end
     else 
      begin
       probsize:=realsize; procunit:=0;
      end;
     realsize2:=fsh.usedsize;
     if(realsize2>=1 shl 40) then
      begin
       probsize2:=realsize2/(1 shl 40); procunit2:=4;
      end
     else if(realsize2>=1 shl 30) then
      begin
       probsize2:=realsize2/(1 shl 30); procunit2:=3;
      end
     else if(realsize2>=1 shl 20) then
      begin
       probsize2:=realsize/(1 shl 20); procunit2:=2;
      end
     else if(realsize2>=1 shl 10) then 
      begin
       probsize2:=realsize/(1 shl 10); procunit2:=1;
      end
     else 
      begin
       probsize2:=realsize; procunit2:=0;
      end;
     procstr:=ExtendedToPWChar(probsize,2);
     efi_console_output_string(systemtable,'Max Size:');
     efi_console_output_string(systemtable,procstr);
     case procunit of
     4:efi_console_output_string(systemtable,'TiB'#10);
     3:efi_console_output_string(systemtable,'GiB'#10);
     2:efi_console_output_string(systemtable,'MiB'#10);
     1:efi_console_output_string(systemtable,'KiB'#10);
     0:efi_console_output_string(systemtable,'B'#10);
     end;
     Wstrfree(procstr);
     procstr:=ExtendedToPWChar(probsize2,2);
     efi_console_output_string(systemtable,'Used Size:');
     efi_console_output_string(systemtable,procstr); 
     case procunit of
     4:efi_console_output_string(systemtable,'TiB'#10);
     3:efi_console_output_string(systemtable,'GiB'#10);
     2:efi_console_output_string(systemtable,'MiB'#10);
     1:efi_console_output_string(systemtable,'KiB'#10);
     0:efi_console_output_string(systemtable,'B'#10);
     end;
     Wstrfree(procstr);
    end;
    {Type the cdrom index to install from}
    if(efslext.fsrcount>1) then
     begin
      label1:
      efi_console_output_string(systemtable,'Type cdrom index you want to install from:');
      efi_console_read_string(systemtable,procstr);
      procnum:=PWCharToUint(procstr);
      Wstrfree(procstr);
      if(procnum=0) or (procnum>efslext.fsrcount) then
       begin
        efi_console_output_string(systemtable,'Error:cdrom index invaild.'#10);
        goto label1;
       end;
     end
    else procnum:=1;
    {Type the EFI system partition to install to}
    if(efslext.fsrwcount>1) then
     begin
      label2:
      efi_console_output_string(systemtable,'Type EFI system partition index you want to install to:');
      efi_console_read_string(systemtable,procstr);
      procnum2:=PWCharToUint(procstr);
      Wstrfree(procstr);
      if(procnum2=0) or (procnum2>efslext.fsrwcount) then
       begin
        efi_console_output_string(systemtable,'Error:EFI system partition index invaild.'#10);
        goto label2;
       end;
     end
    else procnum2:=1;
    {Now install the cdrom to the EFI system partition}
    efi_install_cdrom_to_hard_disk_stage2(systemtable,efslext,procnum,procnum2,restartbool);
    {Now format the empty hard disk to TYDQ file system}
    freemem(edl2.disk_block_content); freemem(edl2.disk_content); edl2.disk_count:=0;
    label3:
    efi_console_output_string(systemtable,'Type the total disk number you want to format to TYDQ file system:');
    efi_console_read_string(systemtable,procstr);
    procnum:=PWCharToUint(procstr);
    Wstrfree(procstr);
    if(procnum=0) or (procnum>edl.disk_count) then
     begin
      efi_console_output_string(systemtable,'Error:typed total disk number invaild.'#10);
      goto label3;
     end;
    i:=1;
    while(i<=procnum) do
     begin
      label4:
      efi_console_output_string(systemtable,'Type the disk index you want to format to TYDQ file system:');
      efi_console_read_string(systemtable,procstr);
      procnum2:=PWCharToUint(procstr);
      Wstrfree(procstr);
      if(procnum2=0) or (procnum2>edl.disk_count) then
       begin
        efi_console_output_string(systemtable,'Error:typed disk index invaild.'#10);
        goto label4;
       end;
      label5:
      efi_console_output_string(systemtable,'Type this disk'#39's Name(name length must be 1-255):');
      efi_console_read_string(systemtable,procstr);
      if(Wstrlen(procstr)=0) or (procstr=nil) or (Wstrlen(procstr)>255) then
       begin
        efi_console_output_string(systemtable,'Error:disk name invaild.'#10);
        goto label5;
       end;
      tydq_fs_initialize(edl,procnum2,procstr);
      Wstrfree(procstr);
      if(havesysinfo=false) then
       begin
        label6:
        efi_console_output_string(systemtable,'Do you want to specify this disk as system disk?'#10);
        efi_console_output_string(systemtable,'Your answer(Y or y is yes,other is no):');
        efi_console_read_string(systemtable,procstr);
        if((WStrCmpL(procstr,'Y')=0) or (WstrCmpL(procstr,'y')=0)) then
         begin
          tydq_fs_systeminfo_create(systemtable,edl,procnum2); 
          efi_console_output_string(systemtable,'Do you want to enter the graphics mode when install completed?'#10);
          efi_console_output_string(systemtable,'Your answer(Y or y is yes,other is no):');
          efi_console_read_string(systemtable,procstr2);
          if(WstrCmpL(procstr2,'Y')=0) or (WstrCmpL(procstr2,'y')=0) then
           begin
            tydqfsi:=tydq_fs_systeminfo_read(edl);
            tydqfsi.header.tydqgraphics:=true;
            tydq_fs_systeminfo_write(systemtable,edl,tydqfsi);
           end;
          havesysinfo:=true;
         end
        else if(i=procnum) then
         begin
          efi_console_output_string(systemtable,'Error:You must specify at least one system disk.'#10);
          goto label6;
         end
        else if(i<procnum) then
         begin
          efi_console_output_string(systemtable,'You can format another disk to system disk.'#10);
         end;
       end;
      if(haveenvirvar=false) then
       begin
        label7:
        efi_console_output_string(systemtable,'Do you want to specify this disk as environment variable disk?'#10);
        efi_console_output_string(systemtable,'Your answer(Y or y is yes,other is no):');
        efi_console_read_string(systemtable,procstr);
        if((WStrCmpL(procstr,'Y')=0) or (WstrCmpL(procstr,'y')=0)) then
         begin
          tydq_fs_environment_variable_file_create(systemtable,edl,procnum2); haveenvirvar:=true;
         end
        else if(i=procnum) then
         begin
          efi_console_output_string(systemtable,'Error:You must specify at least one environment variable disk.'#10);
          goto label7;
         end
        else if(i<procnum) then
         begin
          efi_console_output_string(systemtable,'You can format another disk to environment variable disk.'#10);
         end;
       end;
      inc(i,1);
     end;
    freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
    edl:=efi_disk_tydq_get_fs_list(systemtable);
    efi_console_output_string(systemtable,'Now you must create a user to enter the system.'#10);
    label8:
    efi_console_output_string(systemtable,'Type your user name(user name length must be 1-127):');
    efi_console_read_string(systemtable,procstr);
    if(Wstrlen(procstr)=0) or (WStrlen(procstr)>127) then
     begin
      efi_console_output_string(systemtable,'Error:user name invaild.'#10);
      goto label8;
     end;
    label9:
    efi_console_output_string(systemtable,'Type your user password(password length must be 1-32):');
    efi_console_read_password_string(systemtable,procstr2);
    if(Wstrlen(procstr2)=0) or (Wstrlen(procstr2)>32) then
     begin
      efi_console_output_string(systemtable,'Error:user password invaild.'#10);
      goto label9;
     end;
    label10:
    efi_console_output_string(systemtable,'Retype your user password:');
    efi_console_read_password_string(systemtable,procstr3);
    if(WstrCmpL(procstr2,procstr3)<>0) then
     begin
      efi_console_output_string(systemtable,'Error:user password does not match.'#10);
      goto label10;
     end;
   edl2:=efi_disk_tydq_get_fs_list(systemtable);
   tydqfsi:=tydq_fs_systeminfo_read(edl2);
   tydq_fs_systeminfo_add_user(systemtable,edl2,tydqfsi,procstr,procstr2,userlevel_chiefmanager);
   efi_console_output_string(systemtable,'Console install completed!Now you can enter the TYDQ system!'#10);
   freemem(edl2.disk_block_content); freemem(edl2.disk_content); edl2.disk_count:=0;
   efi_reset_system_warm(systemtable);
  end;
end;
procedure efi_graphics_main(systemtable:Pefi_system_table);[public,alias:'efi_graphics_main'];
begin
 compheap_initialize; sysheap_initialize;
end;
function efi_main(ImageHandle:efi_handle;systemtable:Pefi_system_table):efi_status;cdecl;[public,alias:'_DLLMainCRTStartup'];
var outputbool:boolean=false;
    i:natuint;
    efsl:efi_file_system_list;
    edl:efi_disk_list;
    sfsp:Pefi_simple_file_system_protocol;
    fp:Pefi_file_protocol;
    fsi:efi_file_info;
    mode,inputmode:byte;
    status,count:natuint;
    inputstr:PWideChar;
    {Only for selecting Installer mode}
    scancode:word;
    inputkey:efi_input_key;
    waitidx:natuint;
    modeselect:byte;
label label1,label2;
begin
 efi_initialize(ImageHandle,SystemTable);
 compheap_initialize; sysheap_initialize;
 efi_console_initialize(systemtable,efi_bck_black,efi_lightgrey,500);
 efsl:=efi_list_all_file_system(systemtable,1);
 edl:=efi_detect_disk_write_ability(systemtable);
 if(edl.disk_count=0) then 
  begin
   freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
   freemem(efsl.file_system_content); efsl.file_system_count:=0;
   efi_console_output_string(systemtable,'Error:No vaild disk can be installed system.'#10);
   while(True) do;
  end;
 freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
 i:=1; 
 while(i<=efsl.file_system_count) do
  begin
   count:=0;
   sfsp:=(efsl.file_system_content+i-1)^;
   sfsp^.OpenVolume(sfsp,fp);
   status:=fp^.Open(fp,fp,'\EFI\BOOT\bootx64.efi',efi_file_mode_read,efi_file_read_only);
   if(status=efi_success) then inc(count);
   status:=fp^.Open(fp,fp,'\EFI\SETUP\bootx64.efi',efi_file_mode_read,efi_file_read_only);
   if(status=efi_success) then inc(count);
   status:=fp^.Open(fp,fp,'\EFI\SYSTEM\kernelmain.elf',efi_file_mode_read,efi_file_read_only);
   if(status=efi_success) then inc(count);
   if(count=3) then break;
   inc(i,1);
  end;
 if(i>efsl.file_system_count) then 
  begin
   freemem(efsl.file_system_content); efsl.file_system_count:=0;
   efi_console_output_string(systemtable,'Error:No vaild cdrom can be installed to your computer.'#10);
   while(True) do;
  end;
 mode:=efi_system_restart_information_get_mode(systemtable);
 efi_console_output_string(systemtable,UintTOPWChar(mode));
 if(mode<>0) then
  begin
   if(mode=1) then
    begin
     efi_console_main(SystemTable);
    end
   else if(mode=2) then
    begin
     efi_graphics_main(SystemTable);
    end;
  end
 else if(mode=0) then
  begin
   modeselect:=2; inputmode:=0;
   label1:
   efi_console_clear_screen(systemtable);
   efi_console_output_string(systemtable,'Select the system installer'#39's install mode:'#10);
   if(modeselect=1) then efi_console_output_string_with_colour(systemtable,'Enter to Graphics install mode'#10,efi_bck_lightgrey,efi_white)
   else efi_console_output_string_with_colour(systemtable,'Enter to Graphics install mode'#10,efi_bck_black,efi_lightgrey);
   if(modeselect=2) then efi_console_output_string_with_colour(systemtable,'Enter to Console install mode'#10,efi_bck_lightgrey,efi_white)
   else efi_console_output_string_with_colour(systemtable,'Enter to Console install mode'#10,efi_bck_black,efi_lightgrey);
   if(modeselect=3) then efi_console_output_string_with_colour(systemtable,'Empty option'#10,efi_bck_lightgrey,efi_white)
   else efi_console_output_string_with_colour(systemtable,'Empty option'#10,efi_bck_black,efi_lightgrey);
   efi_console_output_string(systemtable,'Press up to go to previous column,press down to go to next column.'#10);
   efi_console_output_string(systemtable,'Press enter to enter the selected mode.'#10);
   SystemTable^.BootServices^.WaitForEvent(1,@SystemTable^.ConIn^.WaitForKey,waitidx);
   SystemTable^.ConIn^.ReadKeyStroke(SystemTable^.ConIn,inputkey);
   scancode:=inputkey.scancode;
   if(inputkey.unicodechar=#10) or (inputkey.unicodechar=#13) then
    begin
     if(modeselect=1) then inputmode:=2 else if(modeselect=2) then inputmode:=1 else goto label1;
     if(modeselect<=2) then goto label2;
    end;
   if(scancode=1) then 
    begin
     if(modeselect=1) then modeselect:=3 else dec(modeselect); goto label1;
    end
   else if(scancode=2) then
    begin
     if(modeselect=3) then modeselect:=1 else inc(modeselect); goto label1;
    end
   else if(scancode<>0) then goto label1;
   label2:
   if(inputmode=1) then
    begin
     efi_console_main(SystemTable);
    end
   else if(inputmode=2) then
    begin
     efi_graphics_main(SystemTable);
    end;
  end;
 freemem(efsl.file_system_content); efsl.file_system_count:=0;
 efi_main:=efi_success;
end;

end.
