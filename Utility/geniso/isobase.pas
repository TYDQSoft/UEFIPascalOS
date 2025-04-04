unit isobase;

interface

{$MODE FPC}

{Definition for iso file}
const iso_type_volume_descriptor_boot_record:byte=0;
      iso_type_volume_descriptor_primary_volume_descriptor:byte=1;
      iso_type_volume_descriptor_supplementary_volume_descriptor:byte=2;
      iso_type_volume_descriptor_volume_parition_descriptor:byte=3;
      iso_type_volume_descriptor_set_terminator:byte=$FF;
      iso_version:byte=$01;
      iso_start=$8000;
      iso_boot_system_id:array[1..5] of char=('C','D','R','O','M');
      iso_boot_id:array[1..15] of char=('C','D','R','O','M',' ','B','Y',' ','G','E','N','I','S','O');
      iso_standard_id:array[1..5] of char=('C','D','0','0','1');
      iso_system_id:array[1..5] of char=('C','D','R','O','M');
      iso_volume_id:array[1..5] of char=('C','D','R','O','M');
      iso_supplement_volume_descriptor_joliet:array[1..6] of char=('J','O','I','L','E','T');
      iso_volume_set_identifier:array[1..12] of char=('V','A','I','L','D',' ','V','O','L','U','M','E');
      iso_publisher_id:array[1..12] of char=('N','O',' ','P','U','B','L','I','S','H','E','R');
      iso_data_preparer_id:array[1..6] of char=('G','E','N','I','S','O');
      iso_application_id:array[1..6] of char=('G','E','N','I','S','O');
      iso_copyright_id:array[1..12] of char=('N','O',' ','C','O','P','Y','R','I','G','H','T');
      iso_abstract_id:array[1..11] of char=('N','O',' ','A','B','S','T','R','A','C','T');
      iso_bibiliographic_id:array[1..14] of char=('N','O',' ','I','N','F','O',' ','L','I','N','K','E','D');
      iso_el_torito_id:array[1..23] of char=('E','L',' ','T','O','R','I','T','O',' ','S','P','E','C','I',
'F','I','C','A','T','I','O','N');
      iso_el_torito_manufacturer:array[1..6] of char=('G','E','N','I','S','O');
      iso_standard_none=0;
      iso_standard_el_torito=1;
      iso_standard_joliet=2;
      iso_standard_rockridge=3;
      iso_standard_udf=4;
      iso_standard_hybrid=5;
{LSB means little-endian,MSB mean big-endian,and LSB_MSB means total in
 big-endian while byte in little endian.}
