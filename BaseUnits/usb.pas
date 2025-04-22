unit usb;

{$MODE FPC}

interface

type usb_device_context_base_address_element0=bitpacked record
                                              Reserved:0..63;
                                              ScratchBufferArrayBaseAddress:0..$3FFFFFFFFFFFFFF;
                                              end;
     usb_device_context_base_address_element=bitpacked record
                                             Reserved:0..63;
                                             DeviceContextBaseAddress:0..$3FFFFFFFFFFFFFF;
                                             end;
     usb_device_context_base_address_array=packed record
                                           element0:usb_device_context_base_address_element0;
                                           element:array[1..1] of usb_device_context_base_address_element;
                                           end;
     Pusb_device_context_base_address_array=^usb_device_context_base_address_array;
     {USB Contexts}
     usb_slot_context=bitpacked record
                      RouteString:0..1048575;
                      Speed:0..15;
                      Reserved1:0..1;
                      MultiTT:0..1;
                      Hub:0..1;
                      ContextEntriesLastVaildIndex:0..31;
                      MaxExitLatency:0..65535;
                      RootHubPortNumber:0..255;
                      NumberOfPorts:0..255;
                      ParentHubSlotID:0..255;
                      ParentPortNumber:0..255;
                      TTThinkTime:0..3;
                      Reserved2:0..15;
                      InterrupterTarget:0..1023;
                      USBDeviceAddress:0..255;
                      Reserved3:0..524287;
                      SlotState:0..31;
                      Reserved4:array[1..4] of dword;
                      end;
     Pusb_slot_context=^usb_slot_context;
     usb_endpoint_context=bitpacked record
                          EndPointState:0..7;
                          Reserved1:0..31;
                          Multi:0..1;
                          MaxPrimaryStreams:0..31;
                          LinearStreamArray:0..1;
                          Interval:0..255;
                          MaxEndpointServiceTimeIntervalPayloadHigh:0..255;
                          Reserved2:0..1;
                          ErrorCount:0..3;
                          Endpoint:0..7;
                          Reserved3:0..1;
                          HostIntitiateDisable:0..1;
                          MaxBurstSize:0..255;
                          MaxPacketSize:0..255;
                          DequeueCycleState:0..1;
                          Reserved4:0..7;
                          TRDequeuePointer:0..$FFFFFFFFFFFFFFF;
                          AverageTRBLength:0..65535;
                          MaxEndPointerServiceTimeIntervalPayloadLow:0..65535;
                          Reserved5:array[1..3] of dword;
                          end;
     Pusb_endpoint_context=^usb_endpoint_context;
     usb_stream_context=bitpacked record
                        DequeueCycleState:0..1;
                        StreamContextType:0..7;
                        TRDequeuePointer:0..$FFFFFFFFFFFFFFF;
                        StoppedEDTLA:0..16777215;
                        Reserved:0..$FFFFFFFFFF;
                        end;
     Pusb_stream_context=^usb_stream_context;
     usb_input_control_context=bitpacked record
                               Reserved1:0..1;
                               DropContextFlags:0..$3FFFFFFF;
                               AddContextFlags:0..$FFFFFFFF;
                               ConfigurationValue:0..255;
                               InterfaceNumber:0..255;
                               AlternateSetting:0..255;
                               Reserved2:0..255;
                               end;
     Pusb_input_control_context=^usb_input_control_context;
     usb_bandwidth_context=packed record
                           Port:array[0..0] of byte;
                           end;
     Pusb_bandwidth_context=^usb_bandwidth_context;
     usb_context=packed record
                 case Byte of
                 0:(Slot:usb_slot_context;);
                 1:(EndPoint:usb_endpoint_context;);
                 2:(InputControl:usb_input_control_context;);
                 end;
     Pusb_context=^usb_context;
     {TRB means Transfer Request Block}
     {USB Transfer TRBs}
     usb_normal_trb=bitpacked record
                    DataBufferPointer:qword;
                    TRBTransferLength:0..131071;
                    TDSize:0..31;
                    InterruptTarget:0..1023;
                    CycleBit:0..1;
                    EvaluateNextTRB:0..1;
                    InterruptOnShortPacket:0..1;
                    NoSnoop:0..1;
                    ChainBit:0..1;
                    InterruptOnCompletion:0..1;
                    ImmediateData:0..1;
                    Reserved1:0..3;
                    BlockEventInterrupt:0..1;
                    TRBType:0..63;
                    Reserved2:word;
                    end;
     Pusb_normal_trb=^usb_normal_trb;
     {USB Control TRBs}
     usb_setup_stage_trb=bitpacked record
                         BmRequestType:byte;
                         BRequest:byte;
                         WValue:word;
                         WIndex:word;
                         WLength:word;
                         TRBTransferLength:0..131071;
                         Reserved1:0..31;
                         InterruptTarget:0..1023;
                         CycleBit:0..1;
                         Reserved2:0..15;
                         InterruptOnCompletion:0..1;
                         ImmediateData:0..1;
                         Reserved3:0..7;
                         TRBType:0..63;
                         TransferType:0..3;
                         Reserved4:0..8191;
                         end;
     Pusb_setup_stage_trb=^usb_setup_stage_trb;
     usb_data_stage_trb=bitpacked record
                        DataBuffer:qword;
                        TRBTransferLength:0..131071;
                        TDSize:0..31;
                        InterruptTarget:0..1023;
                        CycleBit:0..1;
                        EvaluateNextTRB:0..1;
                        InterruptOnShortPacket:0..1;
                        NoSnoop:0..1;
                        ChainBit:0..1;
                        InterruptOnCompletion:0..1;
                        ImmediateData:0..1;
                        Reserved1:0..7;
                        TRBType:0..63;
                        Direction:0..1;
                        Reserved2:0..32767;
                        end;
     Pusb_data_stage_trb=^usb_data_stage_trb;
     usb_status_stage_trb=bitpacked record
                          Reserved1:qword;
                          Reserved2:0..4194303;
                          CycleBit:0..1;
                          EvaluateNextTRB:0..1;
                          Reserved:0..3;
                          ChainBit:0..1;
                          InterruptOnCompletion:0..1;
                          Reserved3:0..15;
                          TRBType:0..63;
                          Direction:0..1;
                          Reserved4:0..32767;
                          end;
     Pusb_status_stage_trb=^usb_status_stage_trb;
     usb_isoch_trb=bitpacked record
                   DataBufferPointer:qword;
                   TRBTransferLength:0..131071;
                   TDSizeOrTBC:0..31;
                   InterruptTarget:0..1023;
                   CycleBit:0..1;
                   EvaluableNextTRB:0..1;
                   InterruptOnShortPacket:0..1;
                   NoSnoop:0..1;
                   ChainBit:0..1;
                   InterruptOnCompletion:0..1;
                   ImmediateData:0..1;
                   TransferBurstCount:0..3;
                   BlockEventInterrupt:0..1;
                   TRBType:0..63;
                   TransferLastBurstPacketCount:0..15;
                   FrameID:0..2047;
                   StartISOCHASAP:0..1;
                   end;
     Pusb_isoch_trb=^usb_isoch_trb;
     usb_no_op_trb=bitpacked record
                   Reserved1:qword;
                   Reserved2:0..4194303;
                   InterrupterTarget:0..1023;
                   CycleBit:0..1;
                   EvaluateNextTRB:0..1;
                   Reserved3:0..3;
                   ChainBit:0..1;
                   InterruptOnCompletion:0..1;
                   Reserved4:0..15;
                   TRBType:0..63;
                   Reserved5:word;
                   end;
     Pusb_no_op_trb=^usb_no_op_trb;
     {USB Event TRBs}
     usb_transfer_event_trb=bitpacked record
                            TRBPointer:qword;
                            TRBTransferLength:0..16777215;
                            CompletionCode:0..255;
                            CycleBit:0..1;
                            Reserved1:0..1;
                            EventData:0..1;
                            Reserved2:0..127;
                            TRBType:0..63;
                            EndPointID:0..31;
                            Reserved3:0..7;
                            SlotID:byte;
                            end;
     Pusb_transfer_event_trb=^usb_transfer_event_trb;
     usb_command_completion_event_trb=bitpacked record
                                      Reserved1:0..15;
                                      CommandTRBPointer:0..$FFFFFFFFFFFFFFF;
                                      CommandCompletionParameter:0..$FFFFFF;
                                      CompletionCode:byte;
                                      CycleBit:0..1;
                                      Reserved2:0..511;
                                      TRBType:0..63;
                                      VirtualFunctionID:0..255;
                                      SlotID:0..255;
                                      end;
     Pusb_command_completion_event_trb=^usb_command_completion_event_trb;
     usb_port_status_change_event_trb=bitpacked record
                                      Reserved1:0..$FFFFFF;
                                      PortID:0..255;
                                      Reserved2:0..$FFFFFF;
                                      CompletionCode:0..255;
                                      CycleBit:0..1;
                                      Reserved3:0..511;
                                      TRBType:0..63;
                                      Reserved4:0..65535;
                                      end;
     Pusb_port_status_change_event_trb=^usb_port_status_change_event_trb;
     usb_bandwidth_request_event_trb=bitpacked record
                                     Reserved1:qword;
                                     Reserved2:0..$FFFFFF;
                                     CompletionCode:0..255;
                                     CycleBit:0..1;
                                     Reserved3:0..511;
                                     TRBType:0..63;
                                     Reserved4:byte;
                                     SlotID:byte;
                                     end;
     Pusb_bandwidth_request_event_trb=^usb_bandwidth_request_event_trb;
     usb_doorbell_event_trb=bitpacked record
                            DBReason:0..31;
                            Reserved1:0..134217727;
                            Reserved2:0..16777215;
                            CompletionCode:0..255;
                            CycleBit:0..1;
                            Reserved3:0..511;
                            TRBType:0..63;
                            VirtualFunctionID:byte;
                            SlotID:byte;
                            end;
     Pusb_doorbell_event_trb=^usb_doorbell_event_trb;
     usb_host_controller_event_trb=bitpacked record
                                   Reserved1:qword;
                                   Reserved2:0..16777215;
                                   CompletionCode:0..255;
                                   CycleBit:0..1;
                                   Reserved3:0..511;
                                   TRBType:0..63;
                                   Reserved4:word;
                                   end;
     Pusb_host_controller_event_trb=^usb_host_controller_event_trb;
     usb_device_notification_event_trb=bitpacked record
                                       Reserved1:0..15;
                                       NotificationType:0..15;
                                       DeviceNotificationData:0..$FFFFFFFFFFFFFF;
                                       Reserved2:0..$FFFFFF;
                                       CompletionCode:byte;
                                       CycleBit:0..1;
                                       Reserved3:0..511;
                                       TRBType:0..63;
                                       Reserved4:byte;
                                       SlotID:byte;
                                       end;
     Pusb_device_notification_event_trb=^usb_device_notification_event_trb;
     usb_mfindex_wrap_event_trb=bitpacked record
                                Reserved1:qword;
                                Reserved2:0..$FFFFFF;
                                CompletionCode:byte;
                                CycleBit:0..1;
                                Reserved3:0..511;
                                TRBType:0..63;
                                Reserved4:word;
                                end;
     Pusb_mfindex_wrap_event_trb=^usb_mfindex_wrap_event_trb;
     {USB Command TRBs}
     usb_no_op_command_trb=bitpacked record
                           Reserved1:array[1..3] of dword;
                           CycleBit:0..1;
                           Reserved2:0..511;
                           TRBType:0..63;
                           Reserved3:word;
                           end;
     Pusb_no_op_command_trb=^usb_no_op_command_trb;
     usb_enable_slot_command_trb=bitpacked record
                                 Reserved1:array[1..3] of dword;
                                 CycleBit:0..1;
                                 Reserved2:0..511;
                                 TRBType:0..63;
                                 SlotType:0..31;
                                 Reserved3:0..2047;
                                 end;
     Pusb_enable_slot_command_trb=^usb_enable_slot_command_trb;
     usb_disable_slot_command_trb=bitpacked record
                                  Reserved1:array[1..3] of dword;
                                  CycleBit:0..1;
                                  Reserved2:0..511;
                                  TRBType:0..63;
                                  Reserved3:byte;
                                  SlotID:byte;
                                  end;
     Pusb_disable_slot_command_trb=^usb_disable_slot_command_trb;
     usb_address_device_command_trb=bitpacked record
                                    Reserved1:0..15;
                                    InputContextPointer:0..$FFFFFFFFFFFFFFF;
                                    Reserved2:dword;
                                    CycleBit:0..1;
                                    Reserved3:0..255;
                                    BlockSetAddressRequest:0..1;
                                    TRBType:0..63;
                                    Reserved4:byte;
                                    SlotId:byte;
                                    end;
     Pusb_address_device_command_trb=^usb_address_device_command_trb;
     usb_configure_endpoint_command_trb=bitpacked record
                                        Reserved1:0..15;
                                        InputContextPointer:0..$FFFFFFFFFFFFFFF;
                                        Reserved2:dword;
                                        CycleBit:0..1;
                                        Reserved3:byte;
                                        Deconfigure:0..1;
                                        TRBType:0..63;
                                        Reserved4:byte;
                                        SlotId:byte;
                                        end;
     Pusb_configure_endpoint_command_trb=^usb_configure_endpoint_command_trb;
     usb_evaluate_context_command_trb=bitpacked record
                                      Reserved1:0..15;
                                      InputContextPointer:0..$FFFFFFFFFFFFFFF;
                                      Reserved2:dword;
                                      CycleBit:0..1;
                                      Reserved3:0..255;
                                      BlockSetAddressRequest:0..1;
                                      TRBType:0..63;
                                      Reserved4:byte;
                                      SlotId:byte;
                                      end;
     Pusb_evaluate_context_command_trb=^usb_evaluate_context_command_trb;
     usb_reset_endpoint_command_trb=bitpacked record
                                    Reserved1:array[1..3] of dword;
                                    CycleBit:0..1;
                                    Reserved2:0..255;
                                    TransferStatePreserve:0..1;
                                    TRBType:0..63;
                                    EndPointID:0..31;
                                    Reserved3:0..7;
                                    SlotId:byte;
                                    end;
     Pusb_reset_endpoint_command_trb=^usb_reset_endpoint_command_trb;
     usb_stop_endpoint_command_trb=bitpacked record
                                   Reserved1:array[1..3] of dword;
                                   CycleBit:0..1;
                                   Reserved2:0..511;
                                   TRBType:0..63;
                                   EndPointID:0..31;
                                   Reserved3:0..3;
                                   Suspend:0..1;
                                   SlotID:byte;
                                   end;
     Pusb_stop_endpoint_command_trb=^usb_stop_endpoint_command_trb;
     usb_set_tr_dequeue_pointer_command_trb=bitpacked record
                                            DequeueCycleState:0..1;
                                            StreamContextType:0..1;
                                            NewTRDequeuePointer:0..$FFFFFFFFFFFFFFF;
                                            Reserved1:word;
                                            StreamID:word;
                                            CycleBit:0..1;
                                            Reserved2:0..511;
                                            TRBType:0..63;
                                            EndPointID:0..31;
                                            Reserved3:0..7;
                                            SlotID:byte;
                                            end;
     Pusb_set_tr_dequeue_pointer_command_trb=^usb_set_tr_dequeue_pointer_command_trb;
     usb_reset_device_command_trb=bitpacked record
                                  Reserved1:array[1..3] of dword;
                                  CycleBit:0..1;
                                  Reserved2:0..511;
                                  TRBType:0..63;
                                  Reserved3:byte;
                                  SlotID:byte;
                                  end;
     Pusb_reset_device_command_trb=^usb_reset_device_command_trb;
     usb_force_event_command_trb=bitpacked record
                                 Reserved1:0..15;
                                 EventTRBPointer:0..$FFFFFFFFFFFFFFF;
                                 Reserved2:0..4194303;
                                 VFInterrupterTarget:0..1023;
                                 CycleBit:0..1;
                                 Reserved3:0..511;
                                 TRBType:0..63;
                                 VFID:byte;
                                 Reserved4:byte;
                                 end;
     Pusb_force_event_command_trb=^usb_force_event_command_trb;
     usb_negotiate_bandwidth_command_trb=usb_disable_slot_command_trb;
     Pusb_negotiate_bandwidth_command_trb=^usb_negotiate_bandwidth_command_trb;
     usb_set_latency_tolerance_value_command_trb=bitpacked record
                                                 Reserved1:array[1..3] of dword;
                                                 CycleBit:0..1;
                                                 Reserved2:0..511;
                                                 TRBType:0..63;
                                                 BestEffortLatencyToleranceValue:0..4095;
                                                 Reserved3:0..15;
                                                 end;
     Pusb_set_latency_tolerance_value_command_trb=^usb_set_latency_tolerance_value_command_trb;
     usb_get_port_bandwidth_command_trb=bitpacked record
                                        Reserved:0..15;
                                        PortBandWidthContextPointer:0..$FFFFFFFFFFFFFFF;
                                        Reserved2:dword;
                                        CycleBit:0..1;
                                        Reserved3:0..511;
                                        TRBType:0..63;
                                        DevSpeed:0..15;
                                        Reserved4:0..15;
                                        HubSlotID:byte;
                                        end;
     Pusb_get_port_bandwidth_command_trb=^usb_get_port_bandwidth_command_trb;
     usb_force_header_command_trb=bitpacked record
                                  PacketType:0..31;
                                  HeaderInfoLow:0..134217727;
                                  HeaderInfoHigh:qword;
                                  CycleBit:0..1;
                                  Reserved1:0..511;
                                  TRBType:0..63;
                                  Reserved2:byte;
                                  RootHubPortNumber:byte;
                                  end;
     Pusb_force_header_command_trb=^usb_force_header_command_trb;
     usb_get_extended_property_command_trb=bitpacked record
                                           Reserved1:0..15;
                                           ExtendedPropertyContextPointer:0..$FFFFFFFFFFFFFFF;
                                           ExtendedCapabilityIdentifier:word;
                                           Reserved2:word;
                                           CycleBit:0..1;
                                           Reserved3:0..511;
                                           TRBType:0..63;
                                           CommandSubType:0..7;
                                           EndPointID:0..31;
                                           SlotID:byte;
                                           end;
     Pusb_get_extended_property_command_trb=^usb_get_extended_property_command_trb;
     usb_set_extended_property_command_trb=bitpacked record
                                           Reserved1:array[1..2] of dword;
                                           ExtendedCapabilityIdentifier:word;
                                           CapabilityParameter:byte;
                                           Reserved2:byte;
                                           CycleBit:0..1;
                                           Reserved3:0..511;
                                           TRBType:0..63;
                                           CommandSubType:0..7;
                                           EndPointID:0..31;
                                           SlotID:byte;
                                           end;
     Pusb_set_extended_property_command_trb=^usb_set_extended_property_command_trb;
     {USB Other TRBs}
     usb_link_trb=bitpacked record
                  Reserved1:0..15;
                  RingSegmentPointer:0..$FFFFFFFFFFFFFFF;
                  Reserved2:0..4194303;
                  InterrupterTarget:0..1023;
                  CycleBit:0..1;
                  ToggleCycle:0..1;
                  Reserved3:0..3;
                  ChainBit:0..1;
                  InterruptOnCompletion:0..1;
                  Reserved4:0..15;
                  TRBType:0..63;
                  Reserved5:word;
                  end;
     Pusb_link_trb=^usb_link_trb;
     usb_event_data_trb=bitpacked record
                        EventPointer:qword;
                        Reserved1:0..4194303;
                        InterrupterTarget:0..1023;
                        CycleBit:0..1;
                        EvaluableNextTRB:0..1;
                        Reserved2:0..3;
                        ChainBit:0..1;
                        InterruptOnCompletion:0..1;
                        Reserved3:0..7;
                        BlockEventInterrupt:0..1;
                        TRBType:0..63;
                        Reserved4:word;
                        end;
     Pusb_event_data_trb=^usb_event_data_trb;
     {USB TRB}
     usb_trb=packed record
             case Byte of
             0:(Normal:usb_normal_trb;);
             1:(SetupStage:usb_setup_stage_trb;);
             2:(DataStage:usb_data_stage_trb;);
             3:(StatusStage:usb_status_stage_trb;);
             4:(Isoch:usb_isoch_trb;);
             5:(NoOp:usb_no_op_trb;);
             6:(TransferEvent:usb_transfer_event_trb;);
             7:(CommandCompletionEvent:usb_command_completion_event_trb;);
             8:(PortStatusChangeEvent:usb_port_status_change_event_trb;);
             9:(BandwidthRequestEvent:usb_bandwidth_request_event_trb;);
             10:(DoorBellEvent:usb_doorbell_event_trb;);
             11:(HostControllerEvent:usb_host_controller_event_trb;);
             12:(DeviceNotificationEvent:usb_device_notification_event_trb;);
             13:(MFIndexWrapEvent:usb_mfindex_wrap_event_trb;);
             14:(NoOpCommand:usb_no_op_command_trb;);
             15:(EnableSlotCommand:usb_enable_slot_command_trb;);
             16:(DisableSlotCommand:usb_disable_slot_command_trb;);
             17:(AddressDeviceCommand:usb_address_device_command_trb;);
             18:(ConfigureEndPointCommand:usb_configure_endpoint_command_trb;);
             19:(EvaluateContextCommand:usb_evaluate_context_command_trb;);
             20:(ResetEndpointCommand:usb_reset_endpoint_command_trb;);
             21:(StopEndPointCommand:usb_stop_endpoint_command_trb;);
             22:(SetTRDequeuePointerCommand:usb_set_tr_dequeue_pointer_command_trb;);
             23:(ResetDeviceCommand:usb_reset_device_command_trb;);
             24:(ForceEventCommand:usb_force_event_command_trb;);
             25:(NegotiateBandWidthCommand:usb_negotiate_bandwidth_command_trb;);
             26:(SetLatencyToleranceValueCommand:usb_set_latency_tolerance_value_Command_trb;);
             27:(GetPortBandwidthCommand:usb_get_port_bandwidth_command_trb;);
             28:(ForceHeaderCommand:usb_force_header_command_trb;);
             29:(GetExtendedPropertyCommand:usb_get_extended_property_command_trb;);
             30:(SetExtendedPropertyCommand:usb_set_extended_property_command_trb;);
             31:(Link:usb_link_trb;);
             32:(EventData:usb_event_data_trb;);
             end;
     Pusb_trb=^usb_trb;
     {USB Event Ring Segment Table}
     usb_event_ring_segment_table=bitpacked record
                                  Reserved1:0..63;
                                  RingSegmentAddressLow:0..67108863;
                                  RingSegmentAddressHigh:dword;
                                  RingSegmentSize:word;
                                  Reserved2:word;
                                  Reserved3:dword;
                                  end;
     Pusb_event_ring_segment_table=^usb_event_ring_segment_table;
     {USB Scratch Pad Buffer Array item}
     usb_scratch_pad_buffer_array_item=bitpacked record
                                       Reserved:0..4095;
                                       BaseAddress:0..$FFFFFFFFFFFFF;
                                       end;
     Pusb_scratch_pad_buffer_array_item=^usb_scratch_pad_buffer_array_item;
     {USB Host Controller Capacity Registers}
     usb_host_controller_structural_parameter_1=bitpacked record
                                                MaxDeviceSlots:byte;
                                                NumberOfInterrupters:0..2047;
                                                Reserved:0..31;
                                                NumberOfPorts:byte;
                                                end;
     usb_host_controller_structural_parameter_2=bitpacked record
                                                IsochronousSchedulingThreshold:0..15;
                                                EventRingSegmentTableIndex:0..15;
                                                Reserved:0..8191;
                                                MaxScratchpadBuffersHigh:0..31;
                                                ScratchpadRestore:0..1;
                                                MaxScratchpadBuffersLow:0..31;
                                                end;
     usb_host_controller_structural_parameter_3=packed record
                                                U1DeviceExitLatency:byte;
                                                Reserved:byte;
                                                U2DeviceExitLatency:word;
                                                end;
     usb_host_controller_capability_parameter_1=bitpacked record
                                                bit64AddressCapability:0..1;
                                                BWNegotiationCapability:0..1;
                                                ContextSize:0..1;
                                                PortPowerControl:0..1;
                                                PortIndicators:0..1;
                                                LightHCResetCapability:0..1;
                                                LatencyToleranceMessagingCapability:0..1;
                                                NoSecondarySIDSupport:0..1;
                                                ParseAllEventData:0..1;
                                                ShortPacketCapability:0..1;
                                                StoppedEDTLACapability:0..1;
                                                ContiguousFrameIDCapability:0..1;
                                                MaximumPrimaryStreamArraySize:0..15;
                                                xHCIExtendedCapabilitiesPointer:word;
                                                end;
     usb_host_controller_doorbell_offset=bitpacked record
                                         Reserved:0..3;
                                         DoorBellOffset:0..$3FFFFFFF;
                                         end;
     usb_host_controller_runtime_register_offset=bitpacked record
                                                 Reserved:0..32;
                                                 RuntimeRegisterSpaceOffset:0..$7FFFFFF;
                                                 end;
     usb_host_controller_capability_parameter_2=bitpacked record
                                                U3EntryCapability:0..1;
                                                ConfigureEndpointCommandMaxExitLatencyTooLargeCapability:0..1;
                                                ForceSaveContextCapability:0..1;
                                                ComplianceTransitionCapability:0..1;
                                                LargeESITPayloadCapability:0..1;
                                                ConfigurationInformationCapability:0..1;
                                                ExtendedTBCCapability:0..1;
                                                ExtendedTBCTRBStatusCapability:0..1;
                                                GetExtendedPropertyCapability:0..1;
                                                VirtualizationBasedTrustedIOCapability:0..1;
                                                Reserved:0..$3FFFFF;
                                                end;
     usb_host_controller_vtio_register_space_offset=bitpacked record
                                                    Reserved:0..4095;
                                                    VTIORegisterSpaceOffset:0..$FFFFF;
                                                    end;
     usb_host_controller_capability_registers=packed record
                                              CapabilityRegisterLength:byte;
                                              Reserved1:byte;
                                              InterfaceVersionNumber:word;
                                              StructuralParameter1:usb_host_controller_structural_parameter_1;
                                              StructuralParameter2:usb_host_controller_structural_parameter_2;
                                              StructuralParameter3:usb_host_controller_structural_parameter_3;
                                              CapabilityParameter1:usb_host_controller_capability_parameter_1;
                                              DoorBellOffset:usb_host_controller_doorbell_offset;
                                              RuntimeRegisterSpaceOffset:usb_host_controller_runtime_register_offset;
                                              CapabilityParameter2:usb_host_controller_capability_parameter_2;
                                              VTIORegisterSpaceOffset:usb_host_controller_vtio_register_space_offset;
                                              Reserved:array[1..1] of byte;
                                              end;
     Pusb_host_controller_capability_registers=^usb_host_controller_capability_registers;
     {USB Host Controller Operational Registers}
     usb_host_controller_port_register_set=packed record
                                           PortStatusAndControl:dword;
                                           PortPowerManagementStatusAndControl:dword;
                                           PortLinkInfo:dword;
                                           PortHardwareLPMControl:dword;
                                           end;
     usb_host_controller_command_register=bitpacked record
                                          RunOrStop:0..1;
                                          HostControllerReset:0..1;
                                          InterrupterEnable:0..1;
                                          HostSystemErrorEnable:0..1;
                                          Reserved1:0..7;
                                          LightHostControllerReset:0..1;
                                          ControllerSaveState:0..1;
                                          ControllerRestoreState:0..1;
                                          EnableWrapState:0..1;
                                          EnableU3MFINDEXStop:0..1;
                                          Reserved2:0..1;
                                          CEMEnable:0..1;
                                          ExtendedTBCEnable:0..1;
                                          ExtendedTBCTRBStatusEnable:0..1;
                                          VTIOEnable:0..1;
                                          Reserved3:0..32767;
                                          end;
     usb_host_controller_status_register=bitpacked record
                                         HCHalted:0..1;
                                         Reserved1:0..1;
                                         HostSystemError:0..1;
                                         EventInterrupt:0..1;
                                         PortChangeDetect:0..1;
                                         Reserved2:0..7;
                                         SaveStateStatus:0..1;
                                         RestoreStateStatus:0..1;
                                         SaveRestoreError:0..1;
                                         ControllerNotReady:0..1;
                                         HostControllerError:0..1;
                                         Reserved:0..524287;
                                         end;
     usb_host_controller_page_size=packed record
                                   pagesize:word;
                                   Reserved:word;
                                   end;
     usb_host_controller_device_notification_control_register=packed record
                                                              N:word;
                                                              Reserved:word;
                                                              end;
     usb_host_controller_command_ring_control_register=bitpacked record
                                                       RingCycleStatus:0..1;
                                                       CommandStop:0..1;
                                                       CommandAbort:0..1;
                                                       CommandRingRunning:0..1;
                                                       Reserved1:0..3;
                                                       CommandRingPointer:0..$3FFFFFFFFFFFFFF;
                                                       end;
     usb_host_controller_device_context_base_address_pointer_register=bitpacked record
                                                                      Reserved:0..63;
                                                                      DeviceContextBaseAddressPointerRegister:0..$3FFFFFFFFFFFFFF;
                                                                      end;
     usb_host_controller_configure_register=bitpacked record
                                            MaxDeviceSlotsEnabled:byte;
                                            U3EntryEnable:0..1;
                                            ConfigurationInformationEnable:0..1;
                                            Reserved:0..$3FFFFF;
                                            end;
     usb_host_controller_operational_registers=packed record
                                               USBCommand:usb_host_controller_command_register;
                                               USBStatus:usb_host_controller_status_register;
                                               PageSize:usb_host_controller_page_size;
                                               Reserved1:qword;
                                               DeviceNotificationControl:usb_host_controller_device_notification_control_register;
                                               CommandRingControl:usb_host_controller_command_ring_control_register;
                                               Reserved2:array[1..2] of qword;
                                               DeviceContextBaseAddressArrayPointer:usb_host_controller_device_context_base_address_pointer_register;
                                               Configure:usb_host_controller_configure_register;
                                               Reserved3:array[1..984] of qword;
                                               PortRegisterSet:array[1..256] of usb_host_controller_port_register_set;
                                               end;
     Pusb_host_controller_operational_registers=^usb_host_controller_operational_registers;
     {USB Host Controller Runtime Registers}
     usb_host_controller_microframe_index_register=bitpacked record
                                                   MicroFrameIndex:0..16383;
                                                   Reserved:0..$3FFFF;
                                                   end;
     usb_host_controller_interrupt_register=bitpacked record
                                            InterruptPending:0..1;
                                            InterruptEnable:0..1;
                                            Reserved1:0..$3FFFFFFF;
                                            InterruptModerationInterval:word;
                                            InterruptModerationCounter:word;
                                            EventRingSegmentTableSize:word;
                                            Reserved2:word;
                                            Reserved3:0..63;
                                            EventRingSegmentTableBaseAddressRegister:0..$3FFFFFFFFFFFFFF;
                                            DequeueERSTSegmentIndex:0..7;
                                            EventHandlerBusy:0..1;
                                            EventRingDequeuePointer:0..$FFFFFFFFFFFFFFF;
                                            end;
     usb_host_controller_runtime_registers=packed record
                                           MFIndex:usb_host_controller_microframe_index_register;
                                           Reserved:array[1..3] of dword;
                                           InterruptRegisterSet:array[1..1024] of usb_host_controller_interrupt_register;
                                           end;
     Pusb_host_controller_runtime_registers=^usb_host_controller_runtime_registers;
     usb_host_controller_doorbell_registers=packed record
                                            DBTarget:byte;
                                            Reserved:byte;
                                            DBTaskID:byte;
                                            end;
     Pusb_host_controller_doorbell_registers=^usb_host_controller_doorbell_registers;
     {USB VTIO Registers}
     usb_host_controller_vtio_capability_register=packed record
                                                  PrimaryDMAID:word;
                                                  AlternateDMAID:word;
                                                  end;
     usb_host_controller_vtio_common_assignment_register=packed record
                                                         Reserved1:0..1;
                                                         CommandRingDMAIDAssignment:0..1;
                                                         DeviceContextBaseAddressArrayDMAIDAssignment:0..1;
                                                         ScratchPadBufferArrayDMAIDAssignment:0..1;
                                                         ScratchPadBufferDMAIDAssignment:0..1;
                                                         Reserved2:0..1;
                                                         InputContextDMAIDAssignment:0..1;
                                                         MSIDMAIDAssignment:0..1;
                                                         PortBandwidthContextDMAIDAssignment:0..1;
                                                         DebugCapabilityDMAIDAssignment:0..1;
                                                         ExtendedPropertyContextDMAIDAssignment:0..1;
                                                         Reserved3:0..$1FFFFF;
                                                         end;
     usb_host_controller_vtio_device_assignment_register=packed record
                                                         Reserved:0..1;
                                                         MaxslotLow:0..$7FFFFFFFFFFFFFFF;
                                                         MaxslotHigh:qword;
                                                         end;
     usb_host_controller_vtio_interrupter_assignment_register=packed record
                                                              Interrupter:array[1..256] of dword;
                                                              end;
     usb_host_controller_vtio_endpointer_register=packed record
                                                  EndpointContextDMAIDAssignment:dword;
                                                  end;
     {USB Device Descriptor}
     usb_device_descriptor=packed record
                           Length:byte;
                           DescriptorType:byte;
                           Version:word;
                           DeviceClass:byte;
                           DeviceSubClass:byte;
                           DeviceProtocol:byte;
                           MaxPacketSize:byte;
                           VendorID:word;
                           ProductID:word;
                           Device:word;
                           Manufracturer:byte;
                           Product:byte;
                           SerialNumber:byte;
                           NumberOfConfigurations:byte;
                           end;
     Pusb_device_descriptor=^usb_device_descriptor;
     {USB Object}
     usb_object=packed record
                CapAddr:Pusb_host_controller_capability_registers;
                OpeAddr:Pusb_host_controller_operational_registers;
                RunAddr:Pusb_host_controller_runtime_registers;
                DoorAddr:Pusb_host_controller_doorbell_registers;
                CmdAddr:Pusb_trb;
                CmdCount:word;
                DevAddr:Pusb_device_context_base_address_array;
                DevCount:word;
                end;
     Pusb_object=^usb_object;

      {USB Endpoint Status}
