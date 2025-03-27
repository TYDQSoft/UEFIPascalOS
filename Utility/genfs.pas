program genfs;

{$mode ObjFPC}

uses genfsbase,fsbase,sysutils,classes;

function StrToInt(str:UnicodeString):SizeInt;
var i,len:SizeUint;
begin
 Result:=0; len:=length(str);
 if(length(str)=0) then exit(Result)
 else
  begin
   if(str[1]='-') then
    begin
     i:=2;
     while(i<=len)do
      begin
       Result:=Result*10+Word(str[i])-Word('0');
       inc(i);
      end;
     Result:=-Result;
    end
   else
    begin
     i:=1;
     while(i<=len)do
      begin
       Result:=Result*10+Word(str[i])-Word('0');
       inc(i);
      end;
    end;
  end;
end;
function genfs_size_to_number(inputsize:UnicodeString):SizeUint;
var i,len:SizeUint;
    size:UnicodeString;
begin
 size:=UpperCase(inputsize);
 len:=length(size);
 if(UpperCase(Copy(size,len-2,3))='MIB') then
  begin
   Result:=StrToInt(Copy(size,1,len-3));
  end
 else if(UpperCase(Copy(size,len-2,3))='GIB') then
  begin
   Result:=StrToInt(Copy(size,1,len-3)) shl 10;
  end
 else if(UpperCase(Copy(size,len-2,3))='TIB') then
  begin
   Result:=StrToInt(Copy(size,1,len-3)) shl 20;
  end
 else if(UpperCase(Copy(size,len-1,2))='MB') then
  begin
   Result:=StrToInt(Copy(size,1,len-2));
  end
 else if(UpperCase(Copy(size,len-1,2))='GB') then
  begin
   Result:=StrToInt(Copy(size,1,len-2)) shl 10;
  end
 else if(UpperCase(Copy(size,len-1,2))='TB') then
  begin
   Result:=StrToInt(Copy(size,1,len-2)) shl 20;
  end
 else
  begin
   writeln('ERROR:Unrecognized Size Number '+size+'.');
   readln;
   abort;
  end;
end;
procedure genfs_version;
begin
 writeln('genfs(File System Generator) version Alpha 0.0.4');
end;
procedure genfs_sketchy_help;
begin
 writeln('Supported File System types until now:FAT12,FAT16,FAT32.');
 writeln('Command Template:genfs [command] [command parameters].');
 writeln('Vaild Commands:help/create/add/copy/move/replace/delete/extract');
 writeln('               /copyto/copyfrom/moveto/movefrom/replaceto/replacefrom');
 writeln('               help [commands] can show you the specific help for specified command.');
 writeln('               help can show this sketchy help.');
 writeln('               No parameters can also show this sketchy help.');
