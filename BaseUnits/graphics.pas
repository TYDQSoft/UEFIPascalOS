unit graphics;

interface

{$MODE objFPC}{$H+}

uses font;

type graph_point=packed record
                 XPosition,YPosition:extended;
                 end;
     graph_point_array=array of graph_point;
     graph_input_point=packed record
                       XPosition,YPosition:Integer;
                       end;
     graph_input_point_array=array of graph_input_point;
     graph_line_segment=packed record
                        IsVertical:boolean;
                        Slope:Extended;
                        Intercept:Extended;
                        StartX,EndX:Extended;
                        end;
     graph_attribute=packed record
                     Index:Natuint;
                     xposition,yposition:Integer;
                     CanvaWidth,CanvaHeight:Dword;
                     StartItemIndex:Dword;
                     Visible:boolean;
                     end;
     Pgraph_attribute=^graph_attribute;
     graph_output_color=packed record
                        case Byte of
                        0:(RGBRed:byte;RGBGreen:byte;RGBBlue:byte;RGBReserved:byte;);
                        1:(BGRBlue:byte;BGRGreen:byte;BGRRed:byte;BGRReserved:byte;);
                        end;
     Pgraph_output_color=^graph_output_color;
     graph_color=packed record
                 Red:byte;
                 Green:byte;
                 Blue:byte;
                 Alpha:byte;
                 end;
     Pgraph_color=^graph_color;
     graph_item=packed record
                Allocated:dword;
                RightIndex:dword;
                end;
     Pgraph_item=^graph_item;
     graph_heap=packed record
                MaxIndex:Natuint;
                {For Heap Only}
                HeapStartAddress:Pgraph_item;
                HeapEndAddress:Pgraph_color;
                AvailablePosition:Dword;
                MaxItemIndex:Dword;
                RestSize:Natuint;
                {For Attribute Only}
                AttributeAddress:Pgraph_attribute;
                AttributeMaxCount:Dword;
                AttributeMaxIndex:Dword;
                AvailableIndex:Dword;
                BlockPower:byte;
                {For Screen Only}
                ScreenAttribute:boolean;
                ScreenWidth,ScreenHeight:dword;
                ScreenInitAddress:Pgraph_color;
                ScreenOutputAddress:Pgraph_output_color;
                end;

const graph_color_screen_rgb:boolean=false;
      graph_color_screen_bgr:boolean=true;
      graph_color_zero:graph_color=(Red:0;Green:0;Blue:0;Alpha:0);
      graph_color_none:graph_color=(Red:0;Green:0;Blue:0;Alpha:0);
      graph_color_black:graph_color=(Red:0;Green:0;Blue:0;Alpha:$FF);
      graph_color_ivory_black:graph_color=(Red:41;Green:36;Blue:33;Alpha:$FF);
      graph_color_grey:graph_color=(Red:192;Green:192;Blue:192;Alpha:$FF);
      graph_color_cold_grey:graph_color=(Red:128;Green:138;Blue:135;Alpha:$FF);
      graph_color_slate_grey:graph_color=(Red:112;Green:128;Blue:105;Alpha:$FF);
      graph_color_warm_grey:graph_color=(Red:128;Green:128;Blue:105;Alpha:$FF);
      graph_color_white:graph_color=(Red:255;Green:255;Blue:255;Alpha:$FF);
      graph_color_antique_white:graph_color=(Red:250;Green:235;Blue:215;Alpha:$FF);
      graph_color_light_sky_blue:graph_color=(Red:240;Green:255;Blue:255;Alpha:$FF);
      graph_color_white_smoke:graph_color=(Red:245;Green:245;Blue:255;Alpha:$FF);
      graph_color_white_almond:graph_color=(Red:255;Green:235;Blue:205;Alpha:$FF);
      graph_color_cornsilk:graph_color=(Red:255;Green:248;Blue:220;Alpha:$FF);
      graph_color_eggshell:graph_color=(Red:252;Green:230;Blue:201;Alpha:$FF);
      graph_color_yellow:graph_color=(Red:255;Green:255;Blue:0;Alpha:$FF);
      graph_color_banana:graph_color=(Red:227;Green:207;Blue:87;Alpha:$FF);
      graph_color_cadmium_yellow:graph_color=(Red:255;Green:153;Blue:18;Alpha:$FF);
      graph_color_dougello:graph_color=(Red:235;Green:142;Blue:85;Alpha:$FF);
      graph_color_forum_gold:graph_color=(Red:255;Green:237;Blue:222;Alpha:$FF);
      graph_color_gold:graph_color=(Red:255;Green:215;Blue:0;Alpha:$FF);
      graph_color_flower_yellow:graph_color=(Red:218;Green:165;Blue:105;Alpha:$FF);
      graph_color_melon_yellow:graph_color=(Red:227;Green:168;Blue:105;Alpha:$FF);
      graph_color_orange:graph_color=(Red:255;Green:97;Blue:0;Alpha:$FF);
      graph_color_cadmium_orange:graph_color=(Red:255;Green:97;Blue:3;Alpha:$FF);
      graph_color_carrot_yellow:graph_color=(Red:237;Green:145;Blue:33;Alpha:$FF);
      graph_color_orange_yellow:graph_color=(Red:255;Green:128;Blue:0;Alpha:$FF);
      graph_color_pale_yellow:graph_color=(Red:245;Green:222;Blue:179;Alpha:$FF);
      graph_color_light_grey_blue:graph_color=(Red:176;Green:224;Blue:230;Alpha:$FF);
      graph_color_reddish_blue:graph_color=(Red:65;Green:105;Blue:255;Alpha:$FF);
      graph_color_slate_blue:graph_color=(Red:106;Green:90;Blue:205;Alpha:$FF);
      graph_color_sky_blue:graph_color=(Red:135;Green:206;Blue:235;Alpha:$FF);
      graph_color_cyan:graph_color=(Red:0;Green:255;Blue:255;Alpha:$FF);
      graph_color_green_dirt:graph_color=(Red:56;Green:94;Blue:15;Alpha:$FF);
      graph_color_indigo_blue:graph_color=(Red:8;Green:46;Blue:84;Alpha:$FF);
      graph_color_aqua_marine:graph_color=(Red:127;Green:255;Blue:212;Alpha:$FF);
      graph_color_turquoise:graph_color=(Red:64;Green:224;Blue:208;Alpha:$FF);
      graph_color_green:graph_color=(Red:0;Green:255;Blue:0;Alpha:$FF);
      graph_color_yellow_green:graph_color=(Red:127;Green:255;Blue:0;Alpha:$FF);
      graph_color_cobalt_green:graph_color=(Red:61;Green:145;Blue:64;Alpha:$FF);
      graph_color_viridis:graph_color=(Red:0;Green:201;Blue:87;Alpha:$FF);
      graph_color_flower_white:graph_color=(Red:255;Green:250;Blue:240;Alpha:$FF);
      graph_color_gainsboro:graph_color=(Red:220;Green:220;Blue:220;Alpha:$FF);
      graph_color_ghost_white:graph_color=(Red:248;Green:248;Blue:255;Alpha:$FF);
      graph_color_honey_dew_orange:graph_color=(Red:240;Green:255;Blue:240;Alpha:$FF);
      graph_color_ivory_white:graph_color=(Red:250;Green:255;Blue:240;Alpha:$FF);
      graph_color_flaxen:graph_color=(Red:250;Green:240;Blue:230;Alpha:$FF);
      graph_color_navajo_white:graph_color=(Red:255;Green:222;Blue:173;Alpha:$FF);
      graph_color_old_lace:graph_color=(Red:253;Green:245;Blue:230;Alpha:$FF);
      graph_color_sea_shell:graph_color=(Red:255;Green:245;Blue:238;Alpha:$FF);
      graph_color_snow_white:graph_color=(Red:255;Green:250;Blue:250;Alpha:$FF);
      graph_color_red:graph_color=(Red:255;Green:0;Blue:0;Alpha:$FF);
      graph_color_brick_red:graph_color=(Red:156;Green:102;Blue:31;Alpha:$FF);
      graph_color_cobalt_red:graph_color=(Red:227;Green:23;Blue:13;Alpha:$FF);
      graph_color_coral:graph_color=(Red:255;Green:127;Blue:80;Alpha:$FF);
      graph_color_firebrick_red:graph_color=(Red:178;Green:34;Blue:34;Alpha:$FF);
      graph_color_indian_red:graph_color=(Red:176;Green:23;Blue:31;Alpha:$FF);
      graph_color_maroon:graph_color=(Red:176;Green:46;Blue:96;Alpha:$FF);
      graph_color_pink_red:graph_color=(Red:255;Green:192;Blue:203;Alpha:$FF);
      graph_color_strawberry:graph_color=(Red:135;Green:38;Blue:87;Alpha:$FF);
      graph_color_orange_red:graph_color=(Red:250;Green:128;Blue:114;Alpha:$FF);
      graph_color_tomato_red:graph_color=(Red:255;Green:99;Blue:71;Alpha:$FF);
      graph_color_vermillion:graph_color=(Red:255;Green:69;Blue:0;Alpha:$FF);
      graph_color_heavy_red:graph_color=(Red:255;Green:0;Blue:255;Alpha:$FF);
      graph_color_brown:graph_color=(Red:128;Green:42;Blue:42;Alpha:$FF);
      graph_color_cream:graph_color=(Red:163;Green:148;Blue:128;Alpha:$FF);
      graph_color_soil_yellow:graph_color=(Red:138;Green:54;Blue:15;Alpha:$FF);
      graph_color_soil_brown:graph_color=(Red:135;Green:51;Blue:36;Alpha:$FF);
      graph_color_chocolate:graph_color=(Red:210;Green:105;Blue:30;Alpha:$FF);
      graph_color_meat:graph_color=(Red:255;Green:125;Blue:64;Alpha:$FF);
      graph_color_yellow_brown:graph_color=(Red:240;Green:230;Blue:140;Alpha:$FF);
      graph_color_rose_red:graph_color=(Red:188;Green:143;Blue:143;Alpha:$FF);
      graph_color_dirt_red:graph_color=(Red:199;Green:97;Blue:20;Alpha:$FF);
      graph_color_dirt_brown:graph_color=(Red:115;Green:74;Blue:18;Alpha:$FF);
      graph_color_squid_brown:graph_color=(Red:94;Green:38;Blue:18;Alpha:$FF);
      graph_color_ocher:graph_color=(Red:160;Green:82;Blue:45;Alpha:$FF);
      graph_color_horse_brown:graph_color=(Red:139;Green:69;Blue:19;Alpha:$FF);
      graph_color_sand_brown:graph_color=(Red:244;Green:164;Blue:96;Alpha:$FF);
      graph_color_dark_brown:graph_color=(Red:210;Green:180;Blue:140;Alpha:$FF);
      graph_color_blue:graph_color=(Red:0;Green:0;Blue:255;Alpha:$FF);
      graph_color_cobalt:graph_Color=(Red:61;Green:89;Blue:171;Alpha:$FF);
      graph_color_dodger_blue:graph_color=(Red:30;Green:144;Blue:255;Alpha:$FF);
      graph_color_jackie_blue:graph_color=(Red:11;Green:23;Blue:70;Alpha:$FF);
      graph_color_manganese_blue:graph_color=(Red:3;Green:168;Blue:158;Alpha:$FF);
      graph_color_heavy_blue:graph_color=(Red:25;Green:25;Blue:112;Alpha:$FF);
      graph_color_peacock_blue:graph_color=(Red:51;Green:161;Blue:201;Alpha:$FF);
      graph_color_turkey_jade_blue:graph_color=(Red:0;Green:199;Blue:140;Alpha:$FF);
      graph_color_forest_green:graph_color=(Red:34;Green:134;Blue:34;Alpha:$FF);
      graph_color_grassland_green:graph_color=(Red:124;Green:252;Blue:0;Alpha:$FF);
      graph_color_sour_orange_green:graph_color=(Red:50;Green:205;Blue:50;Alpha:$FF);
      graph_color_mint_green:graph_color=(Red:189;Green:252;Blue:201;Alpha:$FF);
      graph_color_grass_green:graph_color=(Red:107;Green:142;Blue:35;Alpha:$FF);
      graph_color_dark_green:graph_color=(Red:48;Green:128;Blue:20;Alpha:$FF);
      graph_color_sea_green:graph_color=(Red:46;Green:139;Blue:87;Alpha:$FF);
      graph_color_fresh_green:graph_color=(Red:0;Green:255;Blue:127;Alpha:$FF);
      graph_color_purple:graph_color=(Red:160;Green:32;Blue:240;Alpha:$FF);
      graph_color_violet_purple:graph_color=(Red:138;Green:43;Blue:226;Alpha:$FF);
      graph_color_jasona:graph_color=(Red:160;Green:102;Blue:211;Alpha:$FF);
      graph_color_lake_purple:graph_color=(Red:153;Green:51;Blue:250;Alpha:$FF);
      graph_color_light_purple:graph_color=(Red:218;Green:112;Blue:214;Alpha:$FF);
      graph_color_plum_purple:graph_color=(Red:221;Green:160;Blue:221;Alpha:$FF);
      graph_align_left:byte=0;
      graph_align_center:byte=1;
      graph_align_right:byte=2;
      graph_align_top:byte=0;
      graph_align_middle:byte=1;
      graph_align_buttom:byte=2;
      graph_align_maxlength:dword=$FFFFFFFF;
      graph_pi:extended=3.1415976;

