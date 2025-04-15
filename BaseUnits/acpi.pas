unit acpi;

interface
      {ACPI Header Signature}
const acpi_rsdp_signature:array[1..8] of char=('R','S','D',' ','P','T','R',' ');
      acpi_rsdt_signature:array[1..4] of char=('R','S','D','T');
      acpi_xsdt_signature:array[1..4] of char=('X','S','D','T');
      acpi_fadt_signature:array[1..4] of char=('F','A','C','P');
      acpi_facs_signature:array[1..4] of char=('F','A','C','S');
      acpi_dsdt_signature:array[1..4] of char=('D','S','D','T');
      acpi_ssdt_signature:array[1..4] of char=('S','S','D','T');
      acpi_psdt_signature:array[1..4] of char=('P','S','D','T');
      acpi_madt_signature:array[1..4] of char=('A','P','I','C');
      acpi_sbst_signature:array[1..4] of char=('S','B','S','T');
      acpi_ecdt_signature:array[1..4] of char=('E','C','D','T');
      acpi_srat_signature:array[1..4] of char=('S','R','A','T');
      acpi_slit_signature:array[1..4] of char=('S','L','I','T');
      acpi_cpep_signature:array[1..4] of char=('C','P','E','P');
      acpi_msct_signature:array[1..4] of char=('M','S','C','T');
      acpi_rasf_signature:array[1..4] of char=('R','A','S','F');
      acpi_ras2_signature:array[1..4] of char=('R','A','S','2');
      acpi_mpst_signature:array[1..4] of char=('M','P','S','T');
      acpi_pmtt_signature:array[1..4] of char=('P','M','T','T');
      acpi_bgrt_signature:array[1..4] of char=('B','G','R','T');
      acpi_fpdt_signature:array[1..4] of char=('F','P','D','T');
      acpi_fpbt_signature:array[1..4] of char=('F','P','B','T');
      acpi_s3pt_signature:array[1..4] of char=('S','3','P','T');
      acpi_gtdt_signature:array[1..4] of char=('G','T','D','T');
      acpi_nfit_signature:array[1..4] of char=('N','F','I','T');
      acpi_sdev_signature:array[1..4] of char=('S','D','E','V');
      acpi_hmat_signature:array[1..4] of char=('H','M','A','T');
      acpi_pdtt_signature:array[1..4] of char=('P','D','T','T');
      acpi_pptt_signature:array[1..4] of char=('P','P','T','T');
      acpi_phat_signature:array[1..4] of char=('P','H','A','T');
      acpi_viot_signature:array[1..4] of char=('V','I','O','T');
      acpi_misc_signature:array[1..4] of char=('M','I','S','C');
      acpi_ccel_signature:array[1..4] of char=('C','C','E','L');
      acpi_skvl_signature:array[1..4] of char=('S','K','V','L');
      {ACPI MADT Specified Type}
      acpi_madt_processor_local_apic:byte=0;
      acpi_madt_io_apic:byte=1;
      acpi_madt_interrupt_source_override:byte=2;
      acpi_madt_nmi_source:byte=3;
      acpi_madt_local_apic_nmi:byte=4;
      acpi_madt_local_apic_address_override:byte=5;
      acpi_madt_io_sapic:byte=6;
      acpi_madt_local_sapic:byte=7;
      acpi_madt_platform_interrupt_sources:byte=8;
      acpi_madt_processor_local_2_apic:byte=9;
      acpi_madt_local_2_apic_nmi:byte=10;
      acpi_madt_gic_cpu_interface:byte=11;
      acpi_madt_gic_distributor:byte=12;
      acpi_madt_gic_msi_frame:byte=13;
      acpi_madt_gic_redsitributor:byte=14;
      acpi_madt_gic_interrupt_translation_service:byte=15;
      acpi_madt_multiprocessor_wakeup:byte=16;
      acpi_madt_core_programmable_interrupt_controller:byte=17;
      acpi_madt_legacy_io_programmable_interrupt_controller:byte=18;
      acpi_madt_HyperTransport_Programmable_Interrupt_Controller:byte=19;
      acpi_madt_Extended_io_programmable_interrupt_controller:byte=20;
      acpi_madt_MSI_programmable_interrupt_controller:byte=21;
      acpi_madt_Bridge_io_programmable_interrupt_controller:byte=22;
      acpi_madt_low_pin_count_programmable_interrupt_controller:byte=23;
      acpi_madt_reserved:byte=24;
      {For ACPI MADT GICD Structure}
      acpi_madt_gic_version_no_specified:byte=0;
      acpi_madt_gic_version_v1:byte=1;
      acpi_madt_gic_version_v2:byte=2;
      acpi_madt_gic_version_v3:byte=3;
      acpi_madt_gic_version_v4:byte=4;
      {For ACPI MADT Mutliprocessor Wakeup Structure}
      acpi_madt_multiprocessor_wakeup_noop:word=0;
      acpi_madt_multiprocessor_wakeup_wakeup:word=1;
      {For ACPI SRAT structure}
      acpi_srat_processor_local_apic_or_sapic_affinity:byte=0;
      acpi_srat_memory_affinity:byte=1;
      acpi_srat_processor_local_2_apic:byte=2;
      acpi_srat_gicc_affinity:byte=3;
      acpi_srat_gic_its_affinity:byte=4;
      acpi_srat_generic_initiator_affinity:byte=5;
      acpi_srat_generic_port_affinity:byte=6;
      {For ACPI Device Handle}
      acpi_srat_acpi_device_handle:byte=0;
      acpi_srat_pci_device_handle:byte=1;
      {For ACPI CPEP}
      acpi_cpep_for_apic_sapic_based_processors:byte=0;
      {For ACPI RASF}
      acpi_rasf_sub_channel_signature:dword=$52415346;
      acpi_rasf_command_execute_rasf_command:byte=$1;
      acpi_rasf_ras_capabilities_status_success:dword=$0;
      acpi_rasf_ras_capabilities_status_not_vaild:dword=$1;
      acpi_rasf_ras_capabilities_status_not_supported:dword=$2;
      acpi_rasf_ras_capabilities_status_busy:dword=$3;
      acpi_rasf_ras_capabilities_status_failed:dword=$4;
      acpi_rasf_ras_capabilities_status_aborted:dword=$5;
      acpi_rasf_ras_capabilities_status_invaild_data:dword=$6;
      acpi_rasf_patrol_scrub:word=$0000;
      {For ACPI RAS2}
      acpi_ras2_ras_capabilities_status_success:dword=$0;
      acpi_ras2_ras_capabilities_status_not_vaild:dword=$1;
      acpi_ras2_ras_capabilities_status_not_supported:dword=$2;
      acpi_ras2_ras_capabilities_status_busy:dword=$3;
      acpi_ras2_ras_capabilities_status_failed:dword=$4;
      acpi_ras2_ras_capabilities_status_aborted:dword=$5;
      acpi_ras2_ras_capabilities_status_invaild_data:dword=$6;
      acpi_ras2_sub_channel_signature_base:dword=$50434300;
      acpi_ras2_feature_related_to_memory:byte=0;
      acpi_ras2_feature_reserved_for_future_use:byte=1;
      acpi_ras2_feature_vendor_defined:byte=$80;
      acpi_ras2_command_execute_rasf_command:byte=$1;
      acpi_ras2_la2pa_translation_status_succeed:dword=0;
      acpi_ras2_la2pa_translation_status_failed:dword=1;
      {For ACPI MPST}
      acpi_mspt_pcc_signature_base:dword=$50434300;
      acpi_mpst_execute_mpst_command:word=$3;
      {For ACPI PMTT}
      acpi_pmtt_socket:byte=0;
      acpi_pmtt_memory_controller:byte=1;
      acpi_pmtt_dimm:byte=2;
      acpi_pmtt_reserved:byte=3;
      acpi_pmtt_vendor_specific:byte=$FF;
      {For ACPI FPDT}
      acpi_fpdt_boot_basic_boot_performance_pointer_record:word=$0;
      acpi_fpdt_boot_s3_performance_table_pointer_record:word=$1;
      acpi_fpdt_runtime_s3_resume_record:word=$0;
      acpi_fpdt_runtime_s3_suspend_record:word=$1;
      acpi_fpdt_runtime_basic_boot_performance_pointer_record:word=$2;
      {For ACPI GTDT}
      acpi_gtdt_gt_block:byte=$0;
      acpi_gtdt_arm_generic_watchdog:byte=$1;
      {For ACPI NFIT}
      acpi_nfit_type_system_physical_address_range_structure:word=$0;
      acpi_nfit_type_nvdimm_region_mapping_structure:word=$1;
      acpi_nfit_type_interleave_structure:word=$2;
      acpi_nfit_type_smbios_management_information_structure:word=$3;
      acpi_nfit_type_nvdimm_control_region_structure:word=$4;
      acpi_nfit_type_nvdimm_block_data_window_region_structure:word=$5;
      acpi_nfit_type_flush_hint_address_structure:word=$6;
      acpi_nfit_type_platform_capabilities_structure:word=$7;
      acpi_nfit_type_reserved:word=$8;
      {For ACPI SDEV}
      acpi_sdev_type_acpi_namespace_device_secure_device:byte=0;
      acpi_sdev_pcie_endpoint_device_based_secure_device:byte=1;
      acpi_sdev_other_secure_device:byte=2;
      acpi_sdev_secure_access_component_types_idbased:byte=0;
      acpi_sdev_secure_access_component_types_memorybased:byte=1;
      {For ACPI HMAT}
      acpi_hmat_type_memory_proximity_domain_attributes_structure:word=0;
      acpi_hmat_type_system_locality_latency_and_bandwidth_information_structure:word=1;
      acpi_hmat_type_memory_side_cache_information_structure:word=2;
      acpi_hmat_data_type_access_latency:byte=0;
      acpi_hmat_data_type_read_latency:byte=1;
      acpi_hmat_data_type_write_latency:byte=2;
      acpi_hmat_data_type_access_bandwidth:byte=3;
      acpi_hmat_data_type_read_bandwidth:byte=4;
      acpi_hmat_data_type_write_bandwidth:byte=5;
      {For ACPI PDTT}
      acpi_pdtt_PCC_command_code_execute_platform_debug_trigger_doorbell_only:byte=0;
      acpi_pdtt_PCC_command_code_execute_platform_debug_trigger_vendor_specific:byte=1;
      {For ACPI PPTT}
      acpi_pptt_type_processor_hierarchy_node_structure:byte=0;
      acpi_pptt_type_cache_type_structure:byte=1;
      {For ACPI PHAT}
      acpi_phat_type_firmware_version_data_record:byte=0;
      acpi_phat_type_firmware_health_data_record:byte=1;
      acpi_phat_amhealthy_error_found:byte=0;
      acpi_phat_amhealthy_no_error_found:byte=1;
      acpi_phat_amhealthy_unknown:byte=2;
      acpi_phat_amhealthy_advisory:byte=3;
      acpi_phat_sub_source_operatingsystem:byte=1;
      acpi_phat_sub_source_hypervisior:byte=2;
      acpi_phat_unknown:byte=0;
      acpi_phat_cold_boot:byte=1;
      acpi_phat_cold_reset:byte=2;
      acpi_phat_warm_reset:byte=3;
      acpi_phat_update:byte=4;
      acpi_phat_unexpected_reset:byte=32;
      acpi_phat_fault:byte=33;
      acpi_phat_timeout:byte=34;
      acpi_phat_thermal:byte=35;
      acpi_phat_power_less:byte=36;
      acpi_phat_power_button:byte=37;
      {For ACPI VIOT}
      acpi_viot_pci_range_structure:byte=1;
      acpi_viot_mmio_endpoint_structure:byte=2;
      acpi_viot_virtio_pci_range_structure:byte=3;
      acpi_viot_virtio_mmio_range_structure:byte=4;
      {For ACPI CCEL}
      acpi_ccel_amd_sev:byte=1;
      acpi_ccel_intel_tdx:byte=2;
      {For ACPI SKVL}
      acpi_skvl_main_storage_volume_key:byte=0;
      acpi_skvl_raw_binary:byte=0;
      {For ACPI Item}
      acpi_type_rsdp:byte=0;
      acpi_type_rsdt:byte=1;
      acpi_type_xsdt:byte=2;
      acpi_type_fadt:byte=3;
      acpi_type_facs:byte=4;
      acpi_type_dsdt:byte=5;
      acpi_type_ssdt:byte=6;
      acpi_type_madt:byte=7;
      acpi_type_psdt:byte=8;
      acpi_type_sbst:byte=9;
      acpi_type_ecdt:byte=10;
      acpi_type_slit:byte=11;
      acpi_type_srat:byte=12;
      acpi_type_cpep:byte=13;
      acpi_type_msct:byte=14;
      acpi_type_rasf:byte=15;
      acpi_type_ras2:byte=16;
      acpi_type_mpst:byte=17;
      acpi_type_pmtt:byte=18;
      acpi_type_bgrt:byte=19;
      acpi_type_fpdt:byte=20;
      acpi_type_gtdt:byte=21;
      acpi_type_nfit:byte=22;
      acpi_type_hmat:byte=23;
      acpi_type_pdtt:byte=24;
      acpi_type_pptt:byte=25;
      acpi_type_sdev:byte=26;
      acpi_type_phat:byte=27;
      acpi_type_viot:byte=28;
      acpi_type_misc:byte=29;
      acpi_type_ccel:byte=30;
      acpi_type_skvl:byte=31;

