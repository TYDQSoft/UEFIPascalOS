program kernelmain;

{$MODE FPC}

uses bootconfig,graphics;

procedure kernel_main(param:Psys_parameter);[public,alias:'_start'];
var readoffset:natuint;
    ptr:Pgraphics_item;
    i:natuint;
begin
 readoffset:=0;
 compheap:=Pheap_record(param^.param_content+readoffset)^;
 readoffset:=readoffset+sizeof(heap_record);
 graphheap:=Pgraphics_heap(param^.param_content+readoffset)^;
 readoffset:=readoffset+sizeof(graphics_heap);
 sysheap:=Pheap_record(param^.param_content+readoffset)^;
 sysheap.contentused:=0; sysheap.segmentcount:=0;
 readoffset:=readoffset+sizeof(heap_record);
 ptr:=graphics_getmem(1,1,graphheap.screenwidth,graphheap.screenheight);
 graphics_draw_block(ptr,1,1,graphheap.screenwidth,graphheap.screenheight,graphics_white);
 graphics_output_to_screen;
 while True do;
end;

begin
end.
