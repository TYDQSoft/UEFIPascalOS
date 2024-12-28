unit graphics;

interface

type graph_item=packed record
                Red:byte;
                Green:byte;
                Blue:byte;
                Alpha:byte;
                end;
     Pgraph_item=^graph_item;
     graph_config=packed record
                  case Boolean of
                  True:
                  (BGRblue:byte; BGRgreen:byte; BGRred:byte; BGRReserved:byte;);
                  False:
                  (RGBred:byte; RGBgreen:byte; RGBblue:byte; RGBReserved:byte;);
                  end;
     Pgraph_config=^graph_config;
     graph_info=packed record
                index:natuint;
                posx,posy,width,height:dword;
                visible:boolean;
                end;
     Pgraph_info=^graph_info;
     graph_heap_record=packed record
                       segment_address:^graph_info;
                       segment_end_count:natuint;
                       segment_max_count:natuint;
                       segment_max_index:natuint;
                       content_address:^graph_item;
                       content_block_size:word;
                       screen_width:dword;
                       screen_height:dword;
                       screen_inter:^graph_item;
                       screen_output:^graph_config;
                       screen_type:byte;
                       end;
                       
const graph_zero:graph_item=(Red:$00;Green:$00;Blue:$00;Alpha:$00);
      graph_red:graph_item=(Red:$FF;Green:$00;Blue:$00;Alpha:$FF);
      graph_green:graph_item=(Red:$00;Green:$FF;Blue:$00;Alpha:$FF);
      graph_blue:graph_item=(Red:$00;Green:$00;Blue:$FF;Alpha:$FF);
      graph_yellow:graph_item=(Red:$FF;Green:$FF;Blue:$00;Alpha:$FF);
      graph_magenta:graph_item=(Red:$FF;Green:$00;Blue:$FF;Alpha:$FF);
      graph_cyan:graph_item=(Red:$00;Green:$FF;Blue:$FF;Alpha:$FF);
      graph_white:graph_item=(Red:$FF;Green:$FF;Blue:$FF;Alpha:$FF);
      graph_black:graph_item=(Red:$00;Green:$00;Blue:$00;Alpha:$FF);

procedure graph_heap_initialize(startaddress:natuint;totalsize:natuint;blocksize:word;width,height:dword;outputaddress:natuint;colortype:byte);
function graph_heap_getmem(x,y,width,height:dword;visible:boolean):Pgraph_item;
function graph_heap_getmemsize(ptr:Pgraph_item):natuint;
function graph_heap_allocmem(x,y,width,height:dword;visible:boolean):Pgraph_item;
procedure graph_heap_freemem(var ptr:Pgraph_item);
procedure graph_heap_reallocmem(var ptr:Pgraph_item;newx,newy,newwidth,newheight:dword;newvisible:boolean);
procedure graph_heap_change_position(ptr:Pgraph_item;newx,newy:dword);
procedure graph_heap_change_visiblity(ptr:Pgraph_item;visible:boolean);
procedure graph_heap_draw_pixel(ptr:Pgraph_item;drawx,drawy:dword;color:graph_item);
procedure graph_heap_draw_block(ptr:Pgraph_item;drawx,drawy,drawwidth,drawheight:dword;color:graph_item);
procedure graph_heap_draw_circle(ptr:Pgraph_item;drawx,drawy,drawradius:dword;color:graph_item);
procedure graph_heap_draw_ellipse(ptr:Pgraph_item;drawx,drawy,drawwidth,drawheight:dword;color:graph_item);
procedure graph_heap_draw_line(ptr:Pgraph_item;startx,starty,endx,endy:dword;color:graph_item);
procedure graph_heap_output_screen; 

var graph_heap:graph_heap_record;

implementation

function dword_to_graph_color(colornum:dword):graph_item;[public,alias:'dword_to_graph_color'];
var res:graph_item;
begin
 res.Red:=colornum shr 24;
 res.Green:=colornum shl 8 shr 24;
 res.Blue:=colornum shl 16 shr 24;
 res.Alpha:=colornum shl 24 shr 24;
