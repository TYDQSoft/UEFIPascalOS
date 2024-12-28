unit acpi;

interface

const acpi_type_processor_local_apic:byte=0;
      acpi_type_io_apic:byte=1;
      acpi_type_Interrupt_Source_override:byte=2;
      acpi_type_Non_maskable_Interrupt_Source:byte=3;
      acpi_type_Local_APIC_NMI:byte=4;
      acpi_type_Local_APIC_Address_override:byte=5;
      acpi_type_io_sapic:byte=6;
      acpi_type_local_sapic:byte=7;
      acpi_type_platform_interrupt_sources:byte=8;
      acpi_type_processor_local_apic_2:byte=9;
      acpi_type_local_APIC_NMI_2:byte=$A;
      acpi_type_GIC_CPU_interface:byte=$B;
      acpi_type_GIC_Distributor:byte=$C;
      acpi_type_GIC_MSI_Frame:byte=$D;
      acpi_type_GIC_Redistributor:byte=$E;
      acpi_type_GIC_Interrupt_Translation_Service:byte=$F;
      acpi_type_Multiprocessor_wakeup:byte=$10;
      acpi_type_Core_PIC:byte=$11;
      acpi_type_Legacy_io_PIC:byte=$12;
      acpi_type_HyperTransport_PIC:byte=$13;
      acpi_type_Extend_io_PIC:byte=$14;
      acpi_type_MSI_PIC:byte=$15;
      acpi_type_Bridge_io_PIC:byte=$16;
      acpi_type_Low_Pin_Count_PIC:byte=$17;
      acpi_GICv1=1;
      acpi_GICv2=2;
      acpi_GICv3=3;
      acpi_GICv4=4;
      acpi_acpi_device_handle=0;
      acpi_pci_device_handle=1;
      acpi_rasf_reserved=0;
      acpi_rasf_execute_command=1;
      acpi_platform_ras_supported=0;
      acpi_platform_ras_supported_and_exposed=1;
      acpi_ras_feature_type_related_to_memory=0;
      acpi_fpdt_basic_boot_performance_table:word=$0000;
      acpi_fpdt_basic_S3_performance_table:word=$0001;
      acpi_fpdt_runtime_performance_resume:word=$0000;
      acpi_fpdt_runtime_performance_suspend:word=$0001;
      acpi_fpdt_runtime_basic_boot_performance_data_record:word=$0002;
      acpi_platform_timer_type_structure_GT_block:byte=$00;
      acpi_platform_timer_type_structure_Arm_Generic_Watchdog:byte=$01;
      acpi_type_system_physical_address_range_structure:word=0;
      acpi_type_NVDIMM_region_mapping_structure:word=1;
      acpi_type_InterLeave_Structure:word=2;
      acpi_type_SMBIOS_Management_Information_Structure:word=3;
      acpi_type_NVDIMM_Control_Region_Structure:word=4;
      acpi_type_NVDIMM_block_data_Window_Region_Structure:word=5;
      acpi_type_Flush_Hint_Address_Structure:word=6;
      acpi_type_Platform_Capabilities_Structure:word=7;
      acpi_namespace_device_based_secure_device:byte=0;
      acpi_PCIe_Endpoint_Device_based_Secure_Device:byte=1;
      acpi_identification_based_secure_access:byte=0;
      acpi_memory_based_secure_access:byte=1;
      acpi_memory_proximity_domain_attributes_structure:word=0;
      acpi_system_locality_latency_and_bandwidth_information_structure:word=1;
      acpi_memory_side_cache_information_structure:word=2;
      acpi_execute_platform_debug_trigger_doorbell_only:byte=0;
      acpi_execute_platform_debug_trigger_vendor_specific_command:byte=1;
      acpi_phat_firmware_version_data_record:word=$0000;
      acpi_phat_firmware_health_data_record:word=$0001;
      acpi_phat_version_element_no_id_defined:word=$FFFF;
      acpi_phat_version_element_invaild_id:word=$0000;
      acpi_viot_node_structure_PCI_Range_Structure:byte=1;
      acpi_viot_node_structure_MMIO_Endpoint_Structure:byte=2;
      acpi_viot_node_structure_virtio_pci_iommu_structure:byte=3;
      acpi_viot_node_structure_virtio_mmio_iommu_structure:byte=4;
      
