unit tydqfs;

interface

{$MODE FPC}

uses uefi,binarybase;

const kernel_number_of_directory_entries=16;
     {Define files in TYDQ File System}
type tydqfs_time=packed record
                 year:word;
                 month:byte;
                 day:byte;
                 hour:byte;
                 minute:byte;
                 second:byte;
                 millisecond:word;
                 end;
     tydqfs_file=packed record
                 fparentpos:qword;
                 fmainclass:dword;
                 fsubclass:dword;
                 fhidden:byte;
                 fuserlevel:byte;
                 fbelonguserindex:qword;
                 fName:array[1..256] of WideChar;
                 fcreatetime:tydqfs_time;
                 flastedittime:tydqfs_time;
                 fcontentCount:qword;
                 end;
     tydqfs_header=packed record
                   signature:qword;
                   maxsize:qword;
                   usedsize:qword;
                   RootName:array[1..256] of WideChar;
                   RootCount:qword;
                   end;
     tydqfs_filename=array[1..256] of WideChar;
     tydqfs_file_list=record
                      file_list_fullpath:^qword;
                      file_list_count:natuint;
                      end;
     tydqfs_data=record
                 fsdata:PByte;
                 fssize:natuint;
                 end;
     tydqfs_string=record
                   string_position:natuint;
                   string_length:natuint;
                   end;
     {Define system info file in TYDQ System}
     tydqfs_system_header=packed record 
                          tydqgraphics:boolean;
                          tydqnetwork:boolean;
                          tydqautodetectkernel:boolean;
                          tydqshell:boolean;
                          tydqenvironmentvariable:boolean;
                          tydqlanguage:word;
                          end;
     tydqfs_system_info=packed record
                        header:tydqfs_system_header;
                        infostart:qword;
                        isfreed:boolean;
                        end;
     {Define environment variable file in TYDQ System}
     tydqfs_environment_variable_list=packed record 
                                      header_index:qword;
                                      item_start_index:qword;
                                      item_start_count:qword;
                                      isfreed:boolean;
                                      end;
     
const tydqfs_signature:natuint=$5D47291AD7E3F2B1;
      {Set the fmainclass of tydqfs_file}
      tydqfs_unknown=0;
      tydqfs_folder=1;
      tydqfs_text_file=2;
      tydqfs_picture_file=3;
      tydqfs_multipicture_file=4;
      tydqfs_sound_file=5;
      tydqfs_video_file=6;
      tydqfs_executable_file=7;
      tydqfs_link_file=8;
      tydqfs_virtual_disk_file=9;
      tydqfs_cdimage_file=10;
      tydqfs_model_file=11;
      tydqfs_certificate_file=12;
      tydqfs_font_file=13;
      tydqfs_color_file=14;
      tydqfs_vector_file=15;
      tydqfs_zipped_file=16;
      tydqfs_cad_file=17;
      tydqfs_binary_file=18;
      {Set the fattribute of tydqfs_file}
      tydqfs_hidden_chiefmanager=0;
      tydqfs_hidden_system=0;
      tydqfs_hidden_normalmanager=1;
      tydqfs_hidden_normaluser=2;
      tydqfs_hidden_none=3;
      {Set the fsubclass of tydqfs_file}
      tydqfs_folder_public=0;
      tydqfs_folder_private=1;
      tydqfs_text_file_pascal=0;
      tydqfs_text_file_c=1;
      tydqfs_text_file_cpp=2;
      tydqfs_text_file_python=3;
      tydqfs_text_file_fortran=4;
      tydqfs_text_file_rust=5;
      tydqfs_text_file_java=6;
      tydqfs_text_file_csharp=7;
      tydqfs_text_file_golang=8;
      tydqfs_text_file_assembly=9;
      tydqfs_text_file_javascript=10;
      tydqfs_text_file_typescript=11;
      tydqfs_text_file_html=12;
      tydqfs_text_file_xml=13;
      tydqfs_text_file_markdown=14;
      tydqfs_text_file_toml=15;
      tydqfs_text_file_yaml=16;
      tydqfs_text_file_shell=17;
      tydqfs_text_file_glsl=18;
      tydqfs_text_file_glsl_es=19;
      tydqfs_text_file_hlsl=20;
      tydqfs_text_file_plaintext=21;
      tydqfs_text_file_settings=22;
      tydqfs_text_file_configuration=23;
      tydqfs_picture_file_webp=0;
      tydqfs_picture_file_bitmap=1;
      tydqfs_picture_file_pcx=2;
      tydqfs_picture_file_tiff=3;
      tydqfs_picture_file_jpeg=4;
      tydqfs_picture_file_tga=5;
      tydqfs_picture_file_exif=6;
      tydqfs_picture_file_fpx=7;
      tydqfs_picture_file_pcd=8;
      tydqfs_picture_file_dxf=9;
      tydqfs_picture_file_ufo=10;
      tydqfs_picture_file_eps=11;
      tydqfs_picture_file_png=12;
      tydqfs_picture_file_hdri=13;
      tydqfs_picture_file_filc=14;
      tydqfs_multipicture_file_gif=0;
      tydqfs_multipicture_file_psd=1;
      tydqfs_multipicture_file_apng=2;
      tydqfs_multipicture_file_ico=3;
      tydqfs_sound_file_cd=0;
      tydqfs_sound_file_wave=1;
      tydqfs_sound_file_aiff=2;
      tydqfs_sound_file_au=3;
      tydqfs_sound_file_mpeg=4;
      tydqfs_sound_file_mp3=5;
      tydqfs_sound_file_mpeg4=6;
      tydqfs_sound_file_midi=7;
      tydqfs_sound_file_wma=8;
      tydqfs_sound_file_realaudio=9;
      tydqfs_sound_file_realmedia=10;
      tydqfs_sound_file_realaudiosecured=11;
      tydqfs_sound_file_vqf=12;
      tydqfs_sound_file_ogg=13;
      tydqfs_sound_file_amr=14;
      tydqfs_sound_file_ape=15;
      tydqfs_sound_file_flac=16;
      tydqfs_sound_file_aac=17;
      tydqfs_video_file_avi=0;
      tydqfs_video_file_wmv=1;
      tydqfs_video_file_mpeg=2;
      tydqfs_video_file_quicktime=3;
      tydqfs_video_file_realvideo=4;
      tydqfs_video_file_flash=5;
      tydqfs_video_file_mpeg4=6;
      tydqfs_executable_file_elf=0;
      tydqfs_executable_file_pe=1;
      tydqfs_executable_file_binary=2;
      tydqfs_link_file_link=0;
      tydqfs_link_file_multilink=1;
      tydqfs_virtual_disk_file_raw=0;
      tydqfs_virtual_disk_file_qcow2=1;
      tydqfs_virtual_disk_file_vhd=2;
      tydqfs_virtual_disk_file_vmdk=3;
      tydqfs_virtual_disk_file_qed=4;
      tydqfs_virtual_disk_file_fvd=5;
      tydqfs_cdimage_file_iso=0;
      tydqfs_cdimage_file_udf=1;
      tydqfs_cdimage_file_juilet=2;
      tydqfd_cdimage_file_romeo=3;
      tydqfs_vector_file_svg=0;
      tydqfs_vector_file_cdr=1;
      tydqfs_vector_file_ai=2;
      tydqfs_vector_file_wmf=3;
      tydqfs_vector_file_emf=4;
      tydqfs_model_file_stl=0;
      tydqfs_model_file_obj=1;
      tydqfs_model_file_fbx=2;
      tydqfs_model_file_dae=3;
      tydqfs_model_file_3ds=4;
      tydqfs_model_file_iges=5;
      tydqfs_model_file_step=6;
      tydqfs_model_file_vrml=7;
      tydqfs_model_file_x3d=8;
      tydqfs_model_file_amf=9;
      tydqfs_model_file_3mf=10;
      tydqfs_certificate_file_pem=0;
      tydqfs_certificate_file_der=1;
      tydqfs_certificate_file_crt=2;
      tydqfs_certificate_file_cer=3;
      tydqfs_certificate_file_key=4;
      tydqfs_certificate_file_pfx=5;
      tydqfs_certificate_file_p12=6;
      tydqfs_certificate_file_jks=7;
      tydqfs_font_file_ttf=0;
      tydqfs_font_file_otf=1;
      tydqfs_font_file_postscript=2;
      tydqfs_font_file_woff=3;
      tydqfs_font_file_woff2=4;
      tydqfs_font_file_psf=5;
      tydqfs_color_file_pal=0;
      tydqfs_zipped_file_zip=0;
      tydqfs_zipped_file_rar=1;
      tydqfs_zipped_file_gz=2;
      tydqfs_zipped_file_bz2=3;
      tydqfs_zipped_file_zcompress=4;
      tydqfs_zipped_file_xz=5;
      tydqfs_cad_file_dwg=0;
      tydqfs_cad_file_dxf=1;
      tydqfs_cad_file_dwt=2;
      tydqfs_binary_file_data=0;
      tydqfs_binary_file_program=1;
      {Set the user level of tydqfs_file}
      userlevel_chiefmanager:byte=$00;
      userlevel_system:byte=$00;
      userlevel_normalmanager:byte=$01;
      userlevel_normaluser:byte=$02;
      userlevel_shared:byte=$03;
    
procedure tydq_fs_system_initialize;
function tydq_fs_time_to_string(orgtime:tydqfs_time):PWideChar;
function tydq_fs_locate_disk_index(edl:efi_disk_list;path:PWideChar):natuint;
function tydq_fs_locate_path(edl:efi_disk_list;path:PWideChar):PWideChar;
procedure tydq_fs_initialize(edl:efi_disk_list;diskindex:natuint;RootName:PWideChar);
function tydq_fs_read_header(edl:efi_disk_list;diskindex:natuint):tydqfs_header;
procedure tydq_fs_write_header(edl:efi_disk_list;diskindex:natuint;fsh:tydqfs_header);
function tydq_fs_disk_exists(edl:efi_disk_list;diskname:PWideChar):boolean;
function tydq_fs_disk_index(edl:efi_disk_list;diskname:PWideChar):natuint;
function tydq_fs_disk_name(edl:efi_disk_list;index:natuint):PWideChar;
function tydq_fs_disk_is_formatted(edl:efi_disk_list;diskindex:natuint):boolean;
function tydq_fs_file_exists(edl:efi_disk_list;diskindex:natuint;filename:PWideChar):boolean;
function tydq_fs_file_position(edl:efi_disk_list;diskindex:natuint;filename:PWideChar):qword;
procedure tydq_fs_file_create(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;mainclass:dword;subclass:dword;userlevel:byte;hiddenlevel:byte;belonguserindex:qword);
function tydq_fs_file_list_item_to_path(edl:efi_disk_list;diskindex:natuint;position:natuint):PWideChar;
function tydq_fs_file_list_item_to_path_ext(edl:efi_disk_list;diskindex:natuint;position:natuint):PWideChar;
function tydq_fs_file_list(edl:efi_disk_list;diskindex:natuint;fileposition:qword;expanded:boolean;detecthidden:boolean;userlevel:byte;belonguserindex:qword):tydqfs_file_list;
procedure tydq_fs_file_delete(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:natuint);
procedure tydq_fs_file_set_attribute(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;mainclass:dword;subclass:dword;userlevel:byte;belonguserindex:qword);
function tydq_fs_file_info(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword):tydqfs_file;
function tydq_fs_file_read_data(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword):tydqfs_data;
function tydq_fs_file_read_data_ext(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;ReadPosition,ReadLength:qword;userlevel:byte;belonguserindex:qword):tydqfs_data;
procedure tydq_fs_file_write_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;writeposition:qword;writedata:Pointer;writesize:qword;userlevel:byte;belonguserindex:qword);
procedure 
tydq_fs_file_rewrite_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;writedata:Pointer;writesize:qword;userlevel:byte;belonguserindex:qword);
procedure tydq_fs_file_resize_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;destinationsize:qword;userlevel:byte;belonguserindex:qword);
procedure tydq_fs_file_insert_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;insertpos:qword;insertdata:Pointer;insertsize:qword;userlevel:byte;belonguserindex:qword);
procedure tydq_fs_file_delete_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;deletepos,deletesize:qword;userlevel:byte;belonguserindex:natuint);
procedure tydq_fs_file_clear_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword);
function tydq_fs_file_read_string_line_count(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword):qword;
function tydq_fs_file_read_wstring_line_count(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword):qword;
function tydq_fs_file_read_string_line(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;userlevel:byte;belonguserindex:qword):PChar;
function tydq_fs_file_read_Wstring_line(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;userlevel:byte;belonguserindex:qword):PWideChar;
procedure tydq_fs_file_write_string(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;writestr:PChar;userlevel:byte;belonguserindex:qword);
procedure tydq_fs_file_write_wstring(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;writestr:PWideChar;userlevel:byte;belonguserindex:qword);
procedure tydq_fs_file_delete_string(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;userlevel:byte;belonguserindex:qword);
procedure tydq_fs_file_delete_wstring(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;userlevel:byte;belonguserindex:qword);
function tydq_fs_systeminfo_init:tydqfs_system_info;
procedure tydq_fs_systeminfo_create(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint);
function tydq_fs_systeminfo_exists(edl:efi_disk_list):boolean;
function tydq_fs_systeminfo_read(edl:efi_disk_list):tydqfs_system_info;
procedure tydq_fs_systeminfo_write(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info);
function tydq_fs_systeminfo_user_exists(edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar):boolean;
procedure tydq_fs_systeminfo_add_user(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;newusername,newuserpassword:PWideChar;newuserlevel:byte);
procedure tydq_fs_systeminfo_delete_user(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar);
procedure tydq_fs_systeminfo_change_user_name(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar;newusername:PWideChar);
procedure tydq_fs_systeminfo_change_user_password(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar;newuserpassword:PWideChar);function tydq_fs_systeminfo_match_user_password(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar;inputpassword:PWideChar):boolean;
function tydq_fs_systeminfo_get_username_with_position(edl:efi_disk_list;sysinfo:tydqfs_system_info;position:natuint):PWideChar;
function tydq_fs_systeminfo_get_user_level(edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar):byte;
function tydq_fs_systeminfo_get_user_index(edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar):qword;
function tydq_fs_systeminfo_disk_index(edl:efi_disk_list):natuint;
procedure tydq_fs_systeminfo_free(var sysinfo:tydqfs_system_info);
function tydq_fs_environment_variable_initialize:tydqfs_environment_variable_list;
procedure tydq_fs_environment_variable_file_create(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint);
function tydq_fs_environment_variable_read(systemtable:Pefi_system_table;edl:efi_disk_list):tydqfs_environment_variable_list;
function tydq_fs_environment_variable_exists(edl:efi_disk_list):boolean;
procedure tydq_fs_environment_variable_add_item(systemtable:Pefi_system_table;edl:efi_disk_list;var evlist:tydqfs_environment_variable_list;varname,varvalue:PWideChar);
procedure tydq_fs_environment_variable_delete_item(systemtable:Pefi_system_table;edl:efi_disk_list;var evlist:tydqfs_environment_variable_list;deletevarname:PWideChar;deletevarindex:qword);
procedure tydq_fs_environment_variable_clear_item(systemtable:Pefi_system_table;edl:efi_disk_list;var evlist:tydqfs_environment_variable_list);
function tydq_fs_environment_variable_get_value(systemtable:Pefi_system_table;edl:efi_disk_list;evlist:tydqfs_environment_variable_list;getname:PWideChar;getindex:qword):PWideChar;
function tydq_fs_environment_variable_get_value_with_index(systemtable:Pefi_system_table;edl:efi_disk_list;evlist:tydqfs_environment_variable_list;getpos:qword):PWideChar;
procedure tydq_fs_environment_variable_file_free(var evlist:tydqfs_environment_variable_list);
function tydq_fs_name_legal(tydqname:PWideChar):boolean;
function tydq_fs_path_legal(tydqpath:PWideChar):boolean;
function tydq_fs_path_vaild(edl:efi_disk_list;diskindex:natuint;path:PWideChar;userlevel:byte;belonguserindex:qword):boolean;