end;
procedure graph_heap_initialize(startaddress:natuint;totalsize:natuint;blocksize:word;width,height:dword;outputaddress:natuint;colortype:byte);
[public,alias:'graph_heap_initialize'];
begin
 graph_heap.segment_address:=Pgraph_info(startaddress);
 graph_heap.segment_end_count:=0;
 graph_heap.segment_max_count:=optimize_integer_divide(totalsize-width*height*sizeof(graph_item),blocksize*sizeof(graph_item)+sizeof(graph_info));
 graph_heap.segment_max_index:=0;
 graph_heap.content_address:=Pgraph_item(startaddress+graph_heap.segment_max_count*sizeof(graph_item));
 graph_heap.content_block_size:=blocksize;
 graph_heap.screen_width:=width;
 graph_heap.screen_height:=height;
 graph_heap.screen_type:=colortype;
 graph_heap.screen_inter:=Pgraph_item(startaddress+totalsize-width*height*sizeof(graph_item));
 graph_heap.screen_output:=Pgraph_config(outputaddress);
end;
function graph_heap_find_first_empty_block(width,height:dword):Pgraph_item;[public,alias:'graph_heap_find_first_empty_block'];
var i,j:dword;
    size:natuint;
    res:Pgraph_item;
begin
 i:=1; res:=nil; size:=width*height;
 if(size=0) then exit(nil);
 while(i<=graph_heap.segment_end_count+1) and (i<=graph_heap.segment_max_count) do
  begin
   if((graph_heap.segment_address+i-1)^.index=0) or (i>graph_heap.segment_end_count) then
    begin
     j:=i;
     while(j<=i+optimize_integer_divide(size-1,graph_heap.content_block_size))
     and (j<=graph_heap.segment_max_count) do
      begin
       if((graph_heap.segment_address+j-1)^.index=0) and (j<=graph_heap.segment_end_count) then inc(j)
       else if(j>graph_heap.segment_end_count) then inc(j)
       else break;
      end;
     if(j>i+optimize_integer_divide(size-1,graph_heap.content_block_size)) then
      begin
       res:=graph_heap.content_address+(i-1)*graph_heap.content_block_size; break;
      end;
    end;
   inc(i,1);
  end;     
 graph_heap_find_first_empty_block:=res;
end;
function graph_heap_find_suitable_index:natuint;[public,alias:'graph_heap_find_suitable_index'];
var i,index:natuint;
begin
 index:=0;
 while True do
  begin
   i:=1;
   inc(index);
   while(i<=graph_heap.segment_end_count) do
    begin
     if((graph_heap.segment_address+i-1)^.index=index) then break;
     inc(i);
    end;
   if(i>graph_heap.segment_end_count) then break;
  end;
 graph_heap_find_suitable_index:=index;
end;
function graph_heap_memory_index_exist(index:natuint):boolean;[public,alias:'graph_heap_memory_index_exist'];
var i,j:natuint;
    res:boolean;
begin
 i:=graph_heap.segment_max_index; res:=false;
 if(i=0) then exit(res);
 while(i>0) do
  begin
   for j:=1 to graph_heap.segment_end_count do
    begin
     if((graph_heap.segment_address+j-1)^.index=i) then break;
    end;
   if(res) then break;
   dec(i,1);
  end;
 graph_heap_memory_index_exist:=res;
end;
function graph_heap_request_memory(x,y,width,height:dword;visible,meminit:boolean):Pgraph_item;[public,alias:'graph_heap_request_memory'];
var ptr:Pgraph_item;
    segptr:Pgraph_info;
    i,index,size:natuint;