type acpi_uint96=array[1..3] of dword;
     acpi_int96=packed record
                Low:array[1..2] of dword;
                High:Integer;
                end;
     acpi_uint128=array[1..4] of dword;
     acpi_int128=packed record
                 Low:array[1..3] of dword;
                 High:Integer;
                 end;
     acpi_guid=packed record
               data1:dword;
               data2:word;
               data3:word;
               data4:array[1..8] of byte;
               end;
     Pacpi_guid=^acpi_guid;
     {ACPI Device Handle}
     acpi_device_handle_acpi=packed record
                             acpi_hid:qword;
                             acpi_uid:dword;
                             Reserved:dword;
                             end;
     acpi_device_handle_pci=packed record
                            PCISegment:word;
                            PCIBDFNumber:word;
                            Reserved:array[1..3] of dword;
                            end;
     acpi_device_handle=packed record
                        case Boolean of
                        True:(acpi:acpi_device_handle_acpi;);
                        False:(pci:acpi_device_handle_pci;);
                        end;
     {ACPI Root System Descriptor Pointer}
     acpi_rsdp=packed record
               signature:array[1..8] of char;
               checksum:byte;
               oemid:array[1..6] of char;
               revision:byte;
               rsdtaddress:dword;
               length:dword;
               xsdtaddress:qword;
               extendedchecksum:byte;
               reserved:array[1..3] of byte;
               end;
     Pacpi_rsdp=^acpi_rsdp;
     {ACPI System Description Table Header}
     acpi_sdth=packed record
               signature:array[1..4] of char;
               length:dword;
               revision:byte;
               checksum:byte;
               oemid:array[1..6] of char;
               oemtableid:array[1..8] of char;
               oemrevision:dword;
               CreatorId:dword;
               CreatorRevision:dword;
               end;
     {ACPI Root System Description Table}
     acpi_rsdt=packed record
               hdr:acpi_sdth;
               Entry:array[1..1] of dword;
               end;
     Pacpi_rsdt=^acpi_rsdt;
     {ACPI Extended System Description Table}
     acpi_xsdt=packed record
               hdr:acpi_sdth;
               Entry:array[1..1] of qword;
               end;
     Pacpi_xsdt=^acpi_xsdt;
     {ACPI Fixed ACPI Description Table}
     acpi_fadt_hdr=packed record
                   signature:array[1..4] of char;
                   length:dword;
                   fadtMajorVersion:byte;
                   checksum:byte;
                   oemid:array[1..6] of char;
                   oemtableid:array[1..8] of char;
                   oemrevision:dword;
                   CreatorId:dword;
                   CreatorRevision:dword;
                   end;
     acpi_fadt_iapc_boot_arch=bitpacked record
                              LegacyDevices:0..1;
                              microcontroller8042:0..1;
                              VGANotPresent:0..1;
                              MSINotSupported:0..1;
                              PCIeASPMControls:0..1;
                              CMOPSRTCNotPresent:0..1;
                              Reserved:0..1023;
                              end;
     acpi_fadt_arm_boot_arch=bitpacked record
                             PSCICompliant:0..1;
                             PSCIUseHVC:0..1;
                             Reserved:0..16383;
                             end;
     acpi_fadt_feature_flags=bitpacked record
                             WBINVD:0..1;
                             WBINVD_FLUSH:0..1;
                             processor_c1:0..1;
                             plv2_up:0..1;
                             pwr_button:0..1;
                             slp_button:0..1;
                             fix_rtc:0..1;
                             rtc_s4:0..1;
                             timer_val_ext:0..1;
                             dck_capabilities:0..1;
                             reset_seg_sup:0..1;
                             sealed_case:0..1;
                             headless:0..1;
                             cpu_sw_slp:0..1;
                             pci_exp_wak:0..1;
                             use_platform_block:0..1;
                             s4_rtc_sts_vaild:0..1;
                             remote_power_on_capable:0..1;
                             force_apic_cluster_model:0..1;
                             force_apic_physical_destination_model:0..1;
                             hardware_reduced_acpi:0..1;
                             low_power_s0_idle_capable:0..1;
                             presistent_cpu_catches:0..3;
                             Reserved:0..255;
                             end;
     acpi_fadt=packed record
               hdr:acpi_fadt_hdr;
               facsaddress:dword;
               dsdtaddress:dword;
               Reserved1:byte;
               PreferredPMProfile:byte;
               SciInterrupt:word;
               SMICommandPort:dword;
               ACPIenable:byte;
               ACPIdisable:byte;
               S4BIOSrequest:byte;
               PstateControl:byte;
               {These are System Port Address}
               PM1aEventRegisterBlock:dword;
               PM1bEventRegisterBlock:dword;
               PM1aControlRegisterBlock:dword;
               PM1bControlRegisterBlock:dword;
               PM2ControlRegisterBlock:dword;
               PMTimerRegisterBlock:dword;
               GPE0RegisterBlock:dword;
               GPE1RegisterBlock:dword;
               {These are System Length in bytes}
               PM1EventLength:byte;
               PM1ControlLength:byte;
               PM2ControlLength:byte;
               PMTimerLength:byte;
               GPE0BlockLength:byte;
               GPE1BlockLength:byte;
               GPE1BaseOffset:byte;
               CSTControl:byte;
               {System Length Ended}
               PLV2Latency:word;
               PLV3Latency:word;
               FlushSize:word;
               FlushStride:word;
               DutyOffset:byte;
               DutyWidth:byte;
               DayAlarm:byte;
               MonthAlarm:byte;
               Century:byte;
               IAPCBootArch:acpi_fadt_iapc_boot_arch;
               Reserved2:byte;
               Flags:acpi_fadt_feature_flags;
               ResetRegister:acpi_uint96;
               ResetValue:byte;
               ARMBootArch:acpi_fadt_arm_boot_arch;
               FADTMinorVersion:byte;
               ExtendedFACSAddress:qword;
               ExtendedDSDTAddress:qword;
               ExtendedPM1aEventRegisterBlock:acpi_uint96;
               ExtendedPM1bEventRegisterBlock:acpi_uint96;
               ExtendedPM1aControlRegisterBlock:acpi_uint96;
               ExtendedPM1bControlRegisterBlock:acpi_uint96;
               ExtendedPMTimerRegisterBlock:acpi_uint96;
               ExtendedGPE0RegisterBlock:acpi_uint96;
               ExtendedGPE1RegisterBlock:acpi_uint96;
               SleepControlRegister:acpi_uint96;
               SleepStatusRegister:acpi_uint96;
               HypervisiorIdentify:qword;
               end;
     Pacpi_fadt=^acpi_fadt;
     {ACPI Firmware ACPI Control Structure}
     acpi_facs_flags=bitpacked record
                     s4bios_supported:0..1;
                     bit64_wake_supported:0..1;
                     Reserved:0..1073741823;
                     end;
     acpi_facs_ospm_flags=bitpacked record
                          bit64_wake_supported:0..1;
                          Reserved:0..2147483647;
                          end;
     acpi_facs_global_lock=bitpacked record
                           Pending:0..1;
                           Owned:0..1;
                           Reserved:0..1073741823;
                           end;
     acpi_facs=packed record
               signature:array[1..4] of char;
               length:dword;
               HardWareSignature:dword;
               FirmwareWakingVector:dword;
               GlobalLock:acpi_facs_global_lock;
               Flags:acpi_facs_flags;
               ExtendedFirmwareWakingVector:qword;
               Version:byte;
               Reserved1:array[1..3] of byte;
               OSPMFlags:acpi_facs_ospm_flags;
               Reserved2:array[1..8] of dword;
               end;
     Pacpi_facs=^acpi_facs;
     {ACPI System Description Table}
     acpi_asdt=packed record
               hdr:acpi_sdth;
               DefinitionBlock:array[1..1] of byte;
               end;
     acpi_ssdt=acpi_asdt;
     acpi_psdt=acpi_asdt;
     Pacpi_dsdt=^acpi_asdt;
     Pacpi_ssdt=^acpi_asdt;
     Pacpi_psdt=^acpi_psdt;
     {ACPI Multiple APIC Description Table}
     acpi_madt_flags=bitpacked record
                     pcat_compat:0..1;
                     reserved:0..2147483647;
                     end;
     acpi_madt=packed record
               hdr:acpi_sdth;
               LocalInterruptControllerAddress:dword;
               Flags:acpi_madt_flags;
               InterruptControlStructure:array[1..1] of byte;
               end;
     Pacpi_madt=^acpi_madt;
     acpi_madt_processor_local_apic_flags=bitpacked record
                                          Enabled:0..1;
                                          OnlineCapable:0..1;
                                          Reserved:0..1073741823;
                                          end;
     acpi_madt_processor_local_apic_structure=packed record
                                              acpitype:byte;
                                              length:byte;
                                              ACPIProcessorUID:byte;
                                              APICId:byte;
                                              Flags:acpi_madt_processor_local_apic_flags;
                                              end;
     Pacpi_madt_processor_local_apic_structure=^acpi_madt_processor_local_apic_structure;
     acpi_madt_io_apic_structure=packed record
                                 acpitype:byte;
                                 length:byte;
                                 IOAPICid:byte;
                                 Reserved:byte;
                                 IOAPICAddress:dword;
                                 GlobalSystemInterruptBase:dword;
                                 end;
     Pacpi_madt_io_apic_structure=^acpi_madt_io_apic_structure;
     acpi_madt_mps_inti_flags=bitpacked record
                              Polarity:0..3;
                              TriggerMode:0..3;
                              Reserved:0..4095;
                              end;
     acpi_madt_interrupt_source_override_structure=packed record
                                                   acpitype:byte;
                                                   length:byte;
                                                   bus:byte;
                                                   source:byte;
                                                   GlobalSystemInterrupt:dword;
                                                   MPSIntIflags:acpi_madt_mps_inti_flags;
                                                   end;
     Pacpi_madt_interrupt_source_override_structure=^acpi_madt_interrupt_source_override_structure;
     acpi_madt_nmi_source_structure=packed record
                                    acpitype:byte;
                                    length:byte;
                                    MPSIntIFlags:acpi_madt_mps_inti_flags;
                                    GlobalSystemInerrupt:dword;
                                    end;
     Pacpi_madt_nmi_source_structure=^acpi_madt_nmi_source_structure;
     acpi_madt_local_apic_nmi_structure=packed record
                                        acpitype:byte;
                                        length:byte;
                                        ACPIProcessorUID:byte;
                                        Flags:acpi_madt_mps_inti_flags;
                                        LocalAPICLIntNumber:byte;
                                        end;
     Pacpi_madt_local_apic_nmi_structure=^acpi_madt_local_apic_nmi_structure;
     acpi_madt_local_apic_address_override_structure=packed record
                                                     acpitype:byte;
                                                     length:byte;
                                                     Reserved:word;
                                                     LocalAPICAddress:qword;
                                                     end;
     Pacpi_madt_local_apic_address_override_structure=^acpi_madt_local_apic_address_override_structure;
     acpi_madt_io_sapic_structure=packed record
                                  acpitype:byte;
                                  length:byte;
                                  IOSAPICid:byte;
                                  Reserved:word;
                                  GlobalSystemInterruptBase:dword;
                                  IOSAPICAddress:qword;
                                  end;
     Pacpi_madt_io_sapic_structure=^acpi_madt_io_sapic_structure;
     acpi_madt_local_sapic_structure=packed record
                                     acpitype:byte;
                                     length:byte;
                                     ACPIProcessorID:byte;
                                     LocalSAPICID:byte;
                                     LocalSAPICEid:byte;
                                     Reserved:array[1..3] of byte;
                                     flag:dword;
                                     ACPIProcessorUIDValue:dword;
                                     ACPIProcessorUIDString:array[1..1] of char;
                                     end;
     Pacpi_madt_local_sapic_structure=^acpi_madt_local_sapic_structure;
     acpi_madt_platform_interrupt_source_flags=bitpacked record
                                               CPEIProcessorOverride:0..1;
                                               Reserved:0..2147483647;
                                               end;
     acpi_madt_platform_interrupt_source_structure=packed record
                                                   acpitype:byte;
                                                   length:byte;
                                                   flags:acpi_madt_mps_inti_flags;
                                                   InterruptType:byte;
                                                   ProcessorID:byte;
                                                   ProcessorEID:byte;
                                                   IOSAPICVector:byte;
                                                   GlobalSystemInterrupt:dword;
                                                   PlatformInterruptSourceFlags:acpi_madt_platform_interrupt_source_flags;
                                                   end;
     Pacpi_madt_platform_interrupt_source_structure=^acpi_madt_platform_interrupt_source_structure;
     acpi_madt_processor_local_2_apic_structure=packed record
                                                acpitype:byte;
                                                length:byte;
                                                Reserved:word;
                                                apic_2_id:dword;
                                                flags:acpi_madt_processor_local_apic_flags;
                                                ACPIProcessorUID:dword;
                                                end;
     Pacpi_madt_processor_local_2_apic_structure=^acpi_madt_processor_local_2_apic_structure;
     acpi_madt_local_2_apic_nmi_structure=packed record
                                          acpitype:byte;
                                          length:byte;
                                          flags:acpi_madt_mps_inti_flags;
                                          ACPIProcessorUID:dword;
                                          Local2APICLINT:byte;
                                          Reserved:array[1..3] of byte;
                                          end;
     Pacpi_madt_local_2_apic_nmi_structure=^acpi_madt_local_2_apic_nmi_structure;
     acpi_madt_gicc_cpu_inteface_flags=bitpacked record
                                  Enabled:0..1;
                                  PerformanceInterruptMode:0..1;
                                  VGICMaintenanceInterruptModeFlags:0..1;
                                  OnlineCapable:0..1;
                                  Reserved:0..268435455;
                                  end;
     acpi_madt_gicc_structure=packed record
                              acpitype:byte;
                              length:byte;
                              Reserved1:word;
                              CPUInterfaceNumber:dword;
                              ACPIProcessorUID:dword;
                              Flags:acpi_madt_gicc_cpu_inteface_flags;
                              ParkingProtocolVersion:dword;
                              PerformanceInterruptGSI:dword;
                              ParkedAddress:qword;
                              PhysicalBaseAddress:qword;
                              GICV:qword;
                              GICH:qword;
                              VGICMaintenanceInterrupt:dword;
                              GICRBaseAddress:qword;
                              MPIDR:dword;
                              ProcessorPowerEfficiencyClass:byte;
                              Reserved2:byte;
                              SPEoverflowInterrupt:word;
                              TRBEInterrupt:word;
                              end;
     Pacpi_madt_gicc_structure=^acpi_madt_gicc_structure;
     acpi_madt_gicd_structure=packed record
                              acpitype:byte;
                              length:byte;
                              Reserved1:word;
                              GICID:dword;
                              PhysicalBaseAddress:qword;
                              SystemVectorBase:dword;
                              GICVersion:byte;
                              Reserved2:array[1..3] of byte;
                              end;
     Pacpi_madt_gicd_structure=^acpi_madt_gicd_structure;
     acpi_madt_gic_msi_frame_flags=packed record
                                   SPICountOrBaseSelect:0..1;
                                   Reserved:0..2147483647;
                                   end;
     acpi_madt_gic_msi_frame_structure=packed record
                                       acpitype:byte;
                                       length:byte;
                                       Reserved:word;
                                       GICMSIFrameId:dword;
                                       PhysicalBaseAddress:qword;
                                       Flags:acpi_madt_gic_msi_frame_flags;
                                       SPICount:word;
                                       SPIBase:word;
                                       end;
     Pacpi_madt_gic_msi_frame_structure=^acpi_madt_gic_msi_frame_structure;
     acpi_madt_gicr_structure=packed record
                              acpitype:byte;
                              length:byte;
                              Reserved:word;
                              DiscoveryRangeBaseAddress:qword;
                              DiscoveryRangeBaseLength:dword;
                              end;
     Pacpi_madt_gicr_structure=^acpi_madt_gicr_structure;
     acpi_madt_gic_its_structure=packed record
                                 acpitype:byte;
                                 length:byte;
                                 Reserved1:word;
                                 GCIITSID:dword;
                                 PhysicalBaseAddress:qword;
                                 Reserved2:dword;
                                 end;
     Pacpi_madt_gic_its_structure=^acpi_madt_gic_its_structure;
     acpi_madt_multiprocessor_wakeup_mailbox_structure=packed record
                                                       Command:word;
                                                       Reserved:word;
                                                       ApicId:dword;
                                                       WakeupVector:qword;
                                                       ReservedForOS:array[1..2032] of byte;
                                                       ReservedForFirmWare:array[1..2048] of byte;
                                                       end;
     Pacpi_madt_multiprocessor_wakeup_mailbox_structure=^acpi_madt_multiprocessor_wakeup_mailbox_structure;
     acpi_madt_multiprocessor_wakeup_structure=packed record
                                               acpitype:byte;
                                               length:byte;
                                               MailBoxVersion:word;
                                               Reserved:dword;
                                               MailBoxAddress:qword;
                                               end;
     Pacpi_madt_multiprocessor_wakeup_structure=^acpi_madt_multiprocessor_wakeup_structure;
     acpi_madt_core_pic_flags=packed record
                              Enabled:0..1;
                              Reserved:0..2147483647;
                              end;
     acpi_madt_core_pic_structure=packed record
                                  acpitype:byte;
                                  length:byte;
                                  Version:byte;
                                  ACPIProcessorID:dword;
                                  PhysicalProcessorID:dword;
                                  Flags:acpi_madt_core_pic_flags;
                                  end;
     Pacpi_madt_core_pic_structure=^acpi_madt_core_pic_structure;
     acpi_madt_lio_pic_structure=packed record
                                 acpitype:byte;
                                 length:byte;
                                 Version:byte;
                                 BaseAddress:qword;
                                 Size:word;
                                 CascadeVector:word;
                                 CascadeVectorMapping:qword;
                                 end;
     Pacpi_madt_lio_pic_structure=^acpi_madt_lio_pic_structure;
     acpi_madt_ht_pic_structure=packed record
                                acpitype:byte;
                                length:byte;
                                version:byte;
                                BaseAddress:qword;
                                Size:word;
                                CascadeVector:qword;
                                end;
     Pacpi_madt_ht_pic_structure=^acpi_madt_ht_pic_structure;
     acpi_madt_eio_pic_structure=packed record
                                 acpitype:byte;
                                 length:byte;
                                 version:byte;
                                 CascadeVector:word;
                                 Node:byte;
                                 NodeMap:qword;
                                 end;
     Pacpi_madt_eio_pic_structure=^acpi_madt_eio_pic_structure;
     acpi_madt_msi_pic_structure=packed record
                                 acpitype:byte;
                                 length:byte;
                                 version:byte;
                                 MessageAddress:qword;
                                 Start:dword;
                                 Count:dword;
                                 end;
     Pacpi_madt_msi_pic_structure=^acpi_madt_msi_pic_structure;
     acpi_madt_bio_pic_structure=packed record
                                 acpitype:byte;
                                 length:byte;
                                 Version:byte;
                                 BaseAddress:qword;
                                 Size:word;
                                 HardWareID:word;
                                 GSIBase:word;
                                 end;
     Pacpi_madt_bio_pic_structure=^acpi_madt_bio_pic_structure;
     acpi_madt_lpc_pic_structure=packed record
                                 acpitype:byte;
                                 length:byte;
                                 version:byte;
                                 BaseAddress:qword;
                                 Size:word;
                                 CascadeVector:word;
                                 end;
     Pacpi_madt_lpc_pic_structure=^acpi_madt_lpc_pic_structure;
     {ACPI Smart Battery Table}
     acpi_sbst=packed record
               hdr:acpi_sdth;
               WarningEnergyLevel:dword;
               LowEnergylevel:dword;
               CriticalEnergyLevel:dword;
               end;
     Pacpi_sbst=^acpi_sbst;
     {ACPI Embedded Controller Boot Resources Table}
     acpi_ecdt=packed record
               hdr:acpi_sdth;
               ECControl:acpi_uint96;
               ECData:acpi_uint96;
               UID:dword;
               GPEBIT:byte;
               ECId:array[1..1] of char;
               end;
     Pacpi_ecdt=^acpi_ecdt;
     {ACPI System Resource Affinity Table}
     acpi_srat=packed record
               hdr:acpi_sdth;
               Reserved1:dword;
               Reserved2:qword;
               StaticResourceAllocationStructure:array[1..1] of byte;
               end;
     Pacpi_srat=^acpi_srat;
     acpi_srat_processor_local_apic_or_sapic_affinity_structure_flags=bitpacked record
                                                                      Enabled:0..1;
                                                                      Reserved:0..2147483647;
                                                                      end;
     acpi_srat_processor_local_apic_or_sapic_affinity_structure=packed record
                                                                acpitype:byte;
                                                                length:byte;
                                                                ProximityDomain1:byte;
                                                                APICId:byte;
                                                                Flags:acpi_srat_processor_local_apic_or_sapic_affinity_structure_flags;
                                                                LocalSAPICEID:byte;
                                                                ProximityDomain2:array[1..3] of byte;
                                                                ClockDomain:dword;
                                                                end;
     Pacpi_srat_processor_local_apic_or_sapic_affinity_structure=^acpi_srat_processor_local_apic_or_sapic_affinity_structure;
     acpi_srat_memory_affinity_structure_flags=bitpacked record
                                               Enable:0..1;
                                               HotPluggable:0..1;
                                               NonVolatile:0..1;
                                               Reserved:0..536870911;
                                               end;
     acpi_srat_memory_affinity_structure=packed record
                                         acpitype:byte;
                                         length:byte;
                                         ProximityDomain:dword;
                                         Reserved1:word;
                                         BaseAddressLow:dword;
                                         BaseAddressHigh:dword;
                                         LengthLow:dword;
                                         LengthHigh:dword;
                                         Reserved2:dword;
                                         Flags:acpi_srat_memory_affinity_structure_flags;
                                         end;
     Pacpi_srat_memory_affinity_structure=^acpi_srat_memory_affinity_structure;
     acpi_srat_processor_local_2_apic_structure=packed record
                                                acpitype:byte;
                                                length:byte;
                                                Reserved1:word;
                                                ProximityDomain:dword;
                                                apic2id:dword;
                                                flags:acpi_srat_processor_local_apic_or_sapic_affinity_structure_flags;
                                                clockdomain:dword;
                                                Reserved2:dword;
                                                end;
     Pacpi_srat_processor_local_2_apic_structure=^acpi_srat_processor_local_2_apic_structure;
     acpi_gicc_affinity_flags=bitpacked record
                              Enabled:0..1;
                              Reserved:0..2147483647;
                              end;
     acpi_gicc_affinity_structure=packed record
                                  acpitype:byte;
                                  length:byte;
                                  ProximityDomain:dword;
                                  ACPIProcessorUID:dword;
                                  Flags:acpi_gicc_affinity_flags;
                                  ClockDomain:dword;
                                  end;
     Pacpi_gicc_affinity_structure=^acpi_gicc_affinity_structure;
     acpi_gic_its_affinity_structure=packed record
                                     acpitype:byte;
                                     length:byte;
                                     ProximityDomain:dword;
                                     Reserved:word;
                                     ITSID:dword;
                                     end;
     Pacpi_gic_its_affinity_structure=^acpi_gic_its_affinity_structure;
     acpi_generic_initiator_or_port_affinity_structure_flags=packed record
                                                             Enabled:0..1;
                                                             ArchitecturalTransactions:0..1;
                                                             Reserved:0..1073741823;
                                                             end;
     acpi_generic_initiator_affinity_structure=packed record
                                               acpitype:byte;
                                               length:byte;
                                               Reserved1:byte;
                                               DeviceHandleType:byte;
                                               ProximityDomain:dword;
                                               DeviceHandle:acpi_device_handle;
                                               Flags:acpi_generic_initiator_or_port_affinity_structure_flags;
                                               Reserved2:dword;
                                               end;
     Pacpi_generic_initiator_affinity_structure=^acpi_generic_initiator_affinity_structure;
     acpi_generic_port_affinity_structure=packed record
                                          acpitype:byte;
                                          length:byte;
                                          Reserved1:byte;
                                          DeviceHandleType:byte;
                                          ProximityDomain:dword;
                                          DeviceHandle:acpi_device_handle;
                                          Flags:acpi_generic_initiator_or_port_affinity_structure_flags;
                                          Reserved2:dword;
                                          end;
     Pacpi_generic_port_affinity_structure=^acpi_generic_port_affinity_structure;
     {ACPI System Locality Information Table}
     acpi_slit=packed record
               hdr:acpi_sdth;
               NumberOfSystemLocalities:qword;
               Entry:array[1..1] of byte;
               end;
     Pacpi_slit=^acpi_slit;
     {ACPI Corrected Platform Error Polling Table}
     acpi_cpep=packed record
               hdr:acpi_sdth;
               Reserved:qword;
               CPEPProcessorStructure:array[1..1] of byte;
               end;
     Pacpi_cpep=^acpi_cpep;
     acpi_cpep_processor_structure=packed record
                                   acpitype:byte;
                                   length:byte;
                                   ProcessorID:byte;
                                   ProcessorEID:byte;
                                   PollingInterval:dword;
                                   end;
     Pacpi_cpep_processor_structure=^acpi_cpep_processor_structure;
     {ACPI Maximum System Characteristics Table}
     acpi_msct_Maximum_Proximity_Domain_Information=packed record
                                                    Revision:byte;
                                                    Length:byte;
                                                    ProximityDomainRangeLow:dword;
                                                    ProximityDomainRangeHigh:dword;
                                                    MaximumProcessorCapacity:dword;
                                                    MaximumMemoryCapacity:qword;
                                                    end;
     acpi_msct=packed record
               hdr:acpi_sdth;
               OffsetToProximityDomainInformationStructure:dword;
               MaximumNumberOfProximityDomains:dword;
               MaximumNumberOfClockDomains:dword;
               MaximumPhysicalAddress:qword;
               ProximityDomainInformationStructure:array[1..1] of acpi_msct_Maximum_Proximity_Domain_Information;
               end;
     Pacpi_msct=^acpi_msct;
     {ACPI RAS Feature Table}
     acpi_rasf_platform_ras_capabilities=bitpacked record
                                         PartolSupported:0..1;
                                         ExposedToSoftware:0..1;
                                         Reserved1:0..63;
                                         Reserved2:dword;
                                         Reserved3:qword;
                                         end;
     acpi_rasf_parameter_block_flag=packed record
                                    PartolScrubberRunning:0..1;
                                    CurrentPatrolSpeed:0..7;
                                    Reserved:0..4095;
                                    end;
     acpi_rasf_parameter_requested_speed=packed record
                                         PatrolScrubberRunning:0..1;
                                         RequestPatrolSpeed:0..7;
                                         Reserved:0..15;
                                         end;
     acpi_rasf_parameter_block=packed record
                               acpitype:byte;
                               Version:word;
                               Length:word;
                               PartolScrubCommandInput:word;
                               RequestedAddressRangeInputBase:qword;
                               RequestedAddressRangeInputSize:qword;
                               ActualAddressRangeBase:qword;
                               ActualAddressRangeSize:qword;
                               Flags:acpi_rasf_parameter_block_flag;
                               RequestedSpeed:acpi_rasf_parameter_requested_speed;
                               end;
     Pacpi_rasf_parameter_block=^acpi_rasf_parameter_block;
     acpi_rasf_pcc_sub_channel=packed record
                               signature:dword;
                               command:word;
                               status:word;
                               Version:word;
                               RASCapabilities:acpi_rasf_platform_ras_capabilities;
                               SetRASCapabilities:acpi_rasf_platform_ras_capabilities;
                               NumberOfRASFCapabilites:word;
                               SetRASCapabilitiesStatus:dword;
                               ParameterBlock:array[1..1] of acpi_rasf_parameter_block;
                               end;
     Pacpi_rasf_pcc_sub_channel=^acpi_rasf_pcc_sub_channel;
     acpi_rasf=packed record
               hdr:acpi_sdth;
               RASFPlatformCommunicationChannelId:acpi_Uint96;
               end;
     Pacpi_rasf=^acpi_rasf;
     {ACPI RAS2 Platform Communication Channel}
     acpi_ras2_platform_communication_channel_descriptor=packed record
                                                         PCCId:byte;
                                                         Reserved:word;
                                                         FeatureType:byte;
                                                         Instance:dword;
                                                         end;
     Pacpi_ras2_platform_communication_channel_descriptor=^acpi_ras2_platform_communication_channel_descriptor;
     acpi_ras2_memory_ras_features=packed record
                                   PCCId:byte;
                                   Reserved:word;
                                   FeatureType:byte;
                                   Instance:dword;
                                   end;
     Pacpi_ras2_memory_ras_features=^acpi_ras2_memory_ras_features;
     acpi_ras2_patrol_scrub_flag=packed record
                                 MemoryScrubberRunning:0..1;
                                 Reserved:0..2147483647;
                                 end;
     acpi_ras2_patrol_scrub_parameters=packed record
                                       CurrentScrubRate:byte;
                                       MinimumScrubRate:byte;
                                       MaximumScrubRate:byte;
                                       Reserved:byte;
                                       end;
     acpi_ras2_configure_scrub_parameters=packed record
                                          BackGroundPatrolScrubbing:0..1;
                                          Reserved1:0..127;
                                          RequestedScrubGate:0..255;
                                          Reserved2:0..255;
                                          end;
     acpi_ras2_patrol_scrub=packed record
                            acpitype:word;
                            version:word;
                            length:word;
                            PatrolScrubCommand:word;
                            RequestedAddressRangeBase:qword;
                            RequestedAddressRangeSize:qword;
                            ActualAddressRangeBase:qword;
                            ActualAddressRangeSize:qword;
                            Flags:acpi_ras2_patrol_scrub_flag;
                            ScrubParameters:acpi_ras2_patrol_scrub_parameters;
                            ConfigureScrubParameters:acpi_ras2_configure_scrub_parameters;
                            end;
     Pacpi_ras2_patrol_scrub=^acpi_ras2_patrol_scrub;
     acpi_ras2_la2pa_translation=packed record
                                 acpitype:word;
                                 version:word;
                                 length:word;
                                 AddressTranslationCommand:word;
                                 SubInstanceIdentifier:qword;
                                 LogicalAddress:qword;
                                 PhysicalAddress:qword;
                                 Status:dword;
                                 end;
     Pacpi_ras2_la2pa_translation=^acpi_ras2_la2pa_translation;
     acpi_ras2_platform_communication_channel=packed record
                                              signature:dword;
                                              command:word;
                                              status:word;
                                              version:word;
                                              RASFeatures:array[1..16] of byte;
                                              SetRASCapabilities:array[1..16] of byte;
                                              NumberOfRAS2ParameterBlocks:word;
                                              SetRASCapabilitiesStatus:dword;
                                              ParameterBlocks:array[1..1] of byte;
                                              end;
     Pacpi_ras2_platform_communication_channel=^acpi_ras2_platform_communication_channel;
     acpi_ras2=packed record
               hdr:acpi_sdth;
               Reserved:word;
               NumberOfPCCDescriptors:word;
               RAS2PlatformCommunicationChannelDescriptorList:array[1..1] of qword;
               end;
     Pacpi_ras2=^acpi_ras2;
     {ACPI Memory Power State Table}
     acpi_mpst_command_status=packed record
                              CommandComplete:0..1;
                              SCIDoorbell:0..1;
                              Error:0..1;
                              PlatformNotification:0..1;
                              Reserved:0..4095;
                              end;
     acpi_mpst_platform_communication_channel_shared_memory_region=packed record
                                                                   signature:dword;
                                                                   command:word;
                                                                   status:word;
                                                                   MemoryPowerCommandRegister:dword;
                                                                   MemoryPowerStatusRegister:dword;
                                                                   PowerStateID:dword;
                                                                   MemoryPowerNodeId:dword;
                                                                   MemoryEnergyConsumed:qword;
                                                                   ExpectedAveragePowerConsumed:qword;
                                                                   end;
     Pacpi_mpst_platform_communication_channel_shared_memory_region=^acpi_mpst_platform_communication_channel_shared_memory_region;
     acpi_mpst_memory_power_node_flag=packed record
                                      Enabled:0..1;
                                      PowerManagedFlags:0..1;
                                      HotPluggable:0..1;
                                      Reserved:0..31;
                                      end;
     acpi_mpst_memory_power_node_structure_component=packed record
                                                     PowerStateValue:byte;
                                                     PowerStateInformationIndex:byte;
                                                     end;
     Pacpi_mpst_memory_power_node_structure_component=^acpi_mpst_memory_power_node_structure_component;
     acpi_mpst_memory_power_node_structure=packed record
                                           Flag:acpi_mpst_memory_power_node_flag;
                                           Reserved:byte;
                                           MemoryPowerNodeId:word;
                                           length:dword;
                                           BaseAddressLow:dword;
                                           BaseAddressHigh:dword;
                                           LengthLow:dword;
                                           LengthHigh:dword;
                                           NumberOfPowerState:dword;
                                           NumberOfPhysicalComponents:dword;
                                           MemoryPowerStateStructure:array[1..1] of acpi_mpst_memory_power_node_structure_component;
                                           end;
     Pacpi_mpst_memory_power_node_structure=^acpi_mpst_memory_power_node_structure;
     acpi_mpst_memory_power_state_characteristics_structure_flag=packed record
                                                                 MemoryContentReserved:0..1;
                                                                 AutonomousMemoryPowerStateEntry:0..1;
                                                                 AutonomousMemoryPowerStateExit:0..1;
                                                                 Reserved:0..15;
                                                                 end;
     acpi_mpst_memory_power_state_characteristics_structure=packed record
                                                            PowerStateIdentifier:byte;
                                                            Flags:acpi_mpst_memory_power_state_characteristics_structure_flag;
                                                            Reserved1:word;
                                                            AveragePowerConsumedInMPS0state:dword;
                                                            RelativePowerSavingtoMPS0State:dword;
                                                            ExitLatency:qword;
                                                            Reserved2:qword;
                                                            end;
     Pacpi_mpst_memory_power_state_characteristics_structure=^acpi_mpst_memory_power_state_characteristics_structure;
     acpi_mpst_memory_power_node=packed record
                                 MemoryPowerNodeCount:word;
                                 Reserved:word;
                                 MemoryPowerNodeStructure:array[1..1] of byte;
                                 end;
     Pacpi_mpst_memory_power_node=^acpi_mpst_memory_power_node;
     acpi_mpst_memory_power_state_characteristics=packed record
                                                  MemoryPowerStateCharacteristicsCount:word;
                                                  Reserved:word;
                                                  MemoryPowerStateCharacteristicsStructure:array[1..1] of byte;
                                                  end;
     Pacpi_mpst_memory_power_state_characteristics=^acpi_mpst_memory_power_state_characteristics;
     acpi_mpst=packed record
               hdr:acpi_sdth;
               MPSTPlatformCommunicationChannelIdentifier:byte;
               Reserved:array[1..3] of byte;
               end;
     Pacpi_mpst=^acpi_mpst;
     {ACPI Platform Memory Topology Table}
     acpi_pmtt_common_memory_device_flag=packed record
                                         TopLevelDevice:0..1;
                                         LogicalOrPhysicalElement:0..1;
                                         VolatileStatus:0..3;
                                         Reserved:0..4095;
                                         end;
     acpi_pmtt_common_memory_device_socket_data=packed record
                                                SocketId:word;
                                                Reserved:word;
                                                MemoryDeviceStructure:array[1..1] of byte;
                                                end;
     acpi_pmtt_common_memory_device_memory_controller_data=packed record
                                                           MemoryControllerId:word;
                                                           Reserved:word;
                                                           MemoryDeviceStructure:array[1..1] of byte;
                                                           end;
     acpi_pmtt_common_memory_device_DIMM_data=packed record
                                              SMBIOSHandle:dword;
                                              end;
     acpi_pmtt_common_memory_device_Vendor_specific_data=packed record
                                                         TypeUUID:acpi_guid;
                                                         VendorSpecificData:array[1..1] of byte;
                                                         //MemoryDeviceStructure:array[1..1] of byte;
                                                         end;
     acpi_pmtt_common_memory_device_header=packed record
                                           acpitype:byte;
                                           Reserved1:byte;
                                           Length:word;
                                           Flags:acpi_pmtt_common_memory_device_flag;
                                           Reserved2:word;
                                           NumberOfMemoryDevices:dword;
                                           case Byte of
                                           0:(socket:acpi_pmtt_common_memory_device_socket_data;);
                                           1:(MemCtrl:acpi_pmtt_common_memory_device_memory_controller_data;);
                                           2:(DIMM:acpi_pmtt_common_memory_device_DIMM_data;);
                                           3:(VendorSpecific:acpi_pmtt_common_memory_device_Vendor_specific_data;);
                                           end;
     Pacpi_pmtt_common_memory_device_header=^acpi_pmtt_common_memory_device_header;
     acpi_pmtt=packed record
               hdr:acpi_sdth;
               NumberOfMemoryDevices:dword;
               MemoryDeviceStructure:array[1..1] of byte;
               end;
     Pacpi_pmtt=^acpi_pmtt;
     {ACPI Boot Graphics Resource Table}
     acpi_bgrt=packed record
               hdr:acpi_sdth;
               Version:word;
               Status:byte;
               ImageType:byte;
               ImageAddress:qword;
               ImageOffsetX:dword;
               ImageOffsetY:dword;
               end;
     Pacpi_bgrt=^acpi_bgrt;
     {ACPI Firmware Performance Data Table}
     acpi_fpdt_performance_record_format=packed record
                                         RecordType:word;
                                         RecordLength:byte;
                                         Revision:byte;
                                         Data:array[1..1] of byte;
                                         end;
     acpi_fpdt_basic_boot_performance_table_pointer_record=packed record
                                                           PerformanceRecordType:word;
                                                           RecordLength:byte;
                                                           Revision:byte;
                                                           Reserved:dword;
                                                           FBPTPointer:qword;
                                                           end;
     Pacpi_fpdt_basic_boot_performance_table_pointer_record=^acpi_fpdt_basic_boot_performance_table_pointer_record;
     acpi_fpdt_s3_performance_table_pointer_record=packed record
                                                   PerformanceRecordType:word;
                                                   RecordLength:byte;
                                                   Revision:byte;
                                                   Reserved:dword;
                                                   S3PTPointer:qword;
                                                   end;
     Pacpi_fpdt_s3_performance_table_pointer_record=^acpi_fpdt_s3_performance_table_pointer_record;
     acpi_fpdt_firmware_basic_boot_performance_table_header=packed record
                                                            signature:dword;
                                                            length:dword;
                                                            end;
     acpi_fpdt_firmware_basic_boot_performance_data_record=packed record
                                                           PerformanceRecordType:word;
                                                           RecordLength:byte;
                                                           Revision:byte;
                                                           Reserved:dword;
                                                           ResetEnd:qword;
                                                           OSLoaderLoadImageStart:qword;
                                                           OSLoaderStartImageStart:qword;
                                                           ExitBootServicesEntry:qword;
                                                           ExitBootServicesExit:qword;
                                                           end;
     acpi_fpdt_firmware_basic_boot_performance_table=packed record
                                                     hdr:acpi_fpdt_firmware_basic_boot_performance_table_header;
                                                     data:acpi_fpdt_firmware_basic_boot_performance_data_record;
                                                     end;
     Pacpi_fpdt_firmware_basic_boot_performance_table=^acpi_fpdt_firmware_basic_boot_performance_table;
     acpi_fpdt_s3_performance_table_header=packed record
                                           signature:dword;
                                           length:dword;
                                           end;
     acpi_fpdt_s3_resume_performance_record=packed record
                                            RuntimePerformanceRecordType:word;
                                            RecordLength:byte;
                                            Revision:byte;
                                            ResumeCount:dword;
                                            FullResume:qword;
                                            AverageResume:qword;
                                            end;
     acpi_fpdt_s3_suspend_performance_record=packed record
                                             RuntimePerformanceRecordType:word;
                                             RecordLength:byte;
                                             Revision:byte;
                                             SuspendStart:qword;
                                             SuspendEnd:qword;
                                             end;
     acpi_fpdt_s3_resume_performance_table=packed record
                                           Hdr:acpi_fpdt_s3_performance_table_header;
                                           data:acpi_fpdt_s3_resume_performance_record;
                                           end;
     Pacpi_fpdt_s3_resume_performance_table=^acpi_fpdt_s3_resume_performance_table;
     acpi_fpdt_s3_suspend_performance_table=packed record
                                            Hdr:acpi_fpdt_s3_performance_table_header;
                                            data:acpi_fpdt_s3_suspend_performance_record;
                                            end;
     Pacpi_fpdt_s3_suspend_performance_table=^acpi_fpdt_s3_suspend_performance_table;
     acpi_fpdt=packed record
               hdr:acpi_sdth;
               PerformanceRecords:array[1..1] of byte;
               end;
     Pacpi_fpdt=^acpi_fpdt;
     {ACPI Generic Timer Description Table}
     acpi_gtdt_flag=packed record
                    TimerInterruptMode:0..1;
                    TimerInterruptPolarity:0..1;
                    AlwaysOnCapacity:0..1;
                    Reserved:0..536870911;
                    end;
     acpi_gtdt_gt_block_physical_timers_and_virtual_timers_flag=packed record
                                                                TimerInterruptMode:0..1;
                                                                TimerInterruptPolarity:0..1;
                                                                Reserved:0..1073741823;
                                                                end;
     acpi_gtdt_gt_block_common_flag=packed record
                                    SecureTimer:0..1;
                                    AlwaysOnCapability:0..1;
                                    Reserved:0..1073741823;
                                    end;
     acpi_gtdt_gt_block_timer_structure=packed record
                                        GTFrameNumber:byte;
                                        Reserved:array[1..3] of byte;
                                        GTxPhysicalAddressCntBaseX:qword;
                                        GTxPhysicalAddressCntEL0BaseX:qword;
                                        GTxPhysicalTimerGSI:dword;
                                        GTxPhysicalTimerFlags:acpi_gtdt_gt_block_physical_timers_and_virtual_timers_flag;
                                        GTxVirtualTimerGSI:dword;
                                        GTxVirtualTimerFlags:acpi_gtdt_gt_block_physical_timers_and_virtual_timers_flag;
                                        GTxCommonFlags:acpi_gtdt_gt_block_common_flag;
                                        end;
     Pacpi_gtdt_gt_block_timer_structure=^acpi_gtdt_gt_block_timer_structure;
     acpi_gtdt_gt_block_structure=packed record
                                  acpitype:byte;
                                  length:word;
                                  Reserved:byte;
                                  GTBlockPhysicalAddress:qword;
                                  GTBlockTimerCount:dword;
                                  GTBlockTimerOffset:dword;
                                  GTBlockTimerStructure:array[1..1] of acpi_gtdt_gt_block_timer_structure;
                                  end;
     Pacpi_gtdt_gt_block_structure=^acpi_gtdt_gt_block_structure;
     acpi_gtdt_arm_generic_watchdog_timer_flag=packed record
                                               TimerInterruptMode:0..1;
                                               TimerInterruptPolarity:0..1;
                                               SecureTimer:0..1;
                                               Reserved:0..536870911;
                                               end;
     acpi_gtdt_arm_generic_watchdog_structure=packed record
                                              acpitype:byte;
                                              length:word;
                                              Reserved:byte;
                                              RefreshFramePhysicalAddress:qword;
                                              WatchdogControlFramePhysicalAddress:qword;
                                              WatchdogTimerGSI:dword;
                                              WatchdogTimerFlags:acpi_gtdt_arm_generic_watchdog_timer_flag;
                                              end;
     Pacpi_gtdt_arm_generic_watchdog_structure=^acpi_gtdt_arm_generic_watchdog_structure;
     acpi_gtdt=packed record
               hdr:acpi_sdth;
               CntControlBasePhysicalAddress:qword;
               Reserved:dword;
               SecureEL1TimerGSI:dword;
               SecureEL1TimerFlags:acpi_gtdt_flag;
               NonSecureEL1TimerGSI:dword;
               NonSecureEL1TimerFlags:acpi_gtdt_flag;
               VirtualEL1TimerGSI:dword;
               VirtualEL1TimerFlags:acpi_gtdt_flag;
               EL2TimerGSI:dword;
               EL2TimerFlags:acpi_gtdt_flag;
               CntReadBasePhysicalAddress:qword;
               PlatformTimerCount:dword;
               PlatformTimerOffset:dword;
               VirtualEL2TimerGSI:dword;
               VirtualEL2TimerFlags:acpi_gtdt_flag;
               //PlatformTimerStructure:array[1..1] of byte;
               end;
     Pacpi_gtdt=^acpi_gtdt;
     {ACPI NVDIMM Firmware Interface Table}
     acpi_nfit_system_physical_address_range_structure_flags=packed record
                                                             ControlManaged:0..1;
                                                             DataInProximityDomainVaild:0..1;
                                                             DataInSPALocationCookie:0..1;
                                                             Reserved:0..8191;
                                                             end;
     acpi_nfit_system_physical_address_range_structure=packed record
                                                       acpitype:word;
                                                       length:word;
                                                       SPARangeStructureIndex:word;
                                                       Flags:acpi_nfit_system_physical_address_range_structure_flags;
                                                       Reserved:dword;
                                                       ProximityDomain:dword;
                                                       AddressRangeTypeGUID:acpi_guid;
                                                       SystemPhysicalAddressRangeBase:qword;
                                                       SystemPhysicalAddressRangeLength:qword;
                                                       AddressRangeMemoryMappingAttribute:qword;
                                                       SpaLocationCookie:qword;
                                                       end;
     Pacpi_nfit_system_physical_address_range_structure=^acpi_nfit_system_physical_address_range_structure;
     acpi_nfit_NVIDMM_state_flags=packed record
                                  SaveSucceed:0..1;
                                  RestoreSucceed:0..1;
                                  PlatformFlushSucceed:0..1;
                                  UnacceptPersistentWrite:0..1;
                                  ObservedSMART:0..1;
                                  NotifyEnabled:0..1;
                                  NotMapped:0..1;
                                  Reserved:0..511;
                                  end;
     acpi_nfit_NVIDMM_region_mapping_structure=packed record
                                               acpitype:word;
                                               length:word;
                                               NFITDeviceHandle:dword;
                                               NVDIMMPhysicalID:word;
                                               NVDIMMRegionID:word;
                                               SPARangeStructureIndex:word;
                                               NVDIMMControlRegionStructureIndex:word;
                                               NVDIMMRegionSize:qword;
                                               RegionOffset:qword;
                                               NVDIMMPhysicalAddressRegionBase:qword;
                                               InterLeaveStructureIndex:word;
                                               InterLeaveWays:word;
                                               NVDIMMStateFlags:acpi_nfit_NVIDMM_state_flags;
                                               Reserved:word;
                                               end;
     Pacpi_nfit_NVIDMM_region_mapping_structure=^acpi_nfit_NVIDMM_region_mapping_structure;
     acpi_nfit_interleave_structure=packed record
                                    acpitype:word;
                                    length:word;
                                    InterleaveStructureIndex:word;
                                    Reserved:word;
                                    NumberOfLinesDescribed:dword;
                                    LineSize:dword;
                                    LineXOffset:array[1..1] of dword;
                                    end;
     Pacpi_nfit_interleave_structure=^acpi_nfit_interleave_structure;
     acpi_nfit_smbios_management_structure=packed record
                                           acpitype:word;
                                           length:word;
                                           Reserved:dword;
                                           Data:array[1..1] of byte;
                                           end;
     Pacpi_nfit_smbios_management_structure=^acpi_nfit_smbios_management_structure;
     acpi_nfit_NVDIMM_Control_Region_Structure=packed record
                                               acpitype:word;
                                               length:word;
                                               NVDIMMControlRegionStructureIndex:word;
                                               VendorID:word;
                                               DeviceID:word;
                                               RevisionID:word;
                                               SubsystemVendorID:word;
                                               SubSystemDeviceID:word;
                                               SubSystemRevisionID:word;
                                               VaildFields:byte;
                                               ManufacturingLocation:byte;
                                               ManufacturingDate:word;
                                               Reserved1:word;
                                               SerialNumber:dword;
                                               RegionFormatInterfaceCode:word;
                                               NumberOfBlockControlWindows:word;
                                               SizeOfBlockControlWindow:qword;
                                               CommandRegisterOffsetInBlockControlWindow:qword;
                                               SizeOfCommandRegisterInBlockControlWindows:qword;
                                               StatusRegisterOffsetInBlockControlWindow:qword;
                                               SizeOfStatusRegisterInBlockControlWindows:qword;
                                               NVDIMMControlRegionFlag:word;
                                               Reserved2:array[1..3] of word;
                                               end;
     Pacpi_nfit_NVDIMM_Control_Region_Structure=^acpi_nfit_NVDIMM_Control_Region_Structure;
     acpi_nfit_NVDIMM_Block_Data_Region_Structure=packed record
                                                  acpitype:word;
                                                  length:word;
                                                  NVDIMMControlRegionStructureIndex:word;
                                                  NumberOfBlockDataWindows:word;
                                                  BlockDataWindowStartOffset:qword;
                                                  SizeOfBlockDataWindow:qword;
                                                  BlockAccessibleMemoryCapacity:qword;
                                                  BeginningAddressOfFirstBlockInBlockAccessibleMemory:qword;
                                                  end;
     Pacpi_nfit_NVDIMM_Block_Data_Region_Structure=^acpi_nfit_NVDIMM_Block_Data_Region_Structure;
     acpi_nfit_flush_hint_address_structure=packed record
                                            acpitype:word;
                                            length:word;
                                            NFITDeviceHandle:dword;
                                            NumberOfFlushHintAddress:word;
                                            Reserved:array[1..3] of word;
                                            FlushHintAddress:array[1..8] of qword;
                                            end;
     Pacpi_nfit_flush_hint_address_structure=^acpi_nfit_flush_hint_address_structure;
     acpi_nfit_platform_capabilities_structure=packed record
                                               acpitype:word;
                                               length:word;
                                               HighestVaildCapability:byte;
                                               Reserved1:array[1..3] of byte;
                                               Capabilities:dword;
                                               Reserved2:dword;
                                               end;
     Pacpi_nfit_platform_capabilities_structure=^acpi_nfit_platform_capabilities_structure;
     acpi_nfit=packed record
               hdr:acpi_sdth;
               Reserved:dword;
               NFITStructures:array[1..1] of byte;
               end;
     Pacpi_nfit=^acpi_nfit;
     {ACPI Secure Devices Table}
     acpi_sdev_acpi_namespaced_device_based_secure_device_flag=bitpacked record
                                                               AllowHandOff:0..1;
                                                               SecureAccessComponent:0..1;
                                                               Reserved:0..63;
                                                               end;
     acpi_sdev_idbased_secure_access_component=packed record
                                               acpitype:byte;
                                               flags:byte;
                                               length:word;
                                               hardwareIdOffset:word;
                                               hardwareIdLength:word;
                                               SubsystemIdOffset:word;
                                               SubsystemIdLength:word;
                                               HardwareRevision:word;
                                               HardwareRevisionPresent:byte;
                                               ClassCodePresent:byte;
                                               PCICompatibleBaseClass:byte;
                                               PCICompatibleSubClass:byte;
                                               PCICompatibleProgrammingInterface:byte;
                                               end;
     Pacpi_sdev_idbased_secure_access_component=^acpi_sdev_idbased_secure_access_component;
     acpi_sdev_memorybased_secure_access_component=packed record
                                                   acpitype:byte;
                                                   flags:byte;
                                                   length:word;
                                                   reserved:dword;
                                                   MemoryAddressBase:qword;
                                                   MemoryLength:qword;
                                                   end;
     Pacpi_sdev_memorybased_secure_access_component=^acpi_sdev_memorybased_secure_access_component;
     acpi_sdev_pcie_endpoint_device_based_device_structure_flags=bitpacked record
                                                                 AllowHandOffToNonSecureOS:0..1;
                                                                 Reserved:0..127;
                                                                 end;
     acpi_sdev_pcie_endpoint_device_based_device_structure=packed record
                                                           acpitype:byte;
                                                           flags:acpi_sdev_pcie_endpoint_device_based_device_structure_flags;
                                                           Length:word;
                                                           PCISegmentNumber:word;
                                                           StartBusNumber:word;
                                                           PCIPathOffset:word;
                                                           PCIPathLength:word;
                                                           VendorSpecificDataOffset:word;
                                                           VendorSpecificDataLength:word;
                                                           end;
     Pacpi_sdev_pcie_endpoint_device_based_device_structure=^acpi_sdev_pcie_endpoint_device_based_device_structure;
     acpi_sdev_acpi_namespaced_device_based_secure_device=packed record
                                                          acpitype:byte;
                                                          flags:acpi_sdev_acpi_namespaced_device_based_secure_device_flag;
                                                          length:word;
                                                          DeviceIdOffset:word;
                                                          DevideIdLength:word;
                                                          VendorSpecificDataOffset:word;
                                                          VendorSpecificDataLength:word;
                                                          SecureAccessComponentOffset:word;
                                                          SecureAccessComponentLength:word;
                                                          end;
     Pacpi_sdev_acpi_namespaced_device_based_secure_device=^acpi_sdev_acpi_namespaced_device_based_secure_device;
     acpi_sdev=packed record
               hdr:acpi_sdth;
               SecureDeviceStructures:array[1..1] of byte;
               end;
     Pacpi_sdev=^acpi_sdev;
     {ACPI Heterogeneous Memory Attribute Table}
     acpi_hmat_memory_proximity_domain_attributes_structure_flags=bitpacked record
                                                                  AttachInitiatorFieldVaild:0..1;
                                                                  Reserved1:0..1;
                                                                  ReservationHint:0..1;
                                                                  Reserved2:0..31;
                                                                  end;
     acpi_hmat_memory_proximity_domain_attributes_structure=packed record
                                                            acpitype:word;
                                                            Reserved1:word;
                                                            Length:dword;
                                                            Flags:acpi_hmat_memory_proximity_domain_attributes_structure_flags;
                                                            Reserved2:word;
                                                            ProximityDomainForTheAttachedInititator:dword;
                                                            ProximityDomainForTheMemory:dword;
                                                            Reserved3:dword;
                                                            Reserved4:qword;
                                                            Reserved5:qword;
                                                            end;
     Pacpi_hmat_memory_proximity_domain_attributes_structure=^acpi_hmat_memory_proximity_domain_attributes_structure;
     acpi_hmat_system_locality_latency_and_bandwidth_information_structure_flags=bitpacked record
                                                                                 Memoryhihierarchy:0..15;
                                                                                 AccessAttributes:0..3;
                                                                                 Reserved:0..3;
                                                                                 end;
     acpi_hmat_system_locality_latency_and_bandwidth_information_structure=packed record
                                                                           acpitype:word;
                                                                           Reserved1:word;
                                                                           Length:dword;
                                                                           Flags:acpi_hmat_system_locality_latency_and_bandwidth_information_structure_flags;
                                                                           DataType:byte;
                                                                           MinTransferSize:byte;
                                                                           Reserved2:byte;
                                                                           NumberOfInitiatorProximityDomains:dword;
                                                                           NumberOfTargetProximityDomains:dword;
                                                                           Reserved3:dword;
                                                                           EntryBaseUnit:qword;
                                                                           //InitiatorProximityDomainList:array[1..1] of dword;
                                                                           //TargetProximityDomainList:array[1..1] of dword;
                                                                           //Entry:array[1..1] of wordl
                                                                           end;
     Pacpi_hmat_system_locality_latency_and_bandwidth_information_structure=^acpi_hmat_system_locality_latency_and_bandwidth_information_structure;
     acpi_memory_side_cache_information_structure_cache_attributes=bitpacked record
                                                                   TotalCacheLevel:0..15;
                                                                   CacheLevel:0..15;
                                                                   CacheAssociactivity:0..15;
                                                                   WritePolicy:0..15;
                                                                   Reserved:0..65535;
                                                                   end;
     Pacpi_memory_side_cache_information_structure_cache_attributes=^acpi_memory_side_cache_information_structure_cache_attributes;
     acpi_memory_side_cache_information_structure=packed record
                                                  acpitype:word;
                                                  Reserved1:word;
                                                  Length:dword;
                                                  ProximityDomainForTheMemory:dword;
                                                  Reserved2:dword;
                                                  MemorySideCacheSize:qword;
                                                  CacheAttributes:dword;
                                                  Reserved3:word;
                                                  NumberOfSMBIOShandles:word;
                                                  SMBIOSHandles:array[1..1] of word;
                                                  end;
     Pacpi_memory_side_cache_information_structure=^acpi_memory_side_cache_information_structure;
     acpi_hmat=packed record
               hdr:acpi_sdth;
               Reserved:dword;
               HMATTableStructure:array[1..1] of byte;
               end;
     Pacpi_hmat=^acpi_hmat;
     {ACPI Platform Debug Trigger Table}
     acpi_pdtt_platform_communication_channel_identifier_structure=bitpacked record
                                                                   PDTTPCCSubChannelIdentifier:byte;
                                                                   RunTime:0..1;
                                                                   WaitForCompletion:0..1;
                                                                   TriggerOrder:0..1;
                                                                   Reserved:0..31;
                                                                   end;
     Pacpi_pdtt_platform_communication_channel_identifier_structure=^acpi_pdtt_platform_communication_channel_identifier_structure;
     acpi_pdtt_type_5_platform_communication_channel_shared_memory=packed record
                                                                   signature:dword;
                                                                   vendorspecificspace:dword;
                                                                   end;
     Pacpi_pdtt_type_5_platform_communication_channel_shared_memory=^acpi_pdtt_type_5_platform_communication_channel_shared_memory;
     acpi_pdtt_platform_communication_channel=packed record
                                              signature:dword;
                                              command:word;
                                              status:word;
                                              vendorspecific:array[1..1] of byte;
                                              end;
     Pacpi_pdtt_platform_communication_channel=^acpi_pdtt_platform_communication_channel;
     acpi_pdtt=packed record
               hdr:acpi_sdth;
               TriggerCount:byte;
               Reserved:array[1..3] of byte;
               TriggerIdentifierArrayOffset:dword;
               //PDTTPlatformCommunicationChannelIdentifiers:array[1..1] of acpi_pdtt_platform_communication_channel_identifier_structure;
               end;
     Pacpi_pdtt=^acpi_pdtt;
     {ACPI Processor Properties Topology Table}
     acpi_pptt_processor_hierarchy_node_structure_flags=bitpacked record
                                                        PhysicalPackage:0..1;
                                                        ACPIProcessorIDVaild:0..1;
                                                        ProcessorIsAThread:0..1;
                                                        NodeIsLeaf:0..1;
                                                        IdenticalImplementation:0..1;
                                                        Reserved:0..134217727;
                                                        end;
     acpi_pptt_processor_hierarchy_node_structure=packed record
                                                  acpitype:byte;
                                                  length:byte;
                                                  Reserved:word;
                                                  Flags:acpi_pptt_processor_hierarchy_node_structure_flags;
                                                  Parent:dword;
                                                  ACPIProcessorID:dword;
                                                  NumberOfPrivateResources:dword;
                                                  PrivateResources:array[1..1] of dword;
                                                  end;
     Pacpi_pptt_processor_hierarchy_node_structure=^acpi_pptt_processor_hierarchy_node_structure;
     acpi_pptt_cache_structure_flags=bitpacked record
                                     SizePropertyVaild:0..1;
                                     NumberOfSetsVaild:0..1;
                                     AssociativityVaild:0..1;
                                     AllocationTypeVaild:0..1;
                                     CacheTypeVaild:0..1;
                                     WritePolicyVaild:0..1;
                                     LineSizeVaild:0..1;
                                     CacheIDVaild:0..1;
                                     Reserved:0..16777215;
                                     end;
     acpi_pptt_cache_attributes=bitpacked record
                                AllocationType:0..3;
                                CacheType:0..3;
                                WritePolicy:0..1;
                                Reserved:0..7;
                                end;
     acpi_pptt_cache_type_structure=packed record
                                    acpitype:byte;
                                    length:byte;
                                    Reserved:word;
                                    Flags:acpi_pptt_cache_structure_flags;
                                    NextLevelOfCache:dword;
                                    Size:dword;
                                    NumberOfSets:dword;
                                    Associativity:byte;
                                    Attributes:acpi_pptt_cache_attributes;
                                    LineSize:word;
                                    CacheId:dword;
                                    end;
     Pacpi_pptt_cache_type_structure=^acpi_pptt_cache_type_structure;
     acpi_pptt=packed record
               hdr:acpi_sdth;
               ProcessorTopologyStructure:array[1..1] of byte;
               end;
     Pacpi_pptt=^acpi_pptt;
     {ACPI Platform Health Assessment Table}
     acpi_phat_firmware_version_data_record_structure_component=packed record
                                                                ComponentID:acpi_guid;
                                                                VersionValue:qword;
                                                                ProducerID:dword;
                                                                end;
     Pacpi_phat_firmware_version_data_record_structure_component=^acpi_phat_firmware_version_data_record_structure_component;
     acpi_phat_firmware_version_data_record=packed record
                                            PlatformRecordType:word;
                                            RecordLength:word;
                                            Revision:byte;
                                            Reserved:array[1..3] of byte;
                                            RecordCount:dword;
                                            PHATVersionComponent:array[1..1] of acpi_phat_firmware_version_data_record_structure_component;
                                            end;
     Pacpi_phat_firmware_version_data_record=^acpi_phat_firmware_version_data_record;
     acpi_phat_firmware_health_data_record=packed record
                                           PlatformRecordType:word;
                                           RecordLength:word;
                                           Revision:byte;
                                           Reserved:array[1..3] of byte;
                                           AmHealthy:byte;
                                           DeviceSignature:acpi_guid;
                                           DeviceSpecificDataOffset:dword;
                                           DevicePath:array[1..1] of byte;
                                           //DeviceSpecificData:array[1..1] of byte;
                                           end;
     Pacpi_phat_firmware_health_data_record=^acpi_phat_firmware_health_data_record;
     acpi_phat_reset_reason_health_record_entry=packed record
                                                VendorDataId:acpi_guid;
                                                Length:word;
                                                Revision:word;
                                                Data:array[1..1] of byte;
                                                end;
     Pacpi_phat_reset_reason_health_record_entry=^acpi_phat_reset_reason_health_record_entry;
     acpi_phat_supported_sources=bitpacked record
                                 UnknownSource:0..1;
                                 HardwareSource:0..1;
                                 FirmwareSource:0..1;
                                 SoftwareSource:0..1;
                                 SupervisiorSource:0..1;
                                 Reserved:0..7;
                                 end;
     acpi_phat_sources=bitpacked record
                       UnknownSource:0..1;
                       HardwareSource:0..1;
                       FirmwareSource:0..1;
                       SoftwareInitiatedReset:0..1;
                       SupervisiorInitiatedReset:0..1;
                       Reserved:0..7;
                       end;
     acpi_phat_reset_reason_health_record=packed record
                                          SupportedSources:acpi_phat_supported_sources;
                                          Source:acpi_phat_sources;
                                          SubSource:byte;
                                          Reason:byte;
                                          VendorCount:word;
                                          VendorSpecificResetReasonEntry:array[1..1] of byte;
                                          end;
     Pacpi_phat_reset_reason_health_record=^acpi_phat_reset_reason_health_record;
     acpi_phat_reset_reason_health_record_header=packed record
                                                 PlatformRecordType:word;
                                                 RecordLength:word;
                                                 Revision:byte;
                                                 Reserved:array[1..2] of byte;
                                                 AmHealthy:byte;
                                                 DeviceSignature:acpi_guid;
                                                 DeviceSpecificDataOffset:dword;
                                                 DevicePath:array[1..88] of byte;
                                                 //DeviceSpecificData:array[1..116] of byte;
                                                 end;
     Pacpi_phat_reset_reason_health_record_header=^acpi_phat_reset_reason_health_record_header;
     acpi_phat=packed record
               hdr:acpi_sdth;
               PlatformTelemetryRecords:array[1..1] of byte;
               end;
     Pacpi_phat=^acpi_phat;
     {ACPI Virtual I/O Translation Table}
     acpi_viot_pci_range_node_structure=packed record
                                        acpitype:byte;
                                        Reserved1:byte;
                                        Length:word;
                                        EndPointStart:dword;
                                        PCISegmentStart:word;
                                        PCISegmentEnd:word;
                                        PCIBDFStart:word;
                                        PCIBDFEnd:word;
                                        OutputNode:word;
                                        Reserved2:array[1..3] of word;
                                        end;
     Pacpi_viot_pci_range_node_structure=^acpi_viot_pci_range_node_structure;
     acpi_viot_single_mmio_endpoint_node_structure=packed record
                                                   acpitype:byte;
                                                   Reserved1:byte;
                                                   length:word;
                                                   EndpointId:dword;
                                                   BaseAddress:qword;
                                                   OutputNode:word;
                                                   Reserved2:array[1..3] of word;
                                                   end;
     Pacpi_viot_single_mmio_endpoint_node_structure=^acpi_viot_single_mmio_endpoint_node_structure;
     acpi_viot_virtio_pci_iommu_node_structure=packed record
                                               acpitype:byte;
                                               reserved1:byte;
                                               length:word;
                                               PCISegment:word;
                                               PCIBDFNumber:word;
                                               Reserved2:qword;
                                               end;
     Pacpi_viot_virtio_pci_iommu_node_structure=^acpi_viot_virtio_pci_iommu_node_structure;
     acpi_viot_virtio_mmio_iommu_node_structure=packed record
                                                acpitype:byte;
                                                Reserved1:byte;
                                                Length:word;
                                                Reserved:dword;
                                                BaseAddress:qword;
                                                end;
     Pacpi_viot_virtio_mmio_iommu_node_structure=^acpi_viot_virtio_mmio_iommu_node_structure;
     acpi_viot=packed record
               hdr:acpi_sdth;
               NodeCount:word;
               NodeOffset:word;
               Reserved:qword;
               NodeStructure:array[1..1] of byte;
               end;
     Pacpi_viot=^acpi_viot;
     {ACPI Miscellaneous GUIDed Table Entries}
     acpi_misc_GUIDed_entry_format=packed record
                                   EntryGUIDID:acpi_guid;
                                   EntryLength:dword;
                                   Revision:dword;
                                   ProducerID:dword;
                                   Data:array[1..1] of byte;
                                   end;
     Pacpi_misc_GUIDed_entry_format=^acpi_misc_GUIDed_entry_format;
     acpi_misc=packed record
               hdr:acpi_sdth;
               GUIDedEntries:array[1..1] of byte;
               end;
     Pacpi_misc=^acpi_misc;
     {ACPI CC Event Log Table}
     acpi_ccel=packed record
               hdr:acpi_sdth;
               cctype:byte;
               ccsubtype:byte;
               Reserved:byte;
               LogAreaMinimumLength:qword;
               LogAreaStartAddress:qword;
               end;
     Pacpi_ccel=^acpi_ccel;
     {ACPI Storage Volume Key Location Table}
     acpi_skvl_key_structure=packed record
                             keytype:word;
                             keyformat:word;
                             keysize:dword;
                             keyaddress:qword;
                             end;
     Pacpi_skvl_key_structure=^acpi_skvl_key_structure;
     acpi_skvl=packed record
               hdr:acpi_sdth;
               keycount:dword;
               keystructure:array[1..1] of acpi_skvl_key_structure;
               end;
     Pacpi_skvl=^acpi_skvl;
     {ACPI Item}
     acpi_item=packed record
               acpitype:byte;
               case Byte of
               0:(rsdp:Pacpi_rsdp;);
               1:(rsdt:Pacpi_rsdt;);
               2:(xsdt:Pacpi_xsdt;);
               3:(fadt:Pacpi_fadt;);
               4:(facs:Pacpi_facs;);
               5:(dsdt:Pacpi_dsdt;);
               6:(ssdt:Pacpi_ssdt;);
               7:(madt:Pacpi_madt;);
               8:(psdt:Pacpi_psdt;);
               9:(sbst:Pacpi_sbst;);
               10:(ecdt:Pacpi_ecdt;);
               11:(slit:Pacpi_slit;);
               12:(srat:Pacpi_srat;);
               13:(cpep:Pacpi_cpep;);
               14:(msct:Pacpi_msct;);
               15:(rasf:Pacpi_rasf;);
               16:(ras2:Pacpi_ras2;);
               17:(mpst:Pacpi_mpst;);
               18:(pmtt:Pacpi_pmtt;);
               19:(bgrt:Pacpi_bgrt;);
               20:(fpdt:Pacpi_fpdt;);
               21:(gtdt:Pacpi_gtdt;);
               22:(nfit:Pacpi_nfit;);
               23:(hmat:Pacpi_hmat;);
               24:(pdtt:Pacpi_pdtt;);
               25:(pptt:Pacpi_pptt;);
               26:(sdev:Pacpi_sdev;);
               27:(phat:Pacpi_phat;);
               28:(viot:Pacpi_viot;);
               29:(misc:Pacpi_misc;);
               30:(ccel:Pacpi_ccel;);
               31:(skvl:Pacpi_skvl;);
               end;
     Pacpi_tree=^acpi_tree;
     acpi_search_list=packed record
                      item:^acpi_item;
                      count:dword;
                      end;
     acpi_tree=packed record
               item:acpi_item;
               child:^acpi_tree;
               count:dword;
               end;
     acpi_processor=packed record
                    BaseInterruptAddress:Pointer;
                    {For i386/x86_64/ia64 Only}
                    LocalAPICId:^byte;
                    LocalAPICCount:byte;
                    IOAPICAddress:^Pointer;
                    IOAPICCount:dword;
                    BaseInterruptOverrideAddress:Pointer;
                    IOSAPICAddress:^Pointer;
                    IOSAPICCount:dword;
                    {For Arm/AArch64 Only}
                    GICParkedAddress:^Pointer;
                    GICBaseAddress:^Pointer;
                    GICCCount:dword;
                    GICDBaseAddress:^Pointer;
                    GICDCount:dword;
                    GICMSIFrameBaseAddress:^Pointer;
                    GICMSIFrameCount:dword;
                    GICRBaseAddress:^Pointer;
                    GICRLength:^dword;
                    GICRCount:dword;
                    GICITSBaseAddress:^Pointer;
                    GICITSCount:dword;
                    {For LoongArch Only}
                    LIOPICBaseAddress:^Pointer;
                    LIOPICSize:^word;
                    LIOPICCount:dword;
                    HTPICBaseAddress:^Pointer;
                    HTPICSize:^word;
                    HTPICCount:dword;
                    MessageBaseAddress:^Pointer;
                    MessageCount:dword;
                    BIOPICBaseAddress:^Pointer;
                    BIOPICSize:^word;
                    BIOCount:dword;
                    LPCPICBaseAddress:^Pointer;
                    LPCPICSize:^word;
                    LPCPICCount:dword;
                    end;
     acpi_cpu_info=packed record
                   architecture:byte;
                   {Core Interrupt Information}
                   Processor:acpi_processor;
                   end;
     acpi_cpu_x86_local_apic_id_register=packed record
                                         Reserved1:array[1..3] of byte;
                                         ID:byte;
                                         Reserved2:array[1..12] of byte;
                                         end;
     acpi_cpu_x86_local_apic_version_register=bitpacked record
                                              Version:byte;
                                              Reserved1:byte;
                                              MaxLVTEntry:byte;
                                              SupportEOIbroadCastsuppression:0..1;
                                              Reserved2:0..127;
                                              Reserved3:array[1..12] of byte;
                                              end;
     acpi_cpu_x86_local_apic_timer_register=bitpacked record
                                            Vector:byte;
                                            Reserved1:0..15;
                                            DeliveryStatus:0..1;
                                            Reserved2:0..7;
                                            Mask:0..1;
                                            TimerMode:0..3;
                                            Reserved3:0..8191;
                                            Reserved4:array[1..12] of byte;
                                            end;
     acpi_cpu_x86_local_apic_cmci_register=bitpacked record
                                           Vector:byte;
                                           DeliveryMode:0..7;
                                           Reserved1:0..1;
                                           DeliveryStatus:0..1;
                                           Reserved2:0..7;
                                           Mask:0..1;
                                           Reserved3:0..32767;
                                           Reserved4:array[1..12] of byte;
                                           end;
     acpi_cpu_x86_local_apic_lint_register=bitpacked record
                                           Vector:byte;
                                           DeliveryMode:0..7;
                                           Reserved1:0..1;
                                           DeliveryStatus:0..1;
                                           InterruptInputPinPolarity:0..1;
                                           RemoteIRRFlag:0..1;
                                           TriggerMode:0..1;
                                           Mask:0..1;
                                           Reserved2:0..32767;
                                           Reserved3:array[1..12] of byte;
                                           end;
     acpi_cpu_x86_local_apic_error_register=bitpacked record
                                            Vector:byte;
                                            Reserved1:0..15;
                                            DeliveryStatus:0..1;
                                            Reserved2:0..7;
                                            Mask:0..1;
                                            Reserved3:0..32767;
                                            Reserved4:array[1..12] of byte;
                                            end;
     acpi_cpu_x86_local_apic_performance_monitoring_counters_register=bitpacked record
                                                                      Vector:byte;
                                                                      DeliveryMode:0..7;
                                                                      Reserved1:0..1;
                                                                      DeliveryStatus:0..1;
                                                                      Reserved2:0..7;
                                                                      Mask:0..1;
                                                                      Reserved3:0..32767;
                                                                      Reserved4:array[1..12] of byte;
                                                                      end;
     acpi_cpu_x86_local_thermal_sensor_register=bitpacked record
                                                Vector:byte;
                                                DeliveryMode:0..7;
                                                Reserved1:0..1;
                                                DeliveryStatus:0..1;
                                                Reserved2:0..7;
                                                Mask:0..1;
                                                Reserved3:0..32767;
                                                Reserved4:array[1..12] of byte;
                                                end;
     acpi_cpu_x86_error_status_register=bitpacked record
                                        SendCheckSumError:0..1;
                                        ReceiveCheckSumError:0..1;
                                        SendAcceptError:0..1;
                                        ReceiveAcceptError:0..1;
                                        RedirectableIPI:0..1;
                                        SendIllegalVector:0..1;
                                        ReceiveIllegalVector:0..1;
                                        IllegalRegisterAddress:0..1;
                                        Reserved:0..16777215;
                                        Reserved2:array[1..12] of byte;
                                        end;
     acpi_cpu_x86_Divide_Configuration_register=bitpacked record
                                                DivideValue1:0..3;
                                                Reserved1:0..1;
                                                DivideValue2:0..1;
                                                Reserved2:0..$FFFFFFF;
                                                Reserved3:array[1..12] of byte;
                                                end;
     acpi_cpu_x86_count_register=packed record
                                 Count:dword;
                                 Reserved1:array[1..12] of byte;
                                 end;
     acpi_cpu_x86_interrupt_command_register_low32=bitpacked record
                                                   Vector:byte;
                                                   DeliveryMode:0..7;
                                                   DestinationMode:0..1;
                                                   DeliveryStatus:0..1;
                                                   Reserved1:0..1;
                                                   Level:0..1;
                                                   TriggerMode:0..1;
                                                   Reserved2:0..3;
                                                   DestinationShortHand:0..3;
                                                   Reserved3:0..4095;
                                                   Reserved4:array[1..12] of byte;
                                                   end;
     acpi_cpu_x86_interrupt_command_register_high32=bitpacked record
                                                    Reserved:0..16777215;
                                                    DestinationField:0..255;
                                                    Reserved4:array[1..12] of byte;
                                                    end;
     acpi_cpu_x86_task_priority_register=bitpacked record
                                         TaskPrioritySubClass:0..15;
                                         TaskPriorityClass:0..15;
                                         Reserved:0..16777215;
                                         Reserved2:array[1..12] of byte;
                                         end;
     acpi_cpu_x86_fixed_interrupt_register=bitpacked record
                                           Reserved:0..65535;
                                           Other:array[1..14] of byte;
                                           end;
     acpi_cpu_x86_logical_destination_register=bitpacked record
                                               Reserved1:0..$FFFFFF;
                                               LogicalAPICID:0..$FF;
                                               Reserved2:array[1..12] of byte;
                                               end;
     acpi_cpu_x86_destination_format_register=bitpacked record
                                              Reserved1:0..$FFFFFFF;
                                              Model:0..$F;
                                              Reserved2:array[1..12] of byte;
                                              end;
     acpi_cpu_x86_arbitation_priority_register=bitpacked record
                                               ArbitationPrioritySubClass:0..15;
                                               ArbitationPriorityClass:0..15;
                                               Reserved1:0..$FFFFFF;
                                               Reserved2:array[1..12] of byte;
                                               end;
     acpi_cpu_x86_processor_priority_register=bitpacked record
                                              ProcessorPrioritySubClass:0..15;
                                              ProcessorPriorityClass:0..15;
                                              Reserved1:0..$FFFFFF;
                                              Reserved2:array[1..12] of byte;
                                              end;
     acpi_cpu_x86_eoi_register=bitpacked record
                               Content:dword;
                               Reserved:array[1..12] of byte;
                               end;
     acpi_cpu_x86_spurious_interrupt_vector_register=bitpacked record
                                                     SpuriousVector:byte;
                                                     EnableAPIC:0..1;
                                                     FocusProcessorChecking:0..1;
                                                     Reserved1:0..3;
                                                     EOIBroadCastSuppression:0..1;
                                                     Reserved2:0..$7FFFF;
                                                     Reserved3:array[1..12] of byte;
                                                     end;
     acpi_cpu_x86_local_apic=packed record
                             Reserved1:array[1..8] of dword;
                             LocalAPICIDRegister:acpi_cpu_x86_local_apic_id_register;
                             LocalAPICVersionRegister:acpi_cpu_x86_local_apic_version_register;
                             Reserved2:array[1..16] of dword;
                             TaskPriorityRegister:acpi_cpu_x86_task_priority_register;
                             ArbitrationPriorityRegister:acpi_cpu_x86_arbitation_priority_register;
                             ProcessorPriorityRegister:acpi_cpu_x86_processor_priority_register;
                             EOIRegister:acpi_cpu_x86_eoi_register;
                             RemoteReadRegister:array[1..4] of dword;
                             LogicalDestinationRegister:acpi_cpu_x86_logical_destination_register;
                             DestinationFormatRegister:acpi_cpu_x86_destination_format_register;
                             SpuriousInterruptVectorRegister:acpi_cpu_x86_spurious_interrupt_vector_register;
                             ISR1,ISR2,ISR3,ISR4,ISR5,ISR6,ISR7,ISR8:acpi_cpu_x86_fixed_interrupt_register;
                             TMR1,TMR2,TMR3,TMR4,TMR5,TMR6,TMR7,TMR8:acpi_cpu_x86_fixed_interrupt_register;
                             IRR1,IRR2,IRR3,IRR4,IRR5,IRR6,IRR7,IRR8:acpi_cpu_x86_fixed_interrupt_register;
                             ErrorStatusRegister:acpi_cpu_x86_error_status_register;
                             Reserved3:array[1..24] of dword;
                             LVTCMCIRegister:acpi_cpu_x86_local_apic_cmci_register;
                             ICR1:acpi_cpu_x86_interrupt_command_register_low32;
                             ICR2:acpi_cpu_x86_interrupt_command_register_high32;
                             LVTTimerRegister:acpi_cpu_x86_local_apic_timer_register;
                             LVTThermalSensorRegister:acpi_cpu_x86_local_thermal_sensor_register;
                             LVTPerformanceMonitoringCountersRegister:acpi_cpu_x86_local_apic_performance_monitoring_counters_register;
                             LVTLInt0Register:acpi_cpu_x86_local_apic_lint_register;
                             LVTLInt1Register:acpi_cpu_x86_local_apic_lint_register;
                             LVTErrorRegister:acpi_cpu_x86_local_apic_error_register;
                             InitialCountRegisterForTimer:acpi_cpu_x86_count_register;
                             CurrentCountRegisterForTimer:acpi_cpu_x86_count_register;
                             Reserved4:array[1..16] of dword;
                             DivideConfigurationRegisterForTimer:acpi_cpu_x86_Divide_Configuration_register;
                             Reserved5:array[1..4] of dword;
                             end;
     Pacpi_cpu_x86_local_apic=^acpi_cpu_x86_local_apic;
     acpi_request=packed record
                  requestAPICIndex:byte;
                  requestrootclass:byte;
                  requestsubclass:byte;
                  requesttimer:dword;
                  requesttimerstatus:byte;
                  requestnumber:byte;
                  requestDelivery:byte;
                  requestDeliveryMode:byte;
                  end;
     acpi_processor_item=packed record
                         case Byte of
                         0:(x86localapic:Pacpi_cpu_x86_local_apic;);
                         end;

