unit graphics;

interface
    
type graphics_item=packed record
                   Red:byte;
                   Green:byte;
                   Blue:byte;
                   Alpha:byte;
                   end;
     graphics_color=packed record
                    Red:byte;
                    Green:byte;
                    Blue:byte;
                    Alpha:byte;
                    end;
     Pgraphics_item=^graphics_item;
     graphics_segment=packed record
                      start:natuint;
                      left,top,width,height:dword;
                      visible:boolean;
                      end;
     graphics_output_blt_pixel=packed record
                               Blue:byte;
                               Green:byte;
                               Red:byte;
                               Reserved:byte;
                               end;
     Pgraphics_output_blt_pixel=^graphics_output_blt_pixel;
     graphics_heap=packed record
                   content:^graphics_item;
                   contentused:natuint;
                   contentmax:natuint;
                   segment:^graphics_segment;
                   segmentcount:natuint;
                   segmentcountmax:natuint;
                   screenwidth:dword;
                   screenheight:dword;
                   initscreen:^graphics_item;
                   framebufferbase:^graphics_output_blt_pixel;
                   screentype:byte;
                   end;
     Pgraphics_heap=^graphics_heap;

const graphics_zero:graphics_item=(Red:0;Green:0;Blue:0;Alpha:0);
      graphics_red:graphics_color=(Red:$FF;Green:0;Blue:0;Alpha:$FF);
      graphics_green:graphics_color=(Red:0;Green:$FF;Blue:0;Alpha:$FF);
      graphics_blue:graphics_color=(Red:0;Green:0;Blue:$FF;Alpha:$FF);
      graphics_white:graphics_color=(Red:$FF;Green:$FF;Blue:$FF;Alpha:$FF);
      graphics_black:graphics_color=(Red:0;Green:0;Blue:0;Alpha:$FF);

function dword_to_graphics_color(number:dword):graphics_color;
procedure graphics_heap_initialize(MemoryStart:Pointer;ContentCount:natuint;SegmentCount:natuint;screenwidth:natuint;screenheight:natuint;framebufferbase:Pgraphics_output_blt_pixel;screentype:byte);
function graphics_getmem(startx,starty,width,height:dword):Pgraphics_item;
function graphics_allocmem(startx,starty,width,height:dword):Pgraphics_item;
function graphics_getmemsize(ptr:Pgraphics_item):natuint;
function graphics_freemem(var ptr:Pgraphics_item):natuint;
procedure graphics_move(Source:Pgraphics_item;var Dest:Pgraphics_item;Count:natuint);
procedure graphics_changeposition(ptr:Pgraphics_item;newstartx,newstarty:dword);
procedure graphics_changevisible(ptr:Pgraphics_item;visible:boolean);
procedure graphics_reallocmem(var ptr:Pgraphics_item;newstartx,newstarty,newwidth,newheight:dword);
procedure graphics_draw_pixel(ptr:Pgraphics_item;relativex,relativey:dword;color:graphics_color);
procedure graphics_draw_block(ptr:Pgraphics_item;relativex,relativey,blockwidth,blockheight:dword;color:graphics_color);
procedure graphics_draw_circle(ptr:Pgraphics_item;relativex,relativey:dword;radius:dword;color:graphics_color);
procedure graphics_output_to_screen;

var graphheap:graphics_heap;

implementation

function dword_to_graphics_color(number:dword):graphics_color;[public,alias:'dword_to_graphics_color'];
var res:graphics_color;
begin
 res.Red:=number div 16777216;
 res.Green:=number div 65536 mod 256;
 res.Blue:=number div 256 mod 256;
 res.Alpha:=number mod 256;
 dword_to_graphics_color:=res;
end;
procedure graphics_heap_initialize(MemoryStart:Pointer;ContentCount:natuint;SegmentCount:natuint;screenwidth:natuint;screenheight:natuint;framebufferbase:Pgraphics_output_blt_pixel;screentype:byte);[public,alias:'graphics_heap_initialize'];
begin
 graphheap.content:=MemoryStart;
 graphheap.contentused:=0;
 graphheap.contentmax:=ContentCount;
 graphheap.segment:=MemoryStart+ContentCount*sizeof(graphics_item);
 graphheap.segmentcount:=0;
 graphheap.segmentcountmax:=SegmentCount;
 graphheap.screenwidth:=screenwidth;
 graphheap.screenheight:=screenheight;
 graphheap.initscreen:=MemoryStart+ContentCount*sizeof(graphics_item)+sizeof(graphics_segment)*SegmentCount;
 graphheap.framebufferbase:=framebufferbase;
 graphheap.screentype:=screentype;