type acpi_guid=packed record
               data1:dword;
               data2:word;
               data3:word;
               data4:array[1..8] of byte;
               end;
     acpi_header=packed record
                 signature:array[1..4] of char;
                 length:dword;
                 revision:byte;
                 checksum:byte;
                 OemId:array[1..6] of byte;
                 OemTableId:qword;
                 OemRevision:dword;
                 CreatorID:dword;
                 CreatorRevision:dword;
                 end;          
     acpi_rsdp=packed record
               signature:array[1..8] of char;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               Revision:byte;
               RsdtAddress:dword;
               Length:dword;
               XsdtAddress:qword;
               ExtendedCheckSum:byte;
               Reserved:array[1..3] of byte;
               end;
     acpi_rsdt=packed record
               signature:array[1..4] of char;
               length:dword;
               revision:byte;
               checksum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               Entry:array[1..1] of dword;
               end;
     acpi_xsdt=packed record
               signature:array[1..4] of char;
               length:dword;
               revision:byte;
               checksum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               Entry:array[1..1] of qword;
               end;
     acpi_facp=bitpacked record
               WBINVD:0..1;
               WBINVD_FLUSH:0..1;
               PROC_C1:0..1;
               P_LVL2_UP:0..1;
               PWR_BUTTON:0..1;
               SLP_BUTTON:0..1;
               FIX_RTC:0..1;
               RTC_S4:0..1;
               TMR_VAL_EXT:0..1;
               DCK_CAP:0..1;
               RESET_REG_SUP:0..1;
               SEALED_CASE:0..1;
               HEADLESS:0..1;
               CPU_SW_SLP:0..1;
               PCI_EXP_WAK:0..1;
               USE_PLATFORM_CLOCK:0..1;
               S4_RTC_STS_VAILD:0..1;
               REMOTE_POWER_ON_CAPABLE:0..1;
               FORCE_APIC_CLUSTER_MODEL:0..1;
               FORCE_APIC_PHYSICAL_DESTINATION_MODE:0..1;
               HW_REDUCED_ACPI:0..1;
               LOW_POWER_S0_IDLE_CAPABLE:0..1;
               PERSISTENT_CPU_CACHES:0..3;
               Reserved:0..255;
               end;
     acpi_iapc_flag=bitpacked record
                    LEGACY_DEVICES:0..1;
                    IAPC_8042:0..1;
                    VGA_Not_Present:0..1;
                    MSI_Not_Supported:0..1;
                    PCIe_ASPM_Controls:0..1;
                    CMOS_RTC_Not_Present:0..1;
                    Reserved:0..1023;
                    end; 
     acpi_arm_flag=bitpacked record
                   PSCI_Compliant:0..1;
                   PSCI_USE_HVC:0..1;
                   Reserved:0..16383;
                   end;
     acpi_fadt=packed record
               signature:array[1..4] of char;
               length:dword;
               FADT_major_version:byte;
               checksum:byte;
               OemId:array[1..6] of byte;
               OemTableID:qword;
               OemRevision:dword;
               CreateId:dword;
               CreateRevision:dword;
               Firmware_ctrl:dword;
               dsdt:dword;
               Reserved:byte;
               Preferred_PM_profile:byte;
               SCI_int:word;
               SMI_CMD:dword;
               ACPI_ENABLE:byte;
               ACPI_DISABLE:byte;
               S4BIOS_REQ:byte;
               PSTATE_CNT:byte;
               PM1a_EVT_BLK:dword;
               PM1b_EVT_BLK:dword;
               PM1a_CNT_BLK:dword;
               PM1b_CNT_BLK:dword;
               PM2_CNT_BLK:dword;
               PM_TLR_BLK:dword;
               GPE0_BLK:dword;
               GPE1_BLK:dword;
               PM1_EVT_LEN:byte;
               PM1_CNT_LEN:byte;
               PM2_CNT_LEN:byte;
               PM_TMR_LEN:byte;
               GPE0_BLK_LEN:byte;
               GPE1_BLK_LEN:byte;
               GPE1_BASE:byte;
               CST_CNT:byte;
               P_LVL2_CNT:word;
               P_LVL3_CNT:word;
               FLUSH_SIZE:word;
               FLUSH_STRIDE:word;
               DUTY_OFFSET:byte;
               DUTY_WIDTH:byte;
               DAY_ALRM:byte;
               MON_ALRM:byte;
               CENTURY:byte;
               IAPC_BOOT_ARCH:acpi_iapc_flag;
               Reserved2:byte;
               Flags:acpi_facp;
               RESET_REG:Uint96;
               RESET_VALUE:byte;
               ARM_BOOT_ARCH:acpi_arm_flag;
               FADT_minor_version:byte;
               X_FIRMWARE_CTRL:qword;
               X_DSDT:qword;
               X_PM1a_EVT_BLK:Uint96;
               X_PM1b_EVT_BLK:Uint96;
               X_PM1a_CNT_BLK:Uint96;
               X_PM1b_CNT_BLK:Uint96;
               X_PM2_CNT_BLK:Uint96;
               X_PM_TMR_BLK:Uint96;
               X_GPE0_BLK:Uint96;
               X_GPE1_BLK:Uint96;
               SLEEP_CONTROL_REG:Uint96;
               SLEEP_STATUS_REG:Uint96;
               HyperVisior_Vendor_Identity:qword;
               end;
     acpi_fcsf_flag=bitpacked record
                    S4BIOS_F:0..1;
                    BIT64_WAKE_SUPPORTED_F:0..1;
                    Reserved:0..1073741823;
                    end;
     acpi_ospm_enabled_flag=bitpacked record
                            BIT64_WAKE_F:0..1;
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
               Hardware_signature:dword;
               Firmware_Waking_Vector:dword;
               GlobalLock:acpi_facs_global_lock;
               Flags:acpi_fcsf_flag;
               X_Firmware_Waking_Vector:qword;
               Version:byte;
               Reserved:array[1..3] of byte;
               OSPM_Flags:acpi_ospm_enabled_flag;
               Reserved2:array[1..24] of byte;
               end;
     acpi_dsdt=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               DefinitionBlock:array[1..1] of byte;
               end;
     acpi_ssdt=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               DefinitionBlock:array[1..1] of byte;
               end; 
     acpi_psdt=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               DefinitionBlock:array[1..1] of byte;
               end;  
     acpi_multiple_apic_flags=bitpacked record 
                              PCAT_COMPAT:0..1;
                              Reserved:0..2147483647;
                              end;
     acpi_madt=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               LocalInterruptControllerAddress:dword;
               Flags:acpi_multiple_apic_flags;
               InterruptControllerStructure:array[1..1] of byte;
               end;
     acpi_local_apic_flags=bitpacked record
                                     Enabled:0..1;
                                     Online_Capable:0..1;
                                     Reserved:0..1073741823;
                                     end;
     acpi_processor_local_apic_structure=packed record
                                         acpi_type:byte;
                                         length:byte;
                                         ACPI_processor_uid:byte;
                                         APIC_id:byte;
                                         Flags:acpi_local_apic_flags;
                                         end;
     acpi_io_apic_structure=packed record
                            acpi_type:byte;
                            length:byte;
                            io_apic_id:byte;
                            Reserved:byte;
                            io_apic_address:dword;
                            global_system_interrupt_source:dword;
                            end;
     acpi_mps_inti_flags=bitpacked record 
                         Polarity:0..3;
                         Trigger_Mode:0..3;
                         Reserved:0..4095;
                         end;
     acpi_interrupt_source_override_structure=packed record
                                              acpi_type:byte;
                                              length:byte;
                                              Bus:byte;
                                              Source:byte;
                                              global_system_interrupt:dword;
                                              Flags:acpi_mps_inti_flags;
                                              end;
     acpi_non_maskable_interrupt_source_structure=packed record
                                                  acpi_type:byte;
                                                  length:byte;
                                                  flags:acpi_mps_inti_flags;
                                                  global_system_interrupt:dword;
                                                  end;
     acpi_local_APIC_NMI_structure=packed record
                                   acpi_type:byte;
                                   length:byte;
                                   ACPI_processor_uid:byte;
                                   flags:acpi_mps_inti_flags;
                                   local_APIC_lint:byte;
                                   end;
     acpi_local_APIC_address_override=packed record
                                      acpi_type:byte;
                                      length:byte;
                                      Reserved:word;
                                      local_apic_address:qword;
                                      end;
     acpi_io_sapic_structure=packed record
                             acpi_type:byte;
                             length:byte;
                             io_apic_id:byte;
                             Reserved:byte;
                             global_system_interrupt_base:dword;
                             io_sapic_address:qword;
                             end;
     acpi_local_sapic_structure=packed record
                                acpi_type:byte;
                                length:byte;
                                acpi_processor_id:byte;
                                local_sapic_id:byte;
                                local_sapic_eid:byte;
                                Reserved:array[1..3] of byte;
                                Flags:acpi_local_apic_flags;
                                ACPI_Processor_UID_Value:dword;
                                ACPI_Processor_UID_String:array[1..1] of char;
                                end;
     acpi_platform_interrupt_source_flags=bitpacked record 
                                          CPEI_Processor_Override:0..1;
                                          Reserved:0..2147483647;
                                          end;
     acpi_platform_interrupt_source_structure=packed record
                                              acpi_type:byte;
                                              length:byte;
                                              flags:acpi_mps_inti_flags;
                                              interrupt_type:byte;
                                              Processor_ID:byte;
                                              Processor_EID:byte;
                                              IO_SAPIC_Vector:byte;
                                              Global_System_interrupt:dword;
                                              Platform_interrupt_Source_flags:acpi_platform_interrupt_source_flags;
                                              end;
     acpi_processor_local_apic_2_structure=packed record
                                           acpi_type:byte;
                                           length:byte;
                                           Reserved:word;
                                           apic_2_id:array[1..2] of word;
                                           flags:acpi_local_apic_flags;
                                           acpi_processor_uid:dword;
                                           end;
     acpi_local_apic_2_NMI_structure=packed record
                                     acpi_type:byte;
                                     length:byte;
                                     Flags:acpi_mps_inti_flags;
                                     ACPI_Processor_UID:dword;
                                     Local_apic_2_Lint:byte;
                                     Reserved:array[1..3] of byte;
                                     end;
     acpi_GIC_cpu_interface_flags=bitpacked record
                                  Enabled:0..1;
                                  Performance_interrupt_Mode:0..1;
                                  VGIC_Maintenance_Interrupt_Mode_Flags:0..1;
                                  Online_Capable:0..1;
                                  Reserved:0..$FFFFFFF;
                                  end;
     acpi_GIC_cpu_interface_structure=packed record
                                      acpi_type:byte;
                                      length:byte;
                                      Reserved1:word;
                                      CPU_interface_Number:dword;
                                      ACPI_Processor_UID:dword;
                                      Flags:acpi_GIC_cpu_interface_flags;
                                      Parking_Protocol_Version:dword;
                                      Performance_Interrupt_GSIV:dword;
                                      Parked_Address:qword;
                                      Physical_Base_Address:qword;
                                      GICV:qword;
                                      GICH:qword;
                                      VGIC_Maintenance_interrupt:dword;
                                      GICR_Base_Address:qword;
                                      MPIDR:qword;
                                      Processor_Power_Efficiency_Class:byte;
                                      Reserved2:byte;
                                      SPE_overflow_interrupt:word;
                                      TRBE_interrupt:word;
                                      end;
     acpi_GIC_distributor_structure=packed record
                                    acpi_type:byte;
                                    length:byte;
                                    Reserved1:word;
                                    GIC_ID:dword;
                                    Physical_Base_Address:qword;
                                    System_Vector_Base:dword;
                                    GIC_Version:byte;
                                    Reserved2:array[1..3] of byte;
                                    end;
     acpi_GIC_MSI_Frame_Flags=bitpacked record
                              SPI_Count_or_Base_Select:0..1;
                              Reserved:0..2147483647;
                              end;
     acpi_GIC_MSI_Frame_Structure=packed record
                                  acpi_type:byte;
                                  length:byte;
                                  Reserved:word;
                                  GIC_MSI_Frame_ID:byte;
                                  Physical_Base_Address:qword;
                                  Flags:acpi_GIC_MSI_Frame_Flags;
                                  SPI_Count:word;
                                  SPI_Base:word;
                                  end;
     acpi_GIC_Redistributor_Structure=packed record 
                                      acpi_type:byte;
                                      length:byte;
                                      Reserved:word;
                                      Discovery_Range_Base_Address:qword;
                                      Discovery_Range_Length:dword;
                                      end;
     acpi_GIC_Interrupt_translation_Service=packed record
                                            acpi_type:byte;
                                            length:byte;
                                            Reserved1:word;
                                            GIC_ITS_ID:dword;
                                            Physical_Base_Address:qword;
                                            Reserved2:dword;
                                            end;
     acpi_multiprocessor_wakeup_structure=packed record
                                          acpi_type:byte;
                                          length:byte;
                                          MailBoxVersion:word;
                                          Reserved:dword;
                                          MailboxAddress:qword;
                                          end;
     acpi_multiprocessor_wakeup_mailbox_structure=packed record
                                                  Command:word;
                                                  Reserved:word;
                                                  ApicId:dword;
                                                  WakeUpVector:qword;
                                                  ReservedForOS:array[1..2032] of byte;
                                                  ReservedForFirmWare:array[1..2048] of byte;
                                                  end;
     acpi_core_pic_flags=bitpacked record
                         Enabled:0..1;
                         Reserved:0..2147483647;
                         end;
     acpi_core_pic_structure=packed record
                             acpi_type:byte;
                             length:byte;
                             version:byte;
                             ACPI_Processor_ID:dword;
                             Physical_Processor_ID:dword;
                             Flags:acpi_core_pic_flags;
                             end;
     acpi_legacy_io_pic_structure=packed record 
                                  acpi_type:byte;
                                  length:byte;
                                  version:byte;
                                  BaseAddress:qword;
                                  Size:word;
                                  CascadeVector:word;
                                  CascadeVectorMapping:qword;
                                  end;
     acpi_HyperTransport_pic_structure=packed record
                                       acpi_type:byte;
                                       length:byte;
                                       version:byte;
                                       BaseAddress:qword;
                                       Size:word;
                                       CascadeVector:qword;
                                       end;
     acpi_Extend_io_pic_structure=packed record
                                  acpi_type:byte;
                                  length:byte;
                                  version:byte;
                                  CascadeVector:byte;
                                  Node:byte;
                                  NodeMap:qword;
                                  end;
     acpi_msi_pic_structure=packed record
                            acpi_type:byte;
                            length:byte;
                            version:byte;
                            MessageAddress:qword;
                            Start:dword;
                            Count:dword;
                            end;
     acpi_bridge_io_pic_structure=packed record
                                  acpi_type:byte;
                                  length:byte;
                                  version:byte;
                                  BaseAddress:qword;
                                  Size:word;
                                  HardwareID:word;
                                  GSIBase:word;
                                  end;
     acpi_lpc_pic_structure=packed record 
                            acpi_type:byte;
                            length:byte;
                            version:byte;
                            BaseAddress:qword;
                            Size:word;
                            CascadeVector:word;
                            end;
     acpi_sbst=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               WarningEnergyLevel:dword;
               LowEnergyLevel:dword;
               CriticialEnergyLevel:dword;
               end;
     acpi_ecdt=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               Checksum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               EC_Control:Uint96;
               EC_Data:Uint96;
               UID:dword;
               GPE_BIT:byte;
               EC_ID:char;
               end;
     acpi_srat=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               Checksum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               Reserved1:dword;
               Reserved2:qword;
               StaticResourceAllocationStructure:array[1..1] of byte;
               end;
     acpi_processor_local_apic_affinity_flags=bitpacked record
                                              Enabled:0..1;
                                              Reserved:0..2147483647;
                                              end;
     acpi_processor_local_apic_affinity_structure=packed record
                                                  acpi_type:byte;
                                                  length:byte;
                                                  proximity_domain:array[1..8] of 0..1;
                                                  apic_id:byte;
                                                  flags:acpi_processor_local_apic_affinity_flags;
                                                  local_SAPIC_EID:byte;
                                                  proximity_domain2:array[1..24] of 0..1;
                                                  clock_domain:dword;
                                                  end; 
     acpi_memory_affinity_flags=bitpacked record
                                Enabled:0..1;
                                HotPluggable:0..1;
                                NonVolatile:0..1;
                                Reserved:0..536870911;
                                end;
     acpi_memory_affinity_structure=packed record
                                    acpi_type:byte;
                                    length:byte;
                                    proximity_domain:array[1..32] of 0..1;
                                    Reserved:word;
                                    BaseAddressLow:dword;
                                    BaseAddressHigh:dword;
                                    LengthLow:dword;
                                    LengthHigh:dword;
                                    Reserved2:dword;
                                    Flags:acpi_memory_affinity_flags;
                                    Reserved3:qword;
                                    end;
     acpi_processor_2_local_apic_2_structure=packed record
                                             acpi_type:byte;
                                             length:byte;
                                             Reserved1:word;
                                             Proximity_domain:array[1..32] of 0..1;
                                             apic_2_id:dword;
                                             Flags:acpi_processor_local_apic_affinity_flags;
                                             Clock_Domain:dword;
                                             Reserved2:dword;
                                             end;
     acpi_gicc_affinity_flags=packed record
                              Enabled:0..1;
                              Reserved:0..2147483647;
                              end;
     acpi_gicc_affinity_structure=packed record
                                  acpi_type:byte;
                                  length:byte;
                                  proximity_domain:array[1..32] of 0..1;
                                  acpi_processor_uid:dword;
                                  flags:acpi_gicc_affinity_flags;
                                  Clock_Domain:dword;
                                  end;
     acpi_architecture_specific_affinity_structure=packed record
                                                   acpi_type:byte;
                                                   length:byte;
                                                   proximity_domain:array[1..32] of 0..1;
                                                   reserved:word;
                                                   its_id:dword;
                                                   end;
     acpi_device_handle=packed record
                        case Boolean of 
                        True:
                        (ACPI_HID:qword;
                         ACPI_UID:dword;
                         ACPI_Reserved:dword;);
                        False:
                        (PCI_Segment:word;
                         PCI_BDF_Number:word;
                         PCI_Reserved:array[1..3] of dword;);
                        end;
     acpi_generic_flags=bitpacked record
                        Enabled:0..1;
                        Architecture_transactions:0..1;
                        Reserved:0..$3FFFFFFF;
                        end;
     acpi_generic_initiator_affinity_structure=packed record
                                               acpi_type:byte;
                                               length:byte;
                                               Reserved:byte;
                                               Device_Handle_Type:byte;
                                               proximity_domain:array[1..32] of 0..1;
                                               Device_Handle:acpi_device_handle;
                                               Flags:acpi_generic_flags;
                                               Reserved2:dword;
                                               end;
     acpi_generic_port_affinity_structure=packed record
                                          acpi_type:byte;
                                          length:byte;
                                          Reserved:byte;
                                          Device_Handle_Type:byte;
                                          Proximity_domain:array[1..32] of 0..1;
                                          Device_Handle:acpi_device_handle;
                                          Flags:acpi_generic_flags;
                                          Reserved2:dword;
                                          end;
     acpi_slit=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               NumberOfSystemLocalities:qword;
               Entry:array[1..1] of byte;
               end;
     acpi_cpep_processor_structure=packed record
                                   acpi_type:byte;
                                   length:byte;
                                   processor_ID:byte;
                                   processor_EID:byte;
                                   Polling_Interval:dword;
                                   end;
     acpi_cpep=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               Reserved:qword;
               CPEP_Processor_Structure:array[1..1] of acpi_cpep_processor_structure;
               end;
     acpi_proximity_domain_information_structure=packed record
                                                 Revision:byte;
                                                 Length:byte;
                                                 ProximityDomainRangeLow:dword;
                                                 ProximityDomainRangeHigh:dword;
                                                 MaximumProcessorCapacity:dword;
                                                 MaximumMemoryCapacity:qword;
                                                 end;
     acpi_msct=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               OffsetToProximityDomainInformationStructure:dword;
               MaximumNumberOfProximityDomains:dword;
               MaximumNumberOfClockDomains:dword;
               MaximumPhysicalAddress:qword;
               ProximityDomainInformationStructure:array[1..1] of acpi_proximity_domain_information_structure;
               end;
     acpi_parameter_block=packed record
                          acpi_type:word;
                          version:word;
                          length:word;
                          PatrolScrubCommand:word;
                          RequestAddressRange:Uint128;
                          ActualAddressRange:Uint128;
                          Flags:word;
                          RequestedSpeed:byte;
                          end;
     acpi_rasf_communication_channel=packed record
                                     signature:array[1..4] of char;
                                     command:word;
                                     status:word;
                                     version:word;
                                     RASCapabilities:Uint128;
                                     SetRASCapabilities:Uint128;
                                     NumberOfRASFParameterBlocks:word;
                                     SetRASCapabilitiesStatus:dword;
                                     ParameterBlocks:array[1..1] of acpi_parameter_block;
                                     end;
     acpi_rasf=packed record
               signature:array[1..4] of char;
               length:dword;
               Revision:byte;
               CheckSum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               PlatformCommunicationChannelIdentifier:array[1..1] of byte;
               end;
     acpi_ras2_platform_communication_channel=packed record 
                                              signature:array[1..4] of char;
                                              command:word;
                                              status:word;
                                              version:word;
                                              RASFeatures:Uint128;
                                              SetRasCapabilities:Uint128;
                                              NumberOfRAS2ParameterBlocks:word;
                                              SetRasCapabilitiesStatus:dword;
                                              ParameterBlocks:array[1..1] of acpi_parameter_block;
                                              end;
     acpi_ras2_platform_communication_Channel_Descriptor=packed record
                                                         PCCidentifier:byte;
                                                         Reserved:word;
                                                         FeatureType:byte;
                                                         Instance:dword;
                                                         end;
     acpi_ras2=packed record
               signature:array[1..4] of char;
               length:dword;
               revision:byte;
               checksum:byte;
               OemId:array[1..6] of byte;
               OemTableId:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               Reserved:word;
               NumberOfPCCDescriptors:word;
               PlatformCommunicationChannelDescriptionList:array[1..1] of acpi_ras2_platform_communication_Channel_Descriptor;
               end;
     acpi_mpst_command=bitpacked record
                       commandcomplete:0..1;
                       scidoorbell:0..1;
                       Error:0..1;
                       PlatformNotification:0..1;
                       Reserved:0..4095;
                       end;
     acpi_mpst_platform_communication_channel_shared_memory=packed record
                                                            signature:array[1..4] of char;
                                                            command:acpi_mpst_command;
                                                            status:word;
                                                            memory_power_command_register:dword;
                                                            memory_power_status_register:dword;
                                                            power_state_id:dword;
                                                            memory_power_node_id:dword;
                                                            memory_power_consumed:qword;
                                                            expected_average_power_consumed:qword;
                                                            end;
     acpi_memory_power_node_flag=bitpacked record
                                 Enabled:0..1;
                                 PowerManagedFlag:0..1;
                                 HotPluggable:0..1;
                                 Reserved:0..31;
                                 end;
     acpi_memory_power_state_structure=packed record
                                       PowerStateValue:byte;
                                       PowerStateInformationIndex:byte;
                                       end;
     acpi_memory_power_node_structure=packed record
                                      Flag:acpi_memory_power_node_flag;
                                      Reserved:byte;
                                      MemoryPowerNodeId:word;
                                      length:dword;
                                      BaseAddressLow:dword;
                                      BaseAddressHigh:dword;
                                      LengthLow:dword;
                                      LengthHigh:dword;
                                      NumberOfPowerStates:dword;
                                      NumberOfPhysicalComponents:dword;
                                      MemoryPowerStateStructure:array[1..1] of acpi_memory_power_state_structure;
                                      end;
     acpi_memory_power_state_characteristics_structure_flag=bitpacked record
                                                            MemoryContentPreserved:0..1;
                                                            AutonomousMemoryPowerStateEntry:0..1;
                                                            AutonomousMemoryPowerStateExit:0..1;
                                                            Reserved:0..31;
                                                            end;
     acpi_memory_power_state_characteristics_structure=packed record
                                                       powerstatestructureID:byte;
                                                       flag:acpi_memory_power_state_characteristics_structure_flag;
                                                       Reserved:word;
                                                       AveragePowerConsumedInMPS0State:dword;
                                                       RelativePowerSavingToMPS0State:dword;
                                                       ExitLatency:qword;
                                                       Reserved2:qword;
                                                       end;
     acpi_platform_memory_topology_table=packed record
                                         signature:array[1..4] of char;
                                         length:dword;
                                         revision:byte;
                                         checksum:byte;
                                         OemId:array[1..6] of byte;
                                         OemTableId:qword;
                                         OemRevision:dword;
                                         CreatorID:dword;
                                         CreatorRevision:dword;
                                         NumberOfMemoryDevices:dword;
                                         MemoryDeviceStructure:array[1..1] of byte;
                                         end;
     acpi_common_memory_device_flag=bitpacked record
                                    level:0..1;
                                    element:0..1;
                                    component:0..3;
                                    reserved:0..4095;
                                    end;
     acpi_common_memory_device_header=packed record
                                      acpi_type:byte;
                                      reserved1:byte;
                                      length:byte;
                                      flags:acpi_common_memory_device_flag;
                                      Reserved2:word;
                                      NumberOfMemoryDevices:dword;
                                      end;
     acpi_common_memory_device_socket_type_data=packed record
                                                header:acpi_common_memory_device_header;
                                                socketIdentifier:word;
                                                Reserved:word;
                                                MemoryDeviceStructure:array[1..1] of byte;
                                                end;
     acpi_common_memory_device_memory_controller_type_data=packed record 
                                                           header:acpi_common_memory_device_header;
                                                           memoryControllerIdentifier:word;
                                                           Reserved:word;
                                                           MemoryDeviceStructure:array[1..1] of byte;
                                                           end;
     acpi_common_memory_device_dimm_type_specific_data=packed record
                                                       header:acpi_common_memory_device_header;
                                                       SMbiosHandle:dword;
                                                       end;
     acpi_common_memory_device_vendor_specific_type_data=packed record
                                                         header:acpi_common_memory_device_header;
                                                         typeuuid:acpi_guid;
                                                         vendorSpecificData:array[1..1] of byte;
                                                         end;
     acpi_common_memory_device_vendor_specific_type_data_alternative=packed record
                                                                     MemoryDeviceStructure:array[1..1] of byte;
                                                                     end;
     acpi_mpst_part1=packed record
                     signature:array[1..4] of char;
                     length:dword;
                     revision:byte;
                     CheckSum:byte;
                     OemId:array[1..6] of byte;
                     OemTableId:qword;
                     OemRevision:dword;
                     CreatorID:dword;
                     CreatorRevision:dword;
                     mpst_platform_communication_channel_identifier:byte;
                     Reserved1:array[1..3] of byte;
                     MemoryPowerNodeCount:word;
                     Reserved2:word;
                     MemoryPowerNodeStructure:array[1..1] of byte;
                     end;
     acpi_mpst_part2=packed record
                     MemoryPowerStateCharacteristicsCount:word;
                     Reserved:word;
                     MemoryPowerStateCharacteristicsStructure:array[1..1] of byte;
                     end;
     acpi_bgrt_status=bitpacked record
                      Displayed:0..1;
                      Orientation:0..3;
                      Reserved:0..31;
                      end;
     acpi_bgrt=packed record
               signature:array[1..4] of char;
               length:dword;
               revision:byte;
               checksum:byte;
               oemid:array[1..6] of byte;
               oemTableID:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               Version:word;
               Status:acpi_bgrt_status;
               ImageType:byte;
               ImageAddress:qword;
               ImageOffsetX:dword;
               ImageOffsetY:dword;
               end;
     acpi_performance_record_format=packed record
                                    acpi_type:word;
                                    record_length:byte;
                                    revision:byte;
                                    Data:array[1..1] of byte;
                                    end;
     acpi_fpdt=packed record
               signature:array[1..4] of char;
               length:dword;
               revision:byte;
               checksum:byte;
               OemId:array[1..6] of byte;
               OemTableID:qword;
               OemRevision:dword;
               CreatorID:dword;
               CreatorRevision:dword;
               PerformanceRecords:array[1..1] of byte;
               end;
     acpi_firmware_basic_boot_performance_table_pointer_record=packed record
                                                               performanceRecordType:word;
                                                               RecordLength:byte;
                                                               Revision:byte;
                                                               Reserved:dword;
                                                               FBPTPointer:qword;
                                                               end;
     acpi_s3_performance_table_pointer_record=packed record
                                              performanceRecordType:Word;
                                              RecordLength:byte;
                                              Revision:byte;
                                              Reserved:dword;
                                              S3PTPointer:qword;
                                              end;
     acpi_firmware_basic_boot_performance_table_header=packed record 
                                                       signature:array[1..4] of char;
                                                       length:dword;
                                                       end;
     acpi_firmware_basic_boot_performance_data_record=packed record
                                                      performanceRecordType:word;
                                                      RecordLength:byte;
                                                      Revision:byte;
                                                      Reserved:dword;
                                                      Resetend:qword;
                                                      OSLoaderLoadImageStart:qword;
                                                      OSLoaderStartImageStart:qword;
                                                      ExitBootServicesEntry:qword;
                                                      ExitBootServicesExit:qword;
                                                      end;
     acpi_s3_performance_table_header=packed record
                                      signature:array[1..4] of char;
                                      length:dword;
                                      end;
     acpi_basic_s3_resume_table_record=packed record
                                       RuntimePerformanceRecordType:word;
                                       RecordLength:byte;
                                       Revision:byte;
                                       ResumeCount:dword;
                                       FullResume:qword;
                                       AverageResume:qword;
                                       end;
     acpi_basic_s3_suspend_performance_record=packed record
                                              RuntimePerformanceRecordType:word;
                                              RecordLength:byte;
                                              Revision:byte;
                                              SuspendStart:dword;
                                              SuspendEnd:dword;
                                              end;
     acpi_gtdt_flag=bitpacked record
                    TimerInterruptMode:0..1;
                    TimerInterruptPolarity:0..1;
                    AlwaysOnCapability:0..1;
                    Reserved:0..536870911;
                    end;
     acpi_gtdt_table_structure=packed record
                               Header:acpi_header;
                               CntControlBase:qword;
                               Reserved:dword;
                               SecureEL1TimerGSIV:dword;
                               SecureEL1TimerFlags:acpi_gtdt_flag;
                               NonSecureEL1TimerGSIV:dword;
                               NonSecureEL1TimerFlags:acpi_gtdt_flag;
                               VirtualEL1TimerGSIV:dword;
                               VirtualEL1TimerFlags:acpi_gtdt_flag;
                               EL2TimerGSIV:dword;
                               EL2TimerFlags:acpi_gtdt_flag;
                               CntReadBasePhysicalAddress:qword;
                               PlatformTimerCount:dword;
                               PlatformTimerOffset:dword;
                               VirtualEL2TimerGSIV:dword;
                               VirtualEL2TimerFlags:acpi_gtdt_flag;
                               PlatformTimerStructure:array[1..1] of byte;
                               end;
     acpi_GT_block_timer_flag=bitpacked record
                              TimerInterruptMode:0..1;
                              TimerInterruptPolarity:0..1;
                              Reserved:0..1073741823;
                              end;
     acpi_GT_block_timer_common_flag=bitpacked record
                                     SecureTimer:0..1;
                                     AlwaysOnCapability:0..1;
                                     Reserved:0..1073741823;
                                     end;
     acpi_GT_block_timer_structure_format=packed record
                                          GTFrameBuffer:byte;
                                          Reserved:array[1..3] of byte;
                                          GTxPhysicalAddressCntBaseX:qword;
                                          GTxPhysicalAddressCntEL0BaseX:qword;
                                          GTxPhysicalTimerGSIV:dword;
                                          GTxPhysicalTimerFlags:acpi_GT_block_timer_flag;
                                          GTxVirtualTimerGSIV:dword;
                                          GTxVirtualTimerFlags:acpi_GT_block_timer_flag;
                                          GTxCommonFlags:acpi_GT_block_timer_common_flag;
                                          end;
     acpi_GT_block_structure=packed record
                             acpi_type:byte;
                             length:word;
                             Reserved:byte;
                             GTBlockPhysicalAddressCntCtlBase:qword;
                             GTBlockTimerCount:dword;
                             GTBlockTimerOffset:dword;
                             GTBlockTimerStructure:array[1..1] of acpi_GT_block_timer_structure_format;
                             end;
     acpi_arm_generic_watchdog_flag=bitpacked record
                                    TimerInterruptMode:0..1;
                                    TimerInterruptPolarity:0..1;
                                    SecureTimer:0..1;
                                    Reserved:0..536870911;
                                    end;
     acpi_arm_generic_watchdog_structure=packed record
                                         acpi_type:byte;
                                         length:word;
                                         Reserved:byte;
                                         RefreshFramePhysicalAddress:qword;
                                         WatchdogControlFramePhysicalAddress:qword;
                                         WatchdogTimerGSIV:dword;
                                         WatchdogTimerFlags:acpi_arm_generic_watchdog_flag;
                                         end;
     acpi_nfit=packed record
               header:acpi_header;
               structuretype:array[1..1] of byte;
               end;
     acpi_system_physical_address_range_structure=packed record 
                                                  acpi_type:word;
                                                  length:word;
                                                  SPARangeStructureIndex:word;
                                                  Flags:word;
                                                  Reserved:dword;
                                                  ProximityDomain:dword;
                                                  AddressRangeTypeGUID:acpi_guid;
                                                  SystemPhysicalAddressRangeBase:qword;
                                                  SystemPhysicalAddressRangeLength:qword;
                                                  AddressRangeMemoryMappingStructure:qword;
                                                  SpaLocationCookie:qword;
                                                  end;
     acpi_nvdimm_state_flags=bitpacked record
                             save:0..1;
                             restore:0..1;
                             flush:0..1;
                             erase:0..1;
                             smart:0..1;
                             platform:0..1;
                             spa:0..1;
                             reserved:0..255;
                             end;
     acpi_nvdimm_mapping_structure=packed record
                                   acpi_type:word;
                                   length:word;
                                   NFIT_Device_Handle:dword;
                                   NVIDMM_Physical_ID:word;
                                   NVIDMM_Region_ID:word;
                                   SPA_Range_Structure_Index:word;
                                   NVDIMM_Control_Region_Structure_Index:word;
                                   NVDIMM_Region_Size:qword;
                                   Region_Offset:qword;
                                   NVDIMM_Physical_Address_Region_Base:qword;
                                   InterLeave_Structure_Index:word;
                                   InterLeave_Ways:word;
                                   NVDIMM_State_Flags:acpi_nvdimm_state_flags;
                                   Reserved:word;
                                   end;
     acpi_sdev_acpi_table=packed record
                          Header:acpi_header;
                          SecureDeviceStructure:array[1..1] of byte;
                          end;
     acpi_namespace_device_based_secure_device_structure=packed record
                                                         acpi_type:byte;
                                                         flags:byte;
                                                         length:word;
                                                         DeviceIdentifierOffset:word;
                                                         DeviceIdentifierLength:word;
                                                         VendorSpecificDataOffset:word;
                                                         VendorSpecificDataLength:word;
                                                         SecureAccessComponentsOffset:word;
                                                         SecureAccessComponentsLength:word;
                                                         end;
     acpi_identification_based_structure_access_component=packed record
                                                          acpi_type:byte;
                                                          flags:byte;
                                                          length:word;
                                                          HardwareIdentifierOffset:word;
                                                          HardwareIdentifierLength:word;
                                                          SubsystemIdentifierOffset:word;
                                                          SubsystemIdentifierLength:word;
                                                          HardwareRevision:byte;
                                                          HardwareRevisionPresent:byte;
                                                          ClassCodePresent:byte;
                                                          PCICompatibleBaseClass:byte;
                                                          PCICompatibleSubClass:byte;
                                                          PCICompatibleProgrammingInterface:byte;
                                                          end;
     acpi_memory_based_secure_access_component=packed record
                                               acpi_type:byte;
                                               flags:byte;
                                               length:word;
                                               Reserved:dword;
                                               MemoryAddressBase:qword;
                                               MemoryLength:qword;
                                               end;
     acpi_PCIe_Endpoint_Device_based_device_structure=packed record
                                                      acpi_type:byte;
                                                      flags:byte;
                                                      length:word;
                                                      PCISegmentNumber:word;
                                                      StartBusNumber:word;
                                                      PCIPathOffset:word;
                                                      PCIPathLength:word;
                                                      VendorSpecificDataOffset:word;
                                                      VendorSpecificDataLength:word;
                                                      end;
     acpi_hamt_header=packed record
                      header:acpi_header;
                      Reserved:dword;
                      HMATTableStructure:array[1..1] of byte;
                      end;
     acpi_hamt_memory_domain_attributes_structure=packed record
                                                  acpi_type:word;
                                                  Reserved1:word;
                                                  length:dword;
                                                  flags:word;
                                                  Reserved2:word;
                                                  ProximityDomainForTheAttachedInitiator:dword;
                                                  ProximityDomainForTheMemory:dword;
                                                  Reserved3:dword;
                                                  Reserved4,Reserved5:qword;
                                                  end;
     acpi_hamt_system_locality_latency_and_bandwidth_information_structure=packed record
                                                                           acpi_type:word;
                                                                           Reserved1:word;
                                                                           Length:dword;
                                                                           flag:word;
                                                                           DataType:byte;
                                                                           MinTransferSize:byte;
                                                                           Reserved2:byte;
                                                                           NumberOfInitiatorProximityDomainS,NumberOfTargetProximityDomainT:dword;
                                                                           Reserved3:dword;
                                                                           EntryBaseUnit:qword;
                                                                           DomainList:array[1..1] of dword;
                                                                           end;
     acpi_hamt_system_locality_latency_and_bandwidth_information_structure_2=packed record
                                                                             Entry:array[1..1] of word;
                                                                             end;
     acpi_hamt_memory_side_cache_information_structure=packed record
                                                       acpi_type:word;
                                                       Reserved:word;
                                                       Length:dword;
                                                       ProximityDomainForTheMemory:dword;
                                                       Reserved1:dword;
                                                       MemorySideCacheSize:qword;
                                                       CacheAttributes:dword;
                                                       Reserved2:word;
                                                       NumberOfSMBIOShandles:word;
                                                       SMBIOSHandles:array[1..1] of word;
                                                       end;
     acpi_pdtt_identifiers_structure=bitpacked record
                                     PDTTPCCSubChannelIdentifier:0..255;
                                     Runtime:0..1;
                                     WaitForCompletion:0..1;
                                     TriggerOrder:0..1;
                                     Reserved:0..31;
                                     end;
     acpi_pdtt_structure=packed record
                         header:acpi_header;
                         TriggerCount:byte;
                         Reserved:array[1..3] of byte;
                         TriggerIdentifierArrayOffset:dword;
                         PDTTPlatformCommunicationChannelIdentifiers:array[1..1] of acpi_pdtt_identifiers_structure;
                         end;
     acpi_pptt_structure=packed record 
                         header:acpi_header;
                         ProcessorTopologyStructure:array[1..1] of byte;
                         end;
     acpi_pptt_processor_structure_flags=bitpacked record
                                         PhysicalPackage:0..1;
                                         ACPIProcessorIDVaild:0..1;
                                         ProcessorIsAThread:0..1;
                                         NodeIsALeaf:0..1;
                                         IdenticalImplementation:0..1;
                                         Reserved:0..134217727;
                                         end;
     acpi_pptt_hierarchy_node_structure=packed record
                                        acpi_type:byte;
                                        length:byte;
                                        Reserved:word;
                                        flags:dword;
                                        Parent:dword;
                                        ACPIProcessorID:dword;
                                        NumberOfPrivateResources:dword;
                                        PrivateResources:array[1..1] of dword;
                                        end;
     acpi_pptt_cache_structure_flags=packed record 
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
     acpi_pptt_cache_type_structure=packed record
                                    acpi_type:byte;
                                    length:byte;
                                    Reserved:word;
                                    flags:acpi_pptt_cache_structure_flags;
                                    NextLevelOfCache:dword;
                                    Size:dword;
                                    Associativity:byte;
                                    Attributes:byte;
                                    LineSize:word;
                                    CacheID:dword;
                                    end;
     acpi_phat_structure=packed record
                         header:acpi_header;
                         PlatformTelemetryRecords:array[1..1] of byte;
                         end;
     acpi_phat_record=packed record
                      PlatformHealthAssessmentRecordType:word;
                      RecordLength:word;
                      Reserved:byte;
                      Data:array[1..1] of byte;
                      end;
     acpi_phat_version_element=packed record
                               ComponentID:acpi_guid;
                               VersionValue:qword;
                               ProducerID:dword;
                               end;
     acpi_phat_firmware_version_data_record_structure=packed record
                                                      PlatformRecordType:word;
                                                      RecordLength:word;
                                                      Revision:byte;
                                                      Reserved:array[1..3] of byte;
                                                      RecordCount:dword;
                                                      PHATVersionElement:array[1..1] of acpi_phat_version_element;
                                                      end;
     acpi_phat_firmware_health_data_record_structure=packed record
                                                     PlatformRecordType:word;
                                                     RecordLength:word;
                                                     Revision:byte;
                                                     Reserved:word;
                                                     AmHealthy:byte;
                                                     DeviceSignature:acpi_guid;
                                                     DeviceSpecificDataOffset:dword;
                                                     DevicePath:array[1..1] of byte;
                                                     end;
     acpi_phat_firmware_health_data_record_structure2=packed record
                                                      device_specific_data:array[1..1] of byte;
                                                      end;
     acpi_phat_reset_reason_health_record=packed record
                                          PlatformRecordType:word;
                                          RecordLength:word;
                                          Revision:byte;
                                          Reserved:array[1..2] of byte;
                                          AmHealthy:byte;
                                          DeviceSignature:acpi_guid;
                                          DeviceSpecificDataOffset:dword;
                                          DevicePath:array[1..88] of byte;
                                          end;
     acpi_phat_reset_reason_health_record_2=packed record
                                            DeviceSpecificData:array[1..116] of byte;
                                            end;
     acpi_phat_vendor_data_entry=packed record 
                                 VendorDataID:acpi_guid;
                                 Length:word;
                                 Revision:word;
                                 Data:array[1..1] of byte;
                                 end;
     acpi_phat_reset_reason_health_structure=packed record
                                             SupportedSources:byte;
                                             Source:byte;
                                             SubSource:byte;
                                             Reason:byte;
                                             VendorCount:word;
                                             VendorSpecificResetReasonEntry:array[1..1] of byte;
                                             end;
     acpi_viot=packed record
               header:acpi_header;
               NodeCount:word;
               NodeOffset:word;
               Reserved:qword;
               NodeStructure:array[1..1] of byte;
               end;
     acpi_viot_pci_range_node_structure=packed record
                                        acpi_type:byte;
                                        Reserved1:byte;
                                        Length:word;
                                        EndpointStart:dword;
                                        PCISegmentStart:word;
                                        PCISegmentEnd:word;
                                        PCIBDFStart:word;
                                        PCIBDFEnd:word;
                                        OutputNode:word;
                                        Reserved2:array[1..6] of byte;
                                        end;
     acpi_viot_single_mmio_endpoint_node_structure=packed record
                                                   acpi_type:byte;
                                                   Reserved1:byte;
                                                   length:word;
                                                   EndPointID:dword;
                                                   BaseAddress:qword;
                                                   OutputNode:word;
                                                   Reserved2:array[1..6] of byte;
                                                   end;
     acpi_viot_virtio_iommu_based_on_virtio_pci_node_structure=packed record
                                                               acpi_type:byte;
                                                               Reserved1:byte;
                                                               Length:word;
                                                               PCISegment:word;
                                                               PCIBDFNumber:word;
                                                               Reserved2:qword;
                                                               end;
     acpi_viot_virtio_iommu_based_on_virtio_mmio_node_structure=packed record
                                                                acpi_type:byte;
                                                                Reserved1:byte;
                                                                Length:word;
                                                                Reserved2:dword;
                                                                BaseAddress:qword;
                                                                end;
     acpi_misc_GUIDed_entry=packed record
                            EntryGUIDID:acpi_guid;
                            EntryLength:dword;
                            Revision:dword;
                            ProducerID:dword;
                            Data:array[1..1] of byte;
                            end;
     acpi_misc=packed record
               header:acpi_header;
               GUIDedEntries:array[1..1] of byte;
               end; 
     acpi_ccel=packed record
               header:acpi_header;
               CCtype,CCSubType:byte;
               Reserved:word;
               LogAreaMinimumLength:qword;
               LogAreaStartAddress:qword;
               end;
     acpi_skvl_key_structure=packed record
                             keytype:word;
                             keyformat:word;
                             keySize:dword;
                             KeyAddress:qword;
                             end;
     acpi_skvl=packed record
               header:acpi_header;
               keyCount:dword;
               keystructure:array[1..1] of acpi_skvl_key_structure;
               end;
     Pacpi_rsdp=^acpi_rsdp;
     Pacpi_rsdt=^acpi_rsdt;
     Pacpi_xsdt=^acpi_xsdt;
     Pacpi_hardware_tree=^acpi_hardware_tree;
     acpi_hardware_tree=packed record
                        acpi_root:Pacpi_hardware_tree;
                        acpi_type:byte;
                        acpi_content:Pointer;
                        acpi_child:Pacpi_hardware_tree;
                        acpi_child_count:qword;
                        end;
     acpi_displayer=packed record
                    displayer_address:Pointer;
                    displayer_type:byte;
                    displayer_width:dword;
                    displayer_height:dword;
                    end;
     
