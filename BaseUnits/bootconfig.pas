unit bootconfig;

interface

type screen_config=packed record
                   screen_is_graphics:boolean;
                   screen_address:natuint;
                   screen_width:dword;
                   screen_height:dword;
                   end;
     Pscreen_config=^screen_config;
     return_config=packed record
                   content:natuint;
                   size:natuint;
                   count:natuint;
                   end;
     Preturn_config=^return_config;
     
implementation

end.
