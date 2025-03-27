unit fsbase;

interface

{$mode FPC}

type fat_bpb_header=packed record
                    bpb_jumpboot:array[1..3] of byte;
                    bpb_oemname:array[1..8] of char;
                    bpb_bytesPerSector:word;
                    bpb_SectorPerCluster:byte;
                    bpb_ReservedSectorCount:word;
                    bpb_NumberOfFATS:byte;
                    bpb_RootEntryCount:word;
                    bpb_TotalSector16:word;
                    bpb_media:byte;
                    bpb_FatSectorCount16:word;
                    bpb_SectorsPerTrack:word;
                    bpb_NumberOfHeads:word;
                    bpb_HiddenSector:dword;
                    bpb_TotalSector32:dword;
                    end;
     fat_extended_bpb_header_for_fat12_and_fat16=packed record
                                                bs_driver_number:byte;
                                                bs_reserved1:byte;
                                                bs_bootsig:byte;
                                                bs_volume_id:dword;
                                                bs_volume_label:array[1..11] of char;
                                                bs_filesystem_type:array[1..8] of char;
                                                bs_reserved2:array[1..448] of byte;
                                                bs_signature:word;
                                                end;
    fat_extended_flags=bitpacked record
                       NumberOfActiveFAT:0..15;
                       Reserved1:0..7;
                       FATmirrorDisable:0..1;
                       Reserved2:0..255;
                       end;
    fat_extended_bpb_header_for_fat32=packed record
                                      bpb_FatSectorCount32:dword;
                                      bpb_ExtendedFlags:fat_extended_flags;
                                      bpb_filesystemversion:word;
                                      bpb_rootcluster:dword;
                                      bpb_filesysteminfo:word;
                                      bpb_backupBootSector:word;
                                      bpb_reserved:array[1..12] of byte;
                                      bs_driver_number:byte;
                                      bs_reserved1:byte;
                                      bs_bootsig:byte;
                                      bs_volume_id:dword;
                                      bs_volume_label:array[1..11] of char;
                                      bs_filesystem_type:array[1..8] of char;
                                      bs_reserved2:array[1..420] of byte;
                                      bs_signature:word;
                                      end;
    fat_header=packed record
               head:fat_bpb_header;
               exthead:fat_extended_bpb_header_for_fat12_and_fat16;
               end;
    fat32_header=packed record
                 head:fat_bpb_header;
                 exthead:fat_extended_bpb_header_for_fat32;
                 end;
    fat12_entry=0..$FFF;
    fat16_entry=0..$FFFF;
    fat32_entry=0..$FFFFFFFF;
    fat_entry=packed record
              case Byte of
              0:(entry12:fat12_entry;);
              1:(entry16:fat16_entry;);
              2:(entry32:fat32_entry;);
              end;
    fat12_entry_pair=bitpacked record
                     entry1:0..$FFF;
                     entry2:0..$FFF;
                     end;
    fat16_entry_pair=array[1..2] of fat16_entry;
    fat32_entry_pair=array[1..2] of fat32_entry;
    fat_entry_pair=packed record
                   case Byte of
                   0:(entry12:fat12_entry_pair;);
                   1:(entry16:fat16_entry_pair;);
                   2:(entry32:fat32_entry_pair;);
                   end;
    fat_fsinfo_structure=packed record
                         leadsignature:dword;
                         reserved1:array[1..480] of byte;
                         structsignature:dword;
                         freecount:dword;
                         nextfree:dword;
                         reserved2:array[1..3] of dword;
                         trailsignature:dword;
                         end;
    fat_date=bitpacked record
             DayOfMonth:0..31;
             MonthOfYear:0..15;
             CountOfYear:0..127;
             end;
    Pfat_date=^fat_date;
    fat_time=bitpacked record
             ElapsedSeconds:0..31;
             Minutes:0..63;
             Hours:0..31;
             end;
    Pfat_time=^fat_time;
    fat_directory_structure=packed record
                            directoryname:array[1..8] of char;
                            directoryext:array[1..3] of char;
                            directoryattribute:byte;
                            directoryreserved1:byte;
                            directoryfilecreationtimetenthofsecond:byte;
                            directoryfilecreationtime:fat_time;
                            directoryfilecreationdate:fat_date;
                            directorylastaccessdate:fat_date;
                            directoryfirstclusterhighword:word;
                            directorywritetime:fat_time;
                            directorywritedate:fat_date;
                            directoryfirstclusterlowword:word;
                            directoryfilesize:dword;
                            end;
    Pfat_directory_structure=^fat_directory_structure;
    fat_long_directory_structure=packed record
                                 longdirectoryorder:byte;
                                 longdirectoryname1:array[1..5] of Widechar;
                                 longdirectoryattr:byte;
                                 longdirectorytype:byte;
                                 longdirectorychecksum:byte;
                                 longdirectoryname2:array[1..6] of Widechar;
                                 longdirectoryfirstclusterlowword:word;
                                 longdirectoryname3:array[1..2] of Widechar;
                                 end;
    Pfat_long_directory_structure=^fat_long_directory_structure;
    fat_total_time=packed record
                   date:fat_date;
                   time:fat_time;
                   end;
    Pfat_total_time=^fat_total_time;
    fat_directory=packed record
                  longdir:Pfat_long_directory_structure;
                  longdircount:Dword;
                  dir:fat_directory_structure;
                  end;
    fat_unicode_fn=packed record
                   fn1:array[1..5] of WideChar;
                   fn2:array[1..6] of WideChar;
                   fn3:array[1..2] of WideChar;
                   end;
    fat_string=packed record
               ansifn:array[1..8] of char;
               ansiext:array[1..3] of char;
               unicodefn:^fat_unicode_fn;
               unicodefncount:SizeUint;
               end;
    ntfs_pbs_header=packed record
                    pbs_jumpboot:array[1..3] of byte;
                    pbs_oemid:array[1..8] of char;
                    pbs_byteperSector:word;
                    pbs_sectorPerCluster:byte;
                    pbs_unused1:array[1..7] of byte;
                    pbs_drivetype:byte;
                    pbs_unused2:word;
                    pbs_sectorsPerTrack:word;
                    pbs_NumberOfHeads:word;
                    pbs_hiddenSectors:dword;
                    pbs_unused3:dword;
                    end;