var tydqcurrentfullpath:PWideChar;
    tydqusername:PWideChar;

implementation

function efi_time_to_tydq_fs_time(etime:efi_time):tydqfs_time;[public,alias:'EFI_TIME_TO_TYDQ_FS_TIME'];
var fs_time:tydqfs_time;
begin
 fs_time.year:=etime.year;
 fs_time.month:=etime.month;
 fs_time.day:=etime.day;
 fs_time.hour:=etime.hour;
 fs_time.minute:=etime.minute;
 fs_time.second:=etime.second;
 fs_time.millisecond:=etime.nanosecond div 1000000;
end;
function PWChar_to_tydq_filename(str:PWideChar):tydqfs_filename;[public,alias:'PWChar_to_tydq_filename'];
var i:natuint;
    fsfn:tydqfs_filename;
begin
 i:=0;
 while((str+i)^<>#0) do
  begin
   fsfn[i+1]:=(str+i)^;
   inc(i);
  end;
 fsfn[i+1]:=#0;
 PWChar_to_tydq_filename:=fsfn;
end;
function tydq_fs_time_to_string(orgtime:tydqfs_time):PWideChar;[public,alias:'TYDQ_FS_TIME_TO_STRING'];
var res,partstr,partstr2:PWideChar;
begin
 Wstrinit(res,256);
 partstr:=UintToPWchar(orgtime.month);
 if(Wstrlen(partstr)=1) then Wstrcat(res,'0');
 Wstrcat(res,partstr);
 Wstrcat(res,'/');
 Wstrfree(partstr);
 partstr:=UintToPWChar(orgtime.day);
 if(Wstrlen(partstr)=1) then Wstrcat(res,'0');
 Wstrcat(res,partstr);
 Wstrfree(partstr);
 partstr:=UintToPWChar(orgtime.year);
 Wstrset(res,partstr);
 Wstrcat(res,'/');
 Wstrfree(partstr);
 Wstrcat(res,' ');
 partstr:=UintToPWChar(orgtime.hour);
 if(Wstrlen(partstr)=1) then Wstrcat(res,'0');
 Wstrcat(res,partstr);
 Wstrfree(partstr);
 Wstrcat(res,':');
 partstr:=UintToPWChar(orgtime.minute);
 if(Wstrlen(partstr)=1) then Wstrcat(res,'0');
 Wstrcat(res,partstr);
 Wstrfree(partstr);
 Wstrcat(res,':');
 partstr:=UintToPWChar(orgtime.second);
 if(Wstrlen(partstr)=1) then Wstrcat(res,'0');
 Wstrcat(res,partstr);
 Wstrfree(partstr);
 tydq_fs_time_to_string:=res;
end;
procedure tydq_fs_system_initialize;[public,alias:'TYDQ_DISKNAME_AND_PATH_INITIALIZE'];
begin
 Wstrinit(tydqcurrentfullpath,65535);
 Wstrinit(tydqusername,127);
end;
function tydq_fs_locate_disk_index(edl:efi_disk_list;path:PWideChar):natuint;[public,alias:'TYDQ_FS_LOCATE_DISK_INDEX'];
var pos,res:natuint;
    partstr:PWideChar;
begin
 if(path<>nil) then
  begin
   pos:=Wstrpos(path,'/',1);
   partstr:=Wstrcutout(path,1,pos-1);
   res:=tydq_fs_disk_index(edl,partstr);
  end
 else res:=0;
 if(res=0) then 
  begin
   pos:=Wstrpos(tydqcurrentfullpath,'/',1);
   partstr:=Wstrcutout(tydqcurrentfullpath,1,pos-1);
   tydq_fs_locate_disk_index:=tydq_fs_disk_index(edl,partstr);
   Wstrfree(partstr);
  end
 else tydq_fs_locate_disk_index:=res;
end;
function tydq_fs_locate_path(edl:efi_disk_list;path:PWideChar):PWideChar;[public,alias:'TYDQ_FS_LOCATE_PATH'];
var pos,pos2,diskindex:natuint;
    partstr,partstr2,res:PWideChar;
begin
 if(Wstrlen(path)>0) then
  begin
   pos:=Wstrpos(path,'/',1);
   if(pos=0) then exit(nil);
   Wstrinit(res,65535);
   partstr:=Wstrcutout(path,1,pos-1);
   if(partstr=nil) then
    begin
     Wstrset(res,path);
    end
   else if(partstr<>nil) then
    begin
     diskindex:=tydq_fs_disk_index(edl,partstr);
     pos2:=Wstrpos(tydqcurrentfullpath,'/',1);
     partstr2:=Wstrcutout(res,pos2,Wstrlen(tydqcurrentfullpath));
     Wstrset(res,partstr2);
     if(diskindex=0) then
      begin
       Wstrcat(res,'/'); Wstrcat(res,path);
      end;
    end;
   Wstrfree(partstr2); Wstrfree(partstr);
   tydq_fs_locate_path:=res;
  end
 else exit(nil);
end;
procedure tydq_fs_initialize(edl:efi_disk_list;diskindex:natuint;RootName:PWideChar);[public,alias:'TYDQ_FS_INITIALIZE'];
var tydqdp:Pefi_disk_io_protocol;
    tydqbp:Pefi_block_io_protocol;
    tydqfsh:tydqfs_header;
begin
 tydqdp:=(edl.disk_content+diskindex-1)^; tydqbp:=(edl.disk_block_content+diskindex-1)^;
 tydqfsh.signature:=$5D47291AD7E3F2B1;
 tydqfsh.maxsize:=(tydqbp^.Media^.LastBlock+1)*tydqbp^.Media^.BlockSize;
 tydqfsh.usedsize:=sizeof(tydqfs_header);
 tydqfsh.RootName:=PWChar_to_tydq_filename(RootName);
 tydqfsh.RootCount:=0;
 tydqdp^.WriteDisk(tydqdp,tydqbp^.Media^.MediaId,0,sizeof(tydqfs_header),@tydqfsh);
end;
function tydq_fs_file_initialize(filename:PWideChar;filetime:efi_time;parentpos:natuint;mainclass,subclass:dword;hiddenlevel:byte;userlevel:byte;belonguserindex:qword):tydqfs_file;[public,alias:'TYDQ_FS_FILE_INITIALIZE'];
var tydqfile:tydqfs_file;
    correction_level:byte;
begin
 if(userlevel>=hiddenlevel) then correction_level:=userlevel else correction_level:=hiddenlevel;
 tydqfile.fparentpos:=parentpos;
 tydqfile.fmainclass:=mainclass;
 tydqfile.fsubclass:=subclass;
 tydqfile.fuserlevel:=correction_level;
 tydqfile.fbelonguserindex:=belonguserindex;
 tydqfile.fcreatetime:=efi_time_to_tydq_fs_time(filetime);
 tydqfile.flastedittime:=efi_time_to_tydq_fs_time(filetime);
 tydqfile.fname:=PWChar_to_tydq_filename(filename);
 tydqfile.fcontentCount:=0;
 tydq_fs_file_initialize:=tydqfile;
end;
function tydq_fs_read_header(edl:efi_disk_list;diskindex:natuint):tydqfs_header;[public,alias:'TYDQ_FS_READ_HEADER'];
var tydqdp:Pefi_disk_io_protocol;
    tydqbp:Pefi_block_io_protocol;
    res:tydqfs_header;
begin
 if(diskindex=0) then exit;
 tydqdp:=(edl.disk_content+diskindex-1)^;
 tydqbp:=(edl.disk_block_content+diskindex-1)^;
 tydqdp^.ReadDisk(tydqdp,tydqbp^.Media^.MediaId,0,sizeof(tydqfs_header),res);
 tydq_fs_read_header:=res;
end;
procedure tydq_fs_write_header(edl:efi_disk_list;diskindex:natuint;fsh:tydqfs_header);[public,alias:'TYDQ_FS_WRITE_HEADER'];
var tydqdp:Pefi_disk_io_protocol;
    tydqbp:Pefi_block_io_protocol;
begin
 tydqdp:=(edl.disk_content+diskindex-1)^;
 tydqbp:=(edl.disk_block_content+diskindex-1)^;
 tydqdp^.WriteDisk(tydqdp,tydqbp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
end;
procedure tydq_fs_disk_move_left(edl:efi_disk_list;diskindex:natuint;movestart,moveend,movelength:qword);[public,alias:'TYDQ_FS_FILE_MOVE_LEFT'];
var procbyte,zero:byte;
    dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,readpos:natuint;
begin
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 for i:=movestart to moveend do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,i,1,procbyte);
   dp^.WriteDisk(dp,bp^.Media^.MediaId,i-movelength,1,@procbyte);
  end;
end;
procedure tydq_fs_disk_move_right(edl:efi_disk_list;diskindex:natuint;movestart,moveend,movelength:qword);[public,alias:'TYDQ_FS_FILE_MOVE_RIGHT'];
var procbyte:byte;
    dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,readpos:natuint;
begin
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 for i:=moveend downto movestart do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,i,1,procbyte);
   dp^.WriteDisk(dp,bp^.Media^.MediaId,i+movelength,1,@procbyte);
  end;
end;
function tydq_fs_disk_is_formatted(edl:efi_disk_list;diskindex:natuint):boolean;[public,alias:'TYDQ_FS_DISK_IS_FORMATTED'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fsh:tydqfs_header;
begin
 if(diskindex>edl.disk_count) then exit(false);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 if(fsh.signature=$5D47291AD7E3F2B1) and (fsh.maxsize=(bp^.Media^.LastBlock+1)*bp^.Media^.BlockSize) and (fsh.usedsize>=sizeof(tydqfs_header)) then
 tydq_fs_disk_is_formatted:=true else tydq_fs_disk_is_formatted:=false;
end;
function tydq_fs_disk_exists(edl:efi_disk_list;diskname:PWideChar):boolean;[public,alias:'TYDQ_FS_DISK_EXISTS'];
var i:natuint;
    fsh:tydqfs_header;
begin
 i:=1;
 while(i<=edl.disk_count) do
  begin
   fsh:=tydq_fs_read_header(edl,i);
   if(WstrCmp(diskname,@fsh.RootName)=0) and (Wstrlen(diskname)=Wstrlen(@fsh.RootName)) then break;
   inc(i);
  end;
 if(i>edl.disk_count) then tydq_fs_disk_exists:=false else tydq_fs_disk_exists:=true;
end;
function tydq_fs_disk_index(edl:efi_disk_list;diskname:PWideChar):natuint;[public,alias:'TYDQ_FS_DISK_INDEX'];
var i:natuint;
    fsh:tydqfs_header;
begin
 i:=1;
 while(i<=edl.disk_count) do
  begin
   fsh:=tydq_fs_read_header(edl,i);
   if(WstrCmp(diskname,@fsh.RootName)=0) and (Wstrlen(diskname)=Wstrlen(@fsh.RootName)) then break;
   inc(i);
  end;
 if(i>edl.disk_count) then tydq_fs_disk_index:=0 else tydq_fs_disk_index:=i;
end;
function tydq_fs_disk_name(edl:efi_disk_list;index:natuint):PWideChar;[public,alias:'TYDQ_FS_DISK_NAME'];
var fsh:tydqfs_header;
    res:PWideChar;
begin
 Wstrinit(res,256);
 fsh:=tydq_fs_read_header(edl,index);
 Wstrset(res,@fsh.RootName);
 tydq_fs_disk_name:=res;
end;
function tydq_fs_file_exists(edl:efi_disk_list;diskindex:natuint;filename:PWideChar):boolean;[public,alias:'TYDQ_FS_FILE_EXISTS'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,pos1,pos2:natuint;
    dpos,rpos:qword;
    fsh:tydqfs_header;
    fsf,rfsf:tydqfs_file;
    partstr:PWideChar;
    bool:boolean;
begin
 if(diskindex>edl.disk_count) then exit(false);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^; 
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 pos1:=1; pos2:=2; bool:=true;
 if(filename=nil) then exit(false);
 if(WstrCmpL(filename,'/')=0) then exit(bool);
 while(pos2>0) do
  begin
   pos2:=Wstrpos(filename,'/',pos1+1);
   if(pos2>0) then partstr:=Wstrcutout(filename,pos1+1,pos2-1) else partstr:=Wstrcutout(filename,pos1+1,Wstrlen(filename));
   if(pos1=1) then
    begin
     i:=1;
     while(i<=fsh.RootCount shr 3) do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1)*(1 shl 3),1 shl 3,dpos);
       dp^.ReadDisk(dp,bp^.Media^.MediaId,dpos,sizeof(tydqfs_file),fsf);
       if(WstrcmpL(@fsf.fname,partstr)=0) then 
        begin
         rpos:=dpos; bool:=true; break;
        end;
       inc(i);
      end;
     if(i>fsh.RootCount shr 3) then 
      begin
       Wstrfree(partstr); bool:=false; break;
      end;
    end
   else if(pos1>1) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,rpos,sizeof(tydqfs_file),fsf);
     if(fsf.fmainclass=tydqfs_folder) and (fsf.fContentCount>0) then
      begin
       i:=1;
       while(i<=fsf.fContentCount shr 3) do
        begin
         dp^.ReadDisk(dp,bp^.Media^.MediaId,rpos+sizeof(tydqfs_file)+(i-1)*1 shl 3,1 shl 3,dpos);
         dp^.ReadDisk(dp,bp^.Media^.MediaId,dpos,sizeof(tydqfs_file),rfsf);
         if(Wstrcmp(@rfsf.fname,partstr)=0) then 
          begin
           rpos:=dpos; bool:=true; break;
          end;
         inc(i);
        end;
       if(i>fsf.fContentCount shr 3) then 
        begin
         Wstrfree(partstr); bool:=false; break;
        end;
      end
     else 
      begin
       if(WstrCmpL(@fsf.fname,partstr)<>0) then bool:=false else bool:=true;
       Wstrfree(partstr); break;
      end;
    end;
   Wstrfree(partstr);
   pos1:=pos2;
  end;
 tydq_fs_file_exists:=bool;