const usb_endpoint_disabled=0;
      usb_endpoint_running=1;
      usb_endpoint_halted=2;
      usb_endpoint_stopped=3;
      usb_endpoint_error=4;
      {USB TRB Completion code Status}
      usb_trb_completion_code_invaild=0;
      usb_trb_completion_code_success=1;
      usb_trb_completion_code_data_buffer_error=2;
      usb_trb_completion_code_babble_detected_error=3;
      usb_trb_completion_code_usb_transaction_error=4;
      usb_trb_completion_code_trb_error=5;
      usb_trb_completion_code_stall_error=6;
      usb_trb_completion_code_resource_error=7;
      usb_trb_completion_code_bandwidth_error=8;
      usb_trb_completion_code_no_slots_available_error=9;
      usb_trb_completion_code_invaild_stream_type_error=10;
      usb_trb_completion_code_slot_not_enabled_error=11;
      usb_trb_completion_code_endpoint_not_enabled_error=12;
      usb_trb_completion_code_short_packet=13;
      usb_trb_completion_code_ring_underrun=14;
      usb_trb_completion_code_ring_overrun=15;
      usb_trb_completion_code_VF_Event_Ring_Full_Error=16;
      usb_trb_completion_code_parameter_error=17;
      usb_trb_completion_code_bandwidth_overrun_error=18;
      usb_trb_completion_code_context_state_error=19;
      usb_trb_completion_code_no_ping_response_error=20;
      usb_trb_completion_code_event_ring_full_error=21;
      usb_trb_completion_code_incompatible_device_error=22;
      usb_trb_completion_code_missed_service_error=23;
      usb_trb_completion_code_command_ring_stopped=24;
      usb_trb_completion_code_command_aborted=25;
      usb_trb_completion_code_stopped=26;
      usb_trb_completion_code_stopped_length_invaild=27;
      usb_trb_completion_code_stopped_short_packet=28;
      usb_trb_completion_code_max_exit_latency_too_large_error=29;
      usb_trb_completion_code_reserved=30;
      usb_trb_completion_code_isoch_buffer_overrun=31;
      usb_trb_completion_code_event_lost_error=32;
      usb_trb_completion_code_undefined_error=33;
      usb_trb_completion_code_invaild_stream_id_error=34;
      usb_trb_completion_code_secondary_bandwidth_error=35;
      usb_trb_completion_code_split_transaction_error=36;
      usb_trb_completion_code_vendor_defined_error_low=192;
      usb_trb_completion_code_vendor_defined_error_high=223;
      usb_trb_completion_code_vendor_defined_info_low=224;
      usb_trb_completion_code_vendor_defined_info_high=255;
      {USB TRB Type}
      usb_trb_type_reserved=0;
      usb_trb_type_normal=1;
      usb_trb_setup_stage=2;
      usb_trb_data_stage=3;
      usb_trb_status_stage=4;
      usb_trb_isoch=5;
      usb_trb_link=6;
      usb_trb_event_data=7;
      usb_trb_no_op=8;
      usb_trb_enable_slot_command=9;
      usb_trb_disable_slot_command=10;
      usb_trb_address_device_command=11;
      usb_trb_configure_endpoint_command=12;
      usb_trb_evaluate_context_command=13;
      usb_trb_reset_endpoint_command=14;
      usb_trb_stop_endpoint_command=15;
      usb_trb_set_tr_dequeue_pointer_command=16;
      usb_trb_reset_device_command=17;
      usb_trb_force_event_command=18;
      usb_trb_negotiate_bandwidth_command=19;
      usb_trb_set_latency_tolerance_value_command=20;
      usb_trb_get_port_bandwidth_command=21;
      usb_trb_force_header_command=22;
      usb_trb_no_op_command=23;
      usb_trb_get_extended_property_command=24;
      usb_trb_set_extended_property_command=25;
      usb_trb_reserved2_low=26;
      usb_trb_reserved2_high=31;
      usb_trb_transfer_event=32;
      usb_trb_command_completion_event=33;
      usb_trb_port_status_change_event=34;
      usb_trb_bandwidth_request_event=35;
      usb_trb_doorbell_event=36;
      usb_trb_host_controller_event=37;
      usb_trb_device_notification_event=38;
      usb_trb_MFindex_wrap_event=39;
      usb_trb_reserved3_low=40;
      usb_trb_reserved3_high=47;
      usb_trb_vendor_defined=48;
      {USB Slot State}
      usb_slot_state_disable_or_enable=0;
      usb_slot_state_default=1;
      usb_slot_state_addressed=2;
      usb_slot_state_configured=3;
      usb_slot_state_reserved=4;