const fat_bpb_jumpboot:array[1..3] of byte=($EB,$58,$90);
      fat_bpb_oemname:array[1..8] of char=('f','s','g','e','n','f','a','t');
      fat_bpb_media:array[1..9] of byte=($F0,$F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF);
      fat_default_label_name:array[1..11] of char=('V','A','I','L','D','V','O','L','U','M','E');
      fat12_default_name:array[1..8] of char=('F','A','T','1','2',' ',' ',' ');
      fat16_default_name:array[1..8] of char=('F','A','T','1','6',' ',' ',' ');
      fat32_default_name:array[1..8] of char=('F','A','T','3','2',' ',' ',' ');
      fat_default_name:array[1..8] of char=('F','A','T',' ',' ',' ',' ',' ');
      fat_signature_word:word=$AA55;
      fat32_lead_signature:dword=$41615252;
      fat32_struct_signature:dword=$61417272;
      fat32_trail_signature:dword=$AA550000;
      fat_attribute_read_only:byte=$01;
      fat_attribute_hidden:byte=$02;
      fat_attribute_system:byte=$04;
      fat_attribute_volume_id:byte=$08;
      fat_attribute_directory:byte=$10;
      fat_attribute_archive:byte=$20;
      fat_attribute_long_name:byte=$0F;
      fat_attribute_long_name_mask:byte=$3F;
      fat_attribute_last_long_entry=$40;
      fat16_clean_bit_mask:word=$8000;
      fat16_no_disk_io_error:word=$4000;
      fat32_clean_bit_mask:dword=$08000000;
      fat32_no_disk_io_error:dword=$04000000;
      fat12_cluster_broken:fat12_entry=$FF7;
      fat16_cluster_broken:fat16_entry=$FFF7;
      fat32_cluster_broken:fat32_entry=$0FFFFFF7;
      fat12_final_cluster_low:fat12_entry=$FF8;
      fat16_final_cluster_low:fat16_entry=$FFF8;
      fat32_final_cluster_low:fat32_entry=$0FFFFFF8;
      fat12_final_cluster_high:fat12_entry=$FFF;
      fat16_final_cluster_high:fat16_entry=$FFFF;
      fat32_final_cluster_high:fat32_entry=$0FFFFFFF;
      fat_directory_file=$01;
      fat_directory_volume=$02;
      fat_directory_directory=$04;
      fat_directory_long=$08;
      fat_bit12=12;
      fat_bit16=16;
      fat_bit32=32;
      fat_available=0;
      fat_using=1;
      fat_cluster_broken=2;
      fat_end=3;
      ntfs_bpb_jumpboot:array[1..3] of byte=($EB,$52,$90);
      ntfs_bpb_oemname:array[1..8] of char=('N','T','F','S',' ',' ',' ',' ');
      filesystem_fat12=0;
      filesystem_fat16=1;
      filesystem_fat32=2;
      filesystem_exfat=3;
      filesystem_ntfs=4;
      filesystem_ext2=5;
      filesystem_ext3=6;
      filesystem_ext4=7;
      filesystem_btrfs=8;