type Integer=-$7FFFFFFF..$7FFFFFFF;
     Pword=^word;
     Pdword=^dword;
     Pqword=^qword;
     Pshortint=^shortint;
     Pinteger=^integer;
     Pint64=^int64;
     iso_a_char=char;
     iso_d_char=char;
     iso_unicode=WideChar;
     iso_int8=byte;
     iso_sint8=smallint;
     iso_data=byte;
     iso_data16=word;
     iso_data32=dword;
     iso_data64=qword;
     iso_date_time=packed record
                   year:array[1..4] of iso_d_char;
                   month:array[1..2] of iso_d_char;
                   day:array[1..2] of iso_d_char;
                   hour:array[1..2] of iso_d_char;
                   minute:array[1..2] of iso_d_char;
                   second:array[1..2] of iso_d_char;
                   hundredthsofASecond:array[1..2] of iso_d_char;
                   timezoneoffsetof15minuteintervals:iso_int8;
                   end;
     iso_flag=bitpacked record
              atleast:0..1;
              reserved:0..127;
              end;
     iso_lsb_word=packed record
                  data1:byte;
                  data2:byte;
                  end;
     iso_lsb_dword=packed record
                   data1:iso_lsb_word;
                   data2:iso_lsb_word;
                   end;
     iso_lsb_qword=packed record
                   data1:iso_lsb_dword;
                   data2:iso_lsb_dword;
                   end;
     iso_lsb_shortint=packed record
                      data1:byte;
                      data2:smallint;
                      end;
     iso_lsb_integer=packed record
                     data1:iso_lsb_word;
                     data2:iso_lsb_shortint;
                     end;
     iso_lsb_int64=packed record
                   data1:iso_lsb_dword;
                   data2:iso_lsb_integer;
                   end;
     iso_msb_word=packed record
                  data2:byte;
                  data1:byte;
                  end;
     iso_msb_dword=packed record
                   data2:iso_msb_word;
                   data1:iso_msb_word;
                   end;
     iso_msb_qword=packed record
                   data2:iso_msb_dword;
                   data1:iso_msb_dword;
                   end;
     iso_msb_shortint=packed record
                      data2:smallint;
                      data1:byte;
                      end;
     iso_msb_integer=packed record
                     data2:iso_msb_shortint;
                     data1:iso_msb_word;
                     end;
     iso_msb_int64=packed record
                   data2:iso_msb_integer;
                   data1:iso_msb_dword;
                   end;
     iso_lsb_msb_word=packed record
                      data1:iso_lsb_word;
                      data2:iso_msb_word;
                      end;
     iso_lsb_msb_dword=packed record
                       data1:iso_lsb_dword;
                       data2:iso_msb_dword;
                       end;
     iso_lsb_msb_qword=packed record
                       data1:iso_lsb_qword;
                       data2:iso_msb_qword;
                       end;
     iso_lsb_msb_shortint=packed record
                          data1:iso_lsb_shortint;
                          data2:iso_msb_shortint;
                          end;
     iso_lsb_msb_integer=packed record
                         data1:iso_lsb_integer;
                         data2:iso_msb_integer;
                         end;
     iso_lsb_msb_int64=packed record
                       data1:iso_lsb_int64;
                       data2:iso_msb_int64;
                       end;
     iso_int16_lsb=iso_lsb_word;
     iso_int16_msb=iso_msb_word;
     iso_int16_lsb_msb=iso_lsb_msb_word;
     iso_sint16_lsb=iso_lsb_shortint;
     iso_sint16_msb=iso_msb_shortint;
     iso_sint16_lsb_msb=iso_lsb_msb_shortint;
     iso_int32_lsb=iso_lsb_dword;
     iso_int32_msb=iso_msb_dword;
     iso_int32_lsb_msb=iso_lsb_msb_dword;
     iso_sint32_lsb=iso_lsb_integer;
     iso_sint32_msb=iso_msb_integer;
     iso_sint32_lsb_msb=iso_lsb_msb_integer;
     iso_int16=packed record
               case Boolean of
               True:(lsb:iso_int16_lsb;);
               False:(msb:iso_int16_msb;);
               end;
     iso_int32=packed record
               case Boolean of
               True:(lsb:iso_int32_lsb;);
               False:(msb:iso_int32_msb;);
               end;
     iso_volume_descriptor_format=packed record
                                  VolumeDescriptorType:iso_int8;
                                  Id:array[1..5] of iso_a_char;
                                  Version:iso_int8;
                                  Data:array[1..2041] of iso_data;
                                  end;
     iso_volume_descriptor_boot_record=packed record
                                       VolumeDescriptorType:iso_int8;
                                       Id:array[1..5] of iso_a_char;
                                       Version:iso_int8;
                                       BootSystemId:array[1..32] of iso_a_char;
                                       BootId:array[1..32] of iso_a_char;
                                       BootSystemUse:array[1..1977] of iso_data;
                                       end;
     iso_volume_descriptor_boot_record_for_ei_torito=packed record
                                                     VolumeDescriptorType:iso_int8;
                                                     Id:array[1..5] of iso_a_char;
                                                     Version:iso_int8;
                                                     BootSystemId:array[1..32] of iso_a_char;
                                                     BootId:array[1..32] of iso_a_char;
                                                     BootCatalogAddress:iso_int32_lsb;
                                                     BootSystemUse:array[1..1973] of iso_data;
                                                     end;
     iso_directory_flags=bitpacked record
                         existence:0..1;
                         directory:0..1;
                         associatedfile:0..1;
                         frecord:0..1;
                         Protection:0..1;
                         Reserved:0..3;
                         MultiExtent:0..1;
                         end;
     iso_directory_date_and_time=packed record
                                 NumberOfYears:iso_int8;
                                 MonthOfYears:iso_int8;
                                 DayOfMonth:iso_int8;
                                 HourOfDay:iso_int8;
                                 MinuteOfHour:iso_int8;
                                 SecondOfMinute:iso_int8;
                                 OffsetFromGreenWich:iso_sint8;
                                 end;
     iso_root_directory_record=packed record
                               LengthOfDirRecord:iso_int8;
                               ExtendedAttributeRecordLength:iso_int8;
                               LocationOfExtent:iso_int32_lsb_msb;
                               DataLength:iso_int32_lsb_msb;
                               DateAndTime:iso_directory_date_and_time;
                               FileFlags:iso_directory_flags;
                               FileUnitSize:iso_int8;
                               InterLeaveGapSize:iso_int8;
                               VolumeSequenceNumber:iso_int16_lsb_msb;
                               LengthOfFileId:iso_int8;
                               Padding:iso_int8;
                               end;
     iso_volume_descriptor_primary_volume_descriptor=packed record
                                                     VolumeDescriptorType:iso_int8;
                                                     StandardId:array[1..5] of iso_a_char;
                                                     Version:iso_int8;
                                                     Unused1:iso_data;
                                                     SystemIdentifier:array[1..32] of iso_a_char;
                                                     VolumeIdentifier:array[1..32] of iso_d_char;
                                                     Unused2:array[1..8] of iso_data;
                                                     {The set size is the count of LBA block}
                                                     VolumeSpaceSize:iso_int32_lsb_msb;
                                                     Unused3:array[1..32] of iso_data;
                                                     VolumeSetSize:iso_int16_lsb_msb;
                                                     VolumeSequenceNumber:iso_int16_lsb_msb;
                                                     LogicalBlockSize:iso_int16_lsb_msb;
                                                     PathTableSize:iso_int32_lsb_msb;
                                                     {These are LBA(Logical Block Address) Data}
                                                     LocationOfTypeLPathTable:iso_int32_lsb;
                                                     LocationOfOptionalTypeLPathTable:iso_int32_lsb;
                                                     LocationOfTypeMPathTable:iso_int32_msb;
                                                     LocationOfOptionalTypeMPathTable:iso_int32_msb;
                                                     {Data Ended}
                                                     DirectoryEntryForRootDirectory:iso_root_directory_record;
                                                     VolumeSetIdentifier:array[1..128] of iso_d_char;
                                                     PublisherIdentifier:array[1..128] of iso_a_char;
                                                     DataPreparerIdentifier:array[1..128] of iso_a_char;
                                                     ApplicationIdentifier:array[1..128] of iso_a_char;
                                                     CopyrightFileIdentifier:array[1..128] of iso_d_char;
                                                     AbstractFileIdentifier:array[1..128] of iso_d_char;
                                                     BibilographicFileIdentifier:array[1..128] of iso_d_char;
                                                     VolumeCreationDateAndTime:iso_date_time;
                                                     VolumeModificationDateAndTime:iso_date_time;
                                                     VolumeExpirationDateAndTime:iso_date_time;
                                                     VolumeEffectiveDateAndTime:iso_date_time;
                                                     FileStructureVersion:iso_int8;
                                                     Unused4:iso_data;
                                                     ApplicationUsed:array[1..512] of iso_data;
                                                     Reserved:array[1..653] of iso_data;
                                                     end;
     iso_volume_descriptor_supplementary_volume_descriptor=packed record
                                                           VolumeDescriptorType:iso_int8;
                                                           StandardIdentifier:array[1..5] of iso_a_char;
                                                           Version:iso_int8;
                                                           VolumeFlags:iso_flag;
                                                           SystemId:array[1..32] of iso_a_char;
                                                           VolumeId:array[1..16] of iso_unicode;
                                                           Unused1:array[1..8] of iso_data;
                                                           {The set size is the count of LBA block}
                                                           VolumeSpaceSize:iso_int32_lsb_msb;
                                                           EscapeSequences:array[1..32] of iso_data;
                                                           VolumeSetSize:iso_int16_lsb_msb;
                                                           VolumeSequenceNumber:iso_int16_lsb_msb;
                                                           LogicalBlockSize:iso_int16_lsb_msb;
                                                           PathTableSize:iso_int32_lsb_msb;
                                                           {These are LBA(Logical Block Address) Data}
                                                           LocationOfTypeLPathTable:iso_int32_lsb;
                                                           LocationOfOptionalTypeLPathTable:iso_int32_lsb;
                                                           LocationOfTypeMPathTable:iso_int32_msb;
                                                           LocationOfOptionalTypeMPathTable:iso_int32_msb;
                                                           {Data Ended}
                                                           DirectoryEntryForRootDirectory:iso_root_directory_record;
                                                           VolumeSetIdentifier:array[1..128] of iso_d_char;
                                                           PublisherIdentifier:array[1..128] of iso_a_char;
                                                           DataPreparerIdentifier:array[1..128] of iso_a_char;
                                                           ApplicationIdentifier:array[1..128] of iso_a_char;
                                                           CopyrightFileIdentifier:array[1..128] of iso_d_char;
                                                           AbstractFileIdentifier:array[1..128] of iso_d_char;
                                                           BibilographicFileIdentifier:array[1..128] of iso_d_char;
                                                           VolumeCreationDateAndTime:iso_date_time;
                                                           VolumeModificationDateAndTime:iso_date_time;
                                                           VolumeExpirationDateAndTime:iso_date_time;
                                                           VolumeEffectiveDateAndTime:iso_date_time;
                                                           FileStructrueVersion:iso_int8;
                                                           Unused4:iso_data;
                                                           ApplicationUsed:array[1..512] of iso_data;
                                                           Reserved:array[1..653] of iso_data;
                                                           end;
     iso_volume_descriptor_volume_parition_descriptor=packed record
                                                      VolumeDescriptorType:iso_int8;
                                                      StandardIdentifier:array[1..5] of iso_a_char;
                                                      Version:iso_int8;
                                                      Unused:iso_data;
                                                      SystemId:array[1..32] of iso_a_char;
                                                      VolumeId:array[1..32] of iso_d_char;
                                                      VolumeParitionLocation:iso_int32_lsb_msb;
                                                      VolumeParitionSize:iso_int32_lsb_msb;
                                                      Data:array[1..1960] of iso_data;
                                                      end;
     iso_volume_descriptor_set_terminator=packed record
                                          VolumeDescriptorType:iso_int8;
                                          Id:array[1..5] of iso_a_char;
                                          Version:iso_int8;
                                          end;
     iso_volume_descriptor=packed record
                           case Byte of
                           0:(br:iso_volume_descriptor_boot_record;);
                           1:(brei:iso_volume_descriptor_boot_record_for_ei_torito;);
                           2:(pvd:iso_volume_descriptor_primary_volume_descriptor;);
                           3:(svd:iso_volume_descriptor_supplementary_volume_descriptor;);
                           4:(vp:iso_volume_descriptor_volume_parition_descriptor;);
                           5:(st:iso_volume_descriptor_set_terminator;);
                           end;
     iso_path_table=packed record
                    LengthOfDirectoryId:iso_int8;
                    ExtendAttributeLength:iso_int8;
                    LocationOfExtent:iso_int32;
                    DirectoryNumberOfParentDirectory:iso_int16;
                    DirectoryIdAndPadding:array[1..256] of iso_data;
                    end;
     iso_extended_directory_date_and_time=packed record
                                          NumberOfYears:array[1..4] of char;
                                          MonthOfYears:array[1..2] of char;
                                          DayOfMonth:array[1..2] of char;
                                          HourOfDay:array[1..2] of char;
                                          MinuteOfHour:array[1..2] of char;
                                          SecondOfMinute:array[1..2] of char;
                                          OffsetFromGreenWich:iso_sint8;
                                          end;
     iso_directory_record=packed record
                          LengthOfDirRecord:iso_int8;
                          ExtendedAttributeRecordLength:iso_int8;
                          LocationOfExtent:iso_int32_lsb_msb;
                          DataLength:iso_int32_lsb_msb;
                          DateAndTime:iso_directory_date_and_time;
                          FileFlags:iso_directory_flags;
                          FileUnitSize:iso_int8;
                          InterLeaveGapSize:iso_int8;
                          VolumeSequenceNumber:iso_int16_lsb_msb;
                          LengthOfFileId:iso_int8;
                          FileIdAndSystemUse:array[1..256] of iso_data;
                          end;
     iso_permission=bitpacked record
                    SystemUserNotRead:0..1;
                    Default1:0..1;
                    SystemUserNotExecute:0..1;
                    Default2:0..1;
                    OwnerNotRead:0..1;
                    Default3:0..1;
                    OwnerNotExecute:0..1;
                    Default4:0..1;
                    AnyUserNotRead:0..1;
                    Default5:0..1;
                    AnyUserNotExecute:0..1;
                    Default6:0..1;
                    NoSystemUserNotRead:0..1;
                    Default7:0..1;
                    NoSystemUserNotExecute:0..1;
                    Default8:0..1;
                    end;
     iso_extended_attribute_record=packed record
                                   OwnerId:array[1..4] of iso_int8;
                                   GroupId:array[1..4] of iso_int8;
                                   Permission:iso_permission;
                                   FileCreationDateAndTime:iso_extended_directory_date_and_time;
                                   FileModificationDateAndTime:iso_extended_directory_date_and_time;
                                   FileExpirationDateAndTime:iso_extended_directory_date_and_time;
                                   FileEffectiveDateAndTime:iso_extended_directory_date_and_time;
                                   RecordFormat:iso_data16;
                                   RecordAttributes:byte;
                                   RecordLength:iso_lsb_msb_word;
                                   SystemId:array[1..32] of iso_data;
                                   SystemUse:array[1..64] of iso_data;
                                   ExtendedAttributeRecordVersion:iso_data;
                                   LengthOfEscapeSequences:iso_data;
                                   Reserved:array[1..64] of iso_data;
                                   ApplicationUse:array[1..4] of iso_data;
                                   ApplicationUseAndEscapeSequences:array[1..65536] of iso_data;
                                   end;
     iso_el_torito_vaildation_entry=packed record
                                    HeaderId:byte;
                                    PlatformId:byte;
                                    Reserved:word;
                                    id:array[1..24] of char;
                                    checksum:word;
                                    key1,key2:byte;
                                    end;
     iso_el_torito_initial_entry=packed record
                                 bootIndicator:byte;
                                 bootmediatype:byte;
                                 LoadSegment:word;
                                 SystemType:byte;
                                 Unused1:byte;
                                 SectorCount:word;
                                 LoadRelativeBlockAddress:dword;
                                 Unused2:array[1..20] of byte;
                                 end;
     iso_el_torito_boot_catalog_needed=packed record
                                       vaildation:iso_el_torito_vaildation_entry;
                                       initial:iso_el_torito_initial_entry;
                                       end;
     iso_el_torito_section_header_entry=packed record
                                        HeadIndicator:byte;
                                        PlatformId:byte;
                                        NumberOfSectionEntries:word;
                                        Id:array[1..28] of char;
                                        end;
     iso_el_torito_section_entry=packed record
                                 bootIndicator:byte;
                                 bootMediaType:byte;
                                 LoadSegment:word;
                                 SystemType:byte;
                                 Unused:byte;
                                 SectorCount:word;
                                 LoadRelativeBlockAddress:dword;
                                 SectionCriteriaType:byte;
                                 VolumeUniqueSectionCriteria:array[1..19] of char;
                                 end;
     iso_el_torito_extension_flag=bitpacked record
                                  Unused1:0..31;
                                  ExtRecordFollow:0..1;
                                  Unused2:0..3;
                                  end;
     iso_el_torito_section_entry_extension=packed record
                                           ExtensionIndicator:byte;
                                           ExtensionFlag:iso_el_torito_extension_flag;
                                           VolumeUniqueSectionCriteria:array[1..34] of char;
                                           end;

