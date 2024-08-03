program kernelmain;

uses bootconfig,graphics;

function kernel_main(param:sys_parameter):Pointer;[public,alias:'_start'];
var Pparam1:Pscreen_config;
    screenconfig:screen_config;
    ptr:Pgraphics_item;
    res:Pqword;
begin
 Pparam1:=Pointer(param.param_content);
 screenconfig:=Pparam1^;
 graphics_heap_initialize;
 ptr:=graphics_heap_getmem(1,1,screenconfig.screen_scanline,screenconfig.screen_height);
 graphics_draw_block(ptr,1,1,screenconfig.screen_scanline,screenconfig.screen_height,$FF,$FF,$FF,$FF);
 graphics_heap_output_to_screen(screenconfig.screen_address,screenconfig.screen_scanline,screenconfig.screen_height);
 res:=allocmem(sizeof(qword));
 res^:=120;
 kernel_main:=res;
end;

begin
end.
