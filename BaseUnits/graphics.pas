unit graphics;

interface

type graph_point=packed record
                 xpos,ypos:dword;
                 end;
     Pgraph_point=^graph_point;
     graph_char=packed record
                content:WideChar;
                charwidth,charheight:dword;
                end;
     Pgraph_char=^graph_char;
     graph_string=packed record
                  content:PWideChar;
                  charwidth,charheight:dword;
                  end;
     Pgraph_string=^graph_string;
     graph_unisometric_string=packed record
                              content:^graph_string;
                              count:natuint;
                              end;
     Pgraph_unisometric_string=^graph_unisometric_string;
     graph_item=bitpacked record
                haveprev:boolean;
                allocated:0..63;
                havenext:boolean;
                end;
     Pgraph_item=^graph_item;
     graph_header=packed record
                  visible:boolean;
                  Index:Natuint;
                  xpos,ypos:Integer;
                  width,height:Dword;
                  end;
     Pgraph_header=^graph_header;
     graph_color=packed record
                Red:byte;
                Green:byte;
                Blue:byte;
                Alpha:byte;
                end;
     graph_colour=graph_color;
     Pgraph_color=^graph_color;
     Pgraph_colour=^graph_colour;
     graph_output_color=packed record
                        case Byte of
                        0:(BGRBlue:byte;BGRGreen:byte;BGRRed:byte;BGRReserved:byte;);
                        1:(RGBRed:byte;RGBGreen:byte;RGBBlue:byte;RGBReserved:byte;);
                        end;
     Pgraph_output_color=^graph_output_color;
     graph_screen_attribute=packed record
                            virtiogpu:boolean;
                            colortype:0..127;
                            end;
     graph_heap=packed record
                mem_start:Pointer;
                mem_end:Pointer;
                mem_block_power:byte;
                item_max_pos:natuint;
                item_max_index:natuint;
                screen_attribute:graph_screen_attribute;
                screen_width,screen_height:dword;
                screen_init_address:^graph_color;
                screen_output_address:^graph_output_color;
                end;

const graph_pi:extended=3.1415926;
      graph_color_type_bgr:byte=0;
      graph_color_type_rgb:byte=1;
      graph_color_none:graph_color=(Red:$00;Green:$00;Blue:$00;Alpha:$00);
      graph_color_black:graph_color=(Red:$00;Green:$00;Blue:$00;Alpha:$FF);
      graph_color_red:graph_color=(Red:$FF;Green:$00;Blue:$00;Alpha:$FF);
      graph_color_green:graph_color=(Red:$00;Green:$FF;Blue:$00;Alpha:$FF);
      graph_color_blue:graph_color=(Red:$00;Green:$00;Blue:$FF;Alpha:$FF);
      graph_color_yellow:graph_color=(Red:$FF;Green:$FF;Blue:$00;Alpha:$FF);
      graph_color_skyblue:graph_color=(Red:$00;Green:$FF;Blue:$FF;Alpha:$FF);
      graph_color_pink:graph_color=(Red:$FF;Green:$00;Blue:$FF;Alpha:$FF);
      graph_color_white:graph_color=(Red:$FF;Green:$FF;Blue:$FF;Alpha:$FF);
      graph_color_ivory_black:graph_color=(Red:$29;Green:$24;Blue:$21;Alpha:$FF);
      graph_color_grey:graph_color=(Red:$C0;Green:$C0;Blue:$C0;Alpha:$FF);
      graph_color_cold_grey:graph_color=(Red:$80;Green:$8A;Blue:$87;Alpha:$FF);
      graph_color_slabstone_grey:graph_color=(Red:$70;Green:$80;Blue:$69;Alpha:$FF);
      graph_color_warm_grey:graph_color=(Red:$80;Green:$80;Blue:$69;Alpha:$FF);
      graph_color_antique_white:graph_color=(Red:$FA;Green:$EB;Blue:$D7;Alpha:$FF);
      graph_color_mist_white:graph_color=(Red:$F5;Green:$F5;Blue:$F5;Alpha:$FF);
      graph_color_almond_white:graph_color=(Red:$FF;Green:$EB;Blue:$CD;Alpha:$FF);
      graph_color_cornslik:graph_color=(Red:$FF;Green:$F8;Blue:$DC;Alpha:$FF);

var gheap:graph_heap;

