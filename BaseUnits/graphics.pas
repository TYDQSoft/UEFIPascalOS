unit graphics;

interface


const graphics_heap_max=1 shl 28;
      graphics_section_max=1 shl 16;
    
type graphics_item=packed record
                   Red:byte;
                   Green:byte;
                   Blue:byte;
                   Alpha:byte;
                   end;
     Pgraphics_item=^graphics_item;
     graphics_section=packed record
                      pointer_start,pointer_end:natuint;
                      draw_x,draw_y,draw_width,draw_height:dword;
                      visible:boolean;
                      end;
     graphics_screen=array[1..33554432] of graphics_item;
     graphics_output_blt_pixel=packed record
                               Blue:byte;
                               Green:byte;
                               Red:byte;
                               Reserved:byte;
                               end;
     graphics_output_screen=array[1..33554432] of graphics_output_blt_pixel;
     graphics_heap=packed record
                   graphics_content:array[1..graphics_heap_max] of graphics_item;
                   graphics_sections:array[1..graphics_section_max] of graphics_section;
                   graphics_count,graphics_rest:natuint;
                   end;

procedure graphics_heap_initialize;     
function graphics_heap_getmem(startx,starty,width,height:natuint):Pgraphics_item;
function graphics_heap_getmemsize(ptr:Pgraphics_item):natuint;
function graphics_heap_allocmem(startx,starty,width,height:natuint):Pgraphics_item;
procedure graphics_heap_freemem(var ptr:Pgraphics_item);
procedure graphics_heap_changeposition(var ptr:Pgraphics_item;startx,starty:natuint);
procedure graphics_heap_changevisible(var ptr:Pgraphics_item;visible:boolean);
procedure graphics_heap_reallocmem(var ptr:Pgraphics_item;startx,starty,width,height:natuint);
procedure graphics_heap_move(dest,source:Pgraphics_item;size:natuint);
procedure graphics_draw_pixel(ptr:Pgraphics_item;relativex,relativey:dword;Red,Green,Blue,Alpha:byte);
procedure graphics_draw_block(ptr:Pgraphics_item;relativex,relativey,blockwidth,blockheight:dword;Red,Blue,Green,Alpha:byte);
procedure graphics_heap_output_to_screen(framebufferbase:qword;screenwidth,screenheight:dword);

var graphicsheap:graphics_heap;
    graphicsscreen:graphics_screen;
    graphicsoutputscreen:graphics_output_screen;

implementation

procedure graphics_heap_initialize;[public,alias:'graphics_heap_initialize'];
begin
 graphicsheap.graphics_count:=0; graphicsheap.graphics_rest:=graphics_heap_max;
end;
procedure graphics_heap_delete_item(ptr:Pgraphics_item);[public,alias:'graphics_heap_delete_item'];
var i,j,k,size:natuint;
    zero:graphics_item;
begin
 i:=1;
 zero.Red:=0; zero.Green:=0; zero.Blue:=0; zero.Alpha:=0;
 while(i<=graphicsheap.graphics_count) do
  begin
   if(Natuint(ptr)>=graphicsheap.graphics_sections[i].pointer_start) and (Natuint(ptr)<=graphicsheap.graphics_sections[i].pointer_end) then break;
   inc(i,1);
  end;
 if(i>graphicsheap.graphics_count) then exit;
 size:=graphicsheap.graphics_sections[i].pointer_end-graphicsheap.graphics_sections[i].pointer_start+1;
 for j:=i+1 to graphicsheap.graphics_count do
  begin
   k:=graphicsheap.graphics_sections[j].pointer_start;
   while(k<=graphicsheap.graphics_sections[j].pointer_end) do
    begin
     graphicsheap.graphics_content[(k-size-Qword(@graphicsheap.graphics_content)+1) shr 2]:=
     graphicsheap.graphics_content[(k-Qword(@graphicsheap.graphics_content)+1) shr 2];
     graphicsheap.graphics_content[(k-Qword(@graphicsheap.graphics_content)+1) shr 2]:=zero;
     inc(k,1 shl 2);
    end;
   graphicsheap.graphics_sections[j-1].pointer_start:=graphicsheap.graphics_sections[j].pointer_start-size;
   graphicsheap.graphics_sections[j-1].pointer_end:=graphicsheap.graphics_sections[j].pointer_end-size;
   graphicsheap.graphics_sections[j-1].draw_x:=graphicsheap.graphics_sections[j].draw_x;
   graphicsheap.graphics_sections[j-1].draw_y:=graphicsheap.graphics_sections[j].draw_y;
   graphicsheap.graphics_sections[j-1].draw_width:=graphicsheap.graphics_sections[j].draw_width;
   graphicsheap.graphics_sections[j-1].draw_height:=graphicsheap.graphics_sections[j].draw_height;
  end;
 dec(graphicsheap.graphics_count);
 inc(graphicsheap.graphics_rest,size shr 2);