const persistent_memory_region:acpi_guid=(data1:$66F0D379;data2:$B4F3;data3:$4074;data4:($AC,$43,$0D,$33,$18,$B7,$8C,$DB));
      NVDIMM_Control_Region:acpi_guid=(data1:$92F701F6;data2:$13B4;data3:$405D;data4:($91,$0B,$29,$93,$67,$E8,$23,$4C));
      NVDIMM_Block_Data_Window_Region:acpi_guid=(data1:$91AF0530;data2:$5D86;data3:$470E;data4:($A6,$B0,$0A,$2D,$B9,$40,$82,$49));
      RAMdisk_supporting_a_virtual_disk_region_volatile:acpi_guid=(data1:$77AB535A;data2:$45FC;data3:$624B;data4:($55,$60,$F7,$B2,$81,$D1,$F9,$6E));
      RAMdisk_supporting_a_CD_disk_region_volatile:acpi_guid=(data1:$3D5ABD30;data2:$4175;data3:$87CE;data4:($6D,$64,$D2,$AD,$E5,$23,$C4,$BB));
      RAMdisk_supporting_a_virtual_disk_region_persistant:acpi_guid=(data1:$5CEA02C9;data2:$4D07;data3:$69D3;data4:($26,$9F,$44,$96,$FB,$E0,$96,$F9));
      RAMdisk_supporting_a_CD_disk_region_persistant:acpi_guid=(data1:$08018188;data2:$42CD;data3:$BB48;data4:($10,$0F,$53,$87,$D5,$3D,$ED,$3D));
      signature_rsdp:PChar='RSD PTR ';
      signature_rsdt:PChar='RSDT';
      signature_xsdt:PChar='XSDT';
      signature_fadt:PChar='FACP';
      signature_facs:PChar='FACS';
      signature_madt:PChar='APIC';
      signature_sbst:PChar='SBST';
      signature_ecdt:PChar='ECDT';
      signature_srat:PChar='SRAT';
      signature_slit:PChar='SLIT';
      signature_cpep:PChar='CPEP';
      signature_msct:PChar='MSCT';
      signature_rasf:PChar='RASF';
      signature_ras2:PChar='RAS2';
      signature_mpst:PChar='MPST';
      signature_bgrt:PChar='BGRT';
      signature_fpdt:PChar='FPDT';
      signature_gtdt:PChar='GTDT';
      signature_nfit:PChar='NFIT';
      signature_sdev:PChar='SDEV';
      signature_hmat:PChar='HMAT';
      signature_pdtt:PChar='PDTT';
      signature_pptt:PChar='PPTT';
      signature_phat:PChar='PHAT';
      signature_viot:PChar='VIOT';
      signature_misc:PChar='MISC';
      signature_ccel:PChar='CCEL';
      signature_skvl:PChar='SKVL';

