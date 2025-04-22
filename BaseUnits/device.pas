unit device;

interface

uses usb;
      {Refer to PCI Code Specification}
const device_class_old_device:byte=$0;
      device_class_mass_storage_controller:byte=$1;
      device_class_network_controller:byte=$2;
      device_class_display_controller:byte=$3;
      device_class_multimedia_device:byte=$4;
      device_class_memory_controller:byte=$5;
      device_class_bridge_device:byte=$6;
      device_class_simple_communication_controller:byte=$7;
      device_class_base_system_peripheral:byte=$8;
      device_class_input_device:byte=$9;
      device_class_docking_station:byte=$A;
      device_class_processor:byte=$B;
      device_class_serial_bus_controller:byte=$C;
      device_class_wireless_controller:byte=$D;
      device_class_intelligent_io_controller:byte=$E;
      device_class_satellite_communication_controller:byte=$F;
      device_class_encryption_or_decryption_controller:byte=$10;
      device_class_data_acquisition_and_signal_processing_controller:byte=$11;
      device_class_processing_accelerator:byte=$12;
      device_class_non_essential_instrumentation:byte=$13;
      device_class_device_does_not_fit_in_any_defined_classes:byte=$FF;
      {These are sub class code and programming interface mode}
      device_sub_class_non_vga_compatible_device:byte=$0;
      device_sub_class_vga_compatible_device:byte=$1;
      device_sub_class_scsi_controller_or_storage_device:byte=$0;
      device_programming_interface_scsi_controller_vendor_specific:byte=$0;
      device_programming_interface_scsi_storage_device:byte=$11;
      device_programming_interface_scsi_controller:byte=$12;
      device_programming_interface_scsi_storage_device_and_controller:byte=$13;
      device_programming_interface_scsi_storage_device_using_nvme:byte=$21;
      device_sub_class_ide_controller:byte=$1;
      device_sub_class_floppy_disk_controller:byte=$2;
      device_sub_class_ipi_bus_controller:byte=$3;
      device_sub_class_raid_controller:byte=$4;
      device_sub_class_ata_controller:byte=$5;
      device_programming_interface_ata_controller_single_stepping:byte=$20;
      device_programming_interface_ata_controller_continuous:byte=$30;
      device_sub_class_serial_ata_controller:byte=$6;
      device_programming_interface_serial_ata_controller_vendor_specific:byte=$0;
      device_programming_interface_serial_ata_controller_ahci_interface:byte=$1;
      device_programming_interface_serial_storage_bus_interface:byte=$2;
      device_sub_class_scsi_controller:byte=$7;
      device_programming_interface_sas_controller:byte=$0;
      device_programming_interface_scsi_controller_obsolete:byte=$1;
      device_sub_class_nvm_controller:byte=$8;
      device_programming_interface_nvm_vendor_specific:byte=$0;
      device_programming_interface_nvm_nvmhci_interface:byte=$1;
      device_programming_interface_nvme_io_controller:byte=$2;
      device_programming_interface_nvme_administrative_controller:byte=$3;
      device_sub_class_ufs_controller:byte=$09;
      device_programming_interface_ufs_vendor_specific:byte=$0;
      device_programming_interface_ufshci:byte=$1;
      device_sub_class_other_mass_storage_controller:byte=$80;
      device_sub_class_ethernet_controller:byte=$0;
      device_sub_class_token_ring_controller:byte=$1;
      device_sub_class_fddi_controller:byte=$2;
      device_sub_class_atm_controller:byte=$3;
      device_sub_class_isdn_controller:byte=$4;
      device_sub_class_worldfip_controller:byte=$5;
      device_sub_class_picmg_multi_computing:byte=$6;
      device_sub_class_infiniband_controller:byte=$7;
      device_sub_class_host_fabric_controller:byte=$8;
      device_sub_class_other_network_controller:byte=$80;
      device_sub_class_compatible_controller:byte=$0;
      device_programming_interface_vga_compatible_controller:byte=$0;
      device_programming_interface_8514_compatible_controller:byte=$1;
      device_sub_class_xga_controller:byte=$1;
      device_sub_class_3d_controller:byte=$2;
      device_sub_class_other_display_controller:byte=$80;
      device_sub_class_video_device:byte=$0;
      device_sub_class_audio_device:byte=$1;
      device_sub_class_computer_telephony_device:byte=$2;
      device_sub_class_hd_audio:byte=$3;
      device_programming_interface_hd_audio:byte=$00;
      device_programming_interface_hd_audio_with_vendor_specific:byte=$80;
      device_sub_class_other_multimedia_device:byte=$80;
      device_sub_class_ram:byte=$00;
      device_sub_class_flash:byte=$01;
      device_sub_class_other_memory_controller:byte=$02;
      device_sub_class_host_bridge:byte=$00;
      device_sub_class_isa_bridge:byte=$01;
      device_sub_class_eisa_bridge:byte=$02;
      device_sub_class_mca_bridge:byte=$03;
      device_sub_class_pci_bridge:byte=$04;
      device_programming_interface_pci_to_pci_bridge:byte=$00;
      device_programming_interface_substractive_decode_pci_to_pci_bridge:byte=$01;
      device_sub_class_pcmica_bridge:byte=$05;
      device_sub_class_nubus_bridge:byte=$06;
      device_sub_class_cardbus_bridge:byte=$07;
      device_sub_class_raceway_bridge:byte=$08;
      device_sub_class_semi_transparent_pci_to_pci_bridge:byte=$09;
      device_programming_interface_primany_pci_bus:byte=$40;
      device_programming_interface_secondary_pci_bus:byte=$80;
      device_sub_class_infiniband_to_pci_host_bridge:byte=$0A;
      device_sub_class_advanced_switching_to_pci_host_bridge:byte=$0B;
      device_programming_interface_advanced_switching_to_pci_host_bridge_custom_interface:byte=$00;
      device_programming_interface_advanced_switching_to_pci_host_bridge_asi_sig_defined_interface:byte=$01;
      device_sub_class_other_bridge_device:byte=$80;
      device_sub_class_compatible_serial_controller:byte=$00;
      device_programming_interface_generic_xt_compatible_serial_controller:byte=$00;
      device_programming_interface_16450_compatible_serial_controller:byte=$01;
      device_programming_interface_16550_compatible_serial_controller:byte=$02;
      device_programming_interface_16650_compatible_serial_controller:byte=$03;
      device_programming_interface_16750_compatible_serial_controller:byte=$04;
      device_programming_interface_16850_compatible_serial_controller:byte=$05;
      device_programming_interface_16950_compatible_serial_controller:byte=$06;
      device_sub_class_port:byte=$01;
      device_programming_interface_parallel_port:byte=$00;
      device_programming_interface_bi_directional_parallel_port:byte=$01;
      device_programming_interface_ecp_compliant_parallel_port:byte=$02;
      device_programming_interface_ieee1284_controller:byte=$02;
      device_programming_interface_ieee1284_target_device:byte=$03;
      device_sub_class_multiport_serial_controller:byte=$02;
      device_sub_class_modem:byte=$03;
      device_programming_interface_generic_modem:byte=$00;
      device_programming_interface_hayes_compatible_modem_16450_compatible:byte=$01;
      device_programming_interface_hayes_compatible_modem_16550_compatible:byte=$02;
      device_programming_interface_hayes_compatible_modem_16650_compatible:byte=$03;
      device_programming_interface_hayes_compatible_modem_16750_compatible:byte=$04;
      device_sub_class_gpib_controller:byte=$04;
      device_sub_class_smart_card:byte=$05;
      device_sub_class_other_communication_controller:byte=$80;
      device_sub_class_pic:byte=$00;
      device_programming_interface_generic_8259_pic:byte=$00;
      device_programming_interface_isa_pic:byte=$01;
      device_programming_interface_eisa_pic:byte=$02;
      device_programming_interface_io_apic_interrupt_controller:byte=$10;
      device_programming_interface_iox_apic_interrupt_controller:byte=$20;
      device_sub_class_dma:byte=$01;
      device_programming_interface_generic_8237_dma_controller:byte=$00;
      device_programming_interface_isa_dma_controller:byte=$01;
      device_programming_interface_eisa_dma_controller:byte=$02;
      device_sub_class_timer:byte=$02;
      device_programming_interface_generic_8254_system_timer:byte=$00;
      device_programming_interface_isa_system_timer:byte=$01;
      device_programming_interface_eisa_system_timer:byte=$02;
      device_programming_interface_high_performance_event_timer:byte=$03;
      device_sub_class_rtc_controller:byte=$03;
      device_programming_interface_generic_rtc_controller:byte=$00;
      device_programming_interface_isa_rtc_controller:byte=$01;
      device_sub_class_hot_plug_controller:byte=$04;
      device_sub_class_sd_host_controller:byte=$05;
      device_sub_class_iommu:byte=$06;
      device_sub_class_root_complex_event_collector:byte=$07;
      device_sub_class_other_system_peripheral:byte=$80;
      device_sub_class_keyboard_controller:byte=$00;
      device_sub_class_digitizer:byte=$01;
      device_sub_class_mouse_controller:byte=$02;
      device_sub_class_scanner_controller:byte=$03;
      device_sub_class_gameport_controller:byte=$04;
      device_programming_interface_generic_gameport_controller:byte=$00;
      device_programming_interface_non_generic_gameport_controller:byte=$01;
      device_sub_class_other_input_controller:byte=$80;
      device_sub_class_docking_station:byte=$00;
      device_sub_class_other_type_of_docking_station:byte=$80;
      device_sub_class_386:byte=$00;
      device_sub_class_486:byte=$01;
      device_sub_class_pentium:byte=$02;
      device_sub_class_alpha:byte=$10;
      device_sub_class_powerpc:byte=$20;
      device_sub_class_mips:byte=$30;
      device_sub_class_co_processor:byte=$40;
      device_sub_class_other_processors:byte=$80;
      device_sub_class_ieee_1394:byte=$00;
      device_programming_interface_ieee_1394_firewire:byte=$00;
      device_programming_interface_ieee_1394_following_1394_openhci_specification:byte=$10;
      device_sub_class_access_bus:byte=$01;
      device_sub_class_ssa:byte=$02;
      device_sub_class_usb_device:byte=$03;
      device_programming_interface_usb_following_uhcb:byte=$00;
      device_programming_interface_usb_following_ohcb:byte=$10;
      device_programming_interface_usb_2_host_controller:byte=$20;
      device_programming_interface_usb_following_xhci:byte=$30;
      device_programming_interface_usb_with_no_specific_programming_interface:byte=$80;
      device_programming_interface_usb_device_not_host_controller:byte=$FE;
      device_sub_class_fibre_channel:byte=$04;
      device_sub_class_smbus:byte=$05;
      device_sub_class_infiniband_deprecated:byte=$06;
      device_sub_class_ipmi:byte=$07;
      device_programming_interface_ipmi_smic_interface:byte=$00;
      device_programming_interface_ipmi_keyboard_controller_style_interface:byte=$01;
      device_programming_interface_ipmi_block_transfer_interface:byte=$02;
      device_sub_class_sercos_interface_standard:byte=$08;
      device_sub_class_canbus:byte=$09;
      device_sub_class_mipi_i3c_host_controller_interface:byte=$0A;
      device_sub_class_other_serial_bus_controllers:byte=$80;
      device_sub_class_irda_compatible_controller:byte=$00;
      device_sub_class_radio_controller:byte=$01;
      device_programming_interface_consumer_ir_controller:byte=$00;
      device_programming_interface_uwb_radio_controller:byte=$01;
      device_sub_class_rf_controller:byte=$10;
      device_sub_class_bluetooth:byte=$11;
      device_sub_class_broadband:byte=$12;
      device_sub_class_ethernet_5ghz:byte=$20;
      device_sub_class_ethernet_24ghz:byte=$21;
      device_sub_class_cellular_controller_modem:byte=$40;
      device_sub_class_cellular_controller_modem_plus:byte=$41;
      device_sub_class_other_type_of_wireless_controller:byte=$80;
      device_sub_class_intelligent_controller:byte=$00;
      device_programming_interface_i2o_spec:byte=$00;
      device_programming_interface_message_fifo:byte=$01;
      device_sub_class_tv:byte=$00;
      device_sub_class_audio:byte=$01;
      device_sub_class_voice:byte=$02;
      device_sub_class_data:byte=$03;
      device_sub_class_other_satellite_communication_controller:byte=$80;
      device_sub_class_network_and_computing_encryption_and_decryption_controller:byte=$00;
      device_sub_class_entertainment_encryption_and_decryption_controller:byte=$10;
      device_sub_class_other_encryption_and_decryption_controller:byte=$80;
      device_sub_class_dpio_modules:byte=$00;
      device_sub_class_performance_counters:byte=$01;
      device_sub_class_communication_synchronization_plus_time_and_frequency_test_or_measurement:byte=$10;
      device_sub_class_management_card:byte=$20;
      device_sub_class_other_data_acquisition_or_signal_processing_controllers:byte=$80;
      device_sub_class_processing_accelerator:byte=$00;
      device_sub_class_non_essential_instrumental_function:byte=$00;
      {Device Index for specified device}
      device_unrecognized_device:qword=0;
      device_redhat_qemu_nvme_controller:qword=1;
      device_redhat_qemu_pcie_root:qword=2;
      device_redhat_qemu_xhci_host_controller:qword=3;
      device_redhat_qemu_qxl_paravirtual_graphic_card:qword=4;
      device_redhat_pci_rocker_ethernet_switch_device:qword=5;
      device_redhat_pci_sd_card_host_controller_interface:qword=6;
      device_redhat_qemu_pcie_host_bridge:qword=7;
      device_redhat_qemu_pci_expander_bridge:qword=8;
      device_redhat_pci_to_pci_bridge_multiset:qword=9;
      device_redhat_qemu_pcie_expander_bridge:qword=10;
      device_redhat_qemu_pci_to_pci_bridge:qword=11;
      device_redhat_qemu_pci_16550A_bridge:qword=12;
      device_redhat_qemu_pci_dual_port_16550A_Adapter:qword=13;
      device_redhat_qemu_pci_quad_port_16550A_Adapter:qword=14;
      device_redhat_qemu_pci_test_device:qword=15;
      device_redhat_virtio_file_system:qword=16;
      device_redhat_virtio_1_0_socket:qword=17;
      device_redhat_inter_VM_shared_memory:qword=18;
      device_redhat_virtio_1_0_console:qword=19;
      device_redhat_virtio_1_0_RNG:qword=20;
      device_redhat_virtio_1_0_memory_balloon:qword=21;
      device_redhat_virtio_1_0_scsi:qword=22;
      device_redhat_virtio_1_0_file_system:qword=23;
      device_redhat_virtio_1_0_gpu:qword=24;
      device_redhat_virtio_1_0_input:qword=25;
      device_redhat_virtio_console:qword=26;
      device_redhat_virtio_scsi:qword=27;
      device_redhat_virtio_rng:qword=28;
      device_redhat_virtio_filesystem:qword=29;
      device_redhat_virtio_1_0_network_device:qword=30;
      device_redhat_virtio_1_0_block_device:qword=31;
      device_redhat_virtio_network_device:qword=32;
      device_redhat_virtio_block_device:qword=33;
      device_redhat_virtio_memory_balloon:qword=34;

