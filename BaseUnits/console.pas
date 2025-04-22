unit console;

interface

uses graphics;

type console_string=packed record
                    content:PWideChar;
                    color:graph_color;
                    endline:boolean;
                    end;
     Pconsole_string=^console_string;
     console_screen=packed record
                    buffer:^console_string;
                    count:natuint;
                    charcount:natuint;
                    maxcharcount:natuint;
                    row:word;
                    maxrow:word;
                    column:word;
                    maxcolumn:word;
                    end;
     Pconsole_screen=^console_screen;

function console_screen_init(maxrow,maxcolumn:natuint):console_screen;
procedure console_screen_free(var cs:console_screen);
procedure console_screen_add_String(var cs:console_screen;str:PWideChar;color:graph_color);
procedure console_draw(cs:console_screen;ptr:Pointer;startx,starty:Integer);

implementation

function console_generate_console_string(content:PWideChar;color:graph_color;endline:boolean):console_string;
var res:console_string;
begin
 res.content:=Wstrcreate(content); res.endline:=endline; res.color:=color;
 console_generate_console_string:=res;
end;
procedure console_free_console_string(var cstr:console_string);
begin
 FreeMem(cstr.content); cstr.endline:=false; cstr.color:=graph_color_none;
end;
function console_screen_init(maxrow,maxcolumn:natuint):console_screen;
var res:console_screen;
begin
 res.buffer:=nil; res.count:=0;
 res.row:=0; res.maxrow:=maxrow;
 res.column:=0; res.maxcolumn:=maxcolumn;
 console_screen_init:=res;
end;
procedure console_screen_free(var cs:console_screen);
begin
 FreeMem(cs.buffer); cs.count:=0; cs.charcount:=0; cs.maxcharcount:=0;
 cs.row:=0; cs.maxrow:=0; cs.column:=0; cs.maxcolumn:=0;
end;
procedure console_screen_roll_screen(var cs:console_screen;rollrow:word);
var i,j,delrow:natuint;
    interval:natuint;
    tempcstr:console_string;
begin
 i:=1; j:=1; delrow:=0;
 while(delrow<=rollrow)do
  begin
   if(Pconsole_string(cs.buffer+i-1)^.endline) or (i=cs.count) then
    begin
     inc(delrow);
     while(j<=i)do
      begin
       tempcstr:=Pconsole_string(cs.buffer+j-1)^;
       console_free_console_string(tempcstr);
       tempcstr.content:=nil;
       inc(j);
      end;
     if(delrow>rollrow) then break;
     j:=i+1;
    end;
   inc(i);
  end;
 interval:=i;
 while(i<cs.count)do
  begin
   Pconsole_string(cs.buffer+i-1)^:=Pconsole_string(cs.buffer+i-interval-1)^;
   inc(i);
  end;
 cs.count:=cs.count-interval;
 cs.row:=cs.row-delrow+1;
 ReallocMem(cs.buffer,cs.count*sizeof(console_string));
end;
procedure console_screen_add_console_string(var cs:console_screen;cstr:console_string);
begin
 inc(cs.count);
 ReallocMem(cs.buffer,sizeof(console_string)*cs.count);
 Pconsole_string(cs.buffer+cs.count-1)^:=cstr;
end;
procedure console_screen_add_String(var cs:console_screen;str:PWideChar;color:graph_color);
var i,j:natuint;
    partstr:PWideChar;
    tempcstr:console_string;
begin
 i:=1; j:=1;
 while((str+i-1)^<>#0)do
  begin
   inc(cs.column);
   if((str+i-1)^=#10) or ((str+i-1)^=#13) then
    begin
     partstr:=Wstrcutout(str,j,i-j);
     tempcstr:=console_generate_console_string(partstr,color,true);
     console_screen_add_console_string(cs,tempcstr);
     inc(cs.row); cs.column:=0; j:=i+1;
    end
   else if(cs.column>=cs.maxcolumn) then
    begin
     partstr:=Wstrcutout(str,j,i-j+1);
     tempcstr:=console_generate_console_string(partstr,color,false);
     console_screen_add_console_string(cs,tempcstr);
     inc(cs.row); cs.column:=0; j:=i+1;
    end
   else if((str+i)^=#0) then
    begin
     tempcstr:=console_generate_console_string(partstr,color,false);
     console_screen_add_console_string(cs,tempcstr);
    end;
   inc(i);
  end;
 if(cs.row>=cs.maxrow) then console_screen_roll_screen(cs,cs.row-cs.maxrow);
end;
procedure console_draw(cs:console_screen;ptr:Pointer;startx,starty:Integer);
var cx,cy:Integer;
    i:natuint;
begin
 cx:=startx; cy:=starty;
 for i:=1 to cs.count do
  begin
   graph_heap_draw_graph_string(ptr,cx,cy,Pconsole_string(cs.buffer+i-1)^.content,
   Pconsole_string(cs.buffer+i-1)^.color);
   if(Pconsole_string(cs.buffer+i-1)^.endline) then
    begin
     inc(cy,32); cx:=0;
    end
   else
    begin
     inc(cx,16*Wstrlen(Pconsole_string(cs.buffer+i-1)^.content));
    end;
  end;
end;

end.