function graph_color_generate(Red:byte;Green:byte;Blue:byte;Alpha:byte):graph_color;
function graph_color_mixed(color1,color2:graph_color):graph_color;
function graph_color_get_inverse(color:graph_color):graph_color;
function graph_color_get_lightness(color:graph_color):byte;
function graph_color_get_inverse(color:graph_color):graph_color;
procedure graph_heap_initialize(startaddr:Pointer;size:Natuint;blockpower:byte;width,height:dword;
isvirtio:boolean;colortype:byte;outputaddr:Pointer);
function graph_heap_getmem(width,height:dword;xpos,ypos:Integer;visible:boolean):Pointer;
function graph_heap_getmemsize(ptr:Pointer):natuint;
function graph_heap_allocmem(width,height:dword;xpos,ypos:Integer;visible:boolean):Pointer;
procedure graph_heap_edit_header(ptr:Pointer;newwidth,newheight:Dword;newxpos,newypos:Integer;visible:boolean);
procedure graph_heap_freemem(var ptr:Pointer);
procedure graph_heap_reallocmem(var ptr:Pointer;newwidth,newheight:dword;newxpos,newypos:Integer;
visible:boolean);
procedure graph_heap_draw_point(ptr:Pointer;xpos,ypos:Integer;color:graph_color);
procedure graph_heap_draw_block(ptr:Pointer;xpos,ypos:Integer;width,height:Dword;color:graph_color);
procedure graph_heap_draw_circle(ptr:Pointer;xpos,ypos:Integer;radius:dword;color:graph_color);
procedure graph_heap_draw_fanshape(ptr:Pointer;xpos,ypos:Integer;radius:dword;
anglestart,angleend:extended;color:graph_color);
procedure graph_heap_draw_eclipse(ptr:Pointer;xpos,ypos:Integer;width,height:Dword;Color:graph_color);
procedure graph_heap_clear_canva(ptr:Pointer);
procedure graph_heap_output_screen;
procedure graph_heap_output_screen_using_virtio_gpu;

implementation

function graph_color_generate(Red:byte;Green:byte;Blue:byte;Alpha:byte):graph_color;
var res:graph_color;
begin
 res.Red:=Red; res.Green:=Green; res.Blue:=blue; res.Alpha:=Alpha;
 graph_color_generate:=res;
