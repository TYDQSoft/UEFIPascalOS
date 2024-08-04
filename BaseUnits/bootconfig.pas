unit bootconfig;

interface

type screen_config=packed record
                   screen_is_graphics:boolean;
                   screen_address:qword;
                   screen_width:dword;
                   screen_height:dword;
                   end;
     Pscreen_config=^screen_config;
     
implementation

end.
