unit genfsbase;

interface

{$mode ObjFPC}

uses Classes,SysUtils,fsbase;

const genfs_var_byte=0;
      genfs_var_word=1;
      genfs_var_dword=2;
      genfs_var_qword=3;
      genfs_var_smallint=4;
      genfs_var_shortint=5;
      genfs_var_integer=6;
      genfs_var_int64=7;

type Integer=-$7FFFFFFF..$7FFFFFFF;
     genfs_variant=packed record
                   vartype:byte;
                   case Byte of
                   0:(genfs_byte:byte;);
                   1:(genfs_word:word;);
                   2:(genfs_dword:dword;);
                   3:(genfs_qword:qword;);
                   4:(genfs_smallint:smallint;);
                   5:(genfs_shortint:shortint;);
                   6:(genfs_integer:integer;);
                   7:(genfs_int64:int64;);
                   end;
     genfs_fat=packed record
               header:fat_header;
               entrystart:SizeUint;
               entrycount:SizeUint;
               datastart:SizeUint;
               end;
     genfs_fat32=packed record
                 header:fat32_header;
                 fsinfo:fat_fsinfo_structure;
                 entrystart:SizeUint;
                 entrycount:SizeUint;
                 datastart:SizeUint;
                 end;
     genfs_exfat=packed record

                 end;
     genfs_ntfs=packed record

                end;
     genfs_ext2=packed record

                end;
     genfs_ext3=packed record

                end;
     genfs_ext4=packed record

                end;
     genfs_btrfs=packed record

                 end;
     genfs_filesystem=packed record
                      linkfilename:Unicodestring;
                      fsname:byte;
                      case Byte of
                      0:(fat12:genfs_fat;);
                      1:(fat16:genfs_fat;);
                      2:(fat32:genfs_fat32;);
                      3:(exfat:genfs_exfat;);
                      4:(ntfs:genfs_ntfs;);
                      5:(ext2:genfs_ext2;);
                      6:(ext3:genfs_ext3;);
                      7:(ext4:genfs_ext4;);
                      8:(btrfs:genfs_btrfs;);
                      end;
     genfs_path=packed record
                IsFile:array of Boolean;
                FilePath:array of Unicodestring;
                count:SizeUint;
                end;
     genfs_inner_path=packed record
                      FileClass:array of byte;
                      FilePath:array of UnicodeString;
                      FileMainPos:array of SizeUint;
                      FileSubPos:array of SizeUint;
                      {For FAT File System Only}
                      FileShortStr:array of string;
                      {For FAT32 File System Only}
                      FileStructSize:array of SizeUint;
                      {For FAT File System Only}
                      FilePrevNextCount:SizeUint;
                      Count:SizeUint;
                      end;
     genfs_path_string=packed record
                       path:array of UnicodeString;
                       count:SizeUint;
                       end;
     genfs_fat_cluster_list=packed record
                            index:array of SizeUint;
                            count:SizeUint;
                            end;
     genfs_fat_position_info=packed record
                             MainPos:SizeUint;
                             SubPos:SizeUint;
                             end;
     genfs_fat_position_info_list=packed record
                                  item:array of genfs_fat_position_info;
                                  size:array of SizeUint;
                                  count:SizeUint;
                                  end;
     genfs_content=packed record
                   content:array[1..512] of byte;
                   size:word;
                   end;
     genfs_file=packed record
                {For FAT Filesystem Only}
                FATMainPos,FATSubPos:SizeUint;
                FATNextCluster:SizeUint;
                end;

function StringToUnicodeString(str:string):UnicodeString;
operator := (x:byte)res:genfs_variant;
operator := (x:word)res:genfs_variant;
operator := (x:dword)res:genfs_variant;
operator := (x:qword)res:genfs_variant;
operator := (x:smallint)res:genfs_variant;
operator := (x:shortint)res:genfs_variant;
operator := (x:Integer)res:genfs_variant;
operator := (x:Int64)res:genfs_variant;
function genfs_filesystem_create(fn:UnicodeString;fstype:byte;Size:SizeUint;param:array of genfs_variant):genfs_filesystem;
function genfs_filesystem_read(fn:UnicodeString):genfs_filesystem;
procedure genfs_filesystem_add(var fs:genfs_filesystem;srcdir:UnicodeString;destdir:UnicodeString);
procedure genfs_filesystem_copy(var fs:genfs_filesystem;srcdir:UnicodeString;destdir:UnicodeString);
procedure genfs_filesystem_delete(var fs:genfs_filesystem;deldir:UnicodeString;erase:boolean=false);
procedure genfs_filesystem_extract(fs:genfs_filesystem;indir,extdir:UnicodeString);
procedure genfs_filesystem_free(var fs:genfs_filesystem);
procedure genfs_filesystem_copy_to_external(var fs:genfs_filesystem;srcdir,destdir:UnicodeString);
procedure genfs_filesystem_copy_from_external(var fs:genfs_filesystem;destdir,srcdir:UnicodeString);
procedure genfs_filesystem_move(var fs:genfs_filesystem;srcdir,destdir:UnicodeString);
procedure genfs_filesystem_move_to_external(var fs:genfs_filesystem;srcdir,destdir:UnicodeString);
procedure genfs_filesystem_move_from_external(var fs:genfs_filesystem;destdir,srcdir:UnicodeString);
procedure genfs_filesystem_replace(var fs:genfs_filesystem;srcdir,repdir:UnicodeString);
procedure genfs_filesystem_replace_to_external(var fs:genfs_filesystem;srcdir,repdir:UnicodeString);
procedure genfs_filesystem_replace_from_external(var fs:genfs_filesystem;repdir,srcdir:UnicodeString);
procedure genfs_filesystem_copy(var fs1:genfs_filesystem;
var fs2:genfs_filesystem;srcdir,destdir:UnicodeString);
procedure genfs_filesystem_replace(fs1:genfs_filesystem;
var fs2:genfs_filesystem;srcdir,destdir:UnicodeString);
procedure genfs_filesystem_move(var fs1:genfs_filesystem;
var fs2:genfs_filesystem;srcdir,destdir:UnicodeString);
procedure genfs_filesystem_image_copy(fs:genfs_filesystem;fn:UnicodeString);
procedure genfs_filesystem_image_move(fs:genfs_filesystem;fn:UnicodeString);
procedure genfs_filesystem_image_replace(fs:genfs_filesystem;fn:UnicodeString);

implementation

{For UnicodeString To PWideChar}
function UnicodeStringToPWideChar(str:UnicodeString):PWideChar;
var i:SizeUint;
begin
 Result:=allocmem(sizeof(WideChar)*(length(str)+1));
 i:=1;
 while(i<=length(str))do
  begin
   (Result+i-1)^:=str[i];
   inc(i);
  end;
end;
{For String To UnicodeString}
function StringToUnicodeString(str:string):UnicodeString;
var i:SizeUint;
begin
 Result:='';
 SetLength(Result,length(str));
 for i:=1 to length(str) do Result[i]:=str[i];
end;
{For UnicodeString To String}
function UnicodeStringToString(str:Unicodestring):String;
var i,len:SizeUint;
    tempnum,ii1,ii2:Word;
