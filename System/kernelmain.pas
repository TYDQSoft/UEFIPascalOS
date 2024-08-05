program kernelmain;

uses bootconfig,graphics;

function kernel_main(param:sys_parameter):Pointer;[public,alias:'_start'];
var screenconfig:screen_config;
    ptr:Pgraphics_item;
    res:Preturn_config;
begin
 sysheap_initialize;
 screenconfig:=Pscreen_config(param.param_content)^;
 graphics_heap_initialize;
 //ptr:=graphics_heap_getmem(1,1,2560,1600);
 //graphics_draw_block(ptr,1,1,2560,1600,$FF,$FF,$FF,$FF);
 //graphics_heap_output_to_screen(3288334336,2560,1600);
 ptr:=graphics_heap_getmem(1,1,screenconfig.screen_width,screenconfig.screen_height);
 graphics_draw_block(ptr,1,1,screenconfig.screen_width,screenconfig.screen_height,$FF,$FF,$FF,$FF);
 graphics_heap_output_to_screen(screenconfig.screen_address,screenconfig.screen_width,screenconfig.screen_height);
 res:=allocmem(sizeof(return_config));
 res^.content:=Natuint(param.param_content);
 res^.size:=param.param_size^;
 res^.count:=param.param_count;
 kernel_main:=res;
end;

begin
end.