end;
function tydq_fs_file_position(edl:efi_disk_list;diskindex:natuint;filename:PWideChar):qword;[public,alias:'TYDQ_FS_FILE_POSITION'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fsh:tydqfs_header;
    fsf,rfsf:tydqfs_file;
    i,pos1,pos2,len:natuint;
    cpos,res:qword;
    partstr:PWideChar;
begin 
 if(diskindex>edl.disk_count) then exit(0);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 pos1:=1; pos2:=2; res:=0; len:=Wstrlen(filename);
 if(filename=nil) then exit(0);
 if(WstrCmpL(filename,'/')=0) then exit(res);
 while(pos2>0) do
  begin
   pos2:=Wstrpos(filename,'/',pos1+1);
   if(pos2>0) then partstr:=Wstrcutout(filename,pos1+1,pos2-1) else partstr:=Wstrcutout(filename,pos1+1,len);
   if(pos1=1) then
    begin
     i:=1;
     while(i<=fsh.RootCount shr 3) do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1)*(1 shl 3),1 shl 3,cpos);
       dp^.ReadDisk(dp,bp^.Media^.MediaId,cpos,sizeof(tydqfs_file),fsf);
       if(WstrCmpL(@fsf.fname,partstr)=0) then 
        begin
         res:=cpos; break;
        end;
       inc(i);
      end;
     if(i>fsh.RootCount div sizeof(natuint)) then 
      begin
       Wstrfree(partstr);
       res:=0; break;
      end;
    end
   else if(pos1>1) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,res,sizeof(tydqfs_file),fsf);
     if(fsf.fmainclass=tydqfs_folder) and (fsf.fContentCount>0) then
      begin
       i:=1;
       while(i<=fsf.fContentCount shr 3) do
        begin
         dp^.ReadDisk(dp,bp^.Media^.MediaId,res+sizeof(tydqfs_file)+(i-1)*(1 shl 3),1 shl 3,cpos);
         dp^.ReadDisk(dp,bp^.Media^.MediaId,cpos,sizeof(tydqfs_file),rfsf);
         if(WstrCmp(@rfsf.fname,partstr)=0) then 
          begin
           res:=cpos; break;
          end;
         inc(i);
        end;
       if(i>fsf.fContentCount shr 3) then 
        begin
         Wstrfree(partstr);
         res:=0; break;
        end;
      end
     else
      begin
       if(WstrCmpL(@fsf.fname,partstr)<>0) then res:=0;
       Wstrfree(partstr); break;
      end;
    end;
   Wstrfree(partstr);
   pos1:=pos2;
  end;
 tydq_fs_file_position:=res;
end;
procedure tydq_fs_file_create(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;mainclass:dword;subclass:dword;userlevel:byte;hiddenlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_CREATE'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fsh:tydqfs_header;
    fsf,rfsf,pfsf:tydqfs_file;
    len,pos1,pos2,fpos,fpos1,fpos2,fpos3,rpos,i,j:natuint;
    prevpath,fname,partstr:PWideChar;
    gtime:efi_time;
    ctime:efi_time_capabilities;
begin
 if(diskindex>edl.disk_count) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 len:=Wstrlen(filename); 
 if(userlevel>hiddenlevel) then exit;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 SystemTable^.RuntimeServices^.GetTime(gtime,ctime);
 if(fpos<>0) then exit
 else
  begin
   pos1:=1;
   repeat
    begin
     pos2:=Wstrpos(filename,'/',pos1+1);
     prevpath:=Wstrcutout(filename,1,pos1-1);
     partstr:=Wstrcutout(filename,1,pos2-1);
     fname:=Wstrcutout(filename,pos1+1,pos2-1);
     fpos1:=tydq_fs_file_position(edl,diskindex,prevpath);
     fpos2:=tydq_fs_file_position(edl,diskindex,partstr);
     if(pos2=0) then
      begin
       if(prevpath=nil) then
        begin
         fsf:=tydq_fs_file_initialize(fname,gtime,fpos1,tydqfs_folder,tydqfs_folder_public,hiddenlevel,userlevel,belonguserindex);
         fpos3:=fsh.usedsize+1 shl 3;
         i:=sizeof(tydqfs_header)+fsh.RootCount;
         while(i<fsh.usedsize) do
          begin
           dp^.ReadDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),rfsf);
           if(rfsf.fparentpos>sizeof(tydqfs_header)+fsh.RootCount) then
            begin
             inc(rfsf.fparentpos,1 shl 3);
            end;
           if(rfsf.fmainclass=tydqfs_folder) then
            begin
             for j:=1 to rfsf.fContentCount shr 3 do
              begin
               dp^.ReadDisk(dp,bp^.Media^.MediaId,i+(j-1) shl 3,1 shl 3,rpos);
               if(rpos>=sizeof(tydqfs_header)+fsh.RootCount) then rpos:=rpos+1 shl 3;
               dp^.WriteDisk(dp,bp^.Media^.MediaId,i+(j-1) shl 3,1 shl 3,@rpos);
              end;
            end;
           dp^.WriteDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),@rfsf);
           inc(i,sizeof(tydqfs_file)+rfsf.fContentCount);
          end;
         tydq_fs_disk_move_right(edl,diskindex,sizeof(tydqfs_header)+fsh.RootCount,fsh.usedsize-1,1 shl 3);
         dp^.WriteDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+fsh.RootCount,1 shl 3,@fpos3);
         dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos3,sizeof(tydqfs_file),@fsf);
         fsh.usedsize:=fsh.usedsize+1 shl 3+sizeof(tydqfs_file);
         fsh.RootCount:=fsh.RootCount+1 shl 3;
         dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
        end
       else 
        begin
         if(fpos2=0) then
         fsf:=tydq_fs_file_initialize(fname,gtime,fpos1,mainclass,subclass,hiddenlevel,userlevel,belonguserindex)
         else if(fpos2>0) then
         fsf:=tydq_fs_file_initialize(fname,gtime,fpos1,tydqfs_folder,tydqfs_folder_public,hiddenlevel,userlevel,belonguserindex);
         dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos1,sizeof(tydqfs_file),pfsf);
         fpos3:=fsh.usedsize+1 shl 3;
         i:=fpos1+sizeof(tydqfs_file)+pfsf.fContentCount;
         while(i<fsh.usedsize) do
          begin
           dp^.ReadDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),rfsf);
           if(rfsf.fparentpos>fpos1+sizeof(tydqfs_file)+pfsf.fContentCount) then
            begin
             inc(rfsf.fparentpos,1 shl 3);
            end;
           if(rfsf.fmainclass=tydqfs_folder) then
            begin
             for j:=1 to rfsf.fContentCount shr 3 do
              begin
               dp^.ReadDisk(dp,bp^.Media^.MediaId,i+(j-1) shl 3,1 shl 3,rpos);
               if(rpos>=sizeof(tydqfs_header)+fsh.RootCount) then rpos:=rpos+1 shl 3;
               dp^.WriteDisk(dp,bp^.Media^.MediaId,i+(j-1) shl 3,1 shl 3,@rpos);
              end;
            end;
           dp^.WriteDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),@rfsf);
           inc(i,sizeof(tydqfs_file)+rfsf.fContentCount);
          end;
         tydq_fs_disk_move_right(edl,diskindex,fpos1+sizeof(tydqfs_file)+pfsf.fContentCount,fsh.usedsize-1,1 shl 3);
         dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos1+sizeof(tydqfs_file)+pfsf.fContentCount,1 shl 3,@fpos3);
         dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos3,sizeof(tydqfs_file),@fsf);
         fsh.usedsize:=fsh.usedsize+1 shl 3+sizeof(tydqfs_file);
         dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
         pfsf.fContentCount:=pfsf.fContentCount+1 shl 3;
         dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@pfsf);
        end;
      end;
     Wstrfree(fname); Wstrfree(prevpath);
     pos1:=pos2;
    end;
   until(pos2=0);
  end;
end;
function tydq_fs_file_list_item_to_path(edl:efi_disk_list;diskindex:natuint;position:natuint):PWideChar;[public,alias:'TYDQ_FS_FILE_LIST_ITEM_TO_PATH'];
var parentpos:^qword;
    parentcount:natuint;
    dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fsf:tydqfs_file;
    res:PWideChar;
    procnum,i,size,len:natuint;
begin
 if(diskindex>edl.disk_count) then exit(nil);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 parentpos:=nil; parentcount:=0; procnum:=position;
 repeat
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,procnum,sizeof(tydqfs_file),fsf);
   inc(parentcount,1);
   ReallocMem(parentpos,parentcount shl 3);
   (parentpos+parentcount-1)^:=procnum;
   procnum:=fsf.fparentpos;
  end;
 until(procnum=0);
 Wstrinit(res,1); res^:='/'; len:=1;
 for i:=parentcount downto 1 do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,(parentpos+i-1)^,sizeof(tydqfs_file),fsf);
   len:=len+Wstrlen(@fsf.fname);
   Wstrrealloc(res,len);
   Wstrcat(res,@fsf.fname);
  end;
 size:=getmemsize(parentpos); parentcount:=0;
 freemem(parentpos); res:=Pointer(Pointer(res)-size);
 tydq_fs_file_list_item_to_path:=res;
end;
function tydq_fs_file_list_item_to_path_ext(edl:efi_disk_list;diskindex:natuint;position:natuint):PWideChar;[public,alias:'TYDQ_FS_FILE_LIST_ITEM_TO_PATH_EXT'];
var parentpos:^qword;
    parentcount:natuint;
    dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fsh:tydqfs_header;
    fsf:tydqfs_file;
    res:PWideChar;
    procnum,i,size,len:natuint;
begin
 if(diskindex>edl.disk_count) then exit(nil);
 parentpos:=nil; parentcount:=0; procnum:=position;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 repeat
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,procnum,sizeof(tydqfs_file),fsf);
   inc(parentcount,1);
   ReallocMem(parentpos,parentcount shl 3);
   (parentpos+parentcount-1)^:=procnum;
   procnum:=fsf.fparentpos;
  end;
 until(procnum=0);
 len:=1; Wstrrealloc(res,1+Wstrlen(@fsh.RootName)); Wstrset(res,@fsh.RootName); Wstrcat(res,'/');
 for i:=parentcount downto 1 do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,(parentpos+i-1)^,sizeof(tydqfs_file),fsf);
   len:=len+Wstrlen(@fsf.fname);
   Wstrrealloc(res,len);
   Wstrcat(res,@fsf.fname);
  end;
 size:=getmemsize(parentpos); parentcount:=0;
 freemem(parentpos); res:=Pointer(Pointer(res)-size);
 tydq_fs_file_list_item_to_path_ext:=res;
end;
function tydq_fs_file_list_combine(filelist1,filelist2:tydqfs_file_list):tydqfs_file_list;[public,alias:'TYDQ_FS_FILE_LIST_COMBINE'];
var res:tydqfs_file_list;
    i:natuint;
begin
 res.file_list_fullpath:=allocmem((filelist1.file_list_count+filelist2.file_list_count) shl 3);
 res.file_list_count:=filelist1.file_list_count+filelist2.file_list_count;
 for i:=1 to filelist1.file_list_count do (res.file_list_fullpath+i-1)^:=(filelist1.file_list_fullpath+i-1)^;
 for i:=1 to filelist2.file_list_count do (res.file_list_fullpath+filelist1.file_list_count+i-1)^:=(filelist2.file_list_fullpath+i-1)^;
 tydq_fs_file_list_combine:=res;
end;
function tydq_fs_file_list(edl:efi_disk_list;diskindex:natuint;fileposition:qword;expanded:boolean;detecthidden:boolean;userlevel:byte;belonguserindex:qword):tydqfs_file_list;[public,alias:'TYDQ_FS_FILE_LIST'];
var res,procres:tydqfs_file_list;
    dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fsf,rfsf:tydqfs_file;
    size:natuint;
    ptr:Pointer;
    canadd:boolean;
    procnum,i:qword;
begin
 res.file_list_fullpath:=nil; res.file_list_count:=0;
 if(diskindex>edl.disk_count) or (diskindex=0) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fileposition,sizeof(tydqfs_file),fsf);
 res.file_list_fullpath:=allocmem(1 shl 3); 
 res.file_list_fullpath^:=fileposition;
 res.file_list_count:=1;
 for i:=1 to fsf.fContentCount shr 3 do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fileposition+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,procnum);
   dp^.ReadDisk(dp,bp^.Media^.MediaId,procnum,1 shl 3,rfsf);
   if(detecthidden=true) and (userlevel<=rfsf.fhidden) then canadd:=true
   else if(detecthidden=false) and (rfsf.fhidden>=tydqfs_hidden_none) then canadd:=true
   else canadd:=false; 
   if(canadd) then 
    begin
     inc(res.file_list_count,1);
     ReallocMem(res.file_list_fullpath,res.file_list_count shl 3);
     if(rfsf.fmainclass=tydqfs_folder) and (expanded=true) then
      begin
       procres:=tydq_fs_file_list(edl,diskindex,(res.file_list_fullpath+res.file_list_count-1)^,expanded,detecthidden,userlevel,belonguserindex);
       Ptr:=res.file_list_fullpath;
       size:=getmemsize(Ptr)+getmemsize(procres.file_list_fullpath);
       res:=tydq_fs_file_list_combine(res,procres);
       freemem(procres.file_list_fullpath); freemem(ptr);
       res.file_list_fullpath:=Pointer(Pointer(res.file_list_fullpath)-size);
      end
     else 
      begin
       (res.file_list_fullpath+res.file_list_count-1)^:=procnum;
      end;
    end;
  end;
 tydq_fs_file_list:=res;
end;
procedure tydq_fs_file_list_sort(edl:efi_disk_list;diskindex:natuint;var filelist:tydqfs_file_list;accordingtoname:boolean);[public,alias:'TYDQ_FS_FILE_LIST_SORT'];
var fsf1,fsf2:tydqfs_file;
    dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,j:natuint;
    bool:boolean;
begin 
 if(diskindex>edl.disk_count) or (diskindex=0) then exit;
 for i:=1 to filelist.file_list_count do
  begin
   bool:=false;
   for j:=i+1 to filelist.file_list_count do
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,(filelist.file_list_fullpath+i-1)^,sizeof(tydqfs_file),fsf1);
     dp^.ReadDisk(dp,bp^.Media^.MediaId,(filelist.file_list_fullpath+j-1)^,sizeof(tydqfs_file),fsf2);
     if(WstrCmp(@fsf1.fname,@fsf2.fname)>0) and (accordingtoname=true) then
      begin
       (filelist.file_list_fullpath+i-1)^:=(filelist.file_list_fullpath+i-1)^+(filelist.file_list_fullpath+j-1)^;
       (filelist.file_list_fullpath+j-1)^:=(filelist.file_list_fullpath+i-1)^-(filelist.file_list_fullpath+j-1)^;
       (filelist.file_list_fullpath+i-1)^:=(filelist.file_list_fullpath+i-1)^-(filelist.file_list_fullpath+j-1)^;
       bool:=true;
      end
     else if((filelist.file_list_fullpath+i-1)^>(filelist.file_list_fullpath+j-1)^) and (accordingtoname=false) then
      begin
       (filelist.file_list_fullpath+i-1)^:=(filelist.file_list_fullpath+i-1)^+(filelist.file_list_fullpath+j-1)^;
       (filelist.file_list_fullpath+j-1)^:=(filelist.file_list_fullpath+i-1)^-(filelist.file_list_fullpath+j-1)^;
       (filelist.file_list_fullpath+i-1)^:=(filelist.file_list_fullpath+i-1)^-(filelist.file_list_fullpath+j-1)^;
       bool:=true;
      end;
    end;
   if(bool=false) then break;
  end;
end;
procedure tydq_fs_file_delete(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:natuint);[public,alias:'TYDQ_FS_FILE_DELETE'];
var dellist:tydqfs_file_list;
    dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos,rpos:qword;
    fsf,rfsf,pfsf,sfsf:tydqfs_file;
    fsh:tydqfs_header;
    i,j,k,m,n:natuint;