function usb_initialize(ptr:Pointer):Pusb_object;
procedure usb_send_packet(obj:Pusb_object;mainindex,subindex:word;index:byte;const data:Pointer;datasize:word);
procedure usb_receive_packet(obj:Pusb_object;mainindex,subindex:word;index:byte;data:Pointer;datasize:word);

implementation

function usb_initialize(ptr:Pointer):Pusb_object;
var capaddr:Pusb_host_controller_capability_registers;
    opeaddr:Pusb_host_controller_operational_registers;
    Runaddr:Pusb_host_controller_runtime_registers;
    DoorAddr:Pusb_host_controller_doorbell_registers;
    CommandAddr:Pusb_trb;
    DeviceAddr:Pusb_device_context_base_address_array;
    DeviceContextAddr:Pointer;
    DeviceCount:byte;
    ICAddr:Pointer;
    EventSegmentTable:Pusb_event_ring_segment_table;
    EventTRB:Pusb_trb;
    res:Pusb_object;
    i,j,k:word;
    bool:boolean;
begin
 {Setting the Address of Registers in MMIO}
 capaddr:=ptr;
 opeaddr:=ptr+capaddr^.CapabilityRegisterLength;
 RunAddr:=ptr+capaddr^.RuntimeRegisterSpaceOffset.RuntimeRegisterSpaceOffset;
 DoorAddr:=ptr+capaddr^.DoorBellOffset.DoorBellOffset;
 {Reset the USB object}
 opeaddr^.USBCommand.HostControllerReset:=1;
 opeaddr^.USBCommand.RunOrStop:=1;
 while(opeaddr^.USBCommand.RunOrStop=1)do;
 {Set the Device Context Data}
 DeviceCount:=opeaddr^.Configure.MaxDeviceSlotsEnabled;
 DeviceAddr:=allocmem(sizeof(usb_device_context_base_address_element0)+
 DeviceCount*sizeof(usb_device_context_base_address_element));
 opeaddr^.DeviceContextBaseAddressArrayPointer.DeviceContextBaseAddressPointerRegister:=Natuint(DeviceAddr);
 {Set Configure Information acquision}
 opeaddr^.Configure.ConfigurationInformationEnable:=1;
 {Initialize the Command}
 CommandAddr:=allocmem($1000);
 opeaddr^.CommandRingControl.CommandRingPointer:=Natuint(CommandAddr);
 opeaddr^.CommandRingControl.Reserved1:=0;
 {Enable Device in best efforts}
 k:=1;
 for i:=1 to DeviceCount do
  begin
   {Set the Command Ring Data}
   Pusb_trb(CommandAddr)^.EnableSlotCommand.CycleBit:=1;
   Pusb_trb(CommandAddr)^.EnableSlotCommand.SlotType:=0;
   Pusb_trb(CommandAddr)^.EnableSlotCommand.TRBType:=usb_trb_enable_slot_command;
   Pusb_trb(CommandAddr+1)^.AddressDeviceCommand.CycleBit:=1;
   Pusb_trb(CommandAddr+1)^.AddressDeviceCommand.BlockSetAddressRequest:=1;
   Pusb_trb(CommandAddr+1)^.AddressDeviceCommand.TRBType:=usb_trb_address_device_command;
   Pusb_trb(CommandAddr+1)^.AddressDeviceCommand.SlotId:=0;
   Pusb_trb(CommandAddr+1)^.AddressDeviceCommand.InputContextPointer:=0;
   Pusb_trb(CommandAddr+2)^.Link.CycleBit:=1;
   Pusb_trb(CommandAddr+2)^.Link.ChainBit:=0;
   Pusb_trb(CommandAddr+2)^.Link.TRBType:=usb_trb_link;
   Pusb_trb(CommandAddr+2)^.Link.RingSegmentPointer:=Natuint(CommandAddr);
   {Running the command when initializing}
   opeaddr^.USBCommand.RunOrStop:=1;
   while(opeaddr^.USBCommand.RunOrStop=1)do;
   {Scan the interrupt for Completion Code}
   j:=1;
   while(j<=1024)do
    begin
     EventSegmentTable:=Pointer(RunAddr^.InterruptRegisterSet[j].EventRingSegmentTableBaseAddressRegister);
     EventTRB:=Pointer(Natuint(EventSegmentTable^.RingSegmentAddressHigh) shl 28+EventSegmentTable^.RingSegmentAddressLow);
     if(EventTRB^.Link.TRBType=usb_trb_command_completion_event) then
      begin
       DeviceAddr^.element[k].DeviceContextBaseAddress:=EventTRB^.CommandCompletionEvent.CommandTRBPointer;
       inc(k); break;
      end;
     inc(j);
    end;
  end;
 {Generate the USB object}
 res:=allocmem(sizeof(usb_object));
 res^.CapAddr:=capaddr; res^.OpeAddr:=opeaddr; res^.RunAddr:=RunAddr; res^.DoorAddr:=DoorAddr;
 res^.CmdAddr:=CommandAddr; res^.DevCount:=DeviceCount; res^.DevAddr:=DeviceAddr; res^.CmdCount:=0;
 {Return the USB object}
 usb_initialize:=res;