procedure fat_jump_boot_move(var dest);
procedure fat_oem_name_move(var dest);
procedure fat_default_volume_label_move(var dest);
procedure fat_default_file_system_type_move(const bit:byte;var dest);
function fat12_check_cluster_status(const number:fat12_entry):byte;
function fat16_check_cluster_status(const number:fat16_entry):byte;
function fat32_check_cluster_status(const number:fat32_entry):byte;
function fat_PWideCharToFatString(const str:PWideChar):fat_string;
function fat_FatStringToPWideChar(const str:fat_string):PWideChar;
procedure fat_MoveDirStructStringToFatString(const source:fat_directory_structure;
var dest:fat_string);
procedure fat_MoveLongDirStructStringToFatString(const source:fat_long_directory_structure;
var dest:fat_string;index:SizeUint);
procedure fat_MovefatStringToDirStruct(const Source:fat_string;
var Dest:fat_directory_structure);
procedure fat_MovefatStringToLongDirStruct(const Source:fat_String;const index:SizeUint;
var Dest:fat_long_directory_structure);
function fat_FatStringToFatDirectory(const Source:fat_string;FileAttr:byte;
date:fat_date;time:fat_time;FileSize:SizeUint;ClusterPos:dword):fat_directory;
function fat_get_file_class(attr:byte;islong:boolean):byte;
function fat_calculate_directory_size(const str:PWideChar):SizeUint;
function fat_PWideCharIsLongFileName(const str:PWideChar):boolean;
function fat_generate_checksum(const dirstruct:fat_directory_structure):byte;
function fat_generate_regular_short_file_name(const str:PWideChar;inputindex:byte):PChar;
function fat_change_short_file_name(const str:PChar;var dir:fat_directory_structure):byte;

implementation

procedure fat_jump_boot_move(var dest);
begin
 Move(fat_bpb_jumpboot[1],dest,3);
end;
procedure fat_oem_name_move(var dest);
begin
 Move(fat_bpb_oemname[1],dest,8);
end;
procedure fat_default_volume_label_move(var dest);
begin
 Move(fat_default_label_name[1],dest,11);
end;
procedure fat_default_file_system_type_move(const bit:byte;var dest);
begin
 if(bit=12) then Move(fat12_default_name,dest,8)
 else if(bit=16) then Move(fat16_default_name,dest,8)
 else if(bit=32) then Move(fat32_default_name,dest,8);
end;
function fat12_check_cluster_status(const number:fat12_entry):byte;
begin
 if(number>=2) and (number<fat12_cluster_broken) then exit(fat_using)
 else if(number<2) then exit(fat_available)
 else if(number=fat12_cluster_broken) then exit(fat_cluster_broken)
 else exit(fat_end);