begin
 if(diskindex>edl.disk_count) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename); 
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 dellist:=tydq_fs_file_list(edl,diskindex,fpos,true,true,userlevel,belonguserindex);
 for i:=1 to dellist.file_list_count do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,(dellist.file_list_fullpath+i-1)^,sizeof(tydqfs_file),fsf);
   if(fsf.fuserlevel<userlevel) then
    begin
     freemem(dellist.file_list_fullpath); dellist.file_list_count:=0;
    end
   else if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then
    begin
     freemem(dellist.file_list_fullpath); dellist.file_list_count:=0;
    end;
  end;
 tydq_fs_file_list_sort(edl,diskindex,dellist,false);
 for i:=dellist.file_list_count downto 1 do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,(dellist.file_list_fullpath+i-1)^,sizeof(tydqfs_file),pfsf);
   if(pfsf.fparentpos=0) then
    begin
     for j:=1 to fsh.RootCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(j-1) shl 3,1 shl 3,rpos);
       if(rpos>=(dellist.file_list_fullpath+i-1)^+sizeof(tydqfs_file)+pfsf.fContentCount) then rpos:=rpos-sizeof(tydqfs_file)-pfsf.fContentCount-1 shl 3;
       if(rpos=(dellist.file_list_fullpath+i-1)^) then k:=j;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(j-1) shl 3,1 shl 3,@rpos);
      end;
     m:=(dellist.file_list_fullpath+i-1)^+sizeof(tydqfs_file)+pfsf.fContentCount;
     while(m<fsh.usedsize) do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,m,sizeof(tydqfs_file),sfsf);
       if(sfsf.fparentpos>=(dellist.file_list_fullpath+i-1)^+sizeof(tydqfs_file)+pfsf.fContentCount) then
        begin
         sfsf.fparentpos:=sfsf.fparentpos-sizeof(tydqfs_file)-pfsf.fContentCount;
        end;
       if(sfsf.fmainclass=tydqfs_folder) then
        begin
         for n:=1 to sfsf.fContentCount shr 3 do
          begin
           dp^.ReadDisk(dp,bp^.Media^.MediaId,m+sizeof(tydqfs_file)+(n-1) shl 3,1 shl 3,rpos);
           rpos:=rpos-pfsf.fContentCount-sizeof(tydqfs_file)-1 shl 3;
           dp^.WriteDisk(dp,bp^.Media^.MediaId,m+sizeof(tydqfs_file)+(n-1) shl 3,1 shl 3,@rpos);
          end;
        end;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,m,sizeof(tydqfs_file),@sfsf);
       inc(m,sizeof(tydqfs_file)+sfsf.fContentCount);
      end;
     tydq_fs_disk_move_left(edl,diskindex,(dellist.file_list_fullpath+i-1)^+sizeof(tydqfs_file)+pfsf.fContentCount,fsh.usedsize-1,sizeof(tydqfs_file)+pfsf.fContentCount);
     tydq_fs_disk_move_left(edl,diskindex,sizeof(tydqfs_header)+k shl 3,fsh.usedsize-1,1 shl 3);
    end
   else 
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,pfsf.fparentpos,sizeof(tydqfs_file),rfsf);
     for j:=1 to rfsf.fContentCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,pfsf.fparentpos+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,rpos);
       if(rpos>=(dellist.file_list_fullpath+i-1)^+sizeof(tydqfs_file)+pfsf.fContentCount) then rpos:=rpos-sizeof(tydqfs_file)-pfsf.fContentCount-1 shl 3;
       if(rpos=(dellist.file_list_fullpath+i-1)^) then k:=j;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,pfsf.fparentpos+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,@rpos);
      end;
     m:=(dellist.file_list_fullpath+i-1)^+sizeof(tydqfs_file)+pfsf.fContentCount;
     while(m<fsh.usedsize) do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,m,sizeof(tydqfs_file),sfsf);
       if(sfsf.fparentpos>=(dellist.file_list_fullpath+i-1)^+sizeof(tydqfs_file)+pfsf.fContentCount) then
        begin
         sfsf.fparentpos:=sfsf.fparentpos-sizeof(tydqfs_file)-pfsf.fContentCount;
        end;
       if(sfsf.fmainclass=tydqfs_folder) then
        begin
         for n:=1 to sfsf.fContentCount shr 3 do
          begin
           dp^.ReadDisk(dp,bp^.Media^.MediaId,m+sizeof(tydqfs_file)+(n-1) shl 3,1 shl 3,rpos);
           rpos:=rpos-pfsf.fContentCount-sizeof(tydqfs_file)-1 shl 3;
           dp^.WriteDisk(dp,bp^.Media^.MediaId,m+sizeof(tydqfs_file)+(n-1) shl 3,1 shl 3,@rpos);
          end;
        end;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,m,sizeof(tydqfs_file),@sfsf);
       inc(m,sizeof(tydqfs_file)+sfsf.fContentCount);
      end;
     tydq_fs_disk_move_left(edl,diskindex,(dellist.file_list_fullpath+i-1)^+sizeof(tydqfs_file)+pfsf.fContentCount,fsh.usedsize-1,sizeof(tydqfs_file)+pfsf.fContentCount);
     tydq_fs_disk_move_left(edl,diskindex,sizeof(tydqfs_header)+k shl 3,fsh.usedsize-1,1 shl 3);
    end;
   fsh.usedsize:=fsh.usedsize-sizeof(tydqfs_file)-pfsf.fContentCount-1 shl 3;
   dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
   if(pfsf.fparentpos>0) then dp^.ReadDisk(dp,bp^.Media^.MediaId,pfsf.fparentpos,sizeof(tydqfs_file),rfsf);
   for j:=1 to i-1 do (dellist.file_list_fullpath+j-1)^:=(dellist.file_list_fullpath+j-1)^-1 shl 3;
  end;
 freemem(dellist.file_list_fullpath); dellist.file_list_count:=0;
end;
procedure tydq_fs_file_set_attribute(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;mainclass:dword;subclass:dword;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_ATTRIBUTE_SET'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos:qword;
    fsf:tydqfs_file;
begin
 if(diskindex>edl.disk_count) or (diskindex=0) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 fsf.fmainclass:=mainclass; fsf.fsubclass:=subclass;
 dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),@fsf);
end;
function tydq_fs_file_info(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword):tydqfs_file;[public,alias:'TYDQ_FS_FILE_INFO'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos:qword;
    res:tydqfs_file;
begin
 if(diskindex>edl.disk_count) then 
  begin
   res.fname[1]:=#0; exit(res);
  end;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then 
  begin
   res.fname[1]:=#0; exit(res);
  end;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),res);
 if(res.fuserlevel<userlevel) then
  begin
   res.fname[1]:=#0; exit(res);
  end
 else if(res.fuserlevel=userlevel) and (res.fbelonguserindex<>belonguserindex) then
  begin
   res.fname[1]:=#0; exit(res);
  end
 else
  begin
   res.fname[1]:=#0; exit(res);
  end;
 tydq_fs_file_info:=res;
end;
function tydq_fs_file_read_data(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword):tydqfs_data;[public,alias:'TYDQ_FS_FILE_READ_DATA'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,fpos,fppos:qword;
    fsf:tydqfs_file;
    res:tydqfs_data;
begin
 res.fsdata:=nil; res.fssize:=0;
 if(diskindex>edl.disk_count) then exit(res);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit(res);
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit(res);
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 fppos:=fpos+sizeof(tydqfs_file);
 for i:=1 to fsf.fContentCount do
  begin
   ReallocMem(res.fsdata,i); inc(res.fssize);
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+(i-1),1,(res.fsdata+i-1)^);
  end;
 tydq_fs_file_read_data:=res;
end;
function tydq_fs_file_read_data_ext(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;ReadPosition,ReadLength:qword;userlevel:byte;belonguserindex:qword):tydqfs_data;[public,alias:'TYDQ_FS_FILE_READ_DATA_EXT'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,Readstart,Readend,fpos,fppos:qword;
    fsf:tydqfs_file;
    res:tydqfs_data;
begin
 res.fsdata:=nil; res.fssize:=0;
 if(diskindex>edl.disk_count) then exit(res);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit(res);
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit(res);
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit(res);
 fppos:=fpos+sizeof(tydqfs_file);
 ReadStart:=ReadPosition; 
 if(ReadPosition+ReadLength-1>=fsf.fContentCount) then ReadEnd:=fsf.fContentCount else ReadEnd:=ReadPosition+ReadLength-1;
 for i:=ReadStart to ReadEnd do
  begin
   inc(res.fssize);
   ReallocMem(res.fsdata,res.fssize);
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+(i-1),1,(res.fsdata+res.fssize-1)^);
  end;
 tydq_fs_file_read_data_ext:=res;
end;
procedure tydq_fs_file_write_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;writeposition:qword;writedata:Pointer;writesize:qword;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_WRITE_DATA'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos,fppos,increasesize,i,j,rpos:qword;
    fsh:tydqfs_header;
    fsf,rfsf:tydqfs_file;
    gtime:efi_time;
    ctime:efi_time_capabilities;
begin
 if(diskindex>edl.disk_count) or (diskindex=0) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_file),fsh);
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
fppos:=fpos+sizeof(tydqfs_file);
 SystemTable^.RuntimeServices^.GetTime(gtime,ctime);
 if(writeposition+writesize-1>fsf.fContentCount) then increasesize:=writeposition+writesize-1-fsf.fContentCount else increasesize:=0;
 if(increasesize>0) then
  begin
   if(fsf.fparentpos=0) then
    begin
     for i:=1 to fsh.RootCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,rpos);
       if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+increasesize;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,@rpos);
      end;
    end
   else if(fsf.fparentpos>0) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos,sizeof(tydqfs_file),rfsf);
     for i:=1 to rfsf.fContentCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,rpos);
       if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+increasesize;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,@rpos);
      end;
    end;
   i:=fppos+fsf.fContentCount;
   while(i<fsh.usedsize) do
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),rfsf);
     if(rfsf.fparentpos>=fppos+fsf.fContentCount) then rfsf.fparentpos:=rfsf.fparentpos+increasesize;
     if(rfsf.fmainclass=tydqfs_folder) then
      begin 
       for j:=1 to rfsf.fContentCount shr 3 do
        begin
         dp^.ReadDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,rpos);
         rpos:=rpos+increasesize;
         dp^.WriteDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,@rpos);
        end;
      end;
     dp^.WriteDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),@rfsf);
     inc(i,sizeof(tydqfs_file)+rfsf.fContentCount);
    end;
   tydq_fs_disk_move_right(edl,diskindex,fppos+fsf.fContentCount,fsh.usedsize-1,increasesize);
   dp^.WriteDisk(dp,bp^.Media^.MediaId,fppos+writeposition,writesize,writedata);
   fsf.fContentCount:=fsf.fContentCount+increasesize;
   fsf.flastedittime:=efi_time_to_tydq_fs_time(gtime);
   dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),@fsf);
   fsh.usedsize:=fsh.usedsize+increasesize;
   dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
  end
 else 
  begin
   dp^.WriteDisk(dp,bp^.Media^.MediaId,fppos+writeposition,writesize,writedata);
   fsf.flastedittime:=efi_time_to_tydq_fs_time(gtime);
   dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),@fsf);
  end;
end;
procedure 
tydq_fs_file_rewrite_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;writedata:Pointer;writesize:qword;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_REWRITE_DATA'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos,fppos,rpos,i,j:qword;
    altersize:int64;
    fsh:tydqfs_header;
    fsf,rfsf:tydqfs_file;
    gtime:efi_time;
    ctime:efi_time_capabilities;
begin
 if(diskindex>edl.disk_count) or (diskindex=0) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_file),fsh);
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 SystemTable^.RuntimeServices^.GetTime(gtime,ctime);
 fppos:=fpos+sizeof(tydqfs_file); altersize:=writesize-fsf.fContentCount;
 if(altersize<>0) then
  begin
   if(fsf.fparentpos=0) then
    begin
     for i:=1 to fsh.RootCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,rpos);
       if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+altersize;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,@rpos);
      end;
    end
   else
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos,sizeof(tydqfs_file),rfsf);
     for i:=1 to rfsf.fContentCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,rpos);
       if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+altersize;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,@rpos);
      end;
    end;
   i:=fppos+fsf.fContentCount;
   while(i<fsh.usedsize) do
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),rfsf);
     if(rfsf.fparentpos>=fppos+fsf.fContentCount) then rfsf.fparentpos:=rfsf.fparentpos+altersize;
     if(rfsf.fmainclass=tydqfs_folder) then
      begin
       for j:=1 to rfsf.fContentCount shr 3 do
        begin
         dp^.ReadDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,rpos);
         if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+altersize;
         dp^.WriteDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,@rpos);
        end;
      end;
     dp^.WriteDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),@rfsf);
     inc(i,sizeof(tydqfs_file)+rfsf.fContentCount);
    end;
   if(altersize>0) then tydq_fs_disk_move_right(edl,diskindex,fppos+fsf.fContentCount,fsh.usedsize-1,altersize)
   else tydq_fs_disk_move_left(edl,diskindex,fppos+fsf.fContentCount,fsh.usedsize-1,-altersize);
   dp^.WriteDisk(dp,bp^.Media^.MediaId,fppos,writesize,writedata);
   fsf.fContentCount:=fsf.fContentCount+altersize;
   fsf.flastedittime:=efi_time_to_tydq_fs_time(gtime);
   dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),@fsf);
   fsh.usedsize:=fsh.usedsize+altersize;
   dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
  end
 else 
  begin
   dp^.WriteDisk(dp,bp^.Media^.MediaId,fppos,writesize,writedata);
   fsf.flastedittime:=efi_time_to_tydq_fs_time(gtime);
   dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),@fsf);
  end;
end;
procedure tydq_fs_file_resize_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;destinationsize:qword;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_RESIZE_DATA'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos,fppos,rpos,i,j:qword;
    zero:byte;
    altersize:int64;
    fsh:tydqfs_header;
    fsf,rfsf:tydqfs_file;
    gtime:efi_time;
    ctime:efi_time_capabilities;
begin
 if(diskindex>edl.disk_count) or (diskindex=0) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 SystemTable^.RuntimeServices^.GetTime(gtime,ctime);
 fppos:=fpos+sizeof(tydqfs_file); altersize:=destinationsize-fsf.fContentCount;
 if(altersize<>0) then
  begin
   if(fsf.fparentpos=0) then
    begin
     for i:=1 to fsf.fContentCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,rpos);
       if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+altersize;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,@rpos);
      end;
    end
   else
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos,sizeof(tydqfs_file),rfsf);
     for i:=1 to rfsf.fContentCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,rpos);
       if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+altersize;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,@rpos);
      end;
    end;
   i:=fppos+fsf.fContentCount;
   while(i<fsh.usedsize) do
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),rfsf);
     if(rfsf.fparentpos>=fppos+fsf.fContentCount) then rfsf.fparentpos:=rfsf.fparentpos+altersize;
     if(rfsf.fmainclass=tydqfs_folder) then
      begin
       for j:=1 to rfsf.fContentCount shr 3 do
        begin
         dp^.ReadDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,rpos);
         if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+altersize;
         dp^.WriteDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,@rpos);
        end;
      end;
     dp^.WriteDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),@rfsf);
     inc(i,sizeof(tydqfs_file)+rfsf.fContentCount);
    end;
   if(altersize>0) then 
    begin
     tydq_fs_disk_move_right(edl,diskindex,fppos+fsf.fContentCount,fsh.usedsize-1,altersize);
     zero:=0;
     for i:=1 to altersize do
      begin
       dp^.WriteDisk(dp,bp^.Media^.MediaId,fppos+fsf.fContentCount+i-1,sizeof(byte),@zero);
      end;
    end
   else tydq_fs_disk_move_left(edl,diskindex,fppos+fsf.fContentCount,fsh.usedsize-1,-altersize);
   fsf.fContentCount:=fsf.fContentCount+altersize;
   fsf.flastedittime:=efi_time_to_tydq_fs_time(gtime);
   dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),@fsf);
   fsh.usedsize:=fsh.usedsize+altersize;
   dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
  end;