operator := (x:word)res:iso_lsb_word;
operator := (x:dword)res:iso_lsb_dword;
operator := (x:qword)res:iso_lsb_qword;
operator := (x:shortint)res:iso_lsb_shortint;
operator := (x:integer)res:iso_lsb_integer;
operator := (x:int64)res:iso_lsb_int64;
function iso_lsb_to_data(lsbword:iso_lsb_word):word;
function iso_lsb_to_data(lsbdword:iso_lsb_dword):dword;
function iso_lsb_to_data(lsbqword:iso_lsb_qword):qword;
function iso_lsb_to_data(lsbshortint:iso_lsb_shortint):shortint;
function iso_lsb_to_data(lsbinteger:iso_lsb_integer):integer;
function iso_lsb_to_data(lsbint64:iso_lsb_int64):int64;
function iso_msb_to_data(msbword:iso_msb_word):word;
function iso_msb_to_data(msbdword:iso_msb_dword):dword;
function iso_msb_to_data(msbqword:iso_msb_qword):qword;
function iso_msb_to_data(msbshortint:iso_msb_shortint):shortint;
function iso_msb_to_data(msbinteger:iso_msb_integer):integer;
function iso_msb_to_data(msbint64:iso_msb_int64):int64;
function iso_lsb_msb_to_data(lsbmsbword:iso_lsb_msb_word):word;
function iso_lsb_msb_to_data(lsbmsbdword:iso_lsb_msb_dword):dword;
function iso_lsb_msb_to_data(lsbmsbqword:iso_lsb_msb_qword):qword;
function iso_lsb_msb_to_data(lsbmsbshortint:iso_lsb_msb_shortint):shortint;
function iso_lsb_msb_to_data(lsbmsbinteger:iso_lsb_msb_integer):integer;
function iso_lsb_msb_to_data(lsbmsbint64:iso_lsb_msb_int64):int64;
function iso_lsb_to_msb(lsbword:iso_lsb_word):iso_msb_word;
function iso_lsb_to_msb(lsbdword:iso_lsb_dword):iso_msb_dword;
function iso_lsb_to_msb(lsbqword:iso_lsb_qword):iso_msb_qword;
function iso_lsb_to_msb(lsbshortint:iso_lsb_shortint):iso_msb_shortint;
function iso_lsb_to_msb(lsbinteger:iso_lsb_integer):iso_msb_integer;
function iso_lsb_to_msb(lsbint64:iso_lsb_int64):iso_msb_int64;
function iso_msb_to_lsb(msbword:iso_msb_word):iso_lsb_word;
function iso_msb_to_lsb(msbdword:iso_msb_dword):iso_lsb_dword;
function iso_msb_to_lsb(msbqword:iso_msb_qword):iso_lsb_qword;
function iso_msb_to_lsb(msbshortint:iso_msb_shortint):iso_lsb_shortint;
function iso_msb_to_lsb(msbinteger:iso_msb_integer):iso_lsb_integer;
function iso_msb_to_lsb(msbint64:iso_msb_int64):iso_lsb_int64;
function iso_lsb_to_lsb_msb(lsbword:iso_lsb_word):iso_lsb_msb_word;
function iso_lsb_to_lsb_msb(lsbdword:iso_lsb_dword):iso_lsb_msb_dword;
function iso_lsb_to_lsb_msb(lsbqword:iso_lsb_qword):iso_lsb_msb_qword;
function iso_lsb_to_lsb_msb(lsbshortint:iso_lsb_shortint):iso_lsb_msb_shortint;
function iso_lsb_to_lsb_msb(lsbinteger:iso_lsb_integer):iso_lsb_msb_integer;
function iso_lsb_to_lsb_msb(lsbint64:iso_lsb_int64):iso_lsb_msb_int64;
procedure iso_volume_descriptor_initialize(var isovd:iso_volume_descriptor);