begin
 ptr:=graph_heap_find_first_empty_block(width,height);
 size:=width*height;
 if(ptr=nil) then exit(ptr);
 index:=graph_heap_find_suitable_index;
 if(index>graph_heap.segment_max_index) then
  begin
   graph_heap.segment_max_index:=index;
  end;
 if(meminit) then
  begin
   i:=1;
   while(i<=optimize_integer_divide(size+graph_heap.content_block_size-1,graph_heap.content_block_size)*graph_heap.content_block_size) do
    begin
     (ptr+i-1)^:=graph_zero;
     inc(i,1);
    end;
  end;
 i:=1;
 segptr:=graph_heap.segment_address+optimize_integer_divide(ptr-graph_heap.content_address,graph_heap.content_block_size);
 (segptr+i-1)^.posx:=x; (segptr+i-1)^.posy:=y;
 (segptr+i-1)^.width:=width; (segptr+i-1)^.height:=height;
 (segptr+i-1)^.visible:=visible;
 while(i<=optimize_integer_divide(size-1,graph_heap.content_block_size)+1) do 
  begin
   (segptr+i-1)^.index:=index; inc(i,1);
  end;
 if(ptr>=Pgraph_item(graph_heap.content_address+graph_heap.segment_end_count*graph_heap.content_block_size)) then
  begin
   inc(graph_heap.segment_end_count,optimize_integer_divide(size-1,graph_heap.content_block_size)+1);
  end;
 graph_heap_request_memory:=ptr;
end;
procedure graph_heap_free_memory(var ptr:Pgraph_item);[public,alias:'graph_heap_free_memory'];
var mempos,memindex,memindex2,memcount,i:natuint;
begin
 mempos:=optimize_integer_divide(ptr-graph_heap.content_address,graph_heap.content_block_size)+1;
 memindex:=(graph_heap.segment_address+mempos-1)^.index;
 if(memindex=graph_heap.segment_max_index) then
  begin
   memindex2:=memindex-1;
   while(not graph_heap_memory_index_exist(memindex2)) and (memindex2>0) do dec(memindex2);
  end;
 while((graph_heap.segment_address+mempos-1)^.index=memindex) do dec(mempos);
 if((graph_heap.segment_address+mempos-1)^.index<>memindex) then inc(mempos);
 i:=1; memcount:=0;
 (graph_heap.segment_address+mempos-1)^.posx:=0;
 (graph_heap.segment_address+mempos-1)^.posy:=0;
 (graph_heap.segment_address+mempos-1)^.width:=0;
 (graph_heap.segment_address+mempos-1)^.height:=0;
 (graph_heap.segment_address+mempos-1)^.visible:=false;
 while((graph_heap.segment_address+mempos-1)^.index=memindex) do
  begin
   (graph_heap.segment_address+mempos-1)^.index:=0;
   inc(mempos); inc(memcount);
  end;
 if(mempos>graph_heap.segment_end_count) then dec(graph_heap.segment_end_count,memcount);
 ptr:=nil;
end;
function graph_heap_get_memory_size(ptr:Pgraph_item):natuint;[public,alias:'graph_heap_get_memory_size'];
var mempos,memindex,memcount,i:natuint;
begin
 mempos:=optimize_integer_divide(ptr-graph_heap.content_address,graph_heap.content_block_size)+1;
 memindex:=(graph_heap.segment_address+mempos-1)^.index;
 while((graph_heap.segment_address+mempos-1)^.index=memindex) do dec(mempos);
 if((graph_heap.segment_address+mempos-1)^.index<>memindex) then inc(mempos);
 i:=1; memcount:=0;
 while((graph_heap.segment_address+mempos+memcount-1)^.index=memindex) do inc(memcount);
 graph_heap_get_memory_size:=memcount*graph_heap.content_block_size div sizeof(graph_item);
end;
function graph_heap_get_memory_start(ptr:Pgraph_item):Pgraph_item;[public,alias:'graph_heap_get_memory_start'];
var mempos,memindex,memcount,i:natuint;
begin
 mempos:=optimize_integer_divide(ptr-graph_heap.content_address,graph_heap.content_block_size)+1;
 memindex:=(graph_heap.segment_address+mempos-1)^.index;
 while((graph_heap.segment_address+mempos-1)^.index=memindex) do dec(mempos);
 if((graph_heap.segment_address+mempos-1)^.index<>memindex) then inc(mempos);
 graph_heap_get_memory_start:=graph_heap.content_address+(mempos-1)*graph_heap.content_block_size;
end;
function graph_heap_memory_get_index(ptr:Pgraph_item):natuint;[public,alias:'graph_heap_memory_get_index'];
var startptr:Pgraph_item;
    startpos:natuint;
