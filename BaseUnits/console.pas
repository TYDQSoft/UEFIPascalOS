unit console;

{$mode ObjFPC}{$H+}

interface

uses graphics;

type console_string=packed record
                    Line:boolean;
                    Content:string;
                    Color:graph_color;
                    end;
     console_screen=class
                    private
                    XPosition,YPosition:Natint;
                    Content:array of console_string;
                    Count:Natuint;
                    CurrentColumn,CurrentRow:Natuint;
                    MaxColumn,MaxRow:Natuint;
                    procedure RollConsole;
                    public
                    constructor Create(InputMaxColumn,InputMaxRow,InputXPosition,InputYPosition:Natuint);
                    destructor Destroy;
                    procedure AddString(InputContent:string;Color:graph_color);
                    procedure GetPosition(var OutputXPosition:Natint;var OutputYPosition:Natint);
                    procedure ChangePosition(InputXPosition,InputYPosition:Natint);
                    procedure DrawConsole(Index:Dword;FontIndex:byte);
                    end;

implementation

procedure console_screen.RollConsole;
var i,j,RollCount:Natuint;
begin
 if(CurrentRow>MaxRow) then
  begin
   RollCount:=CurrentRow-MaxRow; i:=1;
   while(i<=RollCount)do
    begin
     j:=1;
     while(j<=Self.Count) and (Self.Content[j-1].Line=false) do inc(j);
     if(j>Self.Count) then j:=Self.Count;
     Delete(Self.Content,0,j); dec(Self.Count,j);
     inc(i);
    end;
  end;
end;
constructor console_screen.Create(InputMaxColumn,InputMaxRow,InputXPosition,InputYPosition:Natuint);
begin
 SetLength(Self.Content,0); Self.Count:=0;
 Self.XPosition:=InputXPosition; Self.YPosition:=InputYPosition;
 Self.CurrentColumn:=1; Self.CurrentRow:=1;
 Self.MaxColumn:=InputMaxColumn; Self.MaxRow:=InputMaxRow;
end;
destructor console_screen.Destroy;
begin
 SetLength(Self.Content,0); Self.Count:=0;
 Self.XPosition:=0; Self.YPosition:=0;
 Self.CurrentColumn:=0; Self.CurrentRow:=0;
 Self.MaxColumn:=0; Self.MaxRow:=0;
end;
procedure console_screen.AddString(InputContent:String;Color:graph_color);
var len,offset:Natuint;
    tempstr:string;
begin
 len:=length(InputContent); offset:=1;
 while(Self.CurrentColumn+len>Self.MaxColumn)do
  begin
   tempstr:=Copy(InputContent,offset,Self.MaxColumn-Self.CurrentColumn+1);
   inc(offset,length(tempstr));
   inc(self.Count);
   SetLength(self.Content,Self.Count);
   self.Content[Self.Count-1].Line:=true;
   self.Content[Self.Count-1].Content:=tempstr;
   self.Content[Self.Count-1].Color:=color;
   inc(Self.CurrentRow,1);
   dec(len,Self.MaxColumn-Self.CurrentColumn+1);
   Self.CurrentColumn:=1;
  end;
 if(len>0) then
  begin
   tempstr:=Copy(InputContent,offset,len);
   inc(self.Count);
   SetLength(self.Content,Self.Count);
   self.Content[Self.Count-1].Line:=false;
   self.Content[Self.Count-1].Content:=tempstr;
   self.Content[Self.Count-1].Color:=color;
   inc(Self.CurrentColumn,len);
  end;
 if(Self.CurrentRow>Self.MaxRow) then Self.RollConsole;
end;
procedure console_screen.ChangePosition(InputXPosition,InputYPosition:Natint);
begin
 Self.XPosition:=InputXPosition; Self.YPosition:=InputYPosition;
end;
procedure console_screen.GetPosition(var OutputXPosition:Natint;var OutputYPosition:Natint);
begin
 OutputXPosition:=Self.XPosition; OutputYPosition:=Self.YPosition;
end;
procedure console_screen.DrawConsole(Index:dword;FontIndex:byte);
var RelativeX,RelativeY,DrawX,DrawY:Natint;
    i,j,templen:Natuint;
begin
 RelativeX:=graph_heap_get_x_position(Index); RelativeY:=graph_heap_get_y_position(Index);
 DrawX:=1; DrawY:=1; i:=1;
 while(i<=Self.Count)do
  begin
   templen:=length(Self.Content[i-1].Content); j:=1;
   while(j<=templen)do
    begin
     graph_heap_draw_char(Index,graph_align_left,graph_align_top,
     RelativeX+(DrawX-1)*16,
     RelativeY+(DrawY-1)*20,FontIndex,Self.Content[i-1].Content[j],Self.Content[i-1].Color);
     if(DrawY>Self.MaxRow) then
      begin
       exit;
      end
     else if(DrawX>Self.MaxColumn) then
      begin
       DrawX:=1; inc(DrawY);
      end
     else
      begin
       inc(DrawX);
      end;
     inc(j);
    end;
   inc(i);
  end;
end;

end.