const acpi_persistent_memory_region_guid:acpi_guid=(data1:$66F0D379;data2:$B4F3;data3:$4074;data4:
($AC,$43,$0D,$33,$18,$B7,$8C,$DB));
      acpi_NVIDMM_Control_region_guid:acpi_guid=(data1:$92F701F6;data2:$13B4;data3:$405D;data4:
($91,$0B,$29,$93,$67,$E8,$23,$4C));
      acpi_NVIDMM_Block_Data_Window_Region_guid:acpi_guid=(data1:$91AF0430;data2:$5D86;data3:$470E;data4:
($A6,$B0,$0A,$2D,$B9,$40,$82,$49));
      acpi_RAM_disk_supporting_a_virtual_disk_region_volatile:acpi_guid=(data1:$77AB535A;data2:$45FC;data3:$624B;data4:
($55,$60,$F7,$B2,$81,$D1,$F9,$6E));
      acpi_RAM_disk_supporting_a_virtual_CD_region_volatile:acpi_guid=(data1:$3D5ABD30;data2:$4175;data3:$87CE;data4:
($6D,$64,$D2,$AD,$E5,$23,$C4,$BB));
      acpi_RAM_disk_supporting_a_virtual_disk_region_persistent:acpi_guid=(data1:$5CEA02C9;data2:$4D07;data3:$69D3;data4:
($26,$9F,$44,$96,$FB,$E0,$96,$F9));
      acpi_RAM_disk_supporting_a_virtual_CD_region_persistent:acpi_guid=(data1:$08018188;data2:$42CD;data3:$BB48;data4:
($10,$0F,$53,$87,$D5,$3D,$ED,$3D));
      acpi_i386:byte=0;
      acpi_x86_64:byte=1;
      acpi_ia64:byte=2;
      acpi_arm:byte=3;
      acpi_arm64:byte=4;
      acpi_riscv32:byte=5;
      acpi_riscv64:byte=6;
      acpi_loongarch32:byte=7;
      acpi_loongarch64:byte=8;
      acpi_request_x86_local_apic:byte=0;
      acpi_request_x86_local_apic_timer:byte=0;
      acpi_request_x86_local_apic_error:byte=1;
      acpi_request_x86_local_apic_lint0:byte=2;
      acpi_request_x86_local_apic_lint1:byte=3;
      acpi_request_x86_local_apic_cmci:byte=4;
      acpi_request_x86_local_apic_thermal:byte=5;
      acpi_request_x86_local_apic_performance:byte=6;
      acpi_request_x86_delivery_fixed=0;
      acpi_request_x86_delivery_smi=2;
      acpi_request_x86_delivery_nmi=4;
      acpi_request_x86_delivery_init=5;
      acpi_request_x86_delivery_external=7;
      acpi_request_x86_timer_one_shot=0;
      acpi_request_x86_timer_periodic=1;