end;
function graph_color_mixed(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 if(color2.Alpha=$FF) then
  begin
   res.Alpha:=$FF; res.Red:=color2.Red; res.Blue:=color2.Blue; res.Green:=color2.Green;
   exit(res);
  end
 else if(color2.Alpha=0) then
  begin
   res.Alpha:=$FF; res.Red:=color1.Red; res.Blue:=color1.Blue; res.Green:=color1.Green;
   exit(res);
  end;
 res.Alpha:=color1.Alpha;
 res.Red:=(color1.Red*res.Alpha+color2.Red*(255-res.Alpha) shr 8) and $FF;
 res.Blue:=(color1.Blue*res.Alpha+color2.Blue*(255-res.Alpha) shr 8) and $FF;
 res.Green:=(color1.Green*res.Alpha+color2.Green*(255-res.Alpha) shr 8) and $FF;
 res.Alpha:=(color1.Alpha*res.Alpha+color2.Alpha*(255-res.Alpha) shr 8) and $FF;
 graph_color_mixed:=res;
end;
function graph_color_mixed_with_weight(color1:graph_color;color2:graph_color;weight:extended):graph_color;
var res:graph_color;
begin
 res.Red:=round(color1.Red-(color2.Red-$FF)*(1-weight)) and $FF;
 res.Green:=round(color1.Green-(color2.Green-$FF)*(1-weight)) and $FF;
 res.Blue:=round(color1.Blue-(color2.Blue-$FF)*(1-weight)) and $FF;
 res.Alpha:=round(color1.Alpha-(color2.Alpha-$FF)*(1-weight)) and $FF;
 graph_color_mixed_with_weight:=res;
end;
function graph_color_get_lightness(color:graph_color):byte;
var res:byte;
begin
 res:=0;
 if(color.Red>res) then res:=color.Red;
 if(color.Green>res) then res:=color.Green;
 if(color.Blue>res) then res:=color.Blue;
 if(color.Alpha>res) then res:=color.Alpha;
 graph_color_get_lightness:=res;
end;
function graph_color_get_inverse(color:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=$FF-color.Red; res.Green:=$FF-color.Green; res.Blue:=$FF-color.Blue; res.Alpha:=color.Alpha;
 graph_color_get_inverse:=res;
end;
function graph_generate_graph_char(character:WideChar;charw,charh:dword):graph_char;
var res:graph_char;
begin
 res.content:=character; res.charwidth:=charw; res.charheight:=charh;
 graph_generate_graph_char:=res;
end; 
function graph_generate_graph_string(str:PWideChar;charw,charh:dword):graph_string;
var res:graph_char;
begin
 res.content:=Wstrcreate(str); res.charwidth:=charw; res.charheight:=charh;
 graph_generate_graph_char:=res;
end; 
procedure graph_heap_initialize(startaddr:Pointer;size:Natuint;blockpower:byte;width,height:dword;
isvirtio:boolean;colortype:byte;outputaddr:Pointer);
var tempsize:natuint;
begin
 gheap.mem_start:=startaddr;
 gheap.screen_width:=width;
 gheap.screen_height:=height;
 gheap.screen_attribute.virtiogpu:=isvirtio;
 gheap.screen_attribute.colortype:=colortype;
 tempsize:=size-width*height*sizeof(graph_color);
 gheap.screen_output_address:=outputaddr;
 gheap.screen_init_address:=startaddr+tempsize;
 gheap.mem_end:=startaddr+tempsize;
 gheap.mem_block_power:=blockpower;
 gheap.item_max_pos:=0;
 gheap.item_max_index:=0;
end;
function graph_heap_get_address_from_index(index:Natuint):Pointer;
begin
 graph_heap_get_address_from_index:=Pointer(gheap.mem_start+(index-1) shl gheap.mem_block_power);
end;
function graph_heap_get_index_from_address(address:Pointer):Natuint;
begin
 graph_heap_get_index_from_address:=(address-gheap.mem_start) shr gheap.mem_block_power+1;
end;
function graph_heap_get_graph_item_from_index(index:Natuint):graph_item;
begin
 graph_heap_get_graph_item_from_index:=Pgraph_item(gheap.mem_end-index)^;
end;
function graph_heap_get_graph_item_from_address(address:Pointer):graph_item;
var blockpos:Natuint;
begin
 blockpos:=Natuint(address-gheap.mem_start) shr gheap.mem_block_power+1;
 graph_heap_get_graph_item_from_address:=Pgraph_item(gheap.mem_end-blockpos)^;
end;
procedure graph_heap_write_graph_item_from_index(item:graph_item;index:Natuint);
begin
 Pgraph_item(gheap.mem_end-index)^:=item;
end;
procedure graph_heap_write_graph_item_from_address(item:graph_item;Address:Pointer);
var blockpos:Natuint;
begin
 blockpos:=Natuint(address-gheap.mem_start) shr gheap.mem_block_power+1;
 Pgraph_item(gheap.mem_end-blockpos)^:=item;
end;
function graph_heap_test_mem_from_index(index:Natuint):boolean;
var item:graph_item;
begin
 if(index>gheap.item_max_pos) then graph_heap_test_mem_from_index:=false
 else
  begin
   item:=Pgraph_item(gheap.mem_end-index)^;
   graph_heap_test_mem_from_index:=item.allocated>0;
  end;
end;
function graph_heap_test_mem_from_address(address:Pointer):boolean;
var item:graph_item;
    blockpos:natuint;
begin
 blockpos:=Natuint(address-gheap.mem_start) shr gheap.mem_block_power+1;
 if(blockpos>gheap.item_max_pos) then graph_heap_test_mem_from_address:=false
 else
  begin
   item:=Pgraph_item(gheap.mem_end-blockpos)^;
   graph_heap_test_mem_from_address:=item.allocated>0;
  end;
end;
function graph_heap_get_total_size:Natuint;
begin
 graph_heap_get_total_size:=Natuint(gheap.mem_end-gheap.mem_start);
end;
function graph_heap_get_memory_start(address:Pointer):Pointer;
var blockpos:natuint;
    item:graph_item;
begin
 if(address=nil) then exit(nil);
 blockpos:=(address-gheap.mem_start) shr gheap.mem_block_power+1;
 item:=graph_heap_get_graph_item_from_index(blockpos);
 while(item.haveprev) and (blockpos>0) do
  begin
   dec(blockpos);
   item:=graph_heap_get_graph_item_from_index(blockpos);
  end;
 if(blockpos=0) then blockpos:=1;
 graph_heap_get_memory_start:=graph_heap_get_address_from_index(blockpos);
end;
function graph_heap_get_memory_size(address:Pointer):Natuint;
var blockpos,startpos,endpos:natuint;
    item,itemstart,itemend:graph_item;
begin
 if(address=nil) then exit(0);
 blockpos:=(address-gheap.mem_start) shr gheap.mem_block_power+1;
 item:=graph_heap_get_graph_item_from_index(blockpos);
 itemstart:=item; startpos:=blockpos;
 while(itemstart.haveprev)do
  begin
   dec(startpos);
   itemstart:=graph_heap_get_graph_item_from_index(startpos);
  end;
 itemend:=item; endpos:=blockpos;
 while(itemend.havenext)do
  begin
   inc(endpos);
   itemend:=graph_heap_get_graph_item_from_index(endpos);
  end;
 graph_heap_get_memory_size:=(endpos-startpos+1) shl gheap.mem_block_power;
end;
procedure graph_heap_clear_block_from_index(index:Natuint);
var blockstartaddr:Pointer;
    i:Natuint;
begin
 blockstartaddr:=gheap.mem_start+(index-1) shl gheap.mem_block_power;
 for i:=1 to 1 shl (gheap.mem_block_power-3) do
  begin
   Pqword(blockstartaddr+(i-1) shl 3)^:=0;
  end;
end;
procedure graph_heap_clear_block_from_address(address:Pointer);
var blockstartaddr:Pointer;
    blockpos,i:Natuint;
begin
 blockpos:=graph_heap_get_index_from_address(address);
 blockstartaddr:=gheap.mem_start+(blockpos-1) shl gheap.mem_block_power;
 for i:=1 to 1 shl (gheap.mem_block_power-3) do Pqword(blockstartaddr+(i-1) shl 3)^:=0;
end;
function graph_heap_request_memory(screenwidth,screenheight:dword;meminit:boolean):Pointer;
var i,j:natuint;
    item:graph_item;
    tempsize,needblock:natuint;
begin
 if(screenwidth=0) or (screenheight=0) then exit(nil);
 i:=1; tempsize:=screenwidth*screenheight*sizeof(graph_color)+sizeof(graph_header);
 needblock:=(tempsize+1 shl gheap.mem_block_power-1) shr gheap.mem_block_power;
 while(i<=gheap.item_max_pos)do
  begin
   item:=graph_heap_get_graph_item_from_index(i);
   if(item.allocated=0) then
    begin
     j:=i;
     while(item.allocated=0)do
      begin
       if(j-i+1>=needblock) then break;
       inc(j);
       item:=graph_heap_get_graph_item_from_index(j);
      end;
     if(j-i+1>=needblock) then break else i:=j;
    end;
   inc(i);
  end;
 if(i<=gheap.item_max_pos) or
 ((gheap.item_max_pos+needblock) shl gheap.mem_block_power<=graph_heap_get_total_size) then
  begin
   graph_heap_request_memory:=graph_heap_get_address_from_index(i);
   if(i>gheap.item_max_pos) then inc(gheap.item_max_pos,needblock);
   j:=i;
   while(j<=i+needblock-1)do
    begin
     item:=graph_heap_get_graph_item_from_index(j);
     if(j<i+needblock-1) then item.havenext:=true else item.havenext:=false;
     if(j>i) then item.haveprev:=true else item.haveprev:=false;
     item.allocated:=1;
     graph_heap_write_graph_item_from_index(item,j);
     if(meminit) then graph_heap_clear_block_from_index(j);
     inc(j);
    end;
  end
 else graph_heap_request_memory:=nil;
end;
procedure graph_heap_free_memory(var ptr:Pointer;forcenil:boolean);
var startaddr:Pointer;
    i,j,totalblock:natuint;
    item:graph_item;
begin
 if(ptr=nil) or (ptr<gheap.mem_start) or (ptr>gheap.mem_end) then exit;
 startaddr:=graph_heap_get_memory_start(ptr);
 i:=graph_heap_get_index_from_address(startaddr);
 totalblock:=graph_heap_get_memory_size(ptr) shr gheap.mem_block_power;
 j:=i;
 while(j<=i+totalblock-1)do
  begin
   item.haveprev:=false; item.havenext:=false; item.allocated:=0;
   graph_heap_write_graph_item_from_index(item,j);
   inc(j);
  end;
 if(i+totalblock-1=gheap.item_max_pos) then
  begin
   gheap.item_max_pos:=i-1;
   item:=graph_heap_get_graph_item_from_index(gheap.item_max_pos);
   while(gheap.item_max_pos>0) and (item.allocated=0) do
    begin
     dec(gheap.item_max_pos);
     item:=graph_heap_get_graph_item_from_index(gheap.item_max_pos);
    end;
  end;
 if(forcenil) then ptr:=nil;
end;
procedure graph_heap_move_memory(const source:Pointer;var dest:Pointer);
var startpos,endpos:Pointer;
    startsize,endsize,i:natuint;
begin
 if(source=nil) or (source<gheap.mem_start) or (source>gheap.mem_end)
 or (dest=nil) or (dest<gheap.mem_start) or (dest>gheap.mem_end) then exit;
 startpos:=graph_heap_get_memory_start(source);
 startsize:=graph_heap_get_memory_size(source);
 endpos:=graph_heap_get_memory_start(dest);
 endsize:=graph_heap_get_memory_size(dest);
 if(startsize>=endsize) then
 for i:=1 to endsize shr 3 do Pqword(endpos+(i-1) shl 3)^:=Pqword(startpos+(i-1) shl 3)^
 else
 for i:=1 to startsize shr 3 do Pqword(endpos+(i-1) shl 3)^:=Pqword(startpos+(i-1) shl 3)^;
end;
function graph_heap_search_for_memindex(memindex:natuint):boolean;
var i:Natuint;
    item:graph_item;
    head:graph_header;
begin
 i:=1;
 while(i<=gheap.item_max_pos)do
  begin
   item:=graph_heap_get_graph_item_from_index(i);
   if(item.haveprev=false) and (item.allocated>0) then
    begin
     head:=Pgraph_header(graph_heap_get_address_from_index(i))^;
     if(head.Index=memindex) then break;
    end;
   inc(i);
  end;
 graph_heap_search_for_memindex:=i<=gheap.item_max_pos;
end;
function graph_heap_search_for_memindex_address(memindex:natuint):Pointer;
var i:Natuint;
    item:graph_item;
    head:graph_header;
begin
 i:=1;
 while(i<=gheap.item_max_pos)do
  begin
   item:=graph_heap_get_graph_item_from_index(i);
   if(item.haveprev=false) and (item.allocated>0) then
    begin
     head:=Pgraph_header(graph_heap_get_address_from_index(i))^;
     if(head.Index=memindex) then break;
    end;
   inc(i);
  end;
 if(i>gheap.item_max_pos) then
 graph_heap_search_for_memindex_address:=nil
 else
 graph_heap_search_for_memindex_address:=graph_heap_get_address_from_index(i)+sizeof(graph_header);
end;
function graph_heap_search_for_visibility(memindex:natuint):boolean;
var i:Natuint;
    item:graph_item;
    head:graph_header;
begin
 i:=1;
 while(i<=gheap.item_max_pos)do
  begin
   item:=graph_heap_get_graph_item_from_index(i);
   if(item.haveprev=false) and (item.allocated>0) then
    begin
     head:=Pgraph_header(graph_heap_get_address_from_index(i))^;
     if(head.Index=memindex) then break;
    end;
   inc(i);
  end;
 if(i>gheap.item_max_pos) then
 graph_heap_search_for_visibility:=false
 else
 graph_heap_search_for_visibility:=head.visible;
end;
function graph_heap_getmem(width,height:dword;xpos,ypos:Integer;visible:boolean):Pointer;
var resptr:Pointer;
    i:natuint;
begin
 resptr:=graph_heap_request_memory(width,height,false);
 Pgraph_header(resptr)^.xpos:=xpos; Pgraph_header(resptr)^.ypos:=ypos;
 Pgraph_header(resptr)^.width:=width; Pgraph_header(resptr)^.height:=height;
 Pgraph_header(resptr)^.visible:=visible;
 i:=1;
 while(i<=gheap.item_max_index)do
  begin
   if(graph_heap_search_for_memindex(i)=false) then break;
   inc(i);
  end;
 if(i>gheap.item_max_index) then inc(gheap.item_max_index);
 Pgraph_header(resptr)^.Index:=i;
 inc(resptr,sizeof(graph_header));
 graph_heap_getmem:=resptr;
end;
function graph_heap_getmemsize(ptr:Pointer):natuint;
begin
 graph_heap_getmemsize:=graph_heap_get_memory_size(ptr);
end;
function graph_heap_allocmem(width,height:dword;xpos,ypos:Integer;visible:boolean):Pointer;
var resptr:Pointer;
    i:natuint;
begin
 resptr:=graph_heap_request_memory(width,height,true);
 Pgraph_header(resptr)^.xpos:=xpos; Pgraph_header(resptr)^.ypos:=ypos;
 Pgraph_header(resptr)^.width:=width; Pgraph_header(resptr)^.height:=height;
 Pgraph_header(resptr)^.visible:=visible;
 i:=1;
 while(i<=gheap.item_max_index)do
  begin
   if(graph_heap_search_for_memindex(i)=false) then break;
   inc(i);
  end;
 if(i>gheap.item_max_index) then inc(gheap.item_max_index);
 Pgraph_header(resptr)^.Index:=i;
 inc(resptr,sizeof(graph_header));
 graph_heap_allocmem:=resptr;
end;
function graph_heap_get_header(ptr:Pointer):graph_header;
var resptr:Pgraph_header;
begin
 resptr:=graph_heap_get_memory_start(ptr);
 graph_heap_get_header:=resptr^;
end;
procedure graph_heap_set_header(ptr:Pointer;head:graph_header);
var resptr:Pgraph_header;
begin
 resptr:=graph_heap_get_memory_start(ptr);
 resptr^:=head;
end;
procedure graph_heap_edit_header(ptr:Pointer;newwidth,newheight:Dword;newxpos,newypos:Integer;visible:boolean);
var resptr:Pgraph_header;
begin
 resptr:=graph_heap_get_memory_start(ptr);
 resptr^.visible:=visible; resptr^.width:=newwidth;
 resptr^.height:=newheight; resptr^.xpos:=newxpos; resptr^.ypos:=newypos;
end;
procedure graph_heap_freemem(var ptr:Pointer);
var i:Natuint;
begin
 graph_heap_free_memory(ptr,true);
 i:=gheap.item_max_index;
 while(i>0)do
  begin
   if(graph_heap_search_for_memindex(i)=false) then break;
   dec(i);
  end;
 gheap.item_max_index:=i;
end;
procedure graph_heap_reallocmem(var ptr:Pointer;newwidth,newheight:dword;newxpos,newypos:Integer;
visible:boolean);
var resptr:Pointer;
    head:graph_header;
begin
 head:=graph_heap_get_header(ptr);
 if(head.width=newwidth) and (head.height=newheight) then
  begin
   head.xpos:=newxpos; head.ypos:=newypos; head.visible:=visible;
   graph_heap_set_header(ptr,head);
   exit;
  end;
 resptr:=graph_heap_allocmem(newwidth,newheight,newxpos,newypos,visible);
 if(resptr=nil) then exit;
 head:=graph_heap_get_header(resptr);
 graph_heap_move_memory(ptr,resptr);
 graph_heap_set_header(resptr,head);
 graph_heap_free_memory(ptr,true);
 resptr:=ptr;
end;
procedure graph_heap_draw_point(ptr:Pointer;xpos,ypos:Integer;color:graph_color);
var head:graph_header;
    screenpos:Natuint;
begin
 head:=graph_heap_get_header(ptr);
 if(xpos<=0) or (xpos>=head.width) then exit;
 if(ypos<=0) or (ypos>=head.height) then exit;
 screenpos:=((ypos-1)*head.width+xpos-1);
 Pgraph_color(ptr+screenpos shl 2)^:=color;
end;
procedure graph_heap_draw_block(ptr:Pointer;xpos,ypos:Integer;width,height:Dword;color:graph_color);
var head:graph_header;
    xstart,ystart:Integer;
    xend,yend,i,j:Dword;
    screenpos:Natuint;
begin
 head:=graph_heap_get_header(ptr);
 if(xpos>head.width) then exit;
 if(ypos>head.height) then exit;
 xstart:=xpos; ystart:=ypos;
 if(xstart>0) then xstart:=xpos else xstart:=1;
 if(ystart>0) then ystart:=ypos else ystart:=1;
 if(xpos+width-1>=head.width) then xend:=head.width else xend:=xpos+width-1;
 if(ypos+height-1>=head.height) then yend:=head.height else yend:=ypos+height-1;
 for j:=ystart to yend do
  for i:=xstart to xend do
   begin
    screenpos:=(j-1)*head.width+i-1; Pgraph_color(ptr+screenpos shl 2)^:=color;
   end;
end;
procedure graph_heap_draw_circle(ptr:Pointer;xpos,ypos:Integer;radius:dword;color:graph_color);
var head:graph_header;
    xstart,ystart:Integer;
    xend,yend,i,j:Dword;
    screenpos:Natuint;
begin
 head:=graph_heap_get_header(ptr);
 if(xpos-radius>0) then xstart:=xpos-radius else xstart:=1;
 if(ypos-radius>0) then ystart:=ypos-radius else ystart:=1;
 if(xpos+radius<head.width) then xend:=xpos+radius else xend:=head.width;
 if(ypos+radius<head.height) then yend:=ypos+radius else yend:=head.height;
 for j:=ystart to yend do
  for i:=xstart to xend do
   begin
    if(sqr(j-ypos)+sqr(i-xpos)<=sqr(radius)) then
     begin
      screenpos:=(j-1)*head.width+i-1; Pgraph_color(ptr+screenpos shl 2)^:=color;
     end;
   end;
end;
procedure graph_heap_draw_fanshape(ptr:Pointer;xpos,ypos:Integer;radius:dword;
anglestart,angleend:extended;color:graph_color);
var head:graph_header;
    xstart,ystart:Integer;
    xend,yend,i,j:Dword;
    screenpos:Natuint;
    sinx,cosx,anglenow:extended;
begin
 head:=graph_heap_get_header(ptr);
 if(xpos-radius>0) then xstart:=xpos-radius else xstart:=1;
 if(ypos-radius>0) then ystart:=ypos-radius else ystart:=1;
 if(xpos+radius<head.width) then xend:=xpos+radius else xend:=head.width;
 if(ypos+radius<head.height) then yend:=ypos+radius else yend:=head.height;
 for j:=ystart to yend do
  for i:=xstart to xend do
   begin
    sinx:=(ypos-j)/sqrt(sqr(ypos-j)+sqr(i-xpos)); cosx:=(i-xpos)/sqrt(sqr(ypos-j)+sqr(i-xpos));
    if(sinx>1) or (cosx>1) or (sinx<-1) or (cosx<-1) then continue;
    if(sinx>=0) and (cosx>=0) then anglenow:=radtodeg(arcsin(sinx))
    else if(sinx>=0) and (cosx<=0) then anglenow:=180-radtodeg(arcsin(sinx))
    else if(sinx<=0) and (cosx<=0) then anglenow:=360+radtodeg(arcsin(sinx))
    else if(sinx<=0) and (cosx>=0) then anglenow:=360+radtodeg(arcsin(sinx));
    if(sqr(ypos-j)+sqr(i-xpos)<=sqr(radius))
    and (anglestart<=anglenow) and (angleend>=anglenow) then
     begin
      screenpos:=(j-1)*head.width+i-1; Pgraph_color(ptr+screenpos shl 2)^:=color;
     end;
   end;
end;
procedure graph_heap_draw_eclipse(ptr:Pointer;xpos,ypos:Integer;width,height:Dword;Color:graph_color);
var head:graph_header;
    xstart,ystart,xm,ym:Integer;
    xend,yend,i,j:dword;
    screenpos:Natuint;
begin
 head:=graph_heap_get_header(ptr);
 if(xpos>head.width) then exit;
 if(ypos>head.height) then exit;
 xstart:=xpos; ystart:=ypos;
 if(xstart>0) then xstart:=1;
 if(ystart>0) then ystart:=1;
 xm:=xpos-1+width shr 1; ym:=ypos-1+height shr 1;
 if(xpos+width-1<=head.width) then xend:=xpos+width-1 else xend:=head.width;
 if(ypos+height-1<=head.height) then yend:=ypos+height-1 else yend:=head.height;
 for j:=ystart to yend do
  for i:=xstart to xend do
   begin
    if(sqr(j-ym)/sqr(height/2)+sqr(i-xm)/sqr(width/2)<=1) then
     begin
      screenpos:=(j-1)*head.width+i-1; Pgraph_color(ptr+screenpos shl 2)^:=color;
     end;
   end;
end;
procedure graph_heap_clear_canva(ptr:Pointer);
var head:graph_header;
    screenpos:Natuint;
begin
 head:=graph_heap_get_header(ptr); screenpos:=0;
 for i:=1 to head.width do
  for j:=1 to head.height do
   begin
    Pgraph_color(ptr+screenpos shl 2)^:=graph_color_zero;
    inc(screenpos);
   end;
end;
procedure graph_heap_draw_line(ptr:Pointer;xstart,ystart,xend,yend:Integer;Color:graph_color);
begin

end;
procedure graph_heap_draw_line(ptr:Pointer;startpos,endpos:graph_point;Color:graph_color);
begin

end;
procedure graph_heap_draw_triangle(ptr:Pointer;p1x,p1y,p2x,p2y,p3x,p3y:Integer;color:graph_color);
begin

end;
procedure graph_heap_draw_triangle(ptr:Pointer;p1,p2,p3:graph_point;color:graph_color);
begin

end;
procedure graph_heap_draw_polygon(ptr:Pointer;p:Pgraph_point;pcount:natuint;color:graph_color);
begin

end;
procedure graph_heap_draw_character(ptr:Pointer;character:graph_char;px,py:Integer;color:graph_color);
begin

end;
procedure graph_heap_draw_character(ptr:Pointer;character:graph_char;point:graph_point;color:graph_color);
begin

end;
procedure graph_heap_draw_string(ptr:Pointer;str:graph_string;px,py:Integer;color:graph_color);
begin

end;
procedure graph_heap_draw_string(ptr:Pointer;str:graph_string;point:graph_point;color:graph_color);
begin

end;
procedure graph_heap_output_screen;
var i,j,k:natuint;
    screenpos:natuint;
    canvapos:natuint;
    addr:Pointer;
    header:graph_header;
    exist:boolean;
begin
 if(gheap.screen_attribute.virtiogpu) then exit;
 {Initialize the Screen}
 screenpos:=0;
 for i:=1 to gheap.screen_width do
  for j:=1 to gheap.screen_height do
   begin
    (gheap.screen_init_address+screenpos)^:=graph_color_black;
    inc(screenpos,1);
   end;
 {Then draw the initial screen}
 for i:=1 to gheap.item_max_index do
  begin
   exist:=graph_heap_search_for_memindex(i);
   if(exist=false) then continue;
   addr:=graph_heap_search_for_memindex_address(i);
   header:=graph_heap_get_header(addr);
   if(header.visible=false) then continue;
   screenpos:=(header.ypos-1)*gheap.screen_width+header.xpos-1;
   canvapos:=0;
   for k:=1 to header.height do
    begin
     for j:=1 to header.width do
      begin
       if(header.xpos+j-1<=0) or (header.ypos+k-1<=0) or (header.xpos+j-1>gheap.screen_width)
       or(header.ypos+k-1>gheap.screen_height) then
        begin
         inc(screenpos); inc(canvapos); continue;
        end;
       (gheap.screen_init_address+screenpos)^:=
       graph_color_mixed((gheap.screen_init_address+screenpos)^,
       Pgraph_color(addr+canvapos shl 2)^);
       inc(screenpos);
       inc(canvapos);
      end;
     inc(screenpos,gheap.screen_width-header.width);
    end;
  end;
 {Then draw it to the physical screen}
 screenpos:=0;
 for i:=1 to gheap.screen_width do
  for j:=1 to gheap.screen_height do
   begin
    if(gheap.screen_attribute.colortype=graph_color_type_bgr) then
     begin
      Pgraph_output_color(gheap.screen_output_address+screenpos)^.BGRRed:=
      Pgraph_color(gheap.screen_init_address+screenpos)^.Red;
      Pgraph_output_color(gheap.screen_output_address+screenpos)^.BGRBlue:=
      Pgraph_color(gheap.screen_init_address+screenpos)^.Blue;
      Pgraph_output_color(gheap.screen_output_address+screenpos)^.BGRGreen:=
      Pgraph_color(gheap.screen_init_address+screenpos)^.Green;
      Pgraph_output_color(gheap.screen_output_address+screenpos)^.BGRReserved:=$00;
     end
    else
     begin
      Pgraph_output_color(gheap.screen_output_address+screenpos)^.RGBRed:=
      Pgraph_color(gheap.screen_init_address+screenpos)^.Red;
      Pgraph_output_color(gheap.screen_output_address+screenpos)^.RGBGreen:=
      Pgraph_color(gheap.screen_init_address+screenpos)^.Green;
      Pgraph_output_color(gheap.screen_output_address+screenpos)^.RGBBlue:=
      Pgraph_color(gheap.screen_init_address+screenpos)^.Blue;
      Pgraph_output_color(gheap.screen_output_address+screenpos)^.RGBReserved:=$00;
     end;
    inc(screenpos,1);
   end;
end;
procedure graph_heap_output_screen_using_virtio_gpu;
begin

end;

end.

