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
                   m1,m2,m3,m4,m5,m6:natuint;
                   end;
     Preturn_config=^return_config;
     
implementation

end.
