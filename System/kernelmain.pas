program kernelmain;

uses bootconfig,graphics;

function kernel_main(param:sys_parameter):Pointer;[public,alias:'_start'];
var screenconfig:screen_config;
    ptr:Pgraphics_item;
    res:Pqword;
begin
 screenconfig:=Pscreen_config(param.param_content)^;
 graphics_heap_initialize;
 ptr:=graphics_heap_getmem(1,1,screenconfig.screen_width,screenconfig.screen_height);
 graphics_draw_block(ptr,1,1,screenconfig.screen_width,screenconfig.screen_height,$FF,$FF,$FF,$FF);
 graphics_heap_output_to_screen(screenconfig.screen_address,screenconfig.screen_width,screenconfig.screen_height);
 res:=allocmem(sizeof(qword));
 res^:=120;
 kernel_main:=res;
end;

begin
end.