var os_cpuinfo:acpi_cpu_info;

function acpi_get_cpu_info_from_acpi_table(ptr:Pointer):acpi_cpu_info;
procedure acpi_cpu_request_interrupt(cpu:acpi_cpu_info;request:acpi_request);

implementation

function acpi_get_architecture:byte;
begin
 {$IF Defined(cpui386)}
 acpi_get_architecture:=acpi_i386;
 {$ELSEIF Defined(cpux86_64)}
 acpi_get_architecture:=acpi_x86_64;
 {$ELSEIF Defined(cpuia64)}
 acpi_get_architecture:=acpi_ia64;
 {$ELSEIF Defined(cpuarm)}
 acpi_get_architecture:=acpi_arm;
 {$ELSEIF Defined(cpuaarch64)}
 acpi_get_architecture:=acpi_arm64;
 {$ELSEIF Defined(cpuriscv32)}
 acpi_get_architecture:=acpi_riscv32;
 {$ELSEIF Defined(cpuriscv64)}
 acpi_get_architecture:=acpi_riscv64;
 {$ELSEIF Defined(cpuloongarch32)}
 acpi_get_architecture:=acpi_loongarch32;
 {$ELSEIF Defined(cpuloongarch64)}
 acpi_get_architecture:=acpi_loongarch64;
 {$ENDIF}