begin
 startptr:=graph_heap_get_memory_start(ptr);
 startpos:=startptr-graph_heap.content_address+1;
 graph_heap_memory_get_index:=(graph_heap.segment_address+startpos-1)^.index;
end;
function graph_heap_get_memory_start_with_index(index:natuint):Pgraph_item;[public,alias:'graph_heap_get_memory_start_with_index'];
var i:natuint;
begin
 i:=1;
 while(i<=graph_heap.segment_end_count)do
  begin
   if((graph_heap.segment_address+i-1)^.index=index) then break;
   inc(i,1);
  end;
 if(i>graph_heap.segment_end_count) then
 graph_heap_get_memory_start_with_index:=nil
 else
 graph_heap_get_memory_start_with_index:=graph_heap.content_address+i-1;
end;
function graph_heap_get_segment_start_with_index(index:natuint):Pgraph_info;[public,alias:'graph_heap_get_segment_start_with_index'];
var i:natuint;
begin
 i:=1;
 while(i<=graph_heap.segment_end_count)do
  begin
   if((graph_heap.segment_address+i-1)^.index=index) then break;
   inc(i,1);
  end;
 if(i>graph_heap.segment_end_count) then
 graph_heap_get_segment_start_with_index:=nil
 else
 graph_heap_get_segment_start_with_index:=graph_heap.segment_address+i-1;
end;
procedure graph_heap_move_memory(srcptr,destptr:Pgraph_item;Size:natuint);[public,alias:'graph_heap_move_memory'];
var ptr1,ptr2:Pgraph_item;
    ptr1size,ptr2size:natuint;
    copysize,i:natuint;
begin
 ptr1:=graph_heap_get_memory_start(srcptr);
 ptr2:=graph_heap_get_memory_start(destptr);
 ptr1size:=graph_heap_get_memory_size(srcptr);
 ptr2size:=graph_heap_get_memory_size(destptr);
 copysize:=size;
 if(srcptr+copysize-1>ptr1+ptr1size-1) then copysize:=ptr1+ptr1size-srcptr;
 if(destptr+copysize-1>ptr2+ptr2size-1) then copysize:=ptr2+ptr2size-destptr;
 ptr1:=srcptr; ptr2:=destptr;
 for i:=1 to copysize do (ptr2+i-1)^:=(ptr1+i-1)^;
end;
function graph_heap_getmem(x,y,width,height:dword;visible:boolean):Pgraph_item;[public,alias:'graph_heap_getmem'];
begin
 graph_heap_getmem:=graph_heap_request_memory(x,y,width,height,visible,false);
end;
function graph_heap_getmemsize(ptr:Pgraph_item):natuint;[public,alias:'graph_heap_getmemsize'];
begin
 graph_heap_getmemsize:=graph_heap_get_memory_size(ptr);
end;
function graph_heap_allocmem(x,y,width,height:dword;visible:boolean):Pgraph_item;[public,alias:'graph_heap_allocmem'];
begin
 graph_heap_allocmem:=graph_heap_request_memory(x,y,width,height,visible,true);
end;
procedure graph_heap_freemem(var ptr:Pgraph_item);[public,alias:'graph_heap_freemem'];
begin
 graph_heap_free_memory(ptr); ptr:=nil;
end;
procedure graph_heap_reallocmem(var ptr:Pgraph_item;newx,newy,newwidth,newheight:dword;newvisible:boolean);[public,alias:'graph_heap_reallocmem'];
var ptr1,ptr2:Pgraph_item;
    ptr1size,ptr2size:natuint;
begin
 ptr1:=graph_heap_get_memory_start(ptr);
 ptr2:=graph_heap_request_memory(newx,newy,newwidth,newheight,newvisible,true);
 ptr1size:=graph_heap_get_memory_size(ptr); ptr2size:=newwidth*newheight;
 if(ptr2=nil) then
  begin
   graph_heap_free_memory(ptr); ptr:=ptr2; exit;
  end;
 graph_heap_move_memory(ptr1,ptr2,ptr1size);
 graph_heap_free_memory(ptr1);
 ptr:=ptr2;
