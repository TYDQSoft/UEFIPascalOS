program kernelmain;

{$MODE FPC}

uses bootconfig,graphics{$ifdef cpuaarch64},prt0{$endif cpuaarch64}{$ifdef cpuarm},prt0{$endif cpuarm};

function kernel_main(param:Psys_parameter):Pointer;[public,alias:'_start'];
var readoffset:natuint;
    ptr:Pgraphics_item;
    res:Preturn_config;
    i:natuint;
begin
 {$ifdef cpuaarch64}
 ExitCode:=0;
 {$endif cpuaarch64}
 {$ifdef cpuarm}
 ExitCode:=0;
 {$endif cpuarm}
 readoffset:=0;
 compheap:=Pheap_record(param^.param_content+readoffset)^;
 readoffset:=readoffset+sizeof(heap_record);
 graphheap:=Pgraphics_heap(param^.param_content+readoffset)^;
 readoffset:=readoffset+sizeof(graphics_heap);
 sysheap:=Pheap_record(param^.param_content+readoffset)^;
 readoffset:=readoffset+sizeof(heap_record);
 ptr:=graphics_getmem(1,1,graphheap.screenwidth,graphheap.screenheight);
 graphics_draw_block(ptr,1,1,graphheap.screenwidth,graphheap.screenheight,graphics_white);
 graphics_output_to_screen;
 res:=allocmem(sizeof(return_config));
 res^.m1:=graphheap.contentused;
 res^.m2:=graphheap.contentmax;
 res^.m3:=Natuint(ptr);
 res^.m4:=graphheap.segmentcount;
 res^.m5:=graphheap.segmentcountmax;
 kernel_main:=res;
end;

begin
end.