end;
function acpi_check_signature(const originalsign;const comparesign;len:byte):boolean;
var i:byte;
    ptr1,ptr2:Pbyte;
begin
 i:=1; ptr1:=@originalsign; ptr2:=@comparesign;
 while(i<=len)do
  begin
   if((ptr1+i-1)^<>(ptr2+i-1)^) then break;
   inc(i);
  end;
 acpi_check_signature:=i>len;
end;
function acpi_generate_item(ptr:Pointer):acpi_item;
var res:acpi_item;
begin
 if(acpi_check_signature(ptr^,acpi_rsdp_signature,8)) then
  begin
   res.acpitype:=acpi_type_rsdp; res.rsdp:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_rsdt_signature,4)) then
  begin
   res.acpitype:=acpi_type_rsdt; res.rsdt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_xsdt_signature,4)) then
  begin
   res.acpitype:=acpi_type_xsdt; res.xsdt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_fadt_signature,4)) then
  begin
   res.acpitype:=acpi_type_fadt; res.fadt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_facs_signature,4)) then
  begin
   res.acpitype:=acpi_type_facs; res.facs:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_dsdt_signature,4)) then
  begin
   res.acpitype:=acpi_type_dsdt; res.dsdt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_ssdt_signature,4)) then
  begin
   res.acpitype:=acpi_type_ssdt; res.ssdt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_psdt_signature,4)) then
  begin
   res.acpitype:=acpi_type_psdt; res.psdt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_madt_signature,4)) then
  begin
   res.acpitype:=acpi_type_madt; res.madt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_sbst_signature,4)) then
  begin
   res.acpitype:=acpi_type_sbst; res.sbst:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_ecdt_signature,4)) then
  begin
   res.acpitype:=acpi_type_ecdt; res.ecdt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_srat_signature,4)) then
  begin
   res.acpitype:=acpi_type_srat; res.srat:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_slit_signature,4)) then
  begin
   res.acpitype:=acpi_type_slit; res.slit:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_cpep_signature,4)) then
  begin
   res.acpitype:=acpi_type_cpep; res.cpep:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_msct_signature,4)) then
  begin
   res.acpitype:=acpi_type_msct; res.msct:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_rasf_signature,4)) then
  begin
   res.acpitype:=acpi_type_rasf; res.rasf:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_ras2_signature,4)) then
  begin
   res.acpitype:=acpi_type_ras2; res.ras2:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_mpst_signature,4)) then
  begin
   res.acpitype:=acpi_type_mpst; res.mpst:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_pmtt_signature,4)) then
  begin
   res.acpitype:=acpi_type_pmtt; res.pmtt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_bgrt_signature,4)) then
  begin
   res.acpitype:=acpi_type_bgrt; res.bgrt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_fpdt_signature,4)) then
  begin
   res.acpitype:=acpi_type_fpdt; res.fpdt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_gtdt_signature,4)) then
  begin
   res.acpitype:=acpi_type_gtdt; res.gtdt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_nfit_signature,4)) then
  begin
   res.acpitype:=acpi_type_nfit; res.nfit:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_sdev_signature,4)) then
  begin
   res.acpitype:=acpi_type_sdev; res.sdev:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_hmat_signature,4)) then
  begin
   res.acpitype:=acpi_type_hmat; res.hmat:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_pdtt_signature,4)) then
  begin
   res.acpitype:=acpi_type_pdtt; res.pdtt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_pptt_signature,4)) then
  begin
   res.acpitype:=acpi_type_pptt; res.pptt:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_phat_signature,4)) then
  begin
   res.acpitype:=acpi_type_phat; res.phat:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_viot_signature,4)) then
  begin
   res.acpitype:=acpi_type_viot; res.viot:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_misc_signature,4)) then
  begin
   res.acpitype:=acpi_type_misc; res.misc:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_ccel_signature,4)) then
  begin
   res.acpitype:=acpi_type_ccel; res.ccel:=ptr;
  end
 else if(acpi_check_signature(ptr^,acpi_skvl_signature,4)) then
  begin
   res.acpitype:=acpi_type_skvl; res.skvl:=ptr;
  end
 else
  begin
   res.acpitype:=$FF; res.xsdt:=nil;
  end;
 acpi_generate_item:=res;
