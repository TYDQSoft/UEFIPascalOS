program kernelmain;

{$MODE FPC}

uses bootconfig,graphics;

function kernel_main(param:sys_parameter):Pointer;[public,alias:'_start'];
var screenconfig:screen_config;
    ptr:Pgraphics_item;
    res:Preturn_config;
begin
 {$ifdef cpux86_64}
 screenconfig:=Pscreen_config(Psys_parameter($BFEC1900)^.param_content)^;
 {$else cpux86_64}
 screenconfig:=Pscreen_config(param.param_content)^;
 {$endif}
 graphics_heap_initialize;
 ptr:=graphics_heap_getmem(1,1,screenconfig.screen_width,screenconfig.screen_height);
 graphics_draw_block(ptr,1,1,screenconfig.screen_width,screenconfig.screen_height,$FF,$FF,$FF,$FF);
 graphics_heap_output_to_screen(screenconfig.screen_address,screenconfig.screen_width,screenconfig.screen_height);
 res:=allocmem(sizeof(return_config));
 res^.content:=screenconfig.screen_address;
 res^.size:=screenconfig.screen_width;
 res^.count:=screenconfig.screen_height;
 kernel_main:=res;
end;

begin
end.
