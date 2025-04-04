program geniso;

{$mode ObjFPC}

uses genisobase;

var config:geniso_configure;

function StringToUnicodeString(str:string):UnicodeString;
var i:SizeUint;
begin
 Result:='';
 for i:=1 to length(str) do Result:=Result+WideChar(str[i]);
end;
begin
 writeln('geniso(CD ISO Image Generator) version alpha v0.0.1');
 {Scan the parameter}
 if(ParamCount<3) then
  begin
   writeln('geniso:Parameter too low(must be 3 or 4 parameters),show the help.');
   writeln('Template:geniso [ISO Name] [Source Path] [Standard Name] [Entry File Name(Optional)]');
   writeln('ISO Name:new iso file name.');
   writeln('Source Path:the source path you want to pack to the iso file.');
   writeln('Standard Name:ISO Standard Name,Vaild is none(indicate is default,ISO9660) or EL torito.');
   writeln('Entry File Name:Entry File Name for EL torito standard,if you use standard ISO9660,this is ignored.');
   readln;
  end
 else if(ParamCount>4) then
  begin
   writeln('geniso:Parameter too much(must be 3 or 4 parameters),show the help.');
   writeln('Template:geniso [ISO Name] [Source Path] [Standard Name] [Entry File Name(Optional)]');
   writeln('ISO Name:new iso file name.');
   writeln('Source Path:the source path you want to pack to the iso file.');
   writeln('Standard Name:ISO Standard Name,Vaild is none(indicate is default,ISO9660) or EL torito.');
   writeln('Entry File Name:Entry File Name for EL torito standard,if you use standard ISO9660,this is ignored.');
   readln;
  end
 else if(paramCount=3) then
  begin
   config:=geniso_construct_config(
   StringToUnicodeString(paramStr(2)),StringToUnicodeString(paramstr(3)),'');
   geniso_initialize(StringToUnicodeString(paramStr(1)),config);
   writeln('Command Done!');
  end
 else if(ParamCount=4) then
  begin
   config:=geniso_construct_config(
   StringToUnicodeString(paramStr(2)),StringToUnicodeString(paramstr(3)),
   StringToUnicodeString(paramstr(4)));
   geniso_initialize(StringToUnicodeString(paramStr(1)),config);
   writeln('Command Done!');
  end;
end.