end;
function acpi_item_get_length(item:acpi_item):dword;
begin
 if(item.acpitype=acpi_type_rsdp) then
 acpi_item_get_length:=item.rsdp^.length
 else
 acpi_item_get_length:=item.xsdt^.hdr.length;
end;
function acpi_item_get_entry_number(item:acpi_item):dword;
var num:dword;
begin
 if(item.acpitype=acpi_type_rsdt) then
  begin
   num:=(item.rsdt^.hdr.length-sizeof(acpi_sdth)) shr 2;
  end
 else if(item.acpitype=acpi_type_xsdt) then
  begin
   num:=(item.xsdt^.hdr.length-sizeof(acpi_sdth)) shr 3;
  end
 else num:=0;
 acpi_item_get_entry_number:=num;
end;
function acpi_generate_tree_from_acpi_table(inputtree:Pacpi_tree;ptr:Pointer):Pacpi_tree;
var tree:Pacpi_tree;
    entrynum,i:dword;
    item:acpi_item;
begin
 item:=acpi_generate_item(ptr);
 if(inputtree=nil) then tree:=allocmem(sizeof(acpi_tree)) else tree:=inputtree;
 tree^.item:=item;
 if(item.acpitype=acpi_type_rsdp) then
  begin
   if(item.rsdp^.revision=1) then
    begin
     tree^.child:=allocmem(sizeof(acpi_tree));
     tree^.count:=1;
     acpi_generate_tree_from_acpi_table(tree^.child,Pointer(item.rsdp^.rsdtaddress));
    end
   else if(item.rsdp^.revision>1) then
    begin
     tree^.child:=allocmem(sizeof(acpi_tree));
     tree^.count:=1;
     acpi_generate_tree_from_acpi_table(tree^.child,Pointer(item.rsdp^.xsdtaddress));
    end;
  end
 else if(item.acpitype=acpi_type_rsdt) then
  begin
   entrynum:=acpi_item_get_entry_number(item);
   tree^.child:=allocmem(sizeof(acpi_tree)*entrynum);
   tree^.count:=entrynum; i:=1;
   while(i<=tree^.count)do
    begin
     if(item.rsdt^.Entry[i]<>0) then
      begin
       acpi_generate_tree_from_acpi_table(tree^.child+i-1,Pointer(item.rsdt^.Entry[i]));
      end;
     inc(i);
    end;
  end
 else if(item.acpitype=acpi_type_xsdt) then
  begin
   entrynum:=acpi_item_get_entry_number(item);
   tree^.child:=allocmem(sizeof(acpi_tree)*entrynum);
   tree^.count:=entrynum; i:=1;
   while(i<=tree^.count)do
    begin
     if(item.xsdt^.Entry[i]<>0) then
      begin
       acpi_generate_tree_from_acpi_table(tree^.child+i-1,Pointer(item.xsdt^.Entry[i]));
      end;
     inc(i);
    end;
  end
 else if(item.acpitype=acpi_type_fadt) then
  begin
   entrynum:=0;
   if(item.fadt^.ExtendedDSDTAddress<>0) or (item.fadt^.dsdtaddress<>0) then inc(entrynum);
   if(item.fadt^.ExtendedFACSAddress<>0) or (item.fadt^.facsaddress<>0) then inc(entrynum);
   tree^.child:=allocmem(entrynum*sizeof(acpi_tree));
   tree^.count:=entrynum; i:=0;
   if(item.fadt^.ExtendedDSDTAddress<>0) then
    begin
     inc(i);
     acpi_generate_tree_from_acpi_table(tree^.child+i-1,Pointer(item.fadt^.ExtendedDSDTAddress));
    end
   else if(item.fadt^.ExtendedFACSAddress<>0) then
    begin
     inc(i);
     acpi_generate_tree_from_acpi_table(tree^.child+i-1,Pointer(item.fadt^.DSDTAddress));
    end;
   if(item.fadt^.ExtendedFACSAddress<>0) then
    begin
     inc(i);
     acpi_generate_tree_from_acpi_table(tree^.child+i-1,Pointer(item.fadt^.ExtendedFACSAddress));
    end
   else if(item.fadt^.facsaddress<>0) then
    begin
     inc(i);
     acpi_generate_tree_from_acpi_table(tree^.child+i-1,Pointer(item.fadt^.facsaddress));
    end;
  end;
 acpi_generate_tree_from_acpi_table:=tree;