end;
function fat16_check_cluster_status(const number:fat16_entry):byte;
begin
 if(number>=2) and (number<fat16_cluster_broken) then exit(fat_using)
 else if(number<2) then exit(fat_available)
 else if(number=fat16_cluster_broken) then exit(fat_cluster_broken)
 else exit(fat_end);
end;
function fat32_check_cluster_status(const number:fat32_entry):byte;
begin
 if(number>=2) and (number<fat32_cluster_broken) then exit(fat_using)
 else if(number<2) then exit(fat_available)
 else if(number=fat32_cluster_broken) then exit(fat_cluster_broken)
 else exit(fat_end);
end;
function fat_generate_checksum(const dirstruct:fat_directory_structure):byte;
var i,j,Result:byte;
begin
 Result:=0; j:=1;
 for i:=11 downto 1 do
  begin
   if(Result and 1=1) and (j<=8) then
   Result:=$80+Result shr 1+Byte(dirstruct.directoryname[j])
   else if(j<=8) then
   Result:=Result shr 1+Byte(dirstruct.directoryname[j])
   else if(Result and 1=1) and (j>8) then
   Result:=$80+Result shr 1+Byte(dirstruct.directoryext[j-8])
   else if(j>8) then
   Result:=Result shr 1+Byte(dirstruct.directoryext[j-8]);
   inc(j);
  end;
 fat_generate_checksum:=Result;