function acpi_guid_match(guid1,guid2:acpi_guid):boolean; 
function acpi_check_signature_long(signature:qword):byte;
function acpi_check_signature_short(signature:dword):byte;     
function acpi_start_analyze_hardware(address:Pointer):Pacpi_hardware_tree;
procedure acpi_analyze_hardware(root:Pacpi_hardware_tree);

implementation

function acpi_guid_match(guid1,guid2:acpi_guid):boolean;[public,alias:'ACPI_GUID_MATCH'];
var res:boolean;
    i:byte;
begin
 res:=true;
 if(guid1.data1<>guid2.data1) then exit(false);
 if(guid1.data2<>guid2.data2) then exit(false);
 if(guid1.data3<>guid2.data3) then exit(false);
 for i:=1 to 8 do if(guid1.data4[i]<>guid2.data4[i]) then exit(false);
 acpi_guid_match:=res;
end;
function acpi_check_signature_long(signature:qword):byte;[public,alias:'ACPI_CHECK_SIGNATURE_LONG'];
var signstr:PChar;
    i:byte;
begin
 signstr:=@signature; i:=1;
 While(i<=8) do 
  begin
   if((signstr+i-1)^<>(signature_rsdp+i-1)^) then break;
   inc(i);
  end;
 if(i>8) then acpi_check_signature_long:=1 else acpi_check_signature_long:=0;