end;
function graphics_heap_getmem(startx,starty,width,height:natuint):Pgraphics_item;[public,alias:'graphics_heap_getmem'];
var i,size:natuint;
    pstart,pend:natuint;
begin
 size:=width*height;
 if(graphicsheap.graphics_rest<size shl 2) then exit(nil);
 if(graphicsheap.graphics_count>=graphics_section_max) then exit(nil);
 if(size=0) then exit(nil);
 inc(graphicsheap.graphics_count);
 if(graphicsheap.graphics_count=1) then graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start:=Natuint(@graphicsheap.graphics_content)
 else graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start:=graphicsheap.graphics_sections[graphicsheap.graphics_count-1].pointer_end+1;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_end:=graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start+size shl 2-1;
 pstart:=(graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start-Natuint(@graphicsheap.graphics_content)+1) shr 2;
 pend:=(graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_end-Natuint(@graphicsheap.graphics_content)+1) shr 2;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].draw_x:=startx;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].draw_y:=starty;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].draw_width:=width;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].draw_height:=height;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].visible:=true;
 for i:=1 to size do
  begin
   graphicsheap.graphics_content[pstart+i-1].Red:=0;
   graphicsheap.graphics_content[pstart+i-1].Green:=0;
   graphicsheap.graphics_content[pstart+i-1].Blue:=0;
   graphicsheap.graphics_content[pstart+i-1].Alpha:=0;
  end;
 dec(graphicsheap.graphics_rest,size);
 graphics_heap_getmem:=Pointer(graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start);
end;
function graphics_heap_getmemsize(ptr:Pgraphics_item):natuint;[public,alias:'graphics_heap_getmemsize'];
var i,size:natuint;
begin
 i:=1;
 while(i<=graphicsheap.graphics_count) do
  begin
   if(Natuint(ptr)>=graphicsheap.graphics_sections[i].pointer_start) and (Natuint(ptr)<=graphicsheap.graphics_sections[i].pointer_end) then break;
   inc(i,1);
  end;
 if(i>graphicsheap.graphics_count) then graphics_heap_getmemsize:=0 
 else graphics_heap_getmemsize:=(graphicsheap.graphics_sections[i].pointer_end-graphicsheap.graphics_sections[i].pointer_start+1) shr 2;
end;
function graphics_heap_allocmem(startx,starty,width,height:natuint):Pgraphics_item;[public,alias:'graphics_heap_allocmem'];
var i,size:natuint;
    pstart,pend:natuint;
begin
 size:=width*height;
 if(graphicsheap.graphics_rest<size shl 2) then exit(nil);
 if(graphicsheap.graphics_count>=graphics_section_max) then exit(nil);
 if(size=0) then exit(nil);
 inc(graphicsheap.graphics_count);
 if(graphicsheap.graphics_count=1) then graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start:=Natuint(@graphicsheap.graphics_content)
 else graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start:=graphicsheap.graphics_sections[graphicsheap.graphics_count-1].pointer_end+1;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_end:=graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start+size shl 2-1;
 pstart:=(graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start-Natuint(@graphicsheap.graphics_content)+1) shr 2;
 pend:=(graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_end-Natuint(@graphicsheap.graphics_content)+1) shr 2;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].draw_x:=startx;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].draw_y:=starty;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].draw_width:=width;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].draw_height:=height;
 graphicsheap.graphics_sections[graphicsheap.graphics_count].visible:=true;
 for i:=1 to size do
  begin
   graphicsheap.graphics_content[pstart+i-1].Red:=0;
   graphicsheap.graphics_content[pstart+i-1].Green:=0;
   graphicsheap.graphics_content[pstart+i-1].Blue:=0;
   graphicsheap.graphics_content[pstart+i-1].Alpha:=0;
  end;
 dec(graphicsheap.graphics_rest,size);
 graphics_heap_allocmem:=Pointer(graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start);
end;
procedure graphics_heap_freemem(var ptr:Pgraphics_item);[public,alias:'graphics_heap_freemem'];
begin
 if(ptr<>nil) then
  begin
   graphics_heap_delete_item(ptr); ptr:=nil;
  end;