implementation

operator := (x:word)res:iso_lsb_word;
begin
 Pword(@res)^:=x;
end;
operator := (x:dword)res:iso_lsb_dword;
begin
 Pdword(@res)^:=x;
end;
operator := (x:qword)res:iso_lsb_qword;
begin
 Pqword(@res)^:=x;
end;
operator := (x:shortint)res:iso_lsb_shortint;
begin
 Pshortint(@res)^:=x;
end;
operator := (x:integer)res:iso_lsb_integer;
begin
 Pinteger(@res)^:=x;
end;
operator := (x:int64)res:iso_lsb_int64;
begin
 Pint64(@res)^:=x;
end;
function iso_lsb_to_data(lsbword:iso_lsb_word):word;
begin
 iso_lsb_to_data:=Pword(@lsbword)^;
end;
function iso_lsb_to_data(lsbdword:iso_lsb_dword):dword;
begin
 iso_lsb_to_data:=Pdword(@lsbdword)^;
end;
function iso_lsb_to_data(lsbqword:iso_lsb_qword):qword;
begin
 iso_lsb_to_data:=Pqword(@lsbqword)^;
end;
function iso_lsb_to_data(lsbshortint:iso_lsb_shortint):shortint;
begin
 iso_lsb_to_data:=Pshortint(@lsbshortint)^;