end;
procedure acpi_tree_free(var tree:Pacpi_tree);
var i:dword;
    temptree:Pacpi_tree;
begin
 i:=1;
 while(i<=tree^.count)do
  begin
   temptree:=tree^.child+i-1;
   acpi_tree_free(temptree);
   inc(i);
  end;
 freemem(tree);
end;
function acpi_tree_search_for_madt(tree:Pacpi_tree):Pointer;
var ptr:Pointer;
    i:dword;
begin
 if(tree^.item.acpitype=acpi_type_madt) then
  begin
   ptr:=tree^.item.madt;
  end
 else
  begin
   i:=1; ptr:=nil;
   while(i<=tree^.count)do
    begin
     ptr:=acpi_tree_search_for_madt(tree^.child+i-1);
     if(ptr<>nil) then break;
     inc(i);
    end;
  end;
 acpi_tree_search_for_madt:=ptr;
end;
function acpi_tree_parse_madt_to_cpu_info(madt:Pacpi_madt):acpi_cpu_info;
var offset,madtlength,madtstart:dword;
    i:dword;
    ptr:Pbyte;
    tempptr:Pointer;
    tempnum:dword;
    res:acpi_cpu_info;
begin
 if(madt=nil) then
  begin
   res.architecture:=$FF; exit(res);
  end;
 madtlength:=madt^.hdr.length-sizeof(acpi_madt)+1;
 madtstart:=sizeof(acpi_madt)-1; offset:=madtstart;
 res.architecture:=acpi_get_architecture;
 ptr:=@res.Processor;
 for i:=1 to sizeof(res.Processor) do PByte(ptr+i-1)^:=0;
 res.Processor.BaseInterruptAddress:=Pointer(madt^.LocalInterruptControllerAddress);
 ptr:=Pointer(madt);
 while(offset<=madtlength)do
  begin
   if((ptr+offset)^=0) then
    begin
     inc(res.Processor.LocalAPICCount);
     tempnum:=Pacpi_madt_processor_local_apic_structure(ptr)^.APICId;
     ReallocMem(res.Processor.LocalAPICId,res.Processor.LocalAPICCount);
     (res.Processor.LocalAPICId+res.Processor.LocalAPICCount-1)^:=tempnum;
     inc(offset,sizeof(acpi_madt_processor_local_apic_structure)); continue;
    end
   else if((ptr+offset)^=1) then
    begin
     inc(res.Processor.IOAPICCount);
     tempptr:=Pointer(Pacpi_madt_io_apic_structure(ptr)^.IOAPICAddress);
     ReallocMem(res.Processor.IOAPICAddress,sizeof(Pointer)*res.Processor.IOAPICCount);
     (res.Processor.IOAPICAddress+res.Processor.IOAPICCount-1)^:=tempptr;
     inc(offset,sizeof(acpi_madt_io_apic_structure)); continue;
    end
   else if((ptr+offset)^=2) then
    begin
     inc(offset,sizeof(acpi_madt_interrupt_source_override)); continue;
    end
   else if((ptr+offset)^=3) then
    begin
     inc(offset,sizeof(acpi_madt_nmi_source_structure)); continue;
    end
   else if((ptr+offset)^=4) then
    begin
     inc(offset,sizeof(acpi_madt_local_apic_nmi_structure)); continue;
    end
   else if((ptr+offset)^=5) then
    begin
     tempptr:=Pointer(Pacpi_madt_local_apic_address_override_structure(ptr)^.LocalAPICAddress);
     res.Processor.BaseInterruptOverrideAddress:=tempptr;
     inc(offset,sizeof(acpi_madt_local_apic_address_override_structure)); continue;
    end
   else if((ptr+offset)^=6) then
    begin
     inc(res.Processor.IOSAPICCount);
     tempptr:=Pointer(Pacpi_madt_io_sapic_structure(ptr)^.IOSAPICAddress);
     ReallocMem(res.Processor.IOSAPICAddress,sizeof(Pointer)*res.Processor.IOSAPICCount);
     (res.Processor.IOSAPICAddress+res.Processor.IOSAPICCount-1)^:=tempptr;
     inc(offset,sizeof(acpi_madt_io_sapic_structure)); continue;
    end
   else if((ptr+offset)^=7) then
    begin
     inc(offset,sizeof(acpi_madt_local_sapic_structure)); continue;
    end
   else if((ptr+offset)^=8) then
    begin
     inc(offset,sizeof(acpi_madt_platform_interrupt_source_structure)); continue;
    end
   else if((ptr+offset)^=9) then
    begin
     inc(offset,sizeof(acpi_madt_processor_local_2_apic_structure)); continue;
    end
   else if((ptr+offset)^=$A) then
    begin
     inc(offset,sizeof(acpi_madt_local_2_apic_nmi_structure)); continue;
    end
   else if((ptr+offset)^=$B) then
    begin
     inc(res.Processor.GICCCount);
     tempptr:=Pointer(Pacpi_madt_gicc_structure(ptr)^.ParkedAddress);
     ReallocMem(res.Processor.GICParkedAddress,sizeof(Pointer)*res.Processor.GICCCount);
     (res.Processor.GICParkedAddress+res.Processor.GICCCount-1)^:=tempptr;
     tempptr:=Pointer(Pacpi_madt_gicc_structure(ptr)^.PhysicalBaseAddress);
     ReallocMem(res.Processor.GICBaseAddress,sizeof(Pointer)*res.Processor.GICCCount);
     (res.Processor.GICBaseAddress+res.Processor.GICCCount-1)^:=tempptr;
     inc(offset,sizeof(acpi_madt_gicc_structure)); continue;
    end
   else if((ptr+offset)^=$C) then
    begin
     inc(res.Processor.GICDCount);
     tempptr:=Pointer(Pacpi_madt_gicd_structure(ptr)^.PhysicalBaseAddress);
     ReallocMem(res.Processor.GICDBaseAddress,sizeof(Pointer)*res.Processor.GICDCount);
     (res.Processor.GICDBaseAddress+res.Processor.GICCCount-1)^:=tempptr;
     inc(offset,sizeof(acpi_madt_gicd_structure)); continue;
    end
   else if((ptr+offset)^=$D) then
    begin
     inc(res.Processor.GICMSIFrameCount);
     tempptr:=Pointer(Pacpi_madt_gic_msi_frame_structure(ptr)^.PhysicalBaseAddress);
     ReallocMem(res.Processor.GICMSIFrameBaseAddress,sizeof(Pointer)*res.Processor.GICDCount);
     (res.Processor.GICMSIFrameBaseAddress+res.Processor.GICMSIFrameCount-1)^:=tempptr;
     inc(offset,sizeof(acpi_madt_gic_msi_frame_structure)); continue;
    end
   else if((ptr+offset)^=$E) then
    begin
     inc(res.Processor.GICRCount);
     tempptr:=Pointer(Pacpi_madt_gicr_structure(ptr)^.DiscoveryRangeBaseAddress);
     tempnum:=Pacpi_madt_gicr_structure(ptr)^.DiscoveryRangeBaseLength;
     ReallocMem(res.Processor.GICRBaseAddress,sizeof(Pointer)*res.Processor.GICDCount);
     ReallocMem(res.Processor.GICRLength,sizeof(dword)*res.Processor.GICDCount);
     (res.Processor.GICRBaseAddress+res.Processor.GICRCount-1)^:=tempptr;
     (res.Processor.GICRLength+res.Processor.GICRCount-1)^:=tempnum;
     inc(offset,sizeof(acpi_madt_gicr_structure)); continue;
    end
   else if((ptr+offset)^=$f) then
    begin
     inc(res.Processor.GICITSCount);
     tempptr:=Pointer(Pacpi_madt_gic_its_structure(ptr)^.PhysicalBaseAddress);
     ReallocMem(res.Processor.GICITSBaseAddress,sizeof(Pointer)*res.Processor.GICITSCount);
     (res.Processor.GICITSBaseAddress+res.Processor.GICITSCount-1)^:=tempptr;
     inc(offset,sizeof(acpi_madt_gic_its_structure)); continue;
    end
   else if((ptr+offset)^=$10) then
    begin
     inc(offset,sizeof(acpi_madt_multiprocessor_wakeup_structure)); continue;
    end
   else if((ptr+offset)^=$11) then
    begin
     inc(offset,sizeof(acpi_madt_core_pic_structure)); continue;
    end
   else if((ptr+offset)^=$12) then
    begin
     inc(res.Processor.LIOPICCount);
     tempptr:=Pointer(Pacpi_madt_lio_pic_structure(ptr)^.BaseAddress);
     ReallocMem(res.Processor.LIOPICBaseAddress,sizeof(Pointer)*res.Processor.LIOPICCount);
     (res.Processor.LIOPICBaseAddress+res.Processor.LIOPICCount-1)^:=tempptr;
     tempnum:=Pacpi_madt_lio_pic_structure(ptr)^.Size;
     ReallocMem(res.Processor.LIOPICSize,sizeof(word)*res.Processor.LIOPICCount);
     (res.Processor.LIOPICSize+res.Processor.LIOPICCount-1)^:=tempnum;
     inc(offset,sizeof(acpi_madt_lio_pic_structure)); continue;
    end
   else if((ptr+offset)^=$13) then
    begin
     inc(res.Processor.HTPICCount);
     tempptr:=Pointer(Pacpi_madt_ht_pic_structure(ptr)^.BaseAddress);
     ReallocMem(res.Processor.HTPICBaseAddress,sizeof(Pointer)*res.Processor.HTPICCount);
     (res.Processor.HTPICBaseAddress+res.Processor.HTPICCount-1)^:=tempptr;
     tempnum:=Pacpi_madt_ht_pic_structure(ptr)^.Size;
     ReallocMem(res.Processor.HTPICSize,sizeof(word)*res.Processor.HTPICCount);
     (res.Processor.HTPICSize+res.Processor.HTPICCount-1)^:=tempnum;
     inc(offset,sizeof(acpi_madt_ht_pic_structure)); continue;
    end
   else if((ptr+offset)^=$14) then
    begin
     inc(offset,sizeof(acpi_madt_eio_pic_structure)); continue;
    end
   else if((ptr+offset)^=$15) then
    begin
     inc(res.Processor.MessageCount);
     tempptr:=Pointer(Pacpi_madt_msi_pic_structure(ptr)^.MessageAddress);
     ReallocMem(res.Processor.MessageBaseAddress,sizeof(Pointer)*res.Processor.MessageCount);
     (res.Processor.MessageBaseAddress+res.Processor.MessageCount-1)^:=tempptr;
     inc(offset,sizeof(acpi_madt_msi_pic_structure)); continue;
    end
   else if((ptr+offset)^=$16) then
    begin
     inc(res.Processor.BIOCount);
     tempptr:=Pointer(Pacpi_madt_bio_pic_structure(ptr)^.BaseAddress);
     ReallocMem(res.Processor.BIOPICBaseAddress,sizeof(Pointer)*res.Processor.BIOCount);
     (res.Processor.BIOPICBaseAddress+res.Processor.HTPICCount-1)^:=tempptr;
     tempnum:=Pacpi_madt_bio_pic_structure(ptr)^.Size;
     ReallocMem(res.Processor.BIOPICSize,sizeof(word)*res.Processor.BIOCount);
     (res.Processor.BIOPICSize+res.Processor.BIOCount-1)^:=tempnum;
     inc(offset,sizeof(acpi_madt_bio_pic_structure)); continue;
    end
   else if((ptr+offset)^=$17) then
    begin
     inc(res.Processor.LPCPICCount);
     tempptr:=Pointer(Pacpi_madt_lpc_pic_structure(ptr)^.BaseAddress);
     ReallocMem(res.Processor.lpcPICBaseAddress,sizeof(Pointer)*res.Processor.LPCPICCount);
     (res.Processor.lpcPICBaseAddress+res.Processor.HTPICCount-1)^:=tempptr;
     tempnum:=Pacpi_madt_lpc_pic_structure(ptr)^.Size;
     ReallocMem(res.Processor.lpcPICSize,sizeof(word)*res.Processor.lpcpicCount);
     (res.Processor.lpcPICSize+res.Processor.lpcpicCount-1)^:=tempnum;
     inc(offset,sizeof(acpi_madt_lpc_pic_structure)); continue;
    end
   else break;
  end;
 acpi_tree_parse_madt_to_cpu_info:=res;