end;
function acpi_check_signature_short(signature:dword):byte;[public,alias:'ACPI_CHECK_SIGNATURE_SHORT'];
var signstr:PChar;
    res:byte;
begin
 signstr:=@signature; res:=0;
 if(signstr^=signature_rsdt^) and ((signstr+1)^=(signature_rsdt+1)^) and ((signstr+2)^=(signature_rsdt+2)^)
 and ((signstr+3)^=(signature_rsdt+3)^) then 
  begin
   res:=1;
  end
 else if(signstr^=signature_xsdt^) and ((signstr+1)^=(signature_xsdt+1)^) and ((signstr+2)^=(signature_xsdt+2)^)
 and ((signstr+3)^=(signature_xsdt+3)^) then 
  begin
   res:=2;
  end
 else if(signstr^=signature_fadt^) and ((signstr+1)^=(signature_fadt+1)^) and ((signstr+2)^=(signature_fadt+2)^)
 and ((signstr+3)^=(signature_fadt+3)^) then 
  begin
   res:=3;
  end
 else if(signstr^=signature_facs^) and ((signstr+1)^=(signature_facs+1)^) and ((signstr+2)^=(signature_facs+2)^)
 and ((signstr+3)^=(signature_facs+3)^) then 
  begin
   res:=4;
  end
 else if(signstr^=signature_madt^) and ((signstr+1)^=(signature_madt+1)^) and ((signstr+2)^=(signature_madt+2)^)
 and ((signstr+3)^=(signature_madt+3)^) then 
  begin
   res:=5;
  end
 else if(signstr^=signature_sbst^) and ((signstr+1)^=(signature_sbst+1)^) and ((signstr+2)^=(signature_sbst+2)^)
 and ((signstr+3)^=(signature_sbst+3)^) then 
  begin
   res:=6;
  end
 else if(signstr^=signature_ecdt^) and ((signstr+1)^=(signature_ecdt+1)^) and ((signstr+2)^=(signature_ecdt+2)^)
 and ((signstr+3)^=(signature_ecdt+3)^) then 
  begin
   res:=7;
  end
 else if(signstr^=signature_srat^) and ((signstr+1)^=(signature_srat+1)^) and ((signstr+2)^=(signature_srat+2)^)
 and ((signstr+3)^=(signature_srat+3)^) then 
  begin
   res:=8;
  end
 else if(signstr^=signature_slit^) and ((signstr+1)^=(signature_slit+1)^) and ((signstr+2)^=(signature_slit+2)^)
 and ((signstr+3)^=(signature_slit+3)^) then 
  begin
   res:=9;
  end
 else if(signstr^=signature_cpep^) and ((signstr+1)^=(signature_cpep+1)^) and ((signstr+2)^=(signature_cpep+2)^)
 and ((signstr+3)^=(signature_cpep+3)^) then 
  begin
   res:=10;
  end
 else if(signstr^=signature_msct^) and ((signstr+1)^=(signature_msct+1)^) and ((signstr+2)^=(signature_msct+2)^)
 and ((signstr+3)^=(signature_msct+3)^) then 
  begin
   res:=11;
  end
 else if(signstr^=signature_rasf^) and ((signstr+1)^=(signature_rasf+1)^) and ((signstr+2)^=(signature_rasf+2)^)
 and ((signstr+3)^=(signature_rasf+3)^) then 
  begin
   res:=12;
  end
 else if(signstr^=signature_ras2^) and ((signstr+1)^=(signature_ras2+1)^) and ((signstr+2)^=(signature_ras2+2)^)
 and ((signstr+3)^=(signature_ras2+3)^) then 
  begin
   res:=13;
  end
 else if(signstr^=signature_mpst^) and ((signstr+1)^=(signature_mpst+1)^) and ((signstr+2)^=(signature_mpst+2)^)
 and ((signstr+3)^=(signature_mpst+3)^) then 
  begin
   res:=14;
  end
 else if(signstr^=signature_bgrt^) and ((signstr+1)^=(signature_bgrt+1)^) and ((signstr+2)^=(signature_bgrt+2)^)
 and ((signstr+3)^=(signature_bgrt+3)^) then 
  begin
   res:=15;
  end
 else if(signstr^=signature_fpdt^) and ((signstr+1)^=(signature_fpdt+1)^) and ((signstr+2)^=(signature_fpdt+2)^)
 and ((signstr+3)^=(signature_fpdt+3)^) then 
  begin
   res:=16;
  end
 else if(signstr^=signature_gtdt^) and ((signstr+1)^=(signature_gtdt+1)^) and ((signstr+2)^=(signature_gtdt+2)^)
 and ((signstr+3)^=(signature_gtdt+3)^) then 
  begin
   res:=17;
  end
 else if(signstr^=signature_nfit^) and ((signstr+1)^=(signature_nfit+1)^) and ((signstr+2)^=(signature_nfit+2)^)
 and ((signstr+3)^=(signature_nfit+3)^) then 
  begin
   res:=18;
  end
 else if(signstr^=signature_sdev^) and ((signstr+1)^=(signature_sdev+1)^) and ((signstr+2)^=(signature_sdev+2)^)
 and ((signstr+3)^=(signature_sdev+3)^) then 
  begin
   res:=19;
  end
 else if(signstr^=signature_hmat^) and ((signstr+1)^=(signature_hmat+1)^) and ((signstr+2)^=(signature_hmat+2)^)
 and ((signstr+3)^=(signature_hmat+3)^) then 
  begin
   res:=20;
  end
 else if(signstr^=signature_pdtt^) and ((signstr+1)^=(signature_pdtt+1)^) and ((signstr+2)^=(signature_pdtt+2)^)
 and ((signstr+3)^=(signature_pdtt+3)^) then 
  begin
   res:=21;
  end
 else if(signstr^=signature_pptt^) and ((signstr+1)^=(signature_pptt+1)^) and ((signstr+2)^=(signature_pptt+2)^)
 and ((signstr+3)^=(signature_pptt+3)^) then 
  begin
   res:=22;
  end
 else if(signstr^=signature_phat^) and ((signstr+1)^=(signature_phat+1)^) and ((signstr+2)^=(signature_phat+2)^)
 and ((signstr+3)^=(signature_phat+3)^) then 
  begin
   res:=23;
  end
 else if(signstr^=signature_viot^) and ((signstr+1)^=(signature_viot+1)^) and ((signstr+2)^=(signature_viot+2)^)
 and ((signstr+3)^=(signature_viot+3)^) then 
  begin
   res:=24;
  end
 else if(signstr^=signature_misc^) and ((signstr+1)^=(signature_misc+1)^) and ((signstr+2)^=(signature_misc+2)^)
 and ((signstr+3)^=(signature_misc+3)^) then 
  begin
   res:=25;
  end
 else if(signstr^=signature_ccel^) and ((signstr+1)^=(signature_ccel+1)^) and ((signstr+2)^=(signature_ccel+2)^)
 and ((signstr+3)^=(signature_ccel+3)^) then 
  begin
   res:=26;
  end
 else if(signstr^=signature_skvl^) and ((signstr+1)^=(signature_skvl+1)^) and ((signstr+2)^=(signature_skvl+2)^)
 and ((signstr+3)^=(signature_skvl+3)^) then 
  begin
   res:=27;
  end
 else res:=0;
 acpi_check_signature_short:=res;