end;
function iso_lsb_to_data(lsbinteger:iso_lsb_integer):integer;
begin
 iso_lsb_to_data:=PInteger(@lsbinteger)^;
end;
function iso_lsb_to_data(lsbint64:iso_lsb_int64):int64;
begin
 iso_lsb_to_data:=Pint64(@lsbint64)^;
end;
function iso_lsb_msb_to_data(lsbmsbword:iso_lsb_msb_word):word;
begin
 iso_lsb_msb_to_data:=Pword(@lsbmsbword)^;
end;
function iso_lsb_msb_to_data(lsbmsbdword:iso_lsb_msb_dword):dword;
begin
 iso_lsb_msb_to_data:=Pdword(@lsbmsbdword)^;
end;
function iso_lsb_msb_to_data(lsbmsbqword:iso_lsb_msb_qword):qword;
begin
 iso_lsb_msb_to_data:=Pqword(@lsbmsbqword)^;
end;
function iso_lsb_msb_to_data(lsbmsbshortint:iso_lsb_msb_shortint):shortint;
begin
 iso_lsb_msb_to_data:=Pshortint(@lsbmsbshortint)^;
end;
function iso_lsb_msb_to_data(lsbmsbinteger:iso_lsb_msb_integer):integer;
begin
 iso_lsb_msb_to_data:=PInteger(@lsbmsbinteger)^;