begin
 len:=0;
 for i:=1 to length(str) do
  begin
   inc(len);
   SetLength(Result,len);
   if(str[i]>#127) then
    begin
     inc(len);
     SetLength(Result,len);
     tempnum:=Word(str[i]);
     ii1:=tempnum shr 8;
     ii2:=tempnum shl 8 shr 8;
     Result[len]:=Char(ii1);
     Result[len-1]:=Char(ii2);
    end
   else if(str[i]<=#127) then
    begin
     Result[len]:=str[i];
    end;
  end;
end;
{For Data Translation}
operator := (x:byte)res:genfs_variant;
begin
 res.vartype:=genfs_var_byte;
 res.genfs_byte:=x;
end;
operator := (x:word)res:genfs_variant;
begin
 res.vartype:=genfs_var_word;
 res.genfs_word:=x;
end;
operator := (x:dword)res:genfs_variant;
begin
 res.vartype:=genfs_var_dword;
 res.genfs_dword:=x;
end;
operator := (x:qword)res:genfs_variant;
begin
 res.vartype:=genfs_var_qword;
 res.genfs_qword:=x;
end;
operator := (x:smallint)res:genfs_variant;
begin
 res.vartype:=genfs_var_smallint;
 res.genfs_smallint:=x;
end;
operator := (x:shortint)res:genfs_variant;
begin
 res.vartype:=genfs_var_shortint;
 res.genfs_shortint:=x;
end;
operator := (x:Integer)res:genfs_variant;
begin
 res.vartype:=genfs_var_integer;
 res.genfs_integer:=x;
end;
operator := (x:Int64)res:genfs_variant;
begin
 res.vartype:=genfs_var_int64;
 res.genfs_int64:=x;
end;
{Total Size is in Bytes,the program will translate all other unit such as KiB to the B}
function genfs_create_empty_image(fn:UnicodeString;TotalSize:SizeUint):genfs_filesystem;
var content:array[1..1024] of dword;
    f:TFileStream;
    i:SizeUint;
begin
 for i:=1 to 1024 do content[i]:=0;
 f:=TFileStream.Create(UnicodeStringToString(fn),fmCreate);
 f.Seek(0,0);
 for i:=1 to TotalSize shr 12 do f.Write(content,4096);
 f.Free;
 Result.linkfilename:=fn;
end;
{Get the size of image}
function genfs_get_image_size(fs:genfs_filesystem):SizeUint;
var f:TFileStream;
begin
 f:=TFileStream.Create(UnicodeStringToString(fs.linkfilename),fmOpenWrite);
 Result:=f.Size;
 f.Free;
end;
{Delete the image}
procedure genfs_delete_image(fs:genfs_filesystem);
begin
 DeleteFile(fs.linkfilename);
end;
{Reset the image}
procedure genfs_clear_image(fs:genfs_filesystem);
var content:array[1..1024] of dword;
    f:TFileStream;
    i:SizeUint;
begin
 for i:=1 to 1024 do content[i]:=0;
 f:=TFileStream.Create(UnicodeStringToString(fs.linkfilename),fmOpenWrite);
 f.Seek(0,0);
 for i:=1 to f.Size shr 12 do f.Write(content,4096);
 f.Free;
end;
{Standard I/O writing}
procedure genfs_io_write(fs:genfs_filesystem;const source;offset:SizeUint;Size:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(Size=0) then exit;
 if(FileExists(fs.linkfilename)) then
 f:=TFileStream.Create(UnicodeStringToString(fs.linkfilename),fmOpenWrite)
 else
 f:=TFileStream.Create(UnicodeStringToString(fs.linkfilename),fmCreate);
 f.Seek(offset,0);
 for i:=1 to Size do
  begin
   f.Write(PByte(@Source+i-1)^,1);
  end;
 f.Free;
end;
{Standard I/O reading}
procedure genfs_io_read(fs:genfs_filesystem;var dest;offset:SizeUint;Size:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(Size=0) then exit;
 f:=TFileStream.Create(UnicodeStringToString(fs.linkfilename),fmOpenRead);
 f.Seek(offset,0);
 for i:=1 to Size do
  begin
   if(offset+i-1>f.Size) then
   PByte(@dest+i-1)^:=0
   else
   f.Read(PByte(@dest+i-1)^,1);
  end;
 f.free;
end;
{Standard I/O Moving}
procedure genfs_io_move(fs:genfs_filesystem;startoffset:SizeUint;endoffset:SizeUint;MoveSize:SizeUint);
var f:TFileStream;
    i:SizeUint;
    iobyte:byte=0;
begin
 if(MoveSize=0) then exit;
 if(FileExists(fs.linkfilename)) then
 f:=TFileStream.Create(UnicodeStringToString(fs.linkfilename),fmOpenReadWrite)
 else
 f:=TFileStream.Create(UnicodeStringToString(fs.linkfilename),fmCreate);
 for i:=1 to MoveSize do
  begin
   if(startoffset+i-1>f.Size) then
    begin
     f.Seek(endoffset+i-1,0);
     iobyte:=0;
     f.Write(iobyte,1);
    end
   else
    begin
     f.Seek(startoffset+i-1,0);
     f.Read(iobyte,1);
     f.Seek(endoffset+i-1,0);
     f.Write(iobyte,1);
     iobyte:=0;
     f.Seek(startoffset+i-1,0);
     f.Write(iobyte,1);
    end;
  end;
 f.free;
end;
{Standard external I/O Reading}
procedure genfs_external_io_read(fn:UnicodeString;var dest;offset:SizeUint;Size:SizeUint);
var f:TFileStream;
    i:SizeInt;
begin
 if(Size=0) then exit;
 f:=TFileStream.Create(UnicodeStringToString(fn),fmOpenRead);
 f.Seek(offset,0);
 for i:=1 to Size do
  begin
   f.Read(PByte(@dest+i-1)^,1);
  end;
 f.free;
end;
{Standard external I/O Writing}
procedure genfs_external_io_write(fn:UnicodeString;const src;offset:SizeUint;Size:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(Size=0) then exit;
 if(FileExists(fn)) then
 f:=TFileStream.Create(UnicodeStringToString(fn),fmOpenWrite)
 else
 f:=TFileStream.Create(UnicodeStringToString(fn),fmCreate);
 f.Seek(offset,0);
 for i:=1 to Size do
  begin
   f.Write(PByte(@src+i-1)^,1);
  end;
 f.free;
end;
{Standard external Size}
function genfs_external_file_Size(fn:UnicodeString):SizeUint;
var f:TFileStream;
begin
 f:=TFileStream.Create(UnicodeStringToString(fn),fmOpenRead);
 Result:=f.Size;
 f.free;
end;
{Standard Get File Path without file name}
function genfs_extract_file_path(fp:UnicodeString):UnicodeString;
var i,len:SizeUint;
begin
 len:=length(fp); i:=len;
 while(i>0)do
  begin
   if(fp[i]='/') or (fp[i]='\') then break;
   dec(i);
  end;
 Result:=Copy(fp,1,i-1);
end;
{Standard Get File Name with extension}
function genfs_extract_file_name(fn:UnicodeString):UnicodeString;
var i,len:SizeUint;
begin
 len:=length(fn); i:=len;
 while(i>0)do
  begin
   if(fn[i]='/') or (fn[i]='\') then break;
   dec(i);
  end;
 Result:=Copy(fn,i+1,len-i);
end;
{Standard Vaildate Vaild File Name}
function genfs_check_file_name(fn:UnicodeString):boolean;
var tempstr:UnicodeString;
    i,len:SizeUint;
begin
 tempstr:=genfs_extract_file_name(fn); i:=1; len:=length(tempstr);
 while(i<=len)do
  begin
   if(tempstr[i]='.') then break;
   inc(i);
  end;
 if(i<=len) then Result:=true else Result:=false;
end;
{Standard initializion}
procedure genfs_filesystem_initialize(var dest);
var i:SizeUint;
begin
 for i:=sizeof(Unicodestring)+sizeof(Byte)+1 to sizeof(genfs_filesystem) do PByte(@dest+i-1)^:=0;
end;
{Standard File System Checker}
function genfs_filesystem_get_type(fs:genfs_filesystem):byte;
var regblock:array[1..512] of char;
    f:TFileStream;
begin
 f:=TFileStream.Create(UnicodeStringToString(fs.linkfilename),fmOpenRead);
 f.Seek(0,0);
 f.Read(regblock,512);
 if(regblock[$37]='F') and (regblock[$38]='A') and (regblock[$39]='T') then
  begin
   if(regblock[$40]='1') and (regblock[$41]='2') then Result:=filesystem_fat12
   else if(regblock[$40]='1') and (regblock[$41]='6') then Result:=filesystem_fat16
   else
    begin
     writeln('ERROR:Unrecognize FAT16 or FAT16 file system.');
     readln;
     abort;
    end;
  end
 else if(regblock[$53]='F') and (regblock[$54]='A') and (regblock[$55]='T')
 and (regblock[$56]='3') and (regblock[$57]='2') then
  begin
   Result:=filesystem_fat32;
  end
 else if(regblock[$4]='E') and (regblock[$54]='X') and (regblock[$55]='F')
 and (regblock[$7]='A') and (regblock[$8]='T') then
  begin
   Result:=filesystem_exfat;
  end
 else if(regblock[$4]='N') and (regblock[$54]='T') and (regblock[$55]='F')
 and (regblock[$7]='S') then
  begin
   Result:=filesystem_ntfs;
  end
 else if(Pword(@regblock[$39])^=$EF53) then
  begin
   if(Pword(@regblock[$65])^=$0) then
   Result:=filesystem_ext2
   else if(Pword(@regblock[$65])^=$0004) then
   Result:=filesystem_ext3
   else if(Pword(@regblock[$65])^=$1000) then
   Result:=filesystem_ext4;
  end
 else if(regblock[$41]='_') and (regblock[$42]='B') and (regblock[$43]='H')
 and (regblock[$44]='R') and (regblock[$45]='f') and (regblock[$46]='S')
 and (regblock[$47]='_') and (regblock[$48]='M') then
  begin
   Result:=filesystem_btrfs;
  end
 else
  begin
   writeln('ERROR:Unrecognized file system.');
   readln;
   abort;
  end;
 f.Free;
end;
{FAT File System Volume Id Calculator}
function genfs_date_to_fat_date:fat_date;
var year,month,day:word;
begin
 DecodeDate(Now,year,month,day);
 Result.CountOfYear:=year-1980;
 Result.DayOfMonth:=day;
 Result.MonthOfYear:=month;
end;
function genfs_time_to_fat_time:fat_time;
var hour,minute,second,millisecond:word;
begin
 DecodeTime(Now,hour,minute,second,millisecond);
 Result.ElapsedSeconds:=second shl 1;
 Result.Hours:=hour;
 Result.Minutes:=minute;
end;
function genfs_generate_volume_id:dword;
begin
 Result:=Pword(@genfs_date_to_fat_date)^ shl 16+Pword(@genfs_time_to_fat_time)^;
end;
{FAT Extract Short File Name}
function genfs_fat_extract_short_name(struct:fat_directory_structure):string;
var i:SizeInt;
begin
 Result:='';
 for i:=1 to 8 do
  begin
   if(struct.directoryname[i]<=' ') then break;
   Result:=Result+struct.directoryname[i];
  end;
 if(struct.directoryext[1]>' ') then
  begin
   Result:=Result+'.';
   for i:=1 to 3 do
    begin
     if(struct.directoryext[i]<=' ') then break;
     Result:=Result+struct.directoryext[i];
    end;
  end;
end;
{File System Infomation Write}
procedure genfs_filesystem_write_info(fs:genfs_filesystem);
var tempnum1,tempnum2,tempnum3,tempnum4:SizeUint;
begin
 if(fs.fsname=filesystem_fat12) then
  begin
   tempnum1:=fs.fat12.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat12.header.head.bpb_SectorPerCluster;
   genfs_io_write(fs,fs.fat12.header,0,sizeof(fat_header));
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   tempnum1:=fs.fat16.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat16.header.head.bpb_SectorPerCluster;
   genfs_io_write(fs,fs.fat16.header,0,sizeof(fat_header));
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   tempnum1:=fs.fat32.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat32.header.head.bpb_SectorPerCluster;
   tempnum3:=fs.fat32.header.exthead.bpb_filesysteminfo;
   tempnum4:=fs.fat32.header.exthead.bpb_backupBootSector;
   genfs_io_write(fs,fs.fat32.header,0,sizeof(fat32_header));
   genfs_io_write(fs,fs.fat32.fsinfo,tempnum3*tempnum1*tempnum2,sizeof(fat_fsinfo_structure));
   genfs_io_write(fs,fs.fat32.header,tempnum4*tempnum1*tempnum2,sizeof(fat32_header));
  end
 else if(fs.fsname=filesystem_exfat) then
  begin

  end
 else if(fs.fsname=filesystem_ntfs) then
  begin

  end
 else if(fs.fsname=filesystem_ext2) then
  begin

  end
 else if(fs.fsname=filesystem_ext3) then
  begin

  end
 else if(fs.fsname=filesystem_ext4) then
  begin

  end
 else if(fs.fsname=filesystem_btrfs) then
  begin

  end
 else
  begin

  end;
end;
{FAT Read Entry Value}
function genfs_fat_read_entry(fs:genfs_filesystem;position:SizeUint):fat_entry;
var pairpos,pairindex:SizeUint;
    tempnum1,tempnum2:SizeUint;
    entrypair,comparepair:fat_entry_pair;
begin
 pairpos:=position shr 1; pairindex:=position mod 2;
 if(fs.fsname=filesystem_fat12) then
  begin
   tempnum1:=fs.fat12.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat12.header.head.bpb_FatSectorCount16;
   genfs_io_read(fs,entrypair.entry12,fs.fat12.entrystart
   +pairpos*sizeof(fat12_entry_pair),sizeof(fat12_entry_pair));
   genfs_io_read(fs,comparepair.entry12,fs.fat12.entrystart
   +tempnum1*tempnum2+pairpos*sizeof(fat12_entry_pair),sizeof(fat12_entry_pair));
   if(comparepair.entry12.entry1<>entrypair.entry12.entry1)or
   (comparepair.entry12.entry2<>entrypair.entry12.entry2)then
   entrypair.entry12:=comparepair.entry12;
   if(pairindex=0) then
   Result.entry12:=entrypair.entry12.entry1
   else
   Result.entry12:=entrypair.entry12.entry2;
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   tempnum1:=fs.fat16.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat16.header.head.bpb_FatSectorCount16;
   genfs_io_read(fs,entrypair.entry16,fs.fat16.entrystart
   +pairpos*sizeof(fat16_entry_pair),sizeof(fat16_entry_pair));
   genfs_io_read(fs,comparepair.entry16,fs.fat16.entrystart
   +tempnum1*tempnum2+pairpos*sizeof(fat16_entry_pair),sizeof(fat16_entry_pair));
   if(comparepair.entry16[pairindex+1]<>entrypair.entry16[pairindex+1])then
   entrypair.entry16:=comparepair.entry16;
   Result.entry16:=entrypair.entry16[pairindex+1];
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   tempnum1:=fs.fat32.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat32.header.exthead.bpb_FatSectorCount32;
   genfs_io_read(fs,entrypair.entry32,fs.fat32.entrystart
   +pairpos*sizeof(fat32_entry_pair),sizeof(fat32_entry_pair));
   genfs_io_read(fs,comparepair.entry32,fs.fat32.entrystart
   +tempnum1*tempnum2+pairpos*sizeof(fat32_entry_pair),sizeof(fat32_entry_pair));
   if(comparepair.entry32[pairindex+1]<>entrypair.entry32[pairindex+1])then
   entrypair.entry32:=comparepair.entry32;
   Result.entry32:=entrypair.entry32[pairindex+1];
  end
 else
  begin
   Result.entry32:=0;
  end;
end;
{FAT Write Entry Value}
procedure genfs_fat_write_entry(fs:genfs_filesystem;entry:fat_entry;position:SizeUint);
var pairpos,pairindex:SizeUint;
    tempentrypair:fat_entry_pair;
    tempnum1,tempnum2:SizeUint;
begin
 pairpos:=position shr 1; pairindex:=position mod 2;
 if(fs.fsname=filesystem_fat12) then
  begin
   tempnum1:=fs.fat12.header.head.bpb_FatSectorCount16;
   tempnum2:=fs.fat12.header.head.bpb_bytesPerSector;
   genfs_io_read(fs,tempentrypair,fs.fat12.entrystart
   +pairpos*sizeof(fat12_entry_pair),sizeof(fat12_entry_pair));
   if(pairindex=0) then
   tempentrypair.entry12.entry1:=entry.entry12
   else
   tempentrypair.entry12.entry2:=entry.entry12;
   genfs_io_write(fs,tempentrypair,fs.fat12.entrystart
   +pairpos*sizeof(fat12_entry_pair),sizeof(fat12_entry_pair));
   genfs_io_write(fs,tempentrypair,fs.fat12.entrystart
   +tempnum1*tempnum2+pairpos*sizeof(fat12_entry_pair),sizeof(fat12_entry_pair));
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   tempnum1:=fs.fat16.header.head.bpb_FatSectorCount16;
   tempnum2:=fs.fat16.header.head.bpb_bytesPerSector;
   genfs_io_read(fs,tempentrypair,fs.fat16.entrystart
   +pairpos*sizeof(fat16_entry_pair),sizeof(fat16_entry_pair));
   tempentrypair.entry16[pairindex+1]:=entry.entry16;
   genfs_io_write(fs,tempentrypair,fs.fat16.entrystart
   +pairpos*sizeof(fat16_entry_pair),sizeof(fat16_entry_pair));
   genfs_io_write(fs,tempentrypair,fs.fat16.entrystart
   +tempnum1*tempnum2+pairpos*sizeof(fat16_entry_pair),sizeof(fat16_entry_pair));
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   tempnum1:=fs.fat32.header.exthead.bpb_FatSectorCount32;
   tempnum2:=fs.fat32.header.head.bpb_bytesPerSector;
   genfs_io_read(fs,tempentrypair,fs.fat32.entrystart
   +pairpos*sizeof(fat32_entry_pair),sizeof(fat32_entry_pair));
   tempentrypair.entry32[pairindex+1]:=entry.entry32;
   genfs_io_write(fs,tempentrypair,fs.fat32.entrystart
   +pairpos*sizeof(fat32_entry_pair),sizeof(fat32_entry_pair));
   genfs_io_write(fs,tempentrypair,fs.fat32.entrystart
   +tempnum1*tempnum2+pairpos*sizeof(fat32_entry_pair),sizeof(fat32_entry_pair));
  end;
end;
{File System Read}
function genfs_filesystem_read(fn:UnicodeString):genfs_filesystem;
var tempnum1,tempnum2,tempnum3:SizeUint;
begin
 {Confirm the linked file name}
 Result.linkfilename:=fn;
 {Confirm the file system type}
 Result.fsname:=genfs_filesystem_get_type(Result);
 {File System Specified Reading}
 if(Result.fsname=filesystem_fat12) then
  begin
   genfs_io_read(Result,Result.fat12.header,0,sizeof(fat_header));
   tempnum1:=Result.fat12.header.head.bpb_bytesPerSector;
   tempnum2:=Result.fat12.header.head.bpb_ReservedSectorCount;
   tempnum3:=Result.fat12.header.head.bpb_FatSectorCount16;
   Result.fat12.entrystart:=tempnum1*tempnum2;
   Result.fat12.datastart:=tempnum1*(tempnum2+tempnum3*2);
   Result.fat12.entrycount:=tempnum1*tempnum3 div 3;
  end
 else if(Result.fsname=filesystem_fat16) then
  begin
   genfs_io_read(Result,Result.fat16.header,0,sizeof(fat_header));
   tempnum1:=Result.fat16.header.head.bpb_bytesPerSector;
   tempnum2:=Result.fat16.header.head.bpb_ReservedSectorCount;
   tempnum3:=Result.fat16.header.head.bpb_FatSectorCount16;
   Result.fat16.entrystart:=tempnum1*tempnum2;
   Result.fat16.datastart:=tempnum1*(tempnum2+tempnum3*2);
   Result.fat16.entrycount:=tempnum1*tempnum3 shr 2;
  end
 else if(Result.fsname=filesystem_fat32) then
  begin
   genfs_io_read(Result,Result.fat32.header,0,sizeof(fat32_header));
   if(Result.fat32.header.head.bpb_jumpboot[1]<>fat_bpb_jumpboot[1])
   or(Result.fat32.header.head.bpb_jumpboot[2]<>fat_bpb_jumpboot[2])
   or(Result.fat32.header.head.bpb_jumpboot[3]<>fat_bpb_jumpboot[3]) then
    begin
     genfs_io_read(Result,Result.fat32.header,
     Result.fat32.header.head.bpb_bytesPerSector*Result.fat32.header.exthead.bpb_backupBootSector,
     sizeof(fat32_header));
     genfs_io_write(Result,Result.fat32.header,0,sizeof(fat32_header));
    end;
   genfs_io_read(Result,Result.fat32.fsinfo,
   Result.fat32.header.head.bpb_bytesPerSector*Result.fat32.header.exthead.bpb_filesysteminfo,
   sizeof(fat_fsinfo_structure));
   tempnum1:=Result.fat32.header.head.bpb_bytesPerSector;
   tempnum2:=Result.fat32.header.head.bpb_ReservedSectorCount;
   tempnum3:=Result.fat32.header.exthead.bpb_FatSectorCount32;
   Result.fat32.entrystart:=tempnum1*tempnum2;
   Result.fat32.datastart:=tempnum1*(tempnum2+tempnum3*2);
   Result.fat32.entrycount:=tempnum1*tempnum3 shr 3;
  end
 else if(Result.fsname=filesystem_exfat) then
  begin

  end
 else
  begin

  end;
end;
{File System create}
function genfs_filesystem_create(fn:UnicodeString;fstype:byte;Size:SizeUint;param:array of genfs_variant):genfs_filesystem;
{For FAT FileSystem Only}
var entrypair:fat_entry_pair;
begin
 {Pass the genfs's corresponding file name in disk}
 Result.linkfilename:=fn;
 {Initialize the file}
 genfs_create_empty_image(Result.linkfilename,Size shl 20);
 {Specify the genfs file system type}
 Result.fsname:=fstype;
 {Initialize the genfs filesystem record}
 genfs_filesystem_initialize(Result);
 {Initialize the genfs specific filesystem}
 if(fstype=filesystem_fat12) then
  begin
   {Need parameter:BytePerSector,SectorPerCluster,ReservedSectorCount,FATSectorCount16}
   Result.fat12.header.head.bpb_bytesPerSector:=param[0].genfs_word;
   Result.fat12.header.head.bpb_SectorPerCluster:=param[1].genfs_byte;
   Result.fat12.header.head.bpb_ReservedSectorCount:=param[2].genfs_word;
   Result.fat12.header.head.bpb_FatSectorCount16:=param[3].genfs_word;
   Result.fat12.header.head.bpb_TotalSector16:=Size shl 20 div param[0].genfs_word;
   Result.fat12.header.head.bpb_TotalSector32:=0;
   {Other universal parameters}
   fat_jump_boot_move(Result.fat12.header.head.bpb_jumpboot);
   fat_oem_name_move(Result.fat12.header.head.bpb_oemname);
   Result.fat12.header.head.bpb_RootEntryCount:=512;
   Result.fat12.header.head.bpb_media:=$F8;
   Result.fat12.header.head.bpb_NumberOfFATS:=2;
   Result.fat12.header.head.bpb_SectorsPerTrack:=2;
   Result.fat12.header.head.bpb_NumberOfHeads:=8;
   Result.fat12.header.head.bpb_HiddenSector:=0;
   {FAT12 extended header initalization}
   Result.fat12.header.exthead.bs_bootsig:=$29;
   Result.fat12.header.exthead.bs_driver_number:=$80;
   Result.fat12.header.exthead.bs_volume_id:=genfs_generate_volume_id;
   fat_default_volume_label_move(Result.fat12.header.exthead.bs_volume_label);
   fat_default_file_system_type_move(12,Result.fat12.header.exthead.bs_filesystem_type);
   Result.fat12.header.exthead.bs_signature:=$AA55;
   {FAT12 entry initialization}
   Result.fat12.entrystart:=param[2].genfs_word*param[0].genfs_word;
   Result.fat12.entrycount:=param[3].genfs_word*param[0].genfs_word div 3;
   entrypair.entry12.entry1:=$FF8; entrypair.entry12.entry2:=$C00;
   genfs_io_write(Result,entrypair.entry12,Result.fat12.entrystart,sizeof(fat12_entry_pair));
   genfs_io_write(Result,entrypair.entry12,Result.fat12.entrystart
   +param[3].genfs_word*param[0].genfs_word,sizeof(fat12_entry_pair));
   {FAT12 data position initialization}
   Result.fat12.datastart:=param[0].genfs_word*(param[2].genfs_word+param[3].genfs_word*2);
  end
 else if(fstype=filesystem_fat16) then
  begin
   {Need parameter:BytePerSector,SectorPerCluster,ReservedSectorCount,FATSectorCount16}
   Result.fat16.header.head.bpb_bytesPerSector:=param[0].genfs_word;
   Result.fat16.header.head.bpb_SectorPerCluster:=param[1].genfs_byte;
   Result.fat16.header.head.bpb_ReservedSectorCount:=param[2].genfs_word;
   Result.fat16.header.head.bpb_FatSectorCount16:=param[3].genfs_word;
   Result.fat16.header.head.bpb_TotalSector16:=Size shl 20 div param[0].genfs_word;
   Result.fat16.header.head.bpb_TotalSector32:=0;
   {Other universal parameters}
   fat_jump_boot_move(Result.fat16.header.head.bpb_jumpboot);
   fat_oem_name_move(Result.fat16.header.head.bpb_oemname);
   Result.fat16.header.head.bpb_RootEntryCount:=512;
   Result.fat16.header.head.bpb_media:=$F8;
   Result.fat16.header.head.bpb_NumberOfFATS:=2;
   Result.fat16.header.head.bpb_SectorsPerTrack:=2;
   Result.fat16.header.head.bpb_NumberOfHeads:=8;
   Result.fat16.header.head.bpb_HiddenSector:=0;
   {FAT16 extended header initalization}
   Result.fat16.header.exthead.bs_bootsig:=$29;
   Result.fat16.header.exthead.bs_driver_number:=$80;
   Result.fat16.header.exthead.bs_volume_id:=genfs_generate_volume_id;
   fat_default_volume_label_move(Result.fat16.header.exthead.bs_volume_label);
   fat_default_file_system_type_move(16,Result.fat16.header.exthead.bs_filesystem_type);
   Result.fat16.header.exthead.bs_signature:=$AA55;
   {FAT16 entry initialization}
   Result.fat16.entrystart:=param[2].genfs_word*param[0].genfs_word;
   Result.fat16.entrycount:=param[3].genfs_word*param[0].genfs_word shr 2;
   entrypair.entry16[1]:=$FFF8; entrypair.entry16[2]:=$C000;
   genfs_io_write(Result,entrypair.entry16,Result.fat16.entrystart,sizeof(fat16_entry_pair));
   genfs_io_write(Result,entrypair.entry16,Result.fat16.entrystart
   +param[3].genfs_word*param[0].genfs_word,sizeof(fat16_entry_pair));
   {FAT16 data position initialization}
   Result.fat16.datastart:=param[0].genfs_word*(param[2].genfs_word+param[3].genfs_word*2);
  end
 else if(fstype=filesystem_fat32) then
  begin
   {Need paramater:BytesPerSector,SectorPerCluster,ReservedSectorCount,
   FATSector32,BackupBootSector,FileSystemInfo,RootCluster}
   Result.fat32.header.head.bpb_bytesPerSector:=param[0].genfs_word;
   Result.fat32.header.head.bpb_SectorPerCluster:=param[1].genfs_byte;
   Result.fat32.header.head.bpb_ReservedSectorCount:=param[2].genfs_word;
   Result.fat32.header.head.bpb_FatSectorCount16:=0;
   Result.fat32.header.exthead.bpb_FatSectorCount32:=param[3].genfs_dword;
   Result.fat32.header.head.bpb_TotalSector32:=Size shl 20 div param[0].genfs_word;
   Result.fat32.header.exthead.bpb_backupBootSector:=param[4].genfs_word;
   Result.fat32.header.exthead.bpb_filesysteminfo:=param[5].genfs_word;
   Result.fat32.header.exthead.bpb_rootcluster:=param[6].genfs_dword;
   {Other universial parameters}
   fat_jump_boot_move(Result.fat32.header.head.bpb_jumpboot);
   fat_oem_name_move(Result.fat32.header.head.bpb_oemname);
   Result.fat32.header.head.bpb_RootEntryCount:=0;
   Result.fat32.header.head.bpb_media:=$F8;
   Result.fat32.header.head.bpb_NumberOfFATS:=2;
   Result.fat32.header.head.bpb_SectorsPerTrack:=2;
   Result.fat32.header.head.bpb_NumberOfHeads:=8;
   Result.fat32.header.head.bpb_HiddenSector:=0;
   {FAT32 extended header initialization}
   Result.fat32.header.exthead.bs_bootsig:=$29;
   Result.fat32.header.exthead.bs_driver_number:=$80;
   Result.fat32.header.exthead.bs_volume_id:=genfs_generate_volume_id;
   fat_default_volume_label_move(Result.fat32.header.exthead.bs_volume_label);
   fat_default_file_system_type_move(32,Result.fat32.header.exthead.bs_filesystem_type);
   Result.fat32.header.exthead.bs_signature:=$AA55;
   Result.fat32.header.exthead.bpb_ExtendedFlags.FATmirrordisable:=0;
   Result.fat32.header.exthead.bpb_ExtendedFlags.NumberOfActiveFAT:=0;
   {FAT32 entry initialization}
   entrypair.entry32[1]:=$FFFFFF8; entrypair.entry32[2]:=$C000000;
   Result.fat32.entrystart:=param[2].genfs_word*param[0].genfs_word;
   Result.fat32.entrycount:=param[3].genfs_word*param[0].genfs_word shr 3;
   genfs_io_write(Result,entrypair.entry32,Result.fat32.entrystart,sizeof(fat32_entry_pair));
   genfs_io_write(Result,entrypair.entry32,Result.fat32.entrystart
   +param[3].genfs_word*param[0].genfs_word,sizeof(fat32_entry_pair));
   {FAT32 data position initialization}
   Result.fat32.datastart:=param[0].genfs_word*(param[2].genfs_word+param[3].genfs_word*2);
   {FAT32 file system info initialization}
   Result.fat32.fsinfo.leadsignature:=fat32_lead_signature;
   Result.fat32.fsinfo.structsignature:=fat32_struct_signature;
   Result.fat32.fsinfo.trailsignature:=fat32_trail_signature;
   Result.fat32.fsinfo.nextfree:=2;
   Result.fat32.fsinfo.freecount:=
   (Size shl 20 div param[0].genfs_word-2*param[3].genfs_dword-param[2].genfs_word)
   div (param[0].genfs_word*param[1].genfs_byte);
  end
 else
  begin

  end;
 genfs_filesystem_write_info(Result);
end;
{File System Free}
procedure genfs_filesystem_free(var fs:genfs_filesystem);
begin
 if(fs.fsname=filesystem_fat12) then
  begin
   fs.fsname:=$FF; fs.fat12.entrycount:=0;
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   fs.fsname:=$FF; fs.fat16.entrycount:=0;
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   fs.fsname:=$FF; fs.fat32.entrycount:=0;
  end
 else
  begin

  end;
end;
{Mask match for GenFs program}
function genfs_is_mask(detectstr:UnicodeString):boolean;
var i,len:SizeUint;
begin
 i:=1; len:=length(detectstr);
 while(i<=len) do
  begin
   if(detectstr[i]='?') or (detectstr[i]='*') then break;
   inc(i);
  end;
 if(i<=len) then Result:=true else Result:=false;
end;
function genfs_mask_match(mask:UnicodeString;detectstr:UnicodeString):boolean;
var i,j,len1,len2:SizeUint;
begin
 i:=1; j:=1; len1:=length(mask); len2:=length(detectstr);
 while(i<=len1) and (j<=len2) do
  begin
   if(mask[i]='*') then
    begin
     if(i<len1) and (mask[i+1]='*') then
      begin
       inc(i);
      end
     else if(i<len1) and (mask[i+1]='?') then
      begin
       inc(i);
      end
     else if(detectstr[j]<>#0) and (mask[i+1]=detectstr[j]) then
      begin
       inc(i); inc(j);
      end
     else inc(j);
    end
   else if(mask[i]='?') then
    begin
     if(detectstr[j]<>#0) then
      begin
       inc(i); inc(j);
      end
     else break;
    end
   else
    begin
     if(mask[i]=detectstr[j]) then
      begin
       inc(i); inc(j);
      end
     else break;
    end;
  end;
 if(j>len2) then Result:=true else Result:=false;
end;
{External File System detection}
function genfs_external_search_for_path(basedir:UnicodeString):genfs_path;
var SearchRec:TUnicodeSearchRec;
    Order:Longint;
    bool:boolean;
    tempstr:UnicodeString;
    temppath:genfs_path;
    i:SizeUint;
    ismask:boolean;
begin
 ismask:=genfs_is_mask(basedir);
 Result.count:=0; Order:=0; bool:=false;
 if(FileExists(basedir)) then
  begin
   inc(Result.count);
   SetLength(Result.FilePath,Result.count);
   SetLength(Result.IsFile,Result.count);
   Result.FilePath[Result.count-1]:=basedir;
   Result.IsFile[Result.count-1]:=true;
  end;
 repeat
  begin
   if(bool=false) and (ismask=false) then
   Order:=FindFirst(basedir+'/*',faDirectory,SearchRec)
   else if(bool=false) and (ismask) then
   Order:=FindFirst(basedir,faDirectory,SearchRec)
   else Order:=FindNext(SearchRec);
   bool:=true;
   if(DirectoryExists(basedir+'/'+SearchRec.Name)=false) then break;
   if(SearchRec.Name='..') or (SearchRec.Name='.') then continue;
   if(Order<>0) then break;
   tempstr:=BaseDir+'/'+SearchRec.Name;
   inc(Result.count);
   SetLength(Result.FilePath,Result.count);
   SetLength(Result.IsFile,Result.count);
   Result.FilePath[Result.count-1]:=tempstr;
   Result.IsFile[Result.count-1]:=false;
   temppath:=genfs_external_search_for_path(tempstr);
   for i:=1 to temppath.count do
    begin
     inc(Result.count);
     SetLength(Result.FilePath,Result.count);
     SetLength(Result.IsFile,Result.count);
     Result.FilePath[Result.count-1]:=temppath.FilePath[i-1];
     Result.IsFile[Result.count-1]:=temppath.IsFile[i-1];
    end;
  end
 until (Order<>0);
 FindClose(SearchRec);
 bool:=false; Order:=0;
 repeat
  begin
   if(bool=false) and (ismask=false) then
   Order:=FindFirst(basedir+'/*',faAnyFile,SearchRec)
   else if(bool=false) and (ismask) then
   Order:=FindFirst(basedir,faAnyFile,SearchRec)
   else Order:=FindNext(SearchRec);
   bool:=true;
   if(FileExists(basedir+'/'+SearchRec.Name)) then continue;
   if(SearchRec.Name='..') or (SearchRec.Name='.') then continue;
   if(SearchRec.Attr and faDirectory=faDirectory) then continue;
   if(Order<>0) then break;
   inc(Result.count);
   tempstr:=basedir+'/'+SearchRec.Name;
   SetLength(Result.FilePath,Result.count);
   SetLength(Result.IsFile,Result.count);
   Result.FilePath[Result.count-1]:=tempstr;
   Result.IsFile[Result.count-1]:=true;
  end
 until (Order<>0);
 FindClose(SearchRec);
end;
{GenFs File Path Prefix}
function genfs_check_prefix(prevpath,nextpath:UnicodeString;isnextdir:Boolean=false):boolean;
var i,len,len2:SizeUint;
begin
 if(length(prevpath)>=length(nextpath)) then
  begin
   genfs_check_prefix:=false;
  end
 else
  begin
   len:=length(prevpath); len2:=length(nextpath); i:=1;
   while(i<=len)do
    begin
     if(prevpath[i]<>nextpath[i]) then break;
     inc(i);
    end;
   inc(i,1);
   while(i<=len2) and (isnextdir) do
    begin
     if(nextpath[i]='/') or (nextpath[i]='\') then break;
     if(i=len+1) and (Copy(nextpath,i,2)='..') or (Copy(nextpath,i,1)='.') then break;
     inc(i);
    end;
   if(i>len) and (isnextdir=false) then genfs_check_prefix:=true
   else if(i>len2) and (isnextdir) then genfs_check_prefix:=true
   else genfs_check_prefix:=false;
  end;
end;
{GenFs check the file is in the same path}
function genfs_check_same_path(path1,path2:UnicodeString):boolean;
var i,j,len1,len2:SizeUInt;
begin
 len1:=length(path1); i:=len1;
 while(i>1) and (path1[i]<>'/') and (path1[i]<>'\') do dec(i);
 len2:=length(path2); j:=len2;
 while(j>1) and (path2[j]<>'/') and (path2[j]<>'\') do dec(j);
 if(Copy(path1,1,i-1)=Copy(path2,1,j-1)) then Result:=true else Result:=false;
end;
{File System Path Translation}
function genfs_path_to_path_string(path:Unicodestring;isfat:boolean=true):genfs_path_string;
var i:SizeUint;
    tempstr:Unicodestring;
    temppwchar:PWideChar;
begin
 i:=1; tempstr:=path;
 Result.count:=0; SetLength(Result.path,1);
 while(length(tempstr)>0)do
  begin
   if(tempstr[i]='/') or (tempstr[i]='\') then
    begin
     if(i>1) then
      begin
       inc(Result.count);
       SetLength(Result.path,Result.count);
       if(isfat) then
        begin
         temppwchar:=UnicodeStringToPWideChar(Copy(tempstr,1,i-1));
         if(fat_PWideCharIsLongFileName(temppwchar)) then
         Result.path[Result.count-1]:=UpperCase(Copy(tempstr,1,i-1))
         else Result.path[Result.count-1]:=Copy(tempstr,1,i-1);
         FreeMem(temppwchar);
        end
       else
        begin
         Result.path[Result.count-1]:=Copy(tempstr,1,i-1);
        end;
      end;
     Delete(tempstr,1,i); i:=1; continue;
    end
   else if(i>length(tempstr)) then
    begin
     inc(Result.count);
     SetLength(Result.path,Result.count);
     if(isfat) then
      begin
       temppwchar:=UnicodeStringToPWideChar(Copy(tempstr,1,i-1));
       if(fat_PWideCharIsLongFileName(temppwchar)) then
       Result.path[Result.count-1]:=UpperCase(Copy(tempstr,1,i-1))
       else Result.path[Result.count-1]:=Copy(tempstr,1,i-1);
       FreeMem(temppwchar);
      end
     else
      begin
       Result.path[Result.count-1]:=Copy(tempstr,1,i-1);
      end;
     Delete(tempstr,1,i);
    end;
   inc(i);
  end;
end;
{File System Search Path without wildchar}
function genfs_extract_search_path_without_wildcard(path:UnicodeString):UnicodeString;
var i,j,len:SizeUint;
begin
 if(genfs_is_mask(path)) then
  begin
   i:=1; len:=length(path);
   while(i<=len)do
    begin
     if(path[i]='*') or (path[i]='?') then break;
     inc(i);
    end;
   j:=i;
   while(j>0)do
    begin
     if(path[j]='/') or (path[j]='\') then break;
     dec(j);
    end;
   Result:=Copy(path,1,j-1);
  end
 else
  begin
   Result:=path;
  end;
end;
{File System Search}
function genfs_filesystem_search_for_path(const fs:genfs_filesystem;
inputbasedir:UnicodeString='/';startpos:SizeUint=0):genfs_inner_path;
var i:SizeUint;
    SearchMainPos,SearchSubPos:SizeUint;
    temppath:genfs_inner_path;
    tempdirpos:SizeUint;
    temppathstr:genfs_path_string;
    temppathstrindex:SizeUint;
    BaseDir:UnicodeString;
    IsMask:boolean;
{For FAT File System}
    clustervalue:fat_entry;
    fatstr:fat_string;
    tempstr:PWideChar;
    BytePerSector,SectorPerCluster:SizeUint;
    unitcontent:array[1..32] of byte;
{For FAT32 Only}
    RootCluster:SizeUint;
    recindex:SizeUint;
    StartIndex:SizeUint;
    StartOffset:SizeUint;
begin
 {Check the InputBaseDir is masked or not}
 ismask:=genfs_is_mask(inputBaseDir);
 if(ismask) then BaseDir:=genfs_extract_search_path_without_wildcard(inputBaseDir)
 else BaseDir:=inputBaseDir;
 {Initialize the Result.}
 Result.Count:=0; Result.FilePrevNextCount:=0;
 SetLength(Result.FileClass,1); SetLength(Result.FilePath,1);
 SetLength(Result.FileMainPos,1); SetLength(Result.FileSubPos,1);
 SetLength(Result.FileShortStr,1); SetLength(Result.FileStructSize,1);
 fatstr.unicodefn:=nil; fatstr.unicodefncount:=0;
 for i:=1 to 32 do unitcontent[i]:=0;
 if(fs.fsname=filesystem_fat12) then
  begin
   {Regain the FAT12 Information}
   BytePerSector:=fs.fat12.header.head.bpb_bytesPerSector;
   SectorPerCluster:=fs.fat12.header.head.bpb_SectorPerCluster;
   if(startpos>2) or (basedir='/') or (basedir='\') then
    begin
     if(startpos>2) then
      begin
       {Indicate the Search Pos is a recursion from root directory}
       SearchMainPos:=startpos; SearchSubPos:=0;
      end
     else
      begin
       {Indicate the Search Pos is on the root directory}
       SearchMainPos:=2; SearchSubPos:=0;
      end;
     while(True)do
      begin
       genfs_io_read(fs,unitcontent,fs.fat12.datastart+(SearchMainPos-2)
       *BytePerSector*SectorPerCluster+
       SearchSubPos shl 5,sizeof(fat_directory_structure));
       inc(SearchSubPos);
       if(unitcontent[1]=$00) then
        begin
         {Indicate the Directory is ended,exit the search.}
         break;
        end
       else if(unitcontent[1]<>$E5) and (unitcontent[12]<>fat_attribute_long_name) then
        begin
         inc(Result.Count);
         {Files in FAT12 File System are always short name,Record it.}
         SetLength(Result.FileShortStr,Result.Count);
         Result.FileShortStr[Result.count-1]:=
         genfs_fat_extract_short_name(Pfat_directory_structure(@unitcontent)^);
         {Record the File Class of Files}
         SetLength(Result.FileClass,Result.Count);
         Result.FileClass[Result.count-1]:=
         fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false);
         {Record the File Full Path}
         SetLength(Result.FilePath,Result.count);
         fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
         tempstr:=fat_FatStringToPWideChar(fatstr);
         if(basedir='\') or (basedir='/') then
         Result.FilePath[Result.count-1]:=basedir+tempstr
         else
         Result.FilePath[Result.count-1]:=basedir+'/'+tempstr;
         {Record the File Main Position(in cluster) and Sub Position(in number of
         fat_directory_structure)}
         SetLength(Result.FileMainPos,Result.count);
         Result.FileMainPos[Result.count-1]:=SearchMainPos;
         SetLength(Result.FileSubPos,Result.count);
         Result.FileSubPos[Result.count-1]:=SearchSubPos-1;
         if(UnicodeString(tempstr)='.') and (UnicodeString(tempstr)='..') then
         inc(Result.FilePrevNextCount);
         {If the file is directory,then search for this directory}
         if(UnicodeString(tempstr)<>'.') and (UnicodeString(tempstr)<>'..') and
         (Result.FileClass[Result.count-1]=fat_directory_directory) then
          begin
           {Confirm the position of Directory Content(in cluster}
           tempdirpos:=Pfat_directory_structure(@unitcontent)^.directoryfirstclusterhighword shl 16+
           Pfat_directory_structure(@unitcontent)^.directoryfirstclusterlowword;
           temppath:=genfs_filesystem_search_for_path(fs,
           Result.FilePath[Result.count-1],tempdirpos);
           {Insert the temppath's content to main Result}
           for i:=1 to temppath.Count do
            begin
             inc(Result.count);
             SetLength(Result.FilePath,Result.count);
             Result.FilePath[Result.count-1]:=temppath.FilePath[i-1];
             SetLength(Result.FileShortStr,Result.count);
             Result.FileShortStr[Result.count-1]:=temppath.FileShortStr[i-1];
             SetLength(Result.FileMainPos,Result.count);
             Result.FileMainPos[Result.count-1]:=temppath.FileMainPos[i-1];
             SetLength(Result.FileSubPos,Result.count);
             Result.FileSubPos[Result.count-1]:=temppath.FileSubPos[i-1];
             SetLength(Result.FileClass,Result.count);
             Result.FileClass[Result.count-1]:=temppath.FileClass[i-1];
            end;
           {Release the memory of variable temppath}
           SetLength(temppath.FilePath,0);
           SetLength(temppath.FileShortStr,0);
           SetLength(temppath.FileMainPos,0);
           SetLength(temppath.FileSubPos,0);
           SetLength(temppath.FileClass,0);
          end;
         FreeMem(tempstr);
        end;
       {If the read offset is on the boundary of the cluster,go to next cluster or search ended.}
       if(SearchSubPos=BytePerSector*SectorPerCluster shr 5) then
        begin
         clustervalue:=genfs_fat_read_entry(fs,SearchMainPos);
         if(fat12_check_cluster_status(clustervalue.entry12)=fat_end)
         or(fat12_check_cluster_status(clustervalue.entry12)=fat_cluster_broken)then
          begin
           break;
          end
         else if(fat12_check_cluster_status(clustervalue.entry12)<>fat_end)
         and(fat12_check_cluster_status(clustervalue.entry12)<>fat_cluster_broken)then
          begin
           SearchMainPos:=clustervalue.entry12;
           SearchSubPos:=0;
          end;
        end;
      end;
    end
   else if(startpos<=2) then
    begin
     {Indicate the basedir is not root directory or recurse from root directory.}
     SearchMainPos:=2; SearchSubPos:=0;
     temppathstrindex:=1; temppathstr:=genfs_path_to_path_string(basedir);
     {Go to the basedir pointed directory.}
     while(True)do
      begin
       genfs_io_read(fs,unitcontent,fs.fat12.datastart+(SearchMainPos-2)*
       BytePerSector*SectorPerCluster+SearchSubPos shl 5,
       sizeof(fat_directory_structure));
       inc(SearchSubPos);
       if(unitcontent[1]=$00) then
        begin
         break;
        end
       else if(unitcontent[1]<>$E5) and (unitcontent[12]<>fat_attribute_long_name) then
        begin
         fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
         tempstr:=fat_FatStringToPWideChar(fatstr);
         if(UnicodeString(tempstr)<>'.') and (UnicodeString(tempstr)<>'..') and
         (temppathstr.path[temppathstrindex-1]=tempstr)
         and(fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false)
         =fat_directory_directory) then
          begin
           SearchMainPos:=Pfat_directory_structure(@unitcontent)^.directoryfirstclusterhighword shl 16+
           Pfat_directory_structure(@unitcontent)^.directoryfirstclusterlowword;
           SearchSubPos:=0;
           inc(temppathstrindex);
          end
         else if(temppathstr.path[temppathstrindex-1]=tempstr)
         and(fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false)
         =fat_directory_file) and (temppathstrindex=temppathstr.count) then
          begin
           inc(Result.Count);
           {Files in FAT12 File System are always short name,Record it.}
           SetLength(Result.FileShortStr,Result.Count);
           Result.FileShortStr[Result.count-1]:=
           genfs_fat_extract_short_name(Pfat_directory_structure(@unitcontent)^);
           {Record the File Class of Files}
           SetLength(Result.FileClass,Result.Count);
           Result.FileClass[Result.count-1]:=
           fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false);
           {Record the File Full Path}
           SetLength(Result.FilePath,Result.count);
           fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
           tempstr:=fat_FatStringToPWideChar(fatstr);
           Result.FilePath[Result.count-1]:=basedir;
           FreeMem(tempstr);
           {Record the File Main Position(in cluster) and Sub Position(in number of
           fat_directory_structure)}
           SetLength(Result.FileMainPos,Result.count);
           Result.FileMainPos[Result.count-1]:=SearchMainPos;
           SetLength(Result.FileSubPos,Result.count);
           Result.FileSubPos[Result.count-1]:=SearchSubPos;
           break;
          end;
         FreeMem(tempstr);
        end;
       if(SearchSubPos=BytePerSector*SectorPerCluster shr 5) then
        begin
         clustervalue:=genfs_fat_read_entry(fs,SearchMainPos);
         if(fat12_check_cluster_status(clustervalue.entry12)=fat_end)
         or(fat12_check_cluster_status(clustervalue.entry12)=fat_cluster_broken)then
          begin
           break;
          end
         else if(fat12_check_cluster_status(clustervalue.entry12)<>fat_end)
         and(fat12_check_cluster_status(clustervalue.entry12)<>fat_cluster_broken)then
          begin
           SearchMainPos:=clustervalue.entry12;
           SearchSubPos:=0;
          end;
        end;
      end;
     if(temppathstrindex<=temppath.Count) then exit(Result);
     {Then Search into the basedir pointed directory.}
     while(True)do
      begin
       genfs_io_read(fs,unitcontent,fs.fat12.datastart+(SearchMainPos-2)
       *BytePerSector*SectorPerCluster+
       SearchSubPos shl 5,sizeof(fat_directory_structure));
       inc(SearchSubPos);
       if(unitcontent[1]=$00) then
        begin
         {Indicate the Directory is ended,exit the search.}
         break;
        end
       else if(unitcontent[1]<>$E5) and (unitcontent[12]<>fat_attribute_long_name) then
        begin
         inc(Result.Count);
         {Files in FAT12 File System are always short name,Record it.}
         SetLength(Result.FileShortStr,Result.Count);
         Result.FileShortStr[Result.count-1]:=
         genfs_fat_extract_short_name(Pfat_directory_structure(@unitcontent)^);
         {Record the File Class of Files}
         SetLength(Result.FileClass,Result.Count);
         Result.FileClass[Result.count-1]:=
         fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false);
         {Record the File Full Path}
         SetLength(Result.FilePath,Result.count);
         fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
         tempstr:=fat_FatStringToPWideChar(fatstr);
         Result.FilePath[Result.count-1]:=basedir+'/'+tempstr;
         {Record the File Main Position(in cluster) and Sub Position(in number of
         fat_directory_structure)}
         SetLength(Result.FileMainPos,Result.count);
         Result.FileMainPos[Result.count-1]:=SearchMainPos;
         SetLength(Result.FileSubPos,Result.count);
         Result.FileSubPos[Result.count-1]:=SearchSubPos-1;
         {If the file is directory,then search for this directory}
         if(UnicodeString(tempstr)='.') and (UnicodeString(tempstr)='..') then
         inc(Result.FilePrevNextCount);
         if(UnicodeString(tempstr)<>'.') and (UnicodeString(tempstr)<>'..') and
         (Result.FileClass[Result.count-1]=fat_directory_directory) then
          begin
           {Confirm the position of Directory Content(in cluster}
           tempdirpos:=Pfat_directory_structure(@unitcontent)^.directoryfirstclusterhighword shl 16+
           Pfat_directory_structure(@unitcontent)^.directoryfirstclusterlowword;
           temppath:=genfs_filesystem_search_for_path(fs,
           Result.FilePath[Result.count-1],tempdirpos);
           {Insert the temppath's content to main Result}
           for i:=1 to temppath.Count do
            begin
             inc(Result.count);
             SetLength(Result.FilePath,Result.count);
             Result.FilePath[Result.count-1]:=temppath.FilePath[i-1];
             SetLength(Result.FileShortStr,Result.count);
             Result.FileShortStr[Result.count-1]:=temppath.FileShortStr[i-1];
             SetLength(Result.FileMainPos,Result.count);
             Result.FileMainPos[Result.count-1]:=temppath.FileMainPos[i-1];
             SetLength(Result.FileSubPos,Result.count);
             Result.FileSubPos[Result.count-1]:=temppath.FileSubPos[i-1];
             SetLength(Result.FileClass,Result.count);
             Result.FileClass[Result.count-1]:=temppath.FileClass[i-1];
            end;
           {Release the memory of variable temppath}
           SetLength(temppath.FilePath,0);
           SetLength(temppath.FileShortStr,0);
           SetLength(temppath.FileMainPos,0);
           SetLength(temppath.FileSubPos,0);
           SetLength(temppath.FileClass,0);
          end;
         FreeMem(tempstr);
        end;
       {If the read offset is on the boundary of the cluster,go to next cluster or search ended.}
       if(SearchSubPos=BytePerSector*SectorPerCluster shr 5) then
        begin
         clustervalue:=genfs_fat_read_entry(fs,SearchMainPos);
         if(fat12_check_cluster_status(clustervalue.entry12)=fat_end)
         or(fat12_check_cluster_status(clustervalue.entry12)=fat_cluster_broken)then
          begin
           break;
          end
         else if(fat12_check_cluster_status(clustervalue.entry12)<>fat_end)
         and(fat12_check_cluster_status(clustervalue.entry12)<>fat_cluster_broken)then
          begin
           SearchMainPos:=clustervalue.entry12;
           SearchSubPos:=0;
          end;
        end;
      end;
    end;
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   {Regain the FAT16 Information}
   BytePerSector:=fs.fat16.header.head.bpb_bytesPerSector;
   SectorPerCluster:=fs.fat16.header.head.bpb_SectorPerCluster;
   if(startpos>2) or (basedir='/') or (basedir='\') then
    begin
     if(startpos>2) then
      begin
       {Indicate the Search Pos is a recursion from root directory}
       SearchMainPos:=startpos; SearchSubPos:=0;
      end
     else
      begin
       {Indicate the Search Pos is on the root directory}
       SearchMainPos:=2; SearchSubPos:=0;
      end;
     while(True)do
      begin
       genfs_io_read(fs,unitcontent,fs.fat16.datastart+(SearchMainPos-2)
       *BytePerSector*SectorPerCluster+
       SearchSubPos shl 5,sizeof(fat_directory_structure));
       inc(SearchSubPos);
       if(unitcontent[1]=$00) then
        begin
         {Indicate the Directory is ended,exit the search.}
         break;
        end
       else if(unitcontent[1]<>$E5) and (unitcontent[16]<>fat_attribute_long_name) then
        begin
         inc(Result.Count);
         {Files in FAT16 File System are always short name,Record it.}
         SetLength(Result.FileShortStr,Result.Count);
         Result.FileShortStr[Result.count-1]:=
         genfs_fat_extract_short_name(Pfat_directory_structure(@unitcontent)^);
         {Record the File Class of Files}
         SetLength(Result.FileClass,Result.Count);
         Result.FileClass[Result.count-1]:=
         fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false);
         {Record the File Full Path}
         SetLength(Result.FilePath,Result.count);
         fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
         tempstr:=fat_FatStringToPWideChar(fatstr);
         if(basedir='\') or (basedir='/') then
         Result.FilePath[Result.count-1]:=basedir+tempstr
         else
         Result.FilePath[Result.count-1]:=basedir+'/'+tempstr;
         {Record the File Main Position(in cluster) and Sub Position(in number of
         fat_directory_structure)}
         SetLength(Result.FileMainPos,Result.count);
         Result.FileMainPos[Result.count-1]:=SearchMainPos;
         SetLength(Result.FileSubPos,Result.count);
         Result.FileSubPos[Result.count-1]:=SearchSubPos-1;
         {If the file is directory,then search for this directory}
         if(UnicodeString(tempstr)='.') and (UnicodeString(tempstr)='..') then
         inc(Result.FilePrevNextCount);
         if(UnicodeString(tempstr)<>'.') and (UnicodeString(tempstr)<>'..') and
         (Result.FileClass[Result.count-1]=fat_directory_directory) then
          begin
           {Confirm the position of Directory Content(in cluster}
           tempdirpos:=Pfat_directory_structure(@unitcontent)^.directoryfirstclusterhighword shl 16+
           Pfat_directory_structure(@unitcontent)^.directoryfirstclusterlowword;
           temppath:=genfs_filesystem_search_for_path(fs,
           Result.FilePath[Result.count-1],tempdirpos);
           {Insert the temppath's content to main Result}
           for i:=1 to temppath.Count do
            begin
             inc(Result.count);
             SetLength(Result.FilePath,Result.count);
             Result.FilePath[Result.count-1]:=temppath.FilePath[i-1];
             SetLength(Result.FileShortStr,Result.count);
             Result.FileShortStr[Result.count-1]:=temppath.FileShortStr[i-1];
             SetLength(Result.FileMainPos,Result.count);
             Result.FileMainPos[Result.count-1]:=temppath.FileMainPos[i-1];
             SetLength(Result.FileSubPos,Result.count);
             Result.FileSubPos[Result.count-1]:=temppath.FileSubPos[i-1];
             SetLength(Result.FileClass,Result.count);
             Result.FileClass[Result.count-1]:=temppath.FileClass[i-1];
            end;
           {Release the memory of variable temppath}
           SetLength(temppath.FilePath,0);
           SetLength(temppath.FileShortStr,0);
           SetLength(temppath.FileMainPos,0);
           SetLength(temppath.FileSubPos,0);
           SetLength(temppath.FileClass,0);
          end;
        end;
       FreeMem(tempstr);
       {If the read offset is on the boundary of the cluster,go to next cluster or search ended.}
       if(SearchSubPos=BytePerSector*SectorPerCluster shr 5) then
        begin
         clustervalue:=genfs_fat_read_entry(fs,SearchMainPos);
         if(fat16_check_cluster_status(clustervalue.entry16)=fat_end)
         or(fat16_check_cluster_status(clustervalue.entry16)=fat_cluster_broken)then
          begin
           break;
          end
         else if(fat16_check_cluster_status(clustervalue.entry16)<>fat_end)
         and(fat16_check_cluster_status(clustervalue.entry16)<>fat_cluster_broken)then
          begin
           SearchMainPos:=clustervalue.entry16;
           SearchSubPos:=0;
          end;
        end;
      end;
    end
   else if(startpos<=2) then
    begin
     {Indicate the basedir is not root directory or recurse from root directory.}
     SearchMainPos:=2; SearchSubPos:=0;
     temppathstrindex:=1; temppathstr:=genfs_path_to_path_string(basedir);
     {Go to the basedir pointed directory.}
     while(True)do
      begin
       genfs_io_read(fs,unitcontent,fs.fat16.datastart+(SearchMainPos-2)*
       BytePerSector*SectorPerCluster+SearchSubPos shl 5,
       sizeof(fat_directory_structure));
       inc(SearchSubPos);
       if(unitcontent[1]=$00) then
        begin
         break;
        end
       else if(unitcontent[1]<>$E5) and (unitcontent[16]<>fat_attribute_long_name) then
        begin
         fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
         tempstr:=fat_FatStringToPWideChar(fatstr);
         if(UnicodeString(tempstr)<>'.') and (UnicodeString(tempstr)<>'..') and
         (temppathstr.path[temppathstrindex-1]=tempstr)
         and(fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false)
         =fat_directory_directory) then
          begin
           SearchMainPos:=Pfat_directory_structure(@unitcontent)^.directoryfirstclusterhighword shl 16+
           Pfat_directory_structure(@unitcontent)^.directoryfirstclusterlowword;
           SearchSubPos:=0;
           inc(temppathstrindex);
          end
         else if(temppathstr.path[temppathstrindex-1]=tempstr)
         and(fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false)
         =fat_directory_file) and (temppathstrindex=temppathstr.count) then
          begin
           inc(Result.Count);
           {Files in FAT16 File System are always short name,Record it.}
           SetLength(Result.FileShortStr,Result.Count);
           Result.FileShortStr[Result.count-1]:=
           genfs_fat_extract_short_name(Pfat_directory_structure(@unitcontent)^);
           {Record the File Class of Files}
           SetLength(Result.FileClass,Result.Count);
           Result.FileClass[Result.count-1]:=
           fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false);
           {Record the File Full Path}
           SetLength(Result.FilePath,Result.count);
           fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
           tempstr:=fat_FatStringToPWideChar(fatstr);
           Result.FilePath[Result.count-1]:=basedir;
           FreeMem(tempstr);
           {Record the File Main Position(in cluster) and Sub Position(in number of
           fat_directory_structure)}
           SetLength(Result.FileMainPos,Result.count);
           Result.FileMainPos[Result.count-1]:=SearchMainPos;
           SetLength(Result.FileSubPos,Result.count);
           Result.FileSubPos[Result.count-1]:=SearchSubPos;
           break;
          end;
         FreeMem(tempstr);
        end;
       if(SearchSubPos=BytePerSector*SectorPerCluster shr 5) then
        begin
         clustervalue:=genfs_fat_read_entry(fs,SearchMainPos);
         if(fat16_check_cluster_status(clustervalue.entry16)=fat_end)
         or(fat16_check_cluster_status(clustervalue.entry16)=fat_cluster_broken)then
          begin
           break;
          end
         else if(fat16_check_cluster_status(clustervalue.entry16)<>fat_end)
         and(fat16_check_cluster_status(clustervalue.entry16)<>fat_cluster_broken)then
          begin
           SearchMainPos:=clustervalue.entry16;
           SearchSubPos:=0;
          end;
        end;
      end;
     if(temppathstrindex<=temppath.Count) then exit(Result);
     {Then Search into the basedir pointed directory.}
     while(True)do
      begin
       genfs_io_read(fs,unitcontent,fs.fat16.datastart+(SearchMainPos-2)
       *BytePerSector*SectorPerCluster+
       SearchSubPos shl 5,sizeof(fat_directory_structure));
       inc(SearchSubPos);
       if(unitcontent[1]=$00) then
        begin
         {Indicate the Directory is ended,exit the search.}
         break;
        end
       else if(unitcontent[1]<>$E5) and (unitcontent[16]<>fat_attribute_long_name) then
        begin
         inc(Result.Count);
         {Files in FAT16 File System are always short name,Record it.}
         SetLength(Result.FileShortStr,Result.Count);
         Result.FileShortStr[Result.count-1]:=
         genfs_fat_extract_short_name(Pfat_directory_structure(@unitcontent)^);
         {Record the File Class of Files}
         SetLength(Result.FileClass,Result.Count);
         Result.FileClass[Result.count-1]:=
         fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,false);
         {Record the File Full Path}
         SetLength(Result.FilePath,Result.count);
         fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
         tempstr:=fat_FatStringToPWideChar(fatstr);
         if(basedir='\') or (basedir='/') then
         Result.FilePath[Result.count-1]:=basedir+tempstr
         else
         Result.FilePath[Result.count-1]:=basedir+'/'+tempstr;
         {Record the File Main Position(in cluster) and Sub Position(in number of
         fat_directory_structure)}
         SetLength(Result.FileMainPos,Result.count);
         Result.FileMainPos[Result.count-1]:=SearchMainPos;
         SetLength(Result.FileSubPos,Result.count);
         Result.FileSubPos[Result.count-1]:=SearchSubPos-1;
         {If the file is directory,then search for this directory}
         if(UnicodeString(tempstr)='.') and (UnicodeString(tempstr)='..') then
         inc(Result.FilePrevNextCount);
         if(UnicodeString(tempstr)<>'.') and (UnicodeString(tempstr)<>'..') and
         (Result.FileClass[Result.count-1]=fat_directory_directory) then
          begin
           {Confirm the position of Directory Content(in cluster)}
           tempdirpos:=Pfat_directory_structure(@unitcontent)^.directoryfirstclusterhighword shl 16+
           Pfat_directory_structure(@unitcontent)^.directoryfirstclusterlowword;
           temppath:=genfs_filesystem_search_for_path(fs,
           Result.FilePath[Result.count-1],tempdirpos);
           {Insert the temppath's content to main Result}
           for i:=1 to temppath.Count do
            begin
             inc(Result.count);
             SetLength(Result.FilePath,Result.count);
             Result.FilePath[Result.count-1]:=temppath.FilePath[i-1];
             SetLength(Result.FileShortStr,Result.count);
             Result.FileShortStr[Result.count-1]:=temppath.FileShortStr[i-1];
             SetLength(Result.FileMainPos,Result.count);
             Result.FileMainPos[Result.count-1]:=temppath.FileMainPos[i-1];
             SetLength(Result.FileSubPos,Result.count);
             Result.FileSubPos[Result.count-1]:=temppath.FileSubPos[i-1];
             SetLength(Result.FileClass,Result.count);
             Result.FileClass[Result.count-1]:=temppath.FileClass[i-1];
            end;
           {Release the memory of variable temppath}
           SetLength(temppath.FilePath,0);
           SetLength(temppath.FileShortStr,0);
           SetLength(temppath.FileMainPos,0);
           SetLength(temppath.FileSubPos,0);
           SetLength(temppath.FileClass,0);
          end;
        end;
       FreeMem(tempstr);
       {If the read offset is on the boundary of the cluster,go to next cluster or search ended.}
       if(SearchSubPos=BytePerSector*SectorPerCluster shr 5) then
        begin
         clustervalue:=genfs_fat_read_entry(fs,SearchMainPos);
         if(fat16_check_cluster_status(clustervalue.entry16)=fat_end)
         or(fat16_check_cluster_status(clustervalue.entry16)=fat_cluster_broken)then
          begin
           break;
          end
         else if(fat16_check_cluster_status(clustervalue.entry16)<>fat_end)
         and(fat16_check_cluster_status(clustervalue.entry16)<>fat_cluster_broken)then
          begin
           SearchMainPos:=clustervalue.entry16;
           SearchSubPos:=0;
          end;
        end;
      end;
    end;
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   {Regain the FAT32 Information}
   BytePerSector:=fs.fat32.header.head.bpb_bytesPerSector;
   SectorPerCluster:=fs.fat32.header.head.bpb_SectorPerCluster;
   RootCluster:=fs.fat32.header.exthead.bpb_rootcluster; recindex:=0; startindex:=0;
   if((startpos>=2) and (startpos<>RootCluster)) or (Basedir='/') or (BaseDir='\') then
    begin
     if(startpos>=2) and (startpos<>RootCluster) then
      begin
       {Indicate it is recursive from root directory.}
       SearchMainPos:=startpos; SearchSubPos:=0;
      end
     else
      begin
       {Indicate it is root directory.}
       SearchMainPos:=RootCluster; SearchSubPos:=0;
      end;
     while(True)do
      begin
       genfs_io_read(fs,unitcontent,fs.fat32.datastart+(SearchMainPos-2)*
       BytePerSector*SectorPerCluster+SearchSubPos shl 5,
       sizeof(fat_directory_structure));
       inc(SearchSubPos);
       if(unitcontent[1]=$00) then
        begin
         {Indicate the Directory is ended.}
         break;
        end
       else if(unitcontent[12]=fat_attribute_long_name) then
        begin
         {Add the long directory structure item to Directory.}
         inc(fatstr.unicodefncount);
         ReallocMem(fatstr.unicodefn,sizeof(fat_long_directory_structure)*fatstr.unicodefncount);
         fat_MoveLongDirStructStringToFatString(Pfat_long_directory_structure(@unitcontent)^,
         fatstr,fatstr.unicodefncount);
         if(recindex=0) then
          begin
           startindex:=SearchMainPos; startoffset:=SearchSubPos;
          end;
         inc(recindex);
        end
       else if(unitcontent[12]<>fat_attribute_long_name) then
        begin
         inc(Result.count);
         {Files in FAT32 are always have short name,record it.}
         SetLength(Result.FileShortStr,Result.count);
         Result.FileShortStr[Result.count-1]:=
         genfs_fat_extract_short_name(Pfat_directory_structure(@unitcontent)^);
         {Record the File Class of File.}
         SetLength(Result.FileClass,Result.count);
         Result.FileClass[Result.count-1]:=
         fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,recindex>0);
         {Record the File Full Path}
         SetLength(Result.FilePath,Result.count);
         fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
         tempstr:=fat_FatStringToPWideChar(fatstr);
         if(basedir='\') or (basedir='/') then
         Result.FilePath[Result.count-1]:=basedir+tempstr
         else
         Result.FilePath[Result.count-1]:=basedir+'/'+tempstr;
         {Record the File Main Position(in cluster) and Sub Position(in number of
         fat_directory_structure)}
         SetLength(Result.FileMainPos,Result.count);
         SetLength(Result.FileSubPos,Result.count);
         if(startindex<>0) then
          begin
           Result.FileMainPos[Result.count-1]:=Startindex;
           Result.FileSubPos[Result.count-1]:=startoffset-1;
          end
         else
          begin
           Result.FileMainPos[Result.count-1]:=SearchMainPos;
           Result.FileSubPos[Result.count-1]:=SearchSubPos-1;
          end;
         {Record the File Directory's actual size}
         SetLength(Result.FileStructSize,Result.count);
         Result.FileStructSize[Result.count-1]:=recindex+1;
         {If the file is directory,then search into its content}
         if(UnicodeString(tempstr)='.') and (UnicodeString(tempstr)='..') then
         inc(Result.FilePrevNextCount);
         if(UnicodeString(tempstr)<>'.') and (UnicodeString(tempstr)<>'..') and
         (Result.FileClass[Result.count-1] and fat_directory_directory=fat_directory_directory) then
          begin
           {Confirm the position of Directory Content(in cluster)}
           tempdirpos:=Pfat_directory_structure(@unitcontent)^.directoryfirstclusterhighword shl 16+
           Pfat_directory_structure(@unitcontent)^.directoryfirstclusterlowword;
           temppath:=genfs_filesystem_search_for_path(fs,
           Result.FilePath[Result.count-1],tempdirpos);
           {Insert the temppath's content to main Result}
           for i:=1 to temppath.Count do
            begin
             inc(Result.count);
             SetLength(Result.FilePath,Result.count);
             Result.FilePath[Result.count-1]:=temppath.FilePath[i-1];
             SetLength(Result.FileShortStr,Result.count);
             Result.FileShortStr[Result.count-1]:=temppath.FileShortStr[i-1];
             SetLength(Result.FileMainPos,Result.count);
             Result.FileMainPos[Result.count-1]:=temppath.FileMainPos[i-1];
             SetLength(Result.FileSubPos,Result.count);
             Result.FileSubPos[Result.count-1]:=temppath.FileSubPos[i-1];
             SetLength(Result.FileClass,Result.count);
             Result.FileClass[Result.count-1]:=temppath.FileClass[i-1];
             SetLength(Result.FileStructSize,Result.count);
             Result.FileStructSize[Result.count-1]:=temppath.FileClass[i-1];
            end;
           {Release the memory of variable temppath}
           SetLength(temppath.FilePath,0);
           SetLength(temppath.FileShortStr,0);
           SetLength(temppath.FileMainPos,0);
           SetLength(temppath.FileSubPos,0);
           SetLength(temppath.FileClass,0);
           SetLength(temppath.FileStructSize,0);
          end;
         if(fatstr.unicodefncount>0) then
          begin
           FreeMem(fatstr.unicodefn); fatstr.unicodefn:=nil; fatstr.unicodefncount:=0;
          end;
         recindex:=0; startindex:=0; startoffset:=0;
         FreeMem(tempstr);
        end;
       {If the read offset is on the boundary of the cluster,go to next cluster or search ended.}
       if(SearchSubPos=BytePerSector*SectorPerCluster shr 5) then
        begin
         clustervalue:=genfs_fat_read_entry(fs,SearchMainPos);
         if(fat32_check_cluster_status(clustervalue.entry32)=fat_end)
         or(fat32_check_cluster_status(clustervalue.entry32)=fat_cluster_broken)then
          begin
           break;
          end
         else if(fat32_check_cluster_status(clustervalue.entry32)<>fat_end)
         and(fat32_check_cluster_status(clustervalue.entry32)<>fat_cluster_broken)then
          begin
           SearchMainPos:=clustervalue.entry32;
           SearchSubPos:=0;
          end;
        end;
      end;
    end
   else if(startpos<2) then
    begin
     {Indicate the basedir is not root directory or recurse from root directory.}
     SearchMainPos:=RootCluster; SearchSubPos:=0;
     temppathstrindex:=1; temppathstr:=genfs_path_to_path_string(basedir);
     {Go to the basedir pointed directory.}
     while(True)do
      begin
       genfs_io_read(fs,unitcontent,fs.fat32.datastart+(SearchMainPos-2)*
       BytePerSector*SectorPerCluster+SearchSubPos shl 5,
       sizeof(fat_directory_structure));
       inc(SearchSubPos);
       if(unitcontent[1]=$00) then
        begin
         {Indicate the Directory is ended.}
         break;
        end
       else if(unitcontent[12]=fat_attribute_long_name) then
        begin
         inc(fatstr.unicodefncount);
         ReallocMem(fatstr.unicodefn,sizeof(fat_long_directory_structure)*fatstr.unicodefncount);
         fat_MoveLongDirStructStringToFatString(Pfat_long_directory_structure(@unitcontent)^,
         fatstr,fatstr.unicodefncount);
         if(recindex=0) then
          begin
           startindex:=SearchMainPos; startoffset:=SearchSubPos;
          end;
         inc(recindex);
        end
       else if(unitcontent[12]<>fat_attribute_long_name) then
        begin
         fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
         tempstr:=fat_FatStringToPWideChar(fatstr);
         if(UnicodeString(tempstr)<>'.') and (UnicodeString(tempstr)<>'..') and
         (temppathstr.path[temppathstrindex-1]=tempstr) and
         (fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,recindex>0)
         and fat_directory_directory=fat_directory_directory) then
          begin
           SearchMainPos:=Pfat_directory_structure(@unitcontent)^.directoryfirstclusterhighword shl 16
           +Pfat_directory_structure(@unitcontent)^.directoryfirstclusterlowword;
           SearchSubPos:=0;
           if(recindex=0) then startindex:=SearchSubPos;
           inc(temppathstrindex);
          end
         else if(temppathstr.path[temppathstrindex-1]=tempstr) and
         (fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,recindex>0)
         and fat_directory_file=fat_directory_file) and (temppathstrindex=temppathstr.count) then
          begin
           inc(Result.count);
           SetLength(Result.FileShortStr,Result.count);
           Result.FileShortStr[Result.count-1]:=genfs_fat_extract_short_name(
           Pfat_directory_structure(@unitcontent)^);
           SetLength(Result.FileClass,Result.count);
           Result.FileClass[Result.count-1]:=fat_directory_file;
           SetLength(Result.FilePath,Result.count);
           Result.FilePath[Result.count-1]:=basedir;
           {Record the File Main Position(in cluster) and Sub Position(in number of
           fat_directory_structure)}
           SetLength(Result.FileMainPos,Result.count);
           SetLength(Result.FileSubPos,Result.count);
           if(startindex<>0) then
            begin
             Result.FileMainPos[Result.count-1]:=Startindex;
             Result.FileSubPos[Result.count-1]:=startoffset-1;
            end
           else
            begin
             Result.FileMainPos[Result.count-1]:=SearchMainPos;
             Result.FileSubPos[Result.count-1]:=SearchSubPos-1;
            end;
           {Record the File Directory's actual size}
           SetLength(Result.FileStructSize,Result.count);
           Result.FileStructSize[Result.count-1]:=recindex+1;
          end;
         if(fatstr.unicodefncount>0) then
          begin
           FreeMem(fatstr.unicodefn); fatstr.unicodefn:=nil; fatstr.unicodefncount:=0;
          end;
         recindex:=0; startindex:=0; startoffset:=0;
         FreeMem(tempstr);
        end;
       {If the read offset is on the boundary of the cluster,go to next cluster or search ended.}
       if(SearchSubPos=BytePerSector*SectorPerCluster shr 5) then
        begin
         clustervalue:=genfs_fat_read_entry(fs,SearchMainPos);
         if(fat32_check_cluster_status(clustervalue.entry32)=fat_end)
         or(fat32_check_cluster_status(clustervalue.entry32)=fat_cluster_broken)then
          begin
           break;
          end
         else if(fat32_check_cluster_status(clustervalue.entry32)<>fat_end)
         and(fat32_check_cluster_status(clustervalue.entry32)<>fat_cluster_broken)then
          begin
           SearchMainPos:=clustervalue.entry32;
           SearchSubPos:=0;
          end;
        end;
      end;
     if(temppathstrindex<=temppath.Count) then exit(Result);
     while(True)do
      begin
       genfs_io_read(fs,unitcontent,fs.fat32.datastart+(SearchMainPos-2)*
       BytePerSector*SectorPerCluster+SearchSubPos shl 5,
       sizeof(fat_directory_structure));
       inc(SearchSubPos);
       if(unitcontent[1]=$00) then
        begin
         {Indicate the Directory is ended.}
         break;
        end
       else if(unitcontent[12]=fat_attribute_long_name) then
        begin
         {Add the long directory structure item to Directory.}
         inc(fatstr.unicodefncount);
         ReallocMem(fatstr.unicodefn,sizeof(fat_long_directory_structure)*fatstr.unicodefncount);
         fat_MoveLongDirStructStringToFatString(Pfat_long_directory_structure(@unitcontent)^,
         fatstr,fatstr.unicodefncount);
         if(recindex=0) then
          begin
           startindex:=SearchMainPos; startoffset:=SearchSubPos;
          end;
         inc(recindex);
        end
       else if(unitcontent[12]<>fat_attribute_long_name) then
        begin
         inc(Result.count);
         {Files in FAT32 are always have short name,record it.}
         SetLength(Result.FileShortStr,Result.count);
         Result.FileShortStr[Result.count-1]:=
         genfs_fat_extract_short_name(Pfat_directory_structure(@unitcontent)^);
         {Record the File Class of File.}
         SetLength(Result.FileClass,Result.count);
         Result.FileClass[Result.count-1]:=
         fat_get_file_class(Pfat_directory_structure(@unitcontent)^.directoryattribute,recindex>0);
         {Record the File Full Path}
         SetLength(Result.FilePath,Result.count);
         fat_MoveDirStructStringToFatString(Pfat_directory_structure(@unitcontent)^,fatstr);
         tempstr:=fat_FatStringToPWideChar(fatstr);
         if(basedir='\') or (basedir='/') then
         Result.FilePath[Result.count-1]:=basedir+tempstr
         else
         Result.FilePath[Result.count-1]:=basedir+'/'+tempstr;
         {Record the File Main Position(in cluster) and Sub Position(in number of
         fat_directory_structure)}
         SetLength(Result.FileMainPos,Result.count);
         SetLength(Result.FileSubPos,Result.count);
         if(startindex<>0) then
          begin
           Result.FileMainPos[Result.count-1]:=Startindex;
           Result.FileSubPos[Result.count-1]:=startoffset-1;
          end
         else
          begin
           Result.FileMainPos[Result.count-1]:=SearchMainPos;
           Result.FileSubPos[Result.count-1]:=SearchSubPos-1;
          end;
         {Record the File Directory's actual size}
         SetLength(Result.FileStructSize,Result.count);
         Result.FileStructSize[Result.count-1]:=recindex+1;
         {If the file is directory,then search into its content}
         if(UnicodeString(tempstr)='.') and (UnicodeString(tempstr)='..') then
         inc(Result.FilePrevNextCount);
         if(UnicodeString(tempstr)<>'.') and (UnicodeString(tempstr)<>'..') and
         (Result.FileClass[Result.count-1] and fat_directory_directory=fat_directory_directory) then
          begin
           {Confirm the position of Directory Content(in cluster)}
           tempdirpos:=Pfat_directory_structure(@unitcontent)^.directoryfirstclusterhighword shl 16+
           Pfat_directory_structure(@unitcontent)^.directoryfirstclusterlowword;
           temppath:=genfs_filesystem_search_for_path(fs,
           Result.FilePath[Result.count-1],tempdirpos);
           {Insert the temppath's content to main Result}
           for i:=1 to temppath.Count do
            begin
             inc(Result.count);
             SetLength(Result.FilePath,Result.count);
             Result.FilePath[Result.count-1]:=temppath.FilePath[i-1];
             SetLength(Result.FileShortStr,Result.count);
             Result.FileShortStr[Result.count-1]:=temppath.FileShortStr[i-1];
             SetLength(Result.FileMainPos,Result.count);
             Result.FileMainPos[Result.count-1]:=temppath.FileMainPos[i-1];
             SetLength(Result.FileSubPos,Result.count);
             Result.FileSubPos[Result.count-1]:=temppath.FileSubPos[i-1];
             SetLength(Result.FileClass,Result.count);
             Result.FileClass[Result.count-1]:=temppath.FileClass[i-1];
             SetLength(Result.FileStructSize,Result.count);
             Result.FileStructSize[Result.count-1]:=temppath.FileClass[i-1];
            end;
           {Release the memory of variable temppath}
           SetLength(temppath.FilePath,0);
           SetLength(temppath.FileShortStr,0);
           SetLength(temppath.FileMainPos,0);
           SetLength(temppath.FileSubPos,0);
           SetLength(temppath.FileClass,0);
           SetLength(temppath.FileStructSize,0);
          end;
         if(fatstr.unicodefncount>0) then
          begin
           FreeMem(fatstr.unicodefn); fatstr.unicodefn:=nil; fatstr.unicodefncount:=0;
          end;
         FreeMem(tempstr);
         recindex:=0; startindex:=0; startoffset:=0;
        end;
       {If the read offset is on the boundary of the cluster,go to next cluster or search ended.}
       if(SearchSubPos=BytePerSector*SectorPerCluster shr 5) then
        begin
         clustervalue:=genfs_fat_read_entry(fs,SearchMainPos);
         if(fat32_check_cluster_status(clustervalue.entry32)=fat_end)
         or(fat32_check_cluster_status(clustervalue.entry32)=fat_cluster_broken)then
          begin
           break;
          end
         else if(fat32_check_cluster_status(clustervalue.entry32)<>fat_end)
         and(fat32_check_cluster_status(clustervalue.entry32)<>fat_cluster_broken)then
          begin
           SearchMainPos:=clustervalue.entry32;
           SearchSubPos:=0;
          end;
        end;
      end;
    end;
  end
 else
  begin

  end;
 if(ismask) then
  begin
   {Rehandle the Result and delete all file path don't match the mask}
   if(fs.fsname=filesystem_fat12) or (fs.fsname=filesystem_fat16) or (fs.fsname=filesystem_fat32) then
    begin
     i:=1;
     while(i<=Result.count) do
      begin
       if(genfs_mask_match(inputbasedir,Result.FilePath[i-1])) then
        begin
         Delete(Result.FilePath,i-1,1); Delete(Result.FileShortStr,i-1,1);
         Delete(Result.FileMainPos,i-1,1); Delete(Result.FileSubPos,i-1,1);
         Delete(Result.FileClass,i-1,1);
         if(fs.fsname=filesystem_fat32) then
         Delete(Result.FileStructSize,i-1,1);
         dec(Result.count);
        end;
       inc(i);
      end;
    end;
  end;
end;
{File System File Existence}
function genfs_filesystem_check_file_existence(fs:genfs_filesystem;basedir:UnicodeString):boolean;
var temppath:genfs_inner_path;
begin
 temppath:=genfs_filesystem_search_for_path(fs,basedir);
 if(temppath.Count>0) then Result:=true else Result:=false;
 SetLength(temppath.FilePath,0); SetLength(temppath.FileShortStr,0); SetLength(temppath.FileMainPos,0);
 SetLength(temppath.FileSubPos,0); SetLength(temppath.FileClass,0); SetLength(temppath.FileStructSize,0);
end;
{FAT File Using Cluster acquire}
function genfs_fat_get_using_cluster(fs:genfs_filesystem;startcluster:SizeUint):genfs_fat_cluster_list;
var i:SizeUint;
    entry:fat_entry;
begin
 i:=startcluster; Result.count:=0;
 if(fs.fsname=filesystem_fat12) then
  begin
   entry:=genfs_fat_read_entry(fs,i);
   if(fat12_check_cluster_status(entry.entry12)=fat_using) or
   (fat12_check_cluster_status(entry.entry12)=fat_end) then
    begin
     inc(Result.count);
     SetLength(Result.index,Result.count);
     Result.index[Result.count-1]:=i;
    end;
   while(fat12_check_cluster_status(entry.entry12)=fat_using) do
    begin
     entry:=genfs_fat_read_entry(fs,entry.entry12);
     if(fat12_check_cluster_status(entry.entry12)=fat_using) or
     (fat12_check_cluster_status(entry.entry12)=fat_end) then
      begin
       inc(Result.count);
       SetLength(Result.index,Result.count);
       Result.index[Result.count-1]:=entry.entry12;
      end;
    end;
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   entry:=genfs_fat_read_entry(fs,i);
   if(fat16_check_cluster_status(entry.entry16)=fat_using) or
   (fat16_check_cluster_status(entry.entry16)=fat_end) then
    begin
     inc(Result.count);
     SetLength(Result.index,Result.count);
     Result.index[Result.count-1]:=i;
    end;
   while(fat16_check_cluster_status(entry.entry16)=fat_using) do
    begin
     entry:=genfs_fat_read_entry(fs,entry.entry16);
     if(fat16_check_cluster_status(entry.entry16)=fat_using) or
     (fat16_check_cluster_status(entry.entry16)=fat_end) then
      begin
       inc(Result.count);
       SetLength(Result.index,Result.count);
       Result.index[Result.count-1]:=entry.entry16;
      end;
    end;
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   entry:=genfs_fat_read_entry(fs,i);
   if(fat32_check_cluster_status(entry.entry32)=fat_using) or
   (fat32_check_cluster_status(entry.entry32)=fat_end) then
    begin
     inc(Result.count);
     SetLength(Result.index,Result.count);
     Result.index[Result.count-1]:=i;
    end;
   while(fat32_check_cluster_status(entry.entry32)=fat_using) do
    begin
     entry:=genfs_fat_read_entry(fs,entry.entry32);
     if(fat32_check_cluster_status(entry.entry32)=fat_using) or
     (fat32_check_cluster_status(entry.entry32)=fat_end) then
      begin
       inc(Result.count);
       SetLength(Result.index,Result.count);
       Result.index[Result.count-1]:=entry.entry32;
      end;
    end;
  end
 else exit(Result);
end;
{FAT Available acquire}
function genfs_fat_get_available_cluster(fs:genfs_filesystem;needcount:SizeUint):genfs_fat_cluster_list;
var i:SizeUint;
    entry:fat_entry;
begin
 i:=2; Result.count:=0;
 if(fs.fsname=filesystem_fat12) then
  begin
   while(i<=fs.fat12.entrycount)do
    begin
     entry:=genfs_fat_read_entry(fs,i);
     if(fat12_check_cluster_status(entry.entry12)=fat_available) then
      begin
       inc(Result.count);
       SetLength(Result.index,Result.count);
       Result.index[Result.count-1]:=i;
       if(Result.count>=needcount) then break;
      end;
     inc(i);
    end;
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   while(i<=fs.fat16.entrycount)do
    begin
     entry:=genfs_fat_read_entry(fs,i);
     if(fat16_check_cluster_status(entry.entry16)=fat_available) then
      begin
       inc(Result.count);
       SetLength(Result.index,Result.count);
       Result.index[Result.count-1]:=i;
       if(Result.count>=needcount) then break;
      end;
     inc(i);
    end;
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   while(i<=fs.fat32.entrycount)do
    begin
     entry:=genfs_fat_read_entry(fs,i);
     if(fat32_check_cluster_status(entry.entry32)=fat_available) then
      begin
       inc(Result.count);
       SetLength(Result.index,Result.count);
       Result.index[Result.count-1]:=i;
       if(Result.count>=needcount) then break;
      end;
     inc(i);
    end;
  end
 else exit(Result);
end;
{FAT Cluster to file position}
function genfs_fat_cluster_to_file_position(fs:genfs_filesystem;cluster:SizeUint):SizeUint;
var tempnum1,tempnum2:SizeUint;
begin
 if(fs.fsname=filesystem_fat12) then
  begin
   tempnum1:=fs.fat12.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat12.header.head.bpb_SectorPerCluster;
   Result:=fs.fat12.datastart+(cluster-2)*(tempnum1*tempnum2);
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   tempnum1:=fs.fat16.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat16.header.head.bpb_SectorPerCluster;
   Result:=fs.fat16.datastart+(cluster-2)*(tempnum1*tempnum2);
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   tempnum1:=fs.fat32.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat32.header.head.bpb_SectorPerCluster;
   Result:=fs.fat32.datastart+(cluster-2)*(tempnum1*tempnum2);
  end;
end;
{FAT Location of File Info Position or New Directory Position}
function genfs_fat_location_of_file_info(fs:genfs_filesystem;MainPos,SubPos,DirSize:SizeUint):genfs_fat_position_info;
var templist:genfs_fat_cluster_list;
    tempDirSize,tempnum1,tempnum2,index:SizeUint;
begin
 if(fs.fsname=filesystem_fat12) then
  begin
   tempnum1:=fs.fat12.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat12.header.head.bpb_SectorPerCluster;
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   tempnum1:=fs.fat16.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat16.header.head.bpb_SectorPerCluster;
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   tempnum1:=fs.fat32.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat32.header.head.bpb_SectorPerCluster;
  end;
 templist:=genfs_fat_get_using_cluster(fs,MainPos);
 tempDirSize:=SubPos shl 5+DirSize shl 5; index:=1;
 while(tempDirSize>tempnum1*tempnum2) and (index<templist.count) do
  begin
   inc(index);
   dec(tempDirSize,tempnum1*tempnum2);
  end;
 Result.MainPos:=templist.index[index-1];
 Result.SubPos:=tempDirSize shr 5;
end;
{FAT Next Directory Position List}
function genfs_fat_location_of_next_directory_list(fs:genfs_filesystem;
MainPos,SubPos,DirSize:SizeUint):genfs_fat_position_info_list;
var templist:genfs_fat_cluster_list;
    tempDirSize,tempnum1,tempnum2,index:SizeUint;
begin
 if(fs.fsname=filesystem_fat12) then
  begin
   tempnum1:=fs.fat12.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat12.header.head.bpb_SectorPerCluster;
  end
 else if(fs.fsname=filesystem_fat16) then
  begin
   tempnum1:=fs.fat16.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat16.header.head.bpb_SectorPerCluster;
  end
 else if(fs.fsname=filesystem_fat32) then
  begin
   tempnum1:=fs.fat32.header.head.bpb_bytesPerSector;
   tempnum2:=fs.fat32.header.head.bpb_SectorPerCluster;
  end;
 tempDirSize:=SubPos shl 5+DirSize shl 5;
 index:=1; Result.count:=0;
 templist:=genfs_fat_get_available_cluster(fs,tempdirsize div (tempnum1*tempnum2));
 if(tempdirSize>0) then
  begin
   inc(Result.count);
   SetLength(Result.item,Result.count);
   SetLength(Result.size,Result.count);
   Result.item[Result.count-1].MainPos:=MainPos;
   Result.item[Result.count-1].SubPos:=SubPos;
   Result.size[Result.count-1]:=tempdirSize shr 5-SubPos;
  end;
 while(tempDirSize>tempnum1*tempnum2) and (index<templist.count) do
  begin
   inc(index);
   dec(tempDirSize,tempnum1*tempnum2);
   inc(Result.count);
   SetLength(Result.item,Result.count);
   SetLength(Result.size,Result.count);
   Result.item[Result.count-1].MainPos:=templist.index[index-1];
   Result.item[Result.count-1].SubPos:=0;
   Result.size[Result.count-1]:=(tempnum1*tempnum2) shr 5;
  end;
 if(index>1) and (tempdirSize>0) then
  begin
   inc(Result.count);
   SetLength(Result.item,Result.count);
   SetLength(Result.size,Result.count);
   Result.item[Result.count-1].MainPos:=templist.index[index-1];
   Result.item[Result.count-1].SubPos:=0;
   Result.size[Result.count-1]:=tempdirSize shr 5;
  end;
end;
{FAT File System Get File Size}
function genfs_fat_get_file_size(fs:genfs_filesystem;path:UnicodeString):SizeUint;
var temppath:genfs_inner_path;
    fatpos:genfs_fat_position_info;
    PosInFile:SizeUint;
    dircontent:array[1..32] of byte;
    i:SizeUint;
begin
 temppath:=genfs_filesystem_search_for_path(fs); Result:=0; i:=1;
 while(i<=temppath.Count)do
  begin
   if(temppath.FilePath[i-1]=path) then
    begin
     if(fs.fsname<=filesystem_fat16) then
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],1)
     else
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],temppath.FileStructSize[i-1]);
     PosInFile:=genfs_fat_cluster_to_file_position(fs,fatpos.MainPos)+
     (fatpos.SubPos-1) shl 5;
     genfs_io_read(fs,dircontent,PosInFile,sizeof(fat_directory_structure));
     Result:=Pfat_directory_structure(@dircontent)^.directoryfilesize;
     break;
    end;
   inc(i);
  end;
end;
{FAT File System Edit File Size}
procedure genfs_fat_edit_file_size(fs:genfs_filesystem;path:UnicodeString;ChangeSize:SizeUint);
var temppath:genfs_inner_path;
    fatpos:genfs_fat_position_info;
    PosInFile:SizeUint;
    dircontent:array[1..32] of byte;
    i:SizeUint;
begin
 temppath:=genfs_filesystem_search_for_path(fs); i:=1;
 while(i<=temppath.Count)do
  begin
   if(temppath.FilePath[i-1]=path) then
    begin
     if(fs.fsname<=filesystem_fat16) then
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],1)
     else
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],temppath.FileStructSize[i-1]);
     PosInFile:=genfs_fat_cluster_to_file_position(fs,fatpos.MainPos)+
     (fatpos.SubPos-1) shl 5;
     genfs_io_read(fs,dircontent,PosInFile,sizeof(fat_directory_structure));
     if(fat_get_file_class(Pfat_directory_structure(@dircontent)^.directoryattribute,
     fs.fsname<=filesystem_fat32)
     and fat_directory_file<>fat_directory_file) then break;
     Pfat_directory_structure(@dircontent)^.directoryfilesize:=ChangeSize;
     genfs_io_write(fs,dircontent,PosInFile,sizeof(fat_directory_structure));
     break;
    end;
   inc(i);
  end;
end;
{FAT File System Get File Cluster}
function genfs_fat_get_file_cluster(fs:genfs_filesystem;path:UnicodeString):SizeUint;
var temppath:genfs_inner_path;
    fatpos:genfs_fat_position_info;
    PosInFile:SizeUint;
    dircontent:array[1..32] of byte;
    i:SizeUint;
begin
 temppath:=genfs_filesystem_search_for_path(fs); Result:=0; i:=1;
 while(i<=temppath.Count)do
  begin
   if(temppath.FilePath[i-1]=path) then
    begin
     if(fs.fsname<=filesystem_fat16) then
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],1)
     else
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],temppath.FileStructSize[i-1]);
     PosInFile:=genfs_fat_cluster_to_file_position(fs,fatpos.MainPos)+
     (fatpos.SubPos-1) shl 5;
     genfs_io_read(fs,dircontent,PosInFile,sizeof(fat_directory_structure));
     Result:=Pfat_directory_structure(@dircontent)^.directoryfirstclusterhighword shl 16
     +Pfat_directory_structure(@dircontent)^.directoryfirstclusterlowword;
     break;
    end;
   inc(i);
  end;
end;
{FAT File System Get File Size}
function genfs_fat_get_file_attribute(fs:genfs_filesystem;path:UnicodeString):byte;
var temppath:genfs_inner_path;
    fatpos:genfs_fat_position_info;
    PosInFile:SizeUint;
    dircontent:array[1..32] of byte;
    i:SizeUint;
begin
 temppath:=genfs_filesystem_search_for_path(fs); Result:=0; i:=1;
 while(i<=temppath.Count)do
  begin
   if(temppath.FilePath[i-1]=path) then
    begin
     if(fs.fsname<=filesystem_fat16) then
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],1)
     else
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],temppath.FileStructSize[i-1]);
     PosInFile:=genfs_fat_cluster_to_file_position(fs,fatpos.MainPos)+
     (fatpos.SubPos-1) shl 5;
     genfs_io_read(fs,dircontent,PosInFile,sizeof(fat_directory_structure));
     Result:=Pfat_directory_structure(@dircontent)^.directoryattribute;
     break;
    end;
   inc(i);
  end;
end;
{FAT File System Next Cluster of Directory}
function genfs_fat_get_directory_cluster(fs:genfs_filesystem;path:UnicodeString):SizeUint;
var temppath:genfs_inner_path;
    fatpos:genfs_fat_position_info;
    PosInFile:SizeUint;
    dircontent:array[1..32] of byte;
    i:SizeUint;
begin
 temppath:=genfs_filesystem_search_for_path(fs); Result:=0; i:=1;
 while(i<=temppath.Count)do
  begin
   if(temppath.FilePath[i-1]=path) then
    begin
     if(fs.fsname<=filesystem_fat16) then
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],1)
     else
     fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[i-1],
     temppath.FileSubPos[i-1],temppath.FileStructSize[i-1]);
     PosInFile:=genfs_fat_cluster_to_file_position(fs,fatpos.MainPos)+
     (fatpos.SubPos-1) shl 5;
     genfs_io_read(fs,dircontent,PosInFile,sizeof(fat_directory_structure));
     Result:=Pfat_directory_structure(@dircontent)^.directoryfirstclusterhighword shl 16
     +Pfat_directory_structure(@dircontent)^.directoryfirstclusterlowword;
     break;
    end;
   inc(i);
  end;
end;
{FAT File System File Rename Operation}
procedure genfs_fat_rename(var fs:genfs_filesystem);
var temppath:genfs_inner_path;
    tempstr:PWideChar;
    tempsstr:PChar;
    checksum:byte;
    FATPos:genfs_fat_position_info;
    FATPoslist:genfs_fat_position_info_list;
    i,j,k,m,n,ptr,count:SizeUint;
    dirsize:SizeUint;
    PosInFile:SizeUint;
    dircontent:array[1..32] of byte;
begin
 temppath:=genfs_filesystem_search_for_path(fs);
 i:=1;
 while(i<=temppath.count)do
  begin
   j:=1; count:=0;
   while(j<=temppath.count)do
    begin
     if(j=i) then
      begin
       inc(j); continue;
      end;
     if(temppath.FileShortStr[i-1]=temppath.FileShortStr[j-1])
     and (genfs_check_same_path(temppath.FilePath[i-1],temppath.FilePath[j-1])) then inc(count);
     inc(j);
    end;
   if(count>0) then
    begin
     tempstr:=UnicodeStringToPWideChar(genfs_extract_file_name(temppath.FilePath[i-1]));
     dirsize:=fat_calculate_directory_size(tempstr);
     FATPos:=genfs_fat_location_of_file_info(fs,
     temppath.FileMainPos[i-1],temppath.FileSubPos[i-1],dirsize shr 5);
     PosInFile:=genfs_fat_cluster_to_file_position(fs,FATPos.MainPos)+
     (FATPos.SubPos-1) shl 5;
     genfs_io_read(fs,dircontent,PosInFile,1 shl 5);
     tempsstr:=fat_generate_regular_short_file_name(tempstr,1+count);
     checksum:=fat_change_short_file_name(tempsstr,Pfat_directory_structure(@dircontent)^);
     genfs_io_write(fs,dircontent,PosInFile,1 shl 5);
     FATPosList:=genfs_fat_location_of_next_directory_list(fs,
     temppath.FileMainPos[i-1],temppath.FileSubPos[i-1],dirsize shr 5);
     k:=1; ptr:=0; n:=dirsize shr 5;
     while(k<=FATPoslist.count)do
      begin
       m:=1;
       while(m<=FATPoslist.size[k-1])do
        begin
         PosInFile:=genfs_fat_cluster_to_file_position(fs,FATPoslist.item[k-1].MainPos)
         +(FATPoslist.item[k-1].SubPos-1+m-1)*(1 shl 5);
         genfs_io_read(fs,dircontent,PosInFile,1 shl 5);
         Pfat_long_directory_structure(@dircontent)^.longdirectorychecksum:=checksum;
         genfs_io_write(fs,dircontent,PosInFile,1 shl 5);
         inc(m); inc(n);
         if(n>=dirsize shr 5) then break;
        end;
       if(n>=dirsize shr 5) then break;
       inc(k);
      end;
    end;
   inc(i);
  end;
end;
{File System File Add Operation}
procedure genfs_filesystem_add(var fs:genfs_filesystem;srcdir:UnicodeString;destdir:UnicodeString);
var temppath:genfs_inner_path;
    extpath:genfs_path;
    pathstr:genfs_path_string;
    destpath:UnicodeString;
    i,j,k,m,n:SizeUint;
    addcontent:array[1..512] of byte;
    BytePerSector,SectorPerCluster:SizeUint;
{These are for external path parsing}
    rootpath:UnicodeString;
    rootlen:SizeUint;
{These are FAT File System Only}
    tempstr:PWideChar;
    tempsize:SizeUint;
    fatentry:fat_entry;
    fatstr:fat_string;
    FatDir:fat_directory;
    TotalPath:UnicodeString;
    fatpos:genfs_fat_position_info;
    fatposlist:genfs_fat_position_info_list;
    fatavailablelist:genfs_fat_cluster_list;
    PosInFile:SizeUint;
    CurCluster,PrevCluster:SizeUint;
    HavePrevNext:boolean;
begin
 for i:=1 to 512 do addcontent[i]:=0;
 temppath:=genfs_filesystem_search_for_path(fs);
 extpath:=genfs_external_search_for_path(srcdir);
 if(extpath.count=0) then
  begin
   writeln('ERROR:No file or directory exists in source file path.');
   readln;
   abort;
  end;
 fatstr.unicodefn:=nil; fatstr.unicodefncount:=0;
 fatdir.longdir:=nil; fatdir.longdircount:=0;
 if(FileExists(srcdir)) then
  begin
   rootpath:=genfs_extract_file_path(srcdir); rootlen:=length(rootpath)+1;
  end
 else
  begin
   rootpath:=genfs_extract_search_path_without_wildcard(srcdir); rootlen:=length(rootpath)+1;
  end;
 i:=1;
 while(i<=extpath.count)do
  begin
   if(extpath.IsFile[i-1]) then
   destpath:=destdir
   else if(genfs_check_file_name(destdir)) then
   destpath:=destdir
   else if(destdir='/') or (destdir='\') then
   destpath:=destdir+Copy(extpath.FilePath[i-1],rootlen+1,length(extpath.FilePath[i-1])-rootlen)
   else if(length(destdir)>0) and ((destdir[length(destdir)]='/') or (destdir[length(destdir)]='\')) then
   destpath:=destdir+Copy(extpath.FilePath[i-1],rootlen+1,length(extpath.FilePath[i-1])-rootlen)
   else
   destpath:=destdir+'/'+Copy(extpath.FilePath[i-1],rootlen+1,length(extpath.FilePath[i-1])-rootlen);
   pathstr:=genfs_path_to_path_string(destpath);
   j:=1; TotalPath:='/';
   PrevCluster:=2;
   if(fs.fsname=filesystem_fat12) then CurCluster:=2
   else if(fs.fsname=filesystem_fat16) then CurCluster:=2
   else if(fs.fsname=filesystem_fat32) then CurCluster:=fs.fat32.header.exthead.bpb_rootcluster;
   while(j<=pathstr.count)do
    begin
     if(fs.fsname<=filesystem_fat32) then
      begin
       k:=1; HavePrevNext:=false;
       while(k<=temppath.Count)do
        begin
         if((j=1) and (TotalPath+pathstr.path[j-1]=temppath.FilePath[k-1]))
         or((j>1) and (TotalPath+'/'+pathstr.path[j-1]=temppath.FilePath[k-1]))then
          begin
           if(fs.fsname<=filesystem_fat16) then
           fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[k-1],
           temppath.FileSubPos[k-1],1)
           else
           fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[k-1],
           temppath.FileSubPos[k-1],temppath.FileStructSize[k-1]);
           PosInFile:=genfs_fat_cluster_to_file_position(fs,fatpos.MainPos)+
           (fatpos.SubPos-1) shl 5;
           genfs_io_read(fs,addcontent,PosInFile,sizeof(fat_directory_structure));
           if(fs.fsname=filesystem_fat32) and
           (fat_get_file_class(Pfat_directory_structure(@addcontent)^.directoryattribute,
           temppath.FileStructSize[k-1]>1)
           and fat_directory_directory=fat_directory_directory) then
            begin
             CurCluster:=Pfat_directory_structure(@addcontent)^.directoryfirstclusterhighword shl 16
             +Pfat_directory_structure(@addcontent)^.directoryfirstclusterlowword;
            end
           else if(fs.fsname<=filesystem_fat16) and
           (fat_get_file_class(Pfat_directory_structure(@addcontent)^.directoryattribute,false)
           and fat_directory_directory=fat_directory_directory) then
            begin
             CurCluster:=Pfat_directory_structure(@addcontent)^.directoryfirstclusterhighword shl 16
             +Pfat_directory_structure(@addcontent)^.directoryfirstclusterlowword;
            end
           else if(fs.fsname=filesystem_fat32) and
           (fat_get_file_class(Pfat_directory_structure(@addcontent)^.directoryattribute,
           temppath.FileStructSize[k-1]>1) and fat_directory_file=fat_directory_file) then
            begin
             break;
            end
           else if(fs.fsname<=filesystem_fat16) and
           (fat_get_file_class(Pfat_directory_structure(@addcontent)^.directoryattribute,false)
           and fat_directory_file=fat_directory_file) then
            begin
             break;
            end;
           break;
          end
         else if(genfs_check_prefix(TotalPath,temppath.FilePath[k-1],true)) then
          begin
           if(j>1) then HavePrevNext:=true;
           if(fs.fsname<=filesystem_fat16) then
           fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[k-1],
           temppath.FileSubPos[k-1],1)
           else
           fatpos:=genfs_fat_location_of_file_info(fs,temppath.FileMainPos[k-1],
           temppath.FileSubPos[k-1],temppath.FileStructSize[k-1]);
          end;
         inc(k);
        end;
       if(k<=temppath.count) then
        begin
         PrevCluster:=CurCluster;
         if(TotalPath='/') or (TotalPath='\') then TotalPath:=TotalPath+pathstr.path[j-1]
         else TotalPath:=TotalPath+'/'+pathstr.path[j-1];
         inc(j);
         continue;
        end
       else if(HavePrevNext=false) then
        begin
         fatavailablelist:=genfs_fat_get_available_cluster(fs,1);
         if(fatavailablelist.count=0) then
          begin
           writeln('ERROR:FAT FileSystem Write out of size.');
           readln;
           abort;
          end;
         CurCluster:=fatavailablelist.index[0];
         fatpos.MainPos:=CurCluster; fatpos.SubPos:=0;
        end;
       if(j>1) and (HavePrevNext=false) then
        begin
         fatstr:=fat_PWideCharToFatString('.');
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory,
         genfs_date_to_fat_date,genfs_time_to_fat_time,0,fatpos.MainPos);
         PosInFile:=genfs_fat_cluster_to_file_position(fs,curcluster);
         genfs_io_write(fs,fatdir.dir,PosInFile,sizeof(fat_directory_structure));
         fatstr:=fat_PWideCharToFatString('..');
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory,
         genfs_date_to_fat_date,genfs_time_to_fat_time,0,PrevCluster);
         PosInFile:=genfs_fat_cluster_to_file_position(fs,curcluster)+sizeof(fat_directory_structure);
         genfs_io_write(fs,fatdir.dir,PosInFile,sizeof(fat_directory_structure));
         if(fs.fsname<=filesystem_fat12) then fatentry.entry12:=fat12_final_cluster_low
         else if(fs.fsname<=filesystem_fat16) then fatentry.entry16:=fat16_final_cluster_low
         else if(fs.fsname<=filesystem_fat32) then fatentry.entry32:=fat32_final_cluster_low;
         genfs_fat_write_entry(fs,fatentry,CurCluster);
         if(fs.fsname=filesystem_fat32) then
          begin
           dec(fs.fat32.fsinfo.freecount,1);
           fatavailablelist:=genfs_fat_get_available_cluster(fs,1);
           if(fatavailablelist.count=0) then
            begin
             writeln('ERROR:File System cannot allocate more cluster to new information.');
             readln;
             abort;
            end;
           fs.fat32.fsinfo.nextfree:=fatavailablelist.index[0];
          end;
         inc(fatpos.subpos,2);
         PrevCluster:=CurCluster;
        end;
        tempstr:=UnicodeStringToPWideChar(pathstr.path[j-1]);
        fatstr:=fat_PWideCharToFatString(tempstr);
        if(extpath.IsFile[i-1]) and (j=pathstr.count) then
        tempsize:=genfs_external_file_size(extpath.FilePath[i-1])
        else tempsize:=0;
        if(fs.fsname<=filesystem_fat16) then
        fatposlist:=genfs_fat_location_of_next_directory_list(fs,fatpos.MainPos,fatpos.SubPos,1)
        else
        fatposlist:=genfs_fat_location_of_next_directory_list(fs,fatpos.MainPos,fatpos.SubPos,
        fat_calculate_directory_size(tempstr) shr 5);
        {Generate new cluster for File System}
        fatavailablelist.count:=0;
        if(fatpos.MainPos<>fatposlist.item[0].MainPos) and (j=1) then
        fatavailablelist:=genfs_fat_get_available_cluster(fs,fatposlist.count+2)
        else if(j=1) then
        fatavailablelist:=genfs_fat_get_available_cluster(fs,fatposlist.count+1)
        else if(fatpos.MainPos<>fatposlist.item[0].MainPos) then
        fatavailablelist:=genfs_fat_get_available_cluster(fs,fatposlist.count+1)
        else
        fatavailablelist:=genfs_fat_get_available_cluster(fs,fatposlist.count);
        if(fatavailablelist.count>0) then
         begin
          CurCluster:=fatavailablelist.index[fatavailablelist.count-1];
          if(fs.fsname=filesystem_fat32) then
           begin
            dec(fs.fat32.fsinfo.freecount,fatavailablelist.count-1);
            fs.fat32.fsinfo.nextfree:=fatavailablelist.index[fatavailablelist.count-1];
           end;
         end
        else
         begin
          writeln('ERROR:File System cannot allocate more cluster to new information.');
          readln;
          abort;
         end;
        if(fs.fsname<=filesystem_fat16) or (fatstr.unicodefncount=0) then
         begin
          if(extpath.IsFile[i-1]) and (j=pathstr.count) and
          (genfs_external_file_size(extpath.FilePath[i-1])=0) then
          fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file,
          genfs_date_to_fat_date,genfs_time_to_fat_time,0,0)
          else if(extpath.IsFile[i-1]) and (j=pathstr.count) then
          fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file,
          genfs_date_to_fat_date,genfs_time_to_fat_time,tempsize,CurCluster)
          else
          fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory,
          genfs_date_to_fat_date,genfs_time_to_fat_time,0,CurCluster);
         end
        else
         begin
          if(extpath.IsFile[i-1]) and (j=pathstr.count) and
          (genfs_external_file_size(extpath.FilePath[i-1])=0) then
          fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file or fat_directory_long,
          genfs_date_to_fat_date,genfs_time_to_fat_time,0,0)
          else if(extpath.IsFile[i-1]) and (j=pathstr.count) then
          fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file or fat_directory_long,
          genfs_date_to_fat_date,genfs_time_to_fat_time,tempsize,CurCluster)
          else
          fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory or fat_directory_long,
          genfs_date_to_fat_date,genfs_time_to_fat_time,0,CurCluster);
         end;
        if(fatstr.unicodefn<>nil) then
         begin
          FreeMem(fatstr.unicodefn); fatstr.unicodefncount:=0; fatstr.unicodefn:=nil;
         end;
        {Add File infomation to the File System}
        if(j>1) and (HavePrevNext=false) then
         begin
          inc(temppath.Count);
          SetLength(temppath.FileClass,temppath.count);
          temppath.FileClass[temppath.count-1]:=fat_directory_directory;
          SetLength(temppath.FilePath,temppath.count);
          if(TotalPath='/') or (TotalPath='\') then
          temppath.FilePath[temppath.count-1]:=TotalPath+'.'
          else
          temppath.FilePath[temppath.count-1]:=TotalPath+'/.';
          SetLength(temppath.FileMainPos,temppath.count);
          temppath.FileMainPos[temppath.count-1]:=fatpos.MainPos;
          SetLength(temppath.FileSubPos,temppath.count);
          temppath.FileSubPos[temppath.count-1]:=0;
          SetLength(temppath.FileShortStr,temppath.count);
          temppath.FileShortStr[temppath.count-1]:='.';
          if(fs.fsname=filesystem_fat32) then
           begin
            SetLength(temppath.FileStructSize,temppath.count);
            temppath.FileStructSize[temppath.count-1]:=1;
           end;
          inc(temppath.Count);
          SetLength(temppath.FileClass,temppath.count);
          temppath.FileClass[temppath.count-1]:=fat_directory_directory;
          SetLength(temppath.FilePath,temppath.count);
          if(TotalPath='/') or (TotalPath='\') then
          temppath.FilePath[temppath.count-1]:=TotalPath+'..'
          else
          temppath.FilePath[temppath.count-1]:=TotalPath+'/..';
          SetLength(temppath.FileMainPos,temppath.count);
          temppath.FileMainPos[temppath.count-1]:=fatpos.MainPos;
          SetLength(temppath.FileSubPos,temppath.count);
          temppath.FileSubPos[temppath.count-1]:=1;
          SetLength(temppath.FileShortStr,temppath.count);
          temppath.FileShortStr[temppath.count-1]:='..';
          if(fs.fsname=filesystem_fat32) then
           begin
            SetLength(temppath.FileStructSize,temppath.count);
            temppath.FileStructSize[temppath.count-1]:=1;
           end;
          inc(temppath.FilePrevNextCount,2);
         end;
        inc(temppath.Count);
        SetLength(temppath.FileClass,temppath.count);
        SetLength(temppath.FilePath,temppath.count);
        SetLength(temppath.FileMainPos,temppath.count);
        SetLength(temppath.FileSubPos,temppath.count);
        SetLength(temppath.FileShortStr,temppath.count);
        if(fs.fsname=filesystem_fat32) then SetLength(temppath.FileStructSize,temppath.count);
        if(fatdir.longdircount>0) and (fs.fsname=filesystem_fat32) then
         begin
          if(j<pathstr.count) or (extpath.IsFile[i-1]=false) then
          temppath.FileClass[temppath.count-1]:=fat_directory_directory and
          fat_directory_long
          else
          temppath.FileClass[temppath.count-1]:=fat_directory_file and
          fat_directory_long;
          if(TotalPath='/') or (TotalPath='\') then
          temppath.FilePath[temppath.count-1]:=TotalPath+pathstr.path[j-1]
          else
          temppath.FilePath[temppath.count-1]:=TotalPath+'/'+pathstr.path[j-1];
          temppath.FileMainPos[temppath.count-1]:=fatpos.MainPos;
          temppath.FileSubPos[temppath.count-1]:=fatpos.SubPos;
          temppath.FileShortStr[temppath.count-1]:=genfs_fat_extract_short_name(fatdir.dir);
          temppath.FileStructSize[temppath.count-1]:=fatdir.longdircount+1;
         end
        else
         begin
          if(j<pathstr.count) then
          temppath.FileClass[temppath.count-1]:=fat_directory_directory
          else
          temppath.FileClass[temppath.count-1]:=fat_directory_file;
          if(TotalPath='/') or (TotalPath='\') then
          temppath.FilePath[temppath.count-1]:=TotalPath+pathstr.path[j-1]
          else
          temppath.FilePath[temppath.count-1]:=TotalPath+'/'+pathstr.path[j-1];
          temppath.FileMainPos[temppath.count-1]:=fatpos.MainPos;
          temppath.FileSubPos[temppath.count-1]:=fatpos.SubPos;
          temppath.FileShortStr[temppath.count-1]:=genfs_fat_extract_short_name(fatdir.dir);
          if(fs.fsname=filesystem_fat32) then
          temppath.FileStructSize[temppath.count-1]:=1;
         end;
        {Generate the missing directory}
        n:=1;
        for k:=1 to fatposlist.count do
         begin
          if(k<fatposlist.count) then
           begin
            if(fs.fsname<=filesystem_fat12) then
            fatentry.entry12:=fatposlist.item[k].MainPos
            else if(fs.fsname<=filesystem_fat16) then
            fatentry.entry16:=fatposlist.item[k].MainPos
            else if(fs.fsname<=filesystem_fat32) then
            fatentry.entry32:=fatposlist.item[k].MainPos;
            genfs_fat_write_entry(fs,fatentry,fatposlist.item[k-1].MainPos);
           end
          else
           begin
            if(fs.fsname<=filesystem_fat12) then
            fatentry.entry12:=fat12_final_cluster_low
            else if(fs.fsname<=filesystem_fat16) then
            fatentry.entry16:=fat16_final_cluster_low
            else if(fs.fsname<=filesystem_fat32) then
            fatentry.entry32:=fat32_final_cluster_low;
            genfs_fat_write_entry(fs,fatentry,fatposlist.item[k-1].MainPos);
           end;
          for m:=1 to fatposlist.size[k-1] do
           begin
            PosInFile:=genfs_fat_cluster_to_file_position(fs,fatposlist.item[k-1].MainPos)+
            (fatposlist.item[k-1].SubPos+m-1) shl 5;
            if(fs.fsname=filesystem_fat32) and (n<=fatdir.longdircount) then
            genfs_io_write(fs,(fatdir.longdir+n-1)^,PosInFile,sizeof(fat_long_directory_structure))
            else
            genfs_io_write(fs,fatdir.dir,PosInFile,sizeof(fat_long_directory_structure));
            inc(n);
           end;
         end;
        if(fatdir.longdircount>0) then
         begin
          FreeMem(fatdir.longdir); fatdir.longdir:=nil; fatdir.longdircount:=0;
         end;
        FreeMem(tempstr);
       if(j=pathstr.Count) and (extpath.IsFile[i-1]) then
        begin
         {Move the file into File System}
         BytePerSector:=fs.fat12.header.head.bpb_bytesPerSector;
         SectorPerCluster:=fs.fat12.header.head.bpb_SectorPerCluster;
         tempsize:=genfs_external_file_size(extpath.FilePath[i-1]);
         fatavailablelist:=genfs_fat_get_available_cluster(fs,(tempsize+BytePerSector*
         SectorPerCluster-1) div (BytePerSector*SectorPerCluster)+1);
         if(fatavailablelist.count=(tempsize+BytePerSector*
         SectorPerCluster-1) div (BytePerSector*SectorPerCluster)) then
         n:=fatavailablelist.count+1
         else if(fatavailablelist.count=(tempsize+BytePerSector*
         SectorPerCluster-1) div (BytePerSector*SectorPerCluster)+1) then
         n:=fatavailablelist.count
         else
          begin
           writeln('ERROR:Out of disk free space.');
           readln;
           abort;
          end;
         for k:=1 to n-1 do
          begin
           PosInFile:=genfs_fat_cluster_to_file_position(fs,fatavailablelist.index[k-1]);
           if(k<n-1) then
           begin
            if(fs.fsname<=filesystem_fat12) then
            fatentry.entry12:=fatavailablelist.index[k]
            else if(fs.fsname<=filesystem_fat16) then
            fatentry.entry16:=fatavailablelist.index[k]
            else if(fs.fsname<=filesystem_fat32) then
            fatentry.entry32:=fatavailablelist.index[k];
            genfs_fat_write_entry(fs,fatentry,fatavailablelist.index[k-1]);
           end
          else
           begin
            if(fs.fsname<=filesystem_fat12) then
            fatentry.entry12:=fat12_final_cluster_low
            else if(fs.fsname<=filesystem_fat16) then
            fatentry.entry16:=fat16_final_cluster_low
            else if(fs.fsname<=filesystem_fat32) then
            fatentry.entry32:=fat32_final_cluster_low;
            genfs_fat_write_entry(fs,fatentry,fatavailablelist.index[k-1]);
           end;
           if(tempsize>0) then
            begin
             for m:=1 to (BytePerSector*SectorPerCluster) shr 9 do
              begin
               if(tempsize>=1 shl 9) then
                begin
                 genfs_external_io_read(extpath.FilePath[i-1],addcontent,
                 (k-1)*(BytePerSector*SectorPerCluster)+(m-1) shl 9,1 shl 9);
                 genfs_io_write(fs,addcontent,PosInFile+(m-1) shl 9,1 shl 9);
                end
               else
                begin
                 genfs_external_io_read(extpath.FilePath[i-1],addcontent,
                 (k-1)*(BytePerSector*SectorPerCluster)+(m-1) shl 9,tempsize);
                 genfs_io_write(fs,addcontent,PosInFile+(m-1) shl 9,tempsize);
                 tempsize:=0;
                 break;
                end;
               dec(tempsize,1 shl 9);
              end;
            end;
          end;
         if(n=fatavailablelist.count+1) and (fs.fsname=filesystem_fat32) then
          begin
           fs.fat32.fsinfo.freecount:=0;
           fs.fat32.fsinfo.nextfree:=fatavailablelist.index[n-2]+1;
          end
         else if(fs.fsname=filesystem_fat32) then
          begin
           dec(fs.fat32.fsinfo.freecount,fatposlist.count);
           fs.fat32.fsinfo.nextfree:=fatavailablelist.index[fatavailablelist.count-1];
          end;
        end;
      end;
     if(TotalPath='/') or (TotalPath='\') then TotalPath:=TotalPath+pathstr.path[j-1]
     else TotalPath:=TotalPath+'/'+pathstr.path[j-1];
     inc(j);
    end;
   inc(i);
  end;
 genfs_filesystem_write_info(fs);
 if(fs.fsname<=filesystem_fat32) then genfs_fat_rename(fs);
end;
{File System File Copy Operation}
procedure genfs_filesystem_copy(var fs:genfs_filesystem;srcdir:UnicodeString;destdir:UnicodeString);
var srcpath,totalpath:genfs_inner_path;
    temppath,finaldestdir,searchpath:UnicodeString;
    rootpath:UnicodeString;
    pathstr:genfs_path_string;
    copycontent:array[1..512] of byte;
    i,j,k,m,n,len,rootlen:SizeUint;
    ismask:boolean;
    PosInFile:SizeUint;
    tempsize:SizeUint;
    tempcluster:SizeUint;
    Ptr1,Ptr2:SizeUint;
{Only for FAT FileSystem}
    BytePerSector,SectorPerCluster:SizeUint;
    tempstr:PWideChar;
    FATstr:fat_string;
    FATdir:fat_directory;
    FATPos:genfs_fat_position_info;
    FATAlist,FATUlist:genfs_fat_cluster_list;
    FATPoslist:genfs_fat_position_info_list;
    CurCluster,PrevCluster:SizeUint;
    HavePrevNext:boolean;
    FATentry:fat_entry;
begin
 if(srcdir=destdir) then exit;
 for i:=1 to 512 do copycontent[i]:=0;
 totalpath:=genfs_filesystem_search_for_path(fs);
 ismask:=genfs_is_mask(srcdir); srcpath.count:=0;
 if(fs.fsname<=filesystem_fat32) then
  begin
   FATstr.unicodefn:=nil; FATStr.unicodefncount:=0;
   FATdir.longdir:=nil; FATdir.longdircount:=0;
  end;
 if(fs.fsname<=filesystem_fat16) then CurCluster:=2
 else if(fs.fsname=filesystem_fat32) then CurCluster:=fs.fat32.header.exthead.bpb_rootcluster;
 {Generate the Source Directory Path}
 for i:=1 to totalpath.Count do
  begin
   if((ismask) and (genfs_mask_match(srcdir,totalpath.FilePath[i-1]))) or
   ((ismask=false) and (genfs_check_prefix(srcdir,totalpath.FilePath[i-1]))) then
    begin
     inc(srcpath.Count);
     SetLength(srcpath.FilePath,srcpath.Count);
     SetLength(srcpath.FileClass,srcpath.Count);
     SetLength(srcpath.FileMainPos,srcpath.Count);
     SetLength(srcpath.FileSubPos,srcpath.Count);
     if(fs.fsname<=filesystem_fat32) then SetLength(srcpath.FileShortStr,srcpath.Count);
     if(fs.fsname=filesystem_fat32) then SetLength(srcpath.FileStructSize,srcpath.Count);
     srcpath.FilePath[srcpath.count-1]:=totalpath.FilePath[i-1];
     srcpath.FileClass[srcpath.count-1]:=totalpath.FileClass[i-1];
     srcpath.FileMainPos[srcpath.count-1]:=totalpath.FileMainPos[i-1];
     srcpath.FileSubPos[srcpath.count-1]:=totalpath.FileSubPos[i-1];
     if(fs.fsname<=filesystem_fat16) then
     srcpath.FileShortStr[srcpath.count-1]:=totalpath.FileShortStr[i-1];
     if(fs.fsname=filesystem_fat32) then
     srcpath.FileStructSize[srcpath.count-1]:=totalpath.FileStructSize[i-1];
    end
   else if(destdir=totalpath.FilePath[i-1]) and (fs.fsname<=filesystem_fat16) then
    begin
     FATPos:=genfs_fat_location_of_file_info(fs,
     totalpath.FileMainPos[i-1],totalpath.FileSubPos[i-1],1);
    end
   else if(destdir=totalpath.FilePath[i-1]) and (fs.fsname=filesystem_fat32) then
    begin
     FATPos:=genfs_fat_location_of_file_info(fs,
     totalpath.FileMainPos[i-1],totalpath.FileSubPos[i-1],totalPath.FileStructSize[i-1]);
    end
  end;
 if(srcpath.count=0) then
  begin
   writeln('ERROR:No file or directory exists in specified path.');
   readln;
   abort;
  end;
 if(ismask) then
  begin
   rootpath:=genfs_extract_search_path_without_wildcard(srcdir); rootlen:=length(rootpath);
  end
 else
  begin
   rootpath:=genfs_extract_file_path(srcdir); rootlen:=length(rootpath);
  end;
 if((destdir='/') or (destdir='\')) and (fs.fsname<=filesystem_fat32) then
  begin
   FATPos:=genfs_fat_location_of_file_info(fs,
   totalpath.FileMainPos[i-1],totalpath.FileSubPos[i-1],totalPath.FileStructSize[i-1]);
  end;
 {Initialize the Final Destination Path}
 len:=length(destdir);
 if((destdir='/') or (destdir='\')) then finaldestdir:=''
 else if(len>1) and ((destdir[len]='/') or (destdir[len]='\')) then finaldestdir:=Copy(destdir,1,len-1)
 else finaldestdir:=destdir;
 {Create the file copied to}
 for i:=1 to srcpath.Count do
  begin
   if(fs.fsname<=filesystem_fat32) and
   (fat_get_file_class(srcpath.FileClass[srcpath.count-1],fs.fsname=filesystem_fat32)
   and fat_directory_file=fat_directory_file) then
   temppath:=finaldestdir
   else if(genfs_check_file_name(finaldestdir)) then
   temppath:=finaldestdir
   else if(finaldestdir='/') or (finaldestdir='\') then
   temppath:=finaldestdir+Copy(srcpath.FilePath[i-1],rootlen+1,length(srcpath.FilePath[i-1])-rootlen)
   else if(length(finaldestdir)>0)
   and ((finaldestdir[length(finaldestdir)]='/') or (finaldestdir[length(finaldestdir)]='\')) then
   temppath:=finaldestdir+Copy(srcpath.FilePath[i-1],rootlen+1,length(srcpath.FilePath[i-1])-rootlen)
   else
   temppath:=finaldestdir+'/'+Copy(srcpath.FilePath[i-1],rootlen+1,length(srcpath.FilePath[i-1])-rootlen);
   pathstr:=genfs_path_to_path_string(temppath);
   searchpath:='/';
   if(fs.fsname=filesystem_fat12) then CurCluster:=2
   else if(fs.fsname=filesystem_fat16) then CurCluster:=2
   else if(fs.fsname=filesystem_fat32) then CurCluster:=fs.fat32.header.exthead.bpb_rootcluster;
   PrevCluster:=CurCluster;
   j:=1;
   while(j<=pathstr.count)do
    begin
     if(fs.fsname<=filesystem_fat32) then
      begin
       k:=1; HavePrevNext:=false;
       while(k<=totalpath.count)do
        begin
         if((j=1) and (searchpath+pathstr.path[j-1]=totalpath.FilePath[k-1]))
         or((j>1) and (searchpath+'/'+pathstr.path[j-1]=totalpath.FilePath[k-1]))then
          begin
           if(fs.fsname<=filesystem_fat16) then
           fatpos:=genfs_fat_location_of_file_info(fs,totalpath.FileMainPos[k-1],
           totalpath.FileSubPos[k-1],1)
           else
           fatpos:=genfs_fat_location_of_file_info(fs,totalpath.FileMainPos[k-1],
           totalpath.FileSubPos[k-1],totalpath.FileStructSize[k-1]);
           PosInFile:=genfs_fat_cluster_to_file_position(fs,fatpos.MainPos)+
           (fatpos.SubPos-1) shl 5;
           genfs_io_read(fs,copycontent,PosInFile,sizeof(fat_directory_structure));
           if((fs.fsname<=filesystem_fat16) and
           (fat_get_file_class(Pfat_directory_structure(@copycontent)^.directoryattribute,false)
           and fat_directory_directory=fat_directory_directory)) or
           ((fs.fsname=filesystem_fat32) and
           (fat_get_file_class(Pfat_directory_structure(@copycontent)^.directoryattribute,
           totalpath.FileStructSize[k-1]>1) and fat_directory_directory=fat_directory_directory)) then
            begin
             CurCluster:=Pfat_directory_structure(@copycontent)^.directoryfirstclusterhighword shl 16
             +Pfat_directory_structure(@copycontent)^.directoryfirstclusterlowword;
            end
           else if((fs.fsname=filesystem_fat32) and
           (fat_get_file_class(Pfat_directory_structure(@copycontent)^.directoryattribute,
           totalpath.FileStructSize[k-1]>1) and fat_directory_file=fat_directory_file)) or
           ((fs.fsname<=filesystem_fat16) and
           (fat_get_file_class(Pfat_directory_structure(@copycontent)^.directoryattribute,false)
           and fat_directory_file=fat_directory_file)) then
            begin
             break;
            end;
           break;
          end
         else if(genfs_check_prefix(searchpath,totalpath.FilePath[k-1],true)) then
          begin
           if(j>1) then HavePrevNext:=true;
           if(fs.fsname<=filesystem_fat16) then
           fatpos:=genfs_fat_location_of_file_info(fs,totalpath.FileMainPos[k-1],
           totalpath.FileSubPos[k-1],1)
           else if(fs.fsname=filesystem_fat32) then
           fatpos:=genfs_fat_location_of_file_info(fs,totalpath.FileMainPos[k-1],
           totalpath.FileSubPos[k-1],totalpath.FileStructSize[k-1]);
          end;
         inc(k);
        end;
       if(k<=totalpath.count) then
        begin
         PrevCluster:=CurCluster;
         if(searchpath='/') or (searchpath='\') then searchpath:=searchpath+pathstr.path[j-1]
         else searchpath:=searchpath+'/'+pathstr.path[j-1];
         inc(j);
         continue;
        end
       else if(HavePrevNext=false) then
        begin
         FATAlist:=genfs_fat_get_available_cluster(fs,1);
         if(FATAlist.count=0) then
          begin
           writeln('ERROR:File System cannot allocate more cluster to new information.');
           readln;
           abort;
          end;
         CurCluster:=FATAlist.index[0];
         fatpos.MainPos:=CurCluster; fatpos.SubPos:=0;
        end;
       if(j>1) and (HavePrevNext=false) then
        begin
         fatstr:=fat_PWideCharToFatString('.');
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory,
         genfs_date_to_fat_date,genfs_time_to_fat_time,0,CurCluster);
         PosInFile:=genfs_fat_cluster_to_file_position(fs,CurCluster);
         genfs_io_write(fs,fatdir,PosInFile,sizeof(fat_directory_structure));
         fatstr:=fat_PWideCharToFatString('..');
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory,
         genfs_date_to_fat_date,genfs_time_to_fat_time,0,PrevCluster);
         PosInFile:=genfs_fat_cluster_to_file_position(fs,CurCluster)+sizeof(fat_directory_structure);
         genfs_io_write(fs,fatdir,PosInFile,sizeof(fat_directory_structure));
         if(fs.fsname<=filesystem_fat12) then fatentry.entry12:=fat12_final_cluster_low
         else if(fs.fsname<=filesystem_fat16) then fatentry.entry16:=fat16_final_cluster_low
         else if(fs.fsname<=filesystem_fat32) then fatentry.entry32:=fat32_final_cluster_low;
         genfs_fat_write_entry(fs,fatentry,CurCluster);
         if(fs.fsname=filesystem_fat32) then
          begin
           dec(fs.fat32.fsinfo.freecount,1);
           FATAlist:=genfs_fat_get_available_cluster(fs,1);
           if(FATAlist.count=0) then
            begin
             writeln('ERROR:File System cannot allocate more cluster to new information.');
             readln;
             abort;
            end;
           fs.fat32.fsinfo.nextfree:=FATAlist.index[0];
          end;
         inc(fatpos.subpos,2);
         PrevCluster:=CurCluster;
        end;
       tempstr:=UnicodeStringToPWideChar(pathstr.path[j-1]);
       fatstr:=fat_PWideCharToFatString(tempstr);
       if(srcpath.FileClass[i-1] and fat_directory_file=fat_directory_file) and (j=pathstr.count) then
       tempsize:=genfs_fat_get_file_size(fs,srcpath.FilePath[i-1])
       else tempsize:=0;
       if(fs.fsname<=filesystem_fat16) then
       fatposlist:=genfs_fat_location_of_next_directory_list(fs,fatpos.MainPos,fatpos.SubPos,1)
       else
       fatposlist:=genfs_fat_location_of_next_directory_list(fs,fatpos.MainPos,fatpos.SubPos,
       fat_calculate_directory_size(tempstr) shr 5);
       if(fatstr.unicodefn<>nil) then
        begin
         FreeMem(fatstr.unicodefn); fatstr.unicodefn:=nil; fatstr.unicodefncount:=0;
        end;
       {Generate new cluster for File System}
       FATAlist.count:=0;
       if(fatpos.MainPos<>fatposlist.item[0].MainPos) and (j=1) then
       FATAlist:=genfs_fat_get_available_cluster(fs,fatposlist.count+2)
       else if(j=1) then
       FATAlist:=genfs_fat_get_available_cluster(fs,fatposlist.count+1)
       else if(fatpos.MainPos<>fatposlist.item[0].MainPos) then
       FATAlist:=genfs_fat_get_available_cluster(fs,fatposlist.count+1)
       else
       FATAlist:=genfs_fat_get_available_cluster(fs,fatposlist.count);
       if(FATAlist.count>0) then
        begin
         CurCluster:=FATAlist.index[FATAlist.count-1];
         if(fs.fsname=filesystem_fat32) then
          begin
           dec(fs.fat32.fsinfo.freecount,fatposlist.count);
           fs.fat32.fsinfo.nextfree:=FATAlist.index[FATAlist.count-1];
          end;
        end
       else
        begin
         writeln('ERROR:File System cannot allocate more cluster to new information.');
         readln;
         abort;
        end;
       if(fs.fsname<=filesystem_fat16) or (fatstr.unicodefncount=0) then
        begin
         if(srcpath.FileClass[i-1] and fat_directory_file=fat_directory_file) and (j=pathstr.count)
         and (genfs_fat_get_file_size(fs,srcpath.FilePath[i-1])=0) then
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file,
         genfs_date_to_fat_date,genfs_time_to_fat_time,tempsize,0)
         else if(srcpath.FileClass[i-1] and fat_directory_file=fat_directory_file) and (j=pathstr.count) then
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file,
         genfs_date_to_fat_date,genfs_time_to_fat_time,tempsize,CurCluster)
         else
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file,
         genfs_date_to_fat_date,genfs_time_to_fat_time,0,CurCluster);
        end
       else
        begin
         if(srcpath.FileClass[i-1] and fat_directory_file=fat_directory_file) and (j=pathstr.count)
         and (genfs_fat_get_file_size(fs,srcpath.FilePath[i-1])=0) then
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file or fat_directory_long,
         genfs_date_to_fat_date,genfs_time_to_fat_time,tempsize,CurCluster)
         else if(srcpath.FileClass[i-1] and fat_directory_file=fat_directory_file) and (j=pathstr.count) then
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file or fat_directory_long,
         genfs_date_to_fat_date,genfs_time_to_fat_time,tempsize,CurCluster)
         else
         fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file or fat_directory_long,
         genfs_date_to_fat_date,genfs_time_to_fat_time,0,CurCluster);
        end;
       {Add File Information to the System}
       if(j>1) and (HavePrevNext=false) then
        begin
         inc(totalpath.Count);
         SetLength(totalpath.FileClass,totalpath.count);
         totalpath.FileClass[totalpath.count-1]:=fat_directory_directory;
         SetLength(totalpath.FilePath,totalpath.count);
         if(searchpath='/') or (searchpath='\') then
         totalpath.FilePath[totalpath.count-1]:=SearchPath+'.'
         else
         totalpath.FilePath[totalpath.count-1]:=SearchPath+'/.';
         SetLength(totalpath.FileMainPos,totalpath.count);
         totalpath.FileMainPos[totalpath.count-1]:=fatpos.MainPos;
         SetLength(totalpath.FileSubPos,totalpath.count);
         totalpath.FileSubPos[totalpath.count-1]:=0;
         SetLength(totalpath.FileShortStr,totalpath.count);
         totalpath.FileShortStr[totalpath.count-1]:='.';
         if(fs.fsname=filesystem_fat32) then
          begin
           SetLength(totalpath.FileStructSize,totalpath.count);
           totalpath.FileStructSize[totalpath.count-1]:=1;
          end;
         inc(totalpath.Count);
         SetLength(totalpath.FileClass,totalpath.count);
         totalpath.FileClass[totalpath.count-1]:=fat_directory_directory;
         SetLength(totalpath.FilePath,totalpath.count);
         if(searchpath='/') or (searchpath='\') then
         totalpath.FilePath[totalpath.count-1]:=SearchPath+'..'
         else
         totalpath.FilePath[totalpath.count-1]:=SearchPath+'/..';
         SetLength(totalpath.FileMainPos,totalpath.count);
         totalpath.FileMainPos[totalpath.count-1]:=fatpos.MainPos;
         SetLength(totalpath.FileSubPos,totalpath.count);
         totalpath.FileSubPos[totalpath.count-1]:=1;
         SetLength(totalpath.FileShortStr,totalpath.count);
         totalpath.FileShortStr[totalpath.count-1]:='..';
         if(fs.fsname=filesystem_fat32) then
          begin
           SetLength(totalpath.FileStructSize,totalpath.count);
           totalpath.FileStructSize[totalpath.count-1]:=1;
          end;
         inc(totalpath.FilePrevNextCount,2);
        end;
       inc(totalpath.count);
       SetLength(totalpath.FilePath,totalpath.count);
       SetLength(totalpath.FileClass,totalpath.count);
       SetLength(totalpath.FileMainPos,totalpath.count);
       SetLength(totalpath.FileSubPos,totalpath.count);
       SetLength(totalpath.FileShortStr,totalpath.count);
       if(fs.fsname=filesystem_fat32) then SetLength(totalpath.FileStructSize,totalpath.count);
       if(fs.fsname=filesystem_fat32) and (fatdir.longdircount>0) then
        begin
         if(j=pathstr.Count) and (srcpath.FileClass[i-1] and fat_directory_file=fat_directory_file) then
         totalpath.FileClass[totalpath.count-1]:=fat_directory_file or fat_directory_long
         else
         totalpath.FileClass[totalpath.count-1]:=fat_directory_directory or fat_directory_long;
         if(searchpath='/') or (searchpath='\') then
         totalpath.FilePath[totalpath.count-1]:=searchpath+pathstr.path[j-1]
         else
         totalpath.FilePath[totalpath.count-1]:=searchpath+'/'+pathstr.path[j-1];
         totalpath.FileMainPos[totalpath.count-1]:=fatpos.MainPos;
         totalpath.FileSubPos[totalpath.count-1]:=fatpos.SubPos;
         totalpath.FileShortStr[totalpath.count-1]:=genfs_fat_extract_short_name(fatdir.dir);
         totalpath.FileStructSize[totalpath.count-1]:=fatdir.longdircount+1;
        end
       else
        begin
         if(j=pathstr.count) and (srcpath.FileClass[i-1] and fat_directory_file=fat_directory_file) then
         totalpath.FileClass[totalpath.count-1]:=fat_directory_file
         else
         totalpath.FileClass[totalpath.count-1]:=fat_directory_directory;
         if(searchpath='/') or (searchpath='\') then
         totalpath.FilePath[totalpath.count-1]:=searchpath+pathstr.path[j-1]
         else
         totalpath.FilePath[totalpath.count-1]:=searchpath+'/'+pathstr.path[j-1];
         totalpath.FileMainPos[totalpath.count-1]:=fatpos.MainPos;
         totalpath.FileSubPos[totalpath.count-1]:=fatpos.SubPos;
         totalpath.FileShortStr[totalpath.count-1]:=genfs_fat_extract_short_name(fatdir.dir);
         if(fs.fsname=filesystem_fat32) then totalpath.FileStructSize[totalpath.count-1]:=1;
        end;
       {Generate the missing directory}
       n:=1;
       for k:=1 to fatposlist.count do
        begin
         if(k<fatposlist.count) then
          begin
           if(fs.fsname=filesystem_fat12) then
           fatentry.entry12:=fatposlist.item[k].MainPos
           else if(fs.fsname=filesystem_fat16) then
           fatentry.entry16:=fatposlist.item[k].MainPos
           else if(fs.fsname=filesystem_fat32) then
           fatentry.entry32:=fatposlist.item[k].MainPos;
           genfs_fat_write_entry(fs,fatentry,fatposlist.item[k-1].MainPos);
          end
         else
          begin
           if(fs.fsname=filesystem_fat12) then
           fatentry.entry12:=fat12_final_cluster_low
           else if(fs.fsname=filesystem_fat16) then
           fatentry.entry16:=fat16_final_cluster_low
           else if(fs.fsname=filesystem_fat32) then
           fatentry.entry32:=fat32_final_cluster_low;
           genfs_fat_write_entry(fs,fatentry,fatposlist.item[k-1].MainPos);
          end;
         for m:=1 to fatposlist.size[k-1] do
          begin
           PosInFile:=genfs_fat_cluster_to_file_position(fs,fatposlist.item[k-1].MainPos)+
           (fatposlist.item[k-1].SubPos+m-1) shl 5;
           if(fs.fsname=filesystem_fat32) and (fatdir.longdircount>0) then
           genfs_io_write(fs,(fatdir.longdir+n-1)^,PosInFile,sizeof(fat_long_directory_structure))
           else
           genfs_io_write(fs,fatdir.dir,PosInFile,sizeof(fat_directory_structure));
           inc(n);
          end;
        end;
       {Check the source item is directory or file}
       if(j=pathstr.count) and (srcpath.FileClass[i-1] and fat_directory_file=fat_directory_file) then
        begin
         {Get the file Storage Position}
         BytePerSector:=fs.fat12.header.head.bpb_bytesPerSector;
         SectorPerCluster:=fs.fat12.header.head.bpb_SectorPerCluster;
         tempcluster:=genfs_fat_get_file_cluster(fs,srcpath.FilePath[i-1]);
         tempsize:=genfs_fat_get_file_size(fs,srcpath.FilePath[i-1]);
         FATUlist:=genfs_fat_get_using_cluster(fs,tempcluster);
         tempsize:=genfs_fat_get_file_size(fs,srcpath.FilePath[i-1]);
         FATAlist:=genfs_fat_get_available_cluster(fs,
         (tempsize+BytePerSector*SectorPerCluster-1) div (BytePerSector*SectorPerCluster)+1);
         {Copy the file into destination}
         if(FATAlist.count=(tempsize+BytePerSector*SectorPerCluster-1)
         div (BytePerSector*SectorPerCluster)) then
         n:=FATAlist.count+1
         else if(FATAlist.count=(tempsize+BytePerSector*SectorPerCluster-1)
         div (BytePerSector*SectorPerCluster)+1) then
         n:=FATAlist.count
         else
          begin
           writeln('ERROR:Out of disk free space.');
           readln;
           abort;
          end;
         Ptr1:=0; Ptr2:=0;
         for k:=1 to n-1 do
          begin
           Ptr1:=genfs_fat_cluster_to_file_position(fs,FATUlist.index[k-1]);
           Ptr2:=genfs_fat_cluster_to_file_position(fs,FATAlist.index[k-1]);
           if(k<n-1) then
            begin
             if(fs.fsname=filesystem_fat12) then
             FATentry.entry12:=FATAlist.index[k]
             else if(fs.fsname=filesystem_fat16) then
             FATentry.entry16:=FATAlist.index[k]
             else if(fs.fsname=filesystem_fat32) then
             FATentry.entry32:=FATAlist.index[k];
             genfs_fat_write_entry(fs,FATentry,FATAlist.index[k-1]);
            end
           else
            begin
             if(fs.fsname=filesystem_fat12) then
             FATentry.entry12:=fat12_final_cluster_low
             else if(fs.fsname=filesystem_fat16) then
             FATentry.entry16:=fat16_final_cluster_low
             else if(fs.fsname=filesystem_fat32) then
             FATentry.entry32:=fat32_final_cluster_low;
             genfs_fat_write_entry(fs,FATentry,FATAlist.index[k-1]);
            end;
           for m:=1 to (BytePerSector*SectorPerCluster) shr 9 do
            begin
             if(tempsize>=1 shl 9)then
              begin
               genfs_io_read(fs,copycontent,Ptr1+(m-1) shl 9,1 shl 9);
               genfs_io_write(fs,copycontent,Ptr2+(m-1) shl 9,1 shl 9);
              end
             else if(tempsize>0) then
              begin
               genfs_io_read(fs,copycontent,Ptr1+(m-1) shl 9,tempsize);
               genfs_io_write(fs,copycontent,Ptr2+(m-1) shl 9,tempsize);
               tempsize:=0;
               break;
              end;
             dec(tempsize,1 shl 9);
            end;
          end;
        end;
      end;
     if(searchpath='/') or (searchpath='\') then searchpath:=searchpath+pathstr.path[j-1]
     else searchpath:=searchpath+'/'+pathstr.path[j-1];
     inc(j);
    end;
  end;
 genfs_filesystem_write_info(fs);
 if(fs.fsname<=filesystem_fat32) then genfs_fat_rename(fs);
end;
{File System File Compare Operation inside}
function genfs_filesystem_compare(fs:genfs_filesystem;basedir,comparedir:UnicodeString):boolean;
var totalpath,basepath,comparepath:genfs_inner_path;
    baserootpath,comparerootpath:UnicodeString;
    temppath1,temppath2:UnicodeString;
    baseismask,compareismask:boolean;
    i,j,k,m,len1,len2:SizeUint;
    comparecontent1,comparecontent2:array[1..512] of byte;
    tempsize1,tempsize2:SizeUint;
    FileInPos1,FileInPos2:SizeUint;
    BytePerSector,SectorPerCluster:SizeUint;
{For FAT Only}
    PtrCluster1,PtrCluster2:SizeUint;
    FATUlist1,FATUlist2:genfs_fat_cluster_list;
begin
 totalpath:=genfs_filesystem_search_for_path(fs);
 basepath.count:=0;
 baseismask:=genfs_is_mask(basedir);
 if(baseismask) then
 baserootpath:=genfs_extract_search_path_without_wildcard(basedir)
 else
 baserootpath:=genfs_extract_file_path(basedir);
 len1:=length(baserootpath);
 comparepath.count:=0;
 compareismask:=genfs_is_mask(comparedir);
 if(compareismask) then
 comparerootpath:=genfs_extract_search_path_without_wildcard(comparedir)
 else
 comparerootpath:=genfs_extract_file_path(comparedir);
 len2:=length(comparerootpath);
 i:=1;
 while(i<=totalpath.count)do
  begin
   if((baseismask) and (genfs_mask_match(basedir,totalpath.FilePath[i-1])))
   or(genfs_check_prefix(basedir,totalpath.FilePath[i-1]))then
    begin
     inc(basepath.count);
     SetLength(basepath.FilePath,basepath.count);
     basepath.FilePath[basepath.count-1]:=totalpath.FilePath[i-1];
     SetLength(basepath.FileSubPos,basepath.Count);
     basepath.FileSubPos[basepath.count-1]:=totalpath.FileSubPos[i-1];
     SetLength(basepath.FileMainPos,basepath.count);
     basepath.FileMainPos[basepath.count-1]:=totalpath.FileMainPos[i-1];
     SetLength(basepath.FileClass,basepath.count);
     basepath.FileClass[basepath.count-1]:=totalpath.FileClass[i-1];
     if(fs.fsname<=filesystem_fat32) then
      begin
       SetLength(basepath.FileShortStr,basepath.count);
       basepath.FileShortStr[basepath.count-1]:=totalpath.FileShortStr[i-1];
      end;
     if(fs.fsname=filesystem_fat32) then
      begin
       SetLength(basepath.FileStructSize,basepath.count);
       basepath.FileStructSize[basepath.count-1]:=totalpath.FileStructSize[i-1];
      end;
    end;
   if((compareismask) and (genfs_mask_match(comparedir,totalpath.FilePath[i-1])))
   or(genfs_check_prefix(basedir,totalpath.FilePath[i-1]))then
    begin
     inc(comparepath.count);
     SetLength(comparepath.FilePath,comparepath.count);
     comparepath.FilePath[comparepath.count-1]:=totalpath.FilePath[i-1];
     SetLength(comparepath.FileSubPos,comparepath.Count);
     comparepath.FileSubPos[comparepath.count-1]:=totalpath.FileSubPos[i-1];
     SetLength(comparepath.FileMainPos,comparepath.count);
     comparepath.FileMainPos[comparepath.count-1]:=totalpath.FileMainPos[i-1];
     SetLength(comparepath.FileClass,comparepath.count);
     comparepath.FileClass[comparepath.count-1]:=totalpath.FileClass[i-1];
     if(fs.fsname<=filesystem_fat32) then
      begin
       SetLength(comparepath.FileShortStr,comparepath.count);
       comparepath.FileShortStr[comparepath.count-1]:=totalpath.FileShortStr[i-1];
      end;
     if(fs.fsname=filesystem_fat32) then
      begin
       SetLength(comparepath.FileStructSize,comparepath.count);
       comparepath.FileStructSize[comparepath.count-1]:=totalpath.FileStructSize[i-1];
      end;
    end;
   inc(i);
  end;
 {Check whether the directory path is same}
 if(basedir=comparedir) then exit(false)
 else if(basepath.Count<>comparepath.Count) then exit(false);
 {Compare the directory's filename}
 i:=1;
 while(i<=basepath.count)do
  begin
   if(baserootpath='') then
   temppath1:=basepath.FilePath[i-1]
   else
   temppath1:=Copy(basepath.FilePath[i-1],len1+2,length(basepath.FilePath[i-1])-len1-1);
   if(comparerootpath='') then
   temppath2:=comparepath.FilePath[i-1]
   else
   temppath2:=Copy(comparepath.FilePath[i-1],len2+2,length(comparepath.FilePath[i-1])-len2-1);
   if(temppath1<>temppath2) then break
   else if(fs.fsname<=filesystem_fat32) and
   (basepath.FileClass[i-1] and fat_directory_file=fat_directory_file)
   and(comparepath.FileClass[i-1] and fat_directory_file=fat_directory_file) then
    begin
     {If the same path pointed the file name in same relative path,compare the content}
     BytePerSector:=fs.fat12.header.head.bpb_bytesPerSector;
     SectorPerCluster:=fs.fat12.header.head.bpb_SectorPerCluster;
     PtrCluster1:=genfs_fat_get_file_cluster(fs,basepath.FilePath[i-1]);
     PtrCluster2:=genfs_fat_get_file_cluster(fs,comparepath.FilePath[i-1]);
     tempsize1:=genfs_fat_get_file_size(fs,basepath.FilePath[i-1]);
     tempsize2:=genfs_fat_get_file_size(fs,comparepath.FilePath[i-1]);
     FATUlist1:=genfs_fat_get_using_cluster(fs,PtrCluster1);
     FATUlist2:=genfs_fat_get_using_cluster(fs,PtrCluster2);
     if(FATUList1.count<>FATUlist2.count) or (tempsize1<>tempsize2) then break
     else
      begin
       j:=1;
       while(j<=FATUlist1.count)do
        begin
         PtrCluster1:=FATUlist1.index[j-1]; PtrCluster2:=FATUlist2.index[j-1];
         k:=1;
         FileInPos1:=genfs_fat_cluster_to_file_position(fs,PtrCluster1);
         FileInPos2:=genfs_fat_cluster_to_file_position(fs,PtrCluster2);
         while(k<=(BytePerSector*SectorPerCluster) shr 9)do
          begin
           if(tempsize1>=1 shl 9) then
            begin
             genfs_io_read(fs,comparecontent1,FileInPos1+(k-1) shl 9,1 shl 9);
             genfs_io_read(fs,comparecontent2,FileInPos2+(k-1) shl 9,1 shl 9);
             m:=1;
             while(m<=1 shl 9) do
              begin
               if(comparecontent1[m]<>comparecontent2[m]) then break;
               inc(m);
              end;
             if(m<=1 shl 9) then break;
            end
           else
            begin
             genfs_io_read(fs,comparecontent1,FileInPos1+(k-1) shl 9,tempsize1);
             genfs_io_read(fs,comparecontent2,FileInPos2+(k-1) shl 9,tempsize1);
             m:=1;
             while(m<=tempsize1) do
              begin
               if(comparecontent1[m]<>comparecontent2[m]) then break;
               inc(m);
              end;
             if(m<=tempsize1) then break;
            end;
           inc(k);
          end;
         if(k<=(BytePerSector*SectorPerCluster) shr 9) then break;
         dec(tempsize1,1 shl 9); dec(tempsize2,1 shl 9);
         inc(j);
        end;
       if(j<=FATUlist1.count) then break;
      end;
    end;
   inc(i);
  end;
 if(i>basepath.count) then Result:=true else Result:=false;
end;
{File System File Compare Operation outside}
function genfs_filesystem_compare_external(fs:genfs_filesystem;basedir,extdir:UnicodeString):boolean;
var innerpath:genfs_inner_path;
    extpath:genfs_path;
    innerrootpath,extrootpath,temppath1,temppath2:UnicodeString;
    compcontent1,compcontent2:array[1..128] of dword;
    len1,len2,i,j,k,m,n,templen1,templen2:SizeUint;
    tempsize1,tempsize2:SizeUint;
    PosInFile:SizeUint;
    PosInExtFile:SizeUint;
    BytePerSector,SectorPerCluster:SizeUint;
{For FAT Only}
    CurCluster:SizeUint;
    FATUlist:genfs_fat_cluster_list;
begin
 innerpath:=genfs_filesystem_search_for_path(fs,basedir);
 extpath:=genfs_external_search_for_path(extdir);
 if(innerpath.Count-innerpath.FilePrevNextCount<>extpath.count) then exit(false)
 else
  begin
   if(genfs_is_mask(basedir)) then
   innerrootpath:=genfs_extract_search_path_without_wildcard(basedir)
   else
   innerrootpath:=genfs_extract_file_path(basedir);
   len1:=length(innerrootpath);
   if(genfs_is_mask(extdir)) then
   extrootpath:=genfs_extract_search_path_without_wildcard(extdir)
   else
   extrootpath:=genfs_extract_file_path(extdir);
   len2:=length(extrootpath);
   i:=1; j:=1;
   while(i<=innerpath.count)do
    begin
     templen1:=length(innerpath.FilePath[i-1]);
     if(Copy(innerpath.FilePath[i-1],templen1-1,3)='/..')
     or(Copy(innerpath.FilePath[i-1],templen1-1)='/.')
     or(Copy(innerpath.FilePath[i-1],templen1-1,3)='\..')
     or(Copy(innerpath.FilePath[i-1],templen1-1)='\.') then
      begin
       inc(i); continue;
      end;
     templen2:=length(extpath.FilePath[j-1]);
     if(innerrootpath='') then temppath1:=innerpath.FilePath[i-1]
     else temppath1:=Copy(innerpath.FilePath[i-1],len1+2,templen1-len1-1);
     if(extrootpath='') then temppath2:=extpath.FilePath[j-1]
     else temppath2:=Copy(extpath.FilePath[j-1],len2+2,templen2-len2+1);
     if(temppath1<>temppath2) then break
     else if(fs.fsname<=filesystem_fat32)
     and(innerpath.FileClass[i-1] and fat_directory_file=fat_directory_file)
     and(extpath.IsFile[j-1]) then
      begin
       BytePerSector:=fs.fat12.header.head.bpb_bytesPerSector;
       SectorPerCluster:=fs.fat12.header.head.bpb_SectorPerCluster;
       tempsize1:=genfs_fat_get_file_size(fs,innerpath.FilePath[i-1]);
       tempsize2:=genfs_external_file_size(extpath.FilePath[j-1]);
       if(tempsize1<>tempsize2) then break;
       {Compare the File Content}
       CurCluster:=genfs_fat_get_file_cluster(fs,innerpath.FilePath[i-1]);
       FATUlist:=genfs_fat_get_using_cluster(fs,CurCluster);
       PosInExtFile:=0; PosInFile:=genfs_fat_cluster_to_file_position(fs,CurCluster);
       k:=1;
       while(k<=FATUlist.Count)do
        begin
         PosInFile:=genfs_fat_cluster_to_file_position(fs,FATUlist.index[k-1]);
         m:=1;
         while(m<=(BytePerSector*SectorPerCluster) shr 9) do
          begin
           if(tempsize1>=1 shl 9) then
            begin
             genfs_external_io_read(extpath.FilePath[j-1],compcontent1,PosInExtFile+(m-1) shl 9,1 shl 9);
             genfs_io_read(fs,compcontent2,PosInFile+(m-1) shl 9,1 shl 9);
             n:=1;
             while(n<=1 shl 9)do
              begin
               if(compcontent1[n]<>compcontent2[n]) then break;
               inc(n);
              end;
             if(n<=1 shl 9) then break;
            end
           else if(tempsize1<1 shl 9) then
            begin
             genfs_external_io_read(extpath.FilePath[j-1],compcontent1,PosInExtFile+(m-1) shl 9,tempsize1);
             genfs_io_read(fs,compcontent2,PosInFile+(m-1) shl 9,tempsize1);
             n:=1;
             while(n<=tempsize1)do
              begin
               if(compcontent1[n]<>compcontent2[n]) then break;
               inc(n);
              end;
             if(n<=tempsize1) then break;
            end;
           inc(PosInExtFile,1 shl 9);
           inc(m);
          end;
         if(m<=(BytePerSector*SectorPerCluster) shr 9) then break;
         inc(k); dec(tempsize1,1 shl 9); dec(tempsize2,1 shl 9);
        end;
       if(k<=FATUlist.count) then break;
      end;
     inc(i); inc(j);
    end;
   if(i<=innerpath.count) then Result:=true else Result:=false;
  end;
end;
{FAT File System Erase Cluster}
procedure genfs_fat_erase_cluster(var fs:genfs_filesystem;clusterindex:SizeUint);
var content:array[1..512] of byte;
    i:SizeUint;
    BytePerSector,SectorPerCluster:SizeUint;
    PosInFile:SizeUint;
begin
 BytePerSector:=fs.fat12.header.head.bpb_bytesPerSector;
 SectorPerCluster:=fs.fat12.header.head.bpb_SectorPerCluster;
 for i:=1 to 512 do content[i]:=0;
 PosInFile:=genfs_fat_cluster_to_file_position(fs,clusterindex);
 i:=1;
 while(i<=(BytePerSector*SectorPerCluster) shr 9)do
  begin
   genfs_io_write(fs,content,PosInFile+(i-1) shl 9,1 shl 9);
  end;
 if(fs.fsname=filesystem_fat32) and (Clusterindex<=fs.fat32.fsinfo.nextfree) then
 fs.fat32.fsinfo.nextfree:=clusterindex;
 if(fs.fsname=filesystem_fat32) then inc(fs.fat32.fsinfo.freecount);
end;
{FAT File System Move List,Only Move to left}
procedure genfs_fat_move_directory(var fs:genfs_filesystem;rootdir:UnicodeString;
MoveStart:genfs_fat_position_info;MoveEnd:genfs_fat_position_info;
MoveStep:SizeUint);
var FATUlist:genfs_fat_cluster_list;
    StartCluster,i:SizeUint;
    StartPos,StartOffset,Startindex:SizeUint;
    EndPos,EndOffset,endindex:SizeUint;
    MoveIndex,MoveOffset,MoveInterval:SizeUint;
    BytePerSector,SectorPerCluster:SizeUint;
    testbyte:byte=0;
    PosInFile:SizeUint;
    PosInFile1:SizeUint;
    PosInFile2:SizeUint;
    FATentry:fat_entry;
begin
 BytePerSector:=fs.fat12.header.head.bpb_bytesPerSector;
 SectorPerCluster:=fs.fat12.header.head.bpb_SectorPerCluster;
 {Initialization of function}
 StartCluster:=genfs_fat_get_file_cluster(fs,rootdir);
 FATUlist:=genfs_fat_get_using_cluster(fs,StartCluster);
 StartPos:=MoveStart.MainPos; StartOffset:=MoveStart.SubPos;
 EndPos:=MoveEnd.MainPos; EndOffset:=MoveEnd.SubPos;
 {Get the Startindex and Endindex in FATUList}
 i:=1;
 while(i<=FATUList.count)do
  begin
   if(StartPos=FATUlist.index[i-1]) then break;
   inc(i);
  end;
 StartIndex:=i;
 i:=1;
 while(i<=FATUList.count)do
  begin
   if(EndPos=FATUlist.index[i-1]) then break;
   inc(i);
  end;
 EndIndex:=i;
 {Then ignore StartPos and EndPos,And Get the first move destination}
 MoveIndex:=startindex; MoveOffset:=startoffset; MoveInterval:=MoveStep;
 while(MoveInterval>0)do
  begin
   if(Moveoffset>0) then dec(MoveOffset)
   else
    begin
     MoveOffset:=(BytePerSector*SectorPerCluster) shr 5;
     dec(MoveIndex);
    end;
   dec(MoveInterval);
  end;
 {The Move the directory}
 while(MoveInterval<=MoveStep)do
  begin
   PosInFile1:=genfs_fat_cluster_to_file_position(fs,FATUlist.index[MoveIndex-1])
   +(MoveOffset-1) shl 5;
   PosInFile2:=genfs_fat_cluster_to_file_position(fs,FATUlist.index[MoveIndex-1])
   +(StartOffset-1) shl 5;
   genfs_io_move(fs,PosInFile1,PosInFile2,sizeof(fat_directory_structure));
   if(Moveoffset<(BytePerSector*SectorPerCluster) shr 5) then inc(MoveOffset)
   else
    begin
     MoveOffset:=0; inc(MoveIndex);
    end;
   if(StartOffset<(BytePerSector*SectorPerCluster) shr 5) then inc(StartOffset)
   else
    begin
     StartOffset:=0; inc(StartIndex);
    end;
   if(Startindex=EndIndex) and (StartOffset>=EndOffset-1) then break;
   inc(MoveInterval);
  end;
 {Detect the directory is vaild or not}
 i:=FATUlist.count;
 while(i>0)do
  begin
   PosInFile:=genfs_fat_cluster_to_file_position(fs,FATUList.index[i-1]);
   genfs_io_read(fs,testbyte,PosInFile,1);
   if(testbyte=0) and (i>1) then
    begin
     if(fs.fsname=filesystem_fat32) then
      begin
       inc(fs.fat32.fsinfo.freecount,1);
       fs.fat32.fsinfo.nextfree:=FATUlist.index[i-1];
      end;
     fatentry.entry32:=0;
     genfs_fat_write_entry(fs,fatentry,FATUList.index[i-1]);
     if(fs.fsname=filesystem_fat12) then
     fatentry.entry12:=fat12_final_cluster_low
     else if(fs.fsname=filesystem_fat16) then
     fatentry.entry16:=fat16_final_cluster_low
     else if(fs.fsname=filesystem_fat32) then
     fatentry.entry32:=fat32_final_cluster_low;
     genfs_fat_write_entry(fs,fatentry,FATUList.index[i-2]);
    end
   else if(testbyte=0) and (i=1) then
    begin
     if(fs.fsname=filesystem_fat32) then
      begin
       inc(fs.fat32.fsinfo.freecount,1);
       fs.fat32.fsinfo.nextfree:=FATUlist.index[i-1];
      end;
     if(fs.fsname=filesystem_fat12) then
     fatentry.entry12:=0
     else if(fs.fsname=filesystem_fat16) then
     fatentry.entry16:=0
     else if(fs.fsname=filesystem_fat32) then
     fatentry.entry32:=0;
     genfs_fat_write_entry(fs,fatentry,FATUList.index[i-1]);
    end;
  end;
 genfs_filesystem_write_info(fs);
end;
{File System File Delete Operation}
procedure genfs_filesystem_delete(var fs:genfs_filesystem;deldir:UnicodeString;erase:boolean=false);
var temppath:genfs_inner_path;
    delismask:boolean;
    delrootdir,tempdir:UnicodeString;
    i,j,k,dellen,templen:SizeUint;
    PosInFile:SizeUint;
{For FAT FileSystem Only}
    FATUList:genfs_fat_cluster_list;
    StartCluster:SizeUint;
    StartPos,EndPos:genfs_fat_position_info;
begin
 temppath:=genfs_filesystem_search_for_path(fs,deldir);
 delismask:=genfs_is_mask(deldir);
 if(delismask) then
  begin
   delrootdir:=genfs_extract_search_path_without_wildcard(deldir); dellen:=length(delrootdir)+1;
   StartCluster:=genfs_fat_get_file_cluster(fs,delrootdir);
  end
 else
  begin
   delrootdir:=genfs_extract_file_path(deldir); dellen:=length(delrootdir)+1;
   StartCluster:=genfs_fat_get_file_cluster(fs,delrootdir);
  end;
 i:=temppath.count;
 while(i>0)do
  begin
   templen:=length(temppath.FilePath[i-1]);
   if(Copy(temppath.FilePath[i-1],templen-2,3)='/..') or
   (Copy(temppath.FilePath[i-1],templen-2,3)='/.') or
   (Copy(temppath.FilePath[i-1],templen-2,3)='\..') or
   (Copy(temppath.FilePath[i-1],templen-2,3)='\.') then
    begin
     dec(i); continue;
    end;
   if(fs.fsname<=filesystem_fat32) then
    begin
     if((delismask) and (genfs_mask_match(deldir,temppath.FilePath[i-1])))
     or(genfs_check_prefix(deldir,temppath.FilePath[i-1]))then
      begin
       StartCluster:=genfs_fat_get_file_cluster(fs,temppath.FilePath[i-1]);
       if(StartCluster>0) then
       FATUlist:=genfs_fat_get_using_cluster(fs,StartCluster)
       else
       FATUlist.count:=0;
       if(erase) then
        begin
         j:=1;
         while(j<=FATUlist.count)do
          begin
           genfs_fat_erase_cluster(fs,FATUlist.index[j-1]); dec(j);
          end;
        end;
       tempdir:=genfs_extract_file_path(temppath.FilePath[i-1]);
       StartPos.MainPos:=temppath.FileMainPos[i-1];
       StartPos.SubPos:=temppath.FileSubPos[i-1];
       if(fs.fsname=filesystem_fat32) then
        begin
         EndPos:=genfs_fat_location_of_file_info(fs,StartPos.MainPos,StartPos.SubPos,
         temppath.FileStructSize[i-1]);
         genfs_fat_move_directory(fs,tempdir,StartPos,EndPos,temppath.FileStructSize[i-1]);
        end
       else
        begin
         EndPos:=genfs_fat_location_of_file_info(fs,StartPos.MainPos,StartPos.SubPos,1);
         genfs_fat_move_directory(fs,tempdir,StartPos,EndPos,1);
        end;
      end;
    end;
   dec(i);
  end;
 genfs_filesystem_write_info(fs);
end;
{File System File Extract Operation}
procedure genfs_filesystem_extract(fs:genfs_filesystem;indir,extdir:UnicodeString);
var temppath:genfs_inner_path;
    ismask:boolean;
    rootpath,temppath2,actualpath:UnicodeString;
    i,j,k,len,len2:SizeUint;
    tempsize,fileptr:SizeUint;
    BytePerSector,SectorPerCluster:SizeUint;
    PosInFile:SizeUint;
    content:array[1..512] of byte;
{For FAT Only}
    FATUList:genfs_fat_cluster_list;
    StartCluster:SizeUint;
begin
 temppath:=genfs_filesystem_search_for_path(fs,indir);
 if(fs.fsname<=filesystem_fat32) then
  begin
   BytePerSector:=fs.fat12.header.head.bpb_bytesPerSector;
   SectorPerCluster:=fs.fat12.header.head.bpb_SectorPerCluster;
  end;
 if(DirectoryExists(extdir)=false) and (FileExists(extdir)=false) then
  begin
   writeln('ERROR:Extract Path does not exist.');
   readln;
   abort;
  end
 else
  begin
   i:=1; ismask:=genfs_is_mask(indir);
   if(ismask)then
    begin
     rootpath:=genfs_extract_search_path_without_wildcard(indir); len:=length(rootpath)+1;
    end
   else
    begin
     rootpath:=genfs_extract_file_path(indir); len:=length(rootpath)+1;
    end;
   len2:=length(extdir);
   if(extdir[len2]<>'/') and (extdir[len2]<>'\') then temppath2:=extdir+'/' else temppath2:=extdir;
   while(i<=temppath.Count)do
    begin
     actualpath:=temppath2+Copy(indir,len+1,length(temppath.FilePath[i-1])-len);
     if(fs.fsname<=filesystem_fat32) then
      begin
       if(temppath.FileClass[i-1] and fat_directory_directory=fat_directory_directory) then
       CreateDir(actualpath)
       else
        begin
         StartCluster:=genfs_fat_get_file_cluster(fs,temppath.FilePath[i-1]);
         if(StartCluster>0) then
         FATUlist:=genfs_fat_get_using_cluster(fs,startCluster)
         else
         FATUlist.count:=0;
         tempsize:=genfs_fat_get_file_size(fs,temppath.FilePath[i-1]);
         fileptr:=0;
         j:=1; k:=1;
         while(tempsize>0)do
          begin
           inc(k);
           if(k shl 9>BytePerSector*SectorPerCluster) then
            begin
             inc(j); k:=1;
            end;
           PosInFile:=genfs_fat_cluster_to_file_position(fs,FATUlist.index[j-1]);
           if(tempsize-fileptr>=1 shl 9) then
            begin
             genfs_io_read(fs,content,PosInFile+(k-1) shl 9,1 shl 9);
             genfs_external_io_write(actualpath,content,fileptr,1 shl 9);
            end
           else
            begin
             genfs_io_read(fs,content,PosInFile+(k-1) shl 9,tempsize-fileptr);
             genfs_external_io_write(actualpath,content,fileptr,tempsize-fileptr);
            end;
           if(tempsize>=1 shl 9) then
            begin
             dec(tempsize,1 shl 9); inc(fileptr,1 shl 9);
            end
           else
            begin
             tempsize:=0; inc(fileptr,tempsize);
            end;
          end;
        end;
      end;
     inc(i);
    end;
  end;
end;
{File System File Get Content}
function genfs_filesystem_get_content(fs:genfs_filesystem;reqdir:UnicodeString;
ptr:SizeUint):genfs_content;
var FileInPos:SizeUint;
    SizeOfFile:SizeUint;
{Only For FAT FileSystem}
    FATUList:genfs_fat_cluster_list;
    listindex,Cluster,Offset:SizeUInt;
    FATBPS,FATSPC:SizeUint;
begin
 if(fs.fsname<=filesystem_fat32) then
  begin
   SizeOfFile:=genfs_fat_get_file_size(fs,reqdir);
   if(SizeOfFile=0) then exit;
   fatbps:=fs.fat12.header.head.bpb_bytesPerSector;
   fatspc:=fs.fat12.header.head.bpb_SectorPerCluster;
   Cluster:=genfs_fat_get_file_cluster(fs,reqdir);
   FATUList:=genfs_fat_get_using_cluster(fs,Cluster);
   listindex:=1; offset:=0;
   while(listindex<=FATUlist.count)do
    begin
     if((listindex-1)*fatbps*fatspc shr 9+offset>=ptr) and (SizeOfFile>=1 shl 9) then
      begin
       FileInPos:=genfs_fat_cluster_to_file_position(fs,FATUList.index[listindex-1])+
       (offset-1) shl 9;
       genfs_io_read(fs,Result.content,FileInPos+(offset-1) shl 9,1 shl 9);
       Result.size:=1 shl 9; break;
      end
     else if((listindex-1)*fatbps*fatspc shr 9+offset>=ptr) and (SizeOfFile<1 shl 9) then
      begin
       FileInPos:=genfs_fat_cluster_to_file_position(fs,FATUList.index[listindex-1])+
       (offset-1) shl 9;
       genfs_io_read(fs,Result.content,FileInPos+(offset-1) shl 9,SizeOfFile);
       Result.size:=SizeOfFile; break;
      end;
     inc(offset);
     if(offset>=(fatbps*fatspc) shr 9) then
      begin
       inc(listindex); offset:=0;
      end;
     dec(SizeOfFile,1 shl 9);
    end;
  end
 else
  begin

  end;
end;
{File System File Set Content}
procedure genfs_filesystem_set_content(fs:genfs_filesystem;reqdir:UnicodeString;
ptr:SizeUint;content:genfs_content);
var SizeOfFile:SizeUint;
    FileClusterCount:SizeUint;
    FileBlockCount:SizeUint;
    PosInFile:SizeUint;
{Only for FAT FileSystem}
    FATUList,FATAlist,FATTlist:genfs_fat_cluster_list;
    listindex,Cluster,Offset:SizeUInt;
    FATpos:genfs_fat_position_info;
    sdir:fat_directory_structure;
    PathList:genfs_inner_path;
    FATBPS,FATSPC:SizeUint;
    FATentry:fat_entry;
begin
 PathList:=genfs_filesystem_search_for_path(fs,reqdir);
 if(fs.fsname<=filesystem_fat32) then
  begin
   fatbps:=fs.fat12.header.head.bpb_bytesPerSector;
   fatspc:=fs.fat12.header.head.bpb_SectorPerCluster;
   SizeOfFile:=genfs_fat_get_file_size(fs,reqdir);
   Cluster:=genfs_fat_get_file_cluster(fs,reqdir);
   if(Cluster=0) and (fs.fsname<=filesystem_fat32) then
    begin
     FATTList:=genfs_fat_get_available_cluster(fs,1);
     if(FATTlist.count=0) then
      begin
       writeln('ERROR:No Cluster available for setting content.');
       readln;
       abort;
      end;
     Cluster:=FATTlist.index[0];
    end;
   fileClusterCount:=(SizeOfFile+fatbps*fatspc-1) div (fatbps*fatspc);
   if(SizeOfFile=0) then
    begin
     FATUlist.count:=0;
     FATAlist:=genfs_fat_get_available_cluster(fs,ptr div ((fatbps*fatspc shr 9))+1);
    end
   else if(ptr<FileClusterCount*fatbps*fatspc shr 9) then
    begin
     FATUlist:=genfs_fat_get_using_cluster(fs,Cluster);
     FATAlist.count:=0;
    end
   else
    begin
     FATUlist:=genfs_fat_get_using_cluster(fs,Cluster);
     FATAList:=genfs_fat_get_available_cluster(fs,ptr-FileClusterCount*fatbps*fatspc shr 9+1);
    end;
   if(Ptr shl 9>=SizeOfFile) then
    begin
     if(fs.fsname<=filesystem_fat16) then
     FATPos:=genfs_fat_location_of_file_info(fs,PathList.FileMainPos[0],
     PathList.FileSubPos[0],1)
     else
     FATPos:=genfs_fat_location_of_file_info(fs,PathList.FileMainPos[0],
     PathList.FileSubPos[0],PathList.FileStructSize[0]);
     PosInFile:=genfs_fat_cluster_to_file_position(fs,PathList.FileMainPos[0])+
     (PathList.FileSubPos[0]-1) shl 5;
     genfs_io_read(fs,sdir,PosInFile,sizeof(fat_directory_structure));
     sdir.directoryfirstclusterhighword:=FATAlist.index[0] shr 16;
     sdir.directoryfirstclusterlowword:=FATAlist.index[0] shl 16 shr 16;
     sdir.directoryfilesize:=ptr shl 9+content.size;
     genfs_io_write(fs,sdir,PosInFile,sizeof(fat_directory_structure));
    end;
   listindex:=1; offset:=0;
   while(listindex<=FATUlist.count+FATAlist.count) do
    begin
     if(listindex=FATUList.count+FATAList.count) then
      begin
       if(fs.fsname=filesystem_fat12) then
       fatentry.entry12:=fat12_final_cluster_low
       else if(fs.fsname=filesystem_fat16) then
       fatentry.entry16:=fat16_final_cluster_low
       else if(fs.fsname=filesystem_fat32) then
       fatentry.entry32:=fat32_final_cluster_low;
       genfs_fat_write_entry(fs,fatentry,FATAList.index[FATAlist.count-1]);
      end
     else if(listindex>FATUlist.count) then
      begin
       if(fs.fsname=filesystem_fat12) then
       fatentry.entry12:=FATAList.index[listindex-FATUlist.count]
       else if(fs.fsname=filesystem_fat16) then
       fatentry.entry16:=FATAList.index[listindex-FATUlist.count]
       else if(fs.fsname=filesystem_fat32) then
       fatentry.entry32:=FATAList.index[listindex-FATUlist.count];
       genfs_fat_write_entry(fs,fatentry,FATAList.index[listindex-FATUlist.count-1]);
      end
     else if(listindex=FATUlist.count) and (FATUlist.count<>0) then
      begin
       if(fs.fsname=filesystem_fat12) then
       fatentry.entry12:=FATAList.index[0]
       else if(fs.fsname=filesystem_fat16) then
       fatentry.entry16:=FATAList.index[0]
       else if(fs.fsname=filesystem_fat32) then
       fatentry.entry32:=FATAList.index[0];
       genfs_fat_write_entry(fs,fatentry,FATUList.index[FATUlist.count-1]);
      end;
     if((listindex-1)*fatbps*fatspc shr 9+offset>=ptr) and (SizeOfFile>=1 shl 9) then
      begin
       if(listindex>FATUlist.count) then
       PosInFile:=genfs_fat_cluster_to_file_position(fs,FATAList.index[listindex-FATUList.count-1])+
       (offset-1) shl 9
       else
       PosInFile:=genfs_fat_cluster_to_file_position(fs,FATUList.index[listindex-1])+
       (offset-1) shl 9;
       genfs_io_write(fs,content.content,PosInFile+(offset-1) shl 9,content.size); break;
      end
     else if((listindex-1)*fatbps*fatspc shr 9+offset>=ptr) and (SizeOfFile<1 shl 9) then
      begin
       if(listindex>FATUlist.count) then
       PosInFile:=genfs_fat_cluster_to_file_position(fs,FATAList.index[listindex-FATUList.count-1])+
       (offset-1) shl 9
       else
       PosInFile:=genfs_fat_cluster_to_file_position(fs,FATUList.index[listindex-1])+
       (offset-1) shl 9;
       genfs_io_write(fs,content.content,PosInFile+(offset-1) shl 9,content.size); break;
      end;
     inc(offset);
     if(Offset>=fatbps*fatspc shr 9) then
      begin
       inc(listindex); offset:=0;
      end;
     dec(SizeOfFile,1 shl 9);
    end;
  end
 else
  begin

  end;
end;
{File System File Get Content from external}
function genfs_filesystem_get_external_content(fn:UnicodeString;ptr:SizeUint):genfs_content;
var FileSize:SizeUint;
    FileBlockSize:SizeUint;
begin
 FileSize:=genfs_external_file_size(fn);
 FileBlockSize:=(FileSize+1 shl 9-1) div (1 shl 9);
 if(Ptr>=FileBlockSize) then
  begin
   Result.size:=0;
  end
 else if(Ptr shl 9>=FileSize) then
  begin
   genfs_external_io_read(fn,Result.content,ptr shl 9,FileSize-(FileBlockSize-1) shl 9);
   Result.size:=FileSize-(FileBlockSize-1) shl 9;
  end
 else
  begin
   genfs_external_io_read(fn,Result.content,ptr shl 9,1 shl 9);
   Result.size:=1 shl 9;
  end;
end;
{File System File Set Content from external}
procedure genfs_filesystem_set_external_content(fn:UnicodeString;ptr:SizeUint;content:genfs_content);
var FileSize:SizeUint;
begin
 genfs_external_io_write(fn,content.content,ptr shl 9,content.size);
end;
{File System Create the Directory missing}
function genfs_filesystem_force_directory(var fs:genfs_filesystem;dir:UnicodeString;
isfile:boolean=false):genfs_file;
var pathstr:genfs_path_string;
    totalpath:genfs_inner_path;
    testpath:UnicodeString;
    i,j,k,m,n:SizeUint;
    PosInFile:SizeUint;
{For FAT Directory Create Only}
    dircontent:array[1..32] of byte;
    tempstr:PWideChar;
    fatstr:fat_string;
    fatdir:fat_directory;
    FATentry:fat_entry;
    HavePrevNext:boolean;
    FATpos:genfs_fat_position_info;
    FATPosList:genfs_fat_position_info_list;
    FATAlist,FATUlist:genfs_fat_cluster_list;
    PrevCluster,CurCluster:SizeUint;
begin
 totalpath:=genfs_filesystem_search_for_path(fs,dir);
 pathstr:=genfs_path_to_path_string(dir);
 testpath:='/';
 if(fs.fsname<=filesystem_fat32) then
  begin
   i:=1;
   if(fs.fsname=filesystem_fat12) then CurCluster:=2
   else if(fs.fsname=filesystem_fat16) then CurCluster:=2
   else if(fs.fsname=filesystem_fat32) then CurCluster:=fs.fat32.header.exthead.bpb_rootcluster;
   PrevCluster:=CurCluster;
   while(i<=pathstr.count)do
    begin
     j:=1; HavePrevNext:=false;
     while(j<=totalpath.count)do
      begin
       if((j>1) and (testpath+'/'+pathstr.path[i-1]=totalpath.FilePath[j-1]))
       or((j=1) and (testpath+pathstr.path[i-1]=totalpath.FilePath[j-1])) then
        begin
         if(fs.fsname<=filesystem_fat16) then
         fatpos:=genfs_fat_location_of_file_info(fs,totalpath.FileMainPos[j-1],
         totalpath.FileSubPos[j-1],1)
         else
         fatpos:=genfs_fat_location_of_file_info(fs,totalpath.FileMainPos[j-1],
         totalpath.FileSubPos[j-1],totalpath.FileStructSize[j-1]);
         PosInFile:=genfs_fat_cluster_to_file_position(fs,fatpos.MainPos)+
         (fatpos.SubPos-1) shl 5;
         genfs_io_read(fs,dircontent,PosInFile,sizeof(fat_directory_structure));
         if((fs.fsname<=filesystem_fat32) and
         (fat_get_file_class(Pfat_directory_structure(@dircontent)^.directoryattribute,
         totalpath.FileStructSize[j-1]>1) and fat_directory_directory=fat_directory_directory))
         or((fs.fsname<=filesystem_fat16) and
         (fat_get_file_class(Pfat_directory_structure(@dircontent)^.directoryattribute,false)
         and fat_directory_directory=fat_directory_directory)) then
          begin
           CurCluster:=Pfat_directory_structure(@dircontent)^.directoryfirstclusterhighword shl 16
           +Pfat_directory_structure(@dircontent)^.directoryfirstclusterlowword;
          end
         else if((fs.fsname=filesystem_fat32) and
         (fat_get_file_class(Pfat_directory_structure(@dircontent)^.directoryattribute,
         totalpath.FileStructSize[j-1]>1) and fat_directory_file=fat_directory_file)) or
         ((fs.fsname<=filesystem_fat16) and
         (fat_get_file_class(Pfat_directory_structure(@dircontent)^.directoryattribute,false)
         and fat_directory_file=fat_directory_file)) then
          begin
           break;
          end;
         break;
        end
       else if(genfs_check_prefix(testpath,totalpath.FilePath[j-1],true)) then
        begin
         if(j>1) then HavePrevNext:=true;
         if(fs.fsname<=filesystem_fat16) then
         fatpos:=genfs_fat_location_of_file_info(fs,totalpath.FileMainPos[j-1],
         totalpath.FileSubPos[j-1],1)
         else if(fs.fsname<=filesystem_fat32) then
         fatpos:=genfs_fat_location_of_file_info(fs,totalpath.FileMainPos[j-1],
         totalpath.FileSubPos[j-1],totalpath.FileStructSize[j-1]);
        end;
       inc(j);
      end;
     if(j<=totalpath.count) then
      begin
       if(testpath='/') or (testpath='\') then
       testpath:=testpath+pathstr.path[j-1] else testpath:=testpath+'/'+pathstr.path[j-1];
       PrevCluster:=CurCluster;
       inc(j); continue;
      end
     else if(HavePrevNext=false) then
      begin
       FATAlist:=genfs_fat_get_available_cluster(fs,1);
       if(FATAlist.count=0) then
        begin
         writeln('ERROR:FAT FileSystem Write out of size.');
         readln;
         abort;
        end;
       CurCluster:=FATAlist.index[0];
       FATpos.MainPos:=CurCluster; FATpos.SubPos:=0;
      end;
     if(j>1) and (HavePrevNext=false) then
      begin
       fatstr:=fat_PWideCharToFatString('.');
       fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory,
       genfs_date_to_fat_date,genfs_time_to_fat_time,0,CurCluster);
       PosInFile:=genfs_fat_cluster_to_file_position(fs,CurCluster);
       genfs_io_write(fs,fatdir.dir,PosInFile,sizeof(fat_directory_structure));
       fatstr:=fat_PWideCharToFatString('..');
       fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory,
       genfs_date_to_fat_date,genfs_time_to_fat_time,0,CurCluster);
       PosInFile:=genfs_fat_cluster_to_file_position(fs,PrevCluster);
       genfs_io_write(fs,fatdir.dir,PosInFile,sizeof(fat_directory_structure));
       if(fs.fsname=filesystem_fat12) then FATentry.entry12:=fat12_final_cluster_low
       else if(fs.fsname=filesystem_fat16) then FATentry.entry16:=fat16_final_cluster_low
       else if(fs.fsname=filesystem_fat32) then FATentry.entry32:=fat32_final_cluster_low;
       genfs_fat_write_entry(fs,FATentry,CurCluster);
       if(fs.fsname=filesystem_fat32) then
        begin
         dec(fs.fat32.fsinfo.freecount,1);
         FATAlist:=genfs_fat_get_available_cluster(fs,1);
         if(FATAlist.count=0) then
          begin
           writeln('ERROR:File System cannot allocate more cluster to new information.');
           readln;
           abort;
          end;
         fs.fat32.fsinfo.nextfree:=FATAlist.index[0];
        end;
       inc(fatpos.subpos,2);
       PrevCluster:=CurCluster;
      end;
     tempstr:=UnicodeStringToPWideChar(pathstr.path[j-1]);
     fatstr:=fat_PWideCharToFatString(tempstr);
     {Arrange the Cluster the directory will occupy}
     if(fs.fsname<=filesystem_fat16) then
     FATPosList:=genfs_fat_location_of_next_directory_list(fs,fatpos.MainPos,
     fatpos.SubPos,1)
     else
     FATPosList:=genfs_fat_location_of_next_directory_list(fs,fatpos.MainPos,
     FATPos.SubPos,fat_calculate_directory_size(tempstr) shr 5);
     {Generate new cluster for file system}
     FATAlist.count:=0;
     if(fatpos.MainPos<>fatposlist.item[0].MainPos) and (i=1) then
     FATAlist:=genfs_fat_get_available_cluster(fs,fatposlist.count+2)
     else if(i=1) then
     FATAlist:=genfs_fat_get_available_cluster(fs,fatposlist.count+1)
     else if(fatpos.MainPos<>fatposlist.item[0].MainPos) then
     FATAlist:=genfs_fat_get_available_cluster(fs,fatposlist.count+1)
     else
     FATAlist:=genfs_fat_get_available_cluster(fs,fatposlist.count);
     if(FATAlist.count>0) then
      begin
       CurCluster:=FATAlist.index[FATAlist.count-1];
       Result.FATNextCluster:=CurCluster;
       Result.FATMainPos:=fatpos.MainPos;
       Result.FATSubPos:=fatpos.SubPos;
       if(fs.fsname=filesystem_fat32) then
        begin
         dec(fs.fat32.fsinfo.freecount,FATAlist.count-1);
         fs.fat32.fsinfo.nextfree:=FATAlist.index[FATAlist.count-1];
        end;
      end
     else
      begin
       writeln('ERROR:FAT File System cannot allocate more space for directory.');
       readln;
       abort;
      end;
     if(fs.fsname<=filesystem_fat16) or (fatstr.unicodefncount>0) then
      begin
       if(i=pathstr.count) and (isfile) then
       fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file,
       genfs_date_to_fat_date,genfs_time_to_fat_time,0,0)
       else
       fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory,
       genfs_date_to_fat_date,genfs_time_to_fat_time,0,CurCluster);
      end
     else
      begin
       if(i=pathstr.count) and (isfile) then
       fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_file and fat_directory_long,
       genfs_date_to_fat_date,genfs_time_to_fat_time,0,0)
       else
       fatdir:=fat_FatStringToFatDirectory(fatstr,fat_directory_directory and fat_directory_long,
       genfs_date_to_fat_date,genfs_time_to_fat_time,0,CurCluster);
      end;
     if(fatstr.unicodefn<>nil) then
      begin
       FreeMem(fatstr.unicodefn); fatstr.unicodefn:=nil; fatstr.unicodefncount:=0;
      end;
     {Add the directory information to totalpath}
     if(i>1) and (HavePrevNext=false) then
      begin
       inc(totalpath.count);
       SetLength(totalpath.FilePath,totalpath.count);
       SetLength(totalpath.FileClass,totalpath.count);
       SetLength(totalpath.FileMainPos,totalpath.count);
       SetLength(totalpath.FileSubPos,totalpath.count);
       SetLength(totalpath.FileShortStr,totalpath.count);
       if(fs.fsname=filesystem_fat32) then SetLength(totalpath.FileStructSize,totalpath.count);
       if(testpath='/') or (testpath='\') then totalpath.FilePath[totalpath.count-1]:=testpath+'.'
       else totalpath.FilePath[totalpath.count-1]:=testpath+'/.';
       totalpath.FileClass[totalpath.count-1]:=fat_directory_directory;
       totalpath.FileMainPos[totalpath.count-1]:=FATPos.MainPos;
       totalpath.FileSubPos[totalpath.count-1]:=0;
       totalpath.FileShortStr[totalpath.count-1]:='.';
       if(fs.fsname=filesystem_fat32) then totalpath.FileStructSize[totalpath.count]:=1;
       inc(totalpath.count);
       SetLength(totalpath.FilePath,totalpath.count);
       SetLength(totalpath.FileClass,totalpath.count);
       SetLength(totalpath.FileMainPos,totalpath.count);
       SetLength(totalpath.FileSubPos,totalpath.count);
       SetLength(totalpath.FileShortStr,totalpath.count);
       if(fs.fsname=filesystem_fat32) then SetLength(totalpath.FileStructSize,totalpath.count);
       if(testpath='/') or (testpath='\') then totalpath.FilePath[totalpath.count-1]:=testpath+'.'
       else totalpath.FilePath[totalpath.count-1]:=testpath+'/..';
       totalpath.FileClass[totalpath.count-1]:=fat_directory_directory;
       totalpath.FileMainPos[totalpath.count-1]:=FATPos.MainPos;
       totalpath.FileSubPos[totalpath.count-1]:=1;
       totalpath.FileShortStr[totalpath.count-1]:='..';
       if(fs.fsname=filesystem_fat32) then totalpath.FileStructSize[totalpath.count]:=1;
       inc(totalpath.FilePrevNextCount,2);
      end;
     inc(totalpath.count);
     SetLength(totalpath.FilePath,totalpath.count);
     SetLength(totalpath.FileClass,totalpath.count);
     SetLength(totalpath.FileShortStr,totalpath.count);
     SetLength(totalpath.FileMainPos,totalpath.count);
     SetLength(totalpath.FileSubPos,totalpath.count);
     if(fs.fsname=filesystem_fat32) then SetLength(totalpath.FileStructSize,totalpath.count);
     if(testpath='/') or (testpath='\') then totalpath.FilePath[totalpath.count-1]:=testpath+tempstr
     else totalpath.FilePath[totalpath.count-1]:=testpath+'/'+tempstr;
     if(fatdir.longdircount>0) and (fs.fsname=filesystem_fat32) then
      begin
       if(i=pathstr.count) and (isfile) then
       totalpath.FileClass[totalpath.count-1]:=fat_directory_file and fat_directory_long
       else
       totalpath.FileClass[totalpath.count-1]:=fat_directory_directory and fat_directory_long;
       totalpath.FileMainPos[totalpath.count-1]:=fatpos.MainPos;
       totalpath.FileSubPos[totalpath.count-1]:=fatpos.SubPos;
       totalpath.FileShortStr[totalpath.count-1]:=genfs_fat_extract_short_name(fatdir.dir);
       totalpath.FileStructSize[totalpath.count-1]:=
       fat_calculate_directory_size(tempstr) shr 5;
      end
     else
      begin
       if(i=pathstr.count) and (isfile) then
       totalpath.FileClass[totalpath.count-1]:=fat_directory_file
       else
       totalpath.FileClass[totalpath.count-1]:=fat_directory_directory;
       totalpath.FileMainPos[totalpath.count-1]:=fatpos.MainPos;
       totalpath.FileSubPos[totalpath.count-1]:=fatpos.SubPos;
       totalpath.FileShortStr[totalpath.count-1]:=genfs_fat_extract_short_name(fatdir.dir);
       if(fs.fsname=filesystem_fat32) then totalpath.FileStructSize[totalpath.count-1]:=1;
      end;
     {Generate the missing directory}
     m:=1; j:=1;
     while(j<=fatposlist.count)do
      begin
       if(j<fatposlist.count) then
        begin
         if(fs.fsname<=filesystem_fat12) then FATEntry.entry12:=fatposlist.item[j].MainPos
         else if(fs.fsname<=filesystem_fat16) then FATEntry.entry16:=fatposlist.item[j].MainPos
         else if(fs.fsname<=filesystem_fat32) then FATEntry.entry32:=fatposlist.item[j].MainPos;
         genfs_fat_write_entry(fs,FATentry,fatposlist.item[j-1].MainPos);
        end
       else
        begin
         if(fs.fsname<=filesystem_fat12) then FATEntry.entry12:=fat12_final_cluster_low
         else if(fs.fsname<=filesystem_fat16) then FATEntry.entry16:=fat16_final_cluster_low
         else if(fs.fsname<=filesystem_fat32) then FATEntry.entry32:=fat32_final_cluster_low;
         genfs_fat_write_entry(fs,FATentry,fatposlist.item[j-1].MainPos);
        end;
       k:=1;
       while(k<=fatposlist.size[j-1])do
        begin
         PosInFile:=genfs_fat_cluster_to_file_position(fs,fatposlist.item[j-1].MainPos)+
         (fatposlist.item[j-1].SubPos+m-1) shl 5;
         if(fs.fsname=filesystem_fat32) and (m<=fatdir.longdircount) then
         genfs_io_write(fs,(fatdir.longdir+m-1)^,PosInFile,sizeof(fat_long_directory_structure))
         else
         genfs_io_write(fs,fatdir.dir,PosInFile,sizeof(fat_long_directory_structure));
         inc(k); inc(m);
        end;
       inc(j);
      end;
     inc(i);
    end;
  end
 else
  begin

  end;
 genfs_filesystem_write_info(fs);
 if(fs.fsname<=filesystem_fat32) then genfs_fat_rename(fs);
end;
{File System Copy to external}
procedure genfs_filesystem_copy_to_external(var fs:genfs_filesystem;srcdir,destdir:UnicodeString);
var i:SizeUint;
    ptr1,ptr2:SizeUint;
    content:genfs_content;
    inpath:genfs_inner_path;
    sismask:boolean;
    slen:SizeUInt;
    spath,dpath:UnicodeString;
    bool:boolean;
    tempsize:SizeUint;
begin
 inpath:=genfs_filesystem_search_for_path(fs,srcdir);
 sismask:=genfs_is_mask(srcdir);
 if(sismask) then spath:=genfs_extract_search_path_without_wildcard(srcdir)
 else spath:=srcdir;
 slen:=length(spath)+1;
 i:=1;
 while(i<=inpath.count)do
  begin
   if(fs.fsname<=filesystem_fat32) and
   (fat_get_file_class(inpath.Fileclass[i-1],fs.fsname=filesystem_fat32) and
   fat_directory_file=fat_directory_file) then
   dpath:=destdir
   else if(genfs_check_file_name(destdir)) then
   dpath:=destdir
   else if(destdir='/') or (destdir='\') then
   dpath:=destdir+Copy(inpath.FilePath[i-1],slen+1,length(inpath.FilePath[i-1])-slen)
   else if(length(destdir)>0) and ((destdir[length(destdir)]='/')
   or (destdir[length(destdir)]='\')) then
   dpath:=destdir+Copy(inpath.FilePath[i-1],slen+1,length(inpath.FilePath[i-1])-slen)
   else
   dpath:=destdir+'/'+Copy(inpath.FilePath[i-1],slen+1,length(inpath.FilePath[i-1])-slen);
   if(fs.fsname<=filesystem_fat32) then
    begin
     bool:=fat_get_file_class(inpath.FileClass[i-1],
     fs.fsname<filesystem_fat32) and fat_directory_file=fat_directory_file;
     tempsize:=genfs_fat_get_file_size(fs,inpath.FilePath[i-1]);
     if(DirectoryExists(dpath)=false) and (FileExists(dpath)=false) then ForceDirectories(dpath)
     else ForceDirectories(genfs_extract_file_path(dpath));
    end;
   ptr1:=0; ptr2:=0;
   while(ptr1 shl 9<tempsize)do
    begin
     content:=genfs_filesystem_get_content(fs,inpath.FilePath[i-1],ptr1);
     genfs_filesystem_set_external_content(dpath,ptr1,content);
     inc(ptr1); inc(ptr2);
    end;
   inc(i);
  end;
end;
{File System Copy from external}
procedure genfs_filesystem_copy_from_external(var fs:genfs_filesystem;destdir,srcdir:UnicodeString);
var i:SizeUint;
    ptr1,ptr2:SizeUint;
    content:genfs_content;
    extpath:genfs_path;
    extismask:boolean;
    extrootpath:UnicodeString;
    extrootlen:SizeUint;
    destpath:UnicodeString;
    tempsize:SizeUint;
    bool:boolean;
begin
 extpath:=genfs_external_search_for_path(srcdir);
 extismask:=genfs_is_mask(destdir);
 if(extismask) then extrootpath:=genfs_extract_search_path_without_wildcard(srcdir)
 else extrootpath:=srcdir;
 extrootlen:=length(extrootpath)+1;
 i:=1;
 while(i<=extpath.count)do
  begin
   if(fs.fsname<=filesystem_fat32) and (extpath.IsFile[i-1]) then
   destpath:=destdir
   else if(genfs_check_file_name(destdir)) then
   destpath:=destdir
   else if(destdir='\') or (destdir='/') then
   destpath:=destdir+Copy(extpath.FilePath[i-1],extrootlen+1,length(extpath.FilePath[i-1])-extrootlen)
   else if(length(destdir)>0) and
   ((destdir[length(destdir)]='/') or (destdir[length(destdir)]='\')) then
   destpath:=destdir+Copy(extpath.FilePath[i-1],extrootlen+1,length(extpath.FilePath[i-1])-extrootlen)
   else
   destpath:=destdir+'/'+Copy(extpath.FilePath[i-1],extrootlen+1,
   length(extpath.FilePath[i-1])-extrootlen);
   if(fs.fsname<=filesystem_fat32) then
    begin
     bool:=extpath.IsFile[i-1];
     tempsize:=genfs_external_file_size(extpath.FilePath[i-1]);
     genfs_filesystem_force_directory(fs,destpath,bool);
    end;
   ptr1:=0; ptr2:=0;
   while(ptr1 shl 9<tempsize)do
    begin
     content:=genfs_filesystem_get_external_content(extpath.FilePath[i-1],ptr1);
     genfs_filesystem_set_content(fs,destpath,ptr2,content);
     inc(ptr1); inc(ptr2);
    end;
   inc(i);
  end;
 genfs_filesystem_write_info(fs);
 if(fs.fsname<=filesystem_fat32) then genfs_fat_rename(fs);
end;
{File System File Move}
procedure genfs_filesystem_move(var fs:genfs_filesystem;srcdir,destdir:UnicodeString);
var i:SizeUint;
    ptr1,ptr2:SizeUint;
    content:genfs_content;
    srcismask:boolean;
    srcpath,destpath:UnicodeString;
    srclen:SizeUint;
    srcinpath:genfs_inner_path;
    fsfile:genfs_file;
    bool:boolean;
    tempsize:SizeUint;
begin
 srcismask:=genfs_is_mask(srcdir);
 if(srcismask) then srcpath:=genfs_extract_search_path_without_wildcard(srcdir)
 else srcpath:=srcdir;
 srclen:=length(srcpath)+1;
 srcinpath:=genfs_filesystem_search_for_path(fs,srcdir);
 i:=1;
 while(i<=srcinpath.count)do
  begin
   if(fs.fsname<=filesystem_fat32) and (fat_get_file_class(srcinpath.FileClass[i-1],
   fs.fsname=filesystem_fat32)
   and fat_directory_file=fat_directory_file) then
   destpath:=destdir
   else if(genfs_check_file_name(destdir)) then
   destpath:=destdir
   else if(destdir='/') or (destdir='\') then
   destpath:=destdir+Copy(srcinpath.FilePath[i-1],srclen+1,length(srcinpath.FilePath[i-1])-srclen)
   else if(length(destdir)>0) and ((destdir[length(destdir)]='/') or
   (destdir[length(destdir)]='\')) then
   destpath:=destdir+Copy(srcinpath.FilePath[i-1],srclen+1,length(srcinpath.FilePath[i-1])-srclen)
   else
   destpath:=destdir+'/'+Copy(srcinpath.FilePath[i-1],srclen+1,length(srcinpath.FilePath[i-1])-srclen);
   if(fs.fsname<=filesystem_fat32) then
    begin
     bool:=fat_get_file_class(srcinpath.FileClass[i-1],
     fs.fsname<filesystem_fat32) and fat_directory_file=fat_directory_file;
     tempsize:=genfs_fat_get_file_size(fs,srcinpath.FilePath[i-1]);
     genfs_filesystem_force_directory(fs,destpath,bool);
    end
   else
    begin

    end;
   ptr1:=0; ptr2:=0;
   while(ptr1 shl 9<tempsize)do
    begin
     content:=genfs_filesystem_get_content(fs,srcinpath.FilePath[i-1],ptr1);
     genfs_filesystem_set_content(fs,srcinpath.FilePath[i-1],ptr2,content);
     inc(ptr1); inc(ptr2);
    end;
   genfs_filesystem_delete(fs,srcinpath.FilePath[i-1],true);
   inc(i);
  end;
 genfs_filesystem_write_info(fs);
 if(fs.fsname<=filesystem_fat32) then genfs_fat_rename(fs);
end;
{File System File Move to external}
procedure genfs_filesystem_move_to_external(var fs:genfs_filesystem;srcdir,destdir:UnicodeString);
begin
 genfs_filesystem_copy_to_external(fs,srcdir,destdir);
 genfs_filesystem_delete(fs,srcdir,true);
end;
{File System File Move from external}
procedure genfs_filesystem_move_from_external(var fs:genfs_filesystem;destdir,srcdir:UnicodeString);
begin
 genfs_filesystem_copy_from_external(fs,destdir,srcdir);
 DeleteFile(destdir);
end;
{File System File Replace}
procedure genfs_filesystem_replace(var fs:genfs_filesystem;srcdir,repdir:UnicodeString);
begin
 if(genfs_filesystem_compare(fs,srcdir,repdir)=false) then
  begin
   genfs_filesystem_delete(fs,repdir,true);
   genfs_filesystem_copy(fs,srcdir,repdir);
  end
 else if(genfs_filesystem_check_file_existence(fs,srcdir)) then
  begin
   writeln('ERROR:Replace source file does not exist.');
   readln;
   abort;
  end;
end;
{File System File Replace to external}
procedure genfs_filesystem_replace_to_external(var fs:genfs_filesystem;srcdir,repdir:UnicodeString);
begin
 if(genfs_filesystem_compare_external(fs,srcdir,repdir)=false) then
  begin
   DeleteFile(repdir);
   genfs_filesystem_copy_to_external(fs,srcdir,repdir);
  end
 else if(FileExists(repdir)) then
  begin
   writeln('ERROR:Replace source file does not exist.');
   readln;
   abort;
  end;
end;
{File System File Replace from external}
procedure genfs_filesystem_replace_from_external(var fs:genfs_filesystem;repdir,srcdir:UnicodeString);
begin
 if(genfs_filesystem_compare_external(fs,srcdir,repdir)=false) then
  begin
   genfs_filesystem_delete(fs,repdir,true);
   genfs_filesystem_copy_from_external(fs,repdir,srcdir);
  end
 else if(genfs_filesystem_check_file_existence(fs,srcdir)) then
  begin
   writeln('ERROR:Replace source file does not exist.');
   readln;
   abort;
  end;
end;
{File System File Copy between two image files}
procedure genfs_filesystem_copy(var fs1:genfs_filesystem;
var fs2:genfs_filesystem;srcdir,destdir:UnicodeString);
var i:SizeUint;
    ptr1,ptr2:SizeUint;
    content:genfs_content;
    srcismask:boolean;
    srcinpath:genfs_inner_path;
    srclen:SizeUint;
    tempsize:SizeUint;
    srcpath,destpath:UnicodeString;
    bool:boolean;
begin
 srcinpath:=genfs_filesystem_search_for_path(fs1);
 srcismask:=genfs_is_mask(srcdir);
 if(srcismask) then srcpath:=genfs_extract_search_path_without_wildcard(srcdir)
 else srcpath:=destdir;
 srclen:=length(srcpath)+1;
 i:=1;
 while(i<=srcinpath.count)do
  begin
   if(fs1.fsname<=filesystem_fat32) and (fat_get_file_class(srcinpath.FileClass[i-1],
   fs1.fsname=filesystem_fat32) and fat_directory_file=fat_directory_file) then
   destpath:=destdir
   else if(genfs_check_file_name(destdir)) then
   destpath:=destdir
   else if(destdir='\') or (destdir='\') then
   destpath:=destdir+Copy(srcinpath.FilePath[i-1],srclen+1,length(srcinpath.FilePath[i-1])-srclen)
   else if(length(destdir)>0) and ((destdir[length(destdir)]='\') or (destdir[length(destdir)]='/')) then
   destpath:=destdir+Copy(srcinpath.FilePath[i-1],srclen+1,length(srcinpath.FilePath[i-1])-srclen)
   else
   destpath:=destdir+'/'+Copy(srcinpath.FilePath[i-1],srclen+1,length(srcinpath.FilePath[i-1])-srclen);
   if(fs1.fsname<=filesystem_fat32) then
    begin
     bool:=fat_get_file_class(srcinpath.FileClass[i-1],fs1.fsname<filesystem_fat32)
     and fat_directory_file=fat_directory_file;
     tempsize:=genfs_fat_get_file_size(fs1,srcinpath.FilePath[i-1]);
     genfs_filesystem_force_directory(fs2,destpath,bool);
    end
   else
    begin

    end;
   ptr1:=0; ptr2:=0;
   while(ptr1 shl 9<=tempsize)do
    begin
     content:=genfs_filesystem_get_content(fs1,srcinpath.FilePath[i-1],ptr1);
     genfs_filesystem_set_content(fs2,destpath,ptr2,content);
     inc(ptr1); inc(ptr2);
    end;
   inc(i);
  end;
end;
{File System Content Compare}
function genfs_filesystem_compare_content(c1,c2:genfs_content):boolean;
var i:SizeUint;
begin
 if(c1.size<>c2.size) then exit(false)
 else
  begin
   i:=1;
   while(i<=c1.size)do
    begin
     if(c1.content[i]<>c2.content[i]) then exit(false);
     inc(i);
    end;
   Result:=true;
  end;
end;
{File System File Compare between two image files}
function genfs_filesystem_compare(fs1,fs2:genfs_filesystem;srcdir,destdir:UnicodeString):boolean;
var i:SizeUint;
    ptr1,ptr2:SizeUint;
    content1,content2:genfs_content;
    srcismask,destismask:boolean;
    srcrootpath,destrootpath:UnicodeString;
    srcinpath,destinpath:genfs_inner_path;
    srcpath,destpath:UnicodeString;
    srclen,destlen:SizeUint;
    bool1,bool2:boolean;
    tempsize1,tempsize2:SizeUint;
begin
 srcinpath:=genfs_filesystem_search_for_path(fs1,srcdir);
 srcismask:=genfs_is_mask(srcdir);
 if(srcismask) then srcrootpath:=genfs_extract_search_path_without_wildcard(srcdir)
 else srcrootpath:=genfs_extract_file_path(srcdir);
 srclen:=length(srcrootpath)+1;
 destinpath:=genfs_filesystem_search_for_path(fs2,destdir);
 destismask:=genfs_is_mask(destdir);
 if(destismask) then destrootpath:=genfs_extract_search_path_without_wildcard(destdir)
 else destrootpath:=genfs_extract_file_path(destdir);
 destlen:=length(destrootpath)+1;
 if(srcinpath.count<>destinpath.count) then exit(false)
 else
  begin
   i:=1;
   while(i<=srcinpath.count)do
    begin
     if(srcrootpath='') then srcpath:=srcinpath.FilePath[i-1]
     else srcpath:=Copy(srcinpath.FilePath[i-1],srclen+1,length(srcinpath.FilePath[i-1])-srclen);
     if(destrootpath='') then destpath:=destinpath.FilePath[i-1]
     else destpath:=Copy(destinpath.FilePath[i-1],destlen+1,length(destinpath.FilePath[i-1])-destlen);
     if(srcpath<>destpath) then exit(false)
     else
      begin
       if(fs1.fsname<=filesystem_fat32) then
        begin
         bool1:=fat_get_file_class(srcinpath.FileClass[i-1],fs1.fsname=filesystem_fat32)
         and fat_directory_file=fat_directory_file;
         tempsize1:=genfs_fat_get_file_size(fs1,srcinpath.FilePath[i-1]);
        end;
       if(fs2.fsname<=filesystem_fat32) then
        begin
         bool2:=fat_get_file_class(destinpath.FileClass[i-1],fs2.fsname=filesystem_fat32)
         and fat_directory_file=fat_directory_file;
         tempsize2:=genfs_fat_get_file_size(fs2,destinpath.FilePath[i-1]);
        end;
       if(bool1=true) and (bool1=bool2) and (tempsize1=tempsize2) then
        begin
         ptr1:=0; ptr2:=0;
         while(ptr1 shl 9<tempsize1)do
          begin
           content1:=genfs_filesystem_get_content(fs1,srcinpath.FilePath[i-1],ptr1);
           content2:=genfs_filesystem_get_content(fs2,destinpath.FilePath[i-1],ptr2);
           if(genfs_filesystem_compare_content(content1,content2)=false) then break;
           inc(ptr1); inc(ptr2);
          end;
         if(ptr1 shl 9<tempsize1) then break;
        end
       else if(bool1=bool2) and (tempsize1=tempsize2) then
        begin
         inc(i); continue;
        end
       else break;
      end;
     inc(i);
    end;
   if(i>srcinpath.count) then Result:=true else Result:=false;
  end;
end;
{File System File Replace between two image files}
procedure genfs_filesystem_replace(fs1:genfs_filesystem;
var fs2:genfs_filesystem;srcdir,destdir:UnicodeString);
begin
 if(genfs_filesystem_check_file_existence(fs2,destdir)) then
  begin
   genfs_filesystem_delete(fs2,destdir,true);
   genfs_filesystem_copy(fs1,fs2,srcdir,destdir);
  end
 else
  begin
   writeln('ERROR:Replace source file does not exist.');
   readln;
   abort;
  end;
end;
{File System File Move between two image files}
procedure genfs_filesystem_move(var fs1:genfs_filesystem;
var fs2:genfs_filesystem;srcdir,destdir:UnicodeString);
begin
 if(genfs_filesystem_check_file_existence(fs1,srcdir)) then
  begin
   genfs_filesystem_copy(fs1,fs2,srcdir,destdir);
   genfs_filesystem_delete(fs1,srcdir,true);
  end
 else
  begin
   writeln('ERROR:Move source file does not exist.');
   readln;
   abort;
  end;
end;
{File System Image Delete}
procedure genfs_filesystem_image_delete(fs:genfs_filesystem);
begin
 DeleteFile(fs.linkfilename);
end;
{File System Image Compare}
function genfs_filesystem_image_compare(fs1,fs2:genfs_filesystem):boolean;
var i:SizeUint;
    f1,f2:TFileStream;
    d1,d2:dword;
begin
 if(fs1.fsname<>fs2.fsname) then
  begin
   exit(false);
  end
 else
  begin
   f1:=TFileStream.Create(UnicodeStringToString(fs1.linkfilename),fmOpenRead);
   f2:=TFileStream.Create(UnicodeStringToString(fs2.linkfilename),fmOpenRead);
   f1.Seek(0,0); f2.Seek(0,0);
   i:=1;
   while(i<=f1.Size shr 2)do
    begin
     f1.Read(d1,4); f2.Read(d2,4);
     if(d1<>d2) then break;
     inc(i);
    end;
   if(i>f1.Size) then Result:=true else Result:=false;
   f1.Free; f2.Free;
  end;
end;
{File System Image Copy}
procedure genfs_filesystem_image_copy(fs:genfs_filesystem;fn:UnicodeString);
var i:SizeUint;
    f1,f2:TFileStream;
    content:array[1..1024] of dword;
begin
 f1:=TFileStream.Create(UnicodeStringToString(fs.linkfilename),fmOpenRead);
 if(FileExists(fn)) then
 f2:=TFileStream.Create(UnicodeStringToString(fn),fmOpenWrite)
 else
 f2:=TFileStream.Create(UnicodeStringToString(fn),fmCreate);
 f1.Seek(0,0); f2.Seek(0,0);
 for i:=1 to f1.Size shr 12 do
  begin
   f1.Read(content,4096);
   f2.Write(content,4096);
  end;
 f1.Free; f2.Free;
end;
{File System Image Move}
procedure genfs_filesystem_image_move(fs:genfs_filesystem;fn:UnicodeString);
begin
 genfs_filesystem_image_copy(fs,fn);
 DeleteFile(fs.linkfilename);
end;
{File System Image Replace}
procedure genfs_filesystem_image_replace(fs:genfs_filesystem;fn:UnicodeString);
var cfs:genfs_filesystem;
begin
 cfs:=genfs_filesystem_read(fn);
 if(genfs_filesystem_image_compare(fs,cfs)=false) then
  begin
   DeleteFile(fn);
   genfs_filesystem_image_copy(fs,fn);
  end;
 genfs_filesystem_free(cfs);
end;

end.