operator := (point:graph_input_point)res:graph_point;
function graph_color_alpha(color:graph_color;Alpha:byte):graph_color;
function graph_color_alpha_mix(Alpha1,Alpha2:byte):byte;
function graph_color_mix_color(color1,color2:graph_color;color1ratio:extended):graph_color;
function graph_color_inverse(color:graph_color):graph_color;
function graph_color_darker(color1,color2:graph_color):graph_color;
function graph_color_brighter(color1,color2:graph_color):graph_color;
function graph_color_multiply(color1,color2:graph_color):graph_color;
function graph_color_filter(color1,color2:graph_color):graph_color;
function graph_color_color_burn(color1,color2:graph_color):graph_color;
function graph_color_color_dodge(color1,color2:graph_color):graph_color;
function graph_color_linear_burn(color1,color2:graph_color):graph_color;
function graph_color_linear_dodge(color1,color2:graph_color):graph_color;
function graph_color_overlay(color1,color2:graph_color):graph_color;
function graph_color_highlight(color1,color2:graph_color):graph_color;
function graph_color_diffuse(color1,color2:graph_color):graph_color;
function graph_color_light(color1,color2:graph_color):graph_color;
function graph_color_point_light(color1,color2:graph_color):graph_color;
function graph_color_linear_light(color1,color2:graph_color):graph_color;
function graph_color_solid_color_mix(color1,color2:graph_color):graph_color;
function graph_color_except(color1,color2:graph_color):graph_color;
function graph_color_delta(color1,color2:graph_color):graph_color;
procedure graph_heap_initialize(StartAddress:Pointer;EndAddress:Pointer;BlockPower:byte;
ScreenWidth,ScreenHeight:dword;OutputAddress:Pointer;ScreenRedGreenBlue:boolean);
function graph_heap_getmem(xposition,yposition:Integer;
Width,Height:Dword;Visible:boolean):Dword;
function graph_heap_getmemsize(index:Dword):Natuint;
function graph_heap_allocmem(xposition,yposition:Integer;
Width,Height:Dword;Visible:boolean):Dword;
procedure graph_heap_freemem(var index:Dword);
procedure graph_heap_reallocmem(var Index:Dword;xposition,yposition:Integer;
Width,Height:Dword;Visible:boolean);
procedure graph_heap_set_attribute(Index:Dword;
newxposition,newyposition:Integer;NewVisibleStatus:boolean);
procedure graph_heap_clear(Index:Dword);
procedure graph_heap_fill_with_color(Index:Dword;Color:graph_color);
procedure graph_heap_draw_point(Index:Dword;RelativeX,RelativeY:Integer;Color:graph_color);
procedure graph_heap_draw_block(Index:Dword;RelativeX,Relativey:Integer;Width,Height:Dword;
Color:graph_color);
procedure graph_heap_draw_circle(Index:Dword;RelativeX,Relativey:Integer;Radius:dword;Color:graph_color);
procedure graph_heap_draw_fanshape(Index:Dword;RelativeX,Relativey:Integer;Radius:dword;
StartAngle,EndAngle:extended;Color:graph_color);
var RelatedWidth,RelatedHeight:Dword;
procedure graph_heap_draw_eclipse(Index:Dword;RelativeX,Relativey:Integer;Width,Height:Dword;
Color:graph_color);
procedure graph_heap_draw_polygon(Index:Dword;Point:array of graph_point;Color:graph_color);
procedure graph_heap_draw_polygon(Index:Dword;Point:graph_point_array;Color:graph_color);
procedure graph_heap_draw_line(Index:Dword;Point:array of graph_point;Thickness:Dword;
Color:graph_color);
procedure graph_heap_draw_line(Index:Dword;Point:graph_point_array;Thickness:Dword;
Color:graph_color);
procedure graph_heap_draw_char(Index:Dword;Xalign:byte;YAlign:byte;PointX,PointY:Integer;
FontIndex:byte;Character:Char;Color:graph_color);
procedure graph_heap_draw_char(Index:Dword;Xalign:byte;YAlign:byte;Point:graph_input_point;
FontIndex:byte;Character:Char;Color:graph_color);
procedure graph_heap_draw_string(Index:Dword;Xalign:byte;YAlign:byte;PointX,PointY:Integer;
FontIndex:byte;Str:string;Color:graph_color;maxlinelength:Integer);
procedure graph_heap_draw_string(Index:Dword;Xalign:byte;YAlign:byte;PointX,PointY:Integer;
FontIndex:byte;Str:PChar;Color:graph_color;maxlinelength:Integer);
procedure graph_heap_draw_string(Index:Dword;Xalign:byte;YAlign:byte;Point:graph_input_point;
FontIndex:byte;Str:string;Color:graph_color;maxlinelength:Integer);
procedure graph_heap_draw_string(Index:Dword;Xalign:byte;YAlign:byte;Point:graph_input_point;
FontIndex:byte;Str:PChar;Color:graph_color;maxlinelength:Integer);
function graph_heap_get_visible_status(Index:Dword):boolean;
function graph_heap_get_x_position(Index:Dword):Integer;
function graph_heap_get_y_position(Index:Dword):Integer;
procedure graph_heap_set_visible_status(Index:Dword;NewVisibleStatus:boolean);
procedure graph_heap_set_x_position(Index:Dword;XPosition:Integer);
procedure graph_heap_set_y_position(Index:Dword;YPosition:Integer);
procedure graph_heap_output_screen;

var graphheap:graph_heap;

implementation

operator := (point:graph_input_point)res:graph_point;
begin
 res.xposition:=point.XPosition;
 res.YPosition:=point.YPosition;
end;
operator * (point:graph_point;lamdba:extended)res:graph_point;
begin
 res.XPosition:=point.XPosition*lamdba;
 res.YPosition:=point.YPosition*lamdba;
end;
operator + (point1,point2:graph_point)res:graph_point;
begin
 res.XPosition:=point1.XPosition+point2.XPosition;
 res.YPosition:=point1.YPosition+point2.YPosition;
end;
operator - (point1,point2:graph_point)res:graph_point;
begin
 res.XPosition:=point1.XPosition-point2.XPosition;
 res.YPosition:=point1.YPosition-point2.YPosition;
end;
function graph_get_bezier_point(Ratio:extended;Point:array of graph_point):graph_point;
var i:Natuint;
    res:graph_point;
begin
 i:=1; res.XPosition:=0; res.YPosition:=0;
 while(i<=length(Point))do
  begin
   res:=res+Point[i-1]*
   (factorial(length(Point))/(factorial(i)*factorial(length(Point)-i))
   *Power(Ratio,i)*Power(1-Ratio,length(Point)-i));
   inc(i);
  end;
 graph_get_bezier_point:=res;
end;
function graph_get_bezier_point(Ratio:extended;Point:graph_point_array):graph_point;
var i:Natuint;
    res:graph_point;
begin
 i:=1; res.XPosition:=0; res.YPosition:=0;
 while(i<=length(Point))do
  begin
   res:=res+Point[i-1]*
   (factorial(length(Point))/(factorial(i)*factorial(length(Point)-i))
   *Power(Ratio,i)*Power(1-Ratio,length(Point)-i));
   inc(i);
  end;
 graph_get_bezier_point:=res;