end;
procedure tydq_fs_file_insert_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;insertpos:qword;insertdata:Pointer;insertsize:qword;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_INSERT_DATA'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,j,fpos,fppos,rpos:natuint;
    fsh:tydqfs_header;
    fsf,rfsf:tydqfs_file;
    gtime:efi_time;
    ctime:efi_time_capabilities;
begin
 if(diskindex>edl.disk_count) or (diskindex=0) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 if(insertsize=0) then exit;
 if(insertpos>fsf.fContentCount+1) or (insertpos=0) then exit;
 SystemTable^.RuntimeServices^.GetTime(gtime,ctime);
 fppos:=fpos+sizeof(tydqfs_file);
 if(fsf.fparentpos=0) then
  begin
   for i:=1 to fsh.RootCount shr 3 do 
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,rpos);
     if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+insertsize;
     dp^.WriteDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,@rpos);
    end;
  end
 else if(fsf.fparentpos>0) then 
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos,sizeof(tydqfs_file),rfsf);
   for i:=1 to rfsf.fContentCount shr 3 do
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,rpos);
     if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+insertsize;
     dp^.WriteDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,@rpos);
    end;
  end;
 i:=fppos+fsf.fContentCount;
 while(i<fsh.usedsize) do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),rfsf);
   if(rfsf.fparentpos>=fppos+fsf.fContentCount) then inc(rfsf.fparentpos,insertsize);
   if(rfsf.fmainclass=tydqfs_folder) then
    begin
     for j:=1 to rfsf.fContentCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,rpos);
       if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos+insertsize;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,@rpos);
      end;
    end;
   dp^.WriteDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),@rfsf);
   inc(i,sizeof(tydqfs_file)+rfsf.fContentCount);
  end;
 tydq_fs_disk_move_right(edl,diskindex,fppos+insertpos,fsh.usedsize-1,insertsize);
 dp^.WriteDisk(dp,bp^.Media^.MediaId,fppos+insertpos,insertsize,insertdata);
 fsf.flastedittime:=efi_time_to_tydq_fs_time(gtime);
 inc(fsf.fContentCount,insertsize);
 dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),@fsf);
 inc(fsh.usedsize,insertsize);
 dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
end;
procedure tydq_fs_file_delete_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;deletepos,deletesize:qword;userlevel:byte;belonguserindex:natuint);[public,alias:'TYDQ_FS_FILE_DELETE_DATA'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fsh:tydqfs_header;
    i,j,fpos,fppos,rpos:qword;
    fsf,rfsf:tydqfs_file;
    adjust_deletesize:qword;
    gtime:efi_time;
    ctime:efi_time_capabilities;
begin
 if(diskindex>edl.disk_count) or (diskindex=0) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 if(deletesize=0) then exit;
 if(deletepos=0) or (deletepos>fsf.fContentCount) then exit;
 SystemTable^.RuntimeServices^.GetTime(gtime,ctime);
 fppos:=fpos+sizeof(tydqfs_file);
 if(deletepos+deletesize-1>fsf.fContentCount) then adjust_deletesize:=fsf.fContentCount-deletepos+1 else adjust_deletesize:=deletesize;
 if(fsf.fparentpos=0) then 
  begin
   for i:=1 to fsh.RootCount shr 3 do
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,rpos);
     if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos-adjust_deletesize;
     dp^.WriteDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,@rpos);
    end;
  end
 else if(fsf.fparentpos>0) then
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos,sizeof(tydqfs_file),rfsf);
   for i:=1 to rfsf.fContentCount shr 3 do
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,rpos);
     if(rpos>=fppos+fsf.fContentCount) then rpos:=rpos-adjust_deletesize;
     dp^.WriteDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,@rpos);
    end;
  end;
 i:=fppos+fsf.fContentCount;
 while(i<fsh.usedsize) do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),rfsf);
   if(rfsf.fparentpos>=fppos+fsf.fContentCount) then dec(rfsf.fparentpos,adjust_deletesize);
   if(rfsf.fmainclass=tydqfs_folder) then
    begin
     for j:=1 to rfsf.fContentCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,rpos);
       rpos:=rpos-adjust_deletesize;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,@rpos);
      end;
    end;
   dp^.WriteDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),@rfsf);
   inc(i,sizeof(tydqfs_file)+rfsf.fContentCount);
  end;
 tydq_fs_disk_move_left(edl,diskindex,fppos+deletepos+deletesize-1,fsh.usedsize-1,adjust_deletesize);
 fsf.flastedittime:=efi_time_to_tydq_fs_time(gtime);
 dec(fsf.fContentCount,adjust_deletesize);
 dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),@fsf);
 dec(fsh.usedsize,adjust_deletesize);
 dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
end;
procedure tydq_fs_file_clear_data(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_CLEAR_DATA'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fsh:tydqfs_header;
    fsf,rfsf:tydqfs_file;
    i,j,fpos,fppos,rpos:qword;
    gtime:efi_time;
    ctime:efi_time_capabilities;
begin
 if(diskindex>edl.disk_count) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),fsh);
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex=belonguserindex) then exit;
 SystemTable^.RuntimeServices^.GetTime(gtime,ctime);
 fppos:=fpos+sizeof(tydqfs_file);
 if(fsf.fparentpos=0) then
  begin
   for i:=1 to fsh.RootCount shr 3 do
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,rpos);
     if(rpos>=fppos+fsf.fContentCount) then dec(rpos,fsf.fContentCount);
     dp^.WriteDisk(dp,bp^.Media^.MediaId,sizeof(tydqfs_header)+(i-1) shl 3,1 shl 3,@rpos);
    end;
  end
 else if(fsf.fparentpos>0) then 
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos,sizeof(tydqfs_file),rfsf);
   for i:=1 to rfsf.fContentCount shr 3 do
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,rpos);
     if(rpos>=fppos+fsf.fContentCount) then dec(rpos,fsf.fContentCount);
     dp^.WriteDisk(dp,bp^.Media^.MediaId,fsf.fparentpos+sizeof(tydqfs_file)+(i-1) shl 3,1 shl 3,@rpos);
    end;
  end;
 i:=fppos+fsf.fContentCount;
 while(i<fsh.usedsize) do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),rfsf);
   if(rfsf.fparentpos>=fppos+fsf.fContentCount) then dec(rfsf.fparentpos,fsf.fContentCount);
   if(rfsf.fmainclass=tydqfs_folder) then 
    begin
     for j:=1 to rfsf.fContentCount shr 3 do
      begin
       dp^.ReadDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,rpos);
       rpos:=rpos-fsf.fContentCount;
       dp^.WriteDisk(dp,bp^.Media^.MediaId,i+sizeof(tydqfs_file)+(j-1) shl 3,1 shl 3,@rpos);
      end;
    end;
   dp^.WriteDisk(dp,bp^.Media^.MediaId,i,sizeof(tydqfs_file),@rfsf);
   inc(i,sizeof(tydqfs_file)+rfsf.fContentCount);
  end;
 tydq_fs_disk_move_left(edl,diskindex,fppos+fsf.fContentCount,fsh.usedsize-1,fsf.fContentCount);
 dec(fsh.usedsize,fsf.fContentCount);
 dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(tydqfs_header),@fsh);
 fsf.flastedittime:=efi_time_to_tydq_fs_time(gtime);
 fsf.fContentCount:=0;
 dp^.WriteDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_header),@fsf);