end;
procedure graph_heap_change_position(ptr:Pgraph_item;newx,newy:dword);[public,alias:'graph_heap_change_position'];
var index:natuint;
    startptr:Pgraph_item;
    startpos:natuint;
begin
 index:=graph_heap_memory_get_index(ptr);
 startptr:=graph_heap_get_memory_start(ptr);
 startpos:=startptr-graph_heap.content_address+1;
 (graph_heap.segment_address+startpos-1)^.posx:=newx;
 (graph_heap.segment_address+startpos-1)^.posy:=newy;
end;
procedure graph_heap_change_visiblity(ptr:Pgraph_item;visible:boolean);[public,alias:'graph_heap_change_visiblity'];
var index:natuint;
    startptr:Pgraph_item;
    startpos:natuint;
begin
 index:=graph_heap_memory_get_index(ptr);
 startptr:=graph_heap_get_memory_start(ptr);
 startpos:=startptr-graph_heap.content_address+1;
 (graph_heap.segment_address+startpos-1)^.visible:=visible;
end;
procedure graph_heap_draw_pixel(ptr:Pgraph_item;drawx,drawy:dword;color:graph_item);[public,alias:'graph_heap_draw_pixel'];
var index:natuint;
    startptr:Pgraph_item;
    startpos:natuint;
    iwidth,iheight:dword;
begin
 index:=graph_heap_memory_get_index(ptr);
 startptr:=graph_heap_get_memory_start(ptr);
 startpos:=startptr-graph_heap.content_address+1;
 iwidth:=(graph_heap.segment_address+startpos-1)^.width;
 iheight:=(graph_heap.segment_address+startpos-1)^.height;
 if(drawx>iwidth) or (drawy>iheight) or (drawx=0) or (drawy=0) then exit;
 (ptr+(drawy-1)*iwidth+drawx-1)^:=color;
end;
procedure graph_heap_draw_block(ptr:Pgraph_item;drawx,drawy,drawwidth,drawheight:dword;color:graph_item);[public,alias:'graph_heap_draw_block'];
var index:natuint;
    startptr:Pgraph_item;
    startpos:natuint;
    iwidth,iheight:dword;
    dwidth,dheight:dword;
    i,j:dword;
begin
 index:=graph_heap_memory_get_index(ptr);
 startptr:=graph_heap_get_memory_start(ptr);
 startpos:=startptr-graph_heap.content_address+1;
 iwidth:=(graph_heap.segment_address+startpos-1)^.width;
 iheight:=(graph_heap.segment_address+startpos-1)^.height;
 if(drawx>iwidth) or (drawy>iheight) or (drawx=0) or (drawy=0) then exit;
 dwidth:=drawwidth;
 if(drawx+dwidth-1>iwidth) then dwidth:=iwidth-drawx+1;
 dheight:=drawheight;
 if(drawy+dheight-1>iheight) then dheight:=iheight-drawy+1;
 for i:=1 to dwidth do
  for j:=1 to dheight do
   begin
    (startptr+(drawy+j-2)*iwidth+drawx+i-2)^:=color;
   end;
end;
procedure graph_heap_draw_circle(ptr:Pgraph_item;drawx,drawy,drawradius:dword;color:graph_item);[public,alias:'graph_heap_draw_circle'];
var index:natuint;
    startptr:Pgraph_item;
    startpos:natuint;
    iwidth,iheight:dword;
    sx,sy,ex,ey,i,j:dword;
begin
 index:=graph_heap_memory_get_index(ptr);
 startptr:=graph_heap_get_memory_start(ptr);
 startpos:=startptr-graph_heap.content_address+1;
 iwidth:=(graph_heap.segment_address+startpos-1)^.width;
 iheight:=(graph_heap.segment_address+startpos-1)^.height;
 if(drawx-drawradius+1>0) then sx:=drawx-drawradius+1 else sx:=1;
 if(drawy-drawradius+1>0) then sy:=drawy-drawradius+1 else sy:=1;
 if(drawx+drawradius-1<iwidth) then ex:=drawx+drawradius+1 else ex:=iwidth;
 if(drawy+drawradius-1<iheight) then ey:=drawy+drawradius+1 else ey:=iheight;
 for i:=sx to ex do
  for j:=sy to ey do
   begin
    if(sqr(i-drawx)+sqr(j-drawy)<=sqr(drawradius)) then (startptr+(j-1)*iwidth+i-1)^:=color;
   end;