end;
procedure graphics_heap_delete_item(ptr:Pgraphics_item);[public,alias:'graphics_heap_delete_item'];
var index,size,i,j:natuint;
    procptr1,procptr2:Pgraphics_item;
begin
 index:=1; size:=0;
 while(index<=graphheap.segmentcount) do
  begin
   size:=(graphheap.segment+index-1)^.width*(graphheap.segment+index-1)^.height*
   sizeof(graphics_item);
   if(Natuint(ptr)>=(graphheap.segment+index-1)^.start) and (Natuint(ptr)<=(graphheap.segment+index-1)^.start+size-1) then break;
   inc(index);
  end;
 if(index>graphheap.segmentcount) then exit;
 for i:=index+1 to graphheap.segmentcount do
  begin
   for j:=1 to (graphheap.segment+i-1)^.width*(graphheap.segment+i-1)^.height do
    begin
     procptr1:=Pgraphics_item((graphheap.segment+i-1)^.start+(j-1)*sizeof(graphics_item));
     procptr2:=Pgraphics_item((graphheap.segment+i-1)^.start+(j-1)*sizeof(graphics_item)-size);
     procptr2^:=procptr1^;
    end;
   (graphheap.segment+i-2)^.start:=(graphheap.segment+i-1)^.start-size;
  end;
 dec(graphheap.contentused,size shr 2);
 dec(graphheap.segmentcount);
end;
function graphics_getmem(startx,starty,width,height:dword):Pgraphics_item;[public,alias:'graphics_getmem'];
var i:natuint;
    procptr:Pgraphics_item;
begin
 if(graphheap.contentused+width*height>graphheap.contentmax) then exit(nil);
 if(graphheap.segmentcount>=graphheap.segmentcountmax) then exit(nil);
 inc(graphheap.segmentcount);
 if(graphheap.segmentcount=1) then
  begin
   (graphheap.segment+graphheap.segmentcount-1)^.start:=Natuint(graphheap.content);
  end
 else if(graphheap.segmentcount>1) then
  begin
   (graphheap.segment+graphheap.segmentcount-1)^.start:=Natuint(graphheap.content+graphheap.contentused);
  end;
 (graphheap.segment+graphheap.segmentcount-1)^.left:=startx;
 (graphheap.segment+graphheap.segmentcount-1)^.top:=starty;
 (graphheap.segment+graphheap.segmentcount-1)^.width:=width;
 (graphheap.segment+graphheap.segmentcount-1)^.height:=height;
 (graphheap.segment+graphheap.segmentcount-1)^.visible:=true;
 for i:=1 to width*height do
  begin
   procptr:=Pointer((graphheap.segment+graphheap.segmentcount-1)^.start+(i-1)*4); procptr^:=graphics_zero;
  end;
 inc(graphheap.contentused,width*height);
 graphics_getmem:=Pointer((graphheap.segment+graphheap.segmentcount-1)^.start);
end;
function graphics_allocmem(startx,starty,width,height:dword):Pgraphics_item;[public,alias:'graphics_allocmem'];
var i:natuint;
    procptr:Pgraphics_item;
begin
 if(graphheap.contentused+width*height>graphheap.contentmax) then exit(nil);
 if(graphheap.segmentcount>=graphheap.segmentcountmax) then exit(nil);
 inc(graphheap.segmentcount);
 if(graphheap.segmentcount=1) then
  begin
   (graphheap.segment+graphheap.segmentcount-1)^.start:=Natuint(graphheap.content);
  end
 else if(graphheap.segmentcount>1) then
  begin
   (graphheap.segment+graphheap.segmentcount-1)^.start:=Natuint(graphheap.content+graphheap.contentused);
  end;
 (graphheap.segment+graphheap.segmentcount-1)^.left:=startx;
 (graphheap.segment+graphheap.segmentcount-1)^.top:=starty;
 (graphheap.segment+graphheap.segmentcount-1)^.width:=width;
 (graphheap.segment+graphheap.segmentcount-1)^.height:=height;
 (graphheap.segment+graphheap.segmentcount-1)^.visible:=true;
 for i:=1 to width*height do
  begin
   procptr:=Pointer((graphheap.segment+graphheap.segmentcount-1)^.start+(i-1)*4); procptr^:=graphics_zero;
  end;
 inc(graphheap.contentused,width*height);
 graphics_allocmem:=Pointer((graphheap.segment+graphheap.segmentcount-1)^.start);