end;
function acpi_get_cpu_info_from_acpi_table(ptr:Pointer):acpi_cpu_info;
var tree:Pacpi_tree;
    res:acpi_cpu_info;
begin
 tree:=nil;
 tree:=acpi_generate_tree_from_acpi_table(tree,ptr);
 ptr:=acpi_tree_search_for_madt(tree);
 res:=acpi_tree_parse_madt_to_cpu_info(ptr);
 acpi_tree_free(tree);
 acpi_get_cpu_info_from_acpi_table:=res;
end;
procedure acpi_cpu_request_interrupt(cpu:acpi_cpu_info;request:acpi_request);
var item:acpi_processor_item;
begin
 if(cpu.architecture=acpi_i386) or (cpu.architecture=acpi_x86_64)
 or(cpu.architecture=acpi_ia64) then
  begin
   if(request.requestrootclass=acpi_request_x86_local_apic) then
    begin
     if(cpu.Processor.BaseInterruptOverrideAddress<>nil) then
     item.x86localapic:=cpu.Processor.BaseInterruptOverrideAddress
     else item.x86localapic:=cpu.Processor.BaseInterruptAddress;
     if(item.x86localapic^.SpuriousInterruptVectorRegister.EnableAPIC=0) then
      begin
       item.x86localapic^.SpuriousInterruptVectorRegister.EnableAPIC:=1;
       item.x86localapic^.SpuriousInterruptVectorRegister.SpuriousVector:=$FF;
       item.x86localapic^.DivideConfigurationRegisterForTimer.DivideValue1:=3;
       item.x86localapic^.DivideConfigurationRegisterForTimer.DivideValue2:=1;
       item.x86localapic^.InitialCountRegisterForTimer.Count:=0;
       item.x86localapic^.LVTTimerRegister.Mask:=1;
      end;
     if(request.requestsubclass=acpi_request_x86_local_apic_timer) then
      begin
       item.x86localapic^.ICR1.DestinationShortHand:=2;
       item.x86localapic^.ICR2.DestinationField:=(cpu.Processor.LocalAPICId+request.requestAPICIndex-1)^;
       item.x86localapic^.InitialCountRegisterForTimer.Count:=request.requesttimer;
       item.x86localapic^.LVTTimerRegister.TimerMode:=request.requesttimerstatus;
       item.x86localapic^.LVTTimerRegister.Mask:=0;
       item.x86localapic^.LVTTimerRegister.Vector:=request.requestnumber-1;
      end
     else if(request.requestsubclass=acpi_request_x86_local_apic_error) then
      begin
       item.x86localapic^.ICR1.DestinationShortHand:=2;
       item.x86localapic^.ICR2.DestinationField:=(cpu.Processor.LocalAPICId+request.requestAPICIndex-1)^;
       item.x86localapic^.LVTErrorRegister.Mask:=0;
       item.x86localapic^.LVTErrorRegister.Vector:=request.requestnumber-1;
      end
     else if(request.requestsubclass=acpi_request_x86_local_apic_lint0) then
      begin
       item.x86localapic^.ICR1.DestinationShortHand:=2;
       item.x86localapic^.ICR2.DestinationField:=(cpu.Processor.LocalAPICId+request.requestAPICIndex-1)^;
       item.x86localapic^.LVTLInt0Register.Mask:=0;
       item.x86localapic^.LVTLInt0Register.InterruptInputPinPolarity:=1;
       item.x86localapic^.LVTLInt0Register.DeliveryMode:=request.requestDeliveryMode;
       item.x86localapic^.LVTLInt0Register.TriggerMode:=1;
       item.x86localapic^.LVTLInt0Register.Vector:=request.requestnumber-1;
      end
     else if(request.requestsubclass=acpi_request_x86_local_apic_lint1) then
      begin
       item.x86localapic^.ICR1.DestinationShortHand:=2;
       item.x86localapic^.ICR2.DestinationField:=(cpu.Processor.LocalAPICId+request.requestAPICIndex-1)^;
       item.x86localapic^.LVTLInt1Register.Mask:=0;
       item.x86localapic^.LVTLInt1Register.InterruptInputPinPolarity:=1;
       item.x86localapic^.LVTLInt1Register.DeliveryMode:=request.requestDeliveryMode;
       item.x86localapic^.LVTLInt1Register.TriggerMode:=1;
       item.x86localapic^.LVTLInt1Register.Vector:=request.requestnumber-1;
      end
     else if(request.requestsubclass=acpi_request_x86_local_apic_cmci) then
      begin
       item.x86localapic^.ICR1.DestinationShortHand:=2;
       item.x86localapic^.ICR2.DestinationField:=(cpu.Processor.LocalAPICId+request.requestAPICIndex-1)^;
       item.x86localapic^.LVTCMCIRegister.Mask:=0;
       item.x86localapic^.LVTCMCIRegister.DeliveryMode:=request.requestDeliveryMode;
       item.x86localapic^.LVTCMCIRegister.Vector:=request.requestnumber-1;
      end
     else if(request.requestsubclass=acpi_request_x86_local_apic_thermal) then
      begin
       item.x86localapic^.ICR1.DestinationShortHand:=2;
       item.x86localapic^.ICR2.DestinationField:=(cpu.Processor.LocalAPICId+request.requestAPICIndex-1)^;
       item.x86localapic^.LVTThermalSensorRegister.DeliveryMode:=request.requestDeliveryMode;
       item.x86localapic^.LVTThermalSensorRegister.Mask:=0;
       item.x86localapic^.LVTThermalSensorRegister.Vector:=request.requestnumber-1;
      end
     else if(request.requestsubclass=acpi_request_x86_local_apic_performance) then
      begin
       item.x86localapic^.ICR1.DestinationShortHand:=2;
       item.x86localapic^.ICR2.DestinationField:=(cpu.Processor.LocalAPICId+request.requestAPICIndex-1)^;
       item.x86localapic^.LVTPerformanceMonitoringCountersRegister.Mask:=0;
       item.x86localapic^.LVTPerformanceMonitoringCountersRegister.DeliveryMode:=request.requestDeliveryMode;
       item.x86localapic^.LVTPerformanceMonitoringCountersRegister.Vector:=request.requestnumber-1;
      end;
    end;
  end
 else if(cpu.architecture=acpi_arm) or (cpu.architecture=acpi_arm64) then
  begin

  end
 else if(cpu.architecture=acpi_riscv32) or (cpu.architecture=acpi_riscv64) then
  begin

  end
 else if(cpu.architecture=acpi_loongarch32) or (cpu.architecture=acpi_loongarch64) then
  begin

  end;
end;

end.

