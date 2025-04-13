unit smbios;

interface

const smbios_type_firmware_information:byte=$00;
      smbios_type_system_infomation:byte=$01;
      smbios_type_baseboard_information:byte=$02;
      smbios_type_system_enclosure:byte=$03;
      smbios_type_processor_information:byte=$04;
      smbios_type_memory_controller_information:byte=$05;
      smbios_type_memory_module_information:byte=$06;
      smbios_type_cache_information:byte=$07;
      smbios_type_port_connector_information:byte=$08;
      smbios_type_system_plots:byte=$09;
      smbios_type_onboard_device_information:byte=$0A;
      smbios_type_oem_string:byte=$0B;
      smbios_type_system_configuration_options:byte=$0C;
      smbios_type_bios_language_information:byte=$0D;
      smbios_type_group_associations:byte=$0E;
      smbios_type_system_event_log:byte=$0F;
      smbios_type_physical_memory_array:byte=$10;
      smbios_type_memory_device:byte=$11;
      smbios_type_32bit_memory_error_information:byte=$12;
      smbios_type_memory_array_mapped_address:byte=$13;
      smbios_type_memory_device_mapped_address:byte=$14;
      smbios_type_built_in_pointing_device:byte=$15;
      smbios_type_portable_battery:byte=$16;
      smbios_type_system_rest:byte=$17;
      smbios_type_hardware_security:byte=$18;
      smbios_type_system_power_controls:byte=$19;
      smbios_type_voltage_probe:byte=$1A;
      smbios_type_cooling_device:byte=$1B;
      smbios_type_temperature_probe:byte=$1C;
      smbios_type_electrical_current_probe:byte=$1D;
      smbios_type_out_of_band_remote_access:byte=$1E;
      smbios_type_boot_integrity_service:byte=$1F;
      smbios_type_system_boot_information:byte=$20;
      smbios_type_64bit_memory_error_information:byte=$21;
      smbios_type_management_device:byte=$22;
      smbios_type_management_device_component:byte=$23;
      smbios_type_management_device_threshold_data:byte=$24;
      smbios_type_memory_channel:byte=$25;
      smbios_type_ipmi_device_configuration:byte=$26;
      smbios_type_system_power_supply:byte=$27;
      smbios_type_additional_information:byte=$28;
      smbios_type_onboard_devices_extended_information:byte=$29;
      smbios_type_management_controller_host_interface:byte=$2A;
      smbios_type_inactive:byte=$7E;
      smbios_type_end_of_table:byte=$7F;
      smbios_type_oem_begin:byte=$80;
      smbios_type_oem_end:byte=$FF;
      {System Information Specified Only}
      smbios_system_information_wake_up_type_reserved:byte=$0;
      smbios_system_information_wake_up_type_other:byte=$1;
      smbios_system_information_wake_up_type_unknown:byte=$2;
      smbios_system_information_wake_up_type_apm_timer:byte=$3;
      smbios_system_information_wake_up_type_modern_ring:byte=$4;
      smbios_system_information_wake_up_type_lan_remote:byte=$5;
      smbios_system_information_wake_up_type_power_switch:byte=$6;
      smbios_system_information_wake_up_type_pci_pme:byte=$7;
      smbios_system_information_wake_up_ac_power_restored:byte=$8;
      {Baseboard Information Specified Only}
      smbios_baseboard_type_unknown:byte=$1;
      smbios_baseboard_type_other:byte=$2;
      smbios_baseboard_type_server_blade:byte=$3;
      smbios_baseboard_type_connectivity_switch:byte=$4;
      smbios_baseboard_type_system_management_module:byte=$5;
      smbios_baseboard_processor_module:byte=$6;
      smbios_baseboard_io_module:byte=$7;
      smbios_baseboard_memory_module:byte=$8;
      smbios_baseboard_daughter_board:byte=$9;
      smbios_baseboard_mother_board:byte=$A;
      smbios_baseboard_processor_or_memory_module:byte=$B;
      smbios_baseboard_processor_or_io_module:byte=$C;
      smbios_baseboard_interconnect_board:byte=$D;
      {System Enclosure or chassis Specified Only}
      smbios_system_enclosure_or_chassis_type_other:byte=$1;
      smbios_system_enclosure_or_chassis_type_unknown:byte=$2;
      smbios_system_enclosure_or_chassis_type_desktop:byte=$3;
      smbios_system_enclosure_or_chassis_type_low_profile_desktop:byte=$4;
      smbios_system_enclosure_or_chassis_type_pizza_box:byte=$5;
      smbios_system_enclosure_or_chassis_type_mini_tower:byte=$6;
      smbios_system_enclosure_or_chassis_type_tower:byte=$7;
      smbios_system_enclosure_or_chassis_type_portable:byte=$8;
      smbios_system_enclosure_or_chassis_type_laptop:byte=$9;
      smbios_system_enclosure_or_chassis_type_notebook:byte=$A;
      smbios_system_enclosure_or_chassis_type_hand_held:byte=$B;
      smbios_system_enclosure_or_chassis_type_docking_station:byte=$C;
      smbios_system_enclosure_or_chassis_type_all_in_one:byte=$D;
      smbios_system_enclosure_or_chassis_type_sub_notebook:byte=$E;
      smbios_system_enclosure_or_chassis_type_space_saving:byte=$F;
      smbios_system_enclosure_or_chassis_type_lunch_box:byte=$10;
      smbios_system_enclosure_or_chassis_type_main_server_chassis:byte=$11;
      smbios_system_enclosure_or_chassis_type_expansion_chassis:byte=$12;
      smbios_system_enclosure_or_chassis_type_sub_chassis:byte=$13;
      smbios_system_enclosure_or_chassis_type_bus_expansion_chassis:byte=$14;
      smbios_system_enclosure_or_chassis_type_peripheral_chassis:byte=$15;
      smbios_system_enclosure_or_chassis_type_raid_chassis:byte=$16;
      smbios_system_enclosure_or_chassis_type_rack_mount_chassis:byte=$17;
      smbios_system_enclosure_or_chassis_type_sealed_case_pc:byte=$18;
      smbios_system_enclosure_or_chassis_type_multi_system_chassis:byte=$19;
      smbios_system_enclosure_or_chassis_type_compact_pci:byte=$1A;
      smbios_system_enclosure_or_chassis_type_advanced_bca:byte=$1B;
      smbios_system_enclosure_or_chassis_type_blade:byte=$1C;
      smbios_system_enclosure_or_chassis_type_blade_enclosure:byte=$1D;
      smbios_system_enclosure_or_chassis_type_tablet:byte=$1E;
      smbios_system_enclosure_or_chassis_type_convertible:byte=$1F;
      smbios_system_enclosure_or_chassis_type_detachable:byte=$20;
      smbios_system_enclosure_or_chassis_type_IOT_Gateway:byte=$21;
      smbios_system_enclosure_or_chassis_type_embedded_PC:byte=$22;
      smbios_system_enclosure_or_chassis_type_mini_PC:byte=$23;
      smbios_system_enclosure_or_chassis_type_stick_PC:byte=$24;
      smbios_system_enclosure_or_chassis_state_other:byte=$1;
      smbios_system_enclosure_or_chassis_state_unknown:byte=$2;
      smbios_system_enclosure_or_chassis_state_safe:byte=$3;
      smbios_system_enclosure_or_chassis_state_warning:byte=$4;
      smbios_system_enclosure_or_chassis_state_criticial:byte=$5;
      smbios_system_enclosure_or_chassis_state_non_recoverable:byte=$6;
      smbios_system_enclosure_or_chassis_security_status_other:byte=$1;
      smbios_system_enclosure_or_chassis_security_status_unknown:byte=$2;
      smbios_system_enclosure_or_chassis_security_status_none:byte=$3;
      smbios_system_enclosure_or_chassis_security_status_external_interface_locked_out:byte=$4;
      smbios_system_enclosure_or_chassis_security_status_external_interface_enabled:byte=$5;
      {Processor Information Specified}
      smbios_processor_information_type_other:byte=$01;
      smbios_processor_information_type_unknown:byte=$02;
      smbios_processor_information_type_central_processor:byte=$03;
      smbios_processor_information_type_math_processor:byte=$04;
      smbios_processor_information_type_dsp_processor:byte=$05;
      smbios_processor_information_type_video_processor:byte=$06;
      smbios_processor_information_family_other:word=$1;
      smbios_processor_information_family_unknown:word=$2;
      smbios_processor_information_family_8086:word=$3;
      smbios_processor_information_family_80286:word=$4;
      smbios_processor_information_family_intel386:word=$5;
      smbios_processor_information_family_intel486:word=$6;
      smbios_processor_information_family_8087:word=$7;
      smbios_processor_information_family_80287:word=$8;
      smbios_processor_information_family_80387:word=$9;
      smbios_processor_information_family_80487:word=$A;
      smbios_processor_information_family_intel_pentium:word=$B;
      smbios_processor_information_family_intel_pentium_pro:word=$C;
      smbios_processor_information_family_intel_pentium_2:word=$D;
      smbios_processor_information_family_intel_pentium_with_mmx:word=$E;
      smbios_processor_information_family_intel_celeron:word=$F;
      smbios_processor_information_family_pentium_2_xeon:word=$10;
      smbios_processor_information_family_pentium_3:word=$11;
      smbios_processor_information_family_m1_family:word=$12;
      smbios_processor_information_family_m2_family:word=$13;
      smbios_processor_information_family_intel_celeron_m:word=$14;
      smbios_processor_information_family_intel_pentium_4_ht:word=$15;
      smbios_processor_information_family_intel:word=$16;
      smbios_processor_information_family_AMD_Duron_family:word=$18;
      smbios_processor_information_family_k5_family:word=$19;
      smbios_processor_information_family_k6_family:word=$1A;
      smbios_processor_information_family_k6_2:word=$1B;
      smbios_processor_information_family_k6_3:word=$1C;
      smbios_processor_information_family_AMD_Athlon_family:word=$1D;
      smbios_processor_information_family_AMD_29000_family:word=$1E;
      smbios_processor_information_family_k6_2_plus:word=$1F;
      smbios_processor_information_family_power_pc_family:word=$20;
      smbios_processor_information_family_power_pc_601:word=$21;
      smbios_processor_information_family_power_pc_603:word=$22;
      smbios_processor_information_family_power_pc_603_plus:word=$23;
      smbios_processor_information_family_power_pc_604:word=$24;
      smbios_processor_information_family_power_pc_620:word=$25;
      smbios_processor_information_family_power_pc_x704:word=$26;
      smbios_processor_information_family_power_pc_750:word=$27;
      smbios_processor_information_family_intel_core_duo:word=$28;
      smbios_processor_information_family_intel_core_duo_mobile:word=$29;
      smbios_processor_information_family_intel_core_solo_mobile:word=$2A;
      smbios_processor_information_family_intel_atom:word=$2B;
      smbios_processor_information_family_intel_core_m:word=$2C;
      smbios_processor_information_family_intel_core_m3:word=$2D;
      smbios_processor_information_family_intel_core_m5:word=$2E;
      smbios_processor_information_family_intel_core_m7:word=$2F;
      smbios_processor_information_family_alpha_family:word=$30;
      smbios_processor_information_family_alpha_21064:word=$31;
      smbios_processor_information_family_alpha_21066:word=$32;
      smbios_processor_information_family_alpha_21164:word=$33;
      smbios_processor_information_family_alpha_21164_pc:word=$34;
      smbios_processor_information_family_alpha_21164_a:word=$35;
      smbios_processor_information_family_alpha_21264:word=$36;
      smbios_processor_information_family_alpha_21364:word=$37;
      smbios_processor_information_family_AMD_turon_2_ultra_dual_core_mobile_m_processor_family:word=$38;
      smbios_processor_information_family_AMD_turon_2_dual_core_mobile_m_processor_family:word=$39;
      smbios_processor_information_family_AMD_Athlon_Dual_core_M_processor_family:word=$3A;
      smbios_processor_information_family_AMD_opteron_6100:word=$3B;
      smbios_processor_information_family_AMD_opteron_4100:word=$3C;
      smbios_processor_information_family_AMD_opteron_6200:word=$3D;
      smbios_processor_information_family_AMD_opteron_4200:word=$3E;
      smbios_processor_information_family_AMD_FX_Series_Processor:word=$3F;
      smbios_processor_information_family_MIPS_family:word=$40;

