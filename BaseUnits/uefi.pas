unit uefi;

{$MODE FPC}

interface
const efi_usb_max_bulk_buffer_num=10;
      efi_usb_max_iso_buffer_num=7;
      efi_usb_max_iso_buffer_num1=2;
      image_file_machine_i386:word=$014C;
      image_file_machine_x64:word=$8664;
      image_file_machine_ia64:word=$0200;
      image_file_machine_ebc:word=$0EBC;
      image_file_machine_armthumb_mixed:word=$01C2;
      image_file_machine_aarch64:word=$AA64;
      image_file_machine_riscv32:word=$5032;
      image_file_machine_riscv64:word=$5064;
      image_file_machine_riscv128:word=$5128;
      image_file_machine_loongarch32:word=$6232;
      image_file_machine_loongarch64:word=$6264;
      max_mcast_filter_cnt=16;
      efi_pxe_base_code_max_arp_entries=8;
      efi_pxe_base_code_max_route_entries=8;
      efi_pxe_base_code_max_ipcnt=8;
      bluetooth_hci_command_local_readable_name_max_size=248;
      efi_bluetooth_config_remote_device_state_connected=$1;
      efi_bluetooth_config_remote_device_state_paired=$2;
      bluetooth_hci_link_key_size=16;
      
type efi_lba=qword;
     fat32_header=packed record
                  JumpOrder:array[1..3] of byte;
                  OemCode:array[1..8] of char;
                  BytesPerSector:word;
                  SectorPerCluster:byte;
                  ReservedSectorCount:word;
                  NumFATs:byte;
                  RootEntryCount:word;
                  TotalSector16:word;
                  Media:byte;
                  FATSectors16:word;
                  SectorPerTrack:word;
                  NumHeads:word;
                  HiddenSectors:dword;
                  TotalSectors32:dword;
                  FATSector32:dword;
                  ExtendedFlags:word;
                  FileSystemVersion:word;
                  RootCluster:dword;
                  FileSystemInfo:word;
                  BootSector:word;
                  Reserved:array[1..12] of byte;
                  DriverNumber:byte;
                  Reserved1:byte;
                  BootSignature:byte;
                  VolumeID:dword;
                  VolumeLabel:array[1..11] of char;
                  FileSystemType:array[1..8] of char;
                  Reserved2:array[1..420] of byte;
                  SignatureWord:word;
                  Reserved3:array[1..65023] of byte;
                  end;
     fat32_file_system_info=packed record
                            FSI_leadSig:dword;
                            FSI_Reserved1:array[1..480] of byte;
                            FSI_StrucSig:dword;
                            FSI_FreeCount:dword;
                            FSI_NextFree:dword;
                            FSI_Reserved2:array[1..12] of byte;
                            FSI_TrailSig:dword;
                            FSI_Reserved3:array[1..65023] of byte;
                            end;
     mbr_partition_record=packed record
                          BootIndicator:byte;
                          StartingCHS:array[1..3] of byte;
                          OSType:byte;
                          EndingCHS:array[1..3] of byte;
                          StartingLBA:dword;
                          SizeinLBA:dword;
                          end;
     master_boot_record=packed record
                        BootStrapCode:array[1..440] of byte;
                        UniqueMbrSignature:dword;
                        Unknown:word;
                        Partition:array[1..4] of mbr_partition_record;
                        Signature:word;
                        end;
     efi_guid=packed record
              data1:dword;
              data2:word;
              data3:word;
              data4:array[1..8] of byte;
              end; 
     efi_gpt_header=packed record
                    signature:qword;
                    Revision:dword;
                    HeaderSize:dword;
                    HeaderCRC32:dword;
                    Reserved1:dword;
                    MyLBA:qword;
                    AlternateLBA:qword;
                    FirstUsableLBA:qword;
                    LastUsableLBA:qword;
                    DiskGuid:efi_guid;
                    PartitionEntryLBA:qword;
                    NumberOfPartitionEntries:dword;
                    SizeOfPartitionEntry:dword;
                    PartitionEntryArrayCRC32:dword;
                    Reserved2:array[1..65444] of byte;
                    end;
     efi_partition_entry=packed record
                         PartitionTypeGUID:efi_guid;
                         UniquePartitionGUID:efi_guid;
                         StartingLBA:efi_lba;
                         EndingLBA:efi_lba;
                         Attributes:qword;
                         PartitionName:array[1..36] of WideChar;
                         end;
     Pefi_guid=^efi_guid;
     PPefi_guid=^Pefi_guid;
     PPPefi_guid=^PPefi_guid;
     efi_ipv4_address=record
                      Addr:array[1..4] of byte;
                      end;
     efi_ipv6_address=record
                      Addr:array[1..16] of byte;
                      end;
     efi_ip_address=record
                    case byte of 
                    0:(Addr:array[1..4] of byte;);
                    1:(v4:efi_ipv4_address;);
                    2:(v6:efi_ipv6_address;);
                    end;
     efi_mac_address=record
                     Addr:array[1..32] of byte;
                     end;
     Pefi_ip_address=^efi_ip_address;
     Pefi_mac_address=^efi_mac_address;
     efi_btt_info_block=record
                        sig:array[1..16] of char;
                        uuid:efi_guid;
                        Parentuuid:efi_guid;
                        Flags:longword;
                        Major,Minor:word;
                        ExternallbaSize,ExternalNlba:longword;
                        Internallbasize,InternalNlba:longword;
                        Nfree:longword;
                        InfoSize:longword;
                        NextOff,DataOff,MapOff,FlogOff,InfoOff:qword;
                        unused:array[1..3968] of char;
                        Checksum:qword;
                        end;
     efi_btt_map_entry=bitpacked record
                       PostMapLba:0..1073741823;
                       Error:0..1;
                       Zero:0..1;
                       end;
     efi_table_header=record
		      signature:qword;
		      revision:dword;
		      headersize:dword;
		      crc32:dword;
		      reserved:dword;
                      end;
     efi_tape_header=record
                     Signature:qword;
                     Revision:dword;
                     BootDescSize:dword;
                     BootDescCRC:dword;
                     TapeGUID:efi_guid;
                     TapeType:efi_guid;
                     TapeUnique:efi_guid;
                     OSVersion:array[1..40] of char;
                     AppVersion:array[1..40] of char;
                     CreationDate:array[1..10] of char;
                     CreationTime:array[1..10] of char;
                     SystemName:array[1..256] of char;
                     TapeTitle:array[1..120] of char;
                     Pad:array[1..468] of char;
                     end;
     efi_handle=pointer;
     Pefi_handle=^pointer;
     PPefi_handle=^Pefi_handle;
     efi_hii_handle=pointer;
     Pefi_hii_handle=^pointer;
     PPefi_hii_handle=^Pefi_hii_handle;
     efi_event=pointer;
     Pefi_event=^pointer;
     PPefi_event=^Pefi_event;
     efi_physical_address=qword;
     efi_virtual_address=qword;
     efi_status=Natuint;
     Pefi_status=^Natuint;
     efi_input_key=record
                   scancode:word;
                   UnicodeChar:WideChar;
                   end;
     Pefi_simple_text_input_protocol=^efi_simple_text_input_protocol;
     efi_input_reset=function (This:Pefi_simple_text_input_protocol;ExtendedVerification:boolean):efi_status;cdecl;
     efi_input_read_key=function (This:Pefi_simple_text_input_protocol;var key:efi_input_key):efi_status;cdecl;
     efi_simple_text_input_protocol=record
      				    Reset:efi_input_reset;
      				    ReadKeyStroke:efi_input_read_key;
      				    WaitForKey:efi_event;
                                    end;
     Pefi_simple_text_output_protocol=^efi_simple_text_output_protocol;
     simple_text_output_mode=record
                             MaxMode:integer;
                             SMode:integer;
                             SAttribute:integer;
                             CursorColumn:integer;
                             CursorRow:integer;
                             CursorVisible:boolean;
                             end;
     efi_text_reset=function (This:Pefi_simple_text_output_protocol;ExtendedVerification:boolean):efi_status;cdecl;
     efi_text_output_string=function (This:Pefi_simple_text_output_protocol;efistring:PWideChar):efi_status;cdecl;
     efi_text_test_string=function (This:Pefi_simple_text_output_protocol;efistring:PWideChar):efi_status;cdecl;
     efi_text_query_mode=function (This:Pefi_simple_text_output_protocol;Modenumber:NatUint;var Columns,Rows:Natuint):efi_status;cdecl;
     efi_text_set_mode=function (This:Pefi_simple_text_output_protocol;Modenumber:NatUint):efi_status;cdecl;
     efi_text_set_attribute=function (This:Pefi_simple_text_output_protocol;eattribute:NatUint):efi_status;cdecl;
     efi_text_clear_screen=function (This:Pefi_simple_text_output_protocol):efi_status;cdecl;
     efi_text_set_cursor_position=function (This:Pefi_simple_text_output_protocol;column,row:Natuint):efi_status;cdecl;
     efi_text_enable_cursor=function (This:Pefi_simple_text_output_protocol;visible:boolean):efi_status;cdecl;
     efi_simple_text_output_protocol=record
                                     Reset:efi_text_reset;
                                     Outputstring:efi_text_output_string;
                                     Teststring:efi_text_test_string;
                                     QueryMode:efi_text_query_mode;
                                     SetMode:efi_text_set_mode;
                                     SetAttribute:efi_text_set_attribute;
                                     clearscreen:efi_text_clear_screen;
                                     setcursorposition:efi_text_set_cursor_position;
                                     enablecursor:efi_text_enable_cursor;
                                     mode:^simple_text_output_mode;
                                     end;
     efi_time=record
     	      year:word;
     	      month:byte;
     	      day:byte;
     	      hour:byte;
     	      minute:byte;
     	      second:byte;
     	      pad1:byte;
     	      nanosecond:longword;
     	      timezone:smallint;
     	      daylight:byte;
     	      pad2:byte;
              end; 
     Pefi_time=^efi_time;
     efi_time_capabilities=record
                           resolution:dword;
                           accuracy:dword;
                           SetsToZero:boolean;
                           end;
     Pefi_time_capabilities=^efi_time_capabilities;
     efi_memory_descriptor=record
                           efitype:longword;
                           physicalstart:efi_physical_address;
                           virtualstart:efi_virtual_address;
                           NumberofPages:qword;
                           efiAttribute:qword;
                           end;
     Pefi_memory_descriptor=^efi_memory_descriptor;
     efi_get_time=function (var Time:efi_time;var Capabilities:efi_time_capabilities):efi_status;cdecl;
     efi_set_time=function (Time:Pefi_time):efi_status;cdecl;
     efi_get_wakeup_time=function (var Enabled,Pending:boolean;var Time:efi_time):efi_status;cdecl;
     efi_set_wakeup_time=function (enabled:boolean;Time:Pefi_time):efi_status;cdecl;
     efi_set_virtual_address_map=function (MemoryMapSize,DescriptorSize:NatUint;DescriptorVersion:dword;VirtualMap:Pefi_memory_descriptor):efi_status;cdecl;
     efi_convert_pointer=function (DebugPosition:NatUint;Address:PPointer):efi_status;cdecl;
     efi_get_variable=function (VariableName:PWideChar;VendorGuid:Pefi_guid;var attributes:dword;var datasize:NatUint;var data):efi_Status;cdecl;
     efi_get_next_variable_name=function (var VariableNameSize:PNatUint;var VariableName:PWidechar;var VendorGuid:Pefi_guid):efi_status;cdecl;
     efi_set_variable=function (VariableName:PWideChar;VendorGuid:Pefi_guid;Attributes:dword;DataSize:Natuint;Data:Pointer):efi_status;cdecl;
     efi_get_next_monotonic_count=function (var Highcount:dword):efi_Status;cdecl;
     efi_reset_type=(EfiResetCold,EfiResetWarm,EfiResetShutDown,EfiResetPlatformSpecific);
     Pefi_reset_type=^efi_reset_type;
     efi_reset_system=function (ResetType:efi_reset_type;ResetStatus:efi_status;DataSize:Natuint;ResetData:Pointer):efi_status;cdecl;
     efi_capsule_block_descriptor=record
                        	  efilength:qword;
                        	  case Boolean of 
                       		  True:(DataBlock:efi_physical_address);
                        	  False:(ContinuationPointer:efi_physical_address);
                      		  end;
     efi_capsule_header=record
                        CapsuleGuid:efi_guid;
                        headersize:dword;
                        flags:dword;
                        CapsuleImageSize:dword;
                        end;
     efi_capsule_table=record
                       CapsuleArrayNumber:dword;
                       CapsulePtr:array[1..1] of Pointer;
                       end;
     Pefi_capsule_header=^efi_capsule_header;
     PPefi_capsule_header=^Pefi_capsule_header;
     efi_update_capsule=function (CapsuleHeaderArray:PPefi_capsule_header;CapsuleCount:NatUint;ScatterGatherList:efi_physical_address):efi_status;cdecl;
     efi_query_capsule_capabilities=function (CapsuleHeaderArray:PPefi_capsule_header;CapsuleCount:NatUint;var MaximumCapsuleSize:qword;var ResetType:efi_reset_type):efi_status;cdecl;
     efi_query_variable_info=function (attributes:dword;MaximumVariableStorageSize,RemainingVariableStorageSize,MaximumVariableSize:Pqword):efi_status;cdecl;                 
     efi_runtime_services=record
                          hdr:efi_table_header;
                          Gettime:efi_get_time;
                          Settime:efi_set_time;
                          GetWakeupTime:efi_get_wakeup_time;
                          SetWakeupTime:efi_set_wakeup_time;
                          SetVirtualAddressMap:efi_set_virtual_address_map;
                          ConvertPointer:efi_convert_pointer;
                          getvariable:efi_get_variable;
                          getnextvariablename:efi_get_next_variable_name;
                          setvariable:efi_set_variable;
                          GetNextMonotonicCount:efi_get_next_monotonic_count;
                          ResetSystem:efi_reset_system;
                          UpdateCapsule:efi_update_capsule;
                          QueryCapsuleCapabilities:efi_query_capsule_capabilities;
                          QueryVariableInfo:efi_query_variable_info;
                          end;
     efi_tpl=NatUint;
     efi_raise_tpl=function (NewTpl:efi_tpl):efi_status;cdecl;
     efi_restore_tpl=function (OldTpl:efi_tpl):efi_status;cdecl;
     efi_allocate_type=(AllocateAnyPages,AllocateMaxAddress,AllocateAddress,MaxAllocateType);
       	efi_memory_type=(EfiReservedMemoryType,EfiLoaderCode,EfiLoaderData,EfiBootServicesCode,EfiBootServicesData,EfiRuntimeServicesCode,EfiRuntimeServicesData,EfiConventionalMemory,EfiUnusableMemory,EfiACPIReclaimMemory,EfiACPIMemoryNVS,EfiMemoryMappedIO,EfiMemoryMappedIOPortSpace,EfiPalCode,EfiPersistentMemory,EfiUnacceptedMemoryType,EfiMaxMemoryType);
     efi_allocate_pages=function (efitype:efi_allocate_type;MemoryType:efi_memory_type;Pages:NatUint;var Memory:qword):efi_status;cdecl;
     efi_free_pages=function (Memory:qword;Pages:NatUint):efi_status;cdecl;
     efi_get_memory_map=function (var MemoryMapSize:Natuint;var Memory_map:efi_memory_descriptor;var MapKey,DescriptorSize:NatUint;var DescriptorVersion:dword):efi_status;cdecl;
     efi_allocate_pool=function (PoolType:efi_memory_type;Size:NatUint;var Buffer:Pointer):efi_status;cdecl;
     efi_free_pool=function (Buffer:Pointer):efi_status;cdecl;
     efi_event_notify=procedure (Event:efi_event;Context:Pointer);cdecl;
     efi_create_event=function (efitype:dword;NotifyTpl:efi_tpl;NotifyFunction:efi_event_notify;NotifyContext:Pointer;var Event:efi_event):efi_status;cdecl;
     efi_create_event_ex=function (efitype:dword;NotifyTpl:efi_tpl;NotifyFunction:efi_event_notify;const NotifyContext:Pointer;const EventGroup:Pefi_guid;var Event:efi_event):efi_status;cdecl;
     efi_timer_delay=(TimerCancel,TimerPeriodic,TimerRelative);
     efi_set_timer=function (event:efi_event;efitype:efi_timer_delay;TriggerTime:qword):efi_status;cdecl;
     efi_wait_for_event=function (NumberOfEvents:NatUint;Event:Pefi_event;var Index:NatUint):efi_status;cdecl;
     efi_signal_event=function (event:efi_event):efi_status;cdecl;
     efi_close_event=function (event:efi_event):efi_status;cdecl;
     efi_check_event=function (event:efi_event):efi_status;cdecl;
     efi_interface_type=(efi_native_interface);
     efi_install_protocol_interface=function (var Handle:efi_handle;Protocol:Pefi_guid;InterfaceType:efi_interface_type;efiinterface:Pointer):efi_status;cdecl;
     efi_reinstall_protocol_interface=function (Handle:efi_handle;Protocol:Pefi_guid;Oldinterface,Newinterface:Pointer):efi_status;cdecl;
     efi_uninstall_protocol_interface=function (Handle:efi_handle;Protocol:Pefi_guid;efiinterface:Pointer):efi_status;cdecl;
     efi_handle_protocol=function (Handle:efi_handle;Protocol:Pefi_guid;var efiinterface:Pointer):efi_status;cdecl;
     efi_register_protocol_notify=function (Protocol:Pefi_guid;Event:efi_event;var Registration:Pointer):efi_status;cdecl;
     efi_locate_search_type=(AllHandles,ByRegisterNotify,ByProtocol);
     efi_locate_handle=function (SearchType:efi_locate_search_type;Protocol:Pefi_guid;SearchKey:Pointer;var BufferSize:Pointer;var Buffer:Pefi_handle):efi_status;cdecl;
     efi_device_path_protocol=record
                              efitype:byte;
                              subtype:byte;
                              efilength:array[1..2] of byte;
                              end;
     Pefi_device_path_protocol=^efi_device_path_protocol;
     PPefi_device_path_protocol=^Pefi_device_path_protocol;
     efi_device_path=efi_device_path_protocol;
     Pefi_device_path=^efi_device_path;
     efi_locate_device_path=function (Protocol:Pefi_guid;var DevicePath:Pefi_device_path_protocol;Device:Pefi_handle):efi_status;cdecl;
     efi_install_configuration_table=function (Guid:Pefi_guid;Table:Pointer):efi_status;cdecl;
     efi_image_load=function (BootPolicy:boolean;ParentImageHandle:efi_handle;DevicePath:Pefi_device_path_protocol;SourceBuffer:Pointer;SourceSize:NatUint;var ImageHandle:efi_handle):efi_status;cdecl;
     efi_image_start=function (ImageHandle:efi_handle;var ExitDataSize:NatUint;var ExitData:PWideChar):efi_status;cdecl;
     efi_exit=function (ImageHandle:efi_handle;ExitStatus:efi_status;ExitDataSize:NatUInt;ExitData:PWideChar):efi_status;cdecl;
     efi_image_unload=function (ImageHandle:efi_handle):efi_status;cdecl;
     efi_exit_boot_services=function (ImageHandle:efi_handle;MapKey:NatUint):efi_status;cdecl;
     efi_stall=function (Microseconds:NatUint):efi_status;cdecl;
     efi_set_watchdog_timer=function (Timeout:NatUint;Watchdogcode:qword;DataSize:NatUint;WatchDogData:PWideChar):efi_status;cdecl;
     efi_connect_controller=function (ControllerHandle:efi_handle;DriveImageHandle:Pefi_handle;RemainingDevicePath:Pefi_device_path_protocol;Recursive:boolean):efi_status;cdecl;
     efi_disconnect_controller=function (ControllerHandle,DriverImageHandle,ChildHandle:efi_handle):efi_status;cdecl;
     efi_open_protocol=function (Handle:efi_handle;Protocol:Pefi_guid;var efiinterface:Pointer;AgentHandle:efi_handle;ControllerHandle:efi_handle;Attributes:dword):efi_status;cdecl;
     efi_close_protocol=function (Handle:efi_handle;Protocol:Pefi_guid;AgentHandle:efi_handle;ControllerHandle:efi_handle):efi_status;cdecl;
     efi_open_protocol_information_entry=record
     					 AgentHandle,ControllerHandle:efi_handle;
     					 Attributes,OpenCount:dword;
                                         end;
     Pefi_open_protocol_information_entry=^efi_open_protocol_information_entry;
     PPefi_open_protocol_information_entry=^Pefi_open_protocol_information_entry;
     efi_open_protocol_information=function (Handle:efi_handle;Protocol:Pefi_guid;var EntryBuffer:PPefi_open_protocol_information_entry;EntryCount:PNatUint):efi_status;cdecl;
     efi_Protocols_Per_Handle=function (Handle:efi_handle;var ProtocolBuffer:PPefi_guid;var ProtocolBufferCount:NatUint):efi_status;cdecl;
     efi_locate_handle_buffer=function (searchtype:efi_locate_search_type;Protocol:Pefi_guid;SearchKey:Pointer;var noHandles:NatUint;var Buffer:Pefi_handle):efi_status;cdecl;
     efi_locate_protocol=function (Protocol:Pefi_guid;Registation:pointer;var efiinterface:Pointer):efi_status;cdecl;
     efi_install_multiple_protocol_interfaces=function (var Handle:efi_handle;argument:array of Pointer):efi_status;cdecl;
     efi_uninstall_multiple_protocol_interfaces=function (var Handle:efi_handle;argument:array of Pointer):efi_status;cdecl;
     efi_calculate_crc32=function (Data:Pointer;DataSize:NatUint;var Crc32:dword):efi_status;cdecl;
     efi_copy_mem=procedure (Destination,Source:Pointer;efilength:NatUint);cdecl;
     efi_set_mem=procedure (Buffer:Pointer;size:NatUint;efivalue:byte);cdecl;
     efi_boot_services=record
                       hdr:efi_table_header;
                       RaiseTPL:efi_raise_tpl;
                       RestoreTPL:efi_restore_tpl;
                       AllocatePages:efi_allocate_pages;
                       FreePages:efi_free_pages;
                       GetMemoryMap:efi_get_memory_map;
                       AllocatePool:efi_allocate_pool;
                       FreePool:efi_free_pool;
                       CreateEvent:efi_create_event;
                       SetTimer:efi_set_timer;
                       WaitForEvent:efi_wait_for_event;
                       SignalEvent:efi_signal_event;
                       CloseEvent:efi_close_event;
                       CheckEvent:efi_check_event;
                       InstallProtocolInterface:efi_install_protocol_interface;
                       ReinstallProtocolInterface:efi_reinstall_protocol_interface;
                       UninstallProtocolInterface:efi_uninstall_protocol_interface;
                       HandleProtocol:efi_handle_protocol;
                       Reserved:Pointer;
                       RegisterProtocolNotify:efi_register_protocol_notify;
                       locatehandle:efi_locate_handle;
                       locatedevicepath:efi_locate_device_path;
                       InstallConfigurationTable:efi_install_configuration_table;
                       loadimage:efi_image_load;
                       startimage:efi_image_start;
                       efiexit:efi_exit;
                       unloadimage:efi_image_unload;
                       exitbootservices:efi_exit_boot_services;
                       GetNextMonotonicCount:efi_get_next_monotonic_count;
                       stall:efi_stall;
                       SetWatchDogTimer:efi_set_watchdog_timer;
                       ConnectController:efi_connect_controller;
                       DisconnectController:efi_disconnect_controller;
                       OpenProtocol:efi_open_protocol;
                       CloseProtocol:efi_close_protocol;
                       OpenProtocolInformation:efi_open_protocol_information;
                       Protocolsperhandle:efi_protocols_per_handle;
                       LocateHandleBuffer:efi_locate_handle_buffer;
                       LocateProtocol:efi_locate_protocol;
                       InstallMultipleProtocolInterfaces:efi_install_multiple_protocol_interfaces;
                       UninstallMultipleProtocolInterfaces:efi_uninstall_multiple_protocol_interfaces;
                       CalculateCrc32:efi_calculate_crc32;
                       CopyMem:efi_copy_mem;
                       SetMem:efi_set_mem;
                       CreateEventEx:efi_create_event_ex;
                       end;
     efi_configuration_table=record
                             VendorGuid:efi_guid;
                             VendorTable:pointer;
                             end;
     efi_system_table=record
                      hdr:efi_table_header;
                      FirmWareVendor:^WideChar;
                      FirmWareRevision:dword;
                      ConsoleInHandle:efi_handle;
                      ConIn:^efi_simple_text_input_protocol;
                      ConsoleOutHandle:efi_handle;
                      ConOut:^efi_simple_text_output_protocol;
                      StandardErrorHandle:efi_handle;
                      StdErr:^efi_simple_text_output_protocol;
                      RuntimeServices:^efi_runtime_services;
                      bootservices:^efi_boot_services;
                      numberofTableEntries:NatUint;
                      configuration_table:^efi_configuration_table;
                      end;
     Pefi_system_table=^efi_system_table;
     
     efi_loaded_image_protocol=record
                               Revision:dword;
                               ParentHandle:efi_handle;
                               SystemTable:^efi_system_table;
                               DeviceHandle:efi_handle;
                               filepath:^efi_device_path_protocol;
                               reserved:Pointer;
                               LoadOptionSize:dword;
                               LoadOptions:Pointer;
                               ImageBase:Pointer;
                               ImageSize:qword;
                               ImageCodeType:efi_memory_type;
                               ImageDataType:efi_memory_type;
                               unload:efi_image_unload;
                               end;
     efi_device_path_utils_get_device_path_size=function (const DevicePath:efi_device_path_protocol):natuint;cdecl;
     efi_device_path_utils_dup_device_path=function (const DevicePath:efi_device_path_protocol):Pefi_device_path_protocol;cdecl;
     efi_device_path_utils_append_path=function (const src1,src2:Pefi_device_path_protocol):Pefi_device_path_protocol;cdecl;
     efi_device_path_utils_append_node=function (const DevicePath,DeviceNode:Pefi_device_path_protocol):Pefi_device_path_protocol;cdecl;
     efi_device_path_utils_append_instance=function (const DevicePath,DeviceInstance:Pefi_device_path_protocol):Pefi_device_path_protocol;cdecl;
     efi_device_path_utils_get_next_instance=function (var DevicePathInstance:PPefi_device_path_protocol;var DevicePathInstanceSize:Natuint):Pefi_device_path_protocol;cdecl;
     efi_device_path_utils_is_multi_instance=function (const DevicePath:Pefi_device_path_protocol):Pefi_device_path_protocol;cdecl;
     efi_device_path_utils_create_node=function (NodeType:byte;NodeSubType:byte;NodeLength:word):Pefi_device_path_protocol;cdecl;
     efi_device_path_utilities_protocol=record
     					GetDevicePathSize:efi_device_path_utils_get_device_path_size;
     					DuplicateDevicePath:efi_device_path_utils_dup_device_path;
     					AppendDevicePath:efi_device_path_utils_append_path;
     					AppendDeviceNode:efi_device_path_utils_append_node;
     					AppendDevicePathInstance:efi_device_path_utils_append_instance;
     					GetNextDevicePathInstance:efi_device_path_utils_get_next_instance;
     					IsDevicePathMultiinstance:efi_device_path_utils_is_multi_instance;
     					CreateDeviceNode:efi_device_path_utils_create_node;
                                        end;
     efi_device_path_to_text_node=function (const DeviceNode:Pefi_device_path_protocol;DisplayOnly:boolean;AllowShortCuts:boolean):PWideChar;cdecl;
     efi_device_path_to_text_path=function (const DevicePath:Pefi_device_path_protocol;DisplayOnly:boolean;AllowShortCuts:boolean):PWideChar;cdecl;
     efi_device_path_to_text_protocol=record
                                      ConvertDeviceNodeToText:efi_device_path_to_text_node;
                                      ConvertDevicePathToText:efi_device_path_to_text_path;
                                      end;
     efi_device_path_from_text_node=function (const TextDeviceNode:PWideChar):Pefi_device_path_protocol;cdecl;
     efi_device_path_from_text_path=function (const TextDevicePath:PWideChar):Pefi_device_path_protocol;cdecl;
     efi_device_path_from_text_protocol=record
     					ConvertTextToDeviceNode:efi_device_path_from_text_node;
     					ConvertTextToDevicePath:efi_device_path_from_text_path;
                                        end;
     Pefi_driver_binding_protocol=^efi_driver_binding_protocol;
     efi_driver_binding_protocol_supported=function (This:Pefi_driver_binding_protocol;ControllerHandle:efi_handle;RemainingDevicePath:Pefi_device_path_protocol):efi_status;cdecl;
     efi_driver_binding_protocol_start=function (This:Pefi_driver_binding_protocol;ControllerHandle:efi_handle;RemainingDevicePath:Pefi_device_path_protocol):efi_status;cdecl;
     efi_driver_binding_protocol_stop=function (This:Pefi_driver_binding_protocol;ControllerHandle:efi_handle;NumberOfChildren:natuint;ChildHandleBuffer:efi_handle):efi_status;cdecl;
     efi_driver_binding_protocol=record
                                 Supported:efi_driver_binding_protocol_supported;
                                 Start:efi_driver_binding_protocol_start;
                                 Stop:efi_driver_binding_protocol_stop;
                                 Version:dword;
                                 ImageHandle:efi_handle;
                                 DriverBindingHandle:efi_handle;
     				 end;
     Pefi_platform_driver_override_protocol=^efi_platform_driver_override_protocol;
     efi_platform_driver_override_get_driver=function (This:Pefi_platform_driver_override_protocol;ControllerHandle:efi_handle;var DriverImageHandle:efi_handle):efi_status;cdecl;
     efi_platform_driver_override_get_driver_path=function (This:Pefi_platform_driver_override_protocol;ControllerHandle:efi_handle;var DriverImagePath:Pointer):efi_status;cdecl;
     efi_platform_driver_override_driver_loaded=function (This:Pefi_platform_driver_override_protocol;ControllerHandle:efi_handle;DriverImagePath:Pefi_device_path_protocol;DriverImageHandle:efi_handle):efi_status;cdecl;
     efi_platform_driver_override_protocol=record
                                           GetDriver:efi_platform_driver_override_get_driver;
                                           GetDriverPath:efi_platform_driver_override_get_driver_path;
                                           DriverLoaded:efi_platform_driver_override_driver_loaded;
                                           end;
     Pefi_bus_specific_driver_override_protocol=^efi_bus_specific_driver_override_protocol;
     efi_bus_specific_driver_override_get_driver=function (This:Pefi_bus_specific_driver_override_protocol;var DriverImageHandle:efi_handle):efi_status;cdecl;
     efi_bus_specific_driver_override_protocol=record
                                               GetDriver:efi_bus_specific_driver_override_get_driver;
                                               end;
     efi_driver_diagnostic_type=(efidriverdiagnostictypestandard=0,efidriverdiagnostictypeextended=1,efidriverdiagnostictypemanufacturing=2,
efidriverdiagnostictypeCancel=3,efiDriverDiagnosticTypeMaximum);
     Pefi_driver_diagnostics_protocol=^efi_driver_diagnostics_protocol;
     efi_driver_diagnostics2_run_diagnostics=function (This:Pefi_driver_diagnostics_protocol;ControllerHandle:efi_handle;ChildHandle:efi_handle;DiagnosticsHandle:efi_driver_diagnostic_type;Language:PChar;var ErrorType:Pefi_guid;var BufferSize:NatUint;var Buffer:PWideChar):efi_status;cdecl;
     efi_driver_diagnostics_protocol=record
                                     RunDiagnostics:efi_driver_diagnostics2_run_diagnostics;
                                     SupportedLanguages:Pchar;
                                     end;
     Pefi_component_name2_protocol=^efi_component_name2_protocol;
     efi_component_name_get_driver_name=function (This:Pefi_component_name2_protocol;Language:Pchar;var DriverName:PWideChar):efi_status;cdecl;
     efi_component_name_get_controller_name=function (This:Pefi_component_name2_protocol;ControllerHandle,ChildHandle:efi_handle;Languages:PChar;var DriverName:PWideChar):efi_status;cdecl;
     efi_component_name2_protocol=record
				  GetDriverName:efi_component_name_get_driver_name;
				  GetControllerName:efi_component_name_get_controller_name;
				  SupportedLanguages:PChar;
                                  end;
     Pefi_service_binding_protocol=^efi_service_binding_protocol;
     efi_service_binding_create_child=function (This:Pefi_service_binding_protocol;var ChildHandle:efi_handle):efi_status;cdecl;
     efi_service_binding_destroy_child=function (This:Pefi_service_binding_protocol;ChildHandle:efi_handle):efi_status;cdecl;
     efi_service_binding_protocol=record
     			 	  CreateChild:efi_service_binding_create_child;
     			 	  DestroyChild:efi_service_binding_destroy_child;
                                  end;
     Pefi_platform_to_driver_configuration_protocol=^efi_platform_to_driver_configuration_protocol;
     efi_platform_to_driver_configuration_query=function (This:Pefi_platform_to_driver_configuration_protocol;ControllerHandle,ChildHandle:efi_handle;Instance:PNatuint;var ParameterTypeGuid:Pefi_guid;var ParameterBlock:Pointer;var ParameterBlockSize:Natuint):efi_status;cdecl;
     	efi_platform_configuration_action=(efiplatformconfigurationactionnone=0,efiplatformconfigurationactionstopcontroller=1,efiplatformconfigurationactionrestartcontroller=2,efiplatformconfigurationactionrestartplatform=3,efiplatformconfigurationactionnvramfailed=4,efiplatformconfigurationactionunsupportedguid=5,efiplatformconfigurationactionmaximum);
     efi_platform_to_driver_configuration_response=function (This:Pefi_platform_to_driver_configuration_protocol;ControllerHandle,ChildHandle:efi_handle;Instance:PNatUint;ParameterTypeGuid:Pefi_guid;ParameterBlock:Pointer;ParameterBlockSize:Natuint;ConfigurationAction:efi_platform_configuration_action):efi_status;cdecl;
     efi_platform_to_driver_configuration_protocol=record
     						   Query:efi_platform_to_driver_configuration_query;
     						   Response:efi_platform_to_driver_configuration_response;
     						   end;
     efi_driver_supported_efi_version_protocol=record
                                               efilength:dword;
                                               FirmWareVersion:dword;
                                               end;
     Pefi_driver_family_override_protocol=^efi_driver_family_override_protocol;
     efi_driver_family_override_get_version=function (This:Pefi_driver_family_override_protocol):dword;cdecl;
     efi_driver_family_override_protocol=record
                                         GetVersion:efi_driver_family_override_get_version;
                                         end;
     Pefi_driver_health_protocol=^efi_driver_health_protocol;
     efi_driver_health_status=(efidriverstatushealthy,efidriverstatusrepairrequired,efidriverstatusconfigurationrequired,efidriverstatusfailed,efidriverstatusreconnectrequired,efidriverstatusrebootrequired);
     efi_string_id=natuint;
     efi_driver_health_hii_message=record
     				   HiiHandle:efi_hii_handle;
     				   StringId:efi_string_id;
     				   MessageCode:qword;
                                   end;
     efi_driver_health_get_health_status=function (This:Pefi_driver_health_protocol;ControllerHandle,ChildHandle:efi_handle;var HealthStatus:efi_driver_health_status;var MessageList:efi_driver_health_hii_message;var FormHiiHandle:efi_hii_handle):efi_status;cdecl;
     efi_driver_health_repair_notify=function (efiValue:Natuint;Limit:Natuint):efi_status;cdecl;
     efi_driver_health_repair=function (This:Pefi_driver_health_protocol;ControllerHandle,ChildHandle:efi_handle;RepairNotify:efi_driver_health_repair_notify):efi_status;cdecl;
     efi_driver_health_protocol=record
                                GetHealthStatus:efi_driver_health_get_health_status;
                                Repair:efi_driver_health_repair;
                                end;
     Pefi_adapter_information_protocol=^efi_adapter_information_protocol;
     efi_adapter_info_get_info=function (This:Pefi_adapter_information_protocol;InformationType:Pefi_guid;var InformationBlock:Pointer;var InformationBlockSize:NatUint):efi_status;cdecl;
     efi_adapter_info_set_info=function (This:Pefi_adapter_information_protocol;InformationType:Pefi_guid;InformationBlock:Pointer;InformationBlockSize:Natuint):efi_status;cdecl;
     efi_adapter_info_get_supported_types=function (This:Pefi_adapter_information_protocol;var InfoTypesBuffer:Pefi_guid;var InfoTypesBufferCount:NatUint):efi_status;cdecl;
     efi_adapter_information_protocol=record
                                      GetInformation:efi_adapter_info_get_info;
                                      SetInformation:efi_adapter_info_set_info;
                                      GetSupportedTypes:efi_adapter_info_get_supported_types;
                                      end;
     efi_adapter_info_state=record
                            MediaState:efi_status;
                            end;
     efi_adapter_info_network=record
     			      iSsciIpv4BootCapability:boolean;
     			      iSsciIpv6BootCapability:boolean;
     			      FCoeBootCapability:boolean;
     			      OffloadCapability:boolean;
     			      iSsciMpioCapability:boolean;
     			      iSsciIpv4Boot:boolean;
     			      iSsciIpv6Boot:boolean;
     			      FCoeBoot:boolean;
                              end;
     efi_adapter_info_san_mac_address=record
     				      SanMacAddress:efi_mac_address;
                                      end;
     efi_adapter_info_undi_ipv6_support=record
                                        Ipv6Support:boolean;
                                        end;
     efi_adapter_info_media_type=record
                                 MediaType:byte;
                                 end;
     efi_adapter_info_cdat_type_type=record
                                     CdatSize:natuint;
                                     Cdat:array of byte;
                                     end;
     Pefi_simple_text_input_ex_protocol=^efi_simple_text_input_ex_protocol;
     efi_input_reset_ex=function (This:Pefi_simple_text_input_ex_protocol;ExtendedVerification:boolean):efi_status;cdecl;
     efi_key_state=record
                   keyshiftstate:dword;
                   keytogglestate:byte;
                   end;
     efi_key_data=record 
                  Key:efi_input_key;
                  KeyState:efi_key_state;
                  end; 
     Pefi_key_data=^efi_key_data;
     efi_key_toggle_state=byte;
     Pefi_key_toggle_state=^efi_key_toggle_state;
     efi_input_read_key_ex=function (This:Pefi_simple_text_input_ex_protocol;var KeyData:efi_key_data):efi_status;cdecl;
     efi_set_state=function (This:Pefi_simple_text_input_ex_protocol;KeyToggleState:Pefi_key_toggle_state):efi_status;cdecl;
     efi_key_notify_function=function (KeyData:Pefi_key_data):efi_status;cdecl;
     efi_register_keystroke_notify=function (This:Pefi_simple_text_input_ex_protocol;KeyData:Pefi_key_data;KeyNotificationFunction:efi_key_notify_function;var NotifyHandle:Pointer):efi_status;cdecl;
     efi_unregister_keystroke_notify=function (This:Pefi_simple_text_input_ex_protocol;NotificationHandle:Pointer):efi_status;cdecl;
     efi_simple_text_input_ex_protocol=record
                                       Reset:efi_input_reset_ex;
                                       ReadKeyStrokeEx:efi_input_read_key_ex;
                                       WaitForKeyEx:efi_event;
                                       SetState:efi_set_state;
                                       RegisterKeyNotify:efi_register_keystroke_notify;
                                       UnregisterKeyNotify:efi_unregister_keystroke_notify;
                                       end;
     efi_simple_pointer_mode=record 
                             ResolutionX,ResolutionY,ResolutionZ:qword;
                             leftbutton,rightbutton:boolean;
                             end;
     Pefi_simple_pointer_protocol=^efi_simple_pointer_protocol;
     efi_simple_pointer_reset=function (This:Pefi_simple_pointer_protocol;ExtendedVerification:boolean):efi_status;cdecl;
     efi_simple_pointer_state=record
                              RelativeMovementX,RelativeMovementY,RelativeMovementZ:integer;
                              LeftButton,RightButton:boolean;
                              end;
     efi_simple_pointer_get_state=function (This:Pefi_simple_pointer_protocol;var State:efi_simple_pointer_state):efi_status;cdecl;
     efi_simple_pointer_protocol=record
                                 Reset:efi_simple_pointer_reset;
                                 GetState:efi_simple_pointer_get_state;
                                 WaitForInput:efi_event;
                                 Mode:^efi_simple_pointer_mode;
                                 end;
     Pefi_absolute_pointer_protocol=^efi_absolute_pointer_protocol;
     efi_absolute_pointer_mode=record
                               AbsoluteMinX,AbsoluteMinY,AbsoluteMinZ,AbsoluteMaxX,AbsoluteMaxY,AbsoluteMaxZ:qword;
                               Attributes:dword;
                               end;
     efi_absolute_pointer_reset=function (This:Pefi_absolute_pointer_protocol;ExtendVerification:boolean):efi_status;cdecl;
     efi_absolute_pointer_state=record
                                CurrentX,CurrentY,CurrentZ:qword;
                                ActiveButtons:dword;
                                end;
     efi_absolute_pointer_get_state=function (This:Pefi_absolute_pointer_protocol;var state:efi_absolute_pointer_state):efi_status;cdecl;
     efi_absolute_pointer_protocol=record
                                   Reset:efi_absolute_pointer_reset;
                                   GetState:efi_absolute_pointer_get_state;
                                   WaitForInput:efi_event;
                                   Mode:^efi_absolute_pointer_mode;
                                   end;
     serial_io_mode=record
                    ControlMask:dword;
                    TimeOut:dword;
                    BaudRate:qword;
                    ReceiveFifoDepth:dword;
                    DataBits:dword;
                    Parity:dword;
                    StopBits:dword;
                    end;
     efi_parity_type=(DefaultParity=0,NoParity=1,EvenParity=2,OddParity=3,MarkParity=4,SpaceParity=5);
     efi_stop_bits_type=(DefaultStopBits=0,OneStopBit=1,OneFiveStopBits=2,TwoStopBits=3);
     Pefi_serial_io_protocol=^efi_serial_io_protocol;
     efi_serial_reset=function (This:Pefi_serial_io_protocol):efi_status;cdecl;
     efi_serial_set_attributes=function (This:Pefi_serial_io_protocol;BaudRate:qword;ReceiveFifoDepth:dword;Timeout:dword;Parity:efi_parity_type;DataBits:byte;StopBits:efi_stop_bits_type):efi_status;cdecl;
     efi_serial_set_control_bits=function (This:Pefi_serial_io_protocol;Control:dword):efi_status;cdecl;
     efi_serial_get_control_bits=function (This:Pefi_serial_io_protocol;var Control:dword):efi_status;cdecl;
     efi_serial_write=function (This:Pefi_serial_io_protocol;BufferSize:PNatuint;Buffer:Pointer):efi_status;cdecl;
     efi_serial_read=function (This:Pefi_serial_io_protocol;var BufferSize:Natuint;var Buffer):efi_status;cdecl;
     efi_serial_io_protocol=record
                            revision:longword;
                            Reset:efi_serial_reset;
                            SetAttributes:efi_serial_set_attributes;
                            SetControl:efi_serial_set_control_bits;
                            GetControl:efi_serial_get_control_bits;
                            efiWrite:efi_serial_write;
                            efiRead:efi_serial_read;
                            Mode:^Serial_IO_mode;
                            device_type_guid:^efi_guid;
                            end;
     Pefi_graphics_output_protocol=^efi_graphics_output_protocol;
     efi_pixel_mask=record
                    RedMask,GreenMask,BlueMask,ReservedMask:dword;
                    end;
     efi_graphics_pixel_format=(PixelRedGreenBlueReserved8BitPerColor,PixelBlueGreenRedReserved8BitPerColor,PixelBitMask,PixelBitOnly,PixelFormatMax);
     efi_graphics_output_mode_information=record
                                          Version:dword;
                                          HorizontalResolution:dword;
                                          VerticalResolution:dword;
                                          PixelFormat:efi_graphics_pixel_format;
                                          PixelInformation:efi_pixel_mask;
                                          PixelsPerScanLine:dword;
                                          end;
     Pefi_graphics_output_mode_information=^efi_graphics_output_mode_information;
     efi_graphics_output_protocol_mode=record
                                       MaxMode:dword;
                                       Mode:dword;
                                       Info:^efi_graphics_output_mode_information;
                                       SizeOfInfo:dword;
                                       FrameBufferBase:efi_physical_address;
                                       FrameBufferSize:natuint;
                                       end;
     efi_graphics_output_protocol_query_mode=function (This:Pefi_graphics_output_protocol;ModeNumber:dword;var SizeOfInfo:Natuint;var Info:Pefi_graphics_output_mode_information):efi_status;cdecl;
     efi_graphics_output_protocol_set_mode=function (This:Pefi_graphics_output_protocol;ModeNumber:dword):efi_status;cdecl;
     efi_graphics_output_blt_pixel=record
                                   Blue,Green,Red,Reserved:byte;
                                   end;
     Pefi_graphics_output_blt_pixel=^efi_graphics_output_blt_pixel;
     efi_graphics_output_blt_operation=(efibltVideoFill,efibltVideoToBltBuffer,efibltBufferToVideo,efiBltVideoToVideo,efiGraphicsOutputBltOperationMax);
     efi_graphics_output_protocol_blt=function (This:Pefi_graphics_output_protocol; BltBuffer:Pefi_graphics_output_blt_pixel;BltOperation:efi_graphics_output_blt_operation;SourceX,SourceY,DestinationX,DestinationY,Width,Height,Delta:Natuint):efi_status;cdecl;
     efi_graphics_output_protocol=record
                                  QueryMode:efi_graphics_output_protocol_query_mode;
                                  SetMode:efi_graphics_output_protocol_set_mode;
                                  Blt:efi_graphics_output_protocol_blt;
                                  Mode:^efi_graphics_output_protocol_mode;
                                  end;
     Pefi_load_file_protocol=^efi_load_file_protocol;
     efi_load_file=function (This:Pefi_load_file_protocol;FilePath:Pefi_device_path_protocol;BootPolicy:boolean;var BufferSize:Natuint;var Buffer):efi_status;cdecl;
     efi_load_file_protocol=record
                            LoadFile:efi_load_file;
                            end;
     efi_load_file2_protocol=efi_load_file_protocol;
     Pefi_simple_file_system_protocol=^efi_simple_file_system_protocol;
     Pefi_file_protocol=^efi_file_protocol;
     efi_simple_file_system_protocol_open_volume=function (This:Pefi_simple_file_system_protocol;var Root:Pefi_file_protocol):efi_status;cdecl;
     efi_simple_file_system_protocol=record
                                     Revision:qword;
                                     OpenVolume:efi_simple_file_system_protocol_open_volume;
                                     end;
     efi_file_open=function (This:Pefi_file_protocol;var NewHandle:Pefi_file_protocol;FileName:PWideChar;OpenMode,Attributes:qword):efi_status;cdecl;
     efi_file_close=function (This:Pefi_file_protocol):efi_status;cdecl;
     efi_file_delete=function (This:Pefi_file_protocol):efi_status;cdecl;
     efi_file_read=function (This:Pefi_file_protocol;var buffersize:qword;var Buffer):efi_status;cdecl;
     efi_file_write=function (This:Pefi_file_protocol;var buffersize:qword;Buffer:Pointer):efi_status;cdecl;
     efi_file_set_position=function (This:Pefi_file_protocol;Position:qword):efi_status;cdecl;
     efi_file_get_position=function (This:Pefi_file_protocol;var Position:qword):efi_status;cdecl;
     efi_file_set_info=function (This:Pefi_file_protocol;InformationType:Pefi_guid;BufferSize:Natuint;Buffer:Pointer):efi_status;cdecl;
     efi_file_get_info=function (This:Pefi_file_protocol;InformationType:Pefi_guid;var BufferSize:Natuint;var Buffer):efi_status;cdecl;
     efi_file_flush=function (This:Pefi_file_protocol):efi_status;cdecl;
     efi_file_io_token=record
                       Event:efi_event;
                       Status:efi_status;
                       BufferSize:qword;
                       Buffer:Pointer;
                       end;
     efi_file_open_ex=function (This:Pefi_file_protocol;var NewHandle:Pefi_file_protocol;FileName:PWideChar;OpenMode,Attributes:qword;var Token:efi_file_io_token):efi_status;cdecl;
     efi_file_read_ex=function (This:Pefi_file_protocol;var Token:efi_file_io_token):efi_status;cdecl;
     efi_file_write_ex=function (This:Pefi_file_protocol;var Token:efi_file_io_token):efi_status;cdecl;
     efi_file_flush_ex=function (This:Pefi_file_protocol;var Token:efi_file_io_token):efi_status;cdecl;
     efi_file_protocol=record
                       Revision:qword;
                       Open:efi_file_open;
                       Close:efi_file_close;
                       Delete:efi_file_delete;
                       efiRead:efi_file_read;
                       efiWrite:efi_file_write;
                       GetPosition:efi_file_get_position;
                       SetPosition:efi_file_set_position;
                       GetInfo:efi_file_get_info;
                       SetInfo:efi_file_set_info;
                       Flush:efi_file_flush;
                       OpenEx:efi_file_open_ex;
                       efiReadEx:efi_file_read_ex;
                       efiWriteEx:efi_file_write_ex;
                       FlushEx:efi_file_flush_ex;
                       end;
     efi_file_info=record
                   Size:qword;
                   FileSize:qword;
                   PhysicalSize:qword;
                   CreateTime:efi_time;
                   LastAccessTime:efi_time;
                   ModificationTime:efi_time;
                   Attributes:qword;
                   FileName:array[1..256] of WideChar;
                   end;
     Pefi_file_info=^efi_file_info;
     efi_file_system_info=record
                          Size:qword;
                          ReadOnly:boolean;
                          VolumeSize:qword;
                          FreeSpace:qword;
                          BlockSize:dword;
                          VolumeLabel:array[1..256] of WideChar;
                          end;
     Pefi_file_system_info=^efi_file_system_info;
     efi_file_system_volume_label=record
                                  VolumeLabel:array[1..256] of WideChar;
                                  end;
     Pefi_tape_io_protocol=^efi_tape_io_protocol;
     efi_tape_read=function (This:Pefi_tape_io_protocol;var BufferSize:natuint;var Buffer):efi_status;cdecl;
     efi_tape_write=function (This:Pefi_tape_io_protocol;BufferSize:Pnatuint;Buffer:Pointer):efi_status;cdecl;
     efi_tape_rewind=function (This:Pefi_tape_io_protocol):efi_status;cdecl;
     efi_tape_space=function (This:Pefi_tape_io_protocol;Direction:Natint;efitype:Natuint):efi_status;cdecl;
     efi_tape_writeFM=function (This:Pefi_tape_io_protocol;Count:Natuint):efi_status;cdecl;
     efi_tape_reset=function (This:Pefi_tape_io_protocol;ExtendedVerification:boolean):efi_status;cdecl;
     efi_tape_io_protocol=record
                          TapeRead:efi_tape_read;
                          TapeWrite:efi_tape_write;
                          TapeRewind:efi_tape_rewind;
                          TapeSpace:efi_tape_space;
                          TapeWriteFM:efi_tape_writeFM;
                          TapeReset:efi_tape_reset;
                          end;
     Pefi_disk_io_protocol=^efi_disk_io_protocol;
     efi_disk_read=function (This:Pefi_disk_io_protocol;MediaId:dword;Offset:qword;BufferSize:natuint;var Buffer):efi_status;cdecl;
     efi_disk_write=function (This:Pefi_disk_io_protocol;MediaId:dword;Offset:qword;BufferSize:natuint;Buffer:Pointer):efi_status;cdecl;
     efi_disk_io_protocol=record
                          Revision:qword;
                          ReadDisk:efi_disk_read;
                          WriteDisk:efi_disk_write;
                          end;
     Pefi_disk_io2_protocol=^efi_disk_io2_protocol;
     efi_disk_cancel_ex=function (This:Pefi_disk_io2_protocol):efi_status;cdecl;
     efi_disk_io2_token=record
                        Event:efi_event;
                        TransactionStatus:efi_status;
                        end;
     efi_disk_read_ex=function (This:Pefi_disk_io2_protocol;MediaId:dword;Offset:qword;var Token:efi_disk_io2_token;BufferSize:Natuint;var Buffer):efi_status;cdecl;
     efi_disk_write_ex=function (This:Pefi_disk_io2_protocol;MediaId:dword;Offset:qword;var Token:efi_disk_io2_token;BufferSize:Natuint;Buffer:Pointer):efi_status;cdecl;
     efi_disk_flush_ex=function (This:Pefi_disk_io2_protocol;var Token:efi_disk_io2_token):efi_status;cdecl;
     efi_disk_io2_protocol=record
                           Revision:qword;
                           Cancel:efi_disk_cancel_ex;
                           ReadDiskEx:efi_disk_read_ex;
                           WriteDiskEx:efi_disk_write_ex;
                           FlushDiskEx:efi_disk_flush_ex;
                           end;  
     Pefi_block_io_protocol=^efi_block_io_protocol;
     efi_block_io_media=record
                        MediaId:dword;
                        RemovableMedia:boolean;
                        MediaPresent:boolean;
                        LogicalPartition:boolean;
                        ReadOnly:boolean;
                        WriteCaching:boolean;
                        BlockSize:dword;
                        IoAlign:dword;
                        LastBlock:efi_lba;
                        LowestAlignedLba:efi_lba;
                        LogicalBlocksPerPhysicalBlock:dword;
                        OptimalTransferLengthGranularity:dword;
                        end;
     efi_block_reset=function (This:Pefi_block_io_protocol;ExtendedVerification:boolean):efi_status;cdecl;
     efi_block_read=function (This:Pefi_block_io_protocol;MediaId:dword;lba:efi_lba;BufferSize:Natuint;var Buffer):efi_status;cdecl;
     efi_block_write=function (This:Pefi_block_io_protocol;MediaId:dword;lba:efi_lba;BufferSize:Natuint;Buffer:Pointer):efi_status;cdecl;
     efi_block_flush=function (This:Pefi_block_io_protocol):efi_status;cdecl;
     efi_block_io_protocol=record 
                           Revision:qword;
                           Media:^efi_block_io_media;
                           Reset:efi_block_reset;
                           ReadBlocks:efi_block_read;
                           WriteBlocks:efi_block_write;
                           FlushBlocks:efi_block_flush;
                           end;
     Pefi_block_io2_protocol=^efi_block_io2_protocol;
     efi_block_reset_ex=function (This:Pefi_block_io2_protocol;ExtendedVerification:boolean):efi_status;cdecl;
     efi_block_io2_token=record
                         Event:efi_event;
                         TransactionStatus:efi_status;
                         end;
     efi_block_read_ex=function (This:Pefi_block_io2_protocol;MediaId:dword;lba:efi_lba;var Token:efi_block_io2_token;BufferSize:Natuint;var Buffer):efi_status;cdecl;
     efi_block_write_ex=function (This:Pefi_block_io2_protocol;MediaId:dword;lba:efi_lba;var Token:efi_block_io2_token;BufferSize:Natuint;Buffer:Pointer):efi_status;cdecl;
     efi_block_flush_ex=function (This:Pefi_block_io2_protocol;var Token:efi_block_io2_token):efi_status;cdecl;
     efi_block_io2_protocol=record
                            Media:^efi_block_io_media;
                            Reset:efi_block_reset_ex;
                            ReadBlocksEX:efi_block_read_ex;
                            WriteBlocksEX:efi_block_write_ex;
                            FlushBlocksEx:efi_block_flush_ex;
                            end;
     Pefi_block_io_crypto_protocol=^efi_block_io_crypto_protocol;
     efi_block_io_crypto_capability=record
                                    Algorithm:efi_guid;
                                    KeySize:qword;
                                    CryptoBlockSizeBitMask:qword;
                                    end;
     efi_block_io_crypto_iv_input=record
                                  InputSize:qword;
                                  end;
     efi_block_io_crypto_iv_input_aes_xts=record
                                          Header:efi_block_io_crypto_iv_input;
                                          CryptoBlockNumber,CryptoBlockByteSize:qword;
                                          end;
     efi_block_io_crypto_iv_input_aes_cbc_microsoft_bitlocker=record
                                                              Header:efi_block_io_crypto_iv_input;
                                                              CryptoBlockNumber,CryptoBlockByteSize:qword;
                                                              end;
     efi_block_io_crypto_capabilities=record
                                      supported:boolean;
                                      KeyCount:qword;
                                      CapabilityCount:qword;
                                      Capabilities:array[1..1] of efi_block_io_crypto_capability;
                                      end;
     efi_block_io_crypto_configuration_table_entry=record
                                                   Index:qword;
                                                   KeyOwnerGuid:efi_guid;
                                                   Capability:efi_block_io_crypto_capability;
                                                   CryptoKey:Pointer;
                                                   end;
     efi_block_io_crypto_response_configuration_entry=record 
                                                      Index:qword;
                                                      KeyOwnerGuid:efi_guid;
                                                      Capability:efi_block_io_crypto_capability;
                                                      end;
     Pefi_block_io_crypto_configuration_table_entry=^efi_block_io_crypto_configuration_table_entry;
     efi_block_io_crypto_reset=function (This:Pefi_block_io_crypto_protocol;ExtendedVerification:boolean):efi_status;cdecl;
     efi_block_io_crypto_get_capabilities=function (This:Pefi_block_io_crypto_protocol;var Capabilities:efi_block_io_crypto_capabilities):efi_status;cdecl;
     efi_block_io_crypto_set_configuration=function (This:Pefi_block_io_crypto_protocol;ConfigurationCount:qword;ConfigurationTable:Pefi_block_io_crypto_configuration_table_entry;var ResultingTable:efi_block_io_crypto_response_configuration_entry):efi_status;cdecl;
     efi_block_io_crypto_get_configuration=function (This:Pefi_block_io_crypto_protocol;StartIndex:qword;ConfigurationCount:qword;KeyOwnerGuid:Pefi_guid;var ConfigurationTable:efi_block_io_crypto_response_configuration_entry):efi_status;cdecl;
     efi_block_io_crypto_token=record
                               event:efi_event;
                               TransactionStatus:efi_status;
                               end;
     efi_block_io_crypto_read_extended=function (This:Pefi_block_io_crypto_protocol;MediaId:dword;lba:efi_lba;var Token:efi_block_io_crypto_token;BufferSize:qword;var Buffer;Index:Pqword;CryptoIvInput:Pointer):efi_status;cdecl;
     efi_block_io_crypto_write_extended=function (This:Pefi_block_io_crypto_protocol;MediaId:dword;lba:efi_lba;var Token:efi_block_io_crypto_token;BufferSize:qword;Buffer:Pointer;Index:Pqword;CryptoIvInput:Pointer):efi_status;cdecl;
     efi_block_io_crypto_flush=function (This:Pefi_block_io_crypto_protocol;var Token:efi_block_io_crypto_token):efi_status;cdecl;
     efi_block_io_crypto_protocol=record 
                                  Media:^efi_block_io_media;
                                  Reset:efi_block_io_crypto_reset;
                                  GetCapabilities:efi_block_io_crypto_get_capabilities;
                                  SetConfiguration:efi_block_io_crypto_set_configuration;
                                  GetConfiguration:efi_block_io_crypto_get_configuration;
                                  ReadExtended:efi_block_io_crypto_read_extended;
                                  WriteExtended:efi_block_io_crypto_write_extended;
                                  FlushBlocks:efi_block_io_crypto_flush;
                                  end;
     Pefi_erase_block_protocol=^efi_erase_block_protocol;
     efi_erase_block_token=record
                           Event:efi_event;
                           TransactionStatus:efi_status;
                           end;
     efi_block_erase=function (This:Pefi_block_io_protocol;MediaId:dword;LBA:efi_lba;var Token:efi_erase_block_token;Size:Natuint):Pefi_status;cdecl;
     efi_erase_block_protocol=record
                              Revision:qword;
                              EraseLengthGranularity:dword;
                              EraseBlocks:efi_block_erase;
                              end;
     Pefi_ata_pass_thru_protocol=^efi_ata_pass_thru_protocol;
     efi_ata_pass_thru_mode=record
                            Attributes:dword;
                            IoAlign:dword;
                            end;
     efi_ata_status_block=record
                          Reserved1:array[1..2] of byte;
                          AtaStatus:byte;
                          AtaError:byte;
                          AtaSectorNumber:byte;
                          AtaCylinderLow:byte;
                          AtaCylinderHigh:byte;
                          AtaDeviceHead:byte;
                          AtaSectorNumberExp:byte;
                          AtaCylinderLowExp:byte;
                          AtaCylinderHighExp:byte;
                          Reserved2:byte;
                          AtaSectorCount:byte;
                          AtaSectorCountExp:byte;
                          Reserved3:array[1..6] of byte;
                          end;
     efi_ata_command_block=record
                          Reserved1:array[1..2] of byte;
                          Atacommand:byte;
                          AtaFeatures:byte;
                          AtaSectorNumber:byte;
                          AtaCylinderLow:byte;
                          AtaCylinderHigh:byte;
                          AtaDeviceHead:byte;
                          AtaSectorNumberExp:byte;
                          AtaCylinderLowExp:byte;
                          AtaCylinderHighExp:byte;
                          AtaFeaturesExp:byte;
                          AtaSectorCount:byte;
                          AtaSectorCountExp:byte;
                          Reserved2:array[1..6] of byte;
                          end;
     efi_ata_pass_thru_cmd_protocol=byte;
     efi_ata_pass_thru_length=byte;
     efi_ata_pass_thru_command_packet=record
                                      Asb:^efi_ata_status_block;
                                      Acb:^efi_ata_command_block;
                                      Timeout:qword;
                                      InDataBuffer:Pointer;
                                      OutDataBuffer:Pointer;
                                      InTransferLength:dword;
                                      OutTransferLength:dword;
                                      Protocol:efi_ata_pass_thru_cmd_protocol;
                                      Length:efi_ata_pass_thru_length;
                                      end;
     efi_ata_pass_thru_passthru=function (This:Pefi_ata_pass_thru_protocol;Port:word;PortMultiplierPort:word;var Packet:efi_ata_pass_thru_command_packet;Event:efi_event):efi_status;cdecl;
     efi_ata_pass_thru_get_next_port=function (This:Pefi_ata_pass_thru_protocol;var Port:word):efi_status;cdecl;
     efi_ata_pass_thru_get_next_device=function (This:Pefi_ata_pass_thru_protocol;Port:word;var PortMultiplierPort:word):efi_status;cdecl;
     efi_ata_pass_thru_build_device_path=function (This:Pefi_ata_pass_thru_protocol;Port,PortMultiplierPort:word;var DevicePath:Pefi_device_path_protocol):efi_status;cdecl;
     efi_ata_pass_thru_get_device=function (This:Pefi_ata_pass_thru_protocol;DevicePath:Pefi_device_path_protocol;var Port,PortMultiplierPort:word):efi_status;cdecl;
     efi_ata_pass_thru_reset_port=function (This:Pefi_ata_pass_thru_protocol;Port:Pword):efi_status;cdecl;
     efi_ata_pass_thru_reset_device=function (This:Pefi_ata_pass_thru_protocol;Port,PortMultiplierPort:word):efi_status;cdecl;
     efi_ata_pass_thru_protocol=record
                                Mode:^efi_ata_pass_thru_mode;
                                Passthru:efi_ata_pass_thru_passthru;
                                GetNextPort:efi_ata_pass_thru_get_next_port;
                                GetNextDevice:efi_ata_pass_thru_get_next_device;
                                BuildDevicePath:efi_ata_pass_thru_build_device_path;
                                GetDevice:efi_ata_pass_thru_get_device;
                                ResetPort:efi_ata_pass_thru_reset_port;
                                ResetDevice:efi_ata_pass_thru_reset_device;
                                end;
    Pefi_storage_security_command_protocol=^efi_storage_security_command_protocol;
    efi_storage_security_receive_data=function (This:Pefi_storage_security_command_protocol;MediaId:dword;Timeout:qword;SecurityProtocolId:byte;SecurityProtocolSpecificData:word;PayloadBufferSize:Natuint;var PayloadBuffer;var PayloadTransferSize:Natuint):efi_status;cdecl;
    efi_storage_security_send_data=function (This:Pefi_storage_security_command_protocol;MediaId:dword;Timeout:qword;SecurityProtocolId:byte;SecurityProtocolSpecificData:word;PayloadBufferSize:Natuint;PayloadBuffer:Pointer):efi_status;cdecl;
    efi_storage_security_command_protocol=record
                                          ReceiveData:efi_storage_security_receive_data;
                                          SendData:efi_storage_security_send_data;
                                          end;
    Pefi_nvm_express_pass_thru_protocol=^efi_nvm_express_pass_thru_protocol;
    efi_nvm_express_pass_thru_mode=record
                                   Attributes:dword;
                                   IoAlign:dword;
                                   NvmeVersion:dword;
                                   end;
    nvme_cdw0=bitpacked record
              Opcode:0..255;
              FusedOperation:0..3;
              Reserved:0..4194303;
              end;
    efi_nvm_express_command=record
    			    cdw0:nvme_cdw0;
    			    flags:byte;
    			    Nsid,Cdw2,Cdw3,Cdw10,Cdw11,Cdw12,Cdw13,Cdw14,Cdw15:dword;
                            end;
    efi_nvm_express_completion=record
                               DW0,DW1,DW2,DW3:dword;
                               end;
    efi_nvm_express_pass_thur_command_packet=record 
                                             CommandTimeout:qword;
                                             TransferBuffer:Pointer;
                                             TransferLength:dword;
                                             MetaDataBuffer:Pointer;
                                             MetaDataLength:dword;
                                             QueueType:byte;
                                             NvmeCmd:^efi_nvm_express_command;
                                             NvmeCompletion:^efi_nvm_express_completion;
                                             end;
    efi_nvm_express_pass_thru_passthru=function (This:Pefi_nvm_express_pass_thru_protocol;NameSpaceId:dword;var Packet:efi_nvm_express_pass_thur_command_packet;Event:efi_event):efi_status;cdecl;
    efi_nvm_express_pass_thru_get_next_namespace=function (This:Pefi_nvm_express_pass_thru_protocol;var namespaceid:dword):efi_status;cdecl;
    efi_nvm_express_pass_thru_build_device_path=function (This:Pefi_nvm_express_pass_thru_protocol;namespaceid:dword;var DevicePath:Pefi_device_path_protocol):efi_status;cdecl;
    efi_nvm_express_pass_thru_get_namespace=function (This:Pefi_nvm_express_pass_thru_protocol;DevicePath:Pefi_device_path_protocol;var Namespaceid:dword):efi_status;cdecl;
    efi_nvm_express_pass_thru_protocol=record
                                       Mode:^efi_nvm_express_pass_thru_mode;
                                       PassThru:efi_nvm_express_pass_thru_passthru;
                                       GetNextNamespace:efi_nvm_express_pass_thru_get_next_namespace;
                                       BuildDevicePath:efi_nvm_express_pass_thru_build_device_path;
                                       GetNamespace:efi_nvm_express_pass_thru_get_namespace;
                                       end;
    Pefi_sd_mmc_pass_thru_protocol=^efi_sd_mmc_pass_thru_protocol;
    efi_sd_mmc_command_block=record
                             CommandIndex:word;
                             CommandArgument:dword;
                             CommandType:dword;
                             ResponseType:dword; 
                             end;
    efi_sd_mmc_status_block=record
                            Resp0,Resp1,Resp2,Resp3:dword;
                            end;
    efi_sd_mmc_command_type=(SdMmcCommandTypeBc,SdMmcCommandTypeBcr,SdMmcCommandTypeAc,SdMmcCommandTypeAdtc);
    efi_sd_mmc_response_type=(SdMmcResponceTypeR1,SdMmcResponceTypeR1b,SdMmcResponceTypeR2,SdMmcResponceTypeR3,SdMmcResponceTypeR4,SdMmcResponceTypeR5,SdMmcResponceTypeR5b,SdMmcResponceTypeR6,SdMmcResponceTypeR7);
    efi_sd_mmc_pass_thru_command_packet=record
                                        SdMmcCmdBlk:^efi_sd_mmc_command_block;
                                        SdMmcStatusBlk:^efi_sd_mmc_status_block;
                                        Timeout:qword;
                                        InDataBuffer,OutDataBuffer:Pointer;
                                        InTransferLength,OutTransferLength:dword;
                                        TransactionStatus:efi_status;
                                        end;
    efi_sd_mmc_pass_thru_passthru=function (This:Pefi_sd_mmc_pass_thru_protocol;Slot:byte;var Packet:efi_sd_mmc_pass_thru_command_packet;Event:efi_event):efi_status;cdecl;
    efi_sd_mmc_pass_thru_get_next_slot=function (This:Pefi_sd_mmc_pass_thru_protocol;var Slot:byte):efi_status;cdecl;
    efi_sd_mmc_pass_thru_build_device_path=function (This:Pefi_sd_mmc_pass_thru_protocol;Slot:byte;var DevicePath:Pefi_device_path_protocol):efi_status;cdecl;
    efi_sd_mmc_pass_thru_get_slot_number=function (This:Pefi_sd_mmc_pass_thru_protocol;DevicePath:Pefi_device_path_protocol;var Slot:byte):efi_status;cdecl;
    efi_sd_mmc_pass_thru_reset_device=function (This:Pefi_sd_mmc_pass_thru_protocol;Slow:byte):efi_status;cdecl;
    efi_sd_mmc_pass_thru_protocol=record
                                  IoAlign:Natuint;
                                  PassThru:efi_sd_mmc_pass_thru_passthru;
                                  GetNextSlot:efi_sd_mmc_pass_thru_get_next_slot;
                                  BuildDevicePath:efi_sd_mmc_pass_thru_build_device_path;
                                  GetSlotNumber:efi_sd_mmc_pass_thru_get_slot_number;
                                  ResetDevice:efi_sd_mmc_pass_thru_reset_device;
                                  end;
    Pefi_ram_disk_protocol=^efi_ram_disk_protocol;
    efi_ram_disk_register_ramdisk=function (RamDiskBase:qword;RamDiskSize:qword;RamDiskType:Pefi_guid;ParentDevicePath:Pefi_device_path;var DevicePath:Pefi_device_path_protocol):efi_status;cdecl;
    efi_ram_disk_unregister_ramdisk=function (DevicePath:Pefi_device_path_protocol):efi_status;cdecl;
    efi_ram_disk_protocol=record
                          Register:efi_ram_disk_register_ramdisk;
                          Unregister:efi_ram_disk_unregister_ramdisk;
                          end;
    Pefi_partition_info_protocol=^efi_partition_info_protocol;
    efi_partition_info_protocol=packed record
                                Revision:dword;
                                efitype:dword;
                                System:byte;
                                Reserved:array[1..7] of byte;
                                case Boolean of 
                                True:(mbr:mbr_partition_record);
                                False:(gpt:efi_partition_entry);
                                end;
    Pefi_nvdimm_label_protocol=^efi_nvdimm_label_protocol;
    efi_nvdimm_label_storage_information=function (This:Pefi_nvdimm_label_protocol;var SizeOfLabelStorageArea:dword;var MaxTransferLength:dword):efi_status;cdecl;
    efi_nvdimm_label_storage_read=function (const This:Pefi_nvdimm_label_protocol;Offset:dword;TransferLength:dword;var LabelData:byte):efi_status;cdecl;
    efi_nvdimm_label_storage_write=function (const This:Pefi_nvdimm_label_protocol;Offset:dword;TransferLength:dword;LabelData:Pbyte):efi_status;cdecl;
    efi_nvdimm_label_protocol=record
                              LabelStorageInformation:efi_nvdimm_label_storage_information;
                              LabelStorageRead:efi_nvdimm_label_storage_read;
                              LabelStorageWrite:efi_nvdimm_label_storage_write;
                              end;
    Pefi_ufs_device_config_protocol=^efi_ufs_device_config_protocol;
    efi_ufs_device_config_rw_descriptor=function (This:Pefi_ufs_device_config_protocol;efiRead:boolean;DescId,Index,Selector:byte;var Descriptor:byte;var DecSize:dword):efi_status;cdecl;
    efi_ufs_device_rw_flag=function (This:Pefi_ufs_device_config_protocol;efiRead:boolean;FlagId:byte;var Flag:byte):efi_status;cdecl;
    efi_ufs_device_rw_attribute=function (This:Pefi_ufs_device_config_protocol;efiRead:boolean;AttrId,Index,Selector:byte;var efiattribute:byte;var AttrSize:dword):efi_status;cdecl;
    efi_ufs_device_config_protocol=record
                                   RwUfsDescriptor:efi_ufs_device_config_rw_descriptor;
                                   RwUfsFlag:efi_ufs_device_rw_flag;
                                   RwUfsAttribute:efi_ufs_device_rw_attribute;
                                   end;
    Pefi_pci_root_bridge_io_protocol=^efi_pci_root_bridge_io_protocol;
                                   efi_pci_root_bridge_io_protocol_width=(efiPciWidthUint8,efiPciWidthUint16,efiPciWidthUint32,efiPciWidthUint64,efiPciWidthFifoUint8,efiPciWidthFifoUint16,efiPciWidthFifoUint32,efiPciWidthFifouint64,efiPciWidthFilluint8,efiPciWidthFilluint16,efiPciWidthFilluint32,efiPciWidthFilluint64,efiPciWidthMaximum);
    efi_pci_root_bridge_io_protocol_poll_io_mem=function (This:Pefi_pci_root_bridge_io_protocol;Width:efi_pci_root_bridge_io_protocol_width;Address,Mask,fvalue,Delay:qword;var fResult:qword):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_io_mem=function (This:Pefi_pci_root_bridge_io_protocol;Width:efi_pci_root_bridge_io_protocol_width;Address:qword;Count:natuint;var Buffer):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_access=record 
                                           efiRead:efi_pci_root_bridge_io_protocol_io_mem;
                                           efiWrite:efi_pci_root_bridge_io_protocol_io_mem;
                                           end;
    efi_pci_root_bridge_io_protocol_operation=(efiPciOperationBusMasterRead,efiPciOperationBusMasterWrite,efiPciOperationBusMasterCommonBuffer,efiPciOperationBusMasterRead64,efiPciOperationBusMasterwrite64,efiPciOperationBusMasterCommonBuffer64,efiPciOperationMaxiumum);
    efi_pci_root_bridge_io_protocol_copy_mem=function (This:Pefi_pci_root_bridge_io_protocol;Width:efi_pci_root_bridge_io_protocol_width;DestAddress,SrcAddress:qword;Count:natuint):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_map=function (This:Pefi_pci_root_bridge_io_protocol;Operation:efi_pci_root_bridge_io_protocol_operation;HostAddress:Pointer;var NumberOfBytes:natuint;DeviceAddress:efi_physical_address;var Mapping:Pointer):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_unmap=function (This:Pefi_pci_root_bridge_io_protocol;Mapping:Pointer):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_allocate_buffer=function (This:Pefi_pci_root_bridge_io_protocol;ftype:efi_allocate_type;memorytype:efi_memory_type;Pages:natuint;var HostAddress:Pointer;Attributes:qword):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_free_buffer=function (This:Pefi_pci_root_bridge_io_protocol;Pages:natuint;HostAddress:Pointer):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_flush=function (This:Pefi_pci_root_bridge_io_protocol):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_get_attributes=function (This:Pefi_pci_root_bridge_io_protocol;var Supports,Attributes:qword):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_set_attributes=function (This:Pefi_pci_root_bridge_io_protocol;Attributes:qword;ResourceBase,ResourceLength:qword):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol_configuration=function (This:Pefi_pci_root_bridge_io_protocol;var Resources:Pointer):efi_status;cdecl;
    efi_pci_root_bridge_io_protocol=record 
                                    ParentHandle:efi_handle;
                                    PollMem:efi_pci_root_bridge_io_protocol_poll_io_mem;
                                    PollIo:efi_pci_root_bridge_io_protocol_poll_io_mem;
                                    Mem:efi_pci_root_bridge_io_protocol_access;
                                    Io:efi_pci_root_bridge_io_protocol_access;
                                    Pci:efi_pci_root_bridge_io_protocol_access;
                                    CopyMem:efi_pci_root_bridge_io_protocol_copy_mem;
                                    Map:efi_pci_root_bridge_io_protocol_map;
                                    UnMap:efi_pci_root_bridge_io_protocol_unmap;
                                    AllocateBuffer:efi_pci_root_bridge_io_protocol_allocate_buffer;
                                    FreeBuffer:efi_pci_root_bridge_io_protocol_free_buffer;
                                    flush:efi_pci_root_bridge_io_protocol_flush;
                                    GetAttributes:efi_pci_root_bridge_io_protocol_get_attributes;
                                    SetAttributes:efi_pci_root_bridge_io_protocol_set_attributes;
                                    Configuration:efi_pci_root_bridge_io_protocol_configuration;
                                    SegmentNumber:dword;
                                    end;
    Pefi_pci_io_protocol=^efi_pci_io_protocol;
    efi_pci_io_protocol_width=(efiPciIoWidthUint8,efiPciIoWidthUint16,efiPciIoWidthUint32,efiPciIoWidthUint64,efiPciIoWidthFifoUint8,efiPciIoWidthFifoUint16,efiPciIoWidthFifoUint32,efiPciIoWidthFifoUint64,efiPciIoWidthFillUint8,efiPciIoWidthFillUint16,efiPciIoWidthFillUint32,efiPciIoWidthFillUint64,efiPciIoWidthMaximum);
    efi_pci_io_protocol_poll_io_mem=function (This:Pefi_pci_io_protocol;Width:efi_pci_io_protocol_width;Barindex:byte;Offset,Mask,fValue,Delay:qword;var fResult:qword):efi_status;cdecl;
    efi_pci_io_protocol_io_mem=function (This:Pefi_pci_io_protocol;Width:efi_pci_io_protocol_width;Barindex:byte;Offset:qword;Count:natuint;var Buffer):efi_status;cdecl;
    efi_pci_io_protocol_access=record
                               efiRead:efi_pci_io_protocol_io_mem;
                               efiWrite:efi_pci_io_protocol_io_mem;
                               end;
    efi_pci_io_protocol_config=function (This:Pefi_pci_io_protocol;Width:efi_pci_io_protocol_width;Offset:dword;Count:natuint;var Buffer):efi_status;cdecl;
    efi_pci_io_protocol_config_access=record
                                      efiRead:efi_pci_io_protocol_config;
                                      efiWrite:efi_pci_io_protocol_config;
                                      end;
    efi_pci_io_protocol_operation=(efiPciIoOperationBusMasterRead,efiPciIoOperationBusMasterWrite,efiPciIoOperationBusCommonBuffer,efiPciIoOperationMaximum);
    efi_pci_io_protocol_copy_mem=function (This:Pefi_pci_io_protocol;Width:efi_pci_io_protocol_width;DestBarIndex:byte;DestOffset:qword;SrcBarIndex:byte;SrcOffset:qword;Count:natuint):efi_status;cdecl;
    efi_pci_io_protocol_map=function (This:Pefi_pci_io_protocol;Operation:efi_pci_io_protocol_operation;HostAddress:Pointer;var NumberOfBytes:natuint;var DeviceAddress:efi_physical_address;var Mapping:Pointer):efi_status;cdecl;
    efi_pci_io_protocol_unmap=function (This:Pefi_pci_io_protocol;Mapping:Pointer):efi_status;cdecl;
    efi_pci_io_protocol_allocate_buffer=function (This:Pefi_pci_io_protocol;fType:efi_allocate_type;MemoryType:efi_memory_type;Pages:natuint;var HostAddress:Pointer;Attributes:qword):efi_status;cdecl;
    efi_pci_io_protocol_free_buffer=function (This:Pefi_pci_io_protocol;Pages:natuint;HostAddress:Pointer):efi_status;cdecl;
    efi_pci_io_protocol_flush=function (This:Pefi_pci_io_protocol):efi_status;cdecl;
    efi_pci_io_protocol_get_location=function (This:Pefi_pci_io_protocol;var SegmentNumber,BusNumber,DeviceNumber,FunctionNumber:natuint):efi_status;cdecl;
    efi_pci_io_protocol_attribute_operation=(efiPciIoAttributeOperationGet,efiPciIoAttributeOperationSet,efiPciIoAttributeOperationEnable,efiPciIoAttributeOperationDisable,efiPciIoAttributeOperationSupported,efiPciIoAttributeOperationMaximum);
    efi_pci_io_protocol_attributes=function (This:Pefi_pci_io_protocol;Operation:efi_pci_io_protocol_attribute_operation;Attributes:qword;var fResult:qword):efi_status;cdecl;
    efi_pci_io_protocol_get_bar_attributes=function (This:Pefi_pci_io_protocol;Barindex:byte;var Supports:qword;var Resources:Pointer):efi_status;cdecl;
    efi_pci_io_protocol_set_bar_attributes=function (This:Pefi_pci_io_protocol;Attributes:qword;BarIndex:byte;var Offset,Length:qword):efi_status;cdecl;
    efi_pci_io_protocol=record
                        PollMem:efi_pci_io_protocol_poll_io_mem;
                        PollIo:efi_pci_io_protocol_poll_io_mem;
                        Mem:efi_pci_io_protocol_access;
                        Io:efi_pci_io_protocol_access;
                        Pci:efi_pci_io_protocol_config_access;
                        CopyMem:efi_pci_io_protocol_copy_mem;
                        Map:efi_pci_io_protocol_map;
                        UnMap:efi_pci_io_protocol_unmap;
                        AllocateBuffer:efi_pci_io_protocol_allocate_buffer;
                        FreeBuffer:efi_pci_io_protocol_free_buffer;
                        Flush:efi_pci_io_protocol_flush;
                        GetLocation:efi_pci_io_protocol_get_location;
                        Attributes:efi_pci_io_protocol_attributes;
                        GetBarAttributes:efi_pci_io_protocol_get_bar_attributes;
                        SetBarAttributes:efi_pci_io_protocol_set_bar_attributes;
                        RomSize:qword;
                        RomImage:Pointer;
                        end;
   Pefi_scsi_io_protocol=^efi_scsi_io_protocol;
   efi_scsi_io_protocol_get_device_type=function (This:Pefi_scsi_io_protocol;var DeviceType:byte):efi_status;cdecl;
   efi_scsi_io_protocol_get_device_location=function (This:Pefi_scsi_io_protocol;var Target:PByte;var lun:qword):efi_status;cdecl;
   efi_scsi_io_protocol_reset_bus=function (This:Pefi_scsi_io_protocol):efi_status;cdecl;
   efi_scsi_io_protocol_reset_device=function (This:Pefi_scsi_io_protocol):efi_status;cdecl;
   efi_scsi_io_scsi_request_packet=record
                                   TimeOut:qword;
                                   InDataBuffer,OutDataBuffer,SenseData,Cdb:Pointer;
                                   InTransferLength,OutTransferLength:dword;
                                   DataDirection,HostAdapterStatus,TargetStatus,SenseDataLength:byte;
                                   end;
   efi_scsi_io_protocol_execute_scsi_command=function (This:Pefi_scsi_io_protocol;var Packet:efi_scsi_io_scsi_request_packet;Event:efi_event):efi_status;cdecl;
   efi_scsi_io_protocol=record
                        GetDeviceType:efi_scsi_io_protocol_get_device_type;
                        GetDeviceLocation:efi_scsi_io_protocol_get_device_location;
                        ResetBus:efi_scsi_io_protocol_reset_bus;
                        ResetDevice:efi_scsi_io_protocol_reset_device;
                        ExecuteScsiCommand:efi_scsi_io_protocol_execute_scsi_command;
                        IoAlign:dword;
                        end;
   Pefi_ext_scsi_pass_thru_protocol=^efi_ext_scsi_pass_thru_protocol;
   efi_ext_scsi_pass_thru_mode=record
                               AdapterId:^dword;
                               Attributes:^dword;
                               IoAlign:^dword;
                               end;
   efi_ext_scsi_pass_thru_scsi_request_packet=record
                                              TimeOut:qword;
                                              InDataBuffer,OutDataBuffer,SenseData,Cdb:Pointer;
                                              InTransferLength,OutTransferLength:dword;
                                              CdbLength,DataDirection,HostAdapterStatus,TargetStatus,SenseDataLength:byte;
                                              end;
   efi_ext_scsi_pass_thru_passthru=function (This:Pefi_ext_scsi_pass_thru_protocol;Target:PByte;Lun:qword;var Packet:efi_ext_scsi_pass_thru_scsi_request_packet;Event:efi_event):efi_status;cdecl;
   efi_ext_scsi_pass_thru_get_next_target_lun=function (This:Pefi_ext_scsi_pass_thru_protocol;var Target:PByte;var Lun:qword):efi_status;cdecl;
   efi_ext_scsi_pass_thru_build_device_path=function (This:Pefi_ext_scsi_pass_thru_protocol;Target:PByte;Lun:qword;var DevicePath:Pefi_device_path_protocol):efi_status;cdecl;
   efi_ext_scsi_pass_thru_get_target_lun=function (This:Pefi_ext_scsi_pass_thru_protocol;DevicePath:Pefi_device_path_protocol;var Target:Pbyte;Lun:qword):efi_status;cdecl;
   efi_ext_scsi_pass_thru_reset_channel=function (This:Pefi_ext_scsi_pass_thru_protocol):efi_status;cdecl;
   efi_ext_scsi_pass_thru_reset_target_lun=function (This:Pefi_ext_scsi_pass_thru_protocol;Target:PByte;Lun:qword):efi_status;cdecl;
   efi_ext_scsi_pass_thru_get_next_target=function (This:Pefi_ext_scsi_pass_thru_protocol;Target:PByte):efi_status;cdecl;
   efi_ext_scsi_pass_thru_protocol=record
                                   Mode:^efi_ext_scsi_pass_thru_mode;
                                   PassThru:efi_ext_scsi_pass_thru_passthru;
                                   GetNextTargetLun:efi_ext_scsi_pass_thru_get_next_target_lun;
                                   BuildDevicePath:efi_ext_scsi_pass_thru_build_device_path;
                                   GetTargetLun:efi_ext_scsi_pass_thru_get_target_lun;
                                   ResetChannel:efi_ext_scsi_pass_thru_reset_channel;
                                   ResetTargetLun:efi_ext_scsi_pass_thru_reset_target_lun;
                                   GetNextTarget:efi_ext_scsi_pass_thru_get_next_target;
                                   end;
    Pefi_iscsi_initiator_name_protocol=^efi_iscsi_initiator_name_protocol;
    efi_iscsi_initiator_name_get=function (This:Pefi_iscsi_initiator_name_protocol;var BufferSize:natuint;var Buffer):efi_status;cdecl;
    efi_iscsi_initiator_name_set=function (This:Pefi_iscsi_initiator_name_protocol;var BufferSize:natuint;Buffer:Pointer):efi_status;cdecl;
    efi_iscsi_initiator_name_protocol=record
                                      efiGet:efi_iscsi_initiator_name_get;
                                      efiSet:efi_iscsi_initiator_name_set;
                                      end; 
    Pefi_usb_io_protocol=^efi_usb_io_protocol;
    efi_usb_data_direction=(efiUsbDataIn,efiUsbDataOut,efiUsbNoData);
    efi_usb_device_request=record
                           RequestType:byte;
                           Request:byte;
                           usbValue:word;
                           Index:word;
                           Length:word;
                           end;
    Pefi_usb_device_request=^efi_usb_device_request;
    efi_usb_io_control_transfer=function (This:Pefi_usb_io_protocol;Request:Pefi_usb_device_request;Direction:efi_usb_data_direction;TimeOut:dword;var Data;DataLength:natuint;var Status:dword):efi_status;cdecl;
    efi_usb_io_bulk_transfer=function (This:Pefi_usb_io_protocol;DeviceEndPoint:byte;var Data;var DataLength:natuint;TimeOut:natuint;var status:dword):efi_status;cdecl;
    efi_async_usb_transfer_callback=function (Data:Pointer;DataLength:natuint;Context:Pointer;Status:dword):efi_status;cdecl;
    efi_usb_io_async_interrupt_transfer=function (This:Pefi_usb_io_protocol;DeviceEndPoint:byte;IsNewTransfer:boolean;PoilingInterval,DataLength:natuint;InterruptCallBack:efi_async_usb_transfer_callback;Context:Pointer):efi_status;cdecl;
    efi_usb_io_sync_interrupt_transfer=function (This:Pefi_usb_io_protocol;DeviceEndPoint:byte;var Data;var DataLength:natuint;TimeOut:natuint;var Status:dword):efi_status;cdecl;
    efi_usb_io_isochronous_transfer=function (This:Pefi_usb_io_protocol;DeviceEndPoint:byte;var Data;DataLength:natuint;var status:dword):efi_status;cdecl;
    efi_usb_io_async_isochronous_transfer=function (This:Pefi_usb_io_protocol;DeviceEndPoint:byte;var Data;DataLength:natuint;IsochronousCallBack:efi_async_usb_transfer_callback;Context:Pointer):efi_status;cdecl;
    efi_usb_device_descriptor=record
                              Length,DescriptorType:byte;
                              BcdUSB:word;
                              DeviceClass,DeviceSubClass,DeviceProtocol,MaxPacketSize:byte;
                              IdVendor,IdProduct,BcdDevice:word;
                              StrManufacturer,StrProduct,StrSerialNumber,NumConfigurations:byte;
                              end;
    efi_usb_io_get_device_descriptor=function (This:Pefi_usb_io_protocol;var DeviceDescriptor:efi_usb_device_descriptor):efi_status;cdecl;
    efi_usb_config_descriptor=record
                              Length,DescriptorType:byte;
                              TotalLength:word;
                              NumInterfaces,ConfigurationValue,Configuration,Attributes,MaxPower:byte;
                              end;
    efi_usb_io_get_config_descriptor=function (This:Pefi_usb_io_protocol;var ConfigurationDescriptor:efi_usb_config_descriptor):efi_status;cdecl;
    efi_usb_interface_descriptor=record
                            Length,DescriptorType,InterfaceNumber,AlternateSetting,NumEndPoints,InterfaceClass,InterfaceSubClass,InterfaceProtocol,efiInterface:byte;
                                 end;
    efi_usb_io_get_interface_descriptor=function (This:Pefi_usb_io_protocol;var InterfaceDescriptor:efi_usb_interface_descriptor):efi_status;cdecl;
    efi_usb_endpoint_descriptor=record
                                Length,DescriptorType,EndPointAddress,Attributes:byte;
                                MaxPacketSize:word;
                                Interval:Byte;
                                end;
    efi_usb_io_get_endpoint_descriptor=function (This:Pefi_usb_io_protocol;EndPointIndex:byte;var EndPointDescriptor:efi_usb_endpoint_descriptor):efi_status;cdecl;
    efi_usb_io_get_string_descriptor=function (This:Pefi_usb_io_protocol;LangID:word;StringID:byte;var fString:PWideChar):efi_status;cdecl;
    efi_usb_io_get_supported_languages=function (This:Pefi_usb_io_protocol;var LangIDTable:Pword;var TableSize:word):efi_status;cdecl;
    efi_usb_io_port_reset=function (This:Pefi_usb_io_protocol):efi_status;cdecl;
    efi_usb_io_protocol=record
                        UsbControlTransfer:efi_usb_io_control_transfer;
                        UsbBulkTransfer:efi_usb_io_bulk_transfer;
                        UsbAsyncInterruptTransfer:efi_usb_io_async_interrupt_transfer;
                        UsbSyncInterruptTransfer:efi_usb_io_sync_interrupt_transfer;
                        UsbIsochronousTransfer:efi_usb_io_isochronous_transfer;
                        UsbAsyncIsochronousTransfer:efi_usb_io_async_isochronous_transfer;
                        UsbGetDeviceDescriptor:efi_usb_io_get_device_descriptor;
                        UsbGetConfigDescriptor:efi_usb_io_get_config_descriptor;
                        UsbGetInterfaceDescriptor:efi_usb_io_get_interface_descriptor;
                        UsbGetEndPointDescriptor:efi_usb_io_get_endpoint_descriptor;
                        UsbGetStringDescriptor:efi_usb_io_get_string_descriptor;
                        UsbGetSupportedLanguages:efi_usb_io_get_supported_languages;
                        UsbPortReset:efi_usb_io_port_reset;
                        end;
    Pefi_usb2_hc_protocol=^efi_usb2_hc_protocol;
    efi_usb2_hc_protocol_get_capability=function (This:Pefi_usb2_hc_protocol;var MaxSpeed,PortNumber,Is64bitCapable:byte):efi_status;cdecl;
    efi_usb2_hc_protocol_reset=function (This:Pefi_usb2_hc_protocol;Attributes:word):efi_status;cdecl;
    efi_usb_hc_state=(efiUsbHcStateHalt,efiUsbHcStateOperational,efiUsbHcStateSuspend,efiUsbHcStateMaximum);
    efi_usb2_hc_protocol_get_state=function (This:Pefi_usb2_hc_protocol;var State:efi_usb_hc_state):efi_status;cdecl;
    efi_usb2_hc_protocol_set_state=function (This:Pefi_usb2_hc_protocol;State:efi_usb_hc_state):efi_status;cdecl;
    efi_usb2_hc_transaction_translator=record
                                      TranslatorHubAddress:byte;
                                      TranslatorPortNumber:byte;
                                      end;
    Pefi_usb2_hc_transaction_translator=^efi_usb2_hc_transaction_translator;
    efi_usb2_hc_protocol_control_transfer=function (This:Pefi_usb2_hc_protocol;DeviceAddress,DeviceSpeed:byte;MaximumPacketLength:natuint;Request:Pefi_usb_device_request;TransferDirection:efi_usb_data_direction;var Data;var DataLength:natuint;TimeOut:natuint;Translator:efi_usb2_hc_transaction_translator;var TransferResult:dword):efi_status;cdecl;
    efi_usb_max_bulk_buffer_array=array [1..efi_usb_max_bulk_buffer_num] of byte;
    efi_usb2_hc_protocol_bulk_transfer=function (This:Pefi_usb2_hc_protocol;DeviceAddress,EndPointAddress,DeviceSpeed:byte;MaximumPacketLength:qword;DataBuffersNumber:byte;var Data:efi_usb_max_bulk_buffer_array;var DataLength:natuint;var DataToggle:byte;TimeOut:natuint;Translator:Pefi_usb2_hc_transaction_translator;var TransferResult:dword):efi_status;cdecl;
    efi_usb2_hc_protocol_async_interrupt_transfer=function (This:Pefi_usb2_hc_protocol;DeviceAddress,EndPointAddress,DeviceSpeed:byte;MaximumPackletLength:natuint;IsNewTransfer:boolean;var DataToggle:byte;PollingInterval,DataLength:natuint;Translator:Pefi_usb2_hc_transaction_translator;CallBackFunction:efi_async_usb_transfer_callback;Context:Pointer):efi_status;cdecl;
    efi_usb2_hc_protocol_sync_interrupt_transfer=function (This:Pefi_usb2_hc_protocol;DeviceAddress,EndPointAddress,DeviceSpeed:byte;MaximumPacketLength:natuint;IsNewTransfer:boolean;var Data;var DataLength:natuint;var DataToggle:byte;TimeOut:natuint;Translator:Pefi_usb2_hc_transaction_translator;var TransferResult:dword):efi_status;cdecl;
    efi_usb_max_iso_buffer_array=array [1..efi_usb_max_iso_buffer_num] of byte;
    efi_usb2_hc_protocol_isochronous_transfer=function (This:Pefi_usb2_hc_protocol;DeviceAddress,EndPointAddress,DeviceSpeed:byte;MaximumPacketLength:natuint;DataBuffersNumber:byte;Data:efi_usb_max_iso_buffer_array;DataLength:natuint;Translator:Pefi_usb2_hc_transaction_translator;var TransferResult:dword):efi_status;cdecl;
    efi_usb2_hc_protocol_async_isochronous_transfer=function (This:Pefi_usb2_hc_protocol;DeviceAddress,EndPointAddress,DeviceSpeed:byte;MaximumPacketLength:natuint;DataBuffersNumber:byte;Data:efi_usb_max_iso_buffer_array;DataLength:natuint;Translator:Pefi_usb2_hc_transaction_translator;IsochronousCallBack:efi_async_usb_transfer_callback;Context:Pointer):efi_status;cdecl;
    efi_usb_port_status=record
                        PortStatus,PortChangeStatus:word;
                        end;
    efi_usb_port_feature=(efiUsbPortEnable=1,efiUsbPortSuspend=2,efiUsbPortReset=4,efiUsbPortPower=8,efiUsbPortOwner=13,efiUsbPortConnectChange=16,efiUsbPortEnableChange=17,efiUsbPortSuspendChange=18,efiUsbPortOverCurrentChange=19,efiUsbPortResetChange=20);
    efi_usb2_hc_protocol_get_roothub_port_status=function (This:Pefi_usb2_hc_protocol;PortNumber:byte;var PortStatus:efi_usb_port_status):efi_status;cdecl;
    efi_usb2_hc_protocol_set_roothub_port_feature=function (This:Pefi_usb2_hc_protocol;PortNumber:byte;PortFeature:efi_usb_port_feature):efi_status;cdecl;
    efi_usb2_hc_protocol_clear_roothub_port_feature=function (This:Pefi_usb2_hc_protocol;PortNumber:byte;PortFeature:efi_usb_port_feature):efi_status;cdecl;
    efi_usb2_hc_protocol=record
                         GetCapability:efi_usb2_hc_protocol_get_capability;
                         Reset:efi_usb2_hc_protocol_reset;
                         GetState:efi_usb2_hc_protocol_get_state;
                         SetState:efi_usb2_hc_protocol_set_state;
                         ControlTransfer:efi_usb2_hc_protocol_control_transfer;
                         BulkTransfer:efi_usb2_hc_protocol_bulk_transfer;
                         AsyncInterruptTransfer:efi_usb2_hc_protocol_async_interrupt_transfer;
                         SyncInterruptTransfer:efi_usb2_hc_protocol_sync_interrupt_transfer;
                         IsochronousTransfer:efi_usb2_hc_protocol_isochronous_transfer;
                         AsyncIsochronousTransfer:efi_usb2_hc_protocol_async_isochronous_transfer;
                         GetRootHubPortStatus:efi_usb2_hc_protocol_get_roothub_port_status;
                         SetRootHubPortFeature:efi_usb2_hc_protocol_set_roothub_port_feature;
                         ClearRootHubPortFeature:efi_usb2_hc_protocol_clear_roothub_port_feature;
                         MajorRevision:word;
                         MinorRevision:word;
                         end;
    Pefi_usbfn_io_protocol=^efi_usbfn_io_protocol;
    efi_usbfn_port_type=(efiUsbUnknownPort=0,efiUsbStandardDownStreamPort,efiUsbChargingDownStreamPort,efiUsbDedicatedChargingPort,efiUsbInvaildDedicatedChargingPort);
    efi_usbfn_io_detect_port=function (This:Pefi_usbfn_io_protocol;var PortType:efi_usbfn_port_type):efi_status;cdecl;
    Pefi_usb_endpoint_descriptor=^efi_usb_endpoint_descriptor;
    efi_usb_interface_info=record
                           InterfaceDescriptor:^efi_usb_interface_descriptor;
                           EndPointDescriptorTable:^Pefi_usb_endpoint_descriptor;
                           end;
    Pefi_usb_interface_info=^efi_usb_interface_info;
    efi_usb_config_info=record
                        ConfigDescriptor:^efi_usb_config_descriptor;
                        InterfaceInfoTable:^Pefi_usb_interface_info;
                        end;
    Pefi_usb_config_info=^efi_usb_config_info;
    efi_usb_device_info=record
                        DeviceDescriptor:^efi_usb_device_descriptor;
                        ConfigInfoTable:^Pefi_usb_config_info;
                        end;
    Pefi_usb_device_info=^efi_usb_device_info;
    efi_usbfn_io_configure_enable_endpoints=function (This:Pefi_usbfn_io_protocol;DeviceInfo:Pefi_usb_device_info):efi_status;cdecl;
    efi_usb_endpoint_type=(UsbEndPointControl=$00,UsbEndPointIsochronous=$01,UsbEndPointBulk=$02,UsbEndpointInterrupt=$03);
    efi_usb_bus_speed=(UsbBusSpeedUnknown=0,UsbBusSpeedLow,UsbBusSpeedFull,UsbBusSpeedHigh,UsbBusSpeedSuper,UsbBusSpeedMaximum=UsbBusSpeedSuper);
    efi_usbfn_io_get_endpoint_maxpacket_size=function (This:Pefi_usbfn_io_protocol;EndPointType:efi_usb_endpoint_type;BusSpeed:efi_usb_bus_speed;var MaxPacketSize:word):efi_status;cdecl;
    efi_usbfn_device_info_id=(efiUsbDeviceInfoUnknown=0,efiUsbDeviceInfoSerialNumber,efiUsbDeviceInfoManufacturerName,efiUsbDeviceInfoProductName);
    efi_usbfn_io_get_device_info=function (This:Pefi_usbfn_io_protocol;Id:efi_usbfn_device_info_id;var BufferSize:natuint;var Buffer):efi_status;cdecl;
    efi_usbfn_io_get_vendor_id_product_id=function (This:Pefi_usbfn_io_protocol;var Vid,Pid:word):efi_status;cdecl;
    efi_usbfn_endpoint_direction=(efiUsbEndPointDirectionHostOut=0,efiUsbEndPointDirectionHostIn,efiUsbEndPointDirectionDeviceTx=efiUsbEndPointDirectionHostIn,efiUsbEndPointDirectionDeviceRx=efiUsbEndPointDirectionHostOut);
    efi_usbfn_io_abort_transfer=function (This:Pefi_usbfn_io_protocol;EndPointIndex:byte;Direction:efi_usbfn_endpoint_direction):efi_status;cdecl;
    efi_usbfn_io_get_endpoint_stall_state=function (This:Pefi_usbfn_io_protocol;EndPointIndex:byte;Direction:efi_usbfn_endpoint_direction;var State:boolean):efi_status;cdecl;
    efi_usbfn_io_set_endpoint_stall_state=function (This:Pefi_usbfn_io_protocol;EndPointIndex:byte;Direction:efi_usbfn_endpoint_direction;State:boolean):efi_status;cdecl;
    efi_usbfn_message=(efiUsbMsgNone=0,efiUsbMsgSetupPacket,efiUsbMsgEndPointStatusChangedRx,efiUsbMsgEndPointStatusChangedTx,efiUsbMsgBusEventDetach,efiUsbMsgBusEventAttach,efiUsbMsgBusEventReset,efiUsbMsgBusEventResume,efiUsbMsgBusEventSpeed);
    efi_usbfn_transfer_status=(UsbTransferStatusUnknown=0,UsbTransferStatusComplete,UsbTransferStatusAborted,UsbTransferStatusActive,UsbTransferStatusNone);
    efi_usbfn_transfer_result=record
                              BytesTransferred:natuint;
                              TransferStatus:efi_usbfn_transfer_status;
                              EndPointIndex:byte;
                              Direction:efi_usbfn_endpoint_direction;
                              Buffer:Pointer;
                              end;
    efi_usbfn_message_payload=record
                              udr:efi_usb_device_request;
                              utr:efi_usbfn_transfer_result;
                              ubs:efi_usb_bus_speed;
                              end;
    efi_usbfn_io_eventhandler=function (This:Pefi_usbfn_io_protocol;var Message:efi_usbfn_message;var PayloadSize:natuint;var Payload:efi_usbfn_message_payload):efi_status;cdecl;
    efi_usbfn_io_transfer=function (This:Pefi_usbfn_io_protocol;EndPointIndex:byte;Direction:efi_usbfn_endpoint_direction;var BufferSize:natuint;var Buffer):efi_status;cdecl;
    efi_usbfn_io_get_maxtransfer_size=function (This:Pefi_usbfn_io_protocol;var MaxTransferSize:natuint):efi_status;cdecl;
    efi_usbfn_io_allocate_transfer_buffer=function (This:Pefi_usbfn_io_protocol;Size:natuint;var Buffer:Pointer):efi_status;cdecl;
    efi_usbfn_io_free_transfer_buffer=function (This:Pefi_usbfn_io_protocol;Buffer:Pointer):efi_status;cdecl;
    efi_usbfn_io_start_controller=function (This:Pefi_usbfn_io_protocol):efi_status;cdecl;
    efi_usbfn_io_stop_controller=function (This:Pefi_usbfn_io_protocol):efi_status;cdecl;
    efi_usbfn_policy_type=(efiUsbPolicyUndefined=0,efiUsbPolicyMaxTransactionSize,efiUsbPolicyZeroLengthTerminationSupport,efiUsbPolicyZeroLengthTermination);
    efi_usbfn_io_set_endpoint_policy=function (This:Pefi_usbfn_io_protocol;EndPointIndex:byte;Direction:efi_usbfn_endpoint_direction;PolicyType:efi_usbfn_policy_type;BufferSize:natuint;Buffer:Pointer):efi_status;cdecl;
    efi_usbfn_io_get_endpoint_policy=function (This:Pefi_usbfn_io_protocol;EndPointIndex:byte;Direction:efi_usbfn_endpoint_direction;PolicyType:efi_usbfn_policy_type;var BufferSize:natuint;var Buffer):efi_status;cdecl;
    efi_usbfn_io_protocol=record
                          Revision:dword;
                          DetectPort:efi_usbfn_io_detect_port;
                          ConfigureEnableEndPoints:efi_usbfn_io_configure_enable_endpoints;
                          GetEndpointMaxPacketSize:efi_usbfn_io_get_endpoint_maxpacket_size;
                          GetDeviceInfo:efi_usbfn_io_get_device_info;
                          GetVendorIdProductId:efi_usbfn_io_get_vendor_id_product_id;
                          AbortTransfer:efi_usbfn_io_abort_transfer;
                          GetEndPointStallState:efi_usbfn_io_get_endpoint_stall_state;
                          SetEndPointStallState:efi_usbfn_io_set_endpoint_stall_state;
                          EventHandler:efi_usbfn_io_eventhandler;
                          Transfer:efi_usbfn_io_transfer;
                          GetMaxTransferSize:efi_usbfn_io_get_maxtransfer_size;
                          AllocateTransferBuffer:efi_usbfn_io_allocate_transfer_buffer;
                          FreeTransferBuffer:efi_usbfn_io_free_transfer_buffer;
                          StartController:efi_usbfn_io_start_controller;
                          StopController:efi_usbfn_io_stop_controller;
                          SetEndPointPolicy:efi_usbfn_io_set_endpoint_policy;
                          GetEndPointPolicy:efi_usbfn_io_get_endpoint_policy;
                          end;
    Pefi_debug_support_protocol=^efi_debug_support_protocol;
    efi_instruction_set_architecture=(IsaIa32=$014C,IsaX64=$8664,IsaIpf=$0200,IsaEbc=$0EBC,IsaArm=$01C2,IsaAArch64=$AA64,Isariscv32=$5032,Isariscv64=$5064,Isariscv128=$5128,Isaloongarch32=$6232,Isaloongarch64=$6264);
    efi_get_maximum_processor_index=function (This:Pefi_debug_support_protocol;var MaxProcessorIndex:natuint):efi_status;cdecl;
    efi_system_context_ebc=record
                           R0,R1,R2,R3,R4,R5,R6,R7:qword;
                           Flags:qword;
                           ControlFlags:qword;
                           Ip:qword;
                           end;
    efi_fx_save_state_ia32=record
                           Fcw,Fsw,Ftw,OpCode,Eip,Cs,Reserved1:word;
                           DataOffset:dword;
                           Ds:word;
                           Reserved2:array[1..10] of byte;
                           St0Mm0:array[1..10] of byte;
                           Reserved3:array[1..6] of byte;
                           St1Mm1:array[1..10] of byte;
                           Reserved4:array[1..6] of byte;
                           St2Mm2:array[1..10] of byte;
                           Reserved5:array[1..6] of byte;
                           St3Mm3:array[1..10] of byte;
                           Reserved6:array[1..6] of byte;
                           St4Mm4:array[1..10] of byte;
                           Reserved7:array[1..6] of byte;
                           St5Mm5:array[1..10] of byte;
                           Reserved8:array[1..6] of byte;
                           St6Mm6:array[1..10] of byte;
                           Reserved9:array[1..6] of byte;
                           St7Mm7:array[1..10] of byte;
                           Reserved10:array[1..6] of byte;
                           Xmm0,Xmm1,Xmm2,Xmm3,Xmm4,Xmm5,Xmm6,Xmm7:array[1..16] of byte;
                           Reserved11:array[1..224] of byte;
                           end;
    efi_system_context_ia32=record
                            ExceptionData:dword;
                            FxSaveState:efi_fx_save_state_ia32;
                            Dr0,Dr1,Dr2,Dr3,Dr6,Dr7:dword;
                            Cr0,Cr1,Cr2,Cr3,Cr4:dword;
                            Eflags:dword;
                            Ldtr,Tr:dword;
                            Gdtr,Idtr:array[1..2] of dword;
                            Eip:dword;
                            Gs,Fs,Es,Ds,Cs,Ss:dword;
                            Edi,Esi,Ebp,Esp,Ebx,Edx,Ecx,Eax:dword;
                            end;
    efi_fx_save_state_x64=record
                          Fcw,Fsw,Ftw,Opcode:word;
                          Rip,DataOffset:qword;
                          Reserved1:array[1..8] of byte;
                          St0Mm0:array[1..10] of byte;
                          Reserved2:array[1..6] of byte;
                          St1Mm1:array[1..10] of byte;
                          Reserved3:array[1..6] of byte;
                          St2Mm2:array[1..10] of byte;
                          Reserved4:array[1..6] of byte;
                          St3Mm3:array[1..10] of byte;
                          Reserved5:array[1..6] of byte;
                          St4Mm4:array[1..10] of byte;
                          Reserved6:array[1..6] of byte;
                          St5Mm5:array[1..10] of byte;
                          Reserved7:array[1..6] of byte;
                          St6Mm6:array[1..10] of byte;
                          Reserved8:array[1..6] of byte;
                          St7Mm7:array[1..10] of byte;
                          Reserved9:array[1..6] of byte;
                          Xmm0,Xmm1,Xmm2,Xmm3,Xmm4,Xmm5,Xmm6,Xmm7:array[1..16] of byte;
                          Reserved10:array[1..224] of byte;
                          end;
    efi_system_context_x64=record
                           ExceptionData:qword;
                           FxSaveState:efi_fx_save_state_x64;
                           Dr0,Dr1,Dr2,Dr3,Dr6,Dr7:qword;
                           Cr0,Cr1,Cr2,Cr3,Cr4,Cr8:qword;
                           RFlags:qword;
                           Ldtr,Tr:qword;
                           Gdtr,Idtr:array[1..2] of qword;
                           Rip:qword;
                           Gs,Fs,Es,Ds,Cs,Ss:qword;
                           Rdi,Rsi,Rbp,Rsp,Rbx,Rdx,Rcx,Rax:qword;
                           R8,R9,R10,R11,R12,R13,R14,R15:qword;
                           end;
    efi_system_context_ipf=record
                           Reserved:qword;
                           R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15,R16,R17,R18,R19,R20,R21,R22,R23,R24,R25,R26,R27,R28,R29,R30,R31:qword;
                           F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32:array [1..2] of qword;
                           Pr:qword;
                           B0,B1,B2,B3,B4,B5,B6,B7:qword;
                           ArRsc,ArBsp,ArBspstore,ArRnat:qword;
                           ArFcr:qword;
                           ArEflag,ArCsd,ArSsd,ArCflg:qword;
                           ArFsr,ArFir,ArFdr:qword;
                           ArCcv:qword;
                           ArUnat:qword;
                           ArFpsr:qword;
                           ArPfs,ArLc,ArEc:qword;
                           CrDcr,CrItm,CrIva,CrPta,CrIpsr,CrIsr,CrIip,CrIfa,CrItir,CrIipa,CrIfs,CrIim,CrIha:qword;
                           Dbr0,Dbr1,Dbr2,Dbr3,Dbr4,Dbr5,Dbr6,Dbr7:qword;
                           Ibr0,Ibr1,Ibr2,Ibr3,Ibr4,Ibr5,Ibr6,Ibr7:qword;
                           IntNat:qword;
                           end;
    efi_system_context_arm=record
                           R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,SP,LR,PC,CPSR,DPSR,DFAR,IFSR:dword;
                           end;
    efi_system_context_aarch64=record
                               X0,X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22,X23,X24,X25,X26,X27,X28,FP,LR,SP:qword;
                               V0,V1,V2,V3,V4,V5,V6,V7,V8,V9,V10,V11,V12,V13,V14,V15,V16,V17,V18,V19,V20,V21,V22,V23,V24,V25,V26,V27,V28,V29,V30,V31:array[1..2] of qword;
                               ELR,SPSR,FPSR,ESR,FaultAddressRegister:qword;
                               end;
    efi_system_context_riscv32=record
                               Zero,Ra,Sp,Gp,Tp,T0,T1,T2:dword;
                               S0FP,S1,A0,A1,A2,A3,A4,A5,A6,A7:dword;
                               S2,S3,S4,S5,S6,S7,S8,S9,S10,S11:dword;
                               T3,T4,T5,T6:dword;
                               Ft0,Ft1,Ft2,Ft3,Ft4,Ft5,Ft6,Ft7:uint128;
                               Fs0,Fs1,Fa0,Fa1,Fa2,Fa3,Fa4,Fa5,Fa6,Fa7:uint128;
                               Fs2,Fs3,Fs4,Fs5,Fs6,Fs7,Fs8,Fs9,Fs10,Fs11:uint128;
                               Ft8,Ft9,Ft10,Ft11,Ft12:uint128;
                               end;
    efi_system_context_riscv64=record
                               Zero,Ra,Sp,Gp,Tp,T0,T1,T2:qword;
                               S0FP,S1,A0,A1,A2,A3,A4,A5,A6,A7:qword;
                               S2,S3,S4,S5,S6,S7,S8,S9,S10,S11:qword;
                               T3,T4,T5,T6:qword;
                               Ft0,Ft1,Ft2,Ft3,Ft4,Ft5,Ft6,Ft7:uint128;
                               Fs0,Fs1,Fa0,Fa1,Fa2,Fa3,Fa4,Fa5,Fa6,Fa7:uint128;
                               Fs2,Fs3,Fs4,Fs5,Fs6,Fs7,Fs8,Fs9,Fs10,Fs11:uint128;
                               Ft8,Ft9,Ft10,Ft11,Ft12:uint128;
                               end;
    efi_system_context_riscv128=record
                               Zero,Ra,Sp,Gp,Tp,T0,T1,T2:uint128;
                               S0FP,S1,A0,A1,A2,A3,A4,A5,A6,A7:uint128;
                               S2,S3,S4,S5,S6,S7,S8,S9,S10,S11:uint128;
                               T3,T4,T5,T6:uint128;
                               Ft0,Ft1,Ft2,Ft3,Ft4,Ft5,Ft6,Ft7:uint128;
                               Fs0,Fs1,Fa0,Fa1,Fa2,Fa3,Fa4,Fa5,Fa6,Fa7:uint128;
                               Fs2,Fs3,Fs4,Fs5,Fs6,Fs7,Fs8,Fs9,Fs10,Fs11:uint128;
                               Ft8,Ft9,Ft10,Ft11,Ft12:uint128;
                               end;
    efi_system_context_loongarch64=record
                                   R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15,R16,R17,R18,R19,R20,R21,R22,R23,R24,R25,R26,R27,R28,R29,R30,R31:qword;
                                   CRMD,PRMD,EUEN,MISC,ECFG,ESTAT,ERA,BADV,BADI:qword;
                                   end;
    efi_system_context=record
                       case Byte of
                       0:(SystemContextEbc:^efi_system_context_ebc;);
                       1:(SystemContextIa32:^efi_system_context_ia32;);
                       2:(SystemContextX64:^efi_system_context_x64;);
                       3:(SystemContextIpf:^efi_system_context_ipf;);
                       4:(SystemContextArm:^efi_system_context_arm;);
                       5:(SystemContextAarch64:^efi_system_context_aarch64;);
                       6:(SystemContextriscv32:^efi_system_context_riscv32;);
                       7:(SystemContextriscv64:^efi_system_context_riscv64;);
                       8:(SystemContextriscv128:^efi_system_context_riscv128;);
                       9:(SystemContextloongarch64:^efi_system_context_loongarch64;);
                       end;
    efi_periodic_callback=procedure (var SystemContext:efi_system_context);
    efi_register_periodic_callback=function (This:Pefi_debug_support_protocol;ProcessorIndex:natuint;PeriodicCallBack:efi_periodic_callback):efi_status;cdecl;
    efi_exception_type=int64;
    efi_exception_callback=procedure (ExceptionType:efi_exception_type;var SystemContext:efi_system_context);
    efi_register_exception_callback=function (This:Pefi_debug_support_protocol;ProcessorIndex:natuint;ExceptionCallBack:efi_exception_callback;ExceptionType:efi_exception_type):efi_status;cdecl;
    efi_invalidate_instruction_cache=function (This:Pefi_debug_support_protocol;ProcessorIndex:natuint;Start:Pointer;Length:qword):efi_status;cdecl;
    efi_debug_support_protocol=record
                               Isa:efi_instruction_set_architecture;
                               GetMaximumProcessorIndex:efi_get_maximum_processor_index;
                               RegisterPeriodicCallBack:efi_register_periodic_callback;
                               RegisterExceptionCallBack:efi_register_exception_callback;
                               InvalidateInstructionCache:efi_invalidate_instruction_cache;
                               end;
    Pefi_debugport_protocol=^efi_debugport_protocol;
    efi_debugport_reset=function (This:Pefi_debugport_protocol):efi_status;cdecl;
    efi_debugport_write=function (This:Pefi_debugport_protocol;TimeOut:dword;var BufferSize:natuint;Buffer:Pointer):efi_status;cdecl;
    efi_debugport_read=function (This:Pefi_debugport_protocol;TimeOut:dword;var BufferSize:natuint;var Buffer):efi_status;cdecl;
    efi_debugport_poll=function (This:Pefi_debugport_protocol):efi_status;cdecl;
    efi_debugport_protocol=record
                           Reset:efi_debugport_reset;
                           efiWrite:efi_debugport_write;
                           efiRead:efi_debugport_read;
                           Poll:efi_debugport_poll;
                           end;
    Pefi_decompress_protocol=^efi_decompress_protocol;
    efi_decompress_get_info=function (This:Pefi_decompress_protocol;Source:Pointer;SourceSize:dword;var DestinationSize,ScratchSize:dword):efi_status;cdecl;
    efi_decompress_decompress=function (This:Pefi_decompress_protocol;Source:Pointer;SourceSize:dword;var Destination;DestinationSize:dword;var Scratch;ScratchSize:dword):efi_status;cdecl;
    efi_decompress_protocol=record
                            GetInfo:efi_decompress_get_info;
                            Decompress:efi_decompress_decompress;
                            end;
    Pefi_acpi_table_protocol=^efi_acpi_table_protocol;
    efi_acpi_table_install_acpi_table=function (This:Pefi_acpi_table_protocol;AcpiTableBuffer:Pointer;AcpiTableBufferSize:natuint;var TableKey:natuint):efi_status;cdecl;
    efi_acpi_table_uninstall_acpi_table=function (This:Pefi_acpi_table_protocol;Tablekey:natuint):efi_status;cdecl;
    efi_acpi_table_protocol=record
                            InstallAcpiTable:efi_acpi_table_install_acpi_table;
                            UnInstallAcpiTable:efi_acpi_table_uninstall_acpi_table;
                            end;
    Pefi_unicode_collation_protocol=^efi_unicode_collation_protocol;
    efi_unicode_collation_stricoll=function (This:Pefi_unicode_collation_protocol;s1,s2:PWideChar):natint;cdecl;
    efi_unicode_collation_metaimatch=function (This:Pefi_unicode_collation_protocol;str,pattern:PWideChar):boolean;cdecl;
    efi_unicode_collation_strlwr=procedure (This:Pefi_unicode_collation_protocol;var str:PWideChar);cdecl;
    efi_unicode_collation_strupr=procedure (This:Pefi_unicode_collation_protocol;var str:PWideChar);cdecl;
    efi_unicode_collation_fattostr=procedure (This:Pefi_unicode_collation_protocol;FatSize:natuint;Fat:PChar;var Str:PWideChar);cdecl;
    efi_unicode_collation_strtofat=procedure (This:Pefi_unicode_collation_protocol;Str:PWideChar;FatSize:natuint;var Fat:PChar);cdecl;
    efi_unicode_collation_protocol=record
                                   StriColl:efi_unicode_collation_stricoll;
                                   MetaiMatch:efi_unicode_collation_metaimatch;
                                   StrLwr:efi_unicode_collation_strlwr;
                                   StrUpr:efi_unicode_collation_strupr;
                                   FatToStr:efi_unicode_collation_fattostr;
                                   StrToFat:efi_unicode_collation_strtofat;
                                   SupportedLanguages:PChar;
                                   end;
    Pefi_regular_expression_protocol=^efi_regular_expression_protocol;
    efi_regex_capture=record
                      CapturePtr:PWideChar;
                      Length:natuint;
                      end;
    efi_regex_syntax_type=efi_guid;
    efi_regular_expression_match=function (This:Pefi_regular_expression_protocol;Str,Pattern:PWideChar;SyntaxType:efi_regex_syntax_type;var fResult:boolean;var Captures:efi_regex_capture):efi_status;cdecl;
    efi_regular_expression_get_info=function (This:Pefi_regular_expression_protocol;var RegExSyntaxTypeListSize:natuint;var RegExSyntaxTypeList:efi_regex_syntax_type):efi_status;cdecl;
    efi_regular_expression_protocol=record
                                    MatchString:efi_regular_expression_match;
                                    GetInfo:efi_regular_expression_get_info;
                                    end;
    Pefi_ebc_protocol=^efi_ebc_protocol;
    PPefi_ebc_protocol=^Pefi_ebc_protocol;
    efi_ebc_create_trunk=function (This:Pefi_ebc_protocol;ImageHandle:efi_handle;EbcEntryPoint:Pointer;var Trunk:Pointer):efi_status;cdecl;
    efi_ebc_unload_image=function (This:Pefi_ebc_protocol;ImageHandle:efi_handle):efi_status;cdecl;
    ebc_icache_flush=function (Start:efi_physical_address;Length:qword):efi_status;cdecl;
    Pebc_icache_flush=^ebc_icache_flush;
    efi_ebc_register_icache_flush=function (This:PPefi_ebc_protocol;Flush:Pebc_icache_flush):efi_status;cdecl;
    efi_ebc_get_version=function (This:Pefi_ebc_protocol;var Version:qword):efi_status;cdecl;
    efi_ebc_protocol=record
                     CreateTrunk:efi_ebc_create_trunk;
                     UnloadImage:efi_ebc_unload_image;
                     RegisterICacheFlush:efi_ebc_register_icache_flush;
                     GetVersion:efi_ebc_get_version;
                     end;
    Pefi_firmware_management_protocol=^efi_firmware_management_protocol;
    efi_firmware_image_authentication=record
                                      MonotonicCount:qword;
                                      AuthInfo:efi_guid;
                                      end;
    efi_firmware_image_descriptor=record
                                  ImageIndex:byte;
                                  ImageTypeId:efi_guid;
                                  ImageId:qword;
                                  ImageIdName:PWideChar;
                                  Version:dword;
                                  VersionName:PWideChar;
                                  Size:natuint;
                                  AttributesSupported,AttributesSetting,Compatibilities:qword;
                                  LowestSupportedImageVersion,LastAttemptVersion,LastAttemptStatus:dword;
                                  HardwareInstance:qword;
                                  Dependencies:array of byte;
                                  end;
    efi_firmware_management_protocol_get_image_info=function (This:Pefi_firmware_management_protocol;var ImageInfoSize:natuint;var ImageInfo:efi_firmware_image_descriptor;var DescriptorVersion:dword;var DescriptorCount:byte;PackageVersion:dword;var PackageVersionName:PWideChar):efi_status;cdecl;
    efi_firmware_management_protocol_get_image=function (This:Pefi_firmware_management_protocol;ImageIndex:byte;var Image;var ImageSize:natuint):efi_Status;cdecl;
    efi_firmware_management_update_image_progress=function (Completion:natuint):efi_status;cdecl;
    efi_firmware_management_protocol_set_image=function (This:Pefi_firmware_management_protocol;ImageIndex:byte;Image:Pointer;ImageSize:natuint;VendorCode:Pointer;Progress:efi_firmware_management_update_image_progress;var AbortReason:PWideChar):efi_status;cdecl;
    efi_firmware_management_protocol_check_image=function (This:Pefi_firmware_management_protocol;ImageIndex:byte;Image:Pointer;ImageSize:natuint;var ImageUpdatable:dword):efi_status;cdecl;
    efi_firmware_management_protocol_get_package_info=function (This:Pefi_firmware_management_protocol;var PackageVersion:dword;var PackageVersionName:PwideChar;var PackageVersionNameMaxLen:dword;var AttributesSupported:qword;var AttributesSetting:qword):efi_status;
    efi_firmware_management_protocol_set_package_info=function (This:Pefi_firmware_management_protocol;Image:Pointer;ImageSize:natuint;VendorCode:Pointer;PackageVersion:dword;PackageVersionName:PWideChar):efi_status;cdecl;
    efi_firmware_management_protocol=record
                                     GetImageInfo:efi_firmware_management_protocol_get_image_info;
                                     GetImage:efi_firmware_management_protocol_get_image;
                                     SetImage:efi_firmware_management_protocol_set_image;
                                     CheckImage:efi_firmware_management_protocol_check_image;
                                     GetPackageInfo:efi_firmware_management_protocol_get_package_info;
                                     SetPackageInfo:efi_firmware_management_protocol_set_package_info;
                                     end;
    efi_system_resource_entry=record
                              FwClass:efi_guid;
                              FwType:dword;
                              FwVersion:dword;
                              LowestSupportedFwVersion:dword;
                              CapsuleFlags:dword;
                              LastAttemptVersion,LastAttemptStatus:dword;
                              end;
    efi_system_resource_table=record
                              FwResourceCount:dword;
                              FwResourceCountMax:dword;
                              FwResourceVersion:qword;
                              Entries:array of efi_system_resource_entry;
                              end;
    efi_json_capsule_header=record
                            Version,CapsuleId,PayloadLength:dword;
                            Payload:array of byte;
                            end;
    efi_json_data_item=record
                       ConfigDataLength:dword;
                       ConfigData:array of byte;
                       end;
    efi_json_capsule_config_data=record
                                 Version,TotalLength:dword;
                                 ConfigDataList:array of efi_json_data_item;
                                 end;
    Pefi_simple_network_protocol=^efi_simple_network_protocol;
    efi_simple_network_state=(efiSimpleNetworkStopped,efiSimpleNetworkStarted,efiSimpleNetworkInitialized,efiSimpleNetworkMaxState);
    efi_simple_network_mode=record
                            State,HwAddressSize,MediaHeaderSize,MaxPacketSize,NvRamSize,NvRamAccessSize,ReceiveFilterMask,ReceiveFilterSetting,MaxMCastFilterCount,MCastFilterCount:dword;
                            MCastFilter:array[1..max_mcast_filter_cnt] of efi_mac_address;
                            CurrentAddress,BroadCastAddress,PermanentAddress:efi_mac_address;
                            Iftype:byte;
                            MaxAddressChangable,MultipleTxSupported,MediaPresentSupported,MediaPresent:boolean;
                            end;
    efi_simple_network_start=function (This:Pefi_simple_network_protocol):efi_status;cdecl;
    efi_simple_network_stop=function (This:Pefi_simple_network_protocol):efi_status;cdecl;
    efi_simple_network_initialize=function (This:Pefi_simple_network_protocol;ExtraRxBufferSize,ExtraTxBufferSize:natuint):efi_status;cdecl;
    efi_simple_network_reset=function (This:Pefi_simple_network_protocol;ExtendedVerification:boolean):efi_status;cdecl;
    efi_simple_network_shutdown=function (This:Pefi_simple_network_protocol):efi_status;cdecl;
    efi_simple_network_receive_Filters=function (This:Pefi_simple_network_protocol;Enable,Disable:dword;ResetMCastFilter:boolean;MCastFilterCnt:natuint;MCastFilter:Pefi_mac_address):efi_status;cdecl;
    efi_simple_network_station_address=function (This:Pefi_simple_network_protocol;Reset:boolean;new:efi_mac_address):efi_status;cdecl;
    efi_network_statistics=record
                           RxTotalFrames,RxGoodFrames,RxUnderSizeFrames,RxOverSizeFrames,RxDroppedFrames,RxUniCastFrames,RxBroadCastFrames,RxMultiCastFrames:qword;
                           RxCrcErrorFrames,RxTotalBytes,TxTotalFrames,TxGoodFrames:qword;
                           TxUnderSizeFrames,TxOverSizeFrames,TxDroppedFrames,TxUniCastFrames,TxBroadCastFrames,TxMultiCastFrames:qword;
                           TxCrcErrorFrames,TxTotalBytes:qword;
                           Collisions,UnsupportedProtocol,RxDuplicatedFrames,RxDecryptErrorFrames,TxErrorFrames,TxRetryframes:qword;
                           end;
    efi_simple_network_statistics=function (This:Pefi_simple_network_protocol;Reset:boolean;var StatisticsSize:natuint;var StatisticsTable:efi_network_statistics):efi_status;cdecl;
    efi_simple_network_mcast_ip_to_mac=function (This:Pefi_simple_network_protocol;IPv6:boolean;IP:Pefi_ip_address;var Mac:efi_mac_address):efi_status;cdecl;
    efi_simple_network_nvdata=function (This:Pefi_simple_network_protocol;ReadWrite:boolean;Offset:natuint;BufferSize:natuint;var Buffer):efi_status;cdecl;
    efi_simple_network_get_status=function (This:Pefi_simple_network_protocol;var InterruptStatus:dword;var TxBuf:Pointer):efi_status;cdecl;
    efi_simple_network_transmit=function (This:Pefi_simple_network_protocol;HeaderSize,BufferSize:natuint;Buffer:Pointer;SrcAddr,DestAddr:Pefi_mac_address;Protocol:Pword):efi_status;cdecl;
    efi_simple_network_receive=function (This:Pefi_simple_network_protocol;var HeaderSize,BufferSize:natuint;var Buffer;var SrcAddr,DestAddr:efi_mac_address;var Protocol:word):efi_status;cdecl;
    efi_simple_network_protocol=record
                                Revision:qword;
                                Start:efi_simple_network_start;
                                Stop:efi_simple_network_stop;
                                Initialize:efi_simple_network_initialize;
                                Reset:efi_simple_network_reset;
                                Shutdown:efi_simple_network_shutdown;
                                ReceiveFilters:efi_simple_network_receive_Filters;
                                StationAddress:efi_simple_network_station_address;
                                Statistics:efi_simple_network_statistics;
                                MCastIPtoMac:efi_simple_network_mcast_ip_to_mac;
                                NvData:efi_simple_network_nvdata;
                                GetStatus:efi_simple_network_get_status;
                                Transmit:efi_simple_network_transmit;
                                Receive:efi_simple_network_receive;
                                WaitForPacket:efi_event;
                                Mode:^efi_simple_network_mode;
                                end;
    efi_network_interface_type=(efiNetworkInterfaceUndi=1);
    Pefi_network_interface_identifier_protocol=^efi_network_interface_identifier_protocol;
    efi_network_interface_identifier_protocol=record
                                              Revision,Id,ImageAddr:qword;
                                              ImageSize:dword;
                                              StringId:array[1..4] of char;
                                              efiType,MajorType,MinorType:byte;
                                              Ipv6Supported:boolean;
                                              IfNum:word;
                                              end;
    Pefi_pxe_base_code_protocol=^efi_pxe_base_code_protocol;
    efi_pxe_base_code_udp_port=word;
    Pefi_pxe_base_code_udp_port=^word;
    efi_pxe_base_code_dhcpv4_packet=record
                                    BootpOpcode:byte;
                                    BootpHwType:byte;
                                    BootpHwAddrlen:byte;
                                    BootpGateHops:byte;
                                    BootpIdent:dword;
                                    BootpSeconds:word;
                                    BootpFlags:word;
                                    BootpCiAddr:array[1..4] of byte;
                                    BootpYiAddr:array[1..4] of byte;
                                    BootpSiAddr:array[1..4] of byte;
                                    BootpGiAddr:array[1..4] of byte;
                                    BootpHwAddr:array[1..16] of byte;
                                    BootpSrvName:array[1..64] of byte;
                                    BootpBootName:array[1..128] of byte;
                                    DhcpMagic:dword;
                                    DhcpOptions:array[1..56] of byte;
                                    end;
    efi_pxe_base_code_dhcpv6_packet=record
                                    MessageType:0..255;
                                    TransactionId:0..16777215;
                                    DhcpOptions:array[1..1024] of byte;
                                    end;
    efi_pxe_base_code_packet=record
                             case byte of
                             0:(Raw:array[1..1472] of byte;);
                             1:(Dhcpv4:efi_pxe_base_code_dhcpv4_packet;);
                             2:(Dhcpv6:efi_pxe_base_code_dhcpv6_packet;);
                             end;
    Pefi_pxe_base_code_packet=^efi_pxe_base_code_packet;
    efi_pxe_base_code_icmp_error_union=packed record
                                       case byte of  
                                       0:(Reserved:dword;);
                                       1:(Mtu:dword;);
                                       2:(efiPointer:dword;);
                                       3:(Identifier:word;Sequence:word;);
                                       end;
    efi_pxe_base_code_icmp_error=record
                                 efiType,code:byte;
                                 Checksum:word;
                                 u:efi_pxe_base_code_icmp_error_union;
                                 Data:array[1..494] of byte;
                                 end;
    efi_pxe_base_code_tftp_error=record
                                 ErrorCode:byte;
                                 ErrorString:array[1..127] of char;
                                 end;
    efi_pxe_base_code_ip_filter=record
                                Filters:byte;
                                IpCnt:byte;
                                Reserved:word;
                                IpList:array[1..efi_pxe_base_code_max_ipcnt] of efi_ip_address;
                                end;
    Pefi_pxe_base_code_ip_filter=^efi_pxe_base_code_ip_filter;
    efi_pxe_base_code_arp_entry=record
                                IpAddr:efi_ip_address;
                                MacAddr:efi_mac_address;
                                end;
    efi_pxe_base_code_route_entry=record
                                  IpAddr,SubnetMask,GwAddr:efi_ip_address;
                                  end;
    efi_pxe_base_code_mode=record
                           Started:boolean;
                           Ipv6Available:boolean;
                           Ipv6Supported:boolean;
                           UsingIpv6:boolean;
                           BisSupported:boolean;
                           BisDetected:boolean;
                           AutoArp:boolean;
                           SendGUID:boolean;
                           DhcpDiscoverVaild:boolean;
                           DhcpAckReceived:boolean;
                           ProxyOfferReceived:boolean;
                           PxeDiscoverVaild:boolean;
                           PxeReplyReceived:boolean;
                           PxeBisReplyReceived:boolean;
                           IcmpErrorReceived:boolean;
                           TftpErrorReceived:boolean;
                           MakeCallBacks:boolean;
                           TTL,TOS:byte;
                           StationIp,SubnetMask:efi_ip_address;
                           DhcpDiscover,DhcpArk,ProxyOffer,PxeDiscover,PxeReply,PxeBisReply:efi_pxe_base_code_packet;
                           IpFilter:efi_pxe_base_code_ip_filter;
                           ArpCacheEntries:dword;
                           ArpCache:array[1..efi_pxe_base_code_max_arp_entries] of efi_pxe_base_code_arp_entry;
                           RouteTableEntries:dword;
                           RouteTable:array[1..efi_pxe_base_code_max_route_entries] of efi_pxe_base_code_route_entry;
                           IcmpError:efi_pxe_base_code_icmp_error;
                           TftpError:efi_pxe_base_code_tftp_error;
                           end;
    efi_pxe_base_code_start=function (This:Pefi_pxe_base_code_protocol;UseIpv6:boolean):efi_status;cdecl;
    efi_pxe_base_code_stop=function (This:Pefi_pxe_base_code_protocol):efi_status;cdecl;
    efi_pxe_base_code_dhcp=function (This:Pefi_pxe_base_code_protocol;SortOffer:boolean):efi_status;cdecl;
    efi_pxe_base_code_srvlist=record
                              efiType:word;
                              AcceptAnyResponse:boolean;
                              Reserved:byte;
                              IpAddr:efi_ip_address;
                              end;
    efi_pxe_base_code_discover_info=record
                                    UseMCast,UseBCast,UseUList,Mustuselist:boolean;
                                    ServerMCastIp:efi_ip_address;
                                    IpCnt:word;
                                    SrvList:array[1..65535] of efi_pxe_base_code_srvlist;
                                    end;
    Pefi_pxe_base_code_discover_info=^efi_pxe_base_code_discover_info;
    efi_pxe_base_code_discover=function (This:Pefi_pxe_base_code_protocol;ftype:word;Layer:Pword;UseBis:boolean;Info:Pefi_pxe_base_code_discover_info):efi_status;cdecl;
    efi_pxe_base_code_tftp_opcode=(efi_pxe_base_code_tftp_first,efi_pxe_base_code_tftp_get_file_size,efi_pxe_base_code_tftp_read_file,efi_pxe_base_code_tftp_write_file,efi_pxe_base_code_tftp_read_directory,efi_pxe_base_code_mtftp_get_file_size,efi_pxe_base_code_mtftp_read_file,efi_pxe_base_codemtftp_read_directory,efi_pxe_base_code_mtftp_last);
    efi_pxe_base_code_mtftp_info=record
                                 MCastIp:efi_ip_address;
                                 CPort,SPort:efi_pxe_base_code_udp_port;
                                 ListenTimeOut,TransmitTimeOut:word;
                                 end;
    Pefi_pxe_base_code_mtftp_info=^efi_pxe_base_code_mtftp_info;
    efi_pxe_base_code_mtftp=function (This:Pefi_pxe_base_code_protocol;Operation:efi_pxe_base_code_tftp_opcode;var BufferPtr;OverWrite:boolean;var BufferSize:qword;BlockSize:Pnatuint;ServerIp:Pefi_ip_address;FileName:PChar;Info:Pefi_pxe_base_code_mtftp_info;DontUseBuffer:boolean):efi_status;cdecl;
    efi_pxe_base_code_udp_write=function (This:Pefi_pxe_base_code_protocol;OpFlags:word;DestIp:Pefi_ip_address;DestPort:Pefi_pxe_base_code_udp_port;GateWayIp:Pefi_ip_address;SrcIp:Pefi_ip_address;var SrcPort:efi_pxe_base_code_udp_port;HeaderSize:Pnatuint;HeaderPtr:Pointer;BufferSize:Pnatuint;BufferPtr:Pointer):efi_status;cdecl;
    efi_pxe_base_code_udp_read=function (This:Pefi_pxe_base_code_protocol;OpFlags:word;var DestIp:efi_ip_address;var Destport:efi_pxe_base_code_udp_port;var SrcIp:efi_ip_address;var SrcPort:efi_pxe_base_code_udp_port;HeaderSize:Pnatuint;HeaderPtr:Pointer;var BufferSize:natuint;BufferPtr:Pointer):efi_status;cdecl;
    efi_pxe_base_code_set_ip_filter=function (This:Pefi_pxe_base_code_protocol;NewFilter:Pefi_pxe_base_code_ip_filter):efi_status;cdecl;
    efi_pxe_base_code_arp=function (This:Pefi_pxe_base_code_protocol;IpAddr:Pefi_ip_address;MacAddr:Pefi_mac_address):efi_status;cdecl;
    efi_pxe_base_code_set_parameters=function (This:Pefi_pxe_base_code_protocol;NewAutoArp,NewSendGUID:Pboolean;NewTTL,NewToS:Pbyte;NewMakeCallBack:Pboolean):efi_status;cdecl;
    efi_pxe_base_code_set_station_ip=function (This:Pefi_pxe_base_code_protocol;NewStationIp,NewSubnetMask:Pefi_ip_address):efi_status;cdecl;
    efi_pxe_base_code_set_packets=function (This:Pefi_pxe_base_code_protocol;NewDhcpDiscoverVaild,NewDhcpAckReceived,NewProxyOfferReceived,NewPxeDiscoverVaild,NewPxeReplyReceived,NewPxeBisReplyReceived:PBoolean;NewDhcpDiscover,NewDhcpAck,NewProxyOffer,NewPxeDiscover,NewPxeReply,NewPxeBisreply:efi_pxe_base_code_packet):efi_status;cdecl;
    efi_pxe_base_code_protocol=record
                               Revision:qword;
                               Start:efi_pxe_base_code_start;
                               Stop:efi_pxe_base_code_stop;
                               Dhcp:efi_pxe_base_code_dhcp;
                               Discover:efi_pxe_base_code_discover;
                               Mtftp:efi_pxe_base_code_mtftp;
                               UdpWrite:efi_pxe_base_code_udp_write;
                               UdpRead:efi_pxe_base_code_udp_read;
                               SetIpFilter:efi_pxe_base_code_set_ip_filter;
                               Arp:efi_pxe_base_code_arp;
                               SetParameters:efi_pxe_base_code_set_parameters;
                               SetStationIp:efi_pxe_base_code_set_station_ip;
                               SetPackets:efi_pxe_base_code_set_packets;
                               Mode:^efi_pxe_base_code_mode;
                               end; 
    Pefi_pxe_base_code_callback_protocol=^efi_pxe_base_code_callback_protocol;
    efi_pxe_base_code_callback_status=(efi_pxe_base_code_callback_status_first,efi_pxe_base_code_callback_status_continue,efi_pxe_base_code_callback_status_abort,efi_pxe_base_code_callback_status_last);
    efi_pxe_base_code_function=(efi_pxe_base_code_function_first,efi_pxe_base_code_function_dhcp,efi_pxe_base_code_function_discover,efi_pxe_base_code_function_mtftp,efi_pxe_base_code_function_udp_write,efi_pxe_base_code_function_udp_read,efi_pxe_base_code_function_arp,efi_pxe_base_code_function_igmp,efi_pxe_base_code_pxe_function_last);
    efi_pxe_callback=function (This:Pefi_pxe_base_code_callback_protocol;ffunction:efi_pxe_base_code_function;Received:boolean;Packetlen:dword;Packet:Pefi_pxe_base_code_packet):efi_pxe_base_code_callback_status;cdecl;
    efi_pxe_base_code_callback_protocol=record
                                        Revision:qword;
                                        CallBack:efi_pxe_callback;
                                        end;
    Pefi_bis_protocol=^efi_bis_protocol;
    bis_application_handle=Pointer;
    efi_bis_version=record
                    Major,Minor:dword;
                    end;
    efi_bis_data=record
                 Length:dword;
                 data:Pbyte;
                 end; 
    Pefi_bis_data=^efi_bis_data;
    efi_bis_initialize=function (This:Pefi_bis_protocol;var AppHandle:bis_application_handle;var InterfaceVersion:efi_bis_version;TargetAddress:Pefi_bis_data):efi_status;cdecl;
    efi_bis_shutdown=function (This:Pefi_bis_protocol):efi_status;cdecl;
    efi_bis_free=function (AppHandle:bis_application_handle;ToFree:Pefi_bis_data):efi_status;cdecl;
    efi_bis_get_boot_object_authorization_certificate=function (AppHandle:bis_application_handle;var Certificate:Pefi_bis_data):efi_status;cdecl;
    efi_bis_get_boot_object_authorization_checkflag=function (AppHandle:bis_application_handle;var CheckIsRequired:boolean):efi_status;cdecl;
    efi_bis_get_boot_object_authorization_update_token=function (AppHandle:bis_application_handle;var UpdateIsToken:efi_bis_data):efi_status;cdecl;
    bis_cert_id=dword;
    bis_alg_id=word;
    efi_bis_signature_info=record
                           CertificateID:bis_cert_id;
                           AlgorithmID:bis_alg_id;
                           KeyLength:word;
                           end;
    Pefi_bis_signature_info=^efi_bis_signature_info;
    efi_bis_get_signature_info=function (AppHandle:bis_application_handle;var SignatureInfo:efi_bis_data):efi_status;cdecl;
    efi_bis_update_boot_object_authorization=function (AppHandle:bis_application_handle;RequestCredential:Pefi_bis_data;var NewUpdateToken:Pefi_bis_data):efi_status;cdecl;
    efi_bis_verify_boot_object=function (AppHandle:bis_application_handle;Credentials,DataObject:Pefi_bis_data;var IsVerified:boolean):efi_status;cdecl;
    efi_bis_verify_object_with_credential=function (AppHandle:bis_application_handle;Credentials,DataObject,SectionName,AuthorityCertificate:Pefi_bis_data;var IsVerified:boolean):efi_status;cdecl;
    efi_bis_protocol=record
                     Initialize:efi_bis_initialize;
                     Shutdown:efi_bis_shutdown;
                     Free:efi_bis_free;
                     GetBootObjectAuthorizationCertificate:efi_bis_get_boot_object_authorization_certificate;
                     GetBootObjectAuthorizationCheckflag:efi_bis_get_boot_object_authorization_checkflag;
                     GetBootObjectAuthorizationUpdateToken:efi_bis_get_boot_object_authorization_update_token;
                     GetSignatureInfo:efi_bis_get_signature_info;
                     UpdateBootObjectAuthorization:efi_bis_update_boot_object_authorization;
                     VerifyBootObject:efi_bis_verify_boot_object;
                     VerifyObjectWithCredential:efi_bis_verify_object_with_credential;
                     end;
    Pefi_http_boot_callback_protocol=^efi_http_boot_callback_protocol;
    efi_http_callback_datatype=(HttpBootDhcp4,HttpBootDhcp6,HttpBootHttpRequest,HttpBootHttpResponse,HttpBootHttpEntityBody,HttpBootTypeMax);
    efi_http_boot_callback=function (This:Pefi_http_boot_callback_protocol;DataType:efi_http_callback_datatype;Received:boolean;DataLength:dword;Data:Pointer):efi_status;cdecl;
    efi_http_boot_callback_protocol=record
                                    CallBack:efi_http_boot_callback;
                                    end;
    Pefi_managed_network_protocol=^efi_managed_network_protocol;
    efi_managed_network_config_data=record
                                    ReceivedQueueTimeoutValue:dword;
                                    TransmitQueueTimeoutValue:dword;
                                    ProtocolTypeFilter:word;
                                    EnableUniCastReceive:boolean;
                                    EnableMultiCastReceive:boolean;
                                    EnableBroadCastReceive:boolean;
                                    EnablePromiscuousReceive:boolean;
                                    FlushQueuesOnReset:boolean;
                                    EnableReceiveTimeStamps:boolean;
                                    DisableBackgroundPolling:boolean;
                                    end;
    Pefi_managed_network_config_data=^efi_managed_network_config_data;
    efi_managed_network_get_mode_data=function (This:Pefi_managed_network_protocol;var MnpConfigData:efi_managed_network_config_data;var SnpModeData:efi_simple_network_mode):efi_status;cdecl;
    efi_managed_network_configure=function (This:Pefi_managed_network_protocol;MnpConfigData:Pefi_managed_network_config_data):efi_status;cdecl;
    efi_managed_network_mcast_ip_to_mac=function (This:Pefi_managed_network_protocol;Ipv6Flag:boolean;IpAddress:Pefi_ip_address;var MacAddress:efi_mac_address):efi_status;cdecl;
    efi_managed_network_groups=function (This:Pefi_managed_network_protocol;JoinFlag:boolean;MacAddress:Pefi_mac_address):efi_status;cdecl;
    efi_managed_network_receive_data=record 
                                     TimeStamp:efi_time;
                                     RecycleEvent:efi_event;
                                     PacketLength:dword;
                                     HeaderLength:dword;
                                     AddressLength:dword;
                                     dataLength:dword;
                                     RoadCastFlag:boolean;
                                     MultiCastFlag:boolean;
                                     PromiscuousFlag:boolean;
                                     Protocol:word;
                                     DestinationAddress:Pointer;
                                     SourceAddress:Pointer;
                                     MediaHeader:Pointer;
                                     PacketData:Pointer;
                                     end;
    efi_managed_network_fragment_data=record
                                      FragmentLength:dword;
                                      FragmentBuffer:Pointer;
                                      end;
    efi_managed_network_transmit_data=record
                                      DestinationAddress:Pefi_mac_address;
                                      SourceAddress:Pefi_mac_address;
                                      ProtocolType:word;
                                      DataLength:dword;
                                      HeaderLength:word;
                                      FragmentCount:word;
                                      FragmentTable:array[1..1] of efi_managed_network_fragment_data;
                                      end;
    efi_managed_network_completion_token=record
                                         Event:efi_event;
                                         Status:efi_status;
                                         case boolean of
                                         True:(RxData:efi_managed_network_receive_data;);
                                         False:(TxData:efi_managed_network_transmit_data;);
                                         end;
    Pefi_managed_network_completion_token=^efi_managed_network_completion_token;
    efi_managed_network_transmit=function (This:Pefi_managed_network_protocol;Token:Pefi_managed_network_completion_token):efi_status;cdecl;
    efi_managed_network_receive=function (This:Pefi_managed_network_protocol;Token:Pefi_managed_network_completion_token):efi_status;cdecl;
    efi_managed_network_cancel=function (This:Pefi_managed_network_protocol;Token:Pefi_managed_network_completion_token):efi_status;cdecl;
    efi_managed_network_poll=function (This:Pefi_managed_network_protocol):efi_status;cdecl;
    efi_managed_network_protocol=record
                                 GetModeData:efi_managed_network_get_mode_data;
                                 Configure:efi_managed_network_configure;
                                 MCastIpToMac:efi_managed_network_mcast_ip_to_mac;
                                 Groups:efi_managed_network_groups;
                                 Transmit:efi_managed_network_transmit;
                                 Receive:efi_managed_network_receive;
                                 Cancel:efi_managed_network_cancel;
                                 Poll:efi_managed_network_poll;
                                 end;
    Pefi_bluetooth_hc_protocol=^efi_bluetooth_hc_protocol;
    efi_bluetooth_hc_send_command=function (This:Pefi_bluetooth_hc_protocol;var BufferSize:natuint;Buffer:Pointer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_hc_receive_event=function (This:Pefi_bluetooth_hc_protocol;var BufferSize:natuint;var Buffer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_hc_async_func_callback=function (Data:Pointer;DataLength:natuint;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_hc_async_receive_event=function (This:Pefi_bluetooth_hc_protocol;IsNewTransfer:boolean;PollingInterval:natuint;DataLength:natuint;CallBack:efi_bluetooth_hc_async_func_callback;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_hc_send_acl_data=function (This:Pefi_bluetooth_hc_protocol;var BufferSize:natuint;Buffer:Pointer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_hc_receive_acl_data=function (This:Pefi_bluetooth_hc_protocol;var BufferSize:natuint;var Buffer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_hc_async_receive_acl_data=function (This:Pefi_bluetooth_hc_protocol;IsNewTransfer:boolean;PollingInterval:natuint;DataLength:natuint;CallBack:efi_bluetooth_hc_async_func_callback;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_hc_send_sco_data=function (This:Pefi_bluetooth_hc_protocol;var BufferSize:natuint;Buffer:Pointer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_hc_receive_sco_data=function (This:Pefi_bluetooth_hc_protocol;var BufferSize:natuint;var Buffer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_hc_async_receive_sco_data=function (This:Pefi_bluetooth_hc_protocol;IsNewTransfer:boolean;PollingInterval:natuint;DataLength:natuint;CallBack:efi_bluetooth_hc_async_func_callback;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_hc_protocol=record
                              SendCommand:efi_bluetooth_hc_send_command;
                              ReceiveEvent:efi_bluetooth_hc_receive_event;
                              AsyncReceiveEvent:efi_bluetooth_hc_async_receive_event;
                              SendACLData:efi_bluetooth_hc_send_acl_data;
                              ReceiveACLData:efi_bluetooth_hc_receive_acl_data;
                              AsyncReceiveACLData:efi_bluetooth_hc_async_receive_acl_data;
                              SendSCOData:efi_bluetooth_hc_send_sco_data;
                              ReceiveSCOData:efi_bluetooth_hc_receive_sco_data;
                              AsyncReceiveSCOData:efi_bluetooth_hc_async_receive_sco_data;
                              end;
    Pefi_bluetooth_io_protocol=^efi_bluetooth_io_protocol;
    bluetooth_address=record
                      Address:array[1..6] of byte;
                      end;
    Pbluetooth_address=^bluetooth_address;
    bluetooth_class_of_device=bitpacked record
                              FormatType:0..3;
                              MinorDeviceClass:0..63;
                              MajorDeviceClass:0..31;
                              MajorServiceClass:0..2047;
                              end;
    efi_bluetooth_device_info=record
                              Version:dword;
                              bd_addr:bluetooth_address;
                              PageScanReptitionMode:byte;
                              ClassDevice:bluetooth_class_of_device;
                              ClockOffset:word;
                              RSSI:byte;
                              ExtendedInquiryResponse:array[1..240] of byte;
                              end;
    efi_bluetooth_io_get_device_info=function (This:Pefi_bluetooth_io_protocol;var DeviceInfoSize:natuint;var DeviceInfo:Pointer):efi_status;cdecl;
    efi_bluetooth_io_get_sdp_info=function (This:Pefi_bluetooth_io_protocol;var SdpInfoSize:natuint;var SdpInfo:Pointer):efi_status;cdecl;
    efi_bluetooth_io_l2cap_raw_send=function (This:Pefi_bluetooth_io_protocol;var BufferSize:natuint;Buffer:Pointer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_io_l2cap_raw_receive=function (This:Pefi_bluetooth_io_protocol;var BufferSize:natuint;var Buffer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_io_async_func_callback=function (ChannelID:word;Data:Pointer;DataLength:natuint;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_io_l2cap_raw_async_receive=function (This:Pefi_bluetooth_io_protocol;IsNewTransfer:boolean;PollingInterval,DataLength:natuint;CallBack:efi_bluetooth_io_async_func_callback;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_io_l2cap_send=function (This:Pefi_bluetooth_io_protocol;Handle:efi_handle;var BufferSize:natuint;Buffer:Pointer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_io_l2cap_receive=function (This:Pefi_bluetooth_io_protocol;Handle:efi_handle;var BufferSize:natuint;var Buffer:Pointer;Timeout:natuint):efi_status;cdecl;
    efi_bluetooth_io_channel_service_callback=function (Data:Pointer;DataLength:natuint;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_io_l2cap_async_receive=function (This:Pefi_bluetooth_io_protocol;Handle:efi_handle;CallBack:efi_bluetooth_io_channel_service_callback;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_io_l2cap_connect=function (This:Pefi_bluetooth_io_protocol;var Handle:efi_handle;Psm,Mtu:word;Callback:efi_bluetooth_io_channel_service_callback;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_io_l2cap_disconnect=function (This:Pefi_bluetooth_io_protocol;Handle:efi_handle):efi_status;cdecl;
    efi_bluetooth_io_l2cap_register_service=function (This:Pefi_bluetooth_io_protocol;var Handle:efi_handle;Psm,mtu:word;CallBack:efi_bluetooth_io_channel_service_callback;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_io_protocol=record
                              GetDeviceInfo:efi_bluetooth_io_get_device_info;
                              GetSdpinfo:efi_bluetooth_io_get_sdp_info;
                              L2CapRawSend:efi_bluetooth_io_l2cap_raw_send;
                              L2CapRawReceive:efi_bluetooth_io_l2cap_raw_receive;
                              L2CapRawAsyncReceive:efi_bluetooth_io_l2cap_raw_async_receive;
                              L2CapSend:efi_bluetooth_io_l2cap_send;
                              L2CapReceive:efi_bluetooth_io_l2cap_receive;
                              L2CapAsyncReceive:efi_bluetooth_io_l2cap_async_receive;
                              L2CapConnect:efi_bluetooth_io_l2cap_connect;
                              L2CapDisconnect:efi_bluetooth_io_l2cap_disconnect;
                              L2CapRegisterService:efi_bluetooth_io_l2cap_register_service;
                              end;
    Pefi_bluetooth_config_protocol=^efi_bluetooth_config_protocol;
    efi_bluetooth_config_init=function (This:Pefi_bluetooth_config_protocol):efi_status;cdecl;
    efi_bluetooth_scan_callback_information=record
                                            BDAddr:bluetooth_address;
                                            RemoteDeviceState:byte;
                                            ClassOfDevice:bluetooth_class_of_device;
                                            RemoteDeviceName:array[1..bluetooth_hci_command_local_readable_name_max_size] of byte;
                                            end;
    Pefi_bluetooth_scan_callback_information=^efi_bluetooth_scan_callback_information;
    efi_bluetooth_config_scan_callback_function=function (This:Pefi_bluetooth_config_protocol;Context:Pointer;CallBackInfo:Pefi_bluetooth_scan_callback_information):efi_status;cdecl;
    efi_bluetooth_config_scan=function (This:Pefi_bluetooth_config_protocol;ReScan:boolean;ScanType:byte;CallBack:efi_bluetooth_config_scan_callback_function;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_config_connect=function (This:Pefi_bluetooth_config_protocol;bd_addr:bluetooth_address):efi_status;cdecl;
    efi_bluetooth_config_disconnect=function (This:Pefi_bluetooth_config_protocol;bd_addr:bluetooth_address;Reason:Pbyte):efi_status;cdecl;
    efi_bluetooth_config_data_type=(EfiBlueToothConfigDataTypeDeviceName,EfiBlueToothConfigDataTypeClassOfDevice,EfiBlueToothConfigDataRemoteDeviceState,EfiBlueToothConfigDataTypeSdpInfo,EfiBlueToothConfigDataTypeBDADDR,EfiBlueToothConfigDataTypeDiscoverable,EfiBlueToothConfigDataTypeControllerStoredPairedDeviceList,EfiBlueToothConfigDataTypeAvailableDeviceList,EfiBlueToothConfigDataTypeRandomAddress,EfiBlueToothConfigDataTypeRSSI,EfiBlueToothConfigDataTypeAdvertisementData,EfiBlueToothConfigDataTypeIoCapability,EfiBlueToothConfigDataTypeOOBDataFlag,EfiBlueToothConfigDataTypeKeySize,EfiBlueToothConfigDataTypeEncKeySize,EfiBlueToothConfigDataTypeMax);
    efi_bluetooth_config_remote_device_state_type=dword;
    efi_bluetooth_config_get_data=function (This:Pefi_bluetooth_config_protocol;DataType:efi_bluetooth_config_data_type;var DataSize:natuint;var Data):efi_status;cdecl;
    efi_bluetooth_config_set_data=function (This:Pefi_bluetooth_config_protocol;DataType:efi_bluetooth_config_data_type;DataSize:natuint;Data:Pointer):efi_status;cdecl;
    efi_bluetooth_config_get_remote_data=function (This:Pefi_bluetooth_config_protocol;DataType:efi_bluetooth_config_data_type;BDAddr:bluetooth_address;var DataSize:natuint;var Data):efi_status;cdecl;
    efi_bluetooth_pin_callback_type=(EfiBluetoothCallBackTypeUserPasskeyNotification,EfiBluetoothCallBackTypeUserConfirmationRequest,EfiBluetoothCallBackTypeOOBDataRequest,EfiBluetoothCallBackTypePinCodeRequest,EfiBluetoothCallBackTypeMax);
    efi_bluetooth_config_register_pin_callback_function=function (This:Pefi_bluetooth_config_protocol;Context:Pointer;Callbacktype:efi_bluetooth_pin_callback_type;InputBuffer:Pointer;InputBufferSize:natuint;var OutputBuffer:Pointer;var OutputBufferSize:natuint):efi_status;
    efi_bluetooth_config_register_pin_callback=function (This:Pefi_bluetooth_config_protocol;Callback:efi_bluetooth_config_register_pin_callback_function;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_hci_link_key_array=array[1..bluetooth_hci_link_key_size] of byte;
    efi_bluetooth_config_register_get_link_key_callback_function=function (This:Pefi_bluetooth_config_protocol;Context:Pointer;BDAddr:Pbluetooth_address;var Linkkey:efi_bluetooth_hci_link_key_array):efi_status;cdecl;
    efi_bluetooth_config_register_get_link_key_callback=function (This:Pefi_bluetooth_config_protocol;CallBack:efi_bluetooth_config_register_get_link_key_callback_function;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_config_register_set_link_key_callback_function=function (This:Pefi_bluetooth_config_protocol;Context:Pointer;BDAddr:Pbluetooth_address;Linkkey:efi_bluetooth_hci_link_key_array):efi_status;cdecl;
    efi_bluetooth_config_register_set_link_key_callback=function (This:Pefi_bluetooth_config_protocol;Callback:efi_bluetooth_config_register_set_link_key_callback_function;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_connect_complete_callback_type=(EfiBluetoothConnCallbackTypeDisconnected,EfiBluetoothConnCallbackTypeConnected,EfiBluetoothConnCallbackTypeAuthenticated,EfiBluetoothConnCallbackTypeEncrypted);
    efi_bluetooth_config_register_connect_complete_callback_function=function (This:Pefi_bluetooth_config_protocol;Context:Pointer;CallBackType:efi_bluetooth_connect_complete_callback_type;BDAddr:Pbluetooth_address;InputBuffer:Pointer;InputBufferSize:natuint):efi_status;cdecl;
    efi_bluetooth_config_register_connect_complete_callback=function (This:Pefi_bluetooth_config_protocol;Callback:efi_bluetooth_config_register_connect_complete_callback_function;Context:Pointer):efi_status;cdecl;
    efi_bluetooth_config_protocol=record
                                  Init:efi_bluetooth_config_init;
                                  Scan:efi_bluetooth_config_scan;
                                  Connect:efi_bluetooth_config_connect;
                                  Disconnect:efi_bluetooth_config_disconnect;
                                  GetData:efi_bluetooth_config_get_data;
                                  SetData:efi_bluetooth_config_set_data;
                                  GetRemoteData:efi_bluetooth_config_get_remote_data;
                                  RegisterPinCallBack:efi_bluetooth_config_register_pin_callback;
                                  RegisterGetLinkKeyCallBack:efi_bluetooth_config_register_get_link_key_callback;
                                  RegisterSetLinkKeyCallBack:efi_bluetooth_config_register_set_link_key_callback;
                                  RegisterLinkConnectCompleteCallBack:efi_bluetooth_config_register_connect_complete_callback;
                                  end;
    
    Pefi_mp_services_protocol=^efi_mp_services_protocol;
    efi_mp_services_get_number_of_processors=function (This:Pefi_mp_services_protocol;var NumberOfProcessors:natuint;var NumberOfEnabledProcessors:natuint):efi_status;cdecl;
    efi_cpu_physical_location=record
                              Package,Core,Thread:dword;
                              end;
    efi_cpu_physical_location2=record
                               Package,Module,Tile,Die,Core,Thread:dword;
                               end;
    extended_processor_information=packed record
                                   Location2:efi_cpu_physical_location2;
                                   end;
    efi_processor_information=record
                              ProcessorId:qword;
                              StatusFlag:dword;
                              Location:efi_cpu_physical_location;
                              ExtendedInformation:extended_processor_information;
                              end;
    efi_mp_services_get_processor_info=function (This:Pefi_mp_services_protocol;ProcessorNumber:natuint;var ProcessorInfoBuffer:efi_processor_information):efi_status;cdecl;
    efi_ap_procedure=procedure(ProcedureArgument:Pointer);cdecl;
    efi_mp_services_startup_all_aps=function (This:Pefi_mp_services_protocol;efiProcedure:efi_ap_procedure;SingleThread:boolean;WaitEvent:efi_event;TimeoutInMicroSeconds:natuint;ProcedureArgument:Pointer;var FailedCpuList:Pnatuint):efi_status;cdecl;
    efi_mp_services_startup_this_ap=function (This:Pefi_mp_services_protocol;efiProcedure:efi_ap_procedure;ProcessorNumber:natuint;WaitEvent:efi_event;TimeoutInMicroSeconds:natuint;ProcedureArgument:Pointer;var Finished:boolean):efi_status;cdecl;
    efi_mp_services_switch_bsp=function (This:Pefi_mp_services_protocol;ProcessorNumber:natuint;EnableOldBSP:boolean):efi_status;cdecl;
    efi_mp_services_enable_disable_ap=function (This:Pefi_mp_services_protocol;ProcessorNumber:natuint;EnableAP:boolean;HealthFlag:Pdword):efi_status;cdecl;
    efi_mp_services_whoami=function (This:Pefi_mp_services_protocol;var ProcessorNumber:natuint):efi_status;cdecl;
    efi_mp_services_protocol=record 
                             GetNumberOfProcessors:efi_mp_services_get_number_of_processors;
                             GetProcessorInfo:efi_mp_services_get_processor_info;
                             StartupAllAPs:efi_mp_services_startup_all_aps;
                             StartupThisAP:efi_mp_services_startup_this_ap;
                             SwitchBSP:efi_mp_services_switch_bsp;
                             EnableDisableAP:efi_mp_services_enable_disable_ap;
                             WhoAmI:efi_mp_services_whoami;
                             end;
{User Defined Types}
    efi_file_system_list=record
                         file_system_content:^Pefi_simple_file_system_protocol;
                         file_system_count:natuint;
                         end;
    efi_file_system_list_ext=record
                         fsrcontent:^Pefi_simple_file_system_protocol;
                         fsrcount:natuint;
                         fsrwcontent:^Pefi_simple_file_system_protocol;
                         fsrwcount:natuint;
                         end;
    efi_disk_list=record
                  disk_content:^Pefi_disk_io_protocol;
                  disk_block_content:^Pefi_block_io_protocol;
                  disk_count:natuint;
                  end;
    efi_manual_operation_list=record
                              size:array[1..128] of natuint;
                              count:byte;
                              end;
    efi_manual_operation_lists_list=record
                                    content:^efi_manual_operation_list;
                                    count:natuint;
                                    end;
    efi_partition_entry_list=record
                             epe_content:array[1..128] of efi_partition_entry;
                             epe_count:byte;
                             end; 
    efi_list_data=record
                  efi_list_pos:^natuint;
                  efi_list_len:^natuint;
                  efi_list_count:natuint;
                  end;
    efi_pointer_list=record
                     pointer_item:^Pefi_simple_pointer_protocol;
                     pointer_count:natuint;
                     end;
    efi_pointer_list_state=record
                      mousex,mousey,mousez:dword;
                      leftbutton,rightbutton:boolean;
                      end;
    efi_absolute_pointer_list=record
                              pointer_item:^Pefi_absolute_pointer_protocol;
                              pointer_count:natuint;
                              end;
    efi_absolute_pointer_list_state=record
                                    mousex,mousey,mousez:qword;
                                    ActiveButton:dword;
                                    end;
    efi_graphics_list=record
                      graphics_item:^Pefi_graphics_output_protocol;
                      graphics_count:natuint;
                      end;
    efi_processor_list=record
                       processor_item:^Pefi_mp_services_protocol;
                       processor_number:^natuint;
                       processor_bootindex:^natuint;
                       processor_count:natuint;
                       end;
{User Defined End}
const unused_entry_guid:efi_guid=(data1:$00000000;data2:$0000;data3:$0000;data4:($00,$00,$00,$00,$00,$00,$00,$00));
      efi_system_partition_guid:efi_guid=(data1:$C12A7328;data2:$F81F;data3:$11D2;data4:($BA,$4B,$00,$A0,$C9,$3E,$C9,$3B));
      partition_containing_a_legacy_mbr_guid:efi_guid=(data1:$024DEE41;data2:$33E7;data3:$11D3;data4:($9D,$69,$00,$08,$C7,$81,$F3,$9F));
      system_console_restart_guid:efi_guid=(data1:$C14A7398;data2:$2819;data3:$4DF2;data4:($BA,$4F,$00,$A0,$C4,$3F,$C9,$4A));
      system_graphics_restart_guid:efi_guid=(data1:$C34F9328;data2:$2EE9;data3:$41F2;data4:($AE,$4F,$00,$A0,$C5,$3F,$C9,$4A));
      evt_timer:dword=$80000000;
      evt_runtime:dword=$40000000;
      evt_notify_wait:dword=$00000100;
      evt_notify_signal:dword=$00000200;
      evt_signal_exit_boot_services=$00000201;
      evt_signal_virtual_address_change=$60000202;
      tpl_application=4;
      tpl_callback=8;
      tpl_notify=16;
      tpl_high_level=31;
      efi_loaded_image_protocol_guid:efi_guid=(data1:$5B1B31A1;data2:$9562;data3:$11D2;data4:($8E,$3F,$00,$A0,$C9,$69,$72,$3B));
      efi_loaded_image_device_path_protocol_guid:efi_guid=(data1:$BC62157E;data2:$3E33;data3:$4FEC;data4:($99,$20,$2D,$3B,$36,$D7,$50,$DF));
      efi_device_path_protocol_guid:efi_guid=(data1:$09576E91;data2:$6D3F;data3:$11D2;data4:($8E,$39,$00,$A0,$C9,$69,$72,$3B));
      efi_device_path_utilities_protocol_guid:efi_guid=(data1:$0379BE4E;data2:$D706;data3:$437D;data4:($B0,$37,$ED,$B8,$2F,$B7,$72,$A4));
      efi_device_path_to_text_protocol_guid:efi_guid=(data1:$8B843E20;data2:$8132;data3:$4852;data4:($90,$CC,$55,$1A,$4E,$4A,$7F,$1C));
      efi_device_path_from_text_protocol_guid:efi_guid=(data1:$05C99A21;data2:$C70F;data3:$4AD2;data4:($8A,$5F,$35,$DF,$33,$43,$F5,$1E));
      efi_driver_binding_protocol_guid:efi_guid=(data1:$18A031AB;data2:$B443;data3:$4D1A;data4:($A5,$C0,$0C,$09,$26,$1E,$9F,$71));
      efi_platform_driver_override_protocol_guid:efi_guid=(data1:$6B30C738;data2:$A391;data3:$11D4;data4:($9A,$3B,$00,$90,$27,$3F,$C1,$4D));
      efi_bus_specific_driver_override_protocol_guid:efi_guid=(data1:$3BC1B285;data2:$8A15;data3:$4A82;data4:($AA,$BF,$4D,$7D,$13,$FB,$32,$65));
      efi_driver_diagnostics_protocol_guid:efi_guid=(data1:$4D330321;data2:$025F;data3:$4AAC;data4:($90,$D8,$5E,$D9,$00,$17,$3B,$63));
      efi_component_name2_protocol_guid:efi_guid=(data1:$6A7A5CFF;data2:$E8D9;data3:$4F70;data4:($BA,$DA,$75,$AB,$30,$25,$CE,$14));
      efi_platform_to_driver_configuration_protocol_guid:efi_guid=(data1:$642CD590;data2:$8059;data3:$4C0A;data4:($A9,$58,$C5,$EC,$07,$D2,$3C,$4B));
      efi_driver_supported_efi_version_protocol_guid:efi_guid=(data1:$5C198761;data2:$16A8;data3:$4E69;data4:($97,$2C,$89,$D6,$79,$54,$F8,$1D));
      efi_driver_family_override_protocol_guid:efi_guid=(data1:$B1EE129E;data2:$DA36;data3:$4181;data4:($91,$F8,$04,$A4,$92,$37,$66,$A7));
      efi_driver_health_protocol_guid:efi_guid=(data1:$2A534210;data2:$9280;data3:$41D8;data4:($AE,$79,$CA,$DA,$01,$A2,$B1,$27));
      efi_adapter_information_protocol_guid:efi_guid=(data1:$E5DD1403;data2:$D622;data3:$C24E;data4:($84,$88,$C7,$1B,$17,$F5,$E8,$02));
      efi_adapter_info_media_state_guid:efi_guid=(data1:$D7C74207;data2:$A831;data3:$4A26;data4:($B1,$F5,$D1,$93,$06,$5C,$E8,$B6));
      efi_adapter_info_network_boot_guid:efi_guid=(data1:$1FBD2690;data2:$4130;data3:$41E5;data4:($94,$AC,$D2,$CF,$03,$7F,$B3,$7C));
      efi_adapter_info_san_mac_address_guid:efi_guid=(data1:$114DA5EF;data2:$2CF1;data3:$4E12;data4:($9B,$BB,$C4,$70,$B5,$52,$05,$D9));
      efi_adapter_info_undi_ipv6_support_guid:efi_guid=(data1:$4BD56BE3;data2:$4975;data3:$4D8A;data4:($A0,$AD,$C4,$91,$20,$4B,$5D,$4D));
      efi_adapter_info_media_type_guid:efi_guid=(data1:$8484472F;data2:$71EC;data3:$411A;data4:($B3,$9C,$62,$CD,$94,$D9,$91,$6E));
      efi_adapter_info_cdat_type_guid:efi_guid=(data1:$77AF24D1;data2:$B6F0;data3:$42B9;data4:($83,$F5,$8F,$E6,$E8,$3E,$B6,$F0));
      efi_simple_text_input_ex_protocol_guid:efi_guid=(data1:$DD9E7534;data2:$7762;data3:$4698;data4:($8C,$14,$F5,$85,$17,$A6,$25,$AA));
      efi_simple_pointer_protocol_guid:efi_guid=(data1:$31878C87;data2:$0B75;data3:$11D5;data4:($9A,$4F,$00,$90,$27,$3F,$C1,$4D));
      efi_absolute_pointer_protocol_guid:efi_guid=(data1:$8D59D32B;data2:$C655;data3:$4AE9;data4:($9B,$15,$F2,$59,$04,$99,$2A,$43));
      efi_serial_to_protocol_guid:efi_guid=(data1:$BB25CF6F;data2:$F1D4;data3:$11D2;data4:($9A,$0C,$00,$90,$27,$3F,$C1,$FD));
      efi_serial_terminal_device_type_guid:efi_guid=(data1:$6AD9A60F;data2:$5815;data3:$4C7C;data4:($8A,$10,$50,$53,$D2,$BF,$7A,$1B));
      efi_graphics_output_protocol_guid:efi_guid=(data1:$9042A9DE;data2:$23DC;data3:$4A38;data4:($96,$FB,$7A,$DE,$D0,$80,$51,$6A));
      efi_load_file_protocol_guid:efi_guid=(data1:$56EC3091;data2:$954C;data3:$11D2;data4:($8E,$3F,$00,$A0,$C9,$69,$72,$3B));
      efi_load_file2_protocol_guid:efi_guid=(data1:$4006C0C1;data2:$FCB3;data3:$403E;data4:($99,$6D,$4A,$6C,$87,$24,$E0,$6D));
      efi_simple_file_system_protocol_guid:efi_guid=(data1:$964E5B22;data2:$6459;data3:$11D2;data4:($8E,$39,$00,$A0,$C9,$69,$72,$3B));
      efi_file_info_id:efi_guid=(data1:$09576E92;data2:$6D3F;data3:$11D2;data4:($8E,$39,$00,$A0,$C9,$69,$72,$3B));
      efi_file_system_info_id:efi_guid=(data1:$09576E93;data2:$6D3F;data3:$11D2;data4:($8E,$39,$00,$A0,$C9,$69,$72,$3B));
      efi_file_system_volume_label_id:efi_guid=(data1:$DB47D7D3;data2:$FE81;data3:$11D3;data4:($9A,$35,$0,$90,$27,$3F,$C1,$4D));
      efi_tape_to_protocol_guid:efi_guid=(data1:$1E93E633;data2:$D65A;data3:$459E;data4:($AB,$84,$93,$D9,$EC,$26,$6D,$18));
      efi_disk_io_protocol_guid:efi_guid=(data1:$CE345171;data2:$BA0B;data3:$11D2;data4:($8E,$4F,$00,$A0,$C9,$69,$72,$3B));
      efi_disk_io2_protocol_guid:efi_guid=(data1:$151C8EAE;data2:$7F2C;data3:$472C;data4:($9E,$54,$98,$28,$19,$4F,$6A,$88));
      efi_block_io_protocol_guid:efi_guid=(data1:$964E5B21;data2:$6459;data3:$11D2;data4:($8E,$39,$00,$A0,$C9,$69,$72,$3B));
      efi_block_io2_protocol_guid:efi_guid=(data1:$A77B2472;data2:$E282;data3:$4E9F;data4:($A2,$45,$C2,$C0,$E2,$7B,$BC,$C1));
      efi_block_io_crypto_protocol_guid:efi_guid=(data1:$A00490BA;data2:$3F1A;data3:$4B4C;data4:($AB,$90,$4F,$A9,$97,$26,$A1,$E8));
      efi_block_io_crypto_algo_guid_aes_xts:efi_guid=(data1:$2F87BA6A;data2:$5C04;data3:$4385;data4:($A7,$80,$F3,$BF,$78,$A9,$7B,$EC));
      efi_block_io_crypto_algo_guid_aes_cbc_microsoft_bitlocker:efi_guid=(data1:$689E4CB2;data2:$70BF;data3:$4CF3;data4:($88,$BB,$33,$B3,$18,$26,$86,$70));
      efi_erase_block_protocol_guid:efi_guid=(data1:$95A9A93E;data2:$A86E;data3:$4926;data4:($AA,$EF,$99,$18,$E7,$72,$D9,$87));
      efi_ata_pass_thru_protocol_guid:efi_guid=(data1:$1D3DE7F0;data2:$0807;data3:$424F;data4:($AA,$69,$11,$A5,$4E,$19,$A4,$6F));
      efi_storage_security_command_protocol_guid:efi_guid=(data1:$C88B0B6D;data2:$0DFC;data3:$49A7;data4:($9C,$B4,$49,$07,$4B,$4C,$3A,$78));
      efi_nvm_express_pass_thru_protocol_guid:efi_guid=(data1:$52C78312;data2:$8EDC;data3:$4233;data4:($98,$F2,$1A,$1A,$A5,$E3,$88,$A5));
      efi_sd_mmc_pass_thru_protocol_guid:efi_guid=(data1:$716EF0D9;data2:$FF83;data3:$4F69;data4:($81,$E9,$51,$8B,$D3,$9A,$8E,$70));
      efi_ram_disk_protocol_guid:efi_guid=(data1:$AB38A0BF;data2:$6873;data3:$44A9;data4:($87,$E6,$D4,$EB,$56,$14,$84,$49));
      efi_partition_info_protocol_guid:efi_guid=(data1:$8CF2F62C;data2:$BC9B;data3:$4821;data4:($80,$8D,$EC,$9E,$C4,$21,$A1,$A0));
      efi_nvdimm_label_protocol_guid:efi_guid=(data1:$D40B6B80;data2:$97D5;data3:$4282;data4:($BB,$1D,$22,$3A,$16,$91,$80,$58));
      efi_ufs_device_config_guid:efi_guid=(data1:$B81BFAB0;data2:$0EB3;data3:$4CF9;data4:($84,$65,$7F,$A9,$86,$36,$16,$64));
      efi_pci_root_bridge_io_protocol_guid:efi_guid=(data1:$2F707EBB;data2:$4A1A;data3:$11D4;data4:($9A,$38,$00,$90,$27,$3F,$C1,$4D));
      efi_pci_io_protocol_guid:efi_guid=(data1:$4CF5B200;data2:$68B8;data3:$4CA5;data4:($9E,$EC,$B2,$3E,$3F,$50,$02,$9A));
      efi_scsi_io_protocol_guid:efi_guid=(data1:$932F4716;data2:$2362;data3:$4002;data4:($80,$3E,$3C,$D5,$4B,$13,$8F,$85));
      efi_ext_scsi_pass_thru_protocol_guid:efi_guid=(data1:$143B7362;data2:$B81B;data3:$4CB7;data4:($AB,$D3,$B6,$25,$A5,$B9,$BF,$FE));
      efi_iscsi_initiator_name_protocol_guid:efi_guid=(data1:$59324945;data2:$EC44;data3:$4C0D;data4:($B1,$CD,$9D,$B1,$39,$DF,$07,$0C));
      efi_usb_io_protocol_guid:efi_guid=(data1:$2B2F6806;data2:$0CD2;data3:$44CF;data4:($8E,$8B,$BB,$A2,$0B,$1B,$5B,$75));
      efi_usb2_hc_protocol_guid:efi_guid=(data1:$3E745226;data2:$9818;data3:$45B6;data4:($A2,$AC,$D7,$CD,$0E,$8B,$A2,$BC));
      efi_usbfn_io_protocol_guid:efi_guid=(data1:$32D2963A;data2:$FE5D;data3:$4F30;data4:($B6,$33,$6E,$5D,$C5,$58,$03,$CC));
      efi_debug_support_protocol_guid:efi_guid=(data1:$2755590C;data2:$6F3C;data3:$42FA;data4:($9E,$A4,$A3,$BA,$54,$3C,$DA,$25));
      efi_debugport_protocol_guid:efi_guid=(data1:$EBA4E8D2;data2:$3858;data3:$41EC;data4:($A2,$81,$26,$47,$BA,$96,$60,$D0));
      efi_decompress_protocol_guid:efi_guid=(data1:$D8117CFE;data2:$94A6;data3:$11D4;data4:($9A,$3A,$00,$90,$27,$3F,$C1,$4D));
      efi_acpi_table_protocol_guid:efi_guid=(data1:$FFE06BDD;data2:$6107;data3:$46A6;data4:($7B,$B2,$5A,$9C,$7E,$C5,$27,$5C));
      efi_unicode_collation_protocol_guid:efi_guid=(data1:$A4C751FC;data2:$23AE;data3:$4C3E;data4:($92,$E9,$49,$64,$CF,$63,$F3,$49));
      efi_regular_expression_protocol_guid:efi_guid=(data1:$B3F79D9A;data2:$436C;data3:$DC11;data4:($B0,$52,$CD,$85,$DF,$52,$4C,$E6));
      efi_ebc_protocol_guid:efi_guid=(data1:$13AC6DD1;data2:$73D0;data3:$11D4;data4:($B0,$6B,$00,$AA,$00,$BD,$6D,$E7));
      efi_firmware_management_protocol_guid:efi_guid=(data1:$86C77A67;data2:$0B97;data3:$4633;data4:($A1,$87,$49,$10,$4D,$06,$85,$C7));
      efi_firmware_management_capsule_id_guid:efi_guid=(data1:$6DCBD5EB;data2:$E82B;data3:$4C44;data4:($BD,$A1,$71,$94,$19,$9A,$D9,$2A));
      efi_system_resource_table_guid:efi_guid=(data1:$B122A263;data2:$3661;data3:$4F68;data4:($99,$29,$78,$F8,$B0,$D6,$21,$80));
      efi_json_capsule_id_guid:efi_guid=(data1:$67D6F4CD;data2:$D6B8;data3:$4573;data4:($BF,$4A,$DE,$5E,$25,$2D,$61,$AE));
      efi_simple_network_protocol_guid:efi_guid=(data1:$A19832B9;data2:$AC25;data3:$11D3;data4:($9A,$2D,$00,$90,$27,$3F,$C1,$4D));
      efi_network_interface_identifier_protocol_guid:efi_guid=(data1:$1ACED566;data2:$75ED;data3:$4218;data4:($BC,$81,$76,$7F,$1F,$97,$7A,$89));
      efi_pxe_base_code_protocol_guid:efi_guid=(data1:$03C4E603;data2:$AC28;data3:$11D3;data4:($9A,$2D,$00,$90,$27,$3F,$C1,$4D));
      efi_pxe_base_code_callback_protocol_guid:efi_guid=(data1:$245DCA21;data2:$FB7B;data3:$11D3;data4:($8F,$01,$00,$A0,$C9,$69,$72,$3B));
      efi_bis_protocol_guid:efi_guid=(data1:$0B64AAB0;data2:$5429;data3:$11D4;data4:($98,$16,$00,$A0,$C9,$1F,$AD,$CF));
      efi_http_boot_callback_protocol_guid:efi_guid=(data1:$BA23B311;data2:$343D;data3:$11E6;data4:($91,$85,$58,$20,$B1,$D6,$52,$99));
      efi_managed_network_service_binding_protocol_guid:efi_guid=(data1:$F36FF770;data2:$A7E1;data3:$42CF;data4:($9E,$D2,$56,$F0,$F2,$71,$F4,$4C));
      efi_managed_network_protocol_guid:efi_guid=(data1:$7AB33A91;data2:$ACE5;data3:$4326;data4:($B5,$72,$E7,$EE,$33,$D3,$9F,$16));
      efi_bluetooth_hc_protocol_guid:efi_guid=(data1:$B3930571;data2:$BEBA;data3:$4FC5;data4:($92,$03,$94,$27,$24,$2E,$6A,$43));
      efi_bluetooth_io_service_binding_protocol:efi_guid=(data1:$388278D3;data2:$7B85;data3:$42F0;data4:($AB,$A9,$FB,$4B,$FD,$69,$F5,$AB));
      efi_bluetooth_io_protocol_guid:efi_guid=(data1:$467313DE;data2:$4E30;data3:$43F1;data4:($94,$3E,$32,$3F,$89,$84,$5D,$B5));
      efi_bluetooth_config_protocol_guid:efi_guid=(data1:$62960CF3;data2:$40FF;data3:$4263;data4:($A7,$7C,$D7,$DE,$BD,$19,$1B,$4B));
      efi_bluetooth_attribute_protocol_guid:efi_guid=(data1:$898890E9;data2:$84B2;data3:$4F3A;data4:($8C,$58,$D8,$57,$78,$13,$E0,$AC));
      efi_mp_services_protocol_guid:efi_guid=(data1:$3FDDA605;data2:$A76E;data3:$4F46;data4:($AD,$29,$12,$F4,$53,$1B,$3D,$08));
      efi_success=0;
      efi_load_error=1;
      efi_invaild_parameter=2;
      efi_unsupported=3;
      efi_bad_buffer_size=4;
      efi_buffer_too_small=5;
      efi_not_ready=6;
      efi_device_error=7;
      efi_write_protected=8;
      efi_out_of_resources=9;
      efi_volume_corrupted=10;
      efi_volume_full=11;
      efi_no_media=12;
      efi_media_changed=13;
      efi_not_found=14;
      efi_access_denied=15;
      efi_no_response=16;
      efi_no_mapping=17;
      efi_timeout=18;
      efi_not_started=19;
      efi_already_started=20;
      efi_aborted=21;
      efi_icmp_error=22;
      efi_tftp_error=23;
      efi_protocol_error=24;
      efi_incompatible_version=25;
      efi_security_violation=26;
      efi_crc_error:natint=27;
      efi_end_of_media=28;
      efi_end_of_file=31;
      efi_invaild_language=32;
      efi_compromised_data=33;
      efi_ip_address_conflict=34;
      efi_http_error=35;
      efi_warn_unknown_glyph=1;
      efi_warn_delete_failure=2;
      efi_warn_write_failure=3;
      efi_warn_buffer_too_small=4;
      efi_warn_stale_data=5;
      efi_warn_file_system=6;
      efi_warn_reset_required=7;
      efi_black=$0;
      efi_blue=$1;
      efi_green=$2;
      efi_cyan=$3;
      efi_red=$4;
      efi_magenta=$5;
      efi_brown=$6;
      efi_lightgrey=$7;
      efi_bright=$8;
      efi_darkgrey=$8;
      efi_lightblue=$9;
      efi_lightgreen=$A;
      efi_lightcyan=$B;
      efi_lightred=$C;
      efi_lightmagenta=$D;
      efi_yellow=$E;
      efi_white=$F;
      efi_bck_black=$0;
      efi_bck_blue=$1;
      efi_bck_green=$2;
      efi_bck_cyan=$3;
      efi_bck_red=$4;
      efi_bck_magenta=$5;
      efi_bck_brown=$6;
      efi_bck_lightgrey=$7;
      efi_shift_state_vaild=$80000000;
      efi_right_shift_pressed=$00000001;
      efi_left_shift_pressed=$00000002;
      efi_right_control_pressed=$00000004;
      efi_left_control_pressed=$00000008;
      efi_right_alt_pressed=$00000010;
      efi_left_alt_pressed=$00000020;
      efi_right_logo_pressed=$00000040;
      efi_left_logo_pressed=$00000080;
      efi_menu_key_pressed=$00000100;
      efi_sys_req_pressed=$00000200;
      efi_toggle_state_vaild=$80;
      efi_key_state_exposed=$40;
      efi_scroll_lock_active=$01;
      efi_num_lock_active=$02;
      efi_caps_lock_active=$04;
      efi_absp_supportsaltactive=$00000001;
      efi_absp_supportspressureasZ=$00000002;
      efi_absp_Touchactive=$00000001;
      efi_abs_AltActive=$00000002;
      efi_serial_clear_to_send=$0010;
      efi_serial_data_set_ready=$0020;
      efi_serial_ring_indicate=$0040;
      efi_serial_carrier_detect=$0080;
      efi_serial_request_to_send=$0002;
      efi_serial_data_terminal_ready=$0001;
      efi_serial_input_buffer_empty=$0100;
      efi_serial_output_buffer_empty=$0200;
      efi_serial_hardware_loopback_enable=$1000;
      efi_serial_software_loopback_enable=$2000;
      efi_serial_hardware_flow_control_enable=$4000;
      efi_simple_file_system_protocol_revision=$00010000;
      efi_file_protocol_revision=$00010000;
      efi_file_protocol2_revision=$00020000;
      efi_file_protocol_latest_revision=efi_file_protocol2_revision;
      efi_file_mode_read=$0000000000000001;
      efi_file_mode_write=$0000000000000002;
      efi_file_mode_create=$8000000000000000;
      efi_file_read_only=$0000000000000001;
      efi_file_hidden=$0000000000000002;
      efi_file_system=$0000000000000004;
      efi_file_reserved=$0000000000000008;
      efi_file_directory=$0000000000000010;
      efi_file_archive=$0000000000000020;
      efi_file_valid_attr=$0000000000000037;
      efi_disk_io_protocol_revision=$00010000;
      efi_disk_io2_protocol_revision=$00020000;
      efi_block_io_protocol_revision2:dword=$00020001;
      efi_block_io_protocol_revision3:dword=(2 shl 16) or 31;
      efi_block_io_crypto_index_any:qword=$FFFFFFFFFFFFFF;
      efi_erase_block_protocol_revision:dword=(2 shl 16) or 60;
      efi_ata_pass_thru_attributes_physical:word=$0001;
      efi_ata_pass_thru_attributes_logical:word=$0002;
      efi_ata_pass_thru_attributes_nonblockio:word=$0004;
      efi_ata_pass_thru_protocol_ata_hardware_reset:byte=$00;
      efi_ata_pass_thru_protocol_ata_software_reset:byte=$01;
      efi_ata_pass_thru_protocol_ata_non_data:byte=$02;
      efi_ata_pass_thru_protocol_pio_data_in:byte=$04;
      efi_ata_pass_thru_protocol_pio_data_out:byte=$05;
      efi_ata_pass_thru_protocol_dma:byte=$06;
      efi_ata_pass_thru_protocol_dma_queued:byte=$07;
      efi_ata_pass_thru_protocol_device_diagnostic:byte=$08;
      efi_ata_pass_thru_protocol_device_reset:byte=$09;
      efi_ata_pass_thru_protocol_umda_data_in:byte=$0A;
      efi_ata_pass_thru_protocol_umda_data_out:byte=$0B;
      efi_ata_pass_thru_protocol_fpdma:byte=$0C;
      efi_ata_pass_thru_protocol_return_response:byte=$FF;
      efi_ata_pass_thru_length_bytes:byte=$80;
      efi_ata_pass_thru_length_mask:byte=$70;
      efi_ata_pass_thru_length_no_data_transfer:byte=$00;
      efi_ata_pass_thru_length_features:byte=$10;
      efi_ata_pass_thru_length_sector_count:byte=$20;
      efi_ata_pass_thru_length_tpsiu:byte=$30;
      efi_ata_pass_thru_length_count:byte=$0F;
      efi_partition_info_protocol_revision:dword=$00010000;
      partition_type_other:byte=$00;
      partition_type_mbr:byte=$01;
      partition_type_gpt:byte=$02;
      efi_nvm_express_pass_thru_attributes_physical:word=$0001;
      efi_nvm_express_pass_thru_attributes_logical:word=$0002;
      efi_nvm_express_pass_thru_attributes_nonblockio:word=$0004;
      efi_nvm_express_pass_thru_attributes_cmd_set_nvm:word=$0008;
      cdw2_vaild:byte=$01;
      cdw3_vaild:byte=$02;
      cdw10_vaild:byte=$04;
      cdw11_vaild:byte=$08;
      cdw12_vaild:byte=$10;
      cdw13_vaild:byte=$20;
      cdw14_vaild:byte=$40;
      cdw15_vaild:byte=$80;   
      fs_signature:qword=$5D47291AD7E3F2B1;
      capsule_flags_persist_across_reset:dword=$00010000;
      capsule_flags_populate_system_table:dword=$00020000;
      capsule_flags_initiate_reset:dword=$00030000;
      efi_pci_attribute_isa_motherboard_io:dword=$0001;
      efi_pci_attribute_isa_io:dword=$0002;
      efi_pci_attribute_vga_palette_io:dword=$0004;
      efi_pci_attribute_vga_memory:dword=$0008;
      efi_pci_attribute_vga_io:dword=$0010;
      efi_pci_attribute_ide_primary_io:dword=$0020;
      efi_pci_attribute_ide_secordary_io:dword=$0040;
      efi_pci_attribute_memory_write_combine:dword=$0080;
      efi_pci_attribute_memory_cached:dword=$0800;
      efi_pci_attribute_memory_disable:dword=$1000;
      efi_pci_attribute_dual_address_cycle:dword=$8000;
      efi_pci_attribute_isa_io_16:dword=$10000;
      efi_pci_attribute_vga_palette_io_16:dword=$20000;
      efi_pci_attribute_vga_io_16:dword=$40000;
      efi_pci_io_attribute_isa_motherboard_io:dword=$0001;
      efi_pci_io_attribute_isa_io:dword=$0002;
      efi_pci_io_attribute_vga_palette_io:dword=$0004;
      efi_pci_io_attribute_vga_memory:dword=$0008;
      efi_pci_io_attribute_vga_io:dword=$0010;
      efi_pci_io_attribute_ide_primary_io:dword=$0020;
      efi_pci_io_attribute_ide_secondary_io:dword=$0040;
      efi_pci_io_attribute_memory_write_combine:dword=$0080;
      efi_pci_io_attribute_io:dword=$0100;
      efi_pci_io_attribute_memory:dword=$0200;
      efi_pci_io_attribute_bus_master:dword=$0400;
      efi_pci_io_attribute_memory_changed:dword=$0800;
      efi_pci_io_attribute_memory_disable:dword=$1000;
      efi_pci_io_attribute_embedded_device:dword=$2000;
      efi_pci_io_attribute_embedded_rom:dword=$4000;
      efi_pci_io_attribute_dual_address_cycle:dword=$8000;
      efi_pci_io_attribute_isa_to_16:dword=$10000;
      efi_pci_io_attribute_vga_palette_to_16:dword=$20000;
      efi_pci_io_attribute_vga_io_16:dword=$40000;
      efi_scsi_io_type_disk:byte=$00;
      efi_scsi_io_type_tape:byte=$01;
      efi_scsi_io_type_printer:byte=$02;
      efi_scsi_io_type_processor:byte=$03;
      efi_scsi_io_type_worm:byte=$04;
      efi_scsi_io_type_cdrom:byte=$05;
      efi_scsi_io_type_scanner:byte=$06;
      efi_scsi_io_type_optical:byte=$07;
      efi_scsi_io_type_mediumchanger:byte=$08;
      efi_scsi_io_type_communication:byte=$09;
      mfi_scsi_io_type_a:byte=$0A;
      mfi_scsi_io_type_b:byte=$0B;
      mfi_scsi_io_type_raid:byte=$0C;
      mfi_scsi_io_type_ses:byte=$0D;
      mfi_scsi_io_type_rbc:byte=$0E;
      mfi_scsi_io_type_ocrw:byte=$0F;
      mfi_scsi_io_type_bridge:byte=$10;
      mfi_scsi_io_type_osd:byte=$11;
      efi_scsi_io_type_reserved_low:byte=$12;
      efi_scsi_io_type_reserved_high:byte=$1E;
      efi_scsi_io_type_unknown:byte=$1F;
      target_max_bytes:byte=$10;
      efi_ext_scsi_pass_thru_attributes_physical:word=$0001;
      efi_ext_scsi_pass_thru_attributes_logical:word=$0002;
      efi_ext_scsi_pass_thru_attributes_nonblockio:word=$0004;
      efi_ext_scsi_data_direction_read=0;
      efi_ext_scsi_data_direction_write=1;
      efi_ext_scsi_data_direction_bidirectional=2;
      efi_ext_scsi_status_host_adapter_ok:byte=$00;
      efi_ext_scsi_status_host_adapter_timeout_command:byte=$09;
      efi_ext_scsi_status_host_adapter_timeout:byte=$0B;
      efi_ext_scsi_status_host_adapter_message_reject:byte=$0D;
      efi_ext_scsi_status_host_adapter_bus_reset:byte=$0E;
      efi_ext_scsi_status_host_adapter_parity_error:byte=$0F;
      efi_ext_scsi_status_host_adapter_require_sense_failed:byte=$10;
      efi_ext_scsi_status_host_adapter_selection_timeout:byte=$11;
      efi_ext_scsi_status_host_adapter_data_overrun_underrun:byte=$12;
      efi_ext_scsi_status_host_adapter_bus_free:byte=$13;
      efi_ext_scsi_status_host_adapter_phase_error:byte=$14;
      efi_ext_scsi_status_host_adapter_other:byte=$7F;
      efi_ext_scsi_status_target_good:byte=$00;
      efi_ext_scsi_status_target_check_condition:byte=$02;
      efi_ext_scsi_status_target_condition_met:byte=$04;
      efi_ext_scsi_status_target_busy:byte=$08;
      efi_ext_scsi_status_target_intermediate:byte=$10;
      efi_ext_scsi_status_target_intermediate_condition_met:byte=$14;
      efi_ext_scsi_status_target_reserved_conflict:byte=$18;
      efi_ext_scsi_status_target_task_set_full:byte=$28;
      efi_ext_scsi_status_target_aca_active:byte=$30;
      efi_ext_scsi_status_target_task_aborted:byte=$40;
      efi_usb_speed_full:byte=$00;
      efi_usb_speed_low:byte=$01;
      efi_usb_speed_high:byte=$02;
      efi_usb_speed_super:byte=$03;
      efi_usb_hc_reset_global:word=$0001;
      efi_usb_hc_reset_host_controller:word=$0002;
      efi_usb_hc_reset_global_with_debug:word=$0004;
      efi_usb_hc_reset_host_with_debug:word=$0008;
      efi_usbfn_io_protocol_revision:dword=$00010001;
      usb_port_stat_connection:word=$0001;
      usb_port_stat_enable:word=$0002;
      usb_port_stat_suspend:word=$0004;
      usb_port_stat_overcurrent:word=$0008;
      usb_port_stat_reset:word=$0010;
      usb_port_stat_power:word=$0100;
      usb_port_stat_low_speed:word=$0200;
      usb_port_stat_high_speed:word=$0400;
      usb_port_stat_super_speed:word=$0800;
      usb_port_stat_owner:word=$2000;
      usb_port_stat_c_connection:word=$0001;
      usb_port_stat_c_enable:word=$0002;
      usb_port_stat_c_suspend:word=$0004;
      usb_port_stat_c_overcurrent:word=$0008;
      usb_port_stat_c_reset:word=$0010;
      except_ebc_undefined=0;
      except_ebc_divide_error=1;
      except_ebc_debug=2;
      except_ebc_breakpoint=3;
      except_ebc_overflow=4;
      except_ebc_invaild_opcode=5;
      except_ebc_stack_fault=6;
      except_ebc_alignment_check=7;
      except_ebc_instruction_encoding=8;
      except_ebc_bad_break=9;
      except_ebc_single_step=10;
      except_ia32_divide_error=0;
      except_ia32_debug=1;
      except_ia32_nmi=2;
      except_ia32_breakpoint=3;
      except_ia32_overflow=4;
      except_ia32_bound=5;
      except_ia32_invaild_opcode=6;
      except_ia32_double_fault=8;
      except_ia32_invaild_tss=10;
      except_ia32_seg_not_present=11;
      except_ia32_stack_fault=12;
      except_ia32_gp_fault=13;
      except_ia32_page_fault=14;
      except_ia32_fp_error=16;
      except_ia32_alignment_check=17;
      except_ia32_machine_check=18;
      except_ia32_simd=19;
      except_x64_divide_error=0;
      except_x64_debug=1;
      except_x64_nmi=2;
      except_x64_breakpoint=3;
      except_x64_overflow=4;
      except_x64_bound=5;
      except_x64_invaild_opcode=6;
      except_x64_double_fault=8;
      except_x64_invaild_tss=10;
      except_x64_seg_not_present=11;
      except_x64_stack_fault=12;
      except_x64_gp_fault=13;
      except_x64_page_fault=14;
      except_x64_fp_error=16;
      except_x64_alignment_check=17;
      except_x64_machine_check=18;
      except_x64_simd=19;
      except_ipf_vhtp_translation=0;
      except_ipf_instruction_tlb=1;
      except_ipf_data_tlb=2;
      except_ipf_alt_instruction_tlb=3;
      except_ipf_alt_data_tlb=4;
      except_ipf_data_nested_tlb=5;
      except_ipf_instruction_key_missed=6;
      except_ipf_data_key_missed=7;
      except_ipf_dirty_bit=8;
      except_ipf_instruction_access_bit=9;
      except_ipf_data_access_bit=10;
      except_ipf_breakpoint=11;
      except_ipf_external_interrupt=12;
      except_ipf_page_not_present=20;
      except_ipf_key_permission=21;
      except_ipf_instruction_access_rights=22;
      except_ipf_data_access_rights=23;
      except_ipf_general_exception=24;
      except_ipf_disabled_fp_register=25;
      except_ipf_nat_consumption=26;
      except_ipf_speculation=27;
      except_ipf_debug=29;
      except_ipf_unaligned_reference=30;
      except_ipf_unsupported_data_reference=31;
      except_ipf_fp_fault=32;
      except_ipf_fp_trap=33;
      except_ipf_lower_privilege_transfer_trap=34;
      except_ipf_taken_branch=35;
      except_ipf_single_step=36;
      except_ipf_ia32_exception=45;
      except_ipf_ia32_intercept=46;
      except_ipf_ia32_interrupt=47;
      except_arm_reset=0;
      except_arm_undefined_instruction=1;
      except_arm_software_interrupt=2;
      except_arm_prefetch_abort=3;
      except_arm_data_abort=4;
      except_arm_reserved=5;
      except_arm_irq=6;
      except_arm_fiq=7;
      except_aarch64_synchronous_exceptions=0;
      except_aarch64_irq=1;
      except_aarch64_fiq=2;
      except_aarch64_serror=3;
      max_aarch64_exception=except_aarch64_serror;
      except_riscv_inst_misaligned=0;
      except_riscv_inst_access_fault=1;
      except_riscv_illegal_inst=2;
      except_riscv_breakpoint=3;
      except_riscv_load_address_misaligned=4;
      except_riscv_load_access_fault=5;
      except_riscv_store_amo_address_misaligned=6;
      except_riscv_store_amo_access_fault=7;
      except_riscv_env_call_from_umode=8;
      except_riscv_env_call_from_smode=9;
      except_riscv_env_call_from_mmode=11;
      except_riscv_inst_page_fault=12;
      except_riscv_load_page_fault=13;
      except_riscv_store_amo_page_fault=14;
      except_riscv_supervisor_software_int=1;
      except_riscv_machine_softwate_int=3;
      except_riscv_supervisor_timer_int=5;
      except_riscv_machine_timer_int=7;
      except_riscv_supervisor_external_int=9;
      except_riscv_machine_external_int=11;
      except_loongarch_int=0;
      except_loongarch_pil=1;
      except_loongarch_pis=2;
      except_loongarch_pif=3;
      except_loongarch_pme=4;
      except_loongarch_pnr=5;
      except_loongarch_pnx=6;
      except_loongarch_ppi=7;
      except_loongarch_ade=8;
      except_loongarch_ale=9;
      except_loongarch_bce=10;
      except_loongarch_sys=11;
      except_loongarch_brk=12;
      except_loongarch_ine=13;
      except_loongarch_ipe=14;
      except_loongarch_fpd=15;
      except_loongarch_sxd=16;
      except_loongarch_asxd=17;
      except_loongarch_fpe=18;
      except_loongarch_int_sip0=0;
      except_loongarch_int_sip1=1;
      except_loongarch_int_ip0=2;
      except_loongarch_int_ip1=3;
      except_loongarch_int_ip2=4;
      except_loongarch_int_ip3=5;
      except_loongarch_int_ip4=6;
      except_loongarch_int_ip5=7;
      except_loongarch_int_ip6=8;
      except_loongarch_int_ip7=9;
      except_loongarch_int_pmc=10;
      except_loongarch_int_timer=11;
      except_loongarch_int_ipi=12;
      max_loongarch_interrupt=14;
      image_attribute_image_updatable=$0000000000000001;
      image_attribute_reset_required=$0000000000000002;
      image_attribute_authentication_required=$0000000000000004;
      image_attribute_in_use=$0000000000000008;
      image_attribute_uefi_image=$0000000000000010;
      image_attribute_dependency=$0000000000000020;
      image_compability_check_supported=$0000000000000001;
      efi_firmware_image_descriptor_version=3;
      image_updatable_vaild=$00000001;
      image_updatable_invaild=$00000002;
      image_updatable_invaild_type=$00000004;
      image_updatable_invaild_old=$00000008;
      image_updatable_vaild_with_vendor_code=$00000010;
      package_attribute_version_updatable=$00000001;
      package_attribute_reset_required=$00000002;
      package_attribute_authentication_required=$00000004;
      esrt_fw_type_unknown=$00000000;
      esrt_fw_type_systemfirmware=$00000001;
      esrt_fw_type_devicefirmware=$00000002;
      esrt_fw_type_uefidriver=$00000003;
      last_attempt_status_success=$00000000;
      last_attempt_status_error_unsuccessful=$00000001;
      last_attempt_status_error_insufficent_resources=$00000002;
      last_attempt_status_error_incorrect_version=$00000003;
      last_attempt_status_error_invaild_format=$00000004;
      last_attempt_status_error_auth_error=$00000005;
      last_attempt_status_error_pwr_evt_ac=$00000006;
      last_attempt_status_error_pwr_evt_batt=$00000007;
      last_attempt_status_error_unsatisfied_dependencies=$00000008;
      last_attempt_status_error_unsuccessful_vendor_range_min=$00001000;
      last_attempt_status_error_unsuccessful_vendor_range_max=$00004000;
      efi_simple_network_protocol_revision=$00010000;
      efi_simple_network_receive_unicast:byte=$01;
      efi_simple_network_receive_multicast:byte=$02;
      efi_simple_network_receive_broadcast:byte=$04;
      efi_simple_network_receive_promiscuous:byte=$08;
      efi_simple_network_receive_promiscuous_multicast:byte=$10;
      efi_network_interface_identifier_protocol_revision=$00020000;
      efi_pxe_base_code_protocol_revision=$00010000;
      efi_pxe_base_code_boot_type_bootstrap=0;
      efi_pxe_base_code_boot_type_ms_winnt_ris=1;
      efi_pxe_base_code_boot_type_intel_lcm=2;
      efi_pxe_base_code_boot_type_dosundi=3;
      efi_pxe_base_code_boot_type_nec_esmpro=4;
      efi_pxe_base_code_boot_type_IBM_WsoD=5;
      efi_pxe_base_code_boot_type_IBM_LCCM=6;
      efi_pxe_base_code_boot_type_CA_unicenter_tng=7;
      efi_pxe_base_code_boot_type_HP_openview=8;
      efi_pxe_base_code_boot_type_Altiris_9=9;
      efi_pxe_base_code_boot_type_Altiris_10=10;
      efi_pxe_base_code_boot_type_Altiris_11=11;
      efi_pxe_base_code_boot_type_Not_Used_12=12;
      efi_pxe_base_code_boot_type_RedHat_install=13;
      efi_pxe_base_code_boot_type_RedHat_boot=14;
      efi_pxe_base_code_boot_type_rembo=15;
      efi_pxe_base_code_boot_type_BeoBoot=16;
      efi_pxe_base_code_boot_type_PXETest=65535;
      efi_pxe_base_code_boot_layer_mask=$7FFF;
      efi_pxe_base_code_boot_layer_initial=$0000;
      efi_pxe_base_code_ip_filter_station_ip=$0001;
      efi_pxe_base_code_ip_filter_broadcast=$0002;
      efi_pxe_base_code_ip_filter_promiscuous=$0004;
      efi_pxe_base_code_ip_filter_promiscuous_multicast=$0008;
      efi_pxe_base_code_udp_opflags_any_src_ip=$0001;
      efi_pxe_base_code_udp_opflags_any_src_port=$0002;
      efi_pxe_base_code_udp_opflags_any_dest_ip=$0004;
      efi_pxe_base_code_udp_opflags_any_dest_port=$0008;
      efi_pxe_base_code_udp_opflags_use_filter=$0010;
      efi_pxe_base_code_udp_opflags_may_fragment=$0020;
      default_ttl=16;
      default_ToS=0;
      efi_pxe_base_code_callback_revision=$00010000;
      bis_version_1=1;
      bis_current_version_major=bis_version_1;
      bis_alg_dsa=41;
      bis_alg_rsa_md5=42;
      bis_cert_id_mask=$FF7F7FFF;
      bis_cert_id_dsa=bis_alg_dsa;
      bis_cert_id_rsa_md5=bis_alg_rsa_md5;
      processor_as_bsp_bit=$00000001;
      processor_enabled_bit=$00000002;
      processor_health_status_bit=$00000004;
      
function bis_get_siginfo_count(bisdataPtr:Pefi_bis_data):dword;
function bis_get_siginfo_array(bisdataPtr:Pefi_bis_data):Pefi_bis_signature_info;  
procedure efi_initialize(ImageHandle:efi_handle;SystemTable:Pefi_system_table);
function efi_error(status:efi_status):boolean;
procedure efi_show_error(SystemTable:Pefi_system_table;status:efi_status);
function efi_get_platform:byte;
function efi_string_to_mac_address(str:PWideChar):efi_mac_address;
function efi_mac_address_to_string(address:efi_mac_address):PWideChar;
procedure efi_console_clear_screen(SystemTable:Pefi_system_table);
procedure efi_console_output_string(SystemTable:Pefi_system_table;outputstring:PWideChar);
procedure efi_set_watchdog_timer_to_null(SystemTable:Pefi_system_table);
procedure efi_console_read_string(SystemTable:Pefi_system_table;var ReadString:PWideChar);
procedure efi_console_read_password_string(SystemTable:Pefi_system_table;var ReadString:PWideChar);
procedure efi_console_enable_mouse(SystemTable:Pefi_system_table);
procedure efi_console_set_global_colour(SystemTable:Pefi_system_table;backgroundcolour:byte;textcolour:byte);
procedure efi_console_set_cursor_position(SystemTable:Pefi_system_table;column,row:natuint);
procedure efi_console_get_cursor_position(SystemTable:Pefi_system_table;var column,row:natuint);
procedure efi_console_get_max_row_and_max_column(SystemTable:Pefi_system_table;debug:boolean);
procedure efi_console_output_string_with_colour(SystemTable:Pefi_system_table;Outputstring:PWideChar;backgroundcolour:byte;textcolour:byte);
procedure efi_console_read_string_with_colour(SystemTable:Pefi_system_table;var ReadString:PWideChar;backgroundcolour:byte;textcolour:byte);
procedure efi_console_timer_mouse_blink(Event:efi_event;Context:Pointer);cdecl;
procedure efi_console_enable_mouse_blink(SystemTable:Pefi_system_table;enableblink:boolean;blinkmilliseconds:qword);
function efi_generate_guid(seed1,seed2:qword):efi_guid;
function efi_generate_fat32_volumeid(seed1:dword):dword;
function efi_list_all_file_system(SystemTable:Pefi_system_table;isreadonly:byte):efi_file_system_list;
function efi_list_all_file_system_ext(SystemTable:Pefi_system_table):efi_file_system_list_ext;
function efi_detect_disk_write_ability(SystemTable:Pefi_system_table):efi_disk_list;
procedure efi_install_cdrom_to_hard_disk(systemtable:Pefi_system_table;disklist:efi_disk_list;harddiskindex:natuint;isgraphics:boolean;manual_list:efi_manual_operation_lists_list);
procedure efi_install_cdrom_to_hard_disk_stage2(systemtable:Pefi_system_table;efslext:efi_file_system_list_ext;inscd,insdisk:natuint;const efipart:boolean);
procedure efi_system_restart_information_off(systemtable:Pefi_system_table;isgraphics:boolean;var mybool:boolean);
function efi_system_restart_information_get_mode(systemtable:Pefi_system_table):byte;
function efi_disk_empty_list(systemTable:Pefi_system_table):efi_disk_list;
function efi_disk_tydq_get_fs_list(systemTable:Pefi_system_table):efi_disk_list;
procedure efi_disk_tydq_set_fs(edl:efi_disk_list;diskindex:natuint);
procedure efi_console_initialize(systemtable:Pefi_system_table;bck_colour,text_colour:byte;blinkmiliseconds:qword);
procedure efi_reset_system_warm(systemtable:Pefi_system_table);
procedure efi_reset_system_cold(systemtable:Pefi_system_table);
procedure efi_system_shutdown(systemtable:Pefi_system_table);
function efi_graphics_initialize(systemtable:Pefi_system_table):efi_graphics_list;
procedure efi_graphics_get_maxwidth_maxheight_and_maxdepth(egl:efi_graphics_list;eglindex:natuint);
function efi_pointer_initialize(systemtable:Pefi_system_table):efi_pointer_list;
procedure efi_mouse_initialize(epl:efi_pointer_list;eplindex:natuint);
procedure efi_pointer_refresh_cursor(Event:efi_event;Context:Pointer);cdecl;
procedure efi_pointer_enable_cursor(systemtable:Pefi_system_table;epl:efi_pointer_list;pointerindex:natuint;enable:boolean;refreshmilliseconds:qword);
function efi_absolute_pointer_initialize(systemtable:Pefi_system_table):efi_absolute_pointer_list;
procedure efi_absolute_mouse_initialize(eapl:efi_absolute_pointer_list;eaplindex:natuint);
procedure efi_absolute_pointer_refresh_cursor(Event:efi_event;Context:Pointer);cdecl;
procedure efi_absolute_pointer_enable_mouse(systemtable:Pefi_system_table;eapl:efi_absolute_pointer_list;eaplindex:natuint;enable:boolean;refreshmilliseconds:qword);
function efi_create_thread(systemtable:Pefi_system_table;func:sys_parameter_function;param:sys_parameter):efi_handle;
procedure efi_start_thread(systemtable:Pefi_system_table;threadhandle:efi_handle);
procedure efi_terminate_thread(systemtable:Pefi_system_table;threadhandle:efi_handle);
function efi_processor_initialize(systemtable:Pefi_system_table):efi_processor_list;
procedure efi_processor_execute_procedure(systemtable:Pefi_system_table;epl:efi_processor_list;eplindex,processorindex:natuint;func:sys_parameter_function;param:sys_parameter);
procedure efi_processor_free(var epl:efi_processor_list);

var maxcolumn:Natuint=80;
    maxrow:Natuint=25;
    currentcolumn:Natuint=0;
    currentrow:Natuint=0;
    consolebck:byte=efi_bck_black;
    consoletex:byte=efi_lightgrey;
    Cursorblinkevent:efi_event=nil;
    CursorblinkVisible:boolean=false;
    ParentImageHandle:efi_handle;
    GlobalSystemTable:Pefi_system_table;
    NetworkEnable:boolean=false;
    content:array[1..67108864] of byte;
    mbr,rmbr:master_boot_record;
    gpt,rgpt1,rgpt2:efi_gpt_header;
    epe:efi_partition_entry_list;
    fat32h:fat32_header;
    fat32fs:fat32_file_system_info;
    {Only for graphics}
    maxscreenwidth:dword=800;
    maxscreenheight:dword=600;
    maxscreendepth:dword=32;
    graphicsindex:natuint;
    mousestate:efi_pointer_list_state;
    absolutemousestate:efi_absolute_pointer_list_state;
    mouseenable:boolean=false;
    absolutemouseenable:boolean=false;
    mouseevent:efi_event=nil;
    
implementation

function bis_get_siginfo_count(bisdataPtr:Pefi_bis_data):dword;[public,alias:'BIS_GET_SIGINFO_COUNT'];
begin
 bis_get_siginfo_count:=bisdataPtr^.Length div sizeof(efi_bis_signature_info);
end;
function bis_get_siginfo_array(bisdataPtr:Pefi_bis_data):Pefi_bis_signature_info;[public,alias:'BIS_GET_SIGINFO_ARRAY'];
begin
 bis_get_siginfo_array:=Pefi_bis_signature_info(bisdataPtr^.Data);
end;
procedure efi_initialize(ImageHandle:efi_handle;SystemTable:Pefi_system_table);[public,alias:'EFI_INITIALIZE'];
begin
 ParentImageHandle:=ImageHandle; GlobalSystemTable:=SystemTable;
end;
function efi_error(status:efi_status):boolean;[public,alias:'EFI_ERROR'];
begin
 {$IFDEF CPU64}
 if(status<$8000000000000000) then efi_error:=false else efi_error:=true;
 {$ELSE CPU64}
 if(status<$80000000) then efi_error:=false else efi_error:=true;
 {$ENDIF CPU64}
end;
procedure efi_show_error(SystemTable:Pefi_system_table;status:efi_status);[public,alias:'EFI_SHOW_ERROR'];
var fstatus:efi_status;
    i:byte;
    error:boolean;
begin
 fstatus:=status; error:=efi_error(status);
 for i:=1 to 63 do
  begin
   if(i=efi_load_error) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_LOAD_ERROR'#10)
   else if(i=efi_invaild_parameter) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_INVAILD_PARAMETER'#10)
   else if(i=efi_unsupported) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_UNSUPPORTED'#10)
   else if(i=efi_bad_buffer_size) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_BAD_BUFFER_SIZE'#10)
   else if(i=efi_buffer_too_small) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_BUFFER_TOO_SMALL'#10)
   else if(i=efi_not_ready) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_NOT_READY'#10)
   else if(i=efi_device_error) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_DEVICE_ERROR'#10)
   else if(i=efi_write_protected) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_WRITE_PROTECTED'#10)
   else if(i=efi_out_of_resources) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_OUT_OF_RESOURCES'#10)
   else if(i=efi_volume_corrupted) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_VOLUME_CORRUPTED'#10)
   else if(i=efi_volume_full) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_VOLUME_FULL'#10)
   else if(i=efi_no_media) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_NO_MEDIA'#10)
   else if(i=efi_media_changed) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_MEDIA_CHANGED'#10)
   else if(i=efi_not_found) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_NOT_FOUND'#10)
   else if(i=efi_access_denied) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_ACCESS_DENIED'#10)
   else if(i=efi_no_response) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_NO_RESPONSE'#10)
   else if(i=efi_no_mapping) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_NO_MAPIING'#10)
   else if(i=efi_timeout) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_TIMEOUT'#10)
   else if(i=efi_not_started) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_NOT_STARTED'#10)
   else if(i=efi_already_started) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_ALREADY_STARTED'#10)
   else if(i=efi_aborted) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_ABORTED'#10)
   else if(i=efi_icmp_error) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_ICMP_ERROR'#10)
   else if(i=efi_tftp_error) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_TFTP_ERROR'#10)
   else if(i=efi_protocol_error) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_PROTOCOL_ERROR'#10)
   else if(i=efi_incompatible_version) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_INCOMPATIBLE_VERSION'#10)
   else if(i=efi_security_violation) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_SECURITY_VIOLATION'#10)
   else if(i=efi_crc_error) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_CRC_ERROR'#10)
   else if(i=efi_end_of_media) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_END_OF_MEDIA'#10)
   else if(i=efi_end_of_file) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_END_OF_FILE'#10)
   else if(i=efi_invaild_language) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_INVAILD_LANGUAGE'#10)
   else if(i=efi_compromised_data) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_COMPROMISED_DATA'#10)
   else if(i=efi_ip_address_conflict) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_IP_ADDRESS_CONFLICT'#10)
   else if(i=efi_http_error) and (fstatus mod 2=1) and (error=true) then efi_console_output_string(systemtable,'EFI_HTTP_ERROR'#10)
   else if(i=efi_warn_unknown_glyph) and (fstatus mod 2=1) and (error=false) then efi_console_output_string(systemtable,'EFI_WARN_UNKNOWN_GLYPH'#10)
   else if(i=efi_warn_delete_failure) and (fstatus mod 2=1) and (error=false) then efi_console_output_string(systemtable,'EFI_WARN_DELETE_FAILURE'#10)
   else if(i=efi_warn_write_failure) and (fstatus mod 2=1) and (error=false) then efi_console_output_string(systemtable,'EFI_WARN_WRITE_FAILURE'#10)
   else if(i=efi_warn_buffer_too_small) and (fstatus mod 2=1) and (error=false) then efi_console_output_string(systemtable,'EFI_WARN_BUFFER_TOO_SMALL'#10)
   else if(i=efi_warn_stale_data) and (fstatus mod 2=1) and (error=false) then efi_console_output_string(systemtable,'EFI_WARN_STALE_DATA'#10)
   else if(i=efi_warn_file_system) and (fstatus mod 2=1) and (error=false) then efi_console_output_string(systemtable,'EFI_WARN_FILE_SYSTEM'#10)
   else if(i=efi_warn_reset_required) and (fstatus mod 2=1) and (error=false) then efi_console_output_string(systemtable,'EFI_WARN_RESET_REQUIRED'#10)
   else if(i=1) and (fstatus mod 2=0) and (error=false) then efi_console_output_string(systemtable,'EFI_SUCCESS'#10);
   fstatus:=fstatus div 2;
  end;
end;
procedure efi_console_clear_screen(SystemTable:Pefi_system_table);[public,alias:'EFI_CONSOLE_CLEAR_SCREEN'];
begin
 SystemTable^.ConOut^.ClearScreen(SystemTable^.ConOut);
 currentcolumn:=0; currentrow:=0;
end;
function efi_get_platform:byte;[public,alias:'EFI_GET_PLATFORM'];
begin
 {$IFDEF CPUX86_64}
 efi_get_platform:=0;
 {$ENDIF}
 {$IFDEF CPUAARCH64}
 efi_get_platform:=1;
 {$ENDIF}
 {$IFDEF CPULOONGARCH}
 efi_get_platform:=2;
 {$ENDIF}
 {$IFDEF CPURISCV64}
 efi_get_platform:=3;
 {$ENDIF}
 {$IFDEF CPURISCV128}
 efi_get_platform:=4;
 {$ENDIF}
end;
function efi_string_to_mac_address(str:PWideChar):efi_mac_address;[public,alias:'EFI_STRING_TO_MAC_ADDRESS'];
const numchar1:PWideChar='0123456789ABCDEF';
      numchar2:PWideChar='0123456789abcdef';
var i,j,k,len:natuint;
    res:efi_mac_address;
begin 
 len:=Wstrlen(str); i:=1; k:=1;
 while(i<len) do
  begin
   j:=0;
   while(j<=15) do
    begin
     if((numchar1+j)^=(str+i-1)^) or ((numchar2+j)^=(str+i-1)^) then break;
     inc(j,1);
    end;
   res.Addr[k]:=j*16;
   j:=0;
   while(j<=15) do
    begin
     if((numchar1+j)^=(str+i)^) or ((numchar2+j)^=(str+i)^) then break;
     inc(j,1);
    end;
   res.Addr[k]:=res.Addr[k]+j;
   inc(k,1);
   inc(i,3);
  end;
 for i:=7 to 32 do res.Addr[i]:=0;
 efi_string_to_mac_address:=res;
end;
function efi_mac_address_to_string(address:efi_mac_address):PWideChar;[public,alias:'EFI_MAC_ADDRESS_TO_STRING'];
const numchar:PWideChar='0123456789ABCDEF';
var i,len:natuint;
    res:PWidechar;
begin
 Wstrinit(res,6*3-1); i:=0; len:=6;
 while(i<len) do
  begin
   inc(i);
   (res+i*3-3)^:=(numchar+address.Addr[i] div 16)^;
   (res+i*3-2)^:=(numchar+address.Addr[i] mod 16)^;
   if(i<len) then (res+i*3-1)^:=':';
  end;
 efi_mac_address_to_string:=res;
end;
procedure efi_console_output_string(SystemTable:Pefi_system_table;outputstring:PWideChar);[public,alias:'EFI_CONSOLE_OUTPUT_STRING'];
var mychar:array[1..2] of WideChar;
    i,len:Natuint;
begin
 SystemTable^.ConOut^.SetAttribute(SystemTable^.ConOut,consolebck shl 4+consoletex);
 i:=1; len:=wstrlen(outputstring);
 while(i<=len) do
  begin
   if(i<=len-1) then
    begin
     if((outputstring+i-1)^=#13) and ((outputstring+i)^=#10) then 
      begin
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
       inc(currentrow); currentcolumn:=0; inc(i,2);
      end
     else if((outputstring+i-1)^=#13) and ((outputstring+i)^<>#10) then
      begin
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
       inc(currentrow); currentcolumn:=0; inc(i,1);
      end
     else if((outputstring+i-1)^=#10) and ((outputstring+i)^<>#13) then
      begin
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
       inc(currentrow); currentcolumn:=0; inc(i,1);
      end
     else
      begin
       mychar[1]:=(outputstring+i-1)^;
       mychar[2]:=#0;
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,@mychar);
       inc(currentcolumn); inc(i,1);
      end;
    end
   else
    begin
     if((outputstring+i-1)^=#13) or ((outputstring+i-1)^=#10) then
      begin
       SystemTable^.ConOut^.OutputString(Systemtable^.ConOut,#13#10);
       inc(currentrow); currentcolumn:=0; inc(i,1);
      end
     else
      begin
       mychar[1]:=(outputstring+i-1)^;
       mychar[2]:=#0;
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,@mychar);
       inc(currentcolumn); inc(i,1);
      end;
    end;
   if(currentcolumn>=maxcolumn) then 
    begin
     currentcolumn:=0; inc(currentrow,1); 
    end;
   if(currentrow>=maxrow) then 
    begin
     efi_console_clear_screen(SystemTable);
    end;
  end;
 efi_console_set_cursor_position(SystemTable,currentcolumn,currentrow);
end;
procedure efi_console_output_string_with_colour(SystemTable:Pefi_system_table;Outputstring:PWideChar;backgroundcolour:byte;textcolour:byte);[public,alias:'EFI_CONSOLE_OUTPUT_STRING_WITH_COLOUR'];
var mychar:array[1..2] of WideChar;
    i,len:Natuint;
begin
 SystemTable^.ConOut^.SetAttribute(SystemTable^.ConOut,backgroundcolour shl 4+textcolour);
 i:=1; len:=wstrlen(outputstring);
 while(i<=len) do
  begin
   if(i<=len-1) then
    begin
     if((outputstring+i-1)^=#13) and ((outputstring+i)^=#10) then 
      begin
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
       inc(currentrow); currentcolumn:=0; inc(i,2);
      end
     else if((outputstring+i-1)^=#13) and ((outputstring+i)^<>#10) then
      begin
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
       inc(currentrow); currentcolumn:=0; inc(i,1);
      end
     else if((outputstring+i-1)^=#10) and ((outputstring+i)^<>#13) then
      begin
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
       inc(currentrow); currentcolumn:=0; inc(i,1);
      end
     else
      begin
       mychar[1]:=(outputstring+i-1)^;
       mychar[2]:=#0;
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,@mychar);
       inc(currentcolumn); inc(i,1);
      end;
    end
   else
    begin
     if((outputstring+i-1)^=#13) or ((outputstring+i-1)^=#10) then
      begin
       SystemTable^.ConOut^.OutputString(Systemtable^.ConOut,#13#10);
       inc(currentrow); currentcolumn:=0; inc(i,1);
      end
     else
      begin
       mychar[1]:=(outputstring+i-1)^;
       mychar[2]:=#0;
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,@mychar);
       inc(currentcolumn); inc(i,1);
      end;
    end;
   if(currentcolumn>=maxcolumn) then 
    begin
     currentcolumn:=0; inc(currentrow,1); 
    end;
   if(currentrow>=maxrow) then 
    begin
     efi_console_clear_screen(SystemTable);
    end;
  end;
 efi_console_set_cursor_position(SystemTable,currentcolumn,currentrow);
end;
procedure efi_set_watchdog_timer_to_null(SystemTable:Pefi_system_table);[public,alias:'EFI_SET_WATCHDOG_TIMER_TO_NULL'];
begin
 SystemTable^.bootservices^.SetWatchDogTimer(0,0,0,nil);
end;
procedure efi_console_read_string(SystemTable:Pefi_system_table;var ReadString:PWideChar);[public,alias:'EFI_CONSOLE_READ_STRING'];
var key:efi_input_key;
    waitidx,i,j:natuint;
begin
 SystemTable^.ConOut^.SetAttribute(SystemTable^.ConOut,consolebck shl 4+consoletex);
 if(ReadString<>nil) then freemem(ReadString);
 Readstring:=allocmem(sizeof(WideChar)); i:=0;
 while (True) do
  begin
   inc(i);
   ReallocMem(ReadString,(i+1)*sizeof(WideChar));
   SystemTable^.BootServices^.WaitForEvent(1,@SystemTable^.ConIn^.WaitForKey,waitidx);
   SystemTable^.ConIn^.ReadKeyStroke(SystemTable^.ConIn,key);
   if(key.ScanCode=0) then (ReadString+i-1)^:=key.UnicodeChar else (ReadString+i-1)^:=#0;
   if((ReadString+i-1)^=#10) or ((ReadString+i-1)^=#13) then
    begin
     (ReadString+i-1)^:=#0; 
     SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
     currentcolumn:=0; inc(currentrow);
     if(currentrow>=maxrow) then efi_console_clear_screen(SystemTable);
     break;
    end
   else if((ReadString+i-1)^=#8) then
    begin
     if(i>0) then
      begin 
       (ReadString+i-1)^:=#0; dec(i);  
       if(i>0) then
        begin
         (ReadString+i-1)^:=#0; dec(i);
         SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#8);
         if(currentcolumn>0) then dec(currentcolumn) 
          else
           begin
           if(currentrow>0) then dec(currentrow);
           currentcolumn:=maxcolumn-1;
          end;
        end;
      end;
    end
   else if((ReadString+i-1)^<>#0) then
    begin
     inc(currentcolumn);
     if(currentcolumn>=maxcolumn) then
      begin
       currentcolumn:=0; inc(currentrow); SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
      end;
     if(currentrow>=maxrow) then efi_console_clear_screen(SystemTable);
     SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,@(ReadString+i-1)^);
    end
   else dec(i);
   efi_console_set_cursor_position(systemtable,currentcolumn,currentrow);
  end;
end;
procedure efi_console_read_password_string(SystemTable:Pefi_system_table;var ReadString:PWideChar);[public,alias:'EFI_CONSOLE_READ_PASSWORD_STRING'];
var key:efi_input_key;
    waitidx,i,j:natuint;
begin
 SystemTable^.ConOut^.SetAttribute(SystemTable^.ConOut,consolebck shl 4+consoletex);
 if(ReadString<>nil) then freemem(ReadString);
 Readstring:=allocmem(sizeof(WideChar)); i:=0;
 while (True) do
  begin
   inc(i);
   ReallocMem(ReadString,(i+1)*sizeof(WideChar));
   SystemTable^.BootServices^.WaitForEvent(1,@SystemTable^.ConIn^.WaitForKey,waitidx);
   SystemTable^.ConIn^.ReadKeyStroke(SystemTable^.ConIn,key);
   if(key.ScanCode=0) then (ReadString+i-1)^:=key.UnicodeChar else (ReadString+i-1)^:=#0;
   if((ReadString+i-1)^=#10) or ((ReadString+i-1)^=#13) then
    begin
     (ReadString+i-1)^:=#0; 
     SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
     currentcolumn:=0; inc(currentrow);
     if(currentrow>=maxrow) then efi_console_clear_screen(SystemTable);
     break;
    end
   else if((ReadString+i-1)^=#8) then
    begin
     if(i>0) then
      begin 
       (ReadString+i-1)^:=#0; dec(i);  
       if(i>0) then
        begin
         (ReadString+i-1)^:=#0; dec(i);
        end;
      end;
    end
   else if((ReadString+i-1)^<>#0) then
    begin
    end
   else dec(i);
   efi_console_set_cursor_position(systemtable,currentcolumn,currentrow);
  end;
end;
procedure efi_console_read_string_with_colour(SystemTable:Pefi_system_table;var ReadString:PWideChar;backgroundcolour:byte;textcolour:byte);[public,alias:'EFI_CONSOLE_READ_STRING_WITH_COLOUR'];
var key:efi_input_key;
    waitidx,i,j:natuint;
begin
 SystemTable^.ConOut^.SetAttribute(SystemTable^.ConOut,backgroundcolour shl 4+textcolour);
 if(ReadString<>nil) then freemem(ReadString);
 Readstring:=allocmem(sizeof(WideChar)); i:=0;
 while (True) do
  begin
   inc(i);
   ReallocMem(ReadString,(i+1)*sizeof(WideChar));
   SystemTable^.BootServices^.WaitForEvent(1,@SystemTable^.ConIn^.WaitForKey,waitidx);
   SystemTable^.ConIn^.ReadKeyStroke(SystemTable^.ConIn,key);
   if(key.ScanCode=0) then (ReadString+i-1)^:=key.UnicodeChar else (ReadString+i-1)^:=#0;
   if((ReadString+i-1)^=#10) or ((ReadString+i-1)^=#13) then
    begin
     (ReadString+i-1)^:=#0; 
     SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
     currentcolumn:=0; inc(currentrow);
     if(currentrow>=maxrow) then efi_console_clear_screen(SystemTable);
     break;
    end
   else if((ReadString+i-1)^=#8) then
    begin
     if(i>0) then
      begin 
       (ReadString+i-1)^:=#0; dec(i);  
       if(i>0) then
        begin
         (ReadString+i-1)^:=#0; dec(i);
         SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#8);
         if(currentcolumn>0) then dec(currentcolumn) 
          else
           begin
           if(currentrow>0) then dec(currentrow);
           currentcolumn:=maxcolumn-1;
          end;
        end;
      end;
    end
   else if((ReadString+i-1)^<>#0) then
    begin
     inc(currentcolumn);
     if(currentcolumn>=maxcolumn) then
      begin
       currentcolumn:=0; inc(currentrow); SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
      end;
     if(currentrow>=maxrow) then efi_console_clear_screen(SystemTable);
     SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,@(ReadString+i-1)^);
    end
   else dec(i);
   efi_console_set_cursor_position(systemtable,currentcolumn,currentrow);
  end;
end;
procedure efi_console_enable_mouse(SystemTable:Pefi_system_table);[public,alias:'EFI_CONSOLE_ENABLE_MOUSE'];
begin
 SystemTable^.ConOut^.EnableCursor(SystemTable^.ConOut,true);
end;
procedure efi_console_set_global_colour(SystemTable:Pefi_system_table;backgroundcolour:byte;textcolour:byte);[public,alias:'EFI_CONSOLE_SET_GLOBAL_COLOUR'];
begin
 consolebck:=backgroundcolour; consoletex:=textcolour;
end;
procedure efi_console_set_cursor_position(SystemTable:Pefi_system_table;column,row:natuint);[public,alias:'EFI_CONSOLE_SET_CURSOR_POSITION'];
begin
 SystemTable^.ConOut^.SetCursorPosition(SystemTable^.ConOut,column,row);
end;
procedure efi_console_get_cursor_position(SystemTable:Pefi_system_table;var column,row:natuint);[public,alias:'EFI_CONSOLE_GET_CURSOR_POSITION'];
begin
 column:=SystemTable^.ConOut^.Mode^.Cursorcolumn;
 row:=SystemTable^.ConOut^.Mode^.CursorRow;
end;
procedure efi_console_get_max_row_and_max_column(SystemTable:Pefi_system_table;debug:boolean);[public,alias:'EFI_CONSOLE_GET_MAX_ROW_AND_MAX_COLUMN'];
var maxc,maxr:Natuint;
    status:natint;
    i:byte;
begin
 i:=0; status:=efi_success;
 SystemTable^.ConOut^.SetMode(SystemTable^.ConOut,0);
 while(True) do
  begin
   inc(i);
   status:=SystemTable^.ConOut^.QueryMode(SystemTable^.ConOut,i-1,maxc,maxr);
   if(debug=true) then
    begin
     SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,'Mode ');
     SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,UIntToPWchar(i-1));
     SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,' ');
     if(status=efi_success) then
      begin
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,UIntToPWchar(maxc));
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,'-');
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,UIntToPWchar(maxr));
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,#13#10);
      end
     else if(status<>efi_success) then
      begin
       SystemTable^.ConOut^.OutputString(SystemTable^.ConOut,'Unsupported'+#13#10);
      end;
    end;
   if(i>=SystemTable^.ConOut^.Mode^.MaxMode) then 
    begin
     SystemTable^.ConOut^.SetMode(SystemTable^.ConOut,i-1);
     maxcolumn:=maxc; maxrow:=maxr; 
     break;
    end;
  end;
end;
procedure efi_console_timer_mouse_blink(Event:efi_event;Context:Pointer);cdecl;[public,alias:'EFI_CONSOLE_TIMER_MOUSE_BLINK'];
begin
 if(CursorBlinkVisible=true) then 
  begin 
   Pefi_system_table(Context)^.ConOut^.EnableCursor(Pefi_system_table(Context)^.ConOut,false);
   CursorBlinkVisible:=false;
  end
 else if(CursorBlinkVisible=false) then 
  begin
   Pefi_system_table(Context)^.ConOut^.EnableCursor(Pefi_system_table(Context)^.ConOut,true);
   CursorBlinkVisible:=true;
  end;
end;
procedure efi_console_enable_mouse_blink(SystemTable:Pefi_system_table;enableblink:boolean;blinkmilliseconds:qword);[public,alias:'EFI_CONSOLE_ENABLE_MOUSE_BLINK'];
begin
 if(enableblink=true) and (Cursorblinkevent=nil) then
  begin
   SystemTable^.BootServices^.CreateEvent(evt_notify_signal or evt_timer,tpl_callback,@efi_console_timer_mouse_blink,SystemTable,Cursorblinkevent);
   SystemTable^.BootServices^.SetTimer(Cursorblinkevent,TimerPeriodic,blinkmilliseconds*10000);
  end
 else if(enableblink=false) and (Cursorblinkevent<>nil) then
  begin
   SystemTable^.BootServices^.CloseEvent(CursorBlinkEvent);
   Cursorblinkevent:=nil;
  end;
end;
function efi_generate_guid(seed1:qword;seed2:qword):efi_guid;[public,alias:'EFI_GENERATE_GUID'];
var resguid:efi_guid;
    i:byte;
    mseed1:dword;
    mseed2,mseed3:word;
    mseed4:array[1..8] of byte;
begin
 mseed1:=seed1 shr 32;
 mseed2:=seed1 mod 4294967296 shr 16;
 mseed3:=seed1 mod 4294967296 mod 65536;
 for i:=1 to 8 do mseed4[i]:=optimize_integer_modulo(optimize_integer_divide(seed2,2 shl ((8-i)*8)),2 shl ((i-1)*8));
 resguid.data1:=mseed1 div 13*5+12;
 resguid.data2:=mseed2 div 7*3+17;
 resguid.data3:=mseed3 div 3*2+21;
 for i:=1 to 8 do resguid.data4[i]:=mseed4[i] div 11*8+18;
 efi_generate_guid:=resguid;
end;
function efi_generate_fat32_volumeid(seed1:dword):dword;[public,alias:'EFI_GENERATE_FAT32_VOLUMEID'];
var res:dword;
begin
 res:=(seed1+seed1 div 17*9+seed1 div 127*110) div 3;
 efi_generate_fat32_volumeid:=res;
end;
function efi_list_all_file_system(SystemTable:Pefi_system_table;isreadonly:byte):efi_file_system_list;[public,alias:'EFI_LIST_ALL_FILE_SYSTEM'];
var totalnum,i:natuint;
    totalbuf:Pefi_handle;
    sfspp:Pointer;
    fsinfo:efi_file_system_info;
    fp:Pefi_file_protocol;
    data:efi_file_system_list;
    realsize:natuint;
begin
 SystemTable^.BootServices^.LocateHandleBuffer(ByProtocol,@efi_simple_file_system_protocol_guid,nil,totalnum,totalbuf);
 data.file_system_content:=allocmem(totalnum*sizeof(Pointer)); data.file_system_count:=0;
 for i:=1 to totalnum do
  begin
   SystemTable^.BootServices^.HandleProtocol((totalbuf+i-1)^,@efi_simple_file_system_protocol_guid,sfspp);
   Pefi_simple_file_system_protocol(sfspp)^.OpenVolume(Pefi_simple_file_system_protocol(sfspp),fp);
   realsize:=sizeof(efi_file_system_info);
   fp^.GetInfo(fp,@efi_file_system_info_id,realsize,fsinfo);
   if(isreadonly=1) and (fsinfo.ReadOnly=true) then
    begin
     inc(data.file_system_count);
     (data.file_system_content+data.file_system_count-1)^:=Pefi_simple_file_system_protocol(sfspp);
    end
   else if(isreadonly=0) and (fsinfo.ReadOnly=false) then
    begin
     inc(data.file_system_count);
     (data.file_system_content+data.file_system_count-1)^:=Pefi_simple_file_system_protocol(sfspp);
    end
   else if(isreadonly=2) then
    begin
     inc(data.file_system_count);
     (data.file_system_content+data.file_system_count-1)^:=Pefi_simple_file_system_protocol(sfspp);
    end;
  end;
 ReallocMem(data.file_system_content,sizeof(Pefi_simple_file_system_protocol)*data.file_system_count);
 efi_list_all_file_system:=data;
end;
function efi_list_all_file_system_ext(SystemTable:Pefi_system_table):efi_file_system_list_ext;[public,alias:'EFI_LIST_ALL_FILE_SYSTEM_EXT'];
var totalnum,i,j,size:natuint;
    status:efi_status;
    totalbuf:Pefi_handle;
    sfspp:Pefi_simple_file_system_protocol;
    fp:Pefi_file_protocol;
    data:efi_file_system_list_ext;
    fsinfo:efi_file_system_info;
    realsize:natuint;
begin
 SystemTable^.BootServices^.LocateHandleBuffer(ByProtocol,@efi_simple_file_system_protocol_guid,nil,totalnum,totalbuf);
 data.fsrcontent:=allocmem(sizeof(Pointer)*totalnum); data.fsrcount:=0;
 data.fsrwcontent:=allocmem(sizeof(Pointer)*totalnum); data.fsrwcount:=0;
 for i:=1 to totalnum do
  begin
   SystemTable^.BootServices^.HandleProtocol((totalbuf+i-1)^,@efi_simple_file_system_protocol_guid,sfspp);
   sfspp^.OpenVolume(sfspp,fp);
   realsize:=sizeof(efi_file_system_info);
   fp^.GetInfo(fp,@efi_file_system_info_id,realsize,fsinfo);
   if(fsinfo.ReadOnly) then
    begin
     inc(data.fsrcount);
     (data.fsrcontent+data.fsrcount-1)^:=Pefi_simple_file_system_protocol(sfspp);
     fp^.Close(fp);
    end
   else
    begin
     j:=1;
     while(j<=4) do
      begin
       status:=fp^.Open(fp,fp,'\',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
       if(status=efi_success) then break;
       inc(j,1);
      end;
     if (j<=4) then
      begin
       inc(data.fsrwcount);
       (data.fsrwcontent+data.fsrwcount-1)^:=Pefi_simple_file_system_protocol(sfspp);
       fp^.Delete(fp);
      end
     else fp^.Close(fp);
    end;
  end;
 size:=getmemsize(data.fsrcontent);
 ReallocMem(data.fsrcontent,sizeof(Pointer)*data.fsrcount);
 data.fsrwcontent:=Pointer(Pointer(data.fsrwcontent)-size);
 size:=getmemsize(data.fsrwcontent);
 ReallocMem(data.fsrwcontent,sizeof(Pointer)*data.fsrwcount);
 data.fsrcontent:=Pointer(Pointer(data.fsrcontent)-size);
 efi_list_all_file_system_ext:=data;
end;
function efi_detect_disk_write_ability(SystemTable:Pefi_system_table):efi_disk_list;[public,alias:'EFI_DETECT_DISK_WRITE_ABILITY'];
var tnum1,tnum2,i:natuint;
    tbuf1,tbuf2:Pefi_handle;
    p1:Pefi_disk_io_protocol;
    p2:Pefi_block_io_protocol;
    mydata1,mydata2:natuint;
    reslist:efi_disk_list;
    status:efi_status;
    size:natuint;
begin
 SystemTable^.BootServices^.LocateHandleBuffer(ByProtocol,@efi_disk_io_protocol_guid,nil,tnum1,tbuf1);
 SystemTable^.BootServices^.LocateHandleBuffer(ByProtocol,@efi_block_io_protocol_guid,nil,tnum2,tbuf2);
 reslist.disk_content:=allocmem(tnum1*sizeof(Pefi_disk_io_protocol)); 
 reslist.disk_block_content:=allocmem(tnum2*sizeof(Pefi_block_io_protocol)); 
 reslist.disk_count:=0;
 for i:=1 to tnum1 do
  begin
   SystemTable^.BootServices^.HandleProtocol((tbuf1+i-1)^,@efi_disk_io_protocol_guid,p1);
   SystemTable^.BootServices^.HandleProtocol((tbuf2+i-1)^,@efi_block_io_protocol_guid,p2);
   mydata1:=$5D47291AD7E3F2B1;
   p1^.ReadDisk(p1,p2^.Media^.MediaId,0,sizeof(natuint),mydata2);
   status:=p1^.WriteDisk(p1,p2^.Media^.MediaId,0,sizeof(natuint),@mydata1);
   if(status=efi_success) then
    begin
     p1^.WriteDisk(p1,p2^.Media^.MediaId,0,sizeof(natuint),@mydata2);
     p1^.ReadDisk(p1,p2^.Media^.MediaId,0,sizeof(master_boot_record),rmbr);
     p1^.ReadDisk(p1,p2^.Media^.MediaId,p2^.Media^.BlockSize,p2^.Media^.BlockSize,rgpt1);
     p1^.ReadDisk(p1,p2^.Media^.MediaId,p2^.Media^.BlockSize*p2^.Media^.LastBlock,p2^.Media^.BlockSize,rgpt2);
     if(rmbr.Partition[1].OStype=$EE) and ((rgpt1.signature=$5452415020494645) or (rgpt2.signature=$5452415020494645)) then continue;
     inc(reslist.disk_count);
     (reslist.disk_content+reslist.disk_count-1)^:=p1;
     (reslist.disk_block_content+reslist.disk_count-1)^:=p2;
    end;
  end;
 size:=getmemsize(reslist.disk_content);
 ReallocMem(reslist.disk_content,sizeof(Pointer)*reslist.disk_count);
 reslist.disk_block_content:=Pointer(Pointer(reslist.disk_block_content)-size);
 size:=getmemsize(reslist.disk_block_content);
 ReallocMem(reslist.disk_block_content,sizeof(Pointer)*reslist.disk_count);
 reslist.disk_content:=Pointer(Pointer(reslist.disk_content)-size);
 efi_detect_disk_write_ability:=reslist;
end;
procedure efi_install_cdrom_to_hard_disk(systemtable:Pefi_system_table;disklist:efi_disk_list;harddiskindex:natuint;isgraphics:boolean;manual_list:efi_manual_operation_lists_list);[public,alias:'EFI_INSTALL_CDROM_TO_HARD_DISK'];
var i,j,lastblock,blocksize,mediaid,diskwritepos,FirstDataSector:natuint;
    tmpv1,tmpv2,tmpv3:natuint;
    zero:byte;
    fp:Pefi_file_protocol;
    efsi:efi_file_system_info;
    readsize:natuint;
    diop:Pefi_disk_io_protocol;
    status:efi_status;
    fssignature:qword;
    current_position,current_size:qword;
begin
 zero:=0;
 for i:=1 to disklist.disk_count do
  begin
   diop:=(disklist.disk_content+i-1)^;
   blocksize:=((disklist.disk_block_content+i-1)^)^.Media^.BlockSize;
   lastblock:=((disklist.disk_block_content+i-1)^)^.Media^.LastBlock;
   mediaid:=((disklist.disk_block_content+i-1)^)^.Media^.MediaId;
   diskwritepos:=0;
   for j:=1 to 440 do mbr.BootStrapCode[j]:=0;
   mbr.UniqueMbrSignature:=0; mbr.Unknown:=0;
   for j:=1 to 4 do
    begin 
     if(j=1) then
      begin
       mbr.Partition[j].BootIndicator:=$05;
       mbr.Partition[j].StartingCHS[1]:=$00;
       mbr.Partition[j].StartingCHS[2]:=$02;
       mbr.Partition[j].StartingCHS[3]:=$00;
       mbr.Partition[j].OSType:=$EE;
       mbr.Partition[j].EndingCHS[1]:=$FF;
       mbr.Partition[j].EndingCHS[2]:=$FF;
       mbr.Partition[j].EndingCHS[3]:=$FF;
       mbr.Partition[j].StartingLBA:=$00000001;
       mbr.Partition[j].SizeInLBA:=LastBlock;
      end
     else if(j>1) then
      begin
       mbr.Partition[j].BootIndicator:=$00;
       mbr.Partition[j].StartingCHS[1]:=$00;
       mbr.Partition[j].StartingCHS[2]:=$00;
       mbr.Partition[j].StartingCHS[3]:=$00;
       mbr.Partition[j].OSType:=$00;
       mbr.Partition[j].EndingCHS[1]:=$00;
       mbr.Partition[j].EndingCHS[2]:=$00;
       mbr.Partition[j].EndingCHS[3]:=$00;
       mbr.Partition[j].StartingLBA:=$00000000;
       mbr.Partition[j].SizeInLBA:=$00000000;
      end;
    end;
   mbr.signature:=$AA55;
   gpt.signature:=$5452415020494645;
   gpt.revision:=$00010000;
   gpt.headersize:=92;
   gpt.headercrc32:=0;
   gpt.reserved1:=0;
   gpt.MyLBA:=1; 
   gpt.AlternateLBA:=lastblock;
   gpt.FirstUsableLBA:=2+optimize_integer_divide(128*128,blocksize); 
   gpt.LastUsableLBA:=gpt.AlternateLBA-optimize_integer_divide(128*128,blocksize)-1;
   gpt.DiskGuid:=efi_generate_guid($F1B2A2C3D7E3F967+32768*(i-1),$C1F2E3D1F4C9E84F+8192*(i-1));
   gpt.PartitionEntryLBA:=2;
   gpt.NumberOfPartitionEntries:=128;
   gpt.SizeOfPartitionEntry:=128;
   gpt.PartitionEntryArrayCRC32:=0;
   epe.epe_count:=128;
   if(blocksize>92) then for j:=1 to blocksize-92 do gpt.reserved2[j]:=0;
   current_position:=0; current_size:=0;
   if(i=harddiskindex) then
    begin
     for j:=1 to 128 do
      begin
       current_size:=(manual_list.content+i-1)^.size[j];
       if(j=1) then
        begin
         epe.epe_content[j].PartitionTypeGUID:=efi_system_partition_guid;
         epe.epe_content[j].UniquePartitionGUID:=efi_generate_guid($F1B2A2C3D7E3F967+4096*i+j*21,$C1F2E3D1F4C9E84F+3072*i+j*17);
         epe.epe_content[j].StartingLBA:=gpt.FirstUsableLBA;
         epe.epe_content[j].EndingLBA:=gpt.FirstUsableLBA+optimize_integer_divide(current_size shl 20,blocksize)-1;
         epe.epe_content[j].Attributes:=0;
         epe.epe_content[j].PartitionName[1]:='E';
         epe.epe_content[j].PartitionName[2]:='F';
         epe.epe_content[j].PartitionName[3]:='I';
         epe.epe_content[j].PartitionName[4]:=#0;
        end
       else if(j<=(manual_list.content+i-1)^.count) then
        begin
         epe.epe_content[j].PartitionTypeGUID:=efi_generate_guid($F1B2A2C3D7E3F967+4096*i+j*23,$C1F2E3D1F4C9E84F+4096*i+j*19);
         epe.epe_content[j].UniquePartitionGUID:=efi_generate_guid($F1B2A2C3D7E3F967+4096*i+j*21,$C1F2E3D1F4C9E84F+4096*i+j*17);
         epe.epe_content[j].StartingLBA:=gpt.FirstUsableLBA+optimize_integer_divide(current_position shl 20,blocksize);
         epe.epe_content[j].EndingLBA:=gpt.FirstUsableLBA+optimize_integer_divide((current_size+current_position) shl 20,blocksize)-1;
         epe.epe_content[j].Attributes:=0;
         epe.epe_content[j].PartitionName[1]:='T';
         epe.epe_content[j].PartitionName[2]:='Y';
         epe.epe_content[j].PartitionName[3]:='D';
         epe.epe_content[j].PartitionName[4]:='Q';
         epe.epe_content[j].PartitionName[5]:=#0;
        end
       else if(j>(manual_list.content+i-1)^.count) then
        begin
         epe.epe_content[j].PartitionTypeGUID:=unused_entry_guid;
         epe.epe_content[j].UniquePartitionGUID:=efi_generate_guid($F1B2A2C3D7E3F967+1636*i+j*21,$C1F2E3D1F4C9E84F+2560*i+j*17);
         epe.epe_content[j].StartingLBA:=0;
         epe.epe_content[j].EndingLBA:=0;
         epe.epe_content[j].Attributes:=0;
         epe.epe_content[j].PartitionName[1]:=#0;
        end;
       if(j<(manual_list.content+i-1)^.count) then current_position:=current_position+current_size;
      end;
    end
   else if(i<>harddiskindex) then
    begin
     for j:=1 to 128 do
      begin
       current_size:=(manual_list.content+i-1)^.size[j];
       if(j<=(manual_list.content+i-1)^.count) then
        begin
         epe.epe_content[j].PartitionTypeGUID:=efi_generate_guid($F1B2A2C3D7E3F967+4096*i+j*23,$C1F2E3D1F4C9E84F+4096*i+j*19);
         epe.epe_content[j].UniquePartitionGUID:=efi_generate_guid($F1B2A2C3D7E3F967+4096*i+j*21,$C1F2E3D1F4C9E84F+4096*i+j*17);
         epe.epe_content[j].StartingLBA:=gpt.FirstUsableLBA+optimize_integer_divide(current_position shl 20,blocksize);
         epe.epe_content[j].EndingLBA:=gpt.FirstUsableLBA+optimize_integer_divide((current_size+current_position) shl 20,blocksize)-1;
         epe.epe_content[j].Attributes:=0;
         epe.epe_content[j].PartitionName[1]:='T';
         epe.epe_content[j].PartitionName[2]:='Y';
         epe.epe_content[j].PartitionName[3]:='D';
         epe.epe_content[j].PartitionName[4]:='Q';
         epe.epe_content[j].PartitionName[5]:=#0;
        end  
       else if(j>(manual_list.content+i-1)^.count) then
        begin
         epe.epe_content[j].PartitionTypeGUID:=unused_entry_guid;
         epe.epe_content[j].UniquePartitionGUID:=efi_generate_guid($F1B2A2C3D7E3F967+4096*i+j*21,$C1F2E3D1F4C9E84F+4096*i+j*17);
         epe.epe_content[j].StartingLBA:=0;
         epe.epe_content[j].EndingLBA:=0;
         epe.epe_content[j].Attributes:=0;
         epe.epe_content[j].PartitionName[1]:=#0;
        end;
       if(j<(manual_list.content+i-1)^.count) then current_position:=current_position+current_size;
      end;
    end;
   SystemTable^.BootServices^.CalculateCrc32(@epe.epe_content,sizeof(epe.epe_content),gpt.PartitionEntryArrayCRC32);
   SystemTable^.BootServices^.CalculateCrc32(@gpt,gpt.headersize,gpt.headercrc32);
   diop^.WriteDisk(diop,mediaid,0,sizeof(master_boot_record),@mbr);
   if(blocksize>512) then for j:=512 to blocksize-1 do diop^.WriteDisk(diop,mediaid,j,1,@zero);
   diskwritepos:=blocksize;
   diop^.WriteDisk(diop,mediaid,diskwritepos,blocksize,@gpt);
   diop^.WriteDisk(diop,mediaid,blocksize*lastblock,blocksize,@gpt);
   diskwritepos:=blocksize*2;
   diop^.WriteDisk(diop,mediaid,diskwritepos,sizeof(epe.epe_content),@epe.epe_content);
   diop^.WriteDisk(diop,mediaid,blocksize*lastblock-blocksize*optimize_integer_divide(128,blocksize shr 7),sizeof(epe.epe_content),@epe.epe_content);
   if(i=harddiskindex) then
    begin
     fat32h.JumpOrder[1]:=$EB; fat32h.JumpOrder[2]:=$58; fat32h.JumpOrder[3]:=$90;
     fat32h.OemCode[1]:='T'; fat32h.OemCode[2]:='Y'; fat32h.OemCode[3]:='D'; fat32h.OemCode[4]:='Q';
     fat32h.OemCode[5]:='O'; fat32h.OemCode[6]:='S'; fat32h.OemCode[7]:=' '; fat32h.OemCode[8]:=' ';
     fat32h.BytesPerSector:=blocksize; 
     fat32h.SectorPerCluster:=1;
     fat32h.ReservedSectorCount:=8;
     fat32h.NumFATs:=2;
     fat32h.RootEntryCount:=0; 
     fat32h.TotalSector16:=0; 
     fat32h.Media:=$F8;
     fat32h.FATSectors16:=0; 
     fat32h.SectorPerTrack:=32; 
     fat32h.NumHeads:=8;
     fat32h.HiddenSectors:=0; 
     fat32h.TotalSectors32:=optimize_integer_divide((manual_list.content+i-1)^.size[1] shl 20,blocksize); 
     fat32h.FATSector32:=optimize_integer_divide((manual_list.content+i-1)^.size[1] shl 10,blocksize);
     fat32h.ExtendedFlags:=0; 
     fat32h.filesystemVersion:=0; 
     fat32h.RootCluster:=fat32h.ReservedSectorCount+fat32h.FATSector32*2;
     fat32h.FileSystemInfo:=1; 
     fat32h.BootSector:=6; 
     for j:=1 to 12 do fat32h.Reserved[j]:=0; 
     fat32h.DriverNumber:=$80; 
     fat32h.Reserved1:=0;
     fat32h.BootSignature:=$29; 
     fat32h.VolumeID:=efi_generate_fat32_volumeid($1F3845D2);
     fat32h.VolumeLabel[1]:='E'; fat32h.VolumeLabel[2]:='F'; fat32h.VolumeLabel[3]:='I'; fat32h.VolumeLabel[4]:=' '; 
     fat32h.VolumeLabel[5]:='P'; fat32h.VolumeLabel[6]:='A'; fat32h.VolumeLabel[7]:='R'; fat32h.VolumeLabel[8]:='T'; 
     fat32h.VolumeLabel[9]:=' '; fat32h.VolumeLabel[10]:=' '; fat32h.VolumeLabel[11]:=' ';
     fat32h.FileSystemType[1]:='F'; fat32h.FileSystemType[2]:='A'; fat32h.FileSystemType[3]:='T';
     fat32h.FileSystemType[4]:='3'; fat32h.FileSystemType[5]:='2'; fat32h.FileSystemType[6]:=' ';
     fat32h.FileSystemType[7]:=' '; fat32h.FileSystemType[8]:=' ';
     for j:=1 to 420 do fat32h.Reserved2[j]:=0;
     fat32h.SignatureWord:=$AA55;
     if(BlockSize>512) then for j:=1 to BlockSize-512 do fat32h.Reserved3[j]:=0;
     fat32fs.FSI_leadsig:=$41615252; 
     for j:=1 to 480 do fat32fs.FSI_Reserved1[j]:=0;
     fat32fs.FSI_StrucSig:=$61417272;
     fat32fs.FSI_FreeCount:=1024*optimize_integer_divide(256,blocksize shr 9)-fat32h.ReservedSectorCount-fat32h.FATSector32*2; 
     fat32fs.FSI_NextFree:=fat32h.ReservedSectorCount+fat32h.FATSector32*2;
     for j:=1 to 12 do fat32fs.FSI_Reserved2[j]:=0;
     fat32fs.FSI_TrailSig:=$AA550000;
     if(BlockSize>512) then for j:=1 to BlockSize-512 do fat32fs.FSI_Reserved3[j]:=0;
     diop^.WriteDisk(diop,mediaid,gpt.FirstUsableLBA*blocksize,blocksize,@fat32h);
     diop^.WriteDisk(diop,mediaid,gpt.FirstUsableLBA*blocksize+blocksize,blocksize,@fat32fs);
     diop^.WriteDisk(diop,mediaid,gpt.FirstUsableLBA*blocksize+blocksize*6,blocksize,@fat32h);
     diop^.WriteDisk(diop,mediaid,gpt.FirstUsableLBA*blocksize+blocksize*7,blocksize,@fat32fs);
     if(isgraphics=true) then
     diop^.WriteDisk(diop,mediaid,gpt.FirstUsableLBA*blocksize+(manual_list.content+i-1)^.size[1] shl 20,sizeof(efi_guid),@system_graphics_restart_guid)
     else
     diop^.WriteDisk(diop,mediaid,gpt.FirstUsableLBA*blocksize+(manual_list.content+i-1)^.size[1] shl 20,sizeof(efi_guid),@system_console_restart_guid);
    end;
  end;
end;
procedure efi_install_cdrom_to_hard_disk_stage2(systemtable:Pefi_system_table;efslext:efi_file_system_list_ext;inscd,insdisk:natuint;const efipart:boolean);[public,alias:'EFI_INSTALL_CDROM_TO_HARD_DISK_STAGE2'];
const orgstr:array[0..4] of PWideChar=('\EFI\SETUP\bootx64.efi','\EFI\SETUP\bootaa64.efi','\EFI\SETUP\bootloongarch64.efi','\EFI\SETUP\bootriscv64.efi','\EFI\SETUP\bootriscv128.efi');
      deststrbare:array[0..4] of PWideChar=('\EFI\BOOT\bootx64.efi','\EFI\BOOT\bootaa64.efi','\EFI\BOOT\bootloongarch64.efi','\EFI\BOOT\bootriscv64.efi','\EFI\BOOT\bootriscv128.efi');
      deststrmulti:array[0..4] of PWideChar=('\EFI\TYDQOS\bootx64.efi','\EFI\TYDQOS\bootaa64.efi','\EFI\TYDQOS\bootloongarch64.efi','\EFI\TYDQOS\bootriscv64.efi','\EFI\TYDQOS\bootriscv128.efi');
var fsp1,fsp2:Pefi_simple_file_system_protocol;
    fp1,fp2:Pefi_file_protocol;
    fpinfo:efi_file_info;
    realsize:natuint;
    status:efi_status;
begin
 {Install the boot loader}
 fsp1:=(efslext.fsrcontent+inscd-1)^; fsp2:=(efslext.fsrwcontent+insdisk-1)^;
 fsp1^.OpenVolume(fsp1,fp1); fsp2^.OpenVolume(fsp2,fp2);
 status:=fp2^.Open(fp2,fp2,'\',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
 while(status<>efi_success) do status:=fp2^.Open(fp2,fp2,'\',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
 status:=fp2^.Open(fp2,fp2,'\EFI',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
 while(status<>efi_success) do status:=fp2^.Open(fp2,fp2,'\EFI',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
 if(efipart) then 
  begin
   status:=fp2^.Open(fp2,fp2,'\EFI\BOOT',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
   while(status<>efi_success) do status:=fp2^.Open(fp2,fp2,'\EFI\BOOT',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
   status:=fp2^.Open(fp2,fp2,deststrbare[efi_get_platform],efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,0);
   while(status<>efi_success) do status:=fp2^.Open(fp2,fp2,deststrbare[efi_get_platform],efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,0);
  end
 else 
  begin
   status:=fp2^.Open(fp2,fp2,'\EFI\TYDQOS',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
   while(status<>efi_success) do status:=fp2^.Open(fp2,fp2,'\EFI\TYDQOS',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
   status:=fp2^.Open(fp2,fp2,deststrmulti[efi_get_platform],efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,0);
   while(status<>efi_success) do status:=fp2^.Open(fp2,fp2,deststrmulti[efi_get_platform],efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,0);
  end;
 status:=fp1^.Open(fp1,fp1,orgstr[efi_get_platform],efi_file_mode_read,0);
 while(status<>efi_success) do status:=fp1^.Open(fp1,fp1,orgstr[efi_get_platform],efi_file_mode_read,0);
 realsize:=sizeof(efi_file_info);
 fp1^.GetInfo(fp1,@efi_file_info_id,realsize,fpinfo);
 realsize:=fpinfo.FileSize;
 fp1^.efiRead(fp1,realsize,content);
 fp1^.flush(fp1);
 fp2^.SetPosition(fp2,0);
 status:=fp2^.efiWrite(fp2,realsize,@content);
 while(status<>efi_success) do 
  begin
   fp2^.SetPosition(fp2,0);
   status:=fp2^.efiWrite(fp2,realsize,@content);
  end;
 fp2^.flush(fp2);
 {Create the system folder}
 status:=fp2^.Open(fp2,fp2,'\EFI\SYSTEM',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
 while(status<>efi_success) do status:=fp2^.Open(fp2,fp2,'\EFI\SYSTEM',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,efi_file_directory);
 {Install the kernel}
 status:=fp2^.Open(fp2,fp2,'\EFI\SYSTEM\kernelmain.elf',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,0);
 while(status<>efi_success) do status:=fp2^.Open(fp2,fp2,'\EFI\SYSTEM\kernelmain.elf',efi_file_mode_create or efi_file_mode_write or efi_file_mode_read,0);
 status:=fp1^.Open(fp1,fp1,'\EFI\SYSTEM\kernelmain.elf',efi_file_mode_read,0);
 while(status<>efi_success) do status:=fp1^.Open(fp1,fp1,'\EFI\SYSTEM\kernelmain.elf',efi_file_mode_read,0);
 realsize:=sizeof(efi_file_info);
 fp1^.GetInfo(fp1,@efi_file_info_id,realsize,fpinfo);
 realsize:=fpinfo.FileSize;
 fp1^.efiRead(fp1,realsize,content);
 fp1^.flush(fp1);
 fp2^.SetPosition(fp2,0);
 status:=fp2^.efiWrite(fp2,realsize,@content);
 while(status<>efi_success) do 
  begin
   fp2^.SetPosition(fp2,0);
   status:=fp2^.efiWrite(fp2,realsize,@content);
  end;
 fp2^.flush(fp2);
 {Close the file}
 fp1^.Close(fp1); 
 fp2^.Close(fp2);
end;
procedure efi_system_restart_information_off(systemtable:Pefi_system_table;isgraphics:boolean;var mybool:boolean);[public,alias:'EFI_SYSTEM_RESTART_INFORMATION_OFF'];
var edl:efi_disk_list;
    procdisk:Pefi_disk_io_protocol;
    procblock:Pefi_block_io_protocol;
    data:efi_guid;
    i:natuint;
begin
 edl:=efi_detect_disk_write_ability(systemtable); mybool:=false;
 i:=1;
 while(i<=edl.disk_count) do
  begin
   procdisk:=(edl.disk_content+i-1)^; procblock:=(edl.disk_block_content+i-1)^; 
   procdisk^.ReadDisk(procdisk,procblock^.Media^.MediaId,0,sizeof(efi_guid),data);
   if(data.data1=system_graphics_restart_guid.data1) and  (data.data2=system_graphics_restart_guid.data2) and (data.data3=system_graphics_restart_guid.data3) 
   and (data.data4[1]=system_graphics_restart_guid.data4[1]) and (data.data4[2]=system_graphics_restart_guid.data4[2])
   and (data.data4[3]=system_graphics_restart_guid.data4[3]) and (data.data4[4]=system_graphics_restart_guid.data4[4])
   and (data.data4[5]=system_graphics_restart_guid.data4[5]) and (data.data4[6]=system_graphics_restart_guid.data4[6])
   and (data.data4[7]=system_graphics_restart_guid.data4[7]) and (data.data4[8]=system_graphics_restart_guid.data4[8]) and (isgraphics) then
    begin
     Procdisk^.WriteDisk(procdisk,procblock^.Media^.MediaId,0,sizeof(efi_guid),@unused_entry_guid);
     mybool:=true; break;
    end
   else if(data.data1=system_console_restart_guid.data1) and  (data.data2=system_console_restart_guid.data2) and (data.data3=system_console_restart_guid.data3) 
   and (data.data4[1]=system_console_restart_guid.data4[1]) and (data.data4[2]=system_console_restart_guid.data4[2])
   and (data.data4[3]=system_console_restart_guid.data4[3]) and (data.data4[4]=system_console_restart_guid.data4[4])
   and (data.data4[5]=system_console_restart_guid.data4[5]) and (data.data4[6]=system_console_restart_guid.data4[6])
   and (data.data4[7]=system_console_restart_guid.data4[7]) and (data.data4[8]=system_console_restart_guid.data4[8]) then
    begin
     Procdisk^.WriteDisk(procdisk,procblock^.Media^.MediaId,0,sizeof(efi_guid),@unused_entry_guid);
     mybool:=true; break;
    end;
   inc(i,1);
  end;
 if(i>edl.disk_count) then mybool:=false;
 freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
end;
function efi_system_restart_information_get_mode(systemtable:Pefi_system_table):byte;[public,alias:'EFI_SYSTEM_RESTART_INFORMATION_GET_MODE'];
var edl:efi_disk_list;
    procdisk:Pefi_disk_io_protocol;
    procblock:Pefi_block_io_protocol;
    data:efi_guid;
    i:natuint;
    res:byte;
begin
 edl:=efi_detect_disk_write_ability(systemtable); 
 i:=1; res:=0;
 while(i<=edl.disk_count) do
  begin
   procdisk:=(edl.disk_content+i-1)^; procblock:=(edl.disk_block_content+i-1)^; 
   procdisk^.ReadDisk(procdisk,procblock^.Media^.MediaId,0,sizeof(efi_guid),data);
   if(data.data1=system_graphics_restart_guid.data1) and (data.data2=system_graphics_restart_guid.data2) and (data.data3=system_graphics_restart_guid.data3) 
   and (data.data4[1]=system_graphics_restart_guid.data4[1]) and (data.data4[2]=system_graphics_restart_guid.data4[2])
   and (data.data4[3]=system_graphics_restart_guid.data4[3]) and (data.data4[4]=system_graphics_restart_guid.data4[4])
   and (data.data4[5]=system_graphics_restart_guid.data4[5]) and (data.data4[6]=system_graphics_restart_guid.data4[6])
   and (data.data4[7]=system_graphics_restart_guid.data4[7]) and (data.data4[8]=system_graphics_restart_guid.data4[8]) then
    begin
     res:=2; break;
    end
   else if(data.data1=system_console_restart_guid.data1) and (data.data2=system_console_restart_guid.data2) and (data.data3=system_console_restart_guid.data3) 
   and (data.data4[1]=system_console_restart_guid.data4[1]) and (data.data4[2]=system_console_restart_guid.data4[2])
   and (data.data4[3]=system_console_restart_guid.data4[3]) and (data.data4[4]=system_console_restart_guid.data4[4])
   and (data.data4[5]=system_console_restart_guid.data4[5]) and (data.data4[6]=system_console_restart_guid.data4[6])
   and (data.data4[7]=system_console_restart_guid.data4[7]) and (data.data4[8]=system_console_restart_guid.data4[8]) then
    begin
     res:=1; break;
    end;
   inc(i,1);
  end;
 freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
 efi_system_restart_information_get_mode:=res;
end;
function efi_disk_empty_list(systemTable:Pefi_system_table):efi_disk_list;[public,alias:'EFI_DISK_EMPTY_LIST'];
var edl,redl:efi_disk_list;
    procdisk:Pefi_disk_io_protocol;
    procblock:Pefi_block_io_protocol;
    data:qword;
    i,size:natuint;
begin
 edl:=efi_detect_disk_write_ability(systemtable); 
 redl.disk_count:=0;
 redl.disk_content:=allocmem(sizeof(Pointer)*edl.disk_count); 
 redl.disk_block_content:=allocmem(sizeof(Pointer)*edl.disk_count);
 for i:=1 to edl.disk_count do
  begin
   procdisk:=(edl.disk_content+i-1)^; procblock:=(edl.disk_block_content+i-1)^;
   procdisk^.ReadDisk(procdisk,procblock^.Media^.MediaId,0,8,data);
   if(data=0) then 
    begin
     inc(redl.disk_count);
     (redl.disk_content+redl.disk_count-1)^:=procdisk;
     (redl.disk_block_content+redl.disk_count-1)^:=procblock;
    end;
  end;
 size:=getmemsize(redl.disk_content);
 ReallocMem(redl.disk_content,sizeof(Pointer)*redl.disk_count);
 redl.disk_block_content:=Pointer(Pointer(redl.disk_block_content)-size);
 size:=getmemsize(redl.disk_block_content);
 ReallocMem(redl.disk_block_content,sizeof(Pointer)*redl.disk_count);
 redl.disk_content:=Pointer(Pointer(redl.disk_content)-size);
 size:=getmemsize(edl.disk_content)+getmemsize(edl.disk_block_content);
 freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
 redl.disk_block_content:=Pointer(Pointer(redl.disk_block_content)-size);
 redl.disk_content:=Pointer(Pointer(redl.disk_content)-size);
 efi_disk_empty_list:=redl;
end;
function efi_disk_tydq_get_fs_list(systemTable:Pefi_system_table):efi_disk_list;[public,alias:'EFI_DISK_TYDQ_FS_LIST'];
var edl,redl:efi_disk_list;
    procdisk:Pefi_disk_io_protocol;
    procblock:Pefi_block_io_protocol;
    signature:qword;
    i,size:natuint;
begin
 edl:=efi_detect_disk_write_ability(systemtable); 
 redl.disk_count:=0;
 redl.disk_content:=allocmem(sizeof(Pointer)*edl.disk_count); 
 redl.disk_block_content:=allocmem(sizeof(Pointer)*edl.disk_count);
 for i:=1 to edl.disk_count do
  begin
   procdisk:=(edl.disk_content+i-1)^;
   procblock:=(edl.disk_block_content+i-1)^;
   procdisk^.ReadDisk(procdisk,procblock^.Media^.MediaId,0,sizeof(natuint),signature);
   if(signature=$5D47291AD7E3F2B1) then 
    begin
     inc(redl.disk_count);
     (redl.disk_content+redl.disk_count-1)^:=procdisk;
     (redl.disk_block_content+redl.disk_count-1)^:=procblock;
    end;
  end;
 if(redl.disk_count>0) then
  begin
   size:=getmemsize(redl.disk_content);
   ReallocMem(redl.disk_content,sizeof(Pointer)*redl.disk_count);
   redl.disk_block_content:=Pointer(Pointer(redl.disk_block_content)-size);
   size:=getmemsize(redl.disk_block_content);
   ReallocMem(redl.disk_block_content,sizeof(Pointer)*redl.disk_count);
   redl.disk_content:=Pointer(Pointer(redl.disk_content)-size);
   size:=getmemsize(edl.disk_block_content)+getmemsize(edl.disk_content);
   freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
   redl.disk_block_content:=Pointer(Pointer(redl.disk_block_content)-size);
   redl.disk_content:=Pointer(Pointer(redl.disk_content)-size);
  end
 else
  begin
   Freemem(redl.disk_block_content); Freemem(redl.disk_content); redl.disk_count:=0;
   freemem(edl.disk_block_content); freemem(edl.disk_content); edl.disk_count:=0;
  end;
 efi_disk_tydq_get_fs_list:=redl;
end;
procedure efi_disk_tydq_set_fs(edl:efi_disk_list;diskindex:natuint);[public,alias:'EFI_DISK_TYDQ_SET_FS'];
var signature:qword;
    dp:Pefi_disk_io_protocol;
    bp:Pefi_block_io_protocol;
begin
 if(diskindex>edl.disk_count) then exit;
 dp:=(edl.disk_content+diskindex-1)^; bp:=(edl.disk_block_content+diskindex-1)^;
 signature:=$5D47291AD7E3F2B1;
 dp^.WriteDisk(dp,bp^.Media^.MediaId,0,sizeof(natuint),@signature);
end;
procedure efi_console_initialize(systemtable:Pefi_system_table;bck_colour,text_colour:byte;blinkmiliseconds:qword);[public,alias:'EFI_CONSOLE_INITIALIZE'];
begin
 efi_console_set_global_colour(systemtable,bck_colour,text_colour);
 efi_console_clear_screen(systemtable);
 efi_console_get_max_row_and_max_column(systemtable,false);
 efi_console_enable_mouse(systemtable);
 efi_console_enable_mouse_blink(systemtable,true,blinkmiliseconds);
 efi_set_watchdog_timer_to_null(systemtable);
end;
procedure efi_reset_system_warm(systemtable:Pefi_system_table);[public,alias:'EFI_RESET_SYSTEM_WARM'];
begin
 SystemTable^.RuntimeServices^.ResetSystem(EfiResetWarm,efi_success,0,nil);
end;
procedure efi_reset_system_cold(systemtable:Pefi_system_table);[public,alias:'EFI_RESET_SYSTEM_COLD'];
begin
 SystemTable^.RuntimeServices^.ResetSystem(EfiResetCold,efi_success,0,nil);
end;
procedure efi_system_shutdown(systemtable:Pefi_system_table);[public,alias:'EFI_SYSTEM_SHUTDOWN'];
begin
 SystemTable^.RuntimeServices^.ResetSystem(EfiResetShutdown,efi_success,0,nil);
end;
function efi_graphics_initialize(systemtable:Pefi_system_table):efi_graphics_list;[public,alias:'EFI_GRAPHICS_INITITALIZE'];
var i:natuint;
    res:efi_graphics_list;
    ptr:Pefi_handle;
    ptrnum:natuint;
begin
 SystemTable^.BootServices^.LocateHandleBuffer(ByProtocol,@efi_graphics_output_protocol_guid,nil,ptrnum,ptr);
 res.graphics_item:=allocmem(sizeof(Pefi_graphics_output_protocol)*ptrnum); res.graphics_count:=ptrnum;
 for i:=1 to res.graphics_count do SystemTable^.BootServices^.HandleProtocol((ptr+i-1)^,@efi_graphics_output_protocol_guid,(res.graphics_item+i-1)^);
 efi_graphics_initialize:=res;
end;
procedure efi_graphics_get_maxwidth_maxheight_and_maxdepth(egl:efi_graphics_list;eglindex:natuint);[public,alias:'EFI_GRAPHICS_GET_MAXWIDTH_MAXHEIGHT_AND_MAXDEPTH'];
var ptr:Pefi_graphics_output_protocol;
    maxmode,i,status:natuint;
begin
 if(eglindex>egl.graphics_count) then exit;
 ptr:=(egl.graphics_item+eglindex-1)^;
 maxmode:=ptr^.Mode^.MaxMode;
 for i:=0 to maxmode-1 do
  begin
   ptr^.SetMode(ptr,i);
   if(ptr^.Mode^.Info^.PixelFormat=PixelBlueGreenRedReserved8BitPerColor) then 
    begin
     maxscreenwidth:=ptr^.Mode^.Info^.HorizontalResolution;
     maxscreenheight:=ptr^.Mode^.Info^.VerticalResolution;
     graphicsindex:=i;
    end;
  end;
 ptr^.SetMode(ptr,graphicsindex);
end;
procedure efi_graphics_free(var egl:efi_graphics_list);[public,alias:'EFI_GRAPICS_FREE'];
begin
 freemem(egl.graphics_item); egl.graphics_count:=0;
end;
function efi_pointer_initialize(systemtable:Pefi_system_table):efi_pointer_list;[public,alias:'EFI_POINTER_INITIALIZE'];
var i:natuint;
    res:efi_pointer_list;
    ptr:Pefi_handle;
    ptrnum:natuint;
begin
 SystemTable^.BootServices^.LocateHandleBuffer(ByProtocol,@efi_simple_pointer_protocol_guid,nil,ptrnum,ptr);
 res.pointer_item:=allocmem(sizeof(Pefi_simple_pointer_protocol)*ptrnum); res.pointer_count:=ptrnum;
 for i:=1 to res.pointer_count do SystemTable^.BootServices^.HandleProtocol((ptr+i-1)^,@efi_simple_pointer_protocol_guid,(res.pointer_item+i-1)^);
 efi_pointer_initialize:=res;
end;
procedure efi_mouse_initialize(epl:efi_pointer_list;eplindex:natuint);[public,alias:'EFI_MOUSE_INITIALIZE'];
var ptr:Pefi_simple_pointer_protocol;
begin
 if(eplindex>epl.pointer_count) then exit;
 mousestate.mousex:=0; mousestate.mousey:=0; mousestate.mousez:=0;
 mousestate.leftbutton:=false; mousestate.rightbutton:=false;
 ptr:=(epl.pointer_item+eplindex-1)^;
end;
procedure efi_pointer_refresh_cursor(Event:efi_event;Context:Pointer);cdecl;[public,alias:'EFI_POINTER_REFRESH_CURSOR'];
var state:efi_simple_pointer_state;
begin
 Pefi_simple_pointer_protocol(Context)^.GetState(Pefi_simple_pointer_protocol(Context),state);
 Pefi_simple_pointer_protocol(Context)^.Reset(Pefi_simple_pointer_protocol(Context),false);
 if(mousestate.mousex<=-state.RelativeMovementX) then mousestate.mousex:=0
 else if(mousestate.mousex>=maxscreenwidth-state.RelativeMovementX) then mousestate.mousex:=maxscreenwidth
 else mousestate.mousex:=mousestate.mousex+state.RelativeMovementX;
 if(mousestate.mousey<=-state.RelativeMovementY) then mousestate.mousey:=0
 else if(mousestate.mousey>=maxscreenheight-state.RelativeMovementY) then mousestate.mousey:=maxscreenheight
 else mousestate.mousey:=mousestate.mousey+state.RelativeMovementY;
 if(mousestate.mousez<=-state.RelativeMovementZ) then mousestate.mousez:=0
 else if(mousestate.mousez>=maxscreendepth-state.RelativeMovementZ) then mousestate.mousez:=maxscreendepth
 else mousestate.mousez:=mousestate.mousez+state.RelativeMovementZ;
 mousestate.leftbutton:=state.LeftButton;
 mousestate.rightbutton:=state.RightButton;
end;
procedure efi_pointer_enable_cursor(systemtable:Pefi_system_table;epl:efi_pointer_list;pointerindex:natuint;enable:boolean;refreshmilliseconds:qword);[public,alias:'EFI_POINTER_ENABLE_CURSOR'];
begin
 if(pointerindex>epl.pointer_count) then exit;
 if(enable=true) and (mouseenable=false) and (mouseevent=nil) then 
  begin
   SystemTable^.BootServices^.CreateEvent(evt_notify_signal or evt_timer,tpl_callback,@efi_pointer_refresh_cursor,(epl.pointer_item+pointerindex-1)^,mouseevent);
   SystemTable^.BootServices^.SetTimer(Cursorblinkevent,TimerPeriodic,refreshmilliseconds*10000);
   mouseenable:=true;
  end
 else if(enable=false) and (mouseenable=true) and (mouseevent<>nil) then
  begin
   SystemTable^.BootServices^.CloseEvent(mouseevent);
   Cursorblinkevent:=nil;
   mouseenable:=false;
  end;
end;
function efi_absolute_pointer_initialize(systemtable:Pefi_system_table):efi_absolute_pointer_list;[public,alias:'EFI_ABSOLUTE_POINTER_INITIALIZE'];
var i:natuint;
    res:efi_absolute_pointer_list;
    ptr:Pefi_handle;
    ptrnum:natuint;
begin
 SystemTable^.BootServices^.LocateHandleBuffer(ByProtocol,@efi_absolute_pointer_protocol_guid,nil,ptrnum,ptr);
 res.pointer_item:=allocmem(sizeof(Pefi_absolute_pointer_protocol)*ptrnum); res.pointer_count:=ptrnum;
 for i:=1 to res.pointer_count do SystemTable^.BootServices^.HandleProtocol((ptr+i-1)^,@efi_absolute_pointer_protocol_guid,(res.pointer_item+i-1)^);
 efi_absolute_pointer_initialize:=res;
end;
procedure efi_absolute_mouse_initialize(eapl:efi_absolute_pointer_list;eaplindex:natuint);[public,alias:'EFI_ABSOLUTE_MOUSE_INITIALIZE'];
var ptr:Pefi_absolute_pointer_protocol;
begin
 if(eaplindex>eapl.pointer_count) then exit;
 ptr:=(eapl.pointer_item+eaplindex-1)^;
 absolutemousestate.mousex:=0;
 absolutemousestate.mousey:=0;
 absolutemousestate.mousez:=0;
 absolutemousestate.activebutton:=0;
end;
procedure efi_absolute_pointer_refresh_cursor(Event:efi_event;Context:Pointer);cdecl;[public,alias:'EFI_ABSOLUTE_POINTER_REFRESH_CURSOR'];
var ptr:Pefi_absolute_pointer_protocol;
    state:efi_absolute_pointer_state;
begin
 ptr:=Pefi_absolute_pointer_protocol(Context);
 ptr^.GetState(ptr,state);
 absolutemousestate.mousex:=state.CurrentX;
 absolutemousestate.mousey:=state.CurrentY;
 absolutemousestate.mousez:=state.CurrentZ;
 absolutemousestate.activebutton:=state.ActiveButtons;
end;
procedure efi_absolute_pointer_enable_mouse(systemtable:Pefi_system_table;eapl:efi_absolute_pointer_list;eaplindex:natuint;enable:boolean;refreshmilliseconds:qword);[public,alias:'EFI_ABSOLUTE_POINTER_ENABLE_MOUSE'];
begin
 if(eaplindex>eapl.pointer_count) then exit;
 if(enable=true) and (absolutemouseenable=false) and (mouseevent=nil) then
  begin
   SystemTable^.BootServices^.CreateEvent(evt_notify_signal or evt_timer,tpl_callback,@efi_absolute_pointer_refresh_cursor,(eapl.pointer_item+eaplindex-1)^,mouseevent);
   SystemTable^.BootServices^.SetTimer(Cursorblinkevent,TimerPeriodic,refreshmilliseconds*10000);
   mouseenable:=true;
  end
 else if(enable=false) and (absolutemouseenable=true) and (mouseevent<>nil) then
  begin
   SystemTable^.BootServices^.CloseEvent(mouseevent);
   Cursorblinkevent:=nil;
   mouseenable:=false;
  end;
end;
procedure efi_procedure(Event:efi_event;Context:Pointer);cdecl;[public,alias:'EFI_PROCEDURE'];
var ptr:Psys_parameter_function_and_parameter;
begin
 ptr:=Context;
 sys_parameter_function_execute(ptr^);
end;
function efi_create_thread(systemtable:Pefi_system_table;func:sys_parameter_function;param:sys_parameter):efi_handle;[public,alias:'EFI_CREATE_THREAD'];
var funcandparam:sys_parameter_function_and_parameter;
    res:efi_handle;
begin
 funcandparam:=sys_parameter_and_function_construct(param,func,0);
 Systemtable^.BootServices^.CreateEvent(evt_notify_signal or evt_timer,tpl_callback,@efi_procedure,@funcandparam,res);
 efi_create_thread:=res;
end;
procedure efi_start_thread(systemtable:Pefi_system_table;threadhandle:efi_handle);[public,alias:'EFI_START_THREAD'];
begin
 SystemTable^.BootServices^.SetTimer(threadhandle,TimerPeriodic,0);
end;
procedure efi_terminate_thread(systemtable:Pefi_system_table;threadhandle:efi_handle);[public,alias:'EFI_TERMINATE_THREAD'];
begin
 SystemTable^.BootServices^.CloseEvent(threadhandle);
end;
function efi_processor_initialize(systemtable:Pefi_system_table):efi_processor_list;[public,alias:'EFI_PROCESSOR_INITIALIZE'];
var i,j:natuint;
    res:efi_processor_list;
    ptr:Pefi_handle;
    ptritem:Pefi_mp_services_protocol;
    enableap,totalap,bootindex:natuint;
    ptrnum:natuint;
begin
 SystemTable^.BootServices^.LocateHandleBuffer(ByProtocol,@efi_mp_services_protocol_guid,nil,ptrnum,ptr);
 res.processor_item:=allocmem(sizeof(Pefi_mp_services_protocol)*ptrnum);
 res.processor_number:=allocmem(sizeof(natuint)*ptrnum);
 res.processor_bootindex:=allocmem(sizeof(natuint)*ptrnum);
 res.processor_count:=ptrnum;
 for i:=1 to ptrnum do 
  begin
   SystemTable^.BootServices^.HandleProtocol((ptr+i-1)^,@efi_mp_services_protocol_guid,ptritem);
   ptritem^.GetNumberOfProcessors(ptritem,totalap,enableap);
   ptritem^.WhoAmI(ptritem,bootindex);
   for j:=1 to totalap do 
    begin
     if(j-1<>bootindex) then ptritem^.EnableDisableAP(ptritem,j-1,true,nil);
    end;
   (res.processor_item+i-1)^:=ptritem;
   (res.processor_number+i-1)^:=totalap;
   (res.processor_bootindex+i-1)^:=bootindex;
  end;
 efi_processor_initialize:=res;
end;
procedure efi_processor_procedure(ProcedureArgument:Pointer);cdecl;[public,alias:'EFI_PROCESSOR_PROCEDURE'];
var ptr:Psys_parameter_function_and_parameter;
begin
 ptr:=ProcedureArgument;
 sys_parameter_function_execute(ptr^);
end;
procedure efi_processor_event(Event:efi_event;Context:Pointer);cdecl;[public,alias:'EFI_PROCESSOR_EVENT'];
begin
 Pefi_system_table(Context)^.BootServices^.CloseEvent(event);
end;
procedure efi_processor_execute_procedure(systemtable:Pefi_system_table;epl:efi_processor_list;eplindex,processorindex:natuint;func:sys_parameter_function;param:sys_parameter);[public,alias:'EFI_PROCESSOR_EXECUTE_PROCEDURE'];
var funcandparam:sys_parameter_function_and_parameter;
    ptr:Pefi_mp_services_protocol;
    event:efi_event;
    bool:boolean;
begin
 ptr:=(epl.processor_item+eplindex-1)^;
 Systemtable^.BootServices^.CreateEvent(evt_notify_signal or evt_timer,tpl_callback,@efi_processor_event,systemtable,event);
 funcandparam:=sys_parameter_and_function_construct(param,func,0);
 ptr^.StartUpThisAP(ptr,@efi_processor_procedure,processorindex,event,0,@funcandparam,bool);
end;
procedure efi_processor_free(var epl:efi_processor_list);[public,alias:'EFI_PROCESSOR_FREE'];
begin
 freemem(epl.processor_bootindex); freemem(epl.processor_number); freemem(epl.processor_item); epl.processor_count:=0;
end;

end.