end;
function tydq_fs_file_read_string_line_count(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword):qword;[public,alias:'TYDQ_FS_FILE_READ_STRING_LINE_COUNT'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,fpos,fppos:qword;
    fsf:tydqfs_file;
    fchar:array[1..2] of Char;
    res:qword;
begin
 if(diskindex>edl.disk_count) then exit(0);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit(0);
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit(0);
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit(0);
 if(fsf.fmainclass<>tydqfs_text_file) then exit(0);
 fppos:=fpos+sizeof(tydqfs_file); i:=1; fchar[1]:=#0; fchar[2]:=#0; res:=1;
 while(i<=fsf.fContentCount) do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i-1,sizeof(Char),fchar[1]);
   if(fchar[1]=#13) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i,sizeof(Char),fchar[2]);
     if(fchar[2]=#10) then 
      begin
       inc(res,1); inc(i,2);
      end
     else 
      begin
       inc(res,1); inc(i,1);
      end;
    end
   else if(fchar[1]<>#0) then
    begin 
     if(fchar[1]=#10) then inc(res,1);
     inc(i,1);
    end
   else break;
  end;
 tydq_fs_file_read_string_line_count:=res;
end;
function tydq_fs_file_read_wstring_line_count(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;userlevel:byte;belonguserindex:qword):qword;[public,alias:'TYDQ_FS_FILE_READ_WSTRING_LINE_COUNT'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,fpos,fppos:qword;
    fsf:tydqfs_file;
    fwchar:array[1..2] of WideChar;
    res:qword;
begin
 if(diskindex>edl.disk_count) then exit(0);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit(0);
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fuserlevel<userlevel) then exit(0);
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit(0);
 if(fsf.fmainclass<>tydqfs_text_file) then exit(0);
 fppos:=fpos+sizeof(tydqfs_file); i:=1; fwchar[1]:=#0; fwchar[2]:=#0; res:=1;
 while(i<=fsf.fContentCount shr 1) do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+(i-1) shl 1,sizeof(WideChar),fwchar[1]);
   if(fwchar[1]=#13) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i shl 1,sizeof(WideChar),fwchar[2]);
     if(fwchar[2]=#10) then 
      begin
       inc(res,1); inc(i,2);
      end
     else 
      begin
       inc(res,1); inc(i,1);
      end;
    end
   else if(fwchar[1]<>#0) then
    begin 
     if(fwchar[1]=#10) then inc(res,1);
     inc(i,1);
    end
   else break;
  end;
 tydq_fs_file_read_wstring_line_count:=res;
end;
function tydq_fs_file_read_string_line(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;userlevel:byte;belonguserindex:qword):PChar;[public,alias:'TYDQ_FS_FILE_READ_STRING_LINE'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,fppos,fpos,maxline,currentline,len:qword;
    fsf:tydqfs_file;
    fchar:array[1..2] of char;
    res:PChar;
begin
 if(diskindex>edl.disk_Count) then exit(nil);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit(nil);
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fmainclass<>tydqfs_text_file) then exit;
 if(fsf.fuserlevel<userlevel) then exit(nil);
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit(nil);
 maxline:=tydq_fs_file_read_string_line_count(edl,diskindex,filename,userlevel,belonguserindex); currentline:=1; len:=0;
 if(lineindex=0) or (lineindex>maxline) then exit(nil);
 i:=1; fppos:=fpos+sizeof(tydqfs_file); res:=nil;
 while(i<=fsf.fContentCount) do
  begin 
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i-1,sizeof(char),fchar[1]);
   if(fchar[1]=#13) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i,sizeof(char),fchar[2]);
     if(fchar[2]=#10) and (currentline<lineindex) then
      begin
       inc(i,2); inc(currentline,1);
      end
     else if(currentline<lineindex) then
      begin
       inc(i,1); inc(currentline,1);
      end
     else break;
    end
   else if(fchar[1]<>#0) then
    begin
     if(fchar[1]=#10) and (currentline<lineindex) then inc(currentline,1) else if(fchar[1]=#10) then break; 
     if(currentline=lineindex) then
      begin
       inc(len);
       strrealloc(res,len);
       (res+len-1)^:=fchar[1];
      end;
     inc(i,1);
    end
   else break;
  end;
 tydq_fs_file_read_string_line:=res;
end;
function tydq_fs_file_read_Wstring_line(edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;userlevel:byte;belonguserindex:qword):PWideChar;[public,alias:'TYDQ_FS_FILE_READ_WSTRING_LINE'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    i,fppos,fpos,maxline,currentline,len:qword;
    fsf:tydqfs_file;
    fwchar:array[1..2] of Widechar;
    res:PWideChar;
begin
 if(diskindex>edl.disk_Count) then exit(nil);
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit(nil);
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fmainclass<>tydqfs_text_file) then exit;
 if(fsf.fuserlevel<userlevel) then exit(nil);
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit(nil);
 maxline:=tydq_fs_file_read_Wstring_line_count(edl,diskindex,filename,userlevel,belonguserindex); currentline:=1; len:=0;
 if(lineindex=0) or (lineindex>maxline) then exit(nil);
 i:=1; fppos:=fpos+sizeof(tydqfs_file); res:=nil;
 while(i<=fsf.fContentCount shr 1) do
  begin 
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+(i-1) shl 1,sizeof(Widechar),fwchar[1]);
   if(fwchar[1]=#13) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i shl 1,sizeof(Widechar),fwchar[2]);
     if(fwchar[2]=#10) and (currentline<lineindex) then
      begin
       inc(i,2); inc(currentline,1);
      end
     else if(currentline<lineindex) then
      begin
       inc(i,1); inc(currentline,1);
      end
     else break;
    end
   else if(fwchar[1]<>#0) then
    begin
     if(fwchar[1]=#10) and (currentline<lineindex) then inc(currentline,1) else if(fwchar[1]=#10) then break; 
     if(currentline=lineindex) then
      begin
       inc(len);
       Wstrrealloc(res,len);
       (res+len-1)^:=fwchar[1];
      end;
     inc(i,1);
    end
   else break;
  end;
 tydq_fs_file_read_Wstring_line:=res;
end;
procedure tydq_fs_file_write_string(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;writestr:PChar;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_WRITE_STRING'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos,fppos,i,currentline,cpos,clen,len:qword;
    fchar:array[1..2] of char;
    fsf:tydqfs_file;
begin
 if(diskindex>edl.disk_count) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fmainclass<>tydqfs_text_file) then exit;
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 if(writestr=nil) then exit;
 fppos:=fpos+sizeof(tydqfs_file); currentline:=1; i:=1; cpos:=0; clen:=0;
 while(i<=fsf.fContentCount) do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i-1,sizeof(char),fchar[1]);
   if(fchar[1]=#13) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i,sizeof(char),fchar[2]);
     if(fchar[2]=#10) and (currentline<lineindex) then
      begin
       inc(i,2); inc(currentline,1);
      end
     else if(currentline<lineindex) then 
      begin
       inc(i,1); inc(currentline,1);
      end
     else break;
    end
   else if(fchar[1]<>#0) then
    begin
     if(fchar[1]=#10) and (currentline<lineindex) then inc(currentline,1) else if(fchar[1]=#10) then break;
     if(currentline=lineindex) then
      begin
       if(cpos=0) then cpos:=i;
       inc(clen);
      end;
    end
   else break;
  end;
 len:=strlen(writestr);
 if(cpos>0) then
  begin
   tydq_fs_file_delete_data(systemtable,edl,diskindex,filename,cpos,clen,userlevel,belonguserindex);
   tydq_fs_file_insert_data(systemtable,edl,diskindex,filename,cpos,writestr,len,userlevel,belonguserindex);
  end;
end;
procedure tydq_fs_file_write_wstring(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;writestr:PWideChar;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_WRITE_WSTRING'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos,fppos,i,currentline,cpos,clen,len:qword;
    fwchar:array[1..2] of Widechar;
    fsf:tydqfs_file;
begin
 if(diskindex>edl.disk_count) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fmainclass<>tydqfs_text_file) then exit;
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 if(writestr=nil) then exit;
 fppos:=fpos+sizeof(tydqfs_file); currentline:=1; i:=1; cpos:=0; clen:=0;
 while(i<=fsf.fContentCount shr 1) do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+(i-1) shl 1,sizeof(Widechar),fwchar[1]);
   if(fwchar[1]=#13) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i shl 1,sizeof(Widechar),fwchar[2]);
     if(fwchar[2]=#10) and (currentline<lineindex) then
      begin
       inc(i,2); inc(currentline,1);
      end
     else if(currentline<lineindex) then 
      begin
       inc(i,1); inc(currentline,1);
      end
     else break;
    end
   else if(fwchar[1]<>#0) then
    begin
     if(fwchar[1]=#10) and (currentline<lineindex) then inc(currentline,1) else if(fwchar[1]=#10) then break;
     if(currentline=lineindex) then
      begin
       if(cpos=0) then cpos:=i;
       inc(clen);
      end;
    end
   else break;
  end;
 len:=Wstrlen(writestr);
 if(cpos>0) then
  begin
   tydq_fs_file_delete_data(systemtable,edl,diskindex,filename,cpos shl 1-1,clen shl 1,userlevel,belonguserindex);
   tydq_fs_file_insert_data(systemtable,edl,diskindex,filename,cpos shl 1-1,writestr,len shl 1,userlevel,belonguserindex);
  end;
end;
procedure tydq_fs_file_delete_string(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_DELETE_STRING'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos,fppos,i,currentline,cpos,clen,len:qword;
    fchar:array[1..2] of char;
    fsf:tydqfs_file;
begin
 if(diskindex>edl.disk_count) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fmainclass<>tydqfs_text_file) then exit;
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 fppos:=fpos+sizeof(tydqfs_file); currentline:=1; i:=1; cpos:=0; clen:=0;
 while(i<=fsf.fContentCount) do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i-1,sizeof(char),fchar[1]);
   if(fchar[1]=#13) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i,sizeof(char),fchar[2]);
     if(fchar[2]=#10) and (currentline<lineindex) then 
      begin
       inc(i,2); inc(currentline,1);
      end
     else if(currentline<lineindex) then 
      begin
       inc(i,1); inc(currentline,1);
      end
     else break;
    end
   else if(fchar[1]<>#0) then
    begin
     if(fchar[1]=#10) and (currentline<lineindex) then inc(currentline,1) else if(fchar[1]=#10) then break;
     if(currentline=lineindex) then
      begin
       if(cpos=0) then cpos:=i;
       inc(clen);
      end;
    end
   else break;
  end;
 if(currentline=1) then tydq_fs_file_delete_data(systemtable,edl,diskindex,filename,cpos,clen,userlevel,belonguserindex)
 else if(currentline>1) then tydq_fs_file_delete_data(systemtable,edl,diskindex,filename,cpos-1,clen,userlevel,belonguserindex);
end;
procedure tydq_fs_file_delete_wstring(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint;filename:PWideChar;lineindex:qword;userlevel:byte;belonguserindex:qword);[public,alias:'TYDQ_FS_FILE_DELETE_WSTRING'];
var dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
    fpos,fppos,i,currentline,cpos,clen,len:qword;
    fwchar:array[1..2] of Widechar;
    fsf:tydqfs_file;
begin
 if(diskindex>edl.disk_count) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 fpos:=tydq_fs_file_position(edl,diskindex,filename);
 if(fpos=0) then exit;
 dp^.ReadDisk(dp,bp^.Media^.MediaId,fpos,sizeof(tydqfs_file),fsf);
 if(fsf.fmainclass<>tydqfs_text_file) then exit;
 if(fsf.fuserlevel<userlevel) then exit;
 if(fsf.fuserlevel=userlevel) and (fsf.fbelonguserindex<>belonguserindex) then exit;
 fppos:=fpos+sizeof(tydqfs_file); currentline:=1; i:=1; cpos:=0; clen:=0;
 while(i<=fsf.fContentCount shr 1) do
  begin
   dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+(i-1) shl 1,sizeof(Widechar),fwchar[1]);
   if(fwchar[1]=#13) then
    begin
     dp^.ReadDisk(dp,bp^.Media^.MediaId,fppos+i shl 1,sizeof(Widechar),fwchar[2]);
     if(fwchar[2]=#10) and (currentline<lineindex) then
      begin
       inc(i,2); inc(currentline,1);
      end
     else if(currentline<lineindex) then 
      begin
       inc(i,1); inc(currentline,1);
      end
     else break;
    end
   else if(fwchar[1]<>#0) then
    begin
     if(fwchar[1]=#10) and (currentline<lineindex) then inc(currentline,1) else if(fwchar[1]=#10) then break;
     if(currentline=lineindex) then
      begin
       if(cpos=0) then cpos:=i;
       inc(clen);
      end;
    end
   else break;
  end;
 if(currentline=1) then tydq_fs_file_delete_data(systemtable,edl,diskindex,filename,cpos shl 1-1,clen shl 1,userlevel,belonguserindex)
 else if(currentline>1) then tydq_fs_file_delete_data(systemtable,edl,diskindex,filename,cpos shl 1-3,clen shl 1,userlevel,belonguserindex);
end;
function tydq_fs_systeminfo_init:tydqfs_system_info;[public,alias:'TYDQ_FS_SYSTEMINFO_INIT'];
var res:tydqfs_system_info;
begin
 res.header.tydqgraphics:=false;
 res.header.tydqnetwork:=false;
 res.header.tydqautodetectkernel:=false;
 res.header.tydqshell:=true;
 res.header.tydqenvironmentvariable:=true;
 res.header.tydqlanguage:=0;
 res.infostart:=8;
 res.isfreed:=false;
end;
procedure tydq_fs_systeminfo_create(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint);[public,alias:'TYDQ_FS_SYSTEMINFO_CREATE'];
var tmpstr:PWideChar;
    position:qword;
begin
 //Create the systeminfo file.
 tydq_fs_file_create(systemtable,edl,diskindex,'/SysInfo.dqi',tydqfs_text_file,tydqfs_text_file_configuration,userlevel_system,tydqfs_hidden_system,1);
 //Systeminfo file header.
 tmpstr:=Wstrcreate('<SysInfo>'#10); 
 position:=1;
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/SysInfo.dqi',position,tmpstr,getmemsize(tmpstr),userlevel_system,1);
 //Graphics option.
 position:=getmemsize(tmpstr)+1;
 Wstrfree(tmpstr);
 tmpstr:=Wstrcreate('Graphics=False'#10);
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/SysInfo.dqi',position,tmpstr,Wstrlen(tmpstr)*2,userlevel_system,1);
 //Network option.
 position:=position+getmemsize(tmpstr)-2;
 Wstrfree(tmpstr);
 tmpstr:=Wstrcreate('Network=False'#10);
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/SysInfo.dqi',position,tmpstr,Wstrlen(tmpstr)*2,userlevel_system,1);
 //Auto detect kernel option.
 position:=position+getmemsize(tmpstr)-2;
 Wstrfree(tmpstr);
 tmpstr:=Wstrcreate('AutoDetectKernel=False'#10);
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/SysInfo.dqi',position,tmpstr,Wstrlen(tmpstr)*2,userlevel_system,1);
 //Shell option.
 position:=position+getmemsize(tmpstr)-2;
 Wstrfree(tmpstr);
 tmpstr:=Wstrcreate('Shell=True'#10);
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/SysInfo.dqi',position,tmpstr,Wstrlen(tmpstr)*2,userlevel_system,1);
 //Environment variable option.
 position:=position+getmemsize(tmpstr)-2;
 Wstrfree(tmpstr);
 tmpstr:=Wstrcreate('EnvironmentVariable=True'#10);
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/SysInfo.dqi',position,tmpstr,Wstrlen(tmpstr)*2,userlevel_system,1);
 //Language option.
 position:=position+getmemsize(tmpstr)-2;
 Wstrfree(tmpstr);
 tmpstr:=Wstrcreate('Language=English');
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/SysInfo.dqi',position,tmpstr,Wstrlen(tmpstr)*2,userlevel_system,1);
 //Ended the systeminfo creation.
 Wstrfree(tmpstr);
end;
function tydq_fs_systeminfo_exists(edl:efi_disk_list):boolean;[public,alias:'TYDQ_FS_SYSTEMINFO_EXISTS'];
var diskindex:natuint;
    fsf:tydqfs_file;
begin
 diskindex:=1;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit(false) else exit(true);
end;
function tydq_fs_systeminfo_read(edl:efi_disk_list):tydqfs_system_info;[public,alias:'TYDQ_FS_SYSTEMINFO_READ'];
var res:tydqfs_system_info;
    i,maxline:qword;
    procnum,len,diskindex:natuint;
    entirestr,optionstr,valuestr:PWideChar;
    fsf:tydqfs_file;
begin
 diskindex:=1;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit(tydq_fs_systeminfo_init);
 i:=1; maxline:=tydq_fs_file_read_wstring_line_count(edl,diskindex,'/SysInfo.dqi',userlevel_system,1); 
 res:=tydq_fs_systeminfo_init;
 for i:=2 to maxline do 
  begin
   entirestr:=tydq_fs_file_read_wstring_line(edl,diskindex,'/SysInfo.dqi',i,userlevel_system,1);
   procnum:=Wstrpos(entirestr,'=',1); len:=WStrlen(entirestr);
   if(procnum=0) then
    begin
     Wstrfree(entirestr); exit(res); break;
    end;
   optionstr:=Wstrcutout(entirestr,1,procnum-1); valuestr:=WStrcutout(entirestr,procnum+1,len);
   if(WstrCmpL(optionstr,'Graphics')=0) then
    begin
     if(WstrcmpL(valuestr,'True')=0) then res.header.tydqgraphics:=true else res.header.tydqgraphics:=false;
    end
   else if(WstrCmpL(optionstr,'Network')=0) then
    begin
     if(WstrcmpL(valuestr,'True')=0) then res.header.tydqnetwork:=true else res.header.tydqnetwork:=false;
    end
   else if(WStrCmpL(optionstr,'AutoDetectKernel')=0) then
    begin
     if(WstrcmpL(valuestr,'True')=0) then res.header.tydqautodetectkernel:=true else res.header.tydqautodetectkernel:=false;
    end
   else if(WStrCmpL(optionstr,'Shell')=0) then
    begin
     if(WstrcmpL(valuestr,'True')=0) then res.header.tydqshell:=true else res.header.tydqshell:=false;
    end
   else if(WStrCmpL(optionstr,'EnvironmentVariable')=0) then
    begin
     if(WstrcmpL(valuestr,'True')=0) then res.header.tydqenvironmentvariable:=true else res.header.tydqenvironmentvariable:=false;
    end
   else if(WStrCmpL(optionstr,'Language')=0) then
    begin
     if(WstrCmpL(valuestr,'English')=0) then res.header.tydqlanguage:=0 else res.header.tydqlanguage:=1;
    end
   else if(WstrCmpL(optionstr,'UName(CM)')=0) then 
    begin
     Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
     res.infostart:=i; res.isfreed:=false; break;
    end;
   Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
  end;
 tydq_fs_systeminfo_read:=res;
end;
procedure tydq_fs_systeminfo_write(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info);[public,alias:'TYDQ_FS_SYSTEMINFO_WRITE'];
var res:tydqfs_system_info;
    i,maxline:qword;
    tempstr:PWideChar;
    diskindex:natuint;
    fsf:tydqfs_file;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 i:=1;
 //Write graphics option.
 if(res.header.tydqgraphics=true) then tempstr:=Wstrcreate('Graphics=True') else tempstr:=Wstrcreate('Graphics=False');
 tydq_fs_file_write_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',2,tempstr,userlevel_system,1);
 Wstrfree(tempstr);
 //Write network option.
 if(res.header.tydqnetwork=true) then tempstr:=Wstrcreate('Network=True') else tempstr:=Wstrcreate('Network=False');
 tydq_fs_file_write_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',3,tempstr,userlevel_system,1);
 Wstrfree(tempstr);
 //Write auto detect kernel option.
 if(res.header.tydqautodetectkernel=true) then tempstr:=Wstrcreate('AutoDetectKernel=True') else tempstr:=Wstrcreate('AutoDetectKernel=False');
 tydq_fs_file_write_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',4,tempstr,userlevel_system,1);
 Wstrfree(tempstr);
 //Write shell option.
 if(res.header.tydqshell=true) then tempstr:=Wstrcreate('Shell=True') else tempstr:=Wstrcreate('Shell=False');
 tydq_fs_file_write_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',5,tempstr,userlevel_system,1);
 Wstrfree(tempstr);
 //Write environment variable option.
 if(res.header.tydqenvironmentvariable=true) then tempstr:=Wstrcreate('EnvironmentVariable=True') else tempstr:=Wstrcreate('EnvironmentVarabie=False');
 tydq_fs_file_write_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',6,tempstr,userlevel_system,1);
 Wstrfree(tempstr);
 //Write language option.
 if(res.header.tydqlanguage=0) then tempstr:=Wstrcreate('Language=English') else tempstr:=Wstrcreate('Language=Chinese');
 tydq_fs_file_write_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',7,tempstr,userlevel_system,1);
 Wstrfree(tempstr);
 //Write ended.
end;
function tydq_fs_systeminfo_user_exists(edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar):boolean;[public,alias:'TYDQ_FS_SYSTEMINFO_USER_EXISTS'];
var diskindex:natuint;
    i,maxline:qword;
    procnum,proclen:natuint;
    entirestr,optionstr,valuestr:PWideChar;
    fsf:tydqfs_file;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit(false);
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 maxline:=tydq_fs_file_read_wstring_line_count(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
 i:=sysinfo.infostart; 
 while(i<=maxline) do
  begin
   entirestr:=tydq_fs_file_read_wstring_line(edl,diskindex,'/SysInfo.dqi',i,userlevel_system,1);
   procnum:=Wstrpos(entirestr,'=',1); proclen:=Wstrlen(entirestr);
   if(procnum=0) then
    begin
     Wstrfree(entirestr); exit(false);
    end;
   optionstr:=Wstrcutout(entirestr,1,procnum-1); valuestr:=Wstrcutout(entirestr,procnum+1,proclen);
   if((WstrCmpL(optionstr,'UName(CM)')=0) or (WStrCmpL(optionstr,'UName(M)')=0) or (WstrCmpL(optionstr,'UName')=0)) and (WstrCmpL(valuestr,username)=0) then
    begin
     Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr); exit(true);
    end;
   Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
   inc(i,3);
  end;
 tydq_fs_systeminfo_user_exists:=false;
end;
function tydq_fs_systeminfo_user_index_exists(edl:efi_disk_list;sysinfo:tydqfs_system_info;userindex:qword):boolean;[public,alias:'TYDQ_FS_SYSTEMINFO_USER_INDEX_EXISTS'];
var diskindex:natuint;
    i,maxline:qword;
    fsf:tydqfs_file;
    procnum,proclen:natuint;
    entirestr,optionstr,valuestr:PWideChar;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit(false);
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 maxline:=tydq_fs_file_read_wstring_line_count(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
 i:=sysinfo.infostart+2; 
 while(i<=maxline) do
  begin
   entirestr:=tydq_fs_file_read_wstring_line(edl,diskindex,'/SysInfo.dqi',i,userlevel_system,1);
   procnum:=Wstrpos(entirestr,'=',1); proclen:=Wstrlen(entirestr);
   if(procnum=0) then
    begin
     Wstrfree(entirestr); exit(false);
    end;
   optionstr:=Wstrcutout(entirestr,1,procnum-1); valuestr:=Wstrcutout(entirestr,procnum+1,proclen);
   if((WstrCmpL(optionstr,'UIndex')=0) or (WStrCmpL(optionstr,'UIndex')=0) or (WstrCmpL(optionstr,'UIndex')=0)) and 
   (PWcharToUint(valuestr)=userindex*3 shl 4) then
    begin
     Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr); exit(true);
    end;
   Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
   inc(i,3);
  end;
 tydq_fs_systeminfo_user_index_exists:=false;
end;
function tydq_fs_systeminfo_get_user_position(edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar):qword;[public,alias:'TYDQ_FS_SYSTEMINFO_GET_USER_POSITION'];
var diskindex:natuint;
    i,maxline:qword;
    procnum,proclen:natuint;
    fsf:tydqfs_file;
    entirestr,optionstr,valuestr:PWideChar;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit(0);
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 maxline:=tydq_fs_file_read_wstring_line_count(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
 i:=sysinfo.infostart; 
 while(i<=maxline) do
  begin
   entirestr:=tydq_fs_file_read_wstring_line(edl,diskindex,'/SysInfo.dqi',i,userlevel_system,1);
   procnum:=Wstrpos(entirestr,'=',1); proclen:=Wstrlen(entirestr);
   if(procnum=0) then
    begin
     Wstrfree(entirestr); exit(0);
    end;
   optionstr:=Wstrcutout(entirestr,1,procnum-1); valuestr:=Wstrcutout(entirestr,procnum+1,proclen);
   if((WstrCmpL(optionstr,'UName(CM)')=0) or (WStrCmpL(optionstr,'UName(M)')=0) or (WstrCmpL(optionstr,'UName')=0)) and (WstrCmpL(valuestr,username)=0) then
    begin
     Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr); exit((i-sysinfo.infostart+1) div 3+1);
    end;
   Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
   inc(i,3);
  end;
 tydq_fs_systeminfo_get_user_position:=0;
end;
function tydq_fs_systeminfo_get_user_index_position(edl:efi_disk_list;sysinfo:tydqfs_system_info;userindex:qword):qword;[public,alias:'TYDQ_FS_SYSTEMINFO_GET_USER_INDEX_POSITION'];
var diskindex:natuint;
    i,maxline:qword;
    procnum,proclen:natuint;
    entirestr,optionstr,valuestr:PWideChar;
    fsf:tydqfs_file;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit(0);
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 maxline:=tydq_fs_file_read_wstring_line_count(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
 i:=sysinfo.infostart+2; 
 while(i<=maxline) do
  begin
   entirestr:=tydq_fs_file_read_wstring_line(edl,diskindex,'/SysInfo.dqi',i,userlevel_system,1);
   procnum:=Wstrpos(entirestr,'=',1); proclen:=Wstrlen(entirestr);
   if(procnum=0) then
    begin
     Wstrfree(entirestr); exit(0);
    end;
   optionstr:=Wstrcutout(entirestr,1,procnum-1); valuestr:=Wstrcutout(entirestr,procnum+1,proclen);
   if((WstrCmpL(optionstr,'UIndex')=0) or (WStrCmpL(optionstr,'UIndex')=0) or (WstrCmpL(optionstr,'UIndex')=0)) and 
   (PWcharToUint(valuestr)=userindex*3 shl 4) then
    begin
     Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr); exit((i-sysinfo.infostart) div 3+1);
    end;
   Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
   inc(i,3);
  end;
 tydq_fs_systeminfo_get_user_index_position:=0;
end;
procedure tydq_fs_systeminfo_add_user(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;newusername,newuserpassword:PWideChar;newuserlevel:byte);[public,alias:'TYDQ_FS_SYSTEMINFO_ADD_USER'];
var fsf:tydqfs_file;
    temp_str1,temp_str2,temp_str3:PWideChar;
    diskindex:natuint;
    i:qword;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 if(tydq_fs_systeminfo_user_exists(edl,sysinfo,newusername)) then exit;
 i:=1;
 while(i<$FFFFFFFFFFFFFFFF) do
  begin
   if(tydq_fs_systeminfo_user_index_exists(edl,sysinfo,i)=false) then break;
   inc(i,1);
  end;
 if(i=$FFFFFFFFFFFFFFFF) then exit;
 fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
 Wstrinit(temp_str1,256);
 if(newuserlevel=userlevel_system) then
  begin 
   temp_str2:=PWChar_encrypt_to_password(newuserpassword,5);
   Wstrset(temp_str1,#10'UName(CM)=');
   Wstrcat(temp_str1,newusername);
   Wstrset(temp_str1,#10'UPassword=');
   Wstrcat(temp_str1,temp_str2);
   Wstrset(temp_str1,#10'UIndex=');
   temp_str3:=UintToPWChar(i*3 shl 4);
   Wstrcat(temp_str1,temp_str3);
  end
 else if(newuserlevel=userlevel_normalmanager) then
  begin
   temp_str2:=PWChar_encrypt_to_password(newuserpassword,3);
   Wstrset(temp_str1,#10'UName(M)=');
   Wstrcat(temp_str1,newusername);
   Wstrset(temp_str1,#10'UPassword=');
   Wstrcat(temp_str1,temp_str2);
   Wstrset(temp_str1,#10'UIndex=');
   temp_str3:=UintToPWChar(i*3 shl 4);
   Wstrcat(temp_str1,temp_str3);
  end
 else if(newuserlevel=userlevel_normaluser) then 
  begin
   temp_str2:=PWChar_encrypt_to_password(newuserpassword,2);
   Wstrset(temp_str1,#10'UName=');
   Wstrcat(temp_str1,newusername);
   Wstrset(temp_str1,#10'UPassword=');
   Wstrcat(temp_str1,temp_str2);
   Wstrset(temp_str1,#10'UIndex=');
   temp_str3:=UintToPWChar(i*3 shl 4);
   Wstrcat(temp_str1,temp_str3);
  end;
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/SysInfo.dqi',fsf.fContentCount-1,temp_str1,Wstrlen(temp_str1) shl 1,userlevel_system,1);
 Wstrfree(temp_str3); Wstrfree(temp_str2); Wstrfree(temp_str1);
end;
procedure tydq_fs_systeminfo_delete_user(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar);[public,alias:'TYDQ_FS_SYSTEMINFO_DELETE_USER'];
var i:qword;
    diskindex:natuint;
    fsf:tydqfs_file;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 i:=tydq_fs_systeminfo_get_user_position(edl,sysinfo,username);
 tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',(i-1)*3+sysinfo.infostart+2,userlevel_system,1);
 tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',(i-1)*3+sysinfo.infostart+1,userlevel_system,1);
 tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',(i-1)*3+sysinfo.infostart,userlevel_system,1);
end;
procedure tydq_fs_systeminfo_delete_user_with_index(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;userindex:qword);[public,alias:'TYDQ_FS_SYSTEMINFO_DELETE_USER_WITH_INDEX'];
var i:qword;
    diskindex:natuint;
    fsf:tydqfs_file;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 i:=tydq_fs_systeminfo_get_user_index_position(edl,sysinfo,userindex);
 tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',(i-1)*3+sysinfo.infostart+2,userlevel_system,1);
 tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',(i-1)*3+sysinfo.infostart+1,userlevel_system,1);
 tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',(i-1)*3+sysinfo.infostart,userlevel_system,1);
end;
function tydq_fs_systeminfo_get_user_count(edl:efi_disk_list;sysinfo:tydqfs_system_info):qword;[public,alias:'TYDQ_FS_SYSTEMINFO_GET_USER_COUNT'];
var diskindex:natuint;
    maxline:qword;
    fsf:tydqfs_file;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit(0);
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 maxline:=tydq_fs_file_read_wstring_line_count(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
 tydq_fs_systeminfo_get_user_count:=(maxline-sysinfo.infostart+1) div 3;
end;
procedure tydq_fs_systeminfo_change_user_name(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar;newusername:PWideChar);[public,alias:'TYDQ_FS_SYSTEMINFO_CHANGE_USER_NAME'];
var diskindex:natuint;
    tempstr,entirestr:PWideChar;
    fuserlevel:byte;
    fsf:tydqfs_file;
    i:qword;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 if(tydq_fs_systeminfo_user_exists(edl,sysinfo,username)) and (tydq_fs_systeminfo_user_exists(edl,sysinfo,newusername)=false) then exit;
 i:=sysinfo.infostart+(tydq_fs_systeminfo_get_user_position(edl,sysinfo,username)-1)*3;
 entirestr:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/SysInfo.dqi',i,userlevel_system,1);
 if(WstrCmp(entirestr,'UName(CM)=')=0) then fuserlevel:=0
 else if(WStrCmp(entirestr,'UName(M)=')=0) then fuserlevel:=1
 else if(WStrCmp(entirestr,'UName=')=0) then fuserlevel:=2;
 Wstrinit(tempstr,256);
 case fuserlevel of
 0:Wstrset(tempstr,'UName(CM)=');
 1:Wstrset(tempstr,'UName(M)=');
 2:Wstrset(tempstr,'UName=');
 end;
 Wstrcat(tempstr,newusername);
 tydq_fs_file_write_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',i,tempstr,userlevel_system,1);
 Wstrfree(tempstr);
end;
procedure tydq_fs_systeminfo_change_user_password(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar;newuserpassword:PWideChar);[public,alias:'TYDQ_FS_SYSTEMINFO_CHANGE_USER_PASSWORD'];
var diskindex:natuint;
    tempstr,tempstr2,entirestr:PWideChar;
    fuserlevel:byte;
    fsf:tydqfs_file;
    i:qword;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 if(tydq_fs_systeminfo_user_exists(edl,sysinfo,username)) and (tydq_fs_systeminfo_user_exists(edl,sysinfo,username)=false) then exit;
 i:=sysinfo.infostart+(tydq_fs_systeminfo_get_user_position(edl,sysinfo,username)-1)*3;
 entirestr:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/SysInfo.dqi',i,userlevel_system,1);
 if(WstrCmp(entirestr,'UName(CM)=')=0) then fuserlevel:=0
 else if(WStrCmp(entirestr,'UName(M)=')=0) then fuserlevel:=1
 else if(WStrCmp(entirestr,'UName=')=0) then fuserlevel:=2;
 Wstrinit(tempstr,256);
 Wstrset(tempstr,'UPassword=');
 case fuserlevel of
 0:tempstr2:=PWChar_encrypt_to_password(newuserpassword,5);
 1:tempstr2:=PWChar_encrypt_to_password(newuserpassword,3);
 2:tempstr2:=PWChar_encrypt_to_password(newuserpassword,2);
 end;
 Wstrcat(tempstr,tempstr2);
 Wstrfree(tempstr2);
 tydq_fs_file_write_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',i+1,tempstr,userlevel_system,1);
 Wstrfree(tempstr);
end;
function tydq_fs_systeminfo_match_user_password(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar;inputpassword:PWideChar):boolean;[public,alias:'TYDQ_FS_SYSTEMINFO_MATCH_USER_PASSWORD'];
var diskindex:natuint;
    fsf:tydqfs_file;
    fuserlevel:byte;
    entirestr1,optionstr1,valuestr1,entirestr2,optionstr2,valuestr2,comparestr:PWideChar;
    procnum,procnum1,procnum2,proclen1,proclen2:qword;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit(false);
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit(false);
 procnum:=tydq_fs_systeminfo_get_user_position(edl,sysinfo,username);
 if(procnum=0) then exit(false);
 entirestr1:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/SysInfo.dqi',sysinfo.infostart+(procnum-1)*3,userlevel_system,1);
 procnum1:=Wstrpos(entirestr1,'=',1); proclen1:=Wstrlen(entirestr1);
 if(procnum1=0) then
  begin
   Wstrfree(entirestr1); exit(false);
  end;
 optionstr1:=Wstrcutout(entirestr1,1,procnum1-1); valuestr1:=Wstrcutout(entirestr1,procnum1+1,proclen1);
 entirestr2:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/SysInfo.dqi',sysinfo.infostart+(procnum-1)*3+1,userlevel_system,1);
 procnum2:=Wstrpos(entirestr2,'=',1); proclen2:=Wstrlen(entirestr2);
 if(procnum2=0) then
  begin
   Wstrfree(entirestr2); Wstrfree(valuestr1); Wstrfree(optionstr1); Wstrfree(entirestr1); exit(false);
  end;
 optionstr2:=Wstrcutout(entirestr2,1,procnum2-1); valuestr2:=Wstrcutout(entirestr2,procnum2+1,proclen2);
 if(WstrCmpL(optionstr1,'UName(CM)')=0) then
  begin
   comparestr:=PWChar_encrypt_to_password(valuestr2,5);
   if(WstrCmpL(comparestr,valuestr2)=0) then tydq_fs_systeminfo_match_user_password:=true else tydq_fs_systeminfo_match_user_password:=false;
  end
 else if(WStrCmpL(optionstr1,'UName(M)')=0) then
  begin
   comparestr:=PWChar_encrypt_to_password(valuestr2,3);
   if(WstrCmpL(comparestr,valuestr2)=0) then tydq_fs_systeminfo_match_user_password:=true else tydq_fs_systeminfo_match_user_password:=false;
  end
 else if(WStrCmpL(optionstr1,'UName')=0) then
  begin
   comparestr:=PWChar_encrypt_to_password(valuestr2,2);
   if(WstrCmpL(comparestr,valuestr2)=0) then tydq_fs_systeminfo_match_user_password:=true else tydq_fs_systeminfo_match_user_password:=false;
  end;
 Wstrfree(comparestr); Wstrfree(valuestr2); Wstrfree(optionstr2); Wstrfree(entirestr2); Wstrfree(valuestr1); Wstrfree(optionstr1); Wstrfree(entirestr1);
end;
function tydq_fs_systeminfo_get_username_with_position(edl:efi_disk_list;sysinfo:tydqfs_system_info;position:natuint):PWideChar;[public,alias:'TYDQ_FS_SYSTEMINFO_GET_USERNAME_WITH_POSITION'];
var diskindex,procnum,proclen:natuint;
    fsf:tydqfs_file;
    index:qword;
    entirestr,optionstr,valuestr,res:PWideChar;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit(nil);
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit(nil);
 Wstrinit(res,255);
 entirestr:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/SysInfo.dqi',sysinfo.infostart+(position-1)*3,userlevel_system,1);
 procnum:=Wstrpos(entirestr,'=',1); proclen:=Wstrlen(entirestr);
 if(procnum=0) then
  begin
   Wstrfree(entirestr); Wstrfree(res); exit(nil);
  end;
 optionstr:=Wstrcutout(entirestr,1,procnum-1); valuestr:=Wstrcutout(entirestr,procnum+1,proclen);
 Wstrset(res,valuestr);
 tydq_fs_systeminfo_get_username_with_position:=res;
end;
function tydq_fs_systeminfo_get_user_level(edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar):byte;[public,alias:'TYDQ_FS_SYSTEMINFO_GET_USER_LEVEL'];
var diskindex:natuint;
    fsf:tydqfs_file;
    fuserlevel:byte;
    entirestr1,optionstr1,valuestr1:PWideChar;
    procnum,procnum1,procnum2,proclen1,proclen2:qword;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit(userlevel_shared);
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit(userlevel_shared);
 procnum:=tydq_fs_systeminfo_get_user_position(edl,sysinfo,username);
 if(procnum=0) then exit(userlevel_shared);
 entirestr1:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/SysInfo.dqi',sysinfo.infostart+(procnum-1)*3,userlevel_system,1);
 procnum1:=Wstrpos(entirestr1,'=',1); proclen1:=Wstrlen(entirestr1);
 if(procnum1=0) then
  begin
   Wstrfree(entirestr1); exit(userlevel_shared);
  end;
 optionstr1:=Wstrcutout(entirestr1,1,procnum1-1); valuestr1:=Wstrcutout(entirestr1,procnum1+1,proclen1);
 if(WstrCmpL(optionstr1,'UName(CM)')=0) then tydq_fs_systeminfo_get_user_level:=userlevel_chiefmanager
 else if(WStrCmpL(optionstr1,'UName(M)')=0) then tydq_fs_systeminfo_get_user_level:=userlevel_normalmanager
 else if(WStrCmpL(optionstr1,'UName')=0) then tydq_fs_systeminfo_get_user_level:=userlevel_normaluser;
 Wstrfree(valuestr1); Wstrfree(optionstr1); Wstrfree(entirestr1);
end;
function tydq_fs_systeminfo_get_user_index(edl:efi_disk_list;sysinfo:tydqfs_system_info;username:PWideChar):qword;[public,alias:'TYDQ_FS_SYSTEMINFO_GET_USER_INDEX'];
var diskindex:natuint;
    fsf:tydqfs_file;
    fuserlevel:byte;
    entirestr1,optionstr1,valuestr1:PWideChar;
    procnum,procnum1,procnum2,proclen1,proclen2:qword;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit(0);
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit(0);
 procnum:=tydq_fs_systeminfo_get_user_position(edl,sysinfo,username);
 if(procnum=0) then exit(0);
 entirestr1:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/SysInfo.dqi',sysinfo.infostart+(procnum-1)*3+2,userlevel_system,1);
 procnum1:=Wstrpos(entirestr1,'=',1); proclen1:=Wstrlen(entirestr1);
 if(procnum1=0) then
  begin
   Wstrfree(entirestr1); exit(0);
  end;
 optionstr1:=Wstrcutout(entirestr1,1,procnum1-1); valuestr1:=Wstrcutout(entirestr1,procnum1+1,proclen1);
 tydq_fs_systeminfo_get_user_index:=PWCharToUint(valuestr1);
 Wstrfree(valuestr1); Wstrfree(optionstr1); Wstrfree(entirestr1);
end;
procedure tydq_fs_systeminfo_clear(systemtable:Pefi_system_table;edl:efi_disk_list;sysinfo:tydqfs_system_info);[public,alias:'TYDQ_FS_SYSTEMINFO_CLEAR'];
var fsf:tydqfs_file;
    maxline:qword;
    diskindex:natuint;
    i:qword;
begin
 diskindex:=1;
 if(sysinfo.isfreed=true) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then exit;
 maxline:=tydq_fs_file_read_wstring_line_count(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
 for i:=maxline downto sysinfo.infostart do tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/SysInfo.dqi',i,userlevel_system,1);
end;
function tydq_fs_systeminfo_disk_index(edl:efi_disk_list):natuint;[public,alias:'TYDQ_FS_SYSTEMINFO_DISK_INDEX'];
var fsf:tydqfs_file;
    maxline:qword;
    diskindex:natuint;
begin
 diskindex:=1;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/SysInfo.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/SysInfo.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex);
  end;
 if(diskindex>edl.disk_count) then tydq_fs_systeminfo_disk_index:=0 else tydq_fs_systeminfo_disk_index:=diskindex;
end;
procedure tydq_fs_systeminfo_free(var sysinfo:tydqfs_system_info);[public,alias:'TYDQ_FS_SYSTEMINFO_FREE'];
begin
 sysinfo.infostart:=0;
 sysinfo.isfreed:=true;
end;
function tydq_fs_environment_variable_initialize:tydqfs_environment_variable_list;[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLE_INITIALIZE'];
var res:tydqfs_environment_variable_list;
begin
 res.header_index:=1;
 res.item_start_index:=2;
 res.item_start_count:=0;
 res.isfreed:=false;
 tydq_fs_environment_variable_initialize:=res;
end;
procedure tydq_fs_environment_variable_file_create(systemtable:Pefi_system_table;edl:efi_disk_list;diskindex:natuint);[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLE_FILE_CREATE'];
var temp_str:PWideChar;
begin
 //Create the empty environment variable file.
 tydq_fs_file_create(systemtable,edl,diskindex,'/EnvironVar.dqi',tydqfs_text_file,tydqfs_text_file_configuration,userlevel_system,tydqfs_hidden_system,1);
 //Write the environment variable header.
 temp_str:=WStrCreate('<EnvironmentVariable>');
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/EnvironVar.dqi',1,temp_str,(Wstrlen(temp_str)+1) shl 1,userlevel_system,1);
 Wstrfree(temp_str);
end;
function tydq_fs_environment_variable_exists(edl:efi_disk_list):boolean;[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLE_EXISTS'];
var diskindex:natuint;
    fsf:tydqfs_file;
begin
 diskindex:=1;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/EnvironVar.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/EnvironVar.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex,1);
  end;
 if(diskindex>edl.disk_count) then exit(false) else exit(true);
end;
function tydq_fs_environment_variable_read(systemtable:Pefi_system_table;edl:efi_disk_list):tydqfs_environment_variable_list;[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLE_READ'];
var diskindex:natuint;
    fsf:tydqfs_file;
    res:tydqfs_environment_variable_list;
    entirestr:PWideChar;
begin
 diskindex:=1;
 res.header_index:=1; res.item_start_index:=2; res.item_start_count:=0; res.isfreed:=false;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/EnvironVar.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/EnvironVar.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex,1);
  end;
 if(diskindex>edl.disk_count) then exit;
 while(True) do
  begin
   entirestr:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/EnvironVar.dqi',res.item_start_index+res.item_start_count,userlevel_system,1);
   if(entirestr<>nil) then 
    begin
     Wstrfree(entirestr); inc(res.item_start_count);
    end
   else break;
  end;
end;
procedure tydq_fs_environment_variable_add_item(systemtable:Pefi_system_table;edl:efi_disk_list;var evlist:tydqfs_environment_variable_list;varname,varvalue:PWideChar);[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLE_ADD_ITEM'];
var diskindex:natuint;
    fsf:tydqfs_file;
    temp_str:PWideChar;
begin
 diskindex:=1;
 if(evlist.isfreed) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/EnvironVar.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/EnvironVar.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex,1);
  end;
 if(diskindex>edl.disk_count) then exit;
 if(varname=nil) or (varvalue=nil) then exit;
 if(varname^=#0) or (varvalue^=#0) then exit;
 inc(evlist.item_start_count);
 Wstrinit(temp_str,65535);
 Wstrset(temp_str,#10);
 Wstrcat(temp_str,varname);
 Wstrcat(temp_str,'=');
 Wstrcat(temp_str,varvalue);
 tydq_fs_file_insert_data(systemtable,edl,diskindex,'/EnvironVar.dqi',fsf.fContentCount-1,temp_str,Wstrlen(temp_str) shl 1,userlevel_system,1);
end;
procedure tydq_fs_environment_variable_delete_item(systemtable:Pefi_system_table;edl:efi_disk_list;var evlist:tydqfs_environment_variable_list;deletevarname:PWideChar;deletevarindex:qword);[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLE_DELETE_ITEM'];
var diskindex,procnum,proclen:natuint;
    fsf:tydqfs_file;
    i,varindex:qword;
    entirestr,optionstr,valuestr:PWideChar;
begin
 diskindex:=1; varindex:=1;
 if(deletevarindex<=0) then exit;
 if(evlist.isfreed) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/EnvironVar.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/EnvironVar.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex,1);
  end;
 if(diskindex>edl.disk_count) then exit;
 i:=1;
 while(i<=evlist.item_start_count) do
  begin
   entirestr:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/EnvironVar.dqi',evlist.item_start_index+i-1,userlevel_system,1);
   procnum:=Wstrpos(entirestr,'=',1); proclen:=Wstrlen(entirestr);
   if(procnum<=1) then
    begin
     Wstrfree(entirestr); inc(i,1); continue;
    end;
   optionstr:=Wstrcutout(entirestr,1,procnum-1); valuestr:=Wstrcutout(entirestr,procnum+1,proclen);
   if(WstrCmpL(optionstr,deletevarname)=0) and (varindex=deletevarindex) then
    begin
     tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/EnvironVar.dqi',i,userlevel_system,1);
     Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
     break;
    end
   else if(WStrCmpL(optionstr,deletevarname)=0) then inc(varindex,1);
   Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
   inc(i,1);
  end;
end;
procedure tydq_fs_environment_variable_clear_item(systemtable:Pefi_system_table;edl:efi_disk_list;var evlist:tydqfs_environment_variable_list);[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLE_CLEAR_ITEM'];
var diskindex,varindex:natuint;
    fsf:tydqfs_file;
    i:qword;
begin
 diskindex:=1; varindex:=1;
 if(evlist.isfreed) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/EnvironVar.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/EnvironVar.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex,1);
  end;
 if(diskindex>edl.disk_count) then exit;
 i:=evlist.item_start_count;
 while(i>0) do
  begin
   tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/EnvironVar.dqi',evlist.item_start_index+i-1,userlevel_system,1); dec(i,1);
  end;
end;
function tydq_fs_environment_variable_get_value(systemtable:Pefi_system_table;edl:efi_disk_list;evlist:tydqfs_environment_variable_list;getname:PWideChar;getindex:qword):PWideChar;[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLR_GET_VALUE'];
var diskindex:natuint;
    fsf:tydqfs_file;
    i,varindex,procnum,proclen:qword;
    entirestr,optionstr,valuestr,res:PWideChar;
begin
 diskindex:=1; varindex:=1;
 if(evlist.isfreed) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/EnvironVar.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/EnvironVar.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex,1);
  end;
 if(diskindex>edl.disk_count) then exit;
 Wstrinit(res,65535);
 i:=1;
 while(i<=evlist.item_start_count) do
  begin
   entirestr:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/EnvironVar.dqi',evlist.item_start_index+i-1,userlevel_system,1);
   procnum:=Wstrpos(entirestr,'=',1); proclen:=Wstrlen(entirestr);
   if(procnum<=1) then
    begin
     Wstrfree(entirestr); inc(i,1); continue;
    end;
   optionstr:=Wstrcutout(entirestr,1,procnum-1); valuestr:=Wstrcutout(entirestr,procnum+1,proclen);
   if(WstrCmpL(optionstr,getname)=0) and (varindex=getindex) then
    begin
     tydq_fs_file_delete_wstring(systemtable,edl,diskindex,'/EnvironVar.dqi',i,userlevel_system,1);
     Wstrset(res,valuestr);
     Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
     break;
    end
   else if(WStrCmpL(optionstr,getname)=0) then inc(varindex,1);
   Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
   inc(i,1);
  end;
 tydq_fs_environment_variable_get_value:=res;
end;
function tydq_fs_environment_variable_get_value_with_index(systemtable:Pefi_system_table;edl:efi_disk_list;evlist:tydqfs_environment_variable_list;getpos:qword):PWideChar;[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLE_GET_VALUE_WITH_INDEX'];
var diskindex:natuint;
    fsf:tydqfs_file;
    i,varindex,procnum,proclen:qword;
    entirestr,optionstr,valuestr,res:PWideChar;
begin
 diskindex:=1; 
 if(evlist.isfreed) then exit;
 while(diskindex<=edl.disk_count) do
  begin
   fsf:=tydq_fs_file_info(edl,diskindex,'/EnvironVar.dqi',userlevel_system,1);
   if(tydq_fs_file_exists(edl,diskindex,'/EnvironVar.dqi')) and (fsf.fmainclass=tydqfs_text_file) and (fsf.fsubclass=tydqfs_text_file_configuration) and (fsf.fhidden=tydqfs_hidden_system) then break;
   inc(diskindex,1);
  end;
 if(diskindex>edl.disk_count) then exit;
 Wstrinit(res,65535);
 i:=getpos;
 entirestr:=tydq_fs_file_read_Wstring_line(edl,diskindex,'/EnvironVar.dqi',evlist.item_start_index+i-1,userlevel_system,1);
 procnum:=Wstrpos(entirestr,'=',1); proclen:=Wstrlen(entirestr);
 if(procnum<=1) then
  begin
   Wstrfree(entirestr); inc(i,1);
  end;
 optionstr:=Wstrcutout(entirestr,1,procnum-1); valuestr:=Wstrcutout(entirestr,procnum+1,proclen);
 Wstrset(res,valuestr); Wstrfree(valuestr); Wstrfree(optionstr); Wstrfree(entirestr);
 tydq_fs_environment_variable_get_value_with_index:=res;
end;
procedure tydq_fs_environment_variable_file_free(var evlist:tydqfs_environment_variable_list);[public,alias:'TYDQ_FS_ENVIRONMENT_VARIABLE_FILE_FREE'];
begin
 evlist.header_index:=0;
 evlist.item_start_index:=0;
 evlist.item_start_count:=0;
 evlist.isfreed:=true;
end;
function tydq_fs_name_legal(tydqname:PWideChar):boolean;[public,alias:'TYDQ_FS_NAME_LEGAL'];
const illegalchar:PWideChar='\/()[]{}!@#$%^&?';
var i,j,len1,len2:natuint;
begin
 len1:=Wstrlen(tydqname); len2:=Wstrlen(illegalchar);
 for i:=1 to len1 do
  for j:=1 to len2 do
   begin
    if((tydqname+i-1)^=(illegalchar+j-1)^) then exit(false);
   end;
 tydq_fs_name_legal:=true;
end;
function tydq_fs_path_legal(tydqpath:PWideChar):boolean;[public,alias:'TYDQ_FS_PATH_LEGAL'];
var i,j,len:natuint;
    partstr:PWideChar;
begin
 i:=1; j:=1; len:=Wstrlen(tydqpath);
 while(j>0) do
  begin
   j:=Wstrpos(tydqpath,'/',i);
   if(j>0) then partstr:=Wstrcutout(tydqpath,i,j-1) else partstr:=Wstrcutout(tydqpath,i,len);
   if(not tydq_fs_name_legal(partstr)) then 
    begin
     Wstrfree(partstr); exit(false);
    end;
   Wstrfree(partstr);
   i:=j+1;
  end;
 tydq_fs_path_legal:=true;
end;
function tydq_fs_path_vaild(edl:efi_disk_list;diskindex:natuint;path:PWideChar;userlevel:byte;belonguserindex:qword):boolean;[public,alias:'TYDQ_FS_PATH_VAILD'];
var i,j,len:natuint;
    partstr:PWideChar;
    fsf:tydqfs_file;
begin
 i:=1; j:=1; len:=Wstrlen(path);
 while(i<=len) do
  begin
   j:=Wstrpos(path,'/',i+1);
   if(j>0) then partstr:=Wstrcutout(path,1,j-1) else partstr:=Wstrcutout(path,1,len);
   fsf:=tydq_fs_file_info(edl,diskindex,path,userlevel,belonguserindex);
   if(fsf.fmainclass=tydqfs_folder) and (fsf.fsubclass=tydqfs_folder_private) then
    begin
     Wstrfree(partstr); exit(false);
    end;
   Wstrfree(partstr);
   i:=j;
  end;
 tydq_fs_path_vaild:=true;
end;

end.
