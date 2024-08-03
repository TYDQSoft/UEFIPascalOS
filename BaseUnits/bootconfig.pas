unit bootconfig;

interface

type screen_config=packed record
                   screen_is_graphics:boolean;
                   screen_address:qword;
                   screen_width:qword;
                   screen_height:qword;
                   screen_scanline:qword;
                   end;
     Pscreen_config=^screen_config;
     
implementation

end.