end;
procedure genfs_detailed_help(cmd:UnicodeString);
begin
 writeln('Tips:When the command paramater has one path,the only path(Not image path)can be wildcarded.');
 writeln('     When two paths,the first path(Not image path) can be wildcarded.');
 if(LowerCase(cmd)='create') then
  begin
   writeln('Create means create a virtual image with specified File System');
   writeln('Template:genfs create [Image name] [File System Type] [Size in MiB(default)]');
   writeln('Example:genfs create fat.img fat32 64MB');
  end
 else if(LowerCase(cmd)='add') then
  begin
   writeln('Add means add a file or directory with files to specified path in image file.');
   writeln('Template:genfs add [Image name] [Source External Path] [Destination Internal Path]');
   writeln('Example:genfs add fat.img E:\LazarusProject\genfs\genfsbase.pas /genfsbase.pas');
  end
 else if(LowerCase(cmd)='copy') then
  begin
   writeln('Copy has two means:');
   writeln('Firstly,copy means copy a file from source path to destination path both in image file.');
   writeln('Template:genfs copy [Image name] [Source Internal Path] [Destination Internal Path]');
   writeln('Example:genfs copy fat.img /genfsbase.pas /test/genfsbase.pas');
   writeln('Secondly,copy means copy a file from source path to destination path in two image files.');
   writeln('Template:genfs copy [First Image Name] [Source Internal Path in Image first] [Second Image Name]'
   +'[Destination Internal Path in Image first]');
   writeln('Example:genfs copy fat.img /genfsbase.pas /test/genfsbase.pas');
  end
 else if(LowerCase(cmd)='copyto') then
  begin
   writeln('Copyto means copy a file from source internal path to destination external path.');
   writeln('Template:genfs copy [Image name] [Source Internal Path] [Destination External Path]');
   writeln('Example:genfs copyto fat.img /genfsbase.pas E:/genfsbase.pas');
  end
 else if(LowerCase(cmd)='copyfrom') then
  begin
   writeln('Copyto means copy a file from destination external path to source internal path.');
   writeln('Template:genfs copyfrom [Image name] [Source Internal Path] [Destination External Path]');
   writeln('Example:genfs copyfrom fat.img /genfsbase.pas E:/genfsbase.pas');
  end
 else if(LowerCase(cmd)='move') then
  begin
   writeln('move has two means:');
   writeln('Firstly,move means move a file from source path to destination path both in image file.');
   writeln('Template:genfs move [Image name] [Source Internal Path] [Destination Internal Path]');
   writeln('Example:genfs move fat.img /genfsbase.pas /test/genfsbase.pas');
   writeln('Secondly,move means move a file from source path to destination path in two image files.');
   writeln('Template:genfs move [First Image Name] [Source Internal Path in Image first] [Second Image Name]'+'[Destination Internal Path in Image first]');
   writeln('Example:genfs move fat.img /genfsbase.pas /test/genfsbase.pas');
  end
 else if(LowerCase(cmd)='moveto') then
  begin
   writeln('moveto means move a file from source internal path to destination external path.');
   writeln('Template:genfs move [Image name] [Source Internal Path] [Destination External Path]');
   writeln('Example:genfs moveto fat.img /genfsbase.pas E:/genfsbase.pas');
  end
 else if(LowerCase(cmd)='movefrom') then
  begin
   writeln('moveto means move a file from destination external path to source internal path.');
   writeln('Template:genfs movefrom [Image name] [Source Internal Path] [Destination External Path]');
   writeln('Example:genfs movefrom fat.img /genfsbase.pas E:/genfsbase.pas');
  end
 else if(LowerCase(cmd)='replace') then
  begin
   writeln('replace has two means:');
   writeln('Firstly,replace means replace a file from source path to destination path both in image file.');
   writeln('Template:genfs replace [Image name] [Source Internal Path] [Destination Internal Path]');
   writeln('Example:genfs replace fat.img /genfsbase.pas /test/genfsbase.pas');
   writeln('Secondly,replace means replace a file from source path to destination path in two image files.');
   writeln('Template:genfs replace [First Image Name] [Source Internal Path in Image first] [Second Image Name]'+'[Destination Internal Path in Image first]');
   writeln('Example:genfs replace fat.img /genfsbase.pas /test/genfsbase.pas');
  end
 else if(LowerCase(cmd)='replaceto') then
  begin
   writeln('replaceto means replace a file from source internal path to destination external path.');
   writeln('Template:genfs replace [Image name] [Source Internal Path] [Destination External Path]');
   writeln('Example:genfs replaceto fat.img /genfsbase.pas E:/genfsbase.pas');
  end
 else if(LowerCase(cmd)='replacefrom') then
  begin
   writeln('replaceto means replace a file from destination external path to source internal path.');
   writeln('Template:genfs replacefrom [Image name] [Source Internal Path] [Destination External Path]');
   writeln('Example:genfs replacefrom fat.img /genfsbase.pas E:/genfsbase.pas');
  end
 else if(LowerCase(cmd)='delete') then
  begin
   writeln('Delete has two means:');
   writeln('Firstly,Delete a file or directory in specific image.');
   writeln('Template:genfs delete [Image name] [Delete path]');
   writeln('Example:genfs delete fat.img /genfsbase.pas');
   writeln('Secondly,Delete a image.');
   writeln('Template:genfs delete [Image name] [Delete path]');
   writeln('Example:genfs delete fat.img');
  end
 else if(LowerCase(cmd)='erase') then
  begin
   writeln('erase has two means:');
   writeln('Firstly,erase a file or directory in specific image.');
   writeln('Template:genfs erase [Image name] [erase path]');
   writeln('Example:genfs erase fat.img /genfsbase.pas');
   writeln('Secondly,erase a image.');
   writeln('Template:genfs erase [Image name] [erase path]');
   writeln('Example:genfs erase fat.img');
  end
 else if(LowerCase(cmd)='extract') then
  begin
   writeln('Extract means extract a file to external from an image file.');
   writeln('Template:genfs extract [Image name] [Source internal path] [Destination external path]');
   writeln('Example:genfs extract fat.img /genfsbase.pas E:/genfsbase.pas');
  end
 else if(LowerCase(cmd)='imgcopy') then
  begin
   writeln('Imgcopy means copy a image from source to destination.');
   writeln('Template:genfs imgcopy [Source] [Destination]');
   writeln('Example:genfs imgcopy fat.img fat2.img');
  end
 else if(LowerCase(cmd)='imgmove') then
  begin
   writeln('Imgcopy means move a image from source to destination.');
   writeln('Template:genfs imgmove [Source] [Destination]');
   writeln('Example:genfs imgmove fat.img fat2.img');
  end
 else if(LowerCase(cmd)='imgreplace') then
  begin
   writeln('Imgcopy means replace a image from source to destination.');
   writeln('Template:genfs imgreplace [Source] [Destination]');
   writeln('Example:genfs imgreplace fat.img fat2.img');
  end
 else
  begin
   writeln('Command '+cmd+' Not found and its help does not exist.');
   writeln('please input another command as alternative.');
  end;