end;
function fat_string_compare(str1:PWideChar;str2:PWideChar):boolean;
var i,j:SizeUint;
begin
 i:=1; j:=1;
 while((str1+i-1)^<>#0) or ((str2+i-1)^<>#0) do
  begin
   if((str1+i-1)^<>(str2+i-1)^) then exit(false);
   inc(i);
  end;
 fat_string_compare:=true;
end;
function fat_generate_regular_short_file_name(const str:PWideChar;inputindex:byte):PChar;
var i,j,len:SizeUint;
    res:PChar;
    index:byte;
begin
 index:=Byte(inputindex-Byte('0'));
 if(index>=1) and (index<=9) then
  begin
   res:=allocmem(sizeof(char)*13); i:=1;
   while(i<=6)do
    begin
     if((str+i-1)^>=#127) then (res+i-1)^:='_'
     else if((str+i-1)^>='a') and ((str+i-1)^<='z') then
     (res+i-1)^:=Char(Byte('A')+Byte((str+i-1)^)-Byte('a'));
     inc(i);
    end;
   (res+5)^:='~'; (res+6)^:=Char(index); (res+7)^:='.';
   i:=1;
   while((str+i-1)^<>'.') and ((str+i-1)^<>' ')do inc(i);
   j:=i; inc(i);
   while(i>=j) and (i-j>=3)do
    begin
     if((str+i-1)^>=#127) then (res+j-i+7)^:='_'
     else if((str+i-1)^>='a') and ((str+i-1)^<='z') then
     (res+j-i+7)^:=Char(Byte('A')+Byte((str+i-1)^)-Byte('a'));
     inc(i);
    end;
   (res+12)^:=#0;
  end
 else
  begin
   res:=allocmem(sizeof(char)*13); i:=1;
   while(i<=2)do
    begin
     if((str+i-1)^>=#127) then (res+i-1)^:='_'
     else if((str+i-1)^>='a') and ((str+i-1)^<='z') then
     (res+i-1)^:=Char(Byte('A')+Byte((str+i-1)^)-Byte('a'));
     inc(i);
    end;
   i:=3;
   while(i<=6)do
    begin
     randomize;
     (str+i-1)^:=Char(33+random(94));
     inc(i);
    end;
   i:=1;
   while((str+i-1)^<>'.') and ((str+i-1)^<>' ')do inc(i);
   j:=i; inc(i);
   while(i>=j) and (i-j>=3)do
    begin
     if((str+i-1)^>=#127) then (res+j-i+7)^:='_'
     else if((str+i-1)^>='a') and ((str+i-1)^<='z') then
     (res+j-i+7)^:=Char(Byte('A')+Byte((str+i-1)^)-Byte('a'));
     inc(i);
    end;
   (res+12)^:=#0;
  end;
 fat_generate_regular_short_file_name:=res;
end;
function fat_change_short_file_name(const str:PChar;var dir:fat_directory_structure):byte;
var i:SizeUint;
begin
 i:=1;
 while(i<=8)do
  begin
   dir.directoryname[i]:=(str+i-1)^;
   inc(i);
  end;
 i:=10;
 while(i<=12)do
  begin
   dir.directoryext[i-9]:=(str+i-1)^;
   inc(i);
  end;
 fat_change_short_file_name:=fat_generate_checksum(dir);
end;
function fat_PWideCharIsLongFileName(const str:PWideChar):boolean;
var i,fpos:SizeUint;
    count:byte;
begin
 if(fat_string_compare(str,'..')) then
  begin
   fat_PWideCharIsLongFileName:=false;
  end
 else if(fat_string_compare(str,'.')) then
  begin
   fat_PWideCharIsLongFileName:=false;
  end
 else
  begin
   i:=0; count:=0; fpos:=0;
   while((str+i)^<>#0)do
    begin
     if((str+i)^='.') then
      begin
       inc(count);
       if(fpos=0) then fpos:=i+1;
      end;
     if((str+i)^=' ') then exit(true);
     if((str+i)^>#127) then exit(true);
     inc(i);
    end;
   if(count>1) then exit(true);
   if(i<=8) and (count=0) then exit(false)
   else if(i<=12) and (count=1) and (fpos>=i-3) then exit(false)
   else exit(true);
  end;
end;
function fat_calculate_directory_size(const str:PWideChar):SizeUint;
var bool:boolean;
    i:SizeUint;
begin
 bool:=fat_PWideCharIsLongFileName(str); i:=1;
 while((str+i)^<>#0) do inc(i);
 if(bool) then fat_calculate_directory_size:=(i div 13+2)*sizeof(fat_long_directory_structure)
 else fat_calculate_directory_size:=sizeof(fat_directory_structure);
end;
function fat_PWideCharToFatString(const str:PWideChar):fat_string;
var bool,tempbool:boolean;
    extpos:SizeUint;
    tempfn:fat_unicode_fn;
    Result:fat_string;
    i,j,len:SizeUint;
begin
 for i:=1 to 8 do Result.ansifn[i]:=' ';
 for i:=1 to 3 do Result.ansiext[i]:=' ';
 bool:=fat_PWideCharIsLongFileName(str);
 Result.unicodefncount:=0; Result.unicodefn:=nil;
 if(bool=true) then
  begin
   i:=1; len:=0;
   while((str+len)^<>#0) do
    begin
     if((str+len)^='.') then extpos:=len+1;
     inc(len);
    end;
   while(i<=len div 13+1)do
    begin
     inc(Result.unicodefncount);
     ReallocMem(Result.unicodefn,Result.unicodefncount*sizeof(fat_long_directory_structure));
     j:=1;
     while(j<=5)do
      begin
       if((i-1)*13+j<=len) then
       (Result.unicodefn+Result.unicodefncount-1)^.fn1[j]:=(str+(i-1)*13+j-1)^
       else if((i-1)*13+j=len+1) then
       (Result.unicodefn+Result.unicodefncount-1)^.fn1[j]:=#0
       else
       (Result.unicodefn+Result.unicodefncount-1)^.fn1[j]:=#$FFFF;
       inc(j);
      end;
     j:=6;
     while(j<=11)do
      begin
       if((i-1)*13+j<=len) then
       (Result.unicodefn+Result.unicodefncount-1)^.fn2[j-5]:=(str+(i-1)*13+j-1)^
       else if((i-1)*13+j=len+1) then
       (Result.unicodefn+Result.unicodefncount-1)^.fn2[j-5]:=#0
       else
       (Result.unicodefn+Result.unicodefncount-1)^.fn2[j-5]:=#$FFFF;
       inc(j);
      end;
     j:=12;
     while(j<=13)do
      begin
       if((i-1)*13+j<=len) then
       (Result.unicodefn+Result.unicodefncount-1)^.fn3[j-11]:=(str+(i-1)*13+j-1)^
       else if((i-1)*13+j=len+1) then
       (Result.unicodefn+Result.unicodefncount-1)^.fn3[j-11]:=#0
       else
       (Result.unicodefn+Result.unicodefncount-1)^.fn3[j-11]:=#$FFFF;
       inc(j);
      end;
     inc(i);
    end;
   {Generate the corresponding short file name}
   i:=1; j:=1;
   while(j<=6)do
    begin
     if((str+i-1)^=#$E5) then
      begin
       Result.ansifn[j]:=#$5;
       inc(i); inc(j);
      end
     else if((str+i-1)^>#127) then
      begin
       Result.ansifn[j]:='_';
       inc(i); inc(j);
      end
     else if((str+i-1)^<=' ') then
      begin
       inc(i);
      end
     else if((str+i-1)^>='a') and ((str+i-1)^<='z') then
      begin
       Result.ansifn[j]:=Char(Byte('A')+Byte((str+i-1)^)-Byte('a'));
       inc(i); inc(j);
      end
     else
      begin
       Result.ansifn[j]:=Char((str+i-1)^);
       inc(i); inc(j);
      end;
    end;
   Result.ansifn[7]:='~'; Result.ansifn[8]:='1';
   i:=extpos+1; j:=1;
   while(j<=3) and (i<=len) do
    begin
     if((str+i-1)^>#127) then
      begin
       Result.ansiext[j]:='_';
       inc(i); inc(j); continue;
      end
     else if((str+i-1)^<=' ') then
      begin
       inc(i); continue;
      end
     else if((str+i-1)^>='a') and ((str+i-1)^<='z') then
      begin
       Result.ansiext[j]:=Char(Byte('A')+Byte((str+i-1)^)-Byte('a'));
       inc(i); inc(j); continue;
      end
     else
      begin
       Result.ansiext[j]:=Char((str+i-1)^);
       inc(i); inc(j); continue;
      end;
     inc(j);
    end;
  end
 else
  begin
   if(Fat_String_Compare(str,'..')) then
    begin
     Result.ansifn[1]:='.'; Result.ansifn[2]:='.';
    end
   else if(Fat_String_Compare(str,'.')) then
    begin
     Result.ansifn[1]:='.';
    end
   else
    begin
     i:=1; j:=1; tempbool:=false;
     while((str+i-1)^<>#0)do
      begin
       if((str+i-1)^='.') then
        begin
         j:=i; inc(i); tempbool:=true; continue;
        end
       else if((str+i-1)^>='a') and ((str+i-1)^<='z') and (tempbool) then
        begin
         Result.ansiext[i-j]:=Char(Byte('A')+Byte((str+i-1)^)-Byte('a'));
        end
       else if((str+i-1)^>='a') and ((str+i-1)^<='z') and (tempbool=false) then
        begin
         Result.ansifn[i]:=Char(Byte('A')+Byte((str+i-1)^)-Byte('a'));
        end
       else if(tempbool) and ((str+i-1)^<=#127) then
        begin
         Result.ansiext[i-j]:=Char((str+i-1)^);
        end
       else if((str+i-1)^<=#127) then
        begin
         Result.ansifn[i]:=Char((str+i-1)^);
        end
       else if(tempbool) then
        begin
         Result.ansiext[i-j]:='_';
        end
       else
        begin
         Result.ansifn[i]:='_';
        end;
       inc(i);
      end;
    end;
  end;
 {If the long directory exists,Reverse it}
 if(Result.unicodefncount>0) then
  begin
   i:=1;
   while(i<=Result.unicodefncount shr 1)do
    begin
     tempfn:=(Result.unicodefn+i-1)^;
     (Result.unicodefn+i-1)^:=(Result.unicodefn+Result.unicodefncount-i)^;
     (Result.unicodefn+Result.unicodefncount-i)^:=tempfn;
     inc(i);
    end;
  end;
 {Output the full Result}
 fat_PwideCharToFatString:=Result;
end;
function fat_FatStringToPWideChar(const str:fat_string):PWideChar;
var i,j,len:SizeUint;
    Result:PWideChar;
begin
 Result:=allocmem(sizeof(WideChar)); len:=0;
 if(str.unicodefncount>0) then
  begin
   i:=str.unicodefncount;
   while(i>0)do
    begin
     j:=1;
     while(j<=5)do
      begin
       if((str.unicodefn+i-1)^.fn1[j]=#0) then break;
       inc(len);
       ReallocMem(Result,sizeof(WideChar)*(len+1));
       (Result+len-1)^:=(str.unicodefn+i-1)^.fn1[j];
       inc(j);
      end;
     if(j<=5) then
      begin
       dec(i); continue;
      end;
     j:=1;
     while(j<=6)do
      begin
       if((str.unicodefn+i-1)^.fn2[j]=#0) then break;
       inc(len);
       ReallocMem(Result,sizeof(WideChar)*(len+1));
       (Result+len-1)^:=(str.unicodefn+i-1)^.fn2[j];
       inc(j);
      end;
     if(j<=6) then
      begin
       dec(i); continue;
      end;
     j:=1;
     while(j<=2)do
      begin
       if((str.unicodefn+i-1)^.fn3[j]=#0) then break;
       inc(len);
       ReallocMem(Result,sizeof(WideChar)*(len+1));
       (Result+len-1)^:=(str.unicodefn+i-1)^.fn3[j];
       inc(j);
      end;
     if(j<=2) then
      begin
       dec(i); continue;
      end;
     dec(i);
    end;
   (Result+len)^:=#0;
  end
 else
  begin
   for i:=1 to 8 do
    begin
     if(str.ansifn[i]<=' ') and (str.ansifn[i]<>#$5) then break
     else if(str.ansifn[i]=#$5) then
      begin
       inc(len);
       ReallocMem(Result,sizeof(WideChar)*(len+1));
       (Result+len-1)^:=#$E5;
      end
     else
      begin
       inc(len);
       ReallocMem(Result,sizeof(WideChar)*(len+1));
       (Result+len-1)^:=str.ansifn[i];
      end;
    end;
   if(str.ansiext[1]>' ') then
    begin
     inc(len);
     ReallocMem(Result,sizeof(WideChar)*(len+1));
     (Result+len-1)^:='.';
    end;
   for i:=1 to 3 do
    begin
     if(str.ansiext[i]<=' ') then break
     else
      begin
       inc(len);
       ReallocMem(Result,sizeof(WideChar)*(len+1));
       (Result+len-1)^:=str.ansiext[i];
      end;
    end;
   (Result+len)^:=#0;
  end;
 fat_FatStringToPWideChar:=Result;
end;
procedure fat_MoveDirStructStringToFatString(const source:fat_directory_structure;
var dest:fat_string);
begin
 Move(source.directoryname[1],dest.ansifn[1],8);
 Move(source.directoryext[1],dest.ansiext[1],3);
end;
procedure fat_MoveLongDirStructStringToFatString(const source:fat_long_directory_structure;
var dest:fat_string;index:SizeUint);
begin
 if(index>Dest.unicodefncount) then exit;
 Move(source.longdirectoryname1[1],(dest.unicodefn+index-1)^.fn1[1],10);
 Move(source.longdirectoryname2[1],(dest.unicodefn+index-1)^.fn2[1],12);
 Move(source.longdirectoryname3[1],(dest.unicodefn+index-1)^.fn3[1],14);
end;
procedure fat_MovefatStringToDirStruct(const Source:fat_string;
var Dest:fat_directory_structure);
begin
 Move(Source.ansifn[1],Dest.directoryname[1],8);
 Move(Source.ansiext[1],Dest.directoryext[1],3);
end;
procedure fat_MovefatStringToLongDirStruct(const Source:fat_String;const index:SizeUint;
var Dest:fat_long_directory_structure);
begin
 if(index>Source.unicodefncount) then exit;
 Move((Source.unicodefn+index-1)^.fn1[1],Dest.longdirectoryname1[1],10);
 Move((Source.unicodefn+index-1)^.fn2[1],Dest.longdirectoryname2[1],12);
 Move((Source.unicodefn+index-1)^.fn3[1],Dest.longdirectoryname3[1],4);
end;
function fat_FatStringToFatDirectory(const Source:fat_string;FileAttr:byte;
date:fat_date;time:fat_time;FileSize:SizeUint;ClusterPos:dword):fat_directory;
var i:SizeUint;
    res:fat_directory;
begin
 {Move the Source's Short Directory Information to FAT directory structure}
 res.longdir:=nil;
 fat_MovefatStringToDirStruct(Source,res.dir);
 res.dir.directoryreserved1:=0;
 res.dir.directoryfilecreationdate:=date;
 res.dir.directoryfilecreationtime:=time;
 res.dir.directoryfilecreationtimetenthofsecond:=time.ElapsedSeconds shl 1 div 10;
 res.dir.directorylastaccessdate:=date;
 res.dir.directorywritedate:=date;
 res.dir.directorywritetime:=time;
 res.dir.directoryfirstclusterhighword:=ClusterPos shr 16;
 res.dir.directoryfirstclusterlowword:=ClusterPos shl 16 shr 16;
 if(FileAttr and fat_directory_file=fat_directory_file) then
  begin
   res.dir.directoryattribute:=fat_attribute_archive;
   res.dir.directoryfilesize:=FileSize;
  end
 else if(FileAttr and fat_directory_directory=fat_directory_directory) then
  begin
   res.dir.directoryattribute:=fat_attribute_directory;
   res.dir.directoryfilesize:=0;
  end
 else if(FileAttr and fat_directory_volume=fat_directory_volume) then
  begin
   res.dir.directoryattribute:=fat_attribute_volume_id;
   res.dir.directoryfilesize:=0;
   res.dir.directoryfirstclusterhighword:=0;
   res.dir.directoryfirstclusterlowword:=0;
  end;
 {If the long directory exists,
  Move the Source's Long Directory Infomation to FAT directory structure}
 i:=1; res.longdircount:=0;
 while(i<=Source.unicodefncount)do
  begin
   inc(res.longdircount);
   ReallocMem(res.longdir,sizeof(fat_long_directory_structure)*res.longdircount);
   fat_MovefatStringToLongDirStruct(Source,i,(res.longdir+res.longdircount-1)^);
   (res.longdir+res.longdircount-1)^.longdirectoryfirstclusterlowword:=0;
   (res.longdir+res.longdircount-1)^.longdirectoryattr:=fat_attribute_long_name;
   if(i=1) then
   (res.longdir+res.longdircount-1)^.longdirectoryorder:=
   (Source.unicodefncount-i+1) or fat_attribute_last_long_entry
   else
   (res.longdir+res.longdircount-1)^.longdirectoryorder:=$01;
   (res.longdir+res.longdircount-1)^.longdirectorychecksum:=fat_generate_checksum(res.dir);
   (res.longdir+res.longdircount-1)^.longdirectorytype:=0;
   inc(i);
  end;
 fat_FatStringToFatDirectory:=res;
end;
function fat_get_file_class(attr:byte;islong:boolean):byte;
begin
 if(islong) then
  begin
   if(attr and fat_attribute_directory=fat_attribute_directory) then
   fat_get_file_class:=fat_directory_directory or fat_directory_long
   else if(attr and fat_attribute_volume_id=fat_attribute_volume_id) then
   fat_get_file_class:=fat_directory_volume or fat_directory_long
   else
   fat_get_file_class:=fat_directory_file or fat_directory_long;
  end
 else
  begin
   if(attr and fat_attribute_directory=fat_attribute_directory) then
   fat_get_file_class:=fat_directory_directory
   else if(attr and fat_attribute_volume_id=fat_attribute_volume_id) then
   fat_get_file_class:=fat_directory_volume
   else
   fat_get_file_class:=fat_directory_file;
  end;
end;

end.

