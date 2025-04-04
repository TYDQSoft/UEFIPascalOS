unit genisobase;

{$mode ObjFPC}

interface

uses Classes,SysUtils,isobase;

type geniso_external_path=packed record
                          FileRootPath:UnicodeString;
                          FilePath:array of UnicodeString;
                          FileName:array of UnicodeString;
                          IsFile:array of boolean;
                          Count:SizeUint;
                          end;
     geniso_temporary_tree=packed record
                           parent:^geniso_temporary_tree;
                           ExtFilePath:UnicodeString;
                           FileName:UnicodeString;
                           FileAttr:boolean;
                           child:^geniso_temporary_tree;
                           count:SizeUint;
                           end;
     Pgeniso_temporary_tree=^geniso_temporary_tree;
     geniso_iso_file=packed record
                     linkfn:UnicodeString;
                     isostart:SizeUint;
                     isovdcount:SizeUint;
                     isootherstart:SizeUint;
                     {For EL torito Only}
                     isoentryname:UnicodeString;
                     isoentrySector:SizeUint;
                     end;
     geniso_content=packed record
                    content:array[1..2048] of byte;
                    count:word;
                    end;
     geniso_return=packed record
                   OccupySize:SizeUint;
                   CatalogIndex:SizeUint;
                   end;
     geniso_configure=packed record
                      standard:byte;
                      sourcepath:UnicodeString;
                      entryfn:UnicodeString;
                      end;

var NextFree:SizeUint=0;

function geniso_initialize(fn:UnicodeString;config:geniso_configure):geniso_iso_file;
function geniso_construct_config(srcpath,standard,entryfilename:UnicodeString):geniso_configure;

implementation