end;
function graph_color_mix(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 if(color2.Alpha=$FF) and (color1.Alpha=0) then
  begin
   res.Alpha:=$FF; res.Red:=color2.Red; res.Blue:=color2.Blue; res.Green:=color2.Green;
   exit(res);
  end
 else if(color2.Alpha=0) and (color1.Alpha=$FF) then
  begin
   res.Alpha:=$FF; res.Red:=color1.Red; res.Blue:=color1.Blue; res.Green:=color1.Green;
   exit(res);
  end
 else if(color2.Alpha=$FF) and (color1.Alpha=$FF) then
  begin
   res.Alpha:=$FF; res.Red:=color2.Red; res.Blue:=color2.Blue; res.Green:=color2.Green;
   exit(res);
  end;
 res.Alpha:=color1.Alpha;
 res.Red:=(color1.Red*res.Alpha+color2.Red*(255-res.Alpha) shr 8) and $FF;
 res.Blue:=(color1.Blue*res.Alpha+color2.Blue*(255-res.Alpha) shr 8) and $FF;
 res.Green:=(color1.Green*res.Alpha+color2.Green*(255-res.Alpha) shr 8) and $FF;
 res.Alpha:=(color1.Alpha*res.Alpha+color2.Alpha*(255-res.Alpha) shr 8) and $FF;
 graph_color_mix:=res;
end;
function graph_max(x,y:Natuint):Natuint;
begin
 if(x>y) then graph_max:=x else graph_max:=y;
end;
function graph_min(x,y:Natuint):Natuint;
begin
 if(x>y) then graph_min:=y else graph_min:=x;
end;
function graph_color_alpha(color:graph_color;Alpha:byte):graph_color;
var res:graph_color;
begin
 res.Red:=color.Red; res.Green:=color.Green; res.Blue:=color.Blue; res.Alpha:=Alpha;
 graph_color_alpha:=res;
end;
function graph_color_alpha_mix(Alpha1,Alpha2:byte):byte;
begin
 graph_color_alpha_mix:=(Alpha1*Alpha1+Alpha2*(255-Alpha1) shr 8) and $FF;
end;
function graph_color_mix_color(color1,color2:graph_color;color1ratio:extended):graph_color;
var res:graph_color;
begin
 res.Red:=Floor(color1.Red*color1ratio+color2.Red*(1-color1ratio));
 res.Green:=Floor(color1.Green*color1ratio+color2.Green*(1-color1ratio));
 res.Blue:=Floor(color1.Blue*color1ratio+color2.Blue*(1-color1ratio));
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_mix_color:=res;
end;
function graph_color_inverse(color:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=255-color.Red; res.Blue:=255-color.Blue; res.Green:=255-color.Green; res.Alpha:=color.Alpha;
 graph_color_inverse:=res;
end;
function graph_color_darker(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=graph_min(color1.Red,color2.Red);
 res.Green:=graph_min(color1.Green,color2.Green);
 res.Blue:=graph_min(color1.Blue,color2.Blue);
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_darker:=res;
end;
function graph_color_brighter(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=graph_max(color1.Red,color2.Red);
 res.Green:=graph_max(color1.Green,color2.Green);
 res.Blue:=graph_max(color1.Blue,color2.Blue);
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_brighter:=res;
end;
function graph_color_multiply(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=Word(color1.Red*color2.Red) div 255;
 res.Green:=Word(color1.Green*color2.Green) div 255;
 res.Blue:=Word(color1.Blue*color2.Blue) div 255;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_multiply:=res;
end;
function graph_color_filter(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=255-(255-color1.Red)*(255-color2.Red) div 255;
 res.Green:=255-(255-color1.Green)*(255-color2.Green) div 255;
 res.Blue:=255-(255-color1.Blue)*(255-color2.Blue) div 255;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_filter:=res;
end;
function graph_color_color_burn(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=color1.Red-(255-color1.Red)*(255-color2.Red) div color2.Red;
 res.Green:=color1.Green-(255-color1.Green)*(255-color2.Green) div color2.Green;
 res.Blue:=color1.Blue-(255-color1.Blue)*(255-color2.Blue) div color2.Blue;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_color_burn:=res;
end;
function graph_color_color_dodge(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=color1.Red+color1.Red*color2.Red div (255-color2.Red);
 res.Green:=color1.Green+color1.Green*color2.Green div (255-color2.Green);
 res.Blue:=color1.Blue+color1.Blue*color2.Blue div (255-color2.Blue);
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_color_dodge:=res;
end;
function graph_color_linear_burn(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=color1.Red+color2.Red-255;
 res.Green:=color1.Green+color2.Green-255;
 res.Blue:=color1.Blue+color2.Blue-255;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_linear_burn:=res;
end;
function graph_color_linear_dodge(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=color1.Red+color2.Red;
 res.Green:=color1.Green+color2.Green;
 res.Blue:=color1.Blue+color2.Blue;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_linear_dodge:=res;
end;
function graph_color_overlay(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 if(color1.Red<=128) then res.Red:=color1.Red*color2.Red div 128
 else color1.Red:=255-(255-color1.Red)*(255-color2.Red) div 128;
 if(color1.Green<=128) then res.Green:=color1.Green*color2.Green div 128
 else res.Green:=255-(255-color1.Green)*(255-color2.Green) div 128;
 if(color1.Blue<=128) then res.Blue:=color1.Blue*color2.Blue div 128
 else res.Blue:=255-(255-color1.Blue)*(255-color2.Blue) div 128;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_overlay:=res;
end;
function graph_color_highlight(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 if(color2.Red<=128) then res.Red:=color1.Red*color2.Red div 128
 else color1.Red:=255-(255-color1.Red)*(255-color2.Red) div 128;
 if(color2.Green<=128) then res.Green:=color1.Green*color2.Green div 128
 else res.Green:=255-(255-color1.Green)*(255-color2.Green) div 128;
 if(color2.Blue<=128) then res.Blue:=color1.Blue*color2.Blue div 128
 else res.Blue:=255-(255-color1.Blue)*(255-color2.Blue) div 128;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_highlight:=res;
end;
function graph_color_diffuse(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 if(color2.Red<=128) then
 res.Red:=color1.Red*color2.Red div 128+color1.Red*color1.Red*(255-color2.Red*2) div (255*255)
 else
 res.Red:=color1.Red*(255-color2.Red) div 128+sqrt(color1.Red)*(color2.Red*2-255) div sqrt(255);
 if(color2.Green<=128) then
 res.Green:=color1.Green*color2.Green div 128+color1.Green*color1.Green*(255-color2.Green*2) div (255*255)
 else
 res.Green:=color1.Green*(255-color2.Green) div 128+sqrt(color1.Red)*(color2.Green*2-255) div sqrt(255);
 if(color2.Blue<=128) then
 res.Blue:=color1.Blue*color2.Blue div 128+color1.Blue*color1.Blue*(255-color2.Blue*2) div (255*255)
 else
 res.Blue:=color1.Blue*(255-color2.Blue) div 128+sqrt(color1.Red)*(color2.Blue*2-255) div sqrt(255);
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_diffuse:=res;
end;
function graph_color_light(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 if(color2.Red<=128) then
 res.Red:=color1.Red-(255-color1.Red)*(255-2*color2.Red) div (2*color2.Red)
 else
 res.Red:=color1.Red+color1.Red*(2*color2.Red-255) div (2*(255-color2.Red));
 if(color2.Green<=128) then
 res.Green:=color1.Green-(255-color1.Green)*(255-2*color2.Green) div (2*color2.Green)
 else
 res.Green:=color1.Green+color1.Green*(2*color2.Green-255) div (2*(255-color2.Green));
 if(color2.Blue<=128) then
 res.Blue:=color1.Blue-(255-color1.Blue)*(255-2*color2.Blue) div (2*color2.Blue)
 else
 res.Blue:=color1.Blue+color1.Blue*(2*color2.Blue-255) div (2*(255-color2.Blue));
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_light:=res;
end;
function graph_color_point_light(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 if(color2.Red<=128) then
 res.Red:=graph_min(color1.Red,color2.Red*2)
 else
 res.Red:=graph_max(color1.Red,color2.Red*2-255);
 if(color2.Green<=128) then
 res.Red:=graph_min(color1.Red,color2.Red*2)
 else
 res.Red:=graph_max(color1.Red,color2.Red*2-255);
 if(color2.Blue<=128) then
 res.Blue:=graph_min(color1.Blue,color2.Blue*2)
 else
 res.Blue:=graph_max(color1.Blue,color2.Blue*2-255);
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_point_light:=res;
end;
function graph_color_linear_light(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=color1.Red+color2.Red*2-255;
 res.Green:=color1.Green+color2.Green*2-255;
 res.Blue:=color1.Blue+color2.Blue*2-255;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_linear_light:=res;
end;
function graph_color_solid_color_mix(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 if(color1.Red+color2.Red>=255) then res.Red:=255 else res.Red:=0;
 if(color1.Green+color2.Green>=255) then res.Green:=255 else res.Green:=0;
 if(color1.Blue+color2.Blue>=255) then res.Blue:=255 else res.Blue:=0;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_solid_color_mix:=res;
end;
function graph_color_except(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 res.Red:=color1.Red+color2.Red-(color1.Red*color2.Red) div 128;
 res.Green:=color1.Green+color2.Green-(color1.Green*color2.Green) div 128;
 res.Blue:=color1.Blue+color2.Blue-(color1.Blue*color2.Blue) div 128;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_except:=res;
end;
function graph_color_delta(color1,color2:graph_color):graph_color;
var res:graph_color;
begin
 if(color1.Red>color2.Red) then
 res.Red:=color1.Red-color2.Red else res.Red:=color2.Red-color1.Red;
 if(color1.Green>color2.Green) then
 res.Green:=color1.Green-color2.Green else res.Green:=color2.Green-color1.Green;
 if(color1.Blue>color2.Blue) then
 res.Blue:=color1.Blue-color2.Blue else res.Blue:=color2.Blue-color1.Blue;
 res.Alpha:=graph_color_alpha_mix(color1.Alpha,color2.Alpha);
 graph_color_delta:=res;
end;
function graph_generate_line_segment(Point1,Point2:graph_point):graph_line_segment;
var res:graph_line_segment;
begin
 if(Point1.XPosition=Point2.XPosition) then
  begin
   res.Slope:=0; res.Intercept:=0;
   res.StartX:=Point1.XPosition; res.EndX:=Point2.XPosition;
   res.IsVertical:=true;
  end
 else
  begin
   res.Slope:=(Point1.YPosition-Point2.YPosition)/(Point1.XPosition-Point2.XPosition);
   res.Intercept:=Point1.YPosition-res.Slope*Point1.XPosition;
   if(Point1.XPosition>Point2.XPosition) then
    begin
     res.StartX:=Point2.XPosition; res.EndX:=Point1.XPosition;
    end
   else
    begin
     res.StartX:=Point1.XPosition; res.EndX:=Point2.XPosition;
    end;
   res.IsVertical:=false;
  end;
 graph_generate_line_segment:=res;
end;
function graph_generate_line_segment(Point1X,Point1Y,Point2X,Point2Y:extended):graph_line_segment;
var res:graph_line_segment;
begin
 if(Point1X=Point2X) then
  begin
   res.Slope:=0; res.Intercept:=0;
   res.StartX:=Point1X; res.EndX:=Point2X;
   res.IsVertical:=true;
  end
 else
  begin
   res.Slope:=(Point1Y-Point2Y)/(Point1X-Point2X);
   res.Intercept:=Point1Y-res.Slope*Point1X;
   if(Point1X>Point2X) then
    begin
     res.StartX:=Point2X; res.EndX:=Point1X;
    end
   else
    begin
     res.StartX:=Point1X; res.EndX:=Point2X;
    end;
   res.IsVertical:=false;
  end;
 graph_generate_line_segment:=res;
end;
procedure graph_heap_initialize(StartAddress:Pointer;EndAddress:Pointer;BlockPower:byte;
ScreenWidth,ScreenHeight:dword;OutputAddress:Pointer;ScreenRedGreenBlue:boolean);
var restsize,restitemcount:Natuint;
begin
 restsize:=Natuint(EndAddress-StartAddress+1);
 {Initialize the drawing screen}
 graphheap.ScreenInitAddress:=EndAddress+1-ScreenWidth*ScreenHeight*sizeof(graph_color);
 graphheap.ScreenWidth:=ScreenWidth; graphheap.ScreenHeight:=ScreenHeight;
 graphheap.ScreenOutputAddress:=OutputAddress;
 graphheap.ScreenAttribute:=not ScreenRedGreenBlue;
 {Initialize the graphics heap Memory}
 graphheap.MaxItemIndex:=0;
 dec(restsize,ScreenWidth*ScreenHeight*sizeof(graph_color));
 restitemcount:=restsize div (sizeof(graph_item)+sizeof(graph_attribute)+
 sizeof(graph_color) shl BlockPower);
 {Initialize the graphics heap Attribute Section}
 graphheap.AttributeMaxCount:=restitemcount; graphheap.AttributeMaxIndex:=0;
 {Initialize the graphics heap allocate Section}
 graphheap.HeapStartAddress:=startaddress;
 graphheap.HeapEndAddress:=Pointer(startaddress)+restitemcount*(sizeof(graph_item)+sizeof(graph_color)
 shl BlockPower)-sizeof(graph_color);
 graphheap.AttributeAddress:=Pointer(graphheap.HeapEndAddress)+sizeof(graph_color);
 graphheap.AvailableIndex:=1; graphheap.AvailablePosition:=1;
 graphheap.RestSize:=Natuint(Pointer(graphheap.HeapEndAddress)-Pointer(graphheap.HeapStartAddress)+
 sizeof(graph_color));
 graphheap.MaxIndex:=0; graphheap.BlockPower:=BlockPower;
end;
function graph_heap_confirm_angle_from_sin_and_cos(sinvalue:extended;cosvalue:extended):extended;
begin
 if(sinvalue>0) and (cosvalue>0) then
  begin
   graph_heap_confirm_angle_from_sin_and_cos:=arcsin(sinvalue)*180/pi;
  end
 else if(sinvalue>0) and (cosvalue<=0) then
  begin
   graph_heap_confirm_angle_from_sin_and_cos:=(180-arcsin(sinvalue))*180/pi;
  end
 else if(sinvalue<=0) and (cosvalue<=0) then
  begin
   graph_heap_confirm_angle_from_sin_and_cos:=(90+arccos(cosvalue))*180/pi;
  end
 else if(sinvalue<=0) and (cosvalue>0) then
  begin
   graph_heap_confirm_angle_from_sin_and_cos:=(360-arccos(cosvalue))*180/pi;
  end;
end;
function graph_heap_address_to_item(Address:Pgraph_color):Dword;
begin
 graph_heap_address_to_item:=
 (Natuint(graphheap.HeapEndAddress-Address)*sizeof(graph_color)+
 sizeof(graph_color) shl graphheap.BlockPower-1) shr (graphheap.BlockPower+2);
end;
function graph_heap_item_to_address(ItemIndex:dword):Pgraph_color;
begin
 graph_heap_item_to_address:=graphheap.HeapEndAddress+1-(Natuint(ItemIndex) shl graphheap.BlockPower);
end;
procedure graph_heap_clear_memory(ItemIndex:dword);
var i:Natuint;
    Address:Pgraph_color;
begin
 Address:=graphheap.HeapEndAddress+1-ItemIndex shl graphheap.BlockPower;
 for i:=1 to 1 shl graphheap.BlockPower do Pgraph_color(Address+i-1)^:=graph_color_zero;
end;
function graph_heap_request_memory_size(index:Dword):Natuint;
var StartIndex,tempindex,tempsize:Natuint;
begin
 StartIndex:=Pgraph_attribute(graphheap.AttributeAddress+index-1)^.StartItemIndex;
 TempIndex:=StartIndex; tempsize:=0;
 while(True)do
  begin
   inc(tempsize,1 shl graphheap.BlockPower);
   if(Pgraph_item(graphheap.HeapStartAddress+TempIndex-1)^.Allocated=0)
   or(Pgraph_item(graphheap.HeapStartAddress+TempIndex-1)^.RightIndex=0) then break;
   TempIndex:=Pgraph_item(graphheap.HeapStartAddress+TempIndex-1)^.RightIndex;
  end;
 graph_heap_request_memory_size:=tempsize;
end;
function graph_heap_request_memory(
xposition,yposition:Integer;Width,Height:Dword;InitialVisible:boolean;MemoryInitialize:boolean):Dword;
var i,j,k:Dword;
    NeedBlock:Dword;
    StartIndex,Index:Dword;
begin
 NeedBlock:=(Width*Height+1 shl graphheap.BlockPower-1) shr graphheap.BlockPower;
 if(NeedBlock=0) or (NeedBlock*sizeof(graph_color) shl graphheap.BlockPower
 +NeedBlock*sizeof(graph_item)>graphheap.restsize) then exit(0);
 Dec(graphheap.RestSize,NeedBlock*sizeof(graph_color) shl graphheap.BlockPower
 +NeedBlock*sizeof(graph_item));
 StartIndex:=0; inc(graphheap.MaxIndex);
 if(graphheap.MaxItemIndex=0) then
  begin
   for i:=1 to NeedBlock do
    begin
     Pgraph_item(graphheap.HeapStartAddress+i-1)^.Allocated:=1;
     if(i<NeedBlock) then Pgraph_item(graphheap.HeapStartAddress+i-1)^.RightIndex:=i+1
     else Pgraph_item(graphheap.HeapStartAddress+i-1)^.RightIndex:=0;
     if(MemoryInitialize) then graph_heap_clear_memory(i);
    end;
   inc(graphheap.MaxItemIndex,NeedBlock);
   inc(graphheap.AvailableIndex,1);
   inc(graphheap.AvailablePosition,NeedBlock);
   inc(graphheap.AttributeMaxIndex,1);
   graphheap.AttributeAddress^.Index:=graphheap.MaxIndex;
   graphheap.AttributeAddress^.xposition:=xposition;
   graphheap.AttributeAddress^.yposition:=yposition;
   graphheap.AttributeAddress^.CanvaWidth:=Width;
   graphheap.AttributeAddress^.CanvaHeight:=Height;
   graphheap.AttributeAddress^.StartItemIndex:=1;
   graphheap.AttributeAddress^.Visible:=InitialVisible;
   graph_heap_request_memory:=1;
  end
 else
  begin
   i:=1; j:=1; k:=1;
   while(i<=graphheap.MaxItemIndex)do
    begin
     if(Pgraph_item(graphheap.HeapStartAddress+i-1)^.Allocated=0) then
      begin
       if(MemoryInitialize) then graph_heap_clear_memory(i);
       if(StartIndex=0) then StartIndex:=i;
       Pgraph_item(graphheap.HeapStartAddress+i-1)^.Allocated:=1;
       if(j<NeedBlock) then
        begin
         k:=i+1;
         while(k<=graphheap.AttributeMaxCount) and
         (Pgraph_item(graphheap.HeapStartAddress+k-1)^.Allocated=1)do inc(k);
         if(k>graphheap.AttributeMaxCount) then exit(0);
         Pgraph_item(graphheap.HeapStartAddress+i-1)^.RightIndex:=k;
         inc(j);
         i:=k; continue;
        end
       else
        begin
         Pgraph_item(graphheap.HeapStartAddress+i-1)^.RightIndex:=0; break;
        end;
      end;
     inc(i);
    end;
   dec(NeedBlock,j);
   if(i<=graphheap.MaxItemIndex) then
    begin
     Pgraph_attribute(graphheap.AttributeAddress+graphheap.AvailableIndex-1)^.xposition:=xposition;
     Pgraph_attribute(graphheap.AttributeAddress+graphheap.AvailableIndex-1)^.yposition:=yposition;
     Pgraph_attribute(graphheap.AttributeAddress+graphheap.AvailableIndex-1)^.CanvaWidth:=Width;
     Pgraph_attribute(graphheap.AttributeAddress+graphheap.AvailableIndex-1)^.CanvaHeight:=Height;
     Pgraph_attribute(graphheap.AttributeAddress+graphheap.AvailableIndex-1)^.Index:=graphheap.MaxIndex;
     Pgraph_attribute(graphheap.AttributeAddress+graphheap.AvailableIndex-1)^.StartItemIndex:=startindex;
     Pgraph_attribute(graphheap.AttributeAddress+graphheap.AvailableIndex-1)^.Visible:=InitialVisible;
     graph_heap_request_memory:=graphheap.AvailableIndex;
     while(i<=graphheap.MaxItemIndex)do
      begin
       if(Pgraph_item(graphheap.HeapStartAddress+i-1)^.Allocated=0) then
        begin
         graphheap.AvailablePosition:=i; break;
        end;
       inc(i);
      end;
     if(i>graphheap.MaxItemIndex) then graphheap.AvailablePosition:=i;
     i:=graphheap.AvailableIndex+1;
     while(i<=graphheap.AttributeMaxIndex)do
      begin
       if(Pgraph_attribute(graphheap.AttributeAddress+i-1)^.Index=0) then
        begin
         graphheap.AvailableIndex:=i; break;
        end;
       inc(i);
      end;
     if(i>graphheap.AttributeMaxIndex) then graphheap.AvailableIndex:=i;
    end
   else
    begin
     if(StartIndex=0) then StartIndex:=graphheap.MaxItemIndex+1;
     for i:=graphheap.MaxItemIndex+1 to graphheap.MaxItemIndex+NeedBlock do
      begin
       Pgraph_item(graphheap.HeapStartAddress+i-1)^.Allocated:=1;
       if(i<graphheap.MaxItemIndex+NeedBlock) then
       Pgraph_item(graphheap.HeapStartAddress+i-1)^.RightIndex:=i+1
       else Pgraph_item(graphheap.HeapStartAddress+i-1)^.RightIndex:=0;
       if(MemoryInitialize) then graph_heap_clear_memory(i);
      end;
     Index:=1;
     while(Index<=graphheap.AttributeMaxIndex)do
      begin
       if(Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.Index=0) then
        begin
         Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.Index:=graphheap.MaxIndex; break;
        end;
       inc(index);
      end;
     if(index>graphheap.AttributeMaxIndex) then
      begin
       inc(graphheap.AttributeMaxIndex);
       Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.Index:=graphheap.MaxIndex;
      end;
     i:=1;
     while(i<=graphheap.AttributeMaxIndex)do
      begin
       if(Pgraph_attribute(graphheap.AttributeAddress+i-1)^.Index=0) then
        begin
         graphheap.AvailableIndex:=i; break;
        end;
       inc(i);
      end;
     if(i>graphheap.AttributeMaxIndex) then graphheap.AvailableIndex:=i;
     (graphheap.AttributeAddress+Index-1)^.Index:=graphheap.MaxIndex;
     (graphheap.AttributeAddress+Index-1)^.xposition:=xposition;
     (graphheap.AttributeAddress+Index-1)^.yposition:=yposition;
     (graphheap.AttributeAddress+Index-1)^.CanvaWidth:=Width;
     (graphheap.AttributeAddress+Index-1)^.CanvaHeight:=Height;
     (graphheap.AttributeAddress+Index-1)^.StartItemIndex:=StartIndex;
     (graphheap.AttributeAddress+Index-1)^.Visible:=InitialVisible;
     graphheap.MaxItemIndex:=graphheap.MaxItemIndex+NeedBlock;
     graphheap.AvailablePosition:=graphheap.MaxItemIndex+1;
     graph_heap_request_memory:=Index;
    end;
  end;
end;
procedure graph_heap_move_memory(SourceIndex,DestIndex:Dword;Size:Natuint);
var tempsize,i:Natuint;
    tempindex1,tempindex2:Dword;
    Address1,Address2:Pgraph_color;
begin
 if(SourceIndex=0) or (DestIndex=0) then exit;
 tempsize:=size;
 if(Pgraph_attribute(graphheap.AttributeAddress+SourceIndex-1)^.Index=0) then exit;
 tempindex1:=Pgraph_attribute(graphheap.AttributeAddress+SourceIndex-1)^.StartItemIndex;
 if(Pgraph_attribute(graphheap.AttributeAddress+DestIndex-1)^.Index=0) then exit;
 tempindex2:=Pgraph_attribute(graphheap.AttributeAddress+DestIndex-1)^.StartItemIndex;
 while(True)do
  begin
   Address1:=graph_heap_item_to_address(tempindex1);
   Address2:=graph_heap_item_to_address(tempindex2);
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex1-1)^.Allocated=0)
   or(Pgraph_item(graphheap.HeapStartAddress+tempindex2-1)^.Allocated=0) then break;
   if(tempsize>1 shl graphheap.BlockPower)then
    begin
     for i:=1 to 1 shl graphheap.BlockPower do (Address2+i-1)^:=(Address1+i-1)^;
     dec(tempsize,1 shl graphheap.BlockPower);
    end
   else
    begin
     for i:=1 to tempsize do (Address2+i-1)^:=(Address1+i-1)^;
     tempsize:=0; break;
    end;
   tempindex1:=Pgraph_item(graphheap.HeapStartAddress+tempindex1-1)^.RightIndex;
   tempindex2:=Pgraph_item(graphheap.HeapStartAddress+tempindex2-1)^.RightIndex;
  end;
end;
procedure graph_heap_free_memory(var Index:Dword;ForceZero:boolean);
var tempindex1,tempindex2,tempstartindex,tempendindex:Dword;
    MaxIndexNow:Natuint;
    i:Dword;
begin
 if(Index=0) then exit;
 if(Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.Index=0) then exit;
 tempindex1:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 tempstartindex:=tempindex1; tempendindex:=0;
 if((graphheap.AttributeAddress+Index-1)^.Index<>0) then
 (graphheap.AttributeAddress+Index-1)^.Index:=0 else exit;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex1-1)^.Allocated=0) then break;
   inc(graphheap.restsize,sizeof(graph_color) shl graphheap.BlockPower+sizeof(graph_item));
   Pgraph_item(graphheap.HeapStartAddress+tempindex1-1)^.Allocated:=0;
   tempindex2:=tempindex1;
   if(tempendindex=0) then tempendindex:=tempindex1;
   tempindex1:=Pgraph_item(graphheap.HeapStartAddress+tempindex2-1)^.RightIndex;
   Pgraph_item(graphheap.HeapStartAddress+tempindex2-1)^.RightIndex:=0;
   if(tempindex1=0) then break;
  end;
 i:=graphheap.AttributeMaxIndex; MaxIndexNow:=0;
 while(i>0) do
  begin
   if(Pgraph_attribute(graphheap.AttributeAddress+i-1)^.Index>MaxIndexNow) then
   MaxIndexNow:=Pgraph_attribute(graphheap.AttributeAddress+i-1)^.Index;
   dec(i);
  end;
 graphheap.MaxIndex:=MaxIndexNow;
 i:=tempstartindex-1;
 while(i>0)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+i-1)^.Allocated=0) then break;
   dec(i);
  end;
 if(i=0) then
  begin
   graphheap.AvailablePosition:=tempstartindex; graphheap.MaxItemIndex:=tempstartindex-1;
  end
 else
  begin
   graphheap.AvailableIndex:=i;
   if(tempendindex=graphheap.MaxItemIndex) then graphheap.MaxItemIndex:=i;
  end;
 graphheap.AvailableIndex:=Index;
 Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.Index:=0;
 Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex:=0;
 if(ForceZero) then index:=0;
end;
procedure graph_heap_change_position(Index:Dword;newxposition,newyposition:Integer);
begin
 if((graphheap.AttributeAddress+Index-1)^.Index<>0) then
  begin
   (graphheap.AttributeAddress+Index-1)^.xposition:=newxposition;
   (graphheap.AttributeAddress+Index-1)^.yposition:=newyposition;
  end;
end;
procedure graph_heap_change_visiblility(Index:Dword;NewVisibleStatus:boolean);
begin
 if((graphheap.AttributeAddress+Index-1)^.Index<>0) then
  begin
   (graphheap.AttributeAddress+Index-1)^.Visible:=NewVisibleStatus;
  end;
end;
function graph_heap_getmem(xposition,yposition:Integer;
Width,Height:Dword;Visible:boolean):Dword;
begin
 graph_heap_getmem:=graph_heap_request_memory(xposition,yposition,width,height,visible,false);
end;
function graph_heap_getmemsize(index:Dword):Natuint;
begin
 graph_heap_getmemsize:=graph_heap_request_memory_size(index);
end;
function graph_heap_allocmem(xposition,yposition:Integer;
Width,Height:Dword;Visible:boolean):Dword;
begin
 graph_heap_allocmem:=graph_heap_request_memory(xposition,yposition,width,height,visible,true);
end;
procedure graph_heap_freemem(var index:Dword);
begin
 graph_heap_free_memory(index,true);
end;
procedure graph_heap_reallocmem(var index:Dword;xposition,yposition:Integer;
Width,Height:Dword;Visible:boolean);
var NewIndex:Dword;
    OldSize,NewSize,MinSize:Natuint;
begin
 NewIndex:=graph_heap_request_memory(xposition,yposition,width,height,visible,true);
 OldSize:=graph_heap_request_memory_size(Index);
 NewSize:=graph_heap_request_memory_size(NewIndex);
 if(OldSize>NewSize) then MinSize:=NewSize else MinSize:=OldSize;
 graph_heap_move_memory(Index,NewIndex,MinSize);
 graph_heap_free_memory(Index,true);
 Index:=NewIndex;
end;
procedure graph_heap_set_attribute(Index:Dword;newxposition,newyposition:Integer;NewVisibleStatus:boolean);
begin
 graph_heap_change_position(Index,newxposition,newyposition);
 graph_heap_change_visiblility(Index,NewVisibleStatus);
end;
procedure graph_heap_draw_point(Index:Dword;RelativeX,RelativeY:Integer;Color:graph_color);
var RelatedWidth,RelatedHeight:Dword;
    CurrentPosition:Natuint;
    tempindex:dword;
    Address:Pgraph_color;
begin
 if(RelativeX<=0) or (RelativeY<=0) then exit;
 RelatedWidth:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaWidth;
 RelatedHeight:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaHeight;
 if(RelativeX>RelatedWidth) or (RelativeY>RelatedHeight) then exit;
 CurrentPosition:=(RelativeY-1)*RelatedWidth+RelativeX-1;
 tempindex:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.Allocated=0) then break;
   if(CurrentPosition>=1 shl graphheap.BlockPower) then
    begin
     dec(CurrentPosition,1 shl graphheap.BlockPower);
    end
   else
    begin
     Address:=graph_heap_item_to_address(tempindex);
     Pgraph_color(Address+CurrentPosition)^:=Color; break;
    end;
   tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
   if(tempindex=0) then break;
  end;
end;
procedure graph_heap_clear(Index:Dword);
var tempindex:dword;
    Address:Pgraph_color;
    i:Natuint;
begin
 tempindex:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.Allocated=0) then break;
   Address:=graph_heap_item_to_address(tempindex);
   for i:=1 to 1 shl graphheap.BlockPower do Pgraph_color(Address+i-1)^:=graph_color_zero;
   tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
   if(tempindex=0) then break;
  end;
end;
procedure graph_heap_fill_with_color(Index:Dword;Color:graph_color);
var tempindex:dword;
    Address:Pgraph_color;
    i:Natuint;
begin
 tempindex:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.Allocated=0) then break;
   Address:=graph_heap_item_to_address(tempindex);
   for i:=1 to 1 shl graphheap.BlockPower do Pgraph_color(Address+i-1)^:=Color;
   tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
   if(tempindex=0) then break;
  end;
end;
procedure graph_heap_draw_block(Index:Dword;RelativeX,Relativey:Integer;Width,Height:Dword;
Color:graph_color);
var RelatedWidth,RelatedHeight:Dword;
    StartX,StartY,EndX,EndY:dword;
    CurrentXPos,CurrentYPos:Dword;
    CurrentPosition:Natuint;
    BlockIndex:Natuint;
    tempindex:dword;
    Address:Pgraph_color;
begin
 if(RelativeX+Width<=0) or (RelativeY+Height<=0) then exit;
 RelatedWidth:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaWidth;
 RelatedHeight:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaHeight;
 if(RelativeX>RelatedWidth) or (RelativeY>RelatedHeight) then exit;
 if(RelativeX<=0) then StartX:=1 else StartX:=RelativeX;
 if(RelativeY<=0) then StartY:=1 else StartY:=RelativeY;
 if(RelativeX+Width-1>RelatedWidth) then EndX:=RelatedWidth else EndX:=RelativeX+Width-1;
 if(RelativeY+Height-1>RelatedHeight) then EndY:=RelatedHeight else EndY:=RelativeY+Height-1;
 CurrentXPos:=StartX; CurrentYPos:=StartY; BlockIndex:=0; CurrentPosition:=0;
 tempindex:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.Allocated=0) then break;
   inc(BlockIndex);
   Address:=graph_heap_item_to_address(tempindex);
   while(CurrentPosition<BlockIndex shl graphheap.BlockPower)do
    begin
     CurrentPosition:=(CurrentYPos-1)*RelatedWidth+(CurrentXPos-1);
     Pgraph_color(Address+CurrentPosition-(BlockIndex-1) shl graphheap.BlockPower)^:=Color;
     if(CurrentXPos<EndX) then inc(CurrentXPos)
     else if(CurrentYPos<EndY) then
      begin
       inc(CurrentYPos); CurrentXPos:=StartX;
      end
     else exit;
    end;
   tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
   if(tempindex=0) then break;
  end;
end;
procedure graph_heap_draw_circle(Index:Dword;RelativeX,Relativey:Integer;Radius:dword;Color:graph_color);
var RelatedWidth,RelatedHeight:Dword;
    StartX,StartY,EndX,EndY:dword;
    CurrentXPos,CurrentYPos:Dword;
    CurrentPosition:Natuint;
    BlockIndex:Natuint;
    tempindex:dword;
    Address:Pgraph_color;
begin
 if(RelativeX+Radius-1<=0) or (RelativeY+Radius-1<=0) then exit;
 RelatedWidth:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaWidth;
 RelatedHeight:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaHeight;
 if(RelativeX-Radius+1>RelatedWidth) or (RelativeY-Radius+1>RelatedHeight) then exit;
 if(RelativeX-Radius+1<=0) then StartX:=1 else StartX:=RelativeX-Radius+1;
 if(RelativeY-Radius+1<=0) then StartY:=1 else StartY:=RelativeY-Radius+1;
 if(RelativeX+Radius-1>RelatedWidth) then EndX:=RelatedWidth else EndX:=RelativeX+Radius-1;
 if(RelativeY+Radius-1>RelatedHeight) then EndY:=RelatedHeight else EndY:=RelativeY+Radius-1;
 CurrentXPos:=StartX; CurrentYPos:=StartY; BlockIndex:=0; CurrentPosition:=0;
 tempindex:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.Allocated=0) then break;
   inc(BlockIndex);
   Address:=graph_heap_item_to_address(tempindex);
   while(CurrentPosition<BlockIndex shl graphheap.BlockPower)do
    begin
     CurrentPosition:=(CurrentYPos-1)*RelatedWidth+(CurrentXPos-1);
     if(sqr(CurrentXPos-RelativeX)+sqr(CurrentYPos-RelativeY)<=sqr(Radius)) then
     Pgraph_color(Address+CurrentPosition-(BlockIndex-1) shl graphheap.BlockPower)^:=Color;
     if(CurrentXPos<EndX) then inc(CurrentXPos)
     else if(CurrentYPos<EndY) then
      begin
       inc(CurrentYPos); CurrentXPos:=StartX;
      end
     else exit;
    end;
   tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
   if(tempindex=0) then break;
  end;
end;
procedure graph_heap_draw_fanshape(Index:Dword;RelativeX,Relativey:Integer;Radius:dword;
StartAngle,EndAngle:extended;Color:graph_color);
var RelatedWidth,RelatedHeight:Dword;
    StartX,StartY,EndX,EndY:dword;
    CurrentXPos,CurrentYPos:Dword;
    CurrentPosition:Natuint;
    tempnum1,tempnum2,tempnum3,tempnum4,tempnum5,tempnum6:extended;
    BlockIndex:Natuint;
    tempindex:dword;
    Address:Pgraph_color;
begin
 if(RelativeX+Radius-1<=0) or (RelativeY+Radius-1<=0) then exit;
 RelatedWidth:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaWidth;
 RelatedHeight:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaHeight;
 if(RelativeX-Radius+1>RelatedWidth) or (RelativeY-Radius+1>RelatedHeight) then exit;
 if(RelativeX-Radius+1<=0) then StartX:=1 else StartX:=RelativeX-Radius+1;
 if(RelativeY-Radius+1<=0) then StartY:=1 else StartY:=RelativeY-Radius+1;
 if(RelativeX+Radius-1>RelatedWidth) then EndX:=RelatedWidth else EndX:=RelativeX+Radius-1;
 if(RelativeY+Radius-1>RelatedHeight) then EndY:=RelatedHeight else EndY:=RelativeY+Radius-1;
 CurrentXPos:=StartX; CurrentYPos:=StartY; BlockIndex:=0; CurrentPosition:=0;
 tempindex:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.Allocated=0) then break;
   inc(BlockIndex);
   Address:=graph_heap_item_to_address(tempindex);
   while(CurrentPosition<BlockIndex shl graphheap.BlockPower)do
    begin
     CurrentPosition:=(CurrentYPos-1)*RelatedWidth+(CurrentXPos-1);
     tempnum1:=StartX+CurrentXPos-RelativeX;
     tempnum2:=StartY+CurrentYPos-RelativeY;
     tempnum3:=sqrt(sqr(tempnum1)+sqr(tempnum2));
     tempnum4:=tempnum2/tempnum3;
     tempnum5:=tempnum1/tempnum3;
     tempnum6:=graph_heap_confirm_angle_from_sin_and_cos(tempnum4,tempnum5);
     if(tempnum6>=StartAngle) and (tempnum6<=EndAngle) then
     Pgraph_color(Address+CurrentPosition-(BlockIndex-1) shl graphheap.BlockPower)^:=Color;
     if(CurrentXPos<EndX) then inc(CurrentXPos)
     else if(CurrentYPos<EndY) then
      begin
       inc(CurrentYPos); CurrentXPos:=StartX;
      end
     else exit;
    end;
   tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
   if(tempindex=0) then break;
  end;
end;
procedure graph_heap_draw_eclipse(Index:Dword;RelativeX,Relativey:Integer;Width,Height:Dword;
Color:graph_color);
var RelatedWidth,RelatedHeight:Dword;
    StartX,StartY,EndX,EndY:dword;
    CurrentXPos,CurrentYPos:Dword;
    CentralX,CentralY:Dword;
    CurrentPosition:Natuint;
    BlockIndex:Natuint;
    tempindex:dword;
    Address:Pgraph_color;
begin
 if(RelativeX+Width<=0) or (RelativeY+Height<=0) then exit;
 RelatedWidth:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaWidth;
 RelatedHeight:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaHeight;
 if(RelativeX>RelatedWidth) or (RelativeY>RelatedHeight) then exit;
 CentralX:=RelativeX+Width div 2; CentralY:=RelativeY+Height div 2;
 if(RelativeX<=0) then StartX:=1 else StartX:=RelativeX;
 if(RelativeY<=0) then StartY:=1 else StartY:=RelativeY;
 if(RelativeX+Width-1>RelatedWidth) then EndX:=RelatedWidth else EndX:=RelativeX+Width-1;
 if(RelativeY+Height-1>RelatedHeight) then EndY:=RelatedHeight else EndY:=RelativeY+Height-1;
 CurrentXPos:=StartX; CurrentYPos:=StartY; BlockIndex:=0; CurrentPosition:=0;
 tempindex:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.Allocated=0) then break;
   inc(BlockIndex);
   Address:=graph_heap_item_to_address(tempindex);
   while(CurrentPosition<BlockIndex shl graphheap.BlockPower)do
    begin
     CurrentPosition:=(CurrentYPos-1)*RelatedWidth+(CurrentXPos-1);
     if(Sqr(CurrentXPos-CentralX)/Sqr(Width)+Sqr(CurrentYPos-CentralY)/Sqr(Height)<=1) then
     Pgraph_color(Address+CurrentPosition-(BlockIndex-1) shl graphheap.BlockPower)^:=Color;
     if(CurrentXPos<EndX) then inc(CurrentXPos)
     else if(CurrentYPos<EndY) then
      begin
       inc(CurrentYPos); CurrentXPos:=StartX;
      end
     else exit;
    end;
   tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
   if(tempindex=0) then break;
  end;
end;
procedure graph_heap_draw_polygon(Index:Dword;Point:array of graph_point;Color:graph_color);
var func:array of graph_line_segment;
    MinX,MaxX,MinY,MaxY:extended;
    i:Dword;
    j,k:Extended;
    Count:Dword;
    bool:boolean;
begin
 SetLength(func,length(Point)-1);
 for i:=1 to length(Point)-1 do
 func[i-1]:=graph_generate_line_segment(Point[i-1],Point[i]);
 MinX:=0; MaxX:=0; MinY:=0; MaxY:=0;
 for i:=1 to length(Point) do
  begin
   if(MinX>Point[i-1].XPosition) or (MinX=0) then MinX:=Point[i-1].XPosition;
   if(MaxX<Point[i-1].XPosition) or (MaxX=0) then MaxX:=Point[i-1].XPosition;
   if(MinY>Point[i-1].YPosition) or (MinY=0) then MinY:=Point[i-1].YPosition;
   if(MaxY<Point[i-1].YPosition) or (MaxY=0) then MaxY:=Point[i-1].YPosition;
  end;
 j:=1;
 while(j<=MaxX)do
  begin
   k:=MinY;
   while(k<=MaxY)do
    begin
     count:=0;
     for i:=1 to length(func) do
      begin
       if(func[i-1].StartX<=j) and (func[i-1].EndX>=j) and
       (func[i-1].Slope*j+func[i-1].Intercept>k) then
        begin
         inc(count);
        end;
      end;
     if(count mod 2=1) then graph_heap_draw_point(Index,Round(j),Round(k),color);
     k:=k+1;
    end;
   j:=j+1;
  end;
end;
procedure graph_heap_draw_polygon(Index:Dword;Point:graph_point_array;Color:graph_color);
var func:array of graph_line_segment;
    MinX,MaxX,MinY,MaxY:extended;
    i:Dword;
    j,k:Extended;
    Count:Dword;
    bool:boolean;
begin
 SetLength(func,length(Point)-1);
 for i:=1 to length(Point)-1 do
 func[i-1]:=graph_generate_line_segment(Point[i-1],Point[i]);
 MinX:=0; MaxX:=0; MinY:=0; MaxY:=0;
 for i:=1 to length(Point) do
  begin
   if(MinX>Point[i-1].XPosition) or (MinX=0) then MinX:=Point[i-1].XPosition;
   if(MaxX<Point[i-1].XPosition) or (MaxX=0) then MaxX:=Point[i-1].XPosition;
   if(MinY>Point[i-1].YPosition) or (MinY=0) then MinY:=Point[i-1].YPosition;
   if(MaxY<Point[i-1].YPosition) or (MaxY=0) then MaxY:=Point[i-1].YPosition;
  end;
 j:=MinX;
 while(j<=MaxX)do
  begin
   k:=MinY;
   while(k<=MaxY)do
    begin
     count:=0;
     for i:=1 to length(func) do
      begin
       if(func[i-1].StartX<=j) and (func[i-1].EndX>=j) and
       (func[i-1].Slope*j+func[i-1].Intercept>k) then
        begin
         inc(count);
        end;
      end;
     if(count mod 2=1) then graph_heap_draw_point(Index,Round(j),Round(k),color);
     k:=k+1;
    end;
   j:=j+1;
  end;
end;
procedure graph_heap_draw_line(Index:Dword;Point:array of graph_point;Thickness:Dword;
Color:graph_color);
var step,base:extended;
    StartX,StartY,EndX,EndY:extended;
    temppoint:graph_point;
begin
 if(Length(Point)<=1) then exit;
 StartX:=Point[0].XPosition; StartY:=Point[0].YPosition;
 EndX:=Point[length(Point)-1].XPosition; EndY:=Point[length(Point)-1].YPosition;
 if(EndX-StartX>EndY-StartY) then step:=1/(Endx-StartX)
 else step:=1/(EndY-StartY);
 base:=0;
 while(base<=1)do
  begin
   temppoint:=graph_get_bezier_point(base,Point);
   if(ThickNess=1) then
    begin
     graph_heap_draw_point(Index,Round(temppoint.XPosition),Round(temppoint.YPosition),color);
    end
   else
    begin
     graph_heap_draw_circle(Index,Round(temppoint.XPosition),Round(temppoint.YPosition),
     ThickNess div 2,color);
    end;
   base:=base+step;
  end;
end;
procedure graph_heap_draw_line(Index:Dword;Point:graph_point_array;Thickness:Dword;
Color:graph_color);
var step,base:extended;
    StartX,StartY,EndX,EndY:extended;
    temppoint:graph_point;
begin
 if(Length(Point)<=1) then exit;
 StartX:=Point[0].XPosition; StartY:=Point[0].YPosition;
 EndX:=Point[length(Point)-1].XPosition; EndY:=Point[length(Point)-1].YPosition;
 if(Abs(EndX-StartX)>Abs(EndY-StartY)) then step:=1/Abs((Endx-StartX)) else step:=Abs(1/(EndY-StartY));
 base:=0;
 while(base<=1)do
  begin
   temppoint:=graph_get_bezier_point(base,Point);
   if(ThickNess=1) then
    begin
     graph_heap_draw_point(Index,Round(temppoint.XPosition),Round(temppoint.YPosition),color);
    end
   else
    begin
     graph_heap_draw_circle(Index,Round(temppoint.XPosition),Round(temppoint.YPosition),
     ThickNess div 2,color);
    end;
   base:=base+step;
  end;
end;
procedure graph_heap_draw_char(Index:Dword;Xalign:byte;YAlign:byte;PointX,PointY:Integer;
FontIndex:byte;Character:Char;Color:graph_color);
var RelatedWidth,RelatedHeight:Dword;
    StartX,StartY,EndX,EndY,FontX,FontY:dword;
    CurrentXPos,CurrentYPos:Dword;
    CurrentPosition:Natuint;
    BlockIndex:Natuint;
    tempindex:dword;
    Address:Pgraph_color;
begin
 if(Character<#32) or (Character>#126) then exit;
 if(Xalign=graph_align_left) then
  begin
   if(PointX+15<=0) then exit;
  end
 else if(Xalign=graph_align_center) then
  begin
   if(PointX+7<=0) then exit;
  end
 else if(Xalign=graph_align_right) then
  begin
   if(PointX<=0) then exit;
  end;
 if(Yalign=graph_align_top) then
  begin
   if(PointY+19<=0) then exit;
  end
 else if(Yalign=graph_align_middle) then
  begin
   if(PointY+9<=0) then exit;
  end
 else if(Yalign=graph_align_buttom) then
  begin
   if(PointY<=0) then exit;
  end;
 RelatedWidth:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaWidth;
 RelatedHeight:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaHeight;
 if(PointX>RelatedWidth) or (PointY>RelatedHeight) then exit;
 if(Xalign=graph_align_left) then
  begin
   if(PointX<=0) then StartX:=1 else StartX:=PointX;
   if(PointX+15>RelatedWidth) then EndX:=RelatedWidth else EndX:=PointX+15;
  end
 else if(Xalign=graph_align_center) then
  begin
   if(PointX<=7) then StartX:=1 else StartX:=PointX-7;
   if(PointX+7>RelatedWidth) then EndX:=RelatedWidth else EndX:=PointX+7;
  end
 else if(Xalign=graph_align_right) then
  begin
   if(PointX<=15) then StartX:=1 else StartX:=PointX-15;
   if(PointX>RelatedWidth) then EndX:=RelatedWidth else EndX:=PointX;
  end;
 if(Yalign=graph_align_top) then
  begin
   if(PointY<=0) then StartY:=1 else StartY:=PointY;
   if(PointY+19>RelatedHeight) then EndY:=RelatedHeight else EndY:=PointY+19;
  end
 else if(Yalign=graph_align_middle) then
  begin
   if(PointY<=9) then StartY:=1 else StartY:=PointY;
   if(PointY+9>RelatedHeight) then EndY:=RelatedHeight else EndY:=PointY+9;
  end
 else if(Yalign=graph_align_buttom) then
  begin
   if(PointY<=19) then StartY:=1 else StartY:=PointY;
   if(PointY>RelatedHeight) then EndY:=RelatedHeight else EndY:=PointY;
  end;
 CurrentXPos:=StartX; CurrentYPos:=StartY; BlockIndex:=0;
 CurrentPosition:=(StartY-1)*RelatedWidth+StartX;
 FontX:=0; FontY:=0;
 tempindex:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.Allocated=0) then break;
   inc(BlockIndex);
   Address:=graph_heap_item_to_address(tempindex);
   while(CurrentPosition>=(BlockIndex-1) shl graphheap.BlockPower) and
   (CurrentPosition<BlockIndex shl graphheap.BlockPower)do
    begin
     CurrentPosition:=(CurrentYPos-1)*RelatedWidth+(CurrentXPos-1);
     if(CurrentPosition>=BlockIndex shl graphheap.BlockPower) then break;
     FontX:=CurrentXPos-StartX+1; FontY:=CurrentYPos-StartY+1;
     if(Font_get_pixel(FontIndex,Byte(character)-$20+1,FontX,FontY)) then
      begin
       Pgraph_color(Address+CurrentPosition-(BlockIndex-1) shl graphheap.BlockPower)^:=Color;
      end;
     if(CurrentXPos<EndX) then inc(CurrentXPos)
     else if(CurrentYPos<EndY) then
      begin
       inc(CurrentYPos); CurrentXPos:=StartX;
      end
     else exit;
    end;
   tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
   if(tempindex=0) then break;
  end;
end;
procedure graph_heap_draw_char(Index:Dword;Xalign:byte;YAlign:byte;Point:graph_input_point;
FontIndex:byte;Character:Char;Color:graph_color);
var RelatedWidth,RelatedHeight:Dword;
    StartX,StartY,EndX,EndY,FontX,FontY:dword;
    CurrentXPos,CurrentYPos:Dword;
    CurrentPosition:Natuint;
    BlockIndex:Natuint;
    tempindex:dword;
    Address:Pgraph_color;
    PointX,PointY:Integer;
begin
 if(Character<#32) or (Character>#126) then exit;
 PointX:=Point.XPosition; PointY:=Point.YPosition;
 if(Xalign=graph_align_left) then
  begin
   if(PointX+15<=0) then exit;
  end
 else if(Xalign=graph_align_center) then
  begin
   if(PointX+7<=0) then exit;
  end
 else if(Xalign=graph_align_right) then
  begin
   if(PointX<=0) then exit;
  end;
 if(Yalign=graph_align_top) then
  begin
   if(PointY+19<=0) then exit;
  end
 else if(Yalign=graph_align_middle) then
  begin
   if(PointY+9<=0) then exit;
  end
 else if(Yalign=graph_align_buttom) then
  begin
   if(PointY<=0) then exit;
  end;
 RelatedWidth:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaWidth;
 RelatedHeight:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.CanvaHeight;
 if(PointX>RelatedWidth) or (PointY>RelatedHeight) then exit;
 if(Xalign=graph_align_left) then
  begin
   if(PointX<=0) then StartX:=1 else StartX:=PointX;
   if(PointX+15>RelatedWidth) then EndX:=RelatedWidth else EndX:=PointX+15;
  end
 else if(Xalign=graph_align_center) then
  begin
   if(PointX<=7) then StartX:=1 else StartX:=PointX-7;
   if(PointX+7>RelatedWidth) then EndX:=RelatedWidth else EndX:=PointX+7;
  end
 else if(Xalign=graph_align_right) then
  begin
   if(PointX<=15) then StartX:=1 else StartX:=PointX-15;
   if(PointX>RelatedWidth) then EndX:=RelatedWidth else EndX:=PointX;
  end;
 if(Yalign=graph_align_top) then
  begin
   if(PointY<=0) then StartY:=1 else StartY:=PointY;
   if(PointY+19>RelatedHeight) then EndY:=RelatedHeight else EndY:=PointY+19;
  end
 else if(Yalign=graph_align_middle) then
  begin
   if(PointY<=9) then StartY:=1 else StartY:=PointY;
   if(PointY+9>RelatedHeight) then EndY:=RelatedHeight else EndY:=PointY+9;
  end
 else if(Yalign=graph_align_buttom) then
  begin
   if(PointY<=19) then StartY:=1 else StartY:=PointY;
   if(PointY>RelatedHeight) then EndY:=RelatedHeight else EndY:=PointY;
  end;
 CurrentXPos:=StartX; CurrentYPos:=StartY; BlockIndex:=0; CurrentPosition:=0;
 FontX:=0; FontY:=0;
 tempindex:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.StartItemIndex;
 while(True)do
  begin
   if(Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.Allocated=0) then break;
   inc(BlockIndex);
   Address:=graph_heap_item_to_address(tempindex);
   while(CurrentPosition>=(BlockIndex-1) shl graphheap.BlockPower) and
   (CurrentPosition<BlockIndex shl graphheap.BlockPower)do
    begin
     FontX:=CurrentXPos-StartX+1; FontY:=CurrentYPos-StartY+1;
     CurrentPosition:=(CurrentYPos-1)*RelatedWidth+(CurrentXPos-1);
     if(Font_get_pixel(FontIndex,Byte(character)-$20+1,FontX,FontY)) then
     Pgraph_color(Address+CurrentPosition-(BlockIndex-1) shl graphheap.BlockPower)^:=Color;
     if(CurrentXPos<EndX) then inc(CurrentXPos)
     else if(CurrentYPos<EndY) then
      begin
       inc(CurrentYPos); CurrentXPos:=StartX;
      end
     else exit;
    end;
   tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
   if(tempindex=0) then break;
  end;
end;
procedure graph_heap_draw_string(Index:Dword;Xalign:byte;YAlign:byte;PointX,PointY:Integer;
FontIndex:byte;Str:string;Color:graph_color;maxlinelength:Integer);
var i,j,k,len,drawlen:Natuint;
    StartX,StartY:Integer;
    LineNumber:DWord;
begin
 i:=1; j:=1; len:=length(str);
 {Initialize the Line Number of the String}
 LineNumber:=1;
 while(i<=len)do
  begin
   if(str[i]=#13) then
    begin
     inc(linenumber); inc(i,2); j:=i; continue;
    end
   else if(str[i]=#10) then
    begin
     inc(linenumber); inc(i); j:=i; continue;
    end
   else if(i-j+1>maxlinelength) then
    begin
     inc(linenumber); j:=i; continue;
    end;
   inc(i);
  end;
 if(Yalign=graph_align_top) then StartY:=PointY
 else if(Yalign=graph_align_middle) then StartY:=PointY-linenumber div 2*20
 else if(Yalign=graph_align_buttom) then StartY:=PointY-linenumber*20;
 i:=1; j:=1;
 while(i<=len)do
  begin
   if(str[i]=#13) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i+2; inc(i,2); inc(StartY,20);
     continue;
    end
   else if(str[i]=#10) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i+1; inc(i); inc(StartY,20);
     continue;
    end
   else if(i-j+1>maxlinelength) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i; inc(StartY,20); continue;
    end;
   inc(i);
  end;
end;
procedure graph_heap_draw_string(Index:Dword;Xalign:byte;YAlign:byte;PointX,PointY:Integer;
FontIndex:byte;Str:PChar;Color:graph_color;maxlinelength:Integer);
var i,j,k,len,drawlen:Natuint;
    StartX,StartY:Integer;
    LineNumber:Dword;
begin
 i:=1; j:=1;
 {Initialize the Line Number of the String}
 LineNumber:=1;
 while((str+i-1)^<>#0)do
  begin
   if((str+i-1)^=#13) then
    begin
     inc(linenumber); inc(i,2); j:=i; continue;
    end
   else if((str+i-1)^=#10) then
    begin
     inc(linenumber); inc(i); j:=i; continue;
    end
   else if(i-j+1>maxlinelength) then
    begin
     inc(linenumber); j:=i; continue;
    end;
   inc(i);
  end;
 if(Yalign=graph_align_top) then StartY:=PointY
 else if(Yalign=graph_align_middle) then StartY:=PointY-linenumber div 2*20
 else if(Yalign=graph_align_buttom) then StartY:=PointY-linenumber*20;
 i:=1; j:=1;
 while((str+i-1)^<>#0)do
  begin
   if((str+i-1)^<>#13) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i+2; inc(i,2); inc(StartY,20);
     continue;
    end
   else if((str+i-1)^<>#10) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i+1; inc(i); inc(StartY,20);
     continue;
    end
   else if(i-j+1>maxlinelength) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i; inc(StartY,20); continue;
    end;
   inc(i);
  end;
end;
procedure graph_heap_draw_string(Index:Dword;Xalign:byte;YAlign:byte;Point:graph_input_point;
FontIndex:byte;Str:string;Color:graph_color;maxlinelength:Integer);
var i,j,k,len,drawlen:Natuint;
    StartX,StartY,PointX,PointY:Integer;
    LineNumber:Dword;
begin
 i:=1; j:=1; len:=length(str);
 PointX:=Point.XPosition; PointY:=Point.YPosition;
 {Initialize the Line Number of the String}
 LineNumber:=1;
 while(i<=len)do
  begin
   if(str[i]=#13) then
    begin
     inc(linenumber); inc(i,2); j:=i; continue;
    end
   else if(str[i]=#10) then
    begin
     inc(linenumber); inc(i); j:=i; continue;
    end
   else if(i-j+1>maxlinelength) then
    begin
     inc(linenumber); j:=i; continue;
    end;
   inc(i);
  end;
 if(Yalign=graph_align_top) then StartY:=PointY
 else if(Yalign=graph_align_middle) then StartY:=PointY-linenumber div 2*20
 else if(Yalign=graph_align_buttom) then StartY:=PointY-linenumber*20;
 i:=1; j:=1;
 while(i<=len)do
  begin
   if(str[i]=#13) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i+2; inc(i,2); inc(StartY,20);
     continue;
    end
   else if(str[i]=#10) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i+1; inc(i); inc(StartY,20);
     continue;
    end
   else if(i-j+1>maxlinelength) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i; inc(StartY,20); continue;
    end;
   inc(i);
  end;
end;
procedure graph_heap_draw_string(Index:Dword;Xalign:byte;YAlign:byte;Point:graph_input_point;
FontIndex:byte;Str:PChar;Color:graph_color;maxlinelength:Integer);
var i,j,k,len,drawlen:Natuint;
    StartX,StartY,PointX,PointY:Integer;
    LineNumber:Dword;
begin
 i:=1; j:=1;
 PointX:=Point.XPosition; PointY:=Point.YPosition;
 {Initialize the Line Number of the String}
 LineNumber:=1;
 while((str+i-1)^<>#0)do
  begin
   if((str+i-1)^=#13) then
    begin
     inc(linenumber); inc(i,2); j:=i; continue;
    end
   else if((str+i-1)^=#10) then
    begin
     inc(linenumber); inc(i); j:=i; continue;
    end
   else if(i-j+1>maxlinelength) then
    begin
     inc(linenumber); j:=i; continue;
    end;
   inc(i);
  end;
 if(Yalign=graph_align_top) then StartY:=PointY
 else if(Yalign=graph_align_middle) then StartY:=PointY-linenumber div 2*20
 else if(Yalign=graph_align_buttom) then StartY:=PointY-linenumber*20;
 i:=1; j:=1;
 while((str+i-1)^<>#0)do
  begin
   if((str+i-1)^<>#13) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i+2; inc(i,2); inc(StartY,20);
     continue;
    end
   else if((str+i-1)^<>#10) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i+1; inc(i); inc(StartY,20);
     continue;
    end
   else if(i-j+1>maxlinelength) then
    begin
     k:=j;
     drawlen:=i-j+1;
     if(Xalign=graph_align_left) then StartX:=PointX
     else if(Xalign=graph_align_center) then StartX:=PointX-drawlen div 2*16
     else if(Xalign=graph_align_right) then StartX:=PointX-drawlen*16;
     while(k<=i) do
      begin
       graph_heap_draw_char(Index,Xalign,Yalign,StartX,StartY,FontIndex,str[k],color);
       inc(StartX,16);
       inc(k);
      end;
     j:=i; inc(StartY,20); continue;
    end;
   inc(i);
  end;
end;
function graph_heap_get_visible_status(Index:Dword):boolean;
begin
 graph_heap_get_visible_status:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.Visible;
end;
function graph_heap_get_x_position(Index:Dword):Integer;
begin
 graph_heap_get_x_position:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.xposition;
end;
function graph_heap_get_y_position(Index:Dword):Integer;
begin
 graph_heap_get_y_position:=Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.yposition;
end;
procedure graph_heap_set_visible_status(Index:Dword;NewVisibleStatus:boolean);
begin
 Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.Visible:=NewVisibleStatus;
end;
procedure graph_heap_set_x_position(Index:Dword;XPosition:Integer);
begin
 Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.xposition:=XPosition;
end;
procedure graph_heap_set_y_position(Index:Dword;YPosition:Integer);
begin
 Pgraph_attribute(graphheap.AttributeAddress+Index-1)^.yposition:=YPosition;
end;
procedure graph_heap_output_screen;
var i,j,k,m:Natuint;
    screenpos:Natuint;
    tempindex:Natuint;
    tempwidth,tempheight:Dword;
    tempx,tempy:Integer;
    MinIndex:Dword;
    Address:Pgraph_color;
begin
 if(graphheap.ScreenOutputAddress=nil) then exit;
 i:=1; j:=1; screenpos:=1;
 {Initialize the initial screen to black}
 for i:=1 to graphheap.ScreenWidth do
  for j:=1 to graphheap.ScreenHeight do
   begin
    Pgraph_color(graphheap.ScreenInitAddress+screenpos-1)^:=graph_color_black;
    inc(screenpos);
   end;
 {Then draw Any Visible Canva to the initial screen}
 for i:=1 to graphheap.MaxIndex do
  begin
   MinIndex:=0;
   for j:=1 to graphheap.AttributeMaxIndex do
    begin
     if(Pgraph_attribute(graphheap.AttributeAddress+j-1)^.Index=i) then
      begin
       MinIndex:=j; break;
      end;
    end;
   if(MinIndex=0) then continue;
   if(Pgraph_attribute(graphheap.AttributeAddress+MinIndex-1)^.Index=0)
   or(Pgraph_attribute(graphheap.AttributeAddress+MinIndex-1)^.Visible=false) then continue;
   tempindex:=Pgraph_attribute(graphheap.AttributeAddress+MinIndex-1)^.StartItemIndex;
   tempwidth:=Pgraph_attribute(graphheap.AttributeAddress+MinIndex-1)^.CanvaWidth;
   tempheight:=Pgraph_attribute(graphheap.AttributeAddress+MinIndex-1)^.CanvaHeight;
   tempx:=Pgraph_attribute(graphheap.AttributeAddress+MinIndex-1)^.xposition;
   tempy:=Pgraph_attribute(graphheap.AttributeAddress+MinIndex-1)^.yposition;
   Address:=graph_heap_item_to_address(tempindex);
   m:=0;
   for k:=1 to tempheight do
    begin
     for j:=1 to tempwidth do
      begin
       if(tempx+j-1<=0) or (tempy+k-1<=0) or
       (tempx+j-1>graphheap.ScreenWidth) or (tempy+k-1>graphheap.ScreenHeight) then continue;
       screenpos:=(tempy+k-2)*graphheap.ScreenWidth+tempx+j-2;
       Pgraph_color(graphheap.ScreenInitAddress+screenpos)^:=
       graph_color_mix(Pgraph_color(graphheap.ScreenInitAddress+screenpos)^,Pgraph_color(Address+m)^);
       inc(m);
       if(m=1 shl graphheap.BlockPower) then
        begin
         tempindex:=Pgraph_item(graphheap.HeapStartAddress+tempindex-1)^.RightIndex;
         if(tempindex=0) then break;
         Address:=graph_heap_item_to_address(tempindex); m:=0;
        end;
      end;
     if(tempindex=0) then break;
    end;
  end;
 {Then Draw it on the physical screen}
 screenpos:=1;
 for j:=1 to graphheap.ScreenHeight do
  for i:=1 to graphheap.ScreenWidth do
   begin
    if(graphheap.ScreenAttribute=false) then
     begin
      Pgraph_color(graphheap.ScreenOutputAddress+screenpos-1)^:=
      Pgraph_color(graphheap.ScreenInitAddress+screenpos-1)^;
      Pgraph_output_color(graphheap.ScreenOutputAddress+screenpos-1)^.RGBReserved:=0;
     end
    else
     begin
      Pgraph_output_color(graphheap.ScreenOutputAddress+screenpos-1)^.BGRRed:=
      Pgraph_color(graphheap.ScreenInitAddress+screenpos-1)^.Red;
      Pgraph_output_color(graphheap.ScreenOutputAddress+screenpos-1)^.BGRGreen:=
      Pgraph_color(graphheap.ScreenInitAddress+screenpos-1)^.Green;
      Pgraph_output_color(graphheap.ScreenOutputAddress+screenpos-1)^.BGRBlue:=
      Pgraph_color(graphheap.ScreenInitAddress+screenpos-1)^.Blue;
      Pgraph_output_color(graphheap.ScreenOutputAddress+screenpos-1)^.BGRReserved:=0;
     end;
    inc(screenpos);
   end;
end;

end.
                                        