end;
procedure graphics_heap_changeposition(var ptr:Pgraphics_item;startx,starty:natuint);[public,alias:'graphics_heap_changeposition'];
var i,size:natuint;
begin
 i:=1;
 while(i<=graphicsheap.graphics_count) do
  begin
   if(Natuint(ptr)>=graphicsheap.graphics_sections[i].pointer_start) and (Natuint(ptr)<=graphicsheap.graphics_sections[i].pointer_end) then break;
   inc(i,1);
  end;
 if(i>graphicsheap.graphics_count) then exit
 else
  begin
   graphicsheap.graphics_sections[i].draw_x:=startx; graphicsheap.graphics_sections[i].draw_y:=starty;
  end;
end;
procedure graphics_heap_changevisible(var ptr:Pgraphics_item;visible:boolean);[public,alias:'graphics_heap_changevisible'];
var i,size:natuint;
begin
 i:=1;
 while(i<=graphicsheap.graphics_count) do
  begin
   if(Natuint(ptr)>=graphicsheap.graphics_sections[i].pointer_start) and (Natuint(ptr)<=graphicsheap.graphics_sections[i].pointer_end) then break;
   inc(i,1);
  end;
 if(i>graphicsheap.graphics_count) then exit
 else
  begin
   graphicsheap.graphics_sections[i].visible:=visible;
  end;
end;
procedure graphics_heap_reallocmem(var ptr:Pgraphics_item;startx,starty,width,height:natuint);[public,alias:'graphics_heap_reallocmem'];
var oldptr,newptr:Pgraphics_item;
    i,index,offset:natuint;
    orgsize,newsize:natuint;
begin
 index:=1;
 while(index<=graphicsheap.graphics_count) do
  begin
   if(Natuint(ptr)>=graphicsheap.graphics_sections[index].pointer_start) and (Natuint(ptr)<=graphicsheap.graphics_sections[index].pointer_end) then break;
   inc(index,1);
  end;
 if(index>graphicsheap.graphics_count) then 
  begin
   ptr:=nil; exit;
  end;
 oldptr:=Pointer(graphicsheap.graphics_sections[index].pointer_start);
 offset:=Natuint(Ptr)-Natuint(oldptr);
 newptr:=graphics_heap_allocmem(startx,starty,width,height);
 if(newptr=nil) then exit;
 orgsize:=graphics_heap_getmemsize(ptr); newsize:=width*height;
 if(orgsize>newsize) then
  begin
   for i:=1 to newsize do (newptr+i-1)^:=(oldptr+i-1)^;
  end
 else if(orgsize<=newsize) then
  begin
   for i:=1 to orgsize do (newptr+i-1)^:=(oldptr+i-1)^;
  end;
 freemem(oldptr); 
 ptr:=newptr+offset-orgsize;
end;
procedure graphics_heap_move(dest,source:Pgraphics_item;size:natuint);[public,alias:'graphics_heap_move'];
var i:natuint;
begin
 for i:=1 to size do
  begin
   (dest+i-1)^:=(source+i-1)^;
  end;
end;
procedure graphics_draw_pixel(ptr:Pgraphics_item;relativex,relativey:dword;Red,Green,Blue,Alpha:byte);[public,alias:'graphics_draw_pixel'];
var index:natuint;
    width,height,pos:dword;
    pstart:dword;
begin
 index:=1;
 while(index<=graphicsheap.graphics_count) do
  begin
   if(Natuint(ptr)>=graphicsheap.graphics_sections[index].pointer_start) and (Natuint(ptr)<=graphicsheap.graphics_sections[index].pointer_end) then break;
   inc(index,1);
  end;
 if(index>graphicsheap.graphics_count) then exit;
 width:=graphicsheap.graphics_sections[index].draw_width;
 height:=graphicsheap.graphics_sections[index].draw_height; 
 if(relativex>width) or (relativex=0) then exit;
 if(relativey>height) or (relativey=0) then exit;
 width:=graphicsheap.graphics_sections[index].draw_width; height:=graphicsheap.graphics_sections[index].draw_height;
 pos:=(relativey-1)*width+relativex;
 pstart:=(graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start-Natuint(@graphicsheap.graphics_content)+1) shr 2;
 graphicsheap.graphics_content[pstart+pos-1].Red:=Red;
 graphicsheap.graphics_content[pstart+pos-1].Green:=Green;
 graphicsheap.graphics_content[pstart+pos-1].Blue:=Blue;
 graphicsheap.graphics_content[pstart+pos-1].Alpha:=Alpha;
end;
procedure graphics_draw_block(ptr:Pgraphics_item;relativex,relativey,blockwidth,blockheight:dword;Red,Blue,Green,Alpha:byte);[public,alias:'graphics_draw_block'];
var index,i,j:natuint;
    width,height,pos:dword;
    pstart:dword;
    correctwidth,correctheight:dword;