end;
procedure usb_run_command(obj:Pusb_object);
begin
 {Set to 1 to run the command}
 obj^.OpeAddr^.USBCommand.RunOrStop:=1;
 {Wait for command complete}
 while(obj^.OpeAddr^.USBCommand.RunOrStop=1)do;
end;
procedure usb_add_command(obj:Pusb_object;trb:usb_trb);
begin
 {If the command trb is full,do not add it}
 if(obj^.CmdCount>=256) then exit;
 {Add the trb to command trb queue}
 inc(obj^.CmdCount);
 (obj^.CmdAddr+obj^.CmdCount-1)^:=trb;
end;
procedure usb_add_transfer_ring(obj:Pusb_object;mainindex,subindex:word;index:word;trb:usb_trb);
var ptr:Pusb_context;
begin
 ptr:=Pointer(obj^.DevAddr^.element[mainindex].DeviceContextBaseAddress+$20+subindex shl 5);
 ptr^.EndPoint.TRDequeuePointer:=index;
 Pusb_trb(ptr^.EndPoint.TRDequeuePointer)^:=trb;
 ptr^.EndPoint.TRDequeuePointer:=index+$10;
end;
procedure usb_send_packet(obj:Pusb_object;mainindex,subindex:word;index:byte;const data:Pointer;datasize:word);
var trb:usb_trb;
begin
 {Set the Setup Stage}
 trb.SetupStage.BmRequestType:=0;
 trb.SetupStage.BRequest:=0;
 trb.SetupStage.WValue:=0;
 trb.SetupStage.WIndex:=index;
 trb.SetupStage.WLength:=0;
 trb.SetupStage.TRBTransferLength:=8;
 trb.SetupStage.InterruptTarget:=mainindex shl 2-4;
 trb.SetupStage.Reserved1:=0;
 trb.SetupStage.Reserved2:=0;
 trb.SetupStage.Reserved3:=0;
 trb.SetupStage.Reserved4:=0;
 trb.SetupStage.InterruptOnCompletion:=1;
 trb.SetupStage.TRBType:=usb_trb_setup_stage;
 trb.SetupStage.TransferType:=2;
 trb.SetupStage.CycleBit:=1;
 usb_add_transfer_ring(obj,mainindex,subindex,1,trb);
 {Set the Status Stage}
 trb.DataStage.CycleBit:=1;
 trb.DataStage.DataBuffer:=Natuint(data);
 trb.DataStage.EvaluateNextTRB:=1;
 trb.DataStage.Reserved1:=0;
 trb.DataStage.Reserved2:=0;
 trb.DataStage.TRBTransferLength:=datasize;
 trb.DataStage.TRBType:=usb_trb_data_stage;
 trb.DataStage.ChainBit:=1;
 trb.DataStage.NoSnoop:=0;
 trb.DataStage.InterruptTarget:=mainindex shl 2-3;
 trb.DataStage.TDSize:=16;
 trb.DataStage.ImmediateData:=1;
 trb.DataStage.Direction:=1;
 trb.DataStage.InterruptOnShortPacket:=1;
 trb.DataStage.InterruptOnCompletion:=1;
 usb_add_transfer_ring(obj,mainindex,subindex,2,trb);
 {Set the Status Stage}
 trb.StatusStage.CycleBit:=1;
 trb.StatusStage.ChainBit:=0;
 trb.StatusStage.Direction:=1;
 trb.StatusStage.EvaluateNextTRB:=0;
 trb.StatusStage.TRBType:=usb_trb_status_stage;
 trb.StatusStage.InterruptOnCompletion:=1;
 trb.StatusStage.Reserved:=0;
 trb.StatusStage.Reserved1:=0;
 trb.StatusStage.Reserved2:=0;
 trb.StatusStage.Reserved3:=0;
 trb.StatusStage.Reserved4:=0;
 usb_add_transfer_ring(obj,mainindex,subindex,3,trb);
 usb_run_command(obj);