end;
function graphics_getmemsize(ptr:Pgraphics_item):natuint;[public,alias:'graphics_getmemsize'];
var index,size:natuint;
begin
 index:=1;
 while(index<=graphheap.segmentcount) do
  begin
   size:=(graphheap.segment+index-1)^.width*(graphheap.segment+index-1)^.height*
   sizeof(graphics_item);
   if(Natuint(ptr)>=(graphheap.segment+index-1)^.start) and
   (Natuint(ptr)>=(graphheap.segment+index-1)^.start+size-1) then break;
   inc(index);
  end;
 if(index>graphheap.segmentcount) then graphics_getmemsize:=0
 else graphics_getmemsize:=size div sizeof(graphics_item);
end;
function graphics_freemem(var ptr:Pgraphics_item):natuint;[public,alias:'graphics_freemem'];
begin
 if(ptr<>nil) then
  begin
   graphics_heap_delete_item(ptr); ptr:=nil;
  end;
end;
procedure graphics_move(Source:Pgraphics_item;var Dest:Pgraphics_item;Count:natuint);[public,alias:'graphics_move'];
var i:natuint;
begin
 for i:=1 to Count do (Dest+i-1)^:=(Source+i-1)^;
end;
procedure graphics_changeposition(ptr:Pgraphics_item;newstartx,newstarty:dword);[public,alias:'graphics_changeposition'];
var index,size:natuint;
begin
 index:=1;
 while(index<=graphheap.segmentcount) do
  begin
   size:=(graphheap.segment+index-1)^.width*(graphheap.segment+index-1)^.height*
   sizeof(graphics_item);
   if(Natuint(ptr)>=(graphheap.segment+index-1)^.start) and
   (Natuint(ptr)>=(graphheap.segment+index-1)^.start+size-1) then break;
   inc(index);
  end;
 if(index>graphheap.segmentcount) then exit
 else
  begin
   (graphheap.segment+index-1)^.left:=newstartx;
   (graphheap.segment+index-1)^.top:=newstarty;
  end;
end;
procedure graphics_changevisible(ptr:Pgraphics_item;visible:boolean);[public,alias:'graphics_changevisible'];
var index,size:natuint;
begin
 index:=1;
 while(index<=graphheap.segmentcount) do
  begin
   size:=(graphheap.segment+index-1)^.width*(graphheap.segment+index-1)^.height*
   sizeof(graphics_item);
   if(Natuint(ptr)>=(graphheap.segment+index-1)^.start) and
   (Natuint(ptr)>=(graphheap.segment+index-1)^.start+size-1) then break;
   inc(index);
  end;
 if(index>graphheap.segmentcount) then exit else (graphheap.segment+index-1)^.visible:=visible;
end;
procedure graphics_reallocmem(var ptr:Pgraphics_item;newstartx,newstarty,newwidth,newheight:dword);[public,alias:'graphics_reallocmem'];
var oldptr,newptr:Pgraphics_item;
    oldsize,newsize,offset,i,j,index,size:natuint;
begin
 newptr:=graphics_getmem(newstartx,newstarty,newwidth,newheight);
 if(newptr=nil) then exit;
 if(ptr=nil) then
  begin
   ptr:=newptr; exit;
  end;
 index:=1;
 while(index<=graphheap.segmentcount) do
  begin
   size:=(graphheap.segment+index-1)^.width*(graphheap.segment+index-1)^.height*
   sizeof(graphics_item);
   if(Natuint(ptr)>=(graphheap.segment+index-1)^.start) and
   (Natuint(ptr)>=(graphheap.segment+index-1)^.start+size-1) then break;
   inc(index);
  end;
 if(index>graphheap.segmentcount-1) then
  begin
   ptr:=newptr; exit;
  end;
 oldptr:=Pgraphics_item((graphheap.segment+index-1)^.start);
 offset:=ptr-oldptr;
 oldsize:=graphics_getmemsize(oldptr);
 newsize:=newwidth*newheight;
 if(oldsize>newsize) then graphics_move(oldptr,newptr,newsize) else graphics_move(oldptr,newptr,oldsize);
 graphics_heap_delete_item(oldptr);
 ptr:=newptr+offset-oldsize;