end;
function acpi_start_analyze_hardware(address:Pointer):Pacpi_hardware_tree;[public,alias:'ACPI_START_ANALYSE_HARDWARE'];
var root:Pacpi_hardware_tree;
begin
 root:=allocmem(sizeof(acpi_hardware_tree));
 root^.acpi_root:=nil;
 root^.acpi_type:=0;
 root^.acpi_content:=address;
 acpi_analyze_hardware(root);
 acpi_start_analyze_hardware:=root;
end;
procedure acpi_analyze_hardware(root:Pacpi_hardware_tree);[public,alias:'ACPI_ANALYZE_HARDWARE'];
var csignature:^dword;
    tempentry1:^dword;
    tempentry2:^qword;
    temprsdp:Pacpi_rsdp;
    temprsdt:Pacpi_rsdt;
    tempxsdt:Pacpi_xsdt;
    i:qword;
begin
 if(root^.acpi_type=0) then
  begin
   temprsdp:=root^.acpi_content;
   if(temprsdp^.revision>=2) and (temprsdp^.rsdtaddress>0) then root^.acpi_child_count:=2 else root^.acpi_child_count:=1;
   root^.acpi_child:=allocmem(root^.acpi_child_count*sizeof(acpi_hardware_tree));
   for i:=1 to root^.acpi_child_count do
    begin
     (root^.acpi_child+i-1)^.acpi_root:=root;
     (root^.acpi_child+i-1)^.acpi_type:=i;
     if(temprsdp^.rsdtaddress>0) then
      begin
       if(i=1) then (root^.acpi_child+i-1)^.acpi_content:=Pointer(temprsdp^.rsdtaddress)
       else (root^.acpi_child+i-1)^.acpi_content:=Pointer(temprsdp^.xsdtaddress);
      end
     else if(temprsdp^.rsdtaddress=0) then
      begin
       (root^.acpi_child+i-1)^.acpi_content:=Pointer(temprsdp^.xsdtaddress);
      end;
     acpi_analyze_hardware(root^.acpi_child+i-1);
    end; 
  end
 else if(root^.acpi_type>0) then
  begin
   case root^.acpi_type of
   1:
   begin
    temprsdt:=root^.acpi_content;
    tempentry1:=Pointer(Pointer(temprsdt)+sizeof(acpi_rsdt)-4);
    root^.acpi_child_count:=(temprsdt^.length+4-sizeof(acpi_rsdt)) shr 2;
    root^.acpi_child:=allocmem(root^.acpi_child_count*sizeof(acpi_hardware_tree));
    for i:=1 to root^.acpi_child_count do
     begin
      (root^.acpi_child+i-1)^.acpi_root:=root;
      csignature:=Pointer(tempentry1+i-1); (root^.acpi_child+i-1)^.acpi_type:=acpi_check_signature_short(csignature^);
      (root^.acpi_child+i-1)^.acpi_content:=Pointer((tempentry1+i-1)^);
      acpi_analyze_hardware(root^.acpi_child+i-1);
     end;
   end;
   2:
   begin
    tempxsdt:=root^.acpi_content;
    tempentry2:=Pointer(Pointer(tempxsdt)+sizeof(acpi_xsdt)-8);
    root^.acpi_child_count:=(tempxsdt^.length+8-sizeof(acpi_xsdt)) shr 3;
    root^.acpi_child:=allocmem(root^.acpi_child_count*sizeof(acpi_hardware_tree));
    for i:=1 to root^.acpi_child_count do
     begin
      (root^.acpi_child+i-1)^.acpi_root:=root;
      csignature:=Pointer(tempentry2+i-1); (root^.acpi_child+i-1)^.acpi_type:=acpi_check_signature_short(csignature^);
      (root^.acpi_child+i-1)^.acpi_content:=Pointer((tempentry2+i-1)^);
      acpi_analyze_hardware(root^.acpi_child+i-1);
     end;
   end;
   else
    begin
     root^.acpi_child:=nil; root^.acpi_child_count:=0;
    end;
   end;
  end;
end;

end.