end;
function iso_lsb_msb_to_data(lsbmsbint64:iso_lsb_msb_int64):int64;
begin
 iso_lsb_msb_to_data:=Pint64(@lsbmsbint64)^;
end;
function iso_msb_to_data(msbword:iso_msb_word):word;
var tempnum:iso_lsb_word;
begin
 tempnum:=iso_msb_to_lsb(msbword);
 iso_msb_to_data:=Pword(@tempnum)^;
end;
function iso_msb_to_data(msbdword:iso_msb_dword):dword;
var tempnum:iso_lsb_dword;
begin
 tempnum:=iso_msb_to_lsb(msbdword);
 iso_msb_to_data:=Pdword(@tempnum)^;
end;
function iso_msb_to_data(msbqword:iso_msb_qword):qword;
var tempnum:iso_lsb_qword;
begin
 tempnum:=iso_msb_to_lsb(msbqword);
 iso_msb_to_data:=Pqword(@tempnum)^;
end;
function iso_msb_to_data(msbshortint:iso_msb_shortint):shortint;
var tempnum:iso_lsb_shortint;
begin
 tempnum:=iso_msb_to_lsb(msbshortint);
 iso_msb_to_data:=Pshortint(@tempnum)^;
end;
function iso_msb_to_data(msbinteger:iso_msb_integer):integer;
var tempnum:iso_lsb_integer;
begin
 tempnum:=iso_msb_to_lsb(msbinteger);
 iso_msb_to_data:=Pinteger(@tempnum)^;