begin
 index:=1;
 while(index<=graphicsheap.graphics_count) do
  begin
   if(Natuint(ptr)>=graphicsheap.graphics_sections[index].pointer_start) and (Natuint(ptr)<=graphicsheap.graphics_sections[index].pointer_end) then break;
   inc(index,1);
  end;
 if(index>graphicsheap.graphics_count) then exit;
 width:=graphicsheap.graphics_sections[index].draw_width;
 height:=graphicsheap.graphics_sections[index].draw_height; 
 if(relativex>width) or (relativex=0) then exit;
 if(relativey>height) or (relativey=0) then exit;
 if(relativex+blockwidth>width) then correctwidth:=width-relativex+1 else correctwidth:=blockwidth;
 if(relativey+blockheight>height) then correctheight:=height-relativey+1 else correctheight:=blockheight;
 pstart:=(graphicsheap.graphics_sections[graphicsheap.graphics_count].pointer_start-Natuint(@graphicsheap.graphics_content)+1) shr 2;
 for i:=1 to correctheight do
  for j:=1 to correctwidth do
   begin
    pos:=(relativey+i-2)*width+relativex+j-1;
    graphicsheap.graphics_content[pstart+pos-1].Red:=Red;
    graphicsheap.graphics_content[pstart+pos-1].Green:=Green;
    graphicsheap.graphics_content[pstart+pos-1].Blue:=Blue;
    graphicsheap.graphics_content[pstart+pos-1].Alpha:=Alpha;
   end;
end;
procedure graphics_heap_output_to_screen(framebufferbase:qword;screenwidth,screenheight:dword);[public,alias:'graphics_heap_output_to_screen'];
var i,j,k,m:natuint;
    dx,dy,dpos:natuint;
    index:natuint;
    fbufferbase:^graphics_output_blt_pixel;
    oldalpha,oldred,oldgreen,oldblue:byte;
    newalpha,newred,newgreen,newblue:byte;
begin
 fbufferbase:=Pointer(framebufferbase);
 for i:=1 to screenwidth*screenheight do
  begin
   graphicsscreen[i].Red:=0;
   graphicsscreen[i].Green:=0;
   graphicsscreen[i].Blue:=0;
   graphicsscreen[i].Alpha:=255;
  end;
 for i:=1 to graphicsheap.graphics_count do
  begin
   m:=graphicsheap.graphics_sections[i].pointer_start;
   if(graphicsheap.graphics_sections[i].visible=false) then continue;
   for j:=1 to graphicsheap.graphics_sections[i].draw_height do
    for k:=1 to graphicsheap.graphics_sections[i].draw_width do
     begin
      dx:=graphicsheap.graphics_sections[i].draw_x+k-1;
      dy:=graphicsheap.graphics_sections[i].draw_y+j-1;
      dpos:=(dy-1)*screenwidth+dx;
      index:=(m-Qword(@graphicsheap.graphics_content)) shr 2+1;
      oldalpha:=graphicsheap.graphics_content[index].Alpha;
      oldred:=graphicsheap.graphics_content[index].Red;
      oldgreen:=graphicsheap.graphics_content[index].Green;
      oldblue:=graphicsheap.graphics_content[index].Blue;
      newalpha:=255-(255-oldalpha)*(255-graphicsscreen[dpos].alpha) div 255;
      newred:=optimize_integer_divide((oldred*oldalpha+graphicsscreen[dpos].Red*graphicsscreen[dpos].alpha*(255-oldalpha) div 255),newalpha);
      newgreen:=optimize_integer_divide((oldgreen*oldalpha+graphicsscreen[dpos].Green*graphicsscreen[dpos].alpha*(255-oldalpha) div 255),newalpha);
      newblue:=optimize_integer_divide((oldblue*oldalpha+graphicsscreen[dpos].Blue*graphicsscreen[dpos].alpha*(255-oldalpha) div 255),newalpha);
      graphicsscreen[dpos].Alpha:=newalpha;
      graphicsscreen[dpos].Red:=newred;
      graphicsscreen[dpos].Green:=newgreen;
      graphicsscreen[dpos].Blue:=newblue;
      inc(m,4);
     end;
  end;
 for i:=1 to screenwidth*screenheight do
  begin
   graphicsoutputscreen[i].Blue:=graphicsscreen[i].Blue;
   graphicsoutputscreen[i].Green:=graphicsscreen[i].Green;
   graphicsoutputscreen[i].Red:=graphicsscreen[i].Red;
   graphicsoutputscreen[i].Reserved:=$00;
   (fbufferbase+i-1)^:=graphicsoutputscreen[i];
  end;
end;

end.