end;
procedure graph_heap_draw_ellipse(ptr:Pgraph_item;drawx,drawy,drawwidth,drawheight:dword;color:graph_item);[public,alias:'graph_heap_draw_ellipse'];
var index:natuint;
    startptr:Pgraph_item;
    startpos:natuint;
    iwidth,iheight:dword;
    dwidth,dheight:dword;
    i,j:dword;
    a,b:dword;
begin
 index:=graph_heap_memory_get_index(ptr);
 startptr:=graph_heap_get_memory_start(ptr);
 startpos:=startptr-graph_heap.content_address+1;
 iwidth:=(graph_heap.segment_address+startpos-1)^.width;
 iheight:=(graph_heap.segment_address+startpos-1)^.height;
 if(drawx>iwidth) or (drawy>iheight) or (drawx=0) or (drawy=0) then exit;
 dwidth:=drawwidth;
 if(drawx+dwidth-1>iwidth) then dwidth:=iwidth-drawx+1;
 dheight:=drawheight;
 if(drawy+dheight-1>iheight) then dheight:=iheight-drawy+1;
 a:=drawwidth shr 1; b:=drawheight shr 1;
 for i:=1 to dwidth do
  for j:=1 to dheight do
   begin
    if(sqr(i-a)/(a*a)+sqr(i-b)/(b*b)<=1) then
    (startptr+(drawy+j-2)*iwidth+drawx+i-2)^:=color;
   end;
end;
procedure graph_heap_draw_line(ptr:Pgraph_item;startx,starty,endx,endy:dword;color:graph_item);[public,alias:'graph_heap_draw_line'];
var index:natuint;
    startptr:Pgraph_item;
    startpos:natuint;
    iwidth,iheight:dword;
    mx,my,mk,mb:extended;
    isvertical:boolean;
    i,j,dx,dy:dword;
    color1,color2:graph_item;
begin
 index:=graph_heap_memory_get_index(ptr);
 startptr:=graph_heap_get_memory_start(ptr);
 startpos:=startptr-graph_heap.content_address+1;
 iwidth:=(graph_heap.segment_address+startpos-1)^.width;
 iheight:=(graph_heap.segment_address+startpos-1)^.height;
 if(startx=0) or (starty=0) or (endx=0) or (endy=0) then exit;
 if(startx>iwidth) or (starty>iheight) or (endx>iwidth) or (endy>iheight) then exit;
 mx:=startx; my:=starty;
 if(endx-startx=0) then isvertical:=true else isvertical:=false;
 if(not isvertical) then
  begin
   mk:=(endy-starty)/(endx-startx); mb:=starty-(endy-starty)/(endx-startx)*startx;
   if(startx<endx) then
    begin
     for i:=startx to endx do
      begin
       mx:=mx+1; my:=my+mk;
       dx:=ceil(mx);
       if(my-floor(my)>ceil(my)-my) then dy:=ceil(my) else dy:=floor(my);
       color1:=color; color2:=color;
       if(my-floor(my)=0) then color1.Alpha:=0 else color1.Alpha:=ceil(255*(my-floor(my)));
       if(ceil(my)-my=0) then color2.Alpha:=0 else color2.Alpha:=ceil(255*(ceil(my)-my));
       if(dy>1) then (startptr+(dy-2)*iwidth+dx-1)^:=color1;
       (startptr+(dy-1)*iwidth+dx-1)^:=color2;
      end;
    end
   else if(startx>endx) then
    begin
     for i:=endx to startx do
      begin
       mx:=mx+1; my:=my+mk;
       dx:=ceil(mx);
       if(my-floor(my)>ceil(my)-my) then dy:=ceil(my) else dy:=floor(my);
       color1:=color; color2:=color;
       if(my-floor(my)=0) then color1.Alpha:=0 else color1.Alpha:=ceil(255*(my-floor(my)));
       if(ceil(my)-my=0) then color2.Alpha:=0 else color2.Alpha:=ceil(255*(ceil(my)-my));
       if(dy>1) then (startptr+(dy-2)*iwidth+dx-1)^:=color1;
       (startptr+(dy-1)*iwidth+dx-1)^:=color2;
      end;
    end;
  end
 else
  begin
   if(endy>starty) then
   for i:=starty to endy do (startptr+(i-1)*iwidth+startx-1)^:=color
   else
   for i:=endy to starty do (startptr+(i-1)*iwidth+startx-1)^:=color;
  end;