end;
procedure genfs_run_command(param:array of Unicodestring);
var pcount:SizeUint;
    fs1,fs2:genfs_filesystem;
begin
 pcount:=length(param);
 genfs_version;
 if(pcount<1) then
  begin
   writeln('No parameters,show the sketchy help.');
   genfs_sketchy_help;
   readln;
  end
 else if(pcount=1) then
  begin
   writeln('Parameters too few,show the sketchy help.');
   genfs_sketchy_help;
   readln;
  end
 else if(pcount=2) and (param[0]='help') then
  begin
   genfs_detailed_help(param[1]);
   readln;
  end
 else
  begin
   if(LowerCase(param[0])='create') then
    begin
     if(LowerCase(param[2])='fat32') or (genfs_size_to_number(param[3])>2048) then
     fs1:=genfs_filesystem_create(param[1],filesystem_fat32,
     genfs_size_to_number(param[3]),[Word(512),Byte(1),Word(8),
     Word(genfs_size_to_number(param[3]) shl 4),Word(6),Word(1),Word(2)])
     else if(LowerCase(param[2])='fat16') or (genfs_size_to_number(param[3])>60) then
     fs1:=genfs_filesystem_create(param[1],filesystem_fat16,
     genfs_size_to_number(param[3]),[Word(512),Byte(1),Word(2),
     Word(genfs_size_to_number(param[3]) shl 4)])
     else if(LowerCase(param[2])='fat12') then
     fs1:=genfs_filesystem_create(param[1],filesystem_fat12,
     genfs_size_to_number(param[3]),[Word(512),Byte(1),Word(2),
     Word(genfs_size_to_number(param[3]) shl 4)])
     else
      begin
       writeln('ERROR:File System '+param[2]+' unsupported.');
      end;
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='add') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>4) then
      begin
       writeln('ERROR:Parameter must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_add(fs1,param[2],param[3]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='copy') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount=4) then
      begin
       fs1:=genfs_filesystem_read(param[1]);
       genfs_filesystem_copy(fs1,param[2],param[3]);
       genfs_filesystem_free(fs1);
      end
     else if(pcount=5) then
      begin
       fs1:=genfs_filesystem_read(param[1]);
       fs2:=genfs_filesystem_read(param[3]);
       genfs_filesystem_copy(fs1,fs2,param[2],param[4]);
       genfs_filesystem_free(fs1);
       genfs_filesystem_free(fs2);
      end
     else
      begin
       writeln('ERROR:Parameter must be 4 or 5.');
       readln;
       abort;
      end;
    end
   else if(LowerCase(param[0])='copyto') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>4) then
      begin
       writeln('ERROR:Parameter must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_copy_to_external(fs1,param[2],param[3]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='copyfrom') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>4) then
      begin
       writeln('ERROR:Parameter must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_copy_from_external(fs1,param[2],param[3]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='move') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount=4) then
      begin
       fs1:=genfs_filesystem_read(param[1]);
       genfs_filesystem_move(fs1,param[2],param[3]);
       genfs_filesystem_free(fs1);
      end
     else if(pcount=5) then
      begin
       fs1:=genfs_filesystem_read(param[1]);
       fs2:=genfs_filesystem_read(param[3]);
       genfs_filesystem_move(fs1,fs2,param[2],param[4]);
       genfs_filesystem_free(fs1);
       genfs_filesystem_free(fs2);
      end
     else
      begin
       writeln('ERROR:Parameter must be 4 or 5.');
       readln;
       abort;
      end;
    end
   else if(LowerCase(param[0])='moveto') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>4) then
      begin
       writeln('ERROR:Parameter must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_move_to_external(fs1,param[2],param[3]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='movefrom') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>4) then
      begin
       writeln('ERROR:Parameter must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_move_from_external(fs1,param[2],param[3]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='delete') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount=3) then
      begin
       fs1:=genfs_filesystem_read(param[1]);
       genfs_filesystem_delete(fs1,param[2],true);
       genfs_filesystem_free(fs1);
      end
     else if(pcount=2) then
      begin
       DeleteFile(param[1]);
      end
     else
      begin
       writeln('ERROR:Parameter must be 2 or 3.');
       readln;
       abort;
      end;
    end
   else if(LowerCase(param[0])='replace') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount=4) then
      begin
       fs1:=genfs_filesystem_read(param[1]);
       genfs_filesystem_replace(fs1,param[2],param[3]);
       genfs_filesystem_free(fs1);
      end
     else if(pcount=5) then
      begin
       fs1:=genfs_filesystem_read(param[1]);
       fs2:=genfs_filesystem_read(param[3]);
       genfs_filesystem_replace(fs1,fs2,param[2],param[4]);
       genfs_filesystem_free(fs1);
       genfs_filesystem_free(fs2);
      end
     else
      begin
       writeln('ERROR:Parameter must be 4 or 5.');
       readln;
       abort;
      end;
    end
   else if(LowerCase(param[0])='replaceto') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>4) then
      begin
       writeln('ERROR:Parameter must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_replace_to_external(fs1,param[2],param[3]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='replacefrom') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>4) then
      begin
       writeln('ERROR:Parameter must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_replace_from_external(fs1,param[2],param[3]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='delete') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount=3) then
      begin
       fs1:=genfs_filesystem_read(param[1]);
       genfs_filesystem_delete(fs1,param[2],true);
       genfs_filesystem_free(fs1);
      end
     else if(pcount=2) then
      begin
       DeleteFile(param[1]);
      end
     else
      begin
       writeln('ERROR:Parameter must be 2 or 3.');
       readln;
       abort;
      end;
    end
   else if(LowerCase(param[0])='extract') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>4) then
      begin
       writeln('ERROR:Parameter count must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_extract(fs1,param[2],param[3]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='imgcopy') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>3) then
      begin
       writeln('ERROR:Parameter count must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_image_copy(fs1,param[2]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='imgmove') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>3) then
      begin
       writeln('ERROR:Parameter count must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_image_move(fs1,param[2]);
     genfs_filesystem_free(fs1);
    end
   else if(LowerCase(param[0])='imgreplace') then
    begin
     if(FileExists(param[1])=false) then
      begin
       writeln('ERROR:Image File does not exist.');
       readln;
       abort;
      end;
     if(pcount<>3) then
      begin
       writeln('ERROR:Parameter count must be 4.');
       readln;
       abort;
      end;
     fs1:=genfs_filesystem_read(param[1]);
     genfs_filesystem_image_replace(fs1,param[2]);
     genfs_filesystem_free(fs1);
    end;
   writeln('Command ',param[0],' successfully done!');
  end;
end;
var myparam:array of Unicodestring;
    i:SizeUint;
begin
 SetLength(myparam,ParamCount);
 for i:=1 to ParamCount do
  begin
   myparam[i-1]:=StringToUnicodeString(ParamStr(i));
  end;
 genfs_run_command(myparam); 
end.