end;
procedure usb_receive_packet(obj:Pusb_object;mainindex,subindex:word;index:byte;data:Pointer;datasize:word);
var trb:usb_trb;
begin
 {Set the Setup Stage}
 trb.SetupStage.BmRequestType:=1 shl 7;
 trb.SetupStage.BRequest:=0;
 trb.SetupStage.WValue:=0;
 trb.SetupStage.WIndex:=index;
 trb.SetupStage.WLength:=0;
 trb.SetupStage.TRBTransferLength:=8;
 trb.SetupStage.InterruptTarget:=mainindex shl 2-4;
 trb.SetupStage.Reserved1:=0;
 trb.SetupStage.Reserved2:=0;
 trb.SetupStage.Reserved3:=0;
 trb.SetupStage.Reserved4:=0;
 trb.SetupStage.InterruptOnCompletion:=1;
 trb.SetupStage.TRBType:=usb_trb_setup_stage;
 trb.SetupStage.TransferType:=2;
 trb.SetupStage.CycleBit:=1;
 usb_add_transfer_ring(obj,mainindex,subindex,1,trb);
 {Set the Status Stage}
 trb.DataStage.CycleBit:=1;
 trb.DataStage.DataBuffer:=Natuint(data);
 trb.DataStage.EvaluateNextTRB:=1;
 trb.DataStage.Reserved1:=0;
 trb.DataStage.Reserved2:=0;
 trb.DataStage.TRBTransferLength:=datasize;
 trb.DataStage.TRBType:=usb_trb_data_stage;
 trb.DataStage.ChainBit:=1;
 trb.DataStage.NoSnoop:=0;
 trb.DataStage.InterruptTarget:=mainindex shl 2-3;
 trb.DataStage.TDSize:=16;
 trb.DataStage.ImmediateData:=1;
 trb.DataStage.Direction:=0;
 trb.DataStage.InterruptOnShortPacket:=1;
 trb.DataStage.InterruptOnCompletion:=1;
 usb_add_transfer_ring(obj,mainindex,subindex,2,trb);
 {Set the Status Stage}
 trb.StatusStage.CycleBit:=1;
 trb.StatusStage.ChainBit:=0;
 trb.StatusStage.Direction:=0;
 trb.StatusStage.EvaluateNextTRB:=0;
 trb.StatusStage.TRBType:=usb_trb_status_stage;
 trb.StatusStage.InterruptOnCompletion:=1;
 trb.StatusStage.Reserved:=0;
 trb.StatusStage.Reserved1:=0;
 trb.StatusStage.Reserved2:=0;
 trb.StatusStage.Reserved3:=0;
 trb.StatusStage.Reserved4:=0;
 usb_add_transfer_ring(obj,mainindex,subindex,3,trb);
 usb_run_command(obj);
end;

end.