function UnicodeStringToString(str:UnicodeString):string;
var i,len:SizeUint;
begin
 len:=length(str); i:=1; Result:='';
 while(i<=len)do
  begin
   if(str[i]>#255) then
    begin
     Result:=Result+Char((Word(str[i]) shr 8))+Char((Word(str[i]) shl 8 shr 8));
    end
   else Result:=Result+Char(str[i]);
   inc(i);
  end;
end;
function StringToPChar(str:string):PChar;
var i,len:SizeUint;
begin
 Result:=allocmem((length(str)+1)*sizeof(char)); i:=1; len:=length(str);
 while(i<=len)do
  begin
   (Result+i-1)^:=str[i];
   inc(i);
  end;
end;
procedure geniso_io_read(iso:geniso_iso_file;var dest;offset,size:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 f:=TFileStream.Create(UnicodeStringToString(iso.linkfn),fmOpenRead);
 f.Seek(offset,0);
 if(size-size shr 3 shl 3=0) then
  begin
   for i:=1 to size shr 3 do f.Read(Pqword(@dest+(i-1) shl 3)^,8);
  end
 else if(size-size shr 2 shl 2=0) then
  begin
   for i:=1 to size shr 2 do f.Read(Pdword(@dest+(i-1) shl 2)^,4);
  end
 else if(size-size shr 1 shl 1=0) then
  begin
   for i:=1 to size shr 1 do f.Read(Pword(@dest+(i-1) shl 1)^,2);
  end
 else
  begin
   for i:=1 to size do f.Read(Pbyte(@dest+i-1)^,1);
  end;
 f.Free;
end;
procedure geniso_io_read_block(iso:geniso_iso_file;var dest:geniso_content;offset:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 f:=TFileStream.Create(UnicodeStringToString(iso.linkfn),fmOpenRead);
 f.Seek(offset,0);
 f.Read(dest.content,dest.count);
 f.Free;
end;
procedure geniso_io_write(iso:geniso_iso_file;const source;offset,size:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(FileExists(iso.linkfn)) then
 f:=TFileStream.Create(UnicodeStringToString(iso.linkfn),fmOpenWrite)
 else
 f:=TFileStream.Create(UnicodeStringToString(iso.linkfn),fmCreate);
 f.Seek(offset,0);
 if(size-size shr 3 shl 3=0) then
  begin
   for i:=1 to size shr 3 do f.Write(Pqword(@source+(i-1) shl 3)^,8);
  end
 else if(size-size shr 2 shl 2=0) then
  begin
   for i:=1 to size shr 2 do f.Write(Pdword(@source+(i-1) shl 2)^,4);
  end
 else if(size-size shr 1 shl 1=0) then
  begin
   for i:=1 to size shr 1 do f.Write(Pword(@source+(i-1) shl 1)^,2);
  end
 else
  begin
   for i:=1 to size do f.Write(Pbyte(@source+i-1)^,1);
  end;
 f.Free;
end;
procedure geniso_io_write_block(iso:geniso_iso_file;const source:geniso_content;offset:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(FileExists(iso.linkfn)) then
 f:=TFileStream.Create(UnicodeStringToString(iso.linkfn),fmOpenWrite)
 else
 f:=TFileStream.Create(UnicodeStringToString(iso.linkfn),fmCreate);
 f.Seek(offset,0);
 f.Write(source.content,source.count);
 f.Free;
end;
function geniso_io_get_size(iso:geniso_iso_file):SizeUint;
var f:TFileStream;
    i:SizeUint;
begin
 f:=TFileStream.Create(UnicodeStringToString(iso.linkfn),fmOpenRead);
 geniso_io_get_size:=f.Size;
 f.Free;
end;
procedure geniso_external_io_read(fn:UnicodeString;var dest;offset,size:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(fn='') then exit;
 f:=TFileStream.Create(UnicodeStringToString(fn),fmOpenRead);
 f.Seek(offset,0);
 if(size-size shr 3 shl 3=0) then
  begin
   for i:=1 to size shr 3 do f.Read(Pqword(Pointer(@dest)+(i-1) shl 3)^,8);
  end
 else if(size-size shr 2 shl 2=0) then
  begin
   for i:=1 to size shr 2 do f.Read(Pdword(Pointer(@dest)+(i-1) shl 2)^,4);
  end
 else if(size-size shr 1 shl 1=0) then
  begin
   for i:=1 to size shr 1 do f.Read(Pword(Pointer(@dest)+(i-1) shl 1)^,2);
  end
 else
  begin
   for i:=1 to size do f.Read(Pbyte(Pointer(@dest)+i-1)^,1);
  end;
 f.Free;
end;
procedure geniso_external_io_read_block(fn:UnicodeString;var source:geniso_content;offset:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(fn='') then exit;
 f:=TFileStream.Create(UnicodeStringToString(fn),fmOpenRead);
 f.Seek(offset,0);
 f.Read(source.content,source.count);
 f.Free;
end;
procedure geniso_external_io_write(fn:UnicodeString;const source;offset,size:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(fn='') then exit;
 if(FileExists(fn)) then
 f:=TFileStream.Create(UnicodeStringToString(fn),fmOpenWrite)
 else
 f:=TFileStream.Create(UnicodeStringToString(fn),fmCreate);
 f.Seek(offset,0);
 if(size-size shr 3 shl 3=0) then
  begin
   for i:=1 to size shr 3 do f.Write(Pdword(@source+(i-1) shl 3)^,8);
  end
 else if(size-size shr 2 shl 2=0) then
  begin
   for i:=1 to size shr 2 do f.Write(Pdword(@source+(i-1) shl 2)^,4);
  end
 else if(size-size shr 1 shl 1=0) then
  begin
   for i:=1 to size shr 1 do f.Write(Pword(@source+(i-1) shl 1)^,2);
  end
 else
  begin
   for i:=1 to size do f.Write(Pbyte(@source+i-1)^,1);
  end;
 f.Free;
end;
procedure geniso_external_io_write_block(fn:UnicodeString;const source:geniso_content;offset:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(fn='') then exit;
 if(FileExists(fn)) then
 f:=TFileStream.Create(UnicodeStringToString(fn),fmOpenWrite)
 else
 f:=TFileStream.Create(UnicodeStringToString(fn),fmCreate);
 f.Seek(offset,0);
 f.Write(source.content,source.count);
 f.Free;
end;
function geniso_external_io_get_size(fn:UnicodeString):SizeUint;
var f:TFileStream;
begin
 if(fn='') then exit(0);
 f:=TFileStream.Create(UnicodeStringToString(fn),fmOpenRead);
 Result:=f.Size;
 f.Free;
end;
function geniso_is_mask(basedir:UnicodeString):boolean;
var i,len:SizeUint;
begin
 i:=1; len:=length(basedir);
 while(i<=len)do
  begin
   if(basedir[i]='*') or (basedir[i]='?') then break;
   inc(i);
  end;
 if(i>len) then geniso_is_mask:=false else geniso_is_mask:=true;
end;
function geniso_extract_file_path_without_wildcard(fullpath:UnicodeString):UnicodeString;
var i,j,len:SizeUint;
begin
 i:=1; len:=length(fullpath);
 while(i<=len)do
  begin
   if(fullpath[i]='*') or (fullpath[i]='?') then break;
   inc(i);
  end;
 j:=i-1;
 while(j>0)do
  begin
   if(fullpath[j]='/') or (fullpath[j]='\') then break;
   dec(j);
  end;
 Result:=Copy(fullpath,1,j-1);
end;
function geniso_compare_same_path(path1,path2:UnicodeString):boolean;
var i,j,len1,len2:SizeUint;
begin
 len1:=length(path1); i:=len1;
 while(i>0) and (path1[i]<>'\') and (path1[i]<>'/') do dec(i);
 len2:=length(path2); j:=len2;
 while(j>0) and (path2[j]<>'\') and (path2[j]<>'/') do dec(j);
 if(Copy(path1,1,i-1)<>Copy(path2,1,j-1)) then Result:=false else Result:=true;
end;
function geniso_get_external_path(inputbasedir:UnicodeString):geniso_external_path;
var SearchRec:TUnicodeSearchRec;
    Order:Longint;
    ismask,bool:boolean;
    basedir,tempstr:UnicodeString;
    tempres:geniso_external_path;
    i:SizeUint;
begin
 {Handle the base directory path}
 Result.Count:=0; ismask:=geniso_is_mask(inputbasedir);
 if(ismask) then
 basedir:=geniso_extract_file_path_without_wildcard(inputbasedir)
 else
 basedir:=inputbasedir;
 Result.FileRootPath:=basedir;
 {If the base directory pointed the file,add the file path and attribute to list.}
 if(FileExists(basedir)) then
  begin
   inc(Result.count);
   SetLength(Result.FilePath,Result.count);
   Result.FilePath[Result.count-1]:=basedir;
   SetLength(Result.IsFile,Result.count);
   Result.IsFile[Result.count-1]:=true;
   SetLength(Result.FileName,Result.count);
   Result.FileName[Result.count-1]:=ExtractFileName(basedir);
  end;
 {Search for every directory in the path base directory}
 Order:=0; bool:=false;
 while(Order=0) do
  begin
   if(ismask) and (bool=false) then
   Order:=FindFirst(inputbasedir,faDirectory,SearchRec)
   else if(ismask=false) and (bool=false) then
   Order:=FindFirst(basedir+'/*',faDirectory,SearchRec)
   else
   Order:=FindNext(SearchRec);
   if(Order<>0) then break;
   if(bool=false) then bool:=true;
   if(basedir='/') or (basedir='\') then tempstr:=basedir+SearchRec.Name
   else tempstr:=basedir+'/'+SearchRec.Name;
   if(SearchRec.Name='..') or (SearchRec.Name='.') then continue;
   if(SearchRec.Attr and faDirectory<>faDirectory) then continue;
   inc(Result.Count);
   SetLength(Result.FilePath,Result.count);
   Result.FilePath[Result.count-1]:=tempstr;
   SetLength(Result.IsFile,Result.count);
   Result.IsFile[Result.count-1]:=false;
   SetLength(Result.FileName,Result.count);
   Result.FileName[Result.count-1]:=ExtractFileName(tempstr);
   if(SearchRec.Name<>'..') and (SearchRec.Name<>'.') then
    begin
     tempres:=geniso_get_external_path(tempstr);
     for i:=1 to tempres.Count do
      begin
       inc(Result.Count);
       SetLength(Result.FilePath,Result.count);
       Result.FilePath[Result.count-1]:=tempres.FilePath[i-1];
       SetLength(Result.IsFile,Result.count);
       Result.IsFile[Result.count-1]:=tempres.IsFile[i-1];
       SetLength(Result.FileName,Result.count);
       Result.FileName[Result.count-1]:=tempres.FileName[i-1];
      end;
    end
   else continue;
  end;
 FindClose(SearchRec);
 {Search for every file in the path base directory}
 Order:=0; bool:=false;
 while(Order=0)do
  begin
   if(ismask) and (bool=false) then
   Order:=FindFirst(inputbasedir,faAnyFile,SearchRec)
   else if(ismask=false) and (bool=false) then
   Order:=FindFirst(basedir+'/*',faAnyFile,SearchRec)
   else
   Order:=FindNext(SearchRec);
   if(Order<>0) then break;
   if(bool=false) then bool:=true;
   if(basedir='/') or (basedir='\') then tempstr:=basedir+SearchRec.Name
   else tempstr:=basedir+'/'+SearchRec.Name;
   if(SearchRec.Name='..') or (SearchRec.Name='.') then continue;
   if(SearchRec.Attr and faDirectory<>0) then continue;
   inc(Result.Count);
   SetLength(Result.FilePath,Result.count);
   Result.FilePath[Result.count-1]:=tempstr;
   SetLength(Result.IsFile,Result.count);
   Result.IsFile[Result.count-1]:=true;
   SetLength(Result.FileName,Result.count);
   Result.FileName[Result.count-1]:=ExtractFileName(tempstr);
  end;
 FindClose(SearchRec);
 {Then return the list for function}
end;
function geniso_create(fn:UnicodeString;vdcount:byte):geniso_iso_file;
var f:TFileStream;
    i:SizeUint;
    content:array[1..512] of dword;
begin
 f:=TFileStream.Create(UnicodeStringToString(fn),fmCreate);
 f.Seek(0,0);
 for i:=1 to 512 do content[i]:=0;
 Result.linkfn:=fn;
 i:=1;
 while(i<=16+vdcount)do
  begin
   f.Write(content,2048);
   inc(i);
  end;
 Result.isostart:=32768;
 Result.isovdcount:=vdcount;
 {Indicate the iso data segment is not defined.}
 Result.isootherstart:=32768+vdcount shl 11;
 f.Free;
end;
function geniso_generate_date_and_time(needzero:boolean=false):iso_date_time;
var tempst:TSystemTime;
begin
 if(needzero=false) then
  begin
   DateTimeToSystemTime(Now,tempst);
   Result.year[1]:=Char(Byte('0')+tempst.Year div 1000);
   Result.year[2]:=Char(Byte('0')+tempst.Year div 100 mod 10);
   Result.year[3]:=Char(Byte('0')+tempst.Year div 10 mod 10);
   Result.year[4]:=Char(Byte('0')+tempst.Year mod 10);
   Result.month[1]:=Char(Byte('0')+tempst.Month div 10);
   Result.month[2]:=Char(Byte('0')+tempst.Month mod 10);
   Result.day[1]:=Char(Byte('0')+tempst.Day div 10);
   Result.day[2]:=Char(Byte('0')+tempst.Day mod 10);
   Result.hour[1]:=Char(Byte('0')+tempst.Hour div 10);
   Result.hour[2]:=Char(Byte('0')+tempst.Hour mod 10);
   Result.minute[1]:=Char(Byte('0')+tempst.Minute div 10);
   Result.minute[2]:=Char(Byte('0')+tempst.Minute mod 10);
   Result.second[1]:=Char(Byte('0')+tempst.Second div 10);
   Result.second[2]:=Char(Byte('0')+tempst.Second mod 10);
   Result.hundredthsofASecond[1]:='0';
   Result.hundredthsofASecond[2]:=Char(Byte('0')+tempst.Millisecond div 100);
   Result.timezoneoffsetof15minuteintervals:=0;
  end
 else
  begin
   Result.year[1]:='0'; Result.year[2]:='0';
   Result.year[3]:='0'; Result.year[4]:='0';
   Result.month[1]:='0'; Result.month[2]:='0';
   Result.day[1]:='0'; Result.day[2]:='0';
   Result.hour[1]:='0'; Result.hour[2]:='0';
   Result.minute[1]:='0'; Result.minute[2]:='0';
   Result.second[1]:='0'; Result.second[2]:='0';
   Result.hundredthsofASecond[1]:='0'; Result.hundredthsofASecond[2]:='0';
   Result.timezoneoffsetof15minuteintervals:=0;
  end;
end;
function geniso_generate_directory_date_and_time:iso_directory_date_and_time;
var tempst:TSystemTime;
begin
 DateTimeToSystemTime(Now,tempst);
 Result.NumberOfYears:=tempst.Year-1900;
 Result.MonthOfYears:=tempst.Month;
 Result.DayOfMonth:=tempst.Day;
 Result.HourOfDay:=tempst.Hour;
 Result.MinuteOfHour:=tempst.Minute;
 Result.SecondOfMinute:=tempst.Second;
 Result.OffsetFromGreenWich:=0;
end;
function geniso_generate_directory_record(filename:UnicodeString;locatesector:SizeUint;
filesize:SizeUint;isfile:boolean=false):iso_directory_record;
var tempstr:PChar;
begin
 Result.LengthOfDirRecord:=33+length(filename)+1;
 Result.ExtendedAttributeRecordLength:=0;
 Result.LocationOfExtent:=iso_lsb_to_lsb_msb(iso_lsb_dword(locatesector));
 Result.DataLength:=iso_lsb_to_lsb_msb(iso_lsb_dword(filesize));
 Result.DateAndTime:=geniso_generate_directory_date_and_time;
 Result.FileUnitSize:=0;
 Pbyte(@Result.FileFlags)^:=0;
 Result.FileFlags.existence:=1;
 Result.FileFlags.Protection:=1;
 if(isfile=true) then Result.FileFlags.directory:=0 else Result.FileFlags.directory:=1;
 Result.InterLeaveGapSize:=0;
 Result.VolumeSequenceNumber:=iso_lsb_to_lsb_msb(iso_lsb_word(0));
 Result.LengthOfFileId:=length(filename);
 tempstr:=StringToPChar(UnicodeStringToString(filename+';'));
 Move(tempstr,Result.FileIdAndSystemUse,strlen(tempstr));
 FreeMem(tempstr);
end;
procedure geniso_rehandle_parent(tree:Pgeniso_temporary_tree);
var i:SizeUint;
begin
 i:=1;
 while(i<=tree^.count)do
  begin
   geniso_rehandle_parent(tree^.child+i-1);
   (tree^.child+i-1)^.parent:=tree;
   inc(i);
  end;
end;
procedure geniso_free_tree(var tree:Pgeniso_temporary_tree);
var temptree:Pgeniso_temporary_tree;
    i:SizeUint;
begin
 i:=1;
 while(i<=tree^.count)do
  begin
   temptree:=tree^.child+i-1;
   geniso_free_tree(temptree);
   inc(i);
  end;
 FreeMem(tree^.child);
end;
function geniso_generate_boot_catalog(entry:SizeUint):iso_el_torito_boot_catalog_needed;
var i:byte;
    w:Pword;
    cs:SizeUint;
begin
 Result.vaildation.HeaderId:=$01;
 Result.vaildation.PlatformId:=$00;
 Result.vaildation.Reserved:=$00;
 Move(iso_el_torito_manufacturer,Result.vaildation.Id,6);
 for i:=7 to 24 do Result.vaildation.id[i]:=#0;
 Result.vaildation.checksum:=0;
 Result.vaildation.key1:=$55;
 Result.vaildation.key2:=$AA;
 w:=PWord(@Result.vaildation); cs:=0; i:=1;
 while(i<=sizeof(iso_el_torito_vaildation_entry) shr 1)do
  begin
   cs:=cs+w^; inc(i); inc(w);
  end;
 Result.vaildation.checksum:=$FFFF-cs and $FFFF+1;
 Result.initial.bootIndicator:=$88;
 Result.initial.bootmediatype:=$0;
 Result.initial.LoadSegment:=$0;
 Result.initial.SystemType:=$0;
 Result.initial.Unused1:=0;
 Result.initial.SectorCount:=0;
 Result.initial.LoadRelativeBlockAddress:=entry;
 for i:=1 to 20 do Result.initial.Unused2[i]:=0;
end;
function geniso_construct_tree_from_external_path(extpath:geniso_external_path;needboot:boolean=false;
tree:Pgeniso_temporary_tree=nil;startindex:SizeUint=1;endindex:SizeUint=1):
Pgeniso_temporary_tree;
var i,j:SizeUint;
    isotree:Pgeniso_temporary_tree;
begin
 i:=startindex;
 if(tree=nil) then
  begin
   isotree:=allocmem(sizeof(geniso_temporary_tree));
   isotree^.parent:=nil;
   isotree^.FileName:='';
   isotree^.FileAttr:=false;
   isotree^.ExtFilePath:='';
   isotree^.child:=allocmem(sizeof(geniso_temporary_tree)*255);
   isotree^.count:=0;
   if(needboot) then
    begin
     inc(isotree^.count);
     (isotree^.child+isotree^.count-1)^.FileAttr:=true;
     (isotree^.child+isotree^.count-1)^.FileName:='boot.catalog';
     (isotree^.child+isotree^.count-1)^.ExtFilePath:='';
    end;
   Result:=isotree;
  end
 else
  begin
   isotree:=tree;
   isotree^.child:=allocmem(sizeof(geniso_temporary_tree)*255);
   inc(isotree^.count);
   (isotree^.child+isotree^.count-1)^.FileAttr:=true;
   (isotree^.child+isotree^.count-1)^.FileName:='';
   inc(isotree^.count);
   (isotree^.child+isotree^.count-1)^.FileAttr:=true;
   (isotree^.child+isotree^.count-1)^.FileName:='\1';
   (isotree^.child+isotree^.count-1)^.ExtFilePath:='';
  end;
 while(i<=endindex)do
  begin
   j:=i+1;
   while(j<=endindex)do
    begin
     if(geniso_compare_same_path(extpath.FilePath[i-1],extpath.FilePath[j-1])) then
      begin
       inc(isotree^.count);
       (isotree^.child+isotree^.count-1)^.FileAttr:=extpath.IsFile[i-1];
       (isotree^.child+isotree^.count-1)^.FileName:=extpath.FileName[i-1];
       (isotree^.child+isotree^.count-1)^.ExtFilePath:=extpath.FilePath[i-1];
       if(extpath.IsFile[i-1]=false) then
       geniso_construct_tree_from_external_path(extpath,false,isotree^.child+isotree^.count-1,i+1,j-1);
       i:=j;
      end;
     inc(j);
    end;
   if(j>endindex) and (i+1<=j-1) then
    begin
     inc(isotree^.count);
     ReallocMem(isotree^.child,isotree^.count*sizeof(geniso_temporary_tree));
     (isotree^.child+isotree^.count-1)^.FileAttr:=extpath.IsFile[i-1];
     (isotree^.child+isotree^.count-1)^.FileName:=extpath.FileName[i-1];
     (isotree^.child+isotree^.count-1)^.ExtFilePath:=extpath.FilePath[i-1];
     if(extpath.IsFile[i-1]=false) then
     geniso_construct_tree_from_external_path(extpath,false,isotree^.child+isotree^.count-1,i+1,j-1);
    end
   else if(j>endindex) and (i+1=j) then
    begin
     inc(isotree^.count);
     ReallocMem(isotree^.child,isotree^.count*sizeof(geniso_temporary_tree));
     (isotree^.child+isotree^.count-1)^.FileAttr:=extpath.IsFile[i-1];
     (isotree^.child+isotree^.count-1)^.FileName:=extpath.FileName[i-1];
     (isotree^.child+isotree^.count-1)^.ExtFilePath:=extpath.FilePath[i-1];
    end;
   if(j>endindex) then break;
  end;
 if(tree=nil) then geniso_rehandle_parent(isotree);
end;
function geniso_generate_filesystem_from_tree(var iso:geniso_iso_file;
tree:Pgeniso_temporary_tree;basedir:UnicodeString='/';PrevSector:SizeUint=0;PrevSize:SizeUint=0
):geniso_return;
var dirrec:iso_directory_record;
    occupysize,occupysector:SizeUint;
    i,startpos,StartSector:SizeUint;
    tempfullpath:UnicodeString;
    temppath,tempname:UnicodeString;
    catalogfile:iso_el_torito_boot_catalog_needed;
    content:geniso_content;
    catalogindex:SizeUint;
    tempsize,writeptr,filewriteptr:SizeUint;
begin
 i:=1; startpos:=iso.isootherstart+(NextFree shl 11); occupysize:=0;
 while(i<=tree^.count)do
  begin
   inc(occupysize,33+length(Pgeniso_temporary_tree(tree^.child+i-1)^.FileName)+1);
   inc(i);
  end;
 StartSector:=iso.isootherstart shr 11+NextFree;
 if(tree^.parent<>nil) then Result.OccupySize:=occupysize;
 writeptr:=0; catalogindex:=0;
 occupysector:=(occupysize+1 shl 11-1) shr 11;
 inc(NextFree,occupySector); i:=1;
 while(i<=tree^.count)do
  begin
   temppath:=Pgeniso_temporary_tree(tree^.child+i-1)^.ExtFilePath;
   if(Pgeniso_temporary_tree(tree^.child+i-1)^.FileAttr) then
   tempsize:=geniso_external_io_get_size(temppath)
   else
   tempsize:=occupysize;
   tempname:=Pgeniso_temporary_tree(tree^.child+i-1)^.FileName;
   if(basedir='/') or (basedir='\') then tempfullpath:=basedir+tempname
   else tempfullpath:=basedir+'/'+tempname;
   if(tempname='') then
   dirrec:=geniso_generate_directory_record(
   Pgeniso_temporary_tree(tree^.child+i-1)^.FileName,StartSector,occupysize)
   else if(tempname='\1') then
   dirrec:=geniso_generate_directory_record(
   Pgeniso_temporary_tree(tree^.child+i-1)^.FileName,PrevSector,PrevSize)
   else if(tempname='boot.catalog') then
   dirrec:=geniso_generate_directory_record(
   Pgeniso_temporary_tree(tree^.child+i-1)^.FileName,iso.isootherstart shr 11+NextFree,
   sizeof(iso_el_torito_boot_catalog_needed))
   else
   dirrec:=geniso_generate_directory_record(
   Pgeniso_temporary_tree(tree^.child+i-1)^.FileName,iso.isootherstart shr 11+NextFree,tempsize);
   geniso_io_write(iso,dirrec,StartSector shl 11+writeptr,dirrec.LengthOfDirRecord);
   inc(writeptr,dirrec.LengthOfDirRecord);
   if(Pgeniso_temporary_tree(tree^.child+i-1)^.FileAttr=false) and
   (Pgeniso_temporary_tree(tree^.child+i-1)^.FileName<>'') and
   (Pgeniso_temporary_tree(tree^.child+i-1)^.FileName<>'\1') then
    begin
     geniso_generate_filesystem_from_tree(iso,tree^.child+i-1,tempfullpath,StartSector,OccupySize);
    end
   else if(Pgeniso_temporary_tree(tree^.child+i-1)^.FileAttr)
   and (Pgeniso_temporary_tree(tree^.child+i-1)^.FileName='boot.catalog') then
    begin
     if(catalogindex=0) then catalogindex:=iso.isootherstart shr 11+NextFree;
     inc(NextFree);
    end
   else if(Pgeniso_temporary_tree(tree^.child+i-1)^.FileAttr) then
    begin
     {Check the file is Entry file for EL Torito}
     if(tree^.parent=nil) and (tempname=iso.isoentryname) then
      begin
       iso.isoentrySector:=iso.isootherstart shr 11+NextFree;
      end
     else if(tempfullpath=iso.isoentryname) then
      begin
       iso.isoentrySector:=iso.isootherstart shr 11+NextFree;
      end;
     {Copy the file to the iso file}
     filewriteptr:=0;
     while(tempsize>0)do
      begin
       if(tempsize<2048) then
        begin
         content.count:=tempsize;
         geniso_external_io_read_block(temppath,content,filewriteptr shl 11);
         geniso_io_write_block(iso,content,(iso.isootherstart shr 11+NextFree) shl 11);
         tempsize:=0;
        end
       else
        begin
         content.count:=2048;
         geniso_external_io_read_block(temppath,content,filewriteptr shl 11);
         geniso_io_write_block(iso,content,(iso.isootherstart shr 11+NextFree) shl 11);
         dec(tempsize,2048);
        end;
       inc(NextFree); inc(filewriteptr);
      end;
    end;
   inc(i);
  end;
 Result.CatalogIndex:=catalogindex;
 if(catalogindex<>0) then
  begin
   catalogfile:=geniso_generate_boot_catalog(iso.isoentrySector);
   geniso_io_write(iso,catalogfile,catalogindex shl 11,sizeof(iso_el_torito_boot_catalog_needed));
  end;
end;
function geniso_initialize(fn:UnicodeString;config:geniso_configure):geniso_iso_file;
var vd:iso_volume_descriptor;
    extpath:geniso_external_path;
    temptree:Pgeniso_temporary_tree;
    RetValue:geniso_return;
    i:word;
begin
 extpath:=geniso_get_external_path(config.sourcepath);
 {Generate the file tree}
 if(config.standard=iso_standard_none) then
  begin
   Result:=geniso_create(fn,2);
   temptree:=geniso_construct_tree_from_external_path(extpath,false,nil,1,extpath.Count)
  end
 else
  begin
   Result:=geniso_create(fn,3);
   Result.isoentryname:=config.entryfn;
   temptree:=geniso_construct_tree_from_external_path(extpath,true,nil,1,extpath.count);
  end;
 {Then burn it to the iso file}
 Retvalue:=geniso_generate_filesystem_from_tree(Result,temptree);
 {Free the file tree}
 geniso_free_tree(temptree);
 if(config.standard=iso_standard_none) then
  begin
   {Initialize the primary volume descriptor}
   iso_volume_descriptor_initialize(vd);
   vd.pvd.VolumeDescriptorType:=iso_type_volume_descriptor_primary_volume_descriptor;
   vd.pvd.Version:=$1;
   Move(iso_standard_id,vd.pvd.StandardId,5);
   Move(iso_system_id,vd.pvd.SystemIdentifier,5);
   for i:=6 to 32 do vd.pvd.SystemIdentifier[i]:=' ';
   Move(iso_volume_id,vd.pvd.VolumeIdentifier,5);
   for i:=6 to 32 do vd.pvd.VolumeIdentifier[i]:=' ';
   vd.pvd.LogicalBlockSize:=iso_lsb_to_lsb_msb(iso_lsb_word(2048));
   vd.pvd.LocationOfTypeLPathTable:=dword($00000000);
   vd.pvd.LocationOfOptionalTypeLPathTable:=dword($00000000);
   vd.pvd.LocationOfTypeMPathTable:=iso_lsb_to_msb(iso_lsb_dword($00000000));
   vd.pvd.LocationOfOptionalTypeMPathTable:=iso_lsb_to_msb(iso_lsb_dword($00000000));
   vd.pvd.PathTableSize:=iso_lsb_to_lsb_msb(iso_lsb_dword(0));
   Move(iso_volume_set_identifier,vd.pvd.VolumeSetIdentifier,12);
   for i:=13 to 128 do vd.pvd.VolumeSetIdentifier[i]:=' ';
   Move(iso_publisher_id,vd.pvd.PublisherIdentifier,12);
   for i:=13 to 128 do vd.pvd.PublisherIdentifier[i]:=' ';
   Move(iso_data_preparer_id,vd.pvd.DataPreparerIdentifier,6);
   for i:=7 to 128 do vd.pvd.DataPreparerIdentifier[i]:=' ';
   Move(iso_application_id,vd.pvd.ApplicationIdentifier,6);
   for i:=7 to 128 do vd.pvd.ApplicationIdentifier[i]:=' ';
   Move(iso_copyright_id,vd.pvd.CopyrightFileIdentifier,12);
   for i:=13 to 128 do vd.pvd.CopyrightFileIdentifier[i]:=' ';
   Move(iso_abstract_id,vd.pvd.AbstractFileIdentifier,11);
   for i:=11 to 128 do vd.pvd.AbstractFileIdentifier[i]:=' ';
   Move(iso_bibiliographic_id,vd.pvd.BibilographicFileIdentifier,14);
   for i:=15 to 128 do vd.pvd.BibilographicFileIdentifier[i]:=' ';
   {Initialize the Root Directory}
   vd.pvd.DirectoryEntryForRootDirectory.LengthOfDirRecord:=34;
   vd.pvd.DirectoryEntryForRootDirectory.ExtendedAttributeRecordLength:=0;
   vd.pvd.DirectoryEntryForRootDirectory.LocationOfExtent:=iso_lsb_to_lsb_msb(
   iso_lsb_dword(Result.isootherstart shr 11));
   vd.pvd.DirectoryEntryForRootDirectory.DataLength:=iso_lsb_to_lsb_msb(iso_lsb_dword(Retvalue.OccupySize));
   Pbyte(@vd.pvd.DirectoryEntryForRootDirectory.FileFlags)^:=0;
   vd.pvd.DirectoryEntryForRootDirectory.FileUnitSize:=0;
   vd.pvd.DirectoryEntryForRootDirectory.InterLeaveGapSize:=0;
   vd.pvd.DirectoryEntryForRootDirectory.FileFlags.existence:=1;
   vd.pvd.DirectoryEntryForRootDirectory.FileFlags.directory:=1;
   vd.pvd.DirectoryEntryForRootDirectory.VolumeSequenceNumber:=iso_lsb_to_lsb_msb(iso_lsb_word(0));
   vd.pvd.DirectoryEntryForRootDirectory.Padding:=0;
   vd.pvd.DirectoryEntryForRootDirectory.LengthOfFileId:=0;
   {Initialize the other}
   vd.pvd.VolumeCreationDateAndTime:=geniso_generate_date_and_time;
   vd.pvd.VolumeModificationDateAndTime:=geniso_generate_date_and_time;
   vd.pvd.VolumeExpirationDateAndTime:=geniso_generate_date_and_time(true);
   vd.pvd.VolumeEffectiveDateAndTime:=geniso_generate_date_and_time(true);
   vd.pvd.VolumeSetSize:=iso_lsb_to_lsb_msb(iso_lsb_word(0));
   vd.pvd.VolumeSequenceNumber:=iso_lsb_to_lsb_msb(iso_lsb_word(1));
   vd.pvd.FileStructureVersion:=$1;
   geniso_io_write(Result,vd,Result.isostart,sizeof(iso_volume_descriptor));
   {Initialize the volume set terminator}
   iso_volume_descriptor_initialize(vd);
   vd.st.VolumeDescriptorType:=iso_type_volume_descriptor_set_terminator;
   Move(iso_standard_id,vd.st.Id,5);
   vd.st.Version:=$1;
   geniso_io_write(Result,vd,Result.isostart+2048,sizeof(iso_volume_descriptor));
  end
 else if(config.standard=iso_standard_el_torito) then
  begin
   iso_volume_descriptor_initialize(vd);
   vd.pvd.VolumeDescriptorType:=iso_type_volume_descriptor_primary_volume_descriptor;
   vd.pvd.Version:=$1;
   Move(iso_standard_id,vd.pvd.StandardId,5);
   Move(iso_system_id,vd.pvd.SystemIdentifier,5);
   for i:=6 to 32 do vd.pvd.SystemIdentifier[i]:=' ';
   Move(iso_volume_id,vd.pvd.VolumeIdentifier,5);
   for i:=6 to 32 do vd.pvd.VolumeIdentifier[i]:=' ';
   vd.pvd.LogicalBlockSize:=iso_lsb_to_lsb_msb(iso_lsb_word(2048));
   vd.pvd.LocationOfTypeLPathTable:=dword($00000000);
   vd.pvd.LocationOfOptionalTypeLPathTable:=dword($00000000);
   vd.pvd.LocationOfTypeMPathTable:=iso_lsb_to_msb(iso_lsb_dword($00000000));
   vd.pvd.LocationOfOptionalTypeMPathTable:=iso_lsb_to_msb(iso_lsb_dword($00000000));
   vd.pvd.PathTableSize:=iso_lsb_to_lsb_msb(iso_lsb_dWord(0));
   Move(iso_volume_set_identifier,vd.pvd.VolumeSetIdentifier,12);
   for i:=13 to 128 do vd.pvd.VolumeSetIdentifier[i]:=' ';
   Move(iso_publisher_id,vd.pvd.PublisherIdentifier,12);
   for i:=13 to 128 do vd.pvd.PublisherIdentifier[i]:=' ';
   Move(iso_data_preparer_id,vd.pvd.DataPreparerIdentifier,6);
   for i:=7 to 128 do vd.pvd.DataPreparerIdentifier[i]:=' ';
   Move(iso_application_id,vd.pvd.ApplicationIdentifier,6);
   for i:=7 to 128 do vd.pvd.ApplicationIdentifier[i]:=' ';
   Move(iso_copyright_id,vd.pvd.CopyrightFileIdentifier,12);
   for i:=13 to 128 do vd.pvd.CopyrightFileIdentifier[i]:=' ';
   Move(iso_abstract_id,vd.pvd.AbstractFileIdentifier,11);
   for i:=11 to 128 do vd.pvd.AbstractFileIdentifier[i]:=' ';
   Move(iso_bibiliographic_id,vd.pvd.BibilographicFileIdentifier,14);
   for i:=15 to 128 do vd.pvd.BibilographicFileIdentifier[i]:=' ';
   {Initialize the Root Directory}
   vd.pvd.DirectoryEntryForRootDirectory.LengthOfDirRecord:=34;
   vd.pvd.DirectoryEntryForRootDirectory.ExtendedAttributeRecordLength:=0;
   vd.pvd.DirectoryEntryForRootDirectory.LocationOfExtent:=iso_lsb_to_lsb_msb(
   iso_lsb_Dword(Result.isootherstart shr 11));
   vd.pvd.DirectoryEntryForRootDirectory.DataLength:=iso_lsb_to_lsb_msb(iso_lsb_dword(Retvalue.OccupySize));
   Pbyte(@vd.pvd.DirectoryEntryForRootDirectory.FileFlags)^:=0;
   vd.pvd.DirectoryEntryForRootDirectory.FileUnitSize:=0;
   vd.pvd.DirectoryEntryForRootDirectory.InterLeaveGapSize:=0;
   vd.pvd.DirectoryEntryForRootDirectory.FileFlags.existence:=1;
   vd.pvd.DirectoryEntryForRootDirectory.FileFlags.directory:=1;
   vd.pvd.DirectoryEntryForRootDirectory.VolumeSequenceNumber:=iso_lsb_to_lsb_msb(iso_lsb_Word(0));
   vd.pvd.DirectoryEntryForRootDirectory.Padding:=0;
   vd.pvd.DirectoryEntryForRootDirectory.LengthOfFileId:=0;
   {Initialize the other}
   vd.pvd.VolumeCreationDateAndTime:=geniso_generate_date_and_time;
   vd.pvd.VolumeModificationDateAndTime:=geniso_generate_date_and_time;
   vd.pvd.VolumeExpirationDateAndTime:=geniso_generate_date_and_time(true);
   vd.pvd.VolumeEffectiveDateAndTime:=geniso_generate_date_and_time(true);
   vd.pvd.VolumeSetSize:=iso_lsb_to_lsb_msb(iso_lsb_word(0));
   vd.pvd.VolumeSequenceNumber:=iso_lsb_to_lsb_msb(iso_lsb_word(1));
   vd.pvd.FileStructureVersion:=$1;
   geniso_io_write(Result,vd,Result.isostart,sizeof(iso_volume_descriptor));
   {Initialize the Boot Record}
   iso_volume_descriptor_initialize(vd);
   vd.brei.VolumeDescriptorType:=iso_type_volume_descriptor_boot_record;
   vd.brei.Version:=$1;
   Move(iso_standard_id,vd.brei.Id,5);
   Move(iso_el_torito_id,vd.brei.BootSystemId,23);
   for i:=24 to 32 do vd.brei.BootSystemId[i]:=#0;
   for i:=1 to 32 do vd.brei.BootId[i]:=#0;
   vd.brei.BootCatalogAddress:=Retvalue.CatalogIndex;
   geniso_io_write(Result,vd,Result.isostart+2048,sizeof(iso_volume_descriptor));
   {Initialize the Volume Set Terminator}
   iso_volume_descriptor_initialize(vd);
   vd.st.VolumeDescriptorType:=iso_type_volume_descriptor_set_terminator;
   Move(iso_standard_id,vd.st.Id,5);
   vd.st.Version:=$1;
   geniso_io_write(Result,vd,Result.isostart+4096,sizeof(iso_volume_descriptor));
  end;
end;
function geniso_construct_config(srcpath,standard,entryfilename:UnicodeString):geniso_configure;
begin
 if(DirectoryExists(srcpath)=false) and (FileExists(srcpath)=false) then
  begin
   writeln('ERROR:Directory or File '+srcpath+' does not exist.');
   readln;
   abort;
  end
 else Result.sourcepath:=srcpath;
 if(LowerCase(standard)='none') or (standard='')
 or(LowerCase(standard)='iso9660') then Result.standard:=iso_standard_none
 else if(LowerCase(standard)='eltorito') then Result.standard:=iso_standard_el_torito
 else
  begin
   writeln('ERROR:Standard '+standard+' unrecognized.');
   readln;
   abort;
  end;
 Result.entryfn:=entryfilename;
end;

end.