end;
procedure graphics_draw_pixel(ptr:Pgraphics_item;relativex,relativey:dword;color:graphics_color);[public,alias:'graphics_draw_pixel'];
var index,size:natuint;
    myptr:Pgraphics_item;
begin
 index:=1;
 while(index<=graphheap.segmentcount) do
  begin
   size:=(graphheap.segment+index-1)^.width*(graphheap.segment+index-1)^.height*sizeof(graphics_item);
   if(Natuint(ptr)>=(graphheap.segment+index-1)^.start) and (Natuint(ptr)<=(graphheap.segment+index-1)^.start+size-1) then break;
   inc(index);
  end;
 if(index>graphheap.segmentcount) then exit;
 if(relativex=0) and (relativex>(graphheap.segment+index-1)^.width) then exit;
 if(relativey=0) and (relativey>(graphheap.segment+index-1)^.height) then exit;
 myptr:=Pointer((graphheap.segment+index-1)^.start+((relativey-1)*(graphheap.segment+index-1)^.width+relativex-1)*sizeof(graphics_item));
 myptr^.Red:=color.Red; myptr^.Blue:=color.Blue; myptr^.Green:=color.Green; myptr^.Alpha:=color.Alpha;
end;
procedure graphics_draw_block(ptr:Pgraphics_item;relativex,relativey,blockwidth,blockheight:dword;color:graphics_color);[public,alias:'graphics_draw_block'];
var index,size,trimwidth,trimheight,i,j:natuint;
    myptr:Pgraphics_item;
begin
 index:=1;
 while(index<=graphheap.segmentcount) do
  begin
   size:=(graphheap.segment+index-1)^.width*(graphheap.segment+index-1)^.height*sizeof(graphics_item);
   if(Natuint(ptr)>=(graphheap.segment+index-1)^.start) and (Natuint(ptr)<=(graphheap.segment+index-1)^.start+size-1) then break;
   inc(index);
  end;
 if(index>graphheap.segmentcount) then exit;
 if(relativex=0) and (relativex>(graphheap.segment+index-1)^.width) then exit;
 if(relativey=0) and (relativey>(graphheap.segment+index-1)^.height) then exit;
 if(relativex+blockwidth-1>(graphheap.segment+index-1)^.width) then
 trimwidth:=(graphheap.segment+index-1)^.width-relativex+1 else trimwidth:=blockwidth;
 if(relativey+blockheight-1>(graphheap.segment+index-1)^.height) then
 trimheight:=(graphheap.segment+index-1)^.height-relativey+1 else trimheight:=blockheight;
 for i:=relativex to relativex+trimwidth-1 do
  for j:=relativey to relativey+trimheight-1 do
   begin
    myptr:=Pointer((graphheap.segment+index-1)^.start+((j-1)*(graphheap.segment+index-1)^.width+i-1)*sizeof(graphics_item));
    myptr^.Red:=color.Red; myptr^.Blue:=color.Blue;
    myptr^.Green:=color.Green; myptr^.Alpha:=color.Alpha;
   end;
end;
procedure graphics_draw_circle(ptr:Pgraphics_item;relativex,relativey:dword;radius:dword;color:graphics_color);[public,alias:'graphics_draw_circle'];
var index,size:natuint;
    myptr:Pgraphics_item;
    startx,starty,endx,endy,i,j:natuint;
begin
 index:=1;
 while(index<=graphheap.segmentcount) do
  begin
   size:=(graphheap.segment+index-1)^.width*(graphheap.segment+index-1)^.height*
   sizeof(graphics_item);
   if(Natuint(ptr)>=(graphheap.segment+index-1)^.start) and (Natuint(ptr)<=(graphheap.segment+index-1)^.start+size-1) then break;
   inc(index);
  end;
 if(index>graphheap.segmentcount) then exit;
 if(relativex-radius<0) then startx:=0 else startx:=relativex-radius+1;
 if(relativex+radius>(graphheap.segment+index-1)^.width+1)
 then endx:=(graphheap.segment+index-1)^.width else endx:=relativex+radius-1;
 if(relativey-radius<0) then starty:=0 else starty:=relativey-radius+1;
 if(relativey+radius>(graphheap.segment+index-1)^.height+1)
 then endy:=(graphheap.segment+index-1)^.height else endy:=relativey+radius-1;
 for i:=startx to endx do
  for j:=starty to endy do
   begin
    if(sqr(relativex-startx+1)+sqr(relativey-starty+1)<=sqr(radius+1)) then
     begin
      myptr:=Pointer((graphheap.segment+index-1)^.start+((j-1)*(graphheap.segment+index-1)^.width+(i-1)*sizeof(graphics_item)));
      myptr^.Red:=color.Red; myptr^.Blue:=color.Blue;
      myptr^.Green:=color.Green; myptr^.alpha:=color.alpha;
     end;
   end;