end;
procedure graph_heap_output_screen;[public,alias:'graph_heap_output_screen'];
var i,j,k:natuint;
    startptr:Pgraph_item;
    startseg:Pgraph_info;
    oldcolor,newcolor:graph_item;
    dx,dy:dword;
    dpos,dindex:natuint;
begin
 for i:=1 to graph_heap.screen_width*graph_heap.screen_height do
  begin
   (graph_heap.screen_inter+i-1)^:=graph_black;
  end;
 for i:=1 to graph_heap.segment_max_index do
  begin
   startptr:=graph_heap_get_memory_start_with_index(i);
   startseg:=graph_heap_get_segment_start_with_index(i);
   if(startseg^.visible=false) then continue;
   dindex:=0;
   for j:=1 to startseg^.width do
    for k:=1 to startseg^.height do
     begin
      dx:=startseg^.posx+j-1; dy:=startseg^.posy+k-1;
      dpos:=(dy-1)*graph_heap.screen_width+dx;
      inc(dindex);
      oldcolor:=(startptr+dindex-1)^;
      newcolor.alpha:=255-(255-oldcolor.alpha)*(255-(graph_heap.screen_inter+dpos-1)^.alpha) div 255;
      newcolor.red:=optimize_integer_divide(oldcolor.red*oldcolor.alpha+
      (graph_heap.screen_inter+dpos-1)^.Red*(graph_heap.screen_inter+dpos-1)^.alpha
      *(255-oldcolor.alpha) div 255,newcolor.alpha);
      newcolor.green:=optimize_integer_divide(oldcolor.green*oldcolor.alpha+
      (graph_heap.screen_inter+dpos-1)^.Green*(graph_heap.screen_inter+dpos-1)^.alpha
      *(255-oldcolor.alpha) div 255,newcolor.alpha);
      newcolor.blue:=optimize_integer_divide(oldcolor.blue*oldcolor.alpha+
      (graph_heap.screen_inter+dpos-1)^.Blue*(graph_heap.screen_inter+dpos-1)^.alpha
      *(255-oldcolor.alpha) div 255,newcolor.alpha);
      (graph_heap.screen_inter+dpos-1)^:=newcolor;
     end;
  end;
 for i:=1 to graph_heap.screen_width*graph_heap.screen_height do
  begin
   if(graph_heap.screen_type=0) then
    begin
     (graph_heap.screen_output+i-1)^.BGRblue:=(graph_heap.screen_inter+dpos-1)^.Blue;
     (graph_heap.screen_output+i-1)^.BGRgreen:=(graph_heap.screen_inter+dpos-1)^.Green;
     (graph_heap.screen_output+i-1)^.BGRred:=(graph_heap.screen_inter+dpos-1)^.Red;
     (graph_heap.screen_output+i-1)^.BGRreserved:=0;
    end
   else if(graph_heap.screen_type=1) then
    begin
     (graph_heap.screen_output+i-1)^.RGBblue:=(graph_heap.screen_inter+dpos-1)^.Blue;
     (graph_heap.screen_output+i-1)^.RGBgreen:=(graph_heap.screen_inter+dpos-1)^.Green;
     (graph_heap.screen_output+i-1)^.RGBred:=(graph_heap.screen_inter+dpos-1)^.Red;
     (graph_heap.screen_output+i-1)^.RGBreserved:=0;
    end;
  end;
end;

end.