end;
function iso_msb_to_data(msbint64:iso_msb_int64):int64;
var tempnum:iso_lsb_int64;
begin
 tempnum:=iso_msb_to_lsb(msbint64);
 iso_msb_to_data:=Pint64(@tempnum)^;
end;
function iso_lsb_to_msb(lsbword:iso_lsb_word):iso_msb_word;
var res:iso_msb_word;
begin
 res.data1:=lsbword.data1; res.data2:=lsbword.data2;
 iso_lsb_to_msb:=res;
end;
function iso_lsb_to_msb(lsbdword:iso_lsb_dword):iso_msb_dword;
var res:iso_msb_dword;
begin
 res.data1:=iso_lsb_to_msb(lsbdword.data1);
 res.data2:=iso_lsb_to_msb(lsbdword.data2);
 iso_lsb_to_msb:=res;
end;
function iso_lsb_to_msb(lsbqword:iso_lsb_qword):iso_msb_qword;
var res:iso_msb_qword;
begin
 res.data1:=iso_lsb_to_msb(lsbqword.data1);
 res.data2:=iso_lsb_to_msb(lsbqword.data2);
 iso_lsb_to_msb:=res;
end;
function iso_lsb_to_msb(lsbshortint:iso_lsb_shortint):iso_msb_shortint;
var res:iso_msb_shortint;
begin
 res.data1:=lsbshortint.data1; res.data2:=lsbshortint.data2;
 iso_lsb_to_msb:=res;
end;
function iso_lsb_to_msb(lsbinteger:iso_lsb_integer):iso_msb_integer;
var res:iso_msb_integer;
begin
 res.data1:=iso_lsb_to_msb(lsbinteger.data1);
 res.data2:=iso_lsb_to_msb(lsbinteger.data2);
 iso_lsb_to_msb:=res;