end;
procedure graphics_output_to_screen;[public,alias:'graphics_heap_output_to_screen'];
var i,j,k,m:natuint;
    dx,dy,dpos:natuint;
    index:natuint;
    oldalpha,oldred,oldgreen,oldblue:byte;
    newalpha,newred,newgreen,newblue:byte;
begin
 for i:=1 to graphheap.screenwidth*graphheap.screenheight do
  begin
   (graphheap.initscreen+i-1)^.Red:=0;
   (graphheap.initscreen+i-1)^.Green:=0;
   (graphheap.initscreen+i-1)^.Blue:=0;
   (graphheap.initscreen+i-1)^.Alpha:=$FF;
  end;
 for i:=1 to graphheap.segmentcount do
  begin
   m:=(graphheap.segment+i-1)^.start;
   if((graphheap.segment+i-1)^.visible=false) then continue;
   for j:=1 to (graphheap.segment+i-1)^.height do
    for k:=1 to (graphheap.segment+i-1)^.width do
     begin
      dx:=(graphheap.segment+i-1)^.left+k-1;
      dy:=(graphheap.segment+i-1)^.top+j-1;
      dpos:=(dy-1)*graphheap.screenwidth+dx;
      index:=(m-Natuint(graphheap.content)) shr 2+1;
      oldalpha:=(graphheap.content+index-1)^.Alpha;
      oldred:=(graphheap.content+index-1)^.Red;
      oldgreen:=(graphheap.content+index-1)^.Green;
      oldblue:=(graphheap.content+index-1)^.Blue;
      newalpha:=255-(255-oldalpha)*(255-(graphheap.initscreen+dpos-1)^.alpha) div 255;
      newred:=optimize_integer_divide(oldred*oldalpha+(graphheap.initscreen+dpos-1)^.Red*(graphheap.initscreen+dpos-1)^.alpha*(255-oldalpha) div 255,newalpha);
      newgreen:=optimize_integer_divide(oldgreen*oldalpha+(graphheap.initscreen+dpos-1)^.Green*(graphheap.initscreen+dpos-1)^.alpha*(255-oldalpha) div 255,newalpha);
      newblue:=optimize_integer_divide(oldblue*oldalpha+(graphheap.initscreen+dpos-1)^.Blue*(graphheap.initscreen+dpos-1)^.alpha*(255-oldalpha) div 255,newalpha);
      (graphheap.initscreen+dpos-1)^.Alpha:=newalpha;
      (graphheap.initscreen+dpos-1)^.Red:=newred;
      (graphheap.initscreen+dpos-1)^.Green:=newgreen;
      (graphheap.initscreen+dpos-1)^.Blue:=newblue;
      inc(m,sizeof(graphics_item));
     end;
  end;
 for i:=1 to graphheap.screenwidth*graphheap.screenheight do
  begin
   if(graphheap.screentype=0) then
    begin
     (graphheap.framebufferbase+i-1)^.Green:=(graphheap.initscreen+i-1)^.Green;
     (graphheap.framebufferbase+i-1)^.Blue:=(graphheap.initscreen+i-1)^.Blue;
     (graphheap.framebufferbase+i-1)^.Red:=(graphheap.initscreen+i-1)^.Red;
     (graphheap.framebufferbase+i-1)^.Reserved:=$00;
    end
   else if(graphheap.screentype=1) then
    begin
     (graphheap.framebufferbase+i-1)^.Green:=(graphheap.initscreen+i-1)^.Green;
     (graphheap.framebufferbase+i-1)^.Blue:=(graphheap.initscreen+i-1)^.Red;
     (graphheap.framebufferbase+i-1)^.Red:=(graphheap.initscreen+i-1)^.Blue;
     (graphheap.framebufferbase+i-1)^.Reserved:=$00;
    end;
  end;
end;

end.