type device_info=packed record
                 {Device Base Class}
                 deviceclass:byte;
                 {Device Base Type based on Device Base Class}
                 devicetype:byte;
                 {Device Base Programming Interface based on Base Class And Sub Class}
                 devicepi:byte;
                 {Device VendorId}
                 devicemanufacturerId:word;
                 {Device DeviceId}
                 deviceuniqueid:word;
                 end;
     device_io_range=packed record
                     address_start:Pointer;
                     address_end:Pointer;
                     address_offset:qword;
                     end;
     device_io_info=packed record 
                    {If it is mapped in MMIO}
                    ismmio:boolean;
                    {Only MMIO Devices can be scanned and recognized}
                    ioaddress:device_io_range;
                    end;
     Pdevice_io_info=^device_io_info;
     device_object=packed record
                   {Stores the unique index}
                   index:dword;
                   {Stores device name}
                   name:qword;
                   {Stores device I/O information}
                   io:^device_io_info;
                   iocount:byte;
                   {Stores device object content}
                   content:Pointer;
                   end;
     device_object_list=packed record
                        {Max index of the device list}
                        maxindex:dword;
                        {Device object list's items}
                        item:^device_object;
                        {Device object items' count}
                        count:Natuint;
                        end;

function device_list_initialize:device_object_list;
function device_list_construct_device_object(devclass:byte;devsubclass:byte;devpi:byte;
devmanufactureId:word;devuniqueid:word;iolist:Pdevice_io_info;iocount:byte):device_object;
function device_list_search_for_object(list:device_object_list;searchpos:Natuint):device_object;
function device_list_search_for_object_index(list:device_object_list;searchpos:Natuint):dword;
procedure device_list_add_item(var list:device_object_list;item:device_object);
procedure device_list_delete_item(var list:device_object_list;position:natuint);
procedure device_list_delete_item_with_index(var list:device_object_list;index:natuint);
procedure device_list_free(var list:device_object_list);

var os_devlist:device_object_list;

implementation

function device_list_initialize:device_object_list;[public,alias:'device_list_initialize'];
var res:device_object_list;
begin
 res.item:=nil; res.count:=0; res.maxindex:=0;
 device_list_initialize:=res;
end;
function device_get_device_index(info:device_info):Natuint;[public,alias:'device_get_device_index'];
begin
 if(info.devicemanufacturerId=$1B36) then
  begin
   case info.deviceuniqueid of
   $10:device_get_device_index:=1;
   $C:device_get_device_index:=2;
   $D:device_get_device_index:=3;
   $100:device_get_device_index:=4;
   $6:device_get_device_index:=5;
   $7:device_get_device_index:=6;
   $8:device_get_device_index:=7;
   $9:device_get_device_index:=8;
   $A:device_get_device_index:=9;
   $B:device_get_device_index:=10;
   $1:device_get_device_index:=11;
   $2:device_get_device_index:=12;
   $3:device_get_device_index:=13;
   $4:device_get_device_index:=14;
   $5:device_get_device_index:=15;
   end;
  end
 else if(info.devicemanufacturerId=$1AF4) then
  begin
   case info.deviceuniqueid of
   $105A:device_get_device_index:=16;
   $1053:device_get_device_index:=17;
   $1110:device_get_device_index:=18;
   $1043:device_get_device_index:=19;
   $1044:device_get_device_index:=20;
   $1045:device_get_device_index:=21;
   $1048:device_get_device_index:=22;
   $1049:device_get_device_index:=23;
   $1050:device_get_device_index:=24;
   $1052:device_get_device_index:=25;
   $1003:device_get_device_index:=26;
   $1004:device_get_device_index:=27;
   $1005:device_get_device_index:=28;
   $1009:device_get_device_index:=29;
   $1041:device_get_device_index:=30;
   $1042:device_get_device_index:=31;
   $1000:device_get_device_index:=32;
   $1001:device_get_device_index:=33;
   $1002:device_get_device_index:=34;
   end;
  end
 else device_get_device_index:=0;
end;
function device_list_construct_device_object(devclass:byte;devsubclass:byte;devpi:byte;
devmanufactureId:word;devuniqueid:word;iolist:Pdevice_io_info;iocount:byte):device_object;[public,alias:'device_list_construct_device_object'];
var res:device_object;
    info:device_info;
begin
 info.deviceclass:=devclass;
 info.devicetype:=devsubclass;
 info.devicepi:=devpi;
 info.devicemanufacturerId:=devmanufactureId;
 info.deviceuniqueid:=devuniqueid;
 res.name:=device_get_device_index(info);
 res.index:=0;
 if(iolist<>nil) and (iocount<>0) then
  begin
   res.io:=allocmem(iocount*sizeof(device_io_info));
   Move(iolist^,res.io^,sizeof(device_io_info)*iocount);
   res.iocount:=iocount;
  end
 else
  begin
   res.io:=nil;
   res.iocount:=0;
  end;
 if(res.name=3) then
  begin
   res.content:=usb_initialize(res.io^.ioaddress.address_start);
  end
 else res.content:=nil;
 device_list_construct_device_object:=res;
end;
function device_list_search_for_index(list:device_object_list;searchindex:dword):boolean;[public,alias:'device_list_search_for_index'];
var i:natuint;
begin
 i:=1;
 while(i<=list.count)do
  begin
   if((list.item+i-1)^.index=searchindex) then break;
   inc(i);
  end;
 if(i>list.count) then device_list_search_for_index:=false else device_list_search_for_index:=true;
end;
function device_list_search_for_object(list:device_object_list;searchpos:Natuint):device_object;
[public,alias:'device_list_search_for_object'];
var res:device_object;
begin
 if(searchpos>0) and (searchpos<=list.count) then res:=(list.item+searchpos-1)^ else res.iocount:=0; 
 device_list_search_for_object:=res;
end;
function device_list_search_for_object_index(list:device_object_list;searchpos:Natuint):dword;
[public,alias:'device_list_search_for_object_index'];
var res:device_object;
begin
 if(searchpos>0) and (searchpos<=list.count) then res:=(list.item+searchpos-1)^ else res.iocount:=0; 
 device_list_search_for_object_index:=res.index;
end;
procedure device_list_add_item(var list:device_object_list;item:device_object);[public,alias:'device_list_add_item'];
var i,j:natuint; 
begin
 i:=1;
 while(i<=list.maxindex)do
  begin
   if(device_list_search_for_index(list,i)=false) then break;
   inc(i);
  end;
 if(i>list.maxindex) then inc(list.maxindex);
 if(list.count=0) then
  begin
   inc(list.count);
   list.item:=allocmem(sizeof(device_object));
   list.item^.name:=item.name;
   list.item^.index:=i;
   list.item^.io:=allocmem(item.iocount*sizeof(device_io_info));
   Move(item.io^,list.item^.io^,sizeof(device_io_info)*item.iocount);
   list.item^.iocount:=item.iocount;
   list.item^.content:=item.content;
  end
 else
  begin
   inc(list.count);
   ReallocMem(list.item,sizeof(device_object)*list.count);
   (list.item+list.count-1)^.name:=item.name;
   (list.item+list.count-1)^.index:=i;
   (list.item+list.count-1)^.io:=allocmem(item.iocount*sizeof(device_io_info));
   Move(item.io^,(list.item+list.count-1)^.io^,sizeof(device_io_info)*item.iocount);
   (list.item+list.count-1)^.iocount:=item.iocount;
   (list.item+list.count-1)^.content:=item.content;
  end;
end;
procedure device_list_delete_item(var list:device_object_list;position:natuint);[public,alias:'device_list_delete_item'];
var i,tempindex:natuint;
    item:device_object;
begin
 item:=(list.item+position-1)^;
 if(item.index=list.maxindex) then 
  begin
   dec(list.maxindex);
   while(device_list_search_for_index(list,list.maxindex)) do dec(list.maxindex);
  end;
 FreeMem(item.io); FreeMem(item.content);
 i:=position;
 while(i<list.count)do
  begin
   (list.item+i-1)^:=(list.item+i)^; inc(i);
  end;
 dec(list.count);
 ReallocMem(list.item,sizeof(device_object)*list.count);
end;
procedure device_list_delete_item_with_index(var list:device_object_list;index:natuint);[public,alias:'device_list_delete_item_with_index'];
var i:natuint;
begin
 i:=1;
 while(i<=list.count)do
  begin
   if((list.item+i-1)^.index=index) then break;
   inc(i);
  end;
 if(i<=list.count) then device_list_delete_item(list,i);
end;
procedure device_list_free(var list:device_object_list);[public,alias:'device_list_free'];
var i,j:Natuint;
    item:device_object;
begin
 i:=1;
 while(i<=list.count)do
  begin
   item:=(list.item+i-1)^;
   FreeMem(item.io);
   FreeMem(item.content);
   inc(i);
  end;
 FreeMem(list.item); list.maxindex:=0; list.count:=0;
end;

end.