end;
function iso_lsb_to_msb(lsbint64:iso_lsb_int64):iso_msb_int64;
var res:iso_msb_int64;
begin
 res.data1:=iso_lsb_to_msb(lsbint64.data1);
 res.data2:=iso_lsb_to_msb(lsbint64.data2);
 iso_lsb_to_msb:=res;
end;
function iso_msb_to_lsb(msbword:iso_msb_word):iso_lsb_word;
var res:iso_lsb_word;
begin
 res.data1:=msbword.data1; res.data2:=msbword.data2;
 iso_msb_to_lsb:=res;
end;
function iso_msb_to_lsb(msbdword:iso_msb_dword):iso_lsb_dword;
var res:iso_lsb_dword;
begin
 res.data1:=iso_msb_to_lsb(msbdword.data1);
 res.data2:=iso_msb_to_lsb(msbdword.data2);
 iso_msb_to_lsb:=res;
end;
function iso_msb_to_lsb(msbqword:iso_msb_qword):iso_lsb_qword;
var res:iso_lsb_qword;
begin
 res.data1:=iso_msb_to_lsb(msbqword.data1);
 res.data2:=iso_msb_to_lsb(msbqword.data2);
 iso_msb_to_lsb:=res;
end;
function iso_msb_to_lsb(msbshortint:iso_msb_shortint):iso_lsb_shortint;
var res:iso_lsb_shortint;
begin
 res.data1:=msbshortint.data1; res.data2:=msbshortint.data2;
 iso_msb_to_lsb:=res;
end;
function iso_msb_to_lsb(msbinteger:iso_msb_integer):iso_lsb_integer;
var res:iso_lsb_integer;
begin
 res.data1:=iso_msb_to_lsb(msbinteger.data1);
 res.data2:=iso_msb_to_lsb(msbinteger.data2);
 iso_msb_to_lsb:=res;
end;
function iso_msb_to_lsb(msbint64:iso_msb_int64):iso_lsb_int64;
var res:iso_lsb_int64;
begin
 res.data1:=iso_msb_to_lsb(msbint64.data1);
 res.data2:=iso_msb_to_lsb(msbint64.data2);
 iso_msb_to_lsb:=res;
end;
function iso_lsb_to_lsb_msb(lsbword:iso_lsb_word):iso_lsb_msb_word;
var res:iso_lsb_msb_word;
begin
 res.data1:=lsbword; res.data2:=iso_lsb_to_msb(lsbword);
 iso_lsb_to_lsb_msb:=res;
end;
function iso_lsb_to_lsb_msb(lsbdword:iso_lsb_dword):iso_lsb_msb_dword;
var res:iso_lsb_msb_dword;
begin
 res.data1:=lsbdword; res.data2:=iso_lsb_to_msb(lsbdword);
 iso_lsb_to_lsb_msb:=res;
end;
function iso_lsb_to_lsb_msb(lsbqword:iso_lsb_qword):iso_lsb_msb_qword;
var res:iso_lsb_msb_qword;
begin
 res.data1:=lsbqword; res.data2:=iso_lsb_to_msb(lsbqword);
 iso_lsb_to_lsb_msb:=res;
end;
function iso_lsb_to_lsb_msb(lsbshortint:iso_lsb_shortint):iso_lsb_msb_shortint;
var res:iso_lsb_msb_shortint;
begin
 res.data1:=lsbshortint; res.data2:=iso_lsb_to_msb(lsbshortint);
 iso_lsb_to_lsb_msb:=res;
end;
function iso_lsb_to_lsb_msb(lsbinteger:iso_lsb_integer):iso_lsb_msb_integer;
var res:iso_lsb_msb_integer;
begin
 res.data1:=lsbinteger; res.data2:=iso_lsb_to_msb(lsbinteger);
 iso_lsb_to_lsb_msb:=res;
end;
function iso_lsb_to_lsb_msb(lsbint64:iso_lsb_int64):iso_lsb_msb_int64;
var res:iso_lsb_msb_int64;
begin
 res.data1:=lsbint64; res.data2:=iso_lsb_to_msb(lsbint64);
 iso_lsb_to_lsb_msb:=res;
end;
procedure iso_volume_descriptor_initialize(var isovd:iso_volume_descriptor);
var ptr:Pqword;
    i:word;
begin
 ptr:=Pqword(@isovd);
 for i:=1 to sizeof(isovd) shr 3 do (ptr+i-1)^:=0;
end;

end.