type smbios_structure_header=packed record
                             SMType:byte;
                             Length:byte;
                             Handle:word;
                             end; 
     {SMBIOS Firmware information}
     smbios_firmware_characteristics=bitpacked record
                                     Reserved1:0..2;
                                     Unknown:0..1;
                                     CharacteristicsNotSupported:0..1;
                                     ISASupported:0..1;
                                     MCASupported:0..1;
                                     EISASupported:0..1;
                                     PCISupported:0..1;
                                     PCMICASupported:0..1;
                                     PlugAndPlaySupported:0..1;
                                     APMSupported:0..1;
                                     FirmwareIsUpgradable:0..1;
                                     FirmwareShadowingIsAllowed:0..1;
                                     VLVESAIsSupported:0..1;
                                     ESCDsupportAvailable:0..1;
                                     BootFromCDSupported:0..1;
                                     SelectableBootIsSupported:0..1;
                                     FirmwareROMSocketed:0..1;
                                     BootFromPCMICASupported:0..1;
                                     EDDSpecificationSupported:0..1;
                                     NECFloppySupported:0..1;
                                     ToshibaFloppySupported:0..1;
                                     Floppy360KBSupported:0..1;
                                     Floppy1_44MBSupported:0..1;
                                     Floppy720KBSupported:0..1;
                                     Floppy2_88MBSupported:0..1;
                                     PrintScreenServiceSupported:0..1;
                                     keyboard8042Supported:0..1;
                                     SerialServicesSupported:0..1;
                                     PrinterServicesSupported:0..1;
                                     NECPC98:0..1;
                                     Reserved2:0..65535;
                                     Reserved3:0..65535;
                                     end;
     smbios_firmware_extended_characteristics=bitpacked record
                                              AcpiSupport:0..1;
                                              USBLegacySupport:0..1;
                                              AGPSupport:0..1;
                                              I2OBootSupported:0..1;
                                              LS120SuperDiskSupport:0..1;
                                              ATAPIZIPdrivebootSupport:0..1;
                                              boot1394Support:0..1;
                                              SmartBatterySupported:0..1;
                                              BIOSBootSpecificationSupport:0..1;
                                              Functionkeyinitiatednetworkserviceboot:0..1;
                                              Enabletargetedcontentdistribution:0..1;
                                              UEFIspecificationSupport:0..1;
                                              SMBIOSTableDescriptAVirtualMachine:0..1;
                                              ManufacturingModeEnable:0..1;
                                              Reserved:0..1;
                                              end;
     smbios_firmware_information_structure=packed record
                                           Header:smbios_structure_header;
                                           Vendor:byte;
                                           FirmWareVersion:byte;
                                           BIOSStartingAddressSegment:word;
                                           FirmwareReleaseDate:byte;
                                           FirmwareROMSize:byte;
                                           FirmwareCharacteristics:smbios_firmware_characteristics;
                                           FirmwareExtendedCharacteristics:smbios_firmware_extended_characteristics;
                                           PlatformFirmwareMajorRelease:byte;
                                           PlatformFirmwareMinorRelease:byte;
                                           EmbeddedControllerFirmwareMajorRelease:byte;
                                           EmbeddedControllerFirmwareMinorRelease:byte;
                                           ExtendedFirmwareRomSize:word;
                                           end;
     Psmbios_firmware_information_structure=^smbios_firmware_information_structure;
     {SMBIOS System Information}
     smbios_system_information_uuid=packed record
                                    TimeLow:dword;
                                    TimeMid:word;
                                    TimeHighAndVersion:word;
                                    ClockSequenceHighAndReserved:byte;
                                    ClockSequenceLow:byte;
                                    Node:array[1..6] of byte;
                                    end;
     smbios_system_information_structure=packed record
                                         Header:smbios_structure_header;
                                         Manufacturer:byte;
                                         ProductName:byte;
                                         Version:byte;
                                         SerialVersion:byte;
                                         UUID:smbios_system_information_uuid;
                                         WakeUpType:byte;
                                         SKUNumber:byte;
                                         Family:byte;
                                         end;
     Psmbios_system_information_structure=^smbios_system_infomation_structure;
     {SMBIOS Baseboard Information}
     smbios_baseboard_feature_flag=bitpacked record
                                   IsHostingBoard:0..1;
                                   RequireChildBoard:0..1;
                                   Removable:0..1;
                                   Replaceable:0..1;
                                   HotSwappable:0..1;
                                   Reserved:0..7;
                                   end;
     smbios_baseboard_information_structure=packed record
                                            Header:smbios_structure_header;
                                            Manufacturer:byte;
                                            Product:byte;
                                            Version:byte;
                                            SerialNumber:byte;
                                            AssetTag:byte;
                                            FeatureFlag:smbios_baseboard_feature_flag;
                                            LocationInChassis:byte;
                                            ChassisHandle:byte;
                                            BoardType:byte;
                                            NumberOfContainedObjectHandles:byte;
                                            ContainedObjectHandles:array[1..1] of word;
                                            end;
     Psmbios_baseboard_information_structure=^smbios_baseboard_information_structure;
     {SMBIOS System Enclosure or Chassis}
     smbios_system_enclosure_or_chassis_contained_elements=packed record
                                                           ContainedElementType:byte;
                                                           ContainedElementMinimum:byte;
                                                           ContainedElementMaximum:byte;
                                                           end;
     Psmbios_system_enclosure_or_chassis_contained_elements=^smbios_system_enclosure_or_chassis_contained_elements;
     smbios_system_enclosure_or_chassis_structure=packed record
                                                  header:smbios_structure_header;
                                                  Manufacturer:byte;
                                                  SMType:byte;
                                                  Version:byte;
                                                  SerialNumber:byte;
                                                  AssetTagNumber:byte;
                                                  BootUpState:byte;
                                                  PowerSupplyState:byte;
                                                  ThermalState:byte;
                                                  SecurityStatus:byte;
                                                  OEMdefined:dword;
                                                  Height:byte;
                                                  NumberOfPowerCards:byte;
                                                  ContainedElementCount:byte;
                                                  ContainedElementRecordLength:byte;
                                                  ContainedElements:array[1..1] of byte;
                                                  //SKUNumber:byte;
                                                  end;
     Psmbios_system_enclosure_or_chassis_structure=^smbios_system_enclosure_or_chassis_structure;
     {SMBIOS Processor Information}
     smbios_processor_information_structure=packed record
                                            Header:smbios_structure_header;
                                            SocketDesignation:byte;
                                            ProcessorType:byte;
                                            ProcessorFamily:byte;
                                            ProcessorManufacturer:byte;
                                            ProcessorID:qword;
                                            ProcessorVersion:byte;
                                            Voltage:byte;
                                            ExternalClock:word;
                                            MaxSpeed:word;
                                            CurrentSpeed:word;
                                            Status:byte;
                                            ProcessorUpgrade:byte;
                                            L1CacheHandle:word;
                                            L2CacheHandle:word;
                                            L3CacheHandle:word;
                                            SerialNumber:byte;
                                            AssetTag:byte;
                                            PartNumber:byte;
                                            CoreCount:byte;
                                            CoreEnabled:byte;
                                            ThreadCount:byte;
                                            ProcessorCharacteristics:word;
                                            ProcessorFamily2:byte;
                                            CoreCount2:word;
                                            CoreEnabled2:word;
                                            ThreadCount2:word;
                                            ThreadEnabled:word;
                                            SocketType:byte;
                                            end;
      
implementation

end.
