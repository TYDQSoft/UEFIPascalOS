unit kernelbase;

interface

type x86_gdt_descriptor=packed record
                        Size:word;
                        Offset:dword;
                        end;
     Px86_gdt_descriptor=^x86_gdt_descriptor;
     x64_gdt_descriptor=packed record
                        Size:word;
                        Offset:qword;
                        end;
     Px64_gdt_descriptor=^x64_gdt_descriptor;
     ia_gdt_access_byte_normal=bitpacked record
                               Accessed:0..1;
                               EnableReadOrWrite:0..1;
                               EnableDirectionOrConfirming:0..1;
                               Executable:0..1;
                               DescriptorType:0..1;
                               DescriptorPrivilageLevel:0..3;
                               Present:0..1;
                               end;
     ia_gdt_access_byte_special=bitpacked record
                                GDTType:0..15;
                                DescriptorType:0..1;
                                DescriptorPrivilageLevel:0..3;
                                Present:0..1;
                                end;
     ia_gdt_access_byte=packed record
                        case Boolean of
                        True:(accessbytenormal:ia_gdt_access_byte_normal;);
                        False:(accessbytespecial:ia_gdt_access_byte_special;);
                        end;
     x86_gdt_descriptor_gate=bitpacked record
                             limitlow:word;
                             baselow:word;
                             basemid:byte;
                             AccessByte:ia_gdt_access_byte;
                             Limithigh:0..15;
                             Flags:0..15;
                             Basehigh:byte;
                             end;
     Px86_gdt_descriptor_gate=^x86_gdt_descriptor_gate;
     x64_gdt_descriptor_gate=bitpacked record
                             limitlow:word;
                             baselow:word;
                             basemid:byte;
                             AccessByte:ia_gdt_access_byte;
                             Limithigh:0..15;
                             Flags:0..15;
                             Basehigh1:byte;
                             Basehigh2:dword;
                             Reserved:dword;
                             end;
     Px64_gdt_descriptor_gate=^x64_gdt_descriptor_gate;
     x86_idt_descriptor=packed record
                        Size:word;
                        Offset:dword;
                        end;
     Px86_idt_descriptor=^x86_idt_descriptor;
     x64_idt_descriptor=packed record
                        Size:word;
                        Offset:qword;
                        end;
     Px64_idt_descriptor=^x64_idt_descriptor;
     ia_segment_descriptor=bitpacked record
                           RequestPrivilegeLevel:0..3;
                           TableIndicator:0..1;
                           Index:0..8191;
                           end;
     x86_idt_descriptor_gate=bitpacked record
                             offsetlow:word;
                             SegmentSelector:ia_segment_descriptor;
                             Reserved1:byte;
                             GateType:0..15;
                             Reserved2:0..1;
                             DescriptorPrivilegeLevel:0..3;
                             Present:0..1;
                             offsethigh:word;
                             end;
     Px86_idt_descriptor_gate=^x86_idt_descriptor_gate;
     x64_idt_descriptor_gate=bitpacked record
                             offsetlow:word;
                             SegmentSelector:ia_segment_descriptor;
                             IST:0..7;
                             Reserved1:0..31;
                             GateType:0..15;
                             Reserved2:0..1;
                             DescriptorPrivilegeLevel:0..3;
                             Present:0..1;
                             offsetmiddle:word;
                             offsethigh:dword;
                             Reserved3:dword;
                             end;
     Px64_idt_descriptor_gate=^x64_idt_descriptor_gate;
     kernel_handler_function_execute=function(param:Pointer):Pointer;
     kernel_handler_function=packed record
                             func:kernel_handler_function_execute;
                             funcparam:Pointer;
                             funcparamsize:natuint;
                             funcresult:Pointer;
                             end;

const kernel_i386:byte=0;
      kernel_x86_64:byte=1;
      kernel_ia64:byte=2;
      kernel_arm:byte=3;
      kernel_arm64:byte=4;
      kernel_riscv32:byte=5;
      kernel_riscv64:byte=6;
      kernel_loongarch32:byte=7;
      kernel_loongarch64:byte=8;
      kernel_ia_ring0:byte=0;
      kernel_ia_ring1:byte=1;
      kernel_ia_ring2:byte=2;
      kernel_ia_ring3:byte=3;

var hfunc:kernel_handler_function;

{$IF Defined(cpui386)}
var gdt:x86_gdt_descriptor;
    gdtentry:array[1..5] of x86_gdt_descriptor_gate;
    idt:x86_idt_descriptor;
    idtentry:array[1..256] of x86_idt_descriptor_gate;
{$ELSEIF Defined(cpux86_64) or Defined(cpuia64)}
var gdt:x64_gdt_descriptor;
    gdtentry:array[1..5] of x64_gdt_descriptor_gate;
    idt:x64_idt_descriptor;
    idtentry:array[1..256] of x64_idt_descriptor_gate;
{$ENDIF}

function kernel_get_architecture:byte;
procedure kernel_handle_function_init(func:kernel_handler_function_execute);
procedure kernel_handle_function_add_param(newparam:sys_variant);
procedure kernel_handle_function_free;
procedure kernel_initialize;

implementation

procedure kernel_handle_function_init(func:kernel_handler_function_execute);
begin
 hfunc.func:=func;
 hfunc.funcparam:=nil;
 hfunc.funcparamsize:=0;
 hfunc.funcresult:=nil;
end;
procedure kernel_handle_function_add_param(newparam:sys_variant);
begin
 if(newparam.vartype=sys_variant_type_natint) then
  begin
   ReallocMem(hfunc.funcparam,hfunc.funcparamsize+sizeof(natint));
   PNatint(hfunc.funcparam+hfunc.funcparamsize)^:=newparam.varnatint;
   inc(hfunc.funcparamsize,sizeof(natint));
  end
 else if(newparam.vartype=sys_variant_type_natuint) then
  begin
   ReallocMem(hfunc.funcparam,hfunc.funcparamsize+sizeof(natuint));
   PNatint(hfunc.funcparam+hfunc.funcparamsize)^:=newparam.varnatuint;
   inc(hfunc.funcparamsize,sizeof(natuint));
  end
 else if(newparam.vartype=sys_variant_type_extended) then
  begin
   ReallocMem(hfunc.funcparam,hfunc.funcparamsize+sizeof(extended));
   Pextended(hfunc.funcparam+hfunc.funcparamsize)^:=newparam.varextended;
   inc(hfunc.funcparamsize,sizeof(extended));
  end
 else if(newparam.vartype=sys_variant_type_pointer) then
  begin
   ReallocMem(hfunc.funcparam,hfunc.funcparamsize+sizeof(pointer));
   PPointer(hfunc.funcparam+hfunc.funcparamsize)^:=newparam.varpointer;
   inc(hfunc.funcparamsize,sizeof(pointer));
  end;
end;
procedure kernel_handle_function_execute_function;
begin
 hfunc.funcresult:=hfunc.func(hfunc.funcparam);
end;
function kernel_handle_function_get_result:Pointer;
begin
 kernel_handle_function_get_result:=hfunc.funcresult;
end;
procedure kernel_handle_function_free;
begin
 FreeMem(hfunc.funcparam); FreeMem(hfunc.funcresult);
 hfunc.funcparamsize:=0;
end;
function kernel_timer(param:Pointer):Pointer;
begin

end;
function kernel_get_architecture:byte;
begin
 {$IF Defined(cpui386)}
 kernel_get_architecture:=kernel_i386;
 {$ELSEIF Defined(cpux86_64)}
 kernel_get_architecture:=kernel_x86_64;
 {$ELSEIF Defined(cpuia64)}
 kernel_get_architecture:=kernel_ia64;
 {$ELSEIF Defined(cpuarm)}
 kernel_get_architecture:=kernel_arm;
 {$ELSEIF Defined(cpuaarch64)}
 kernel_get_architecture:=kernel_arm64;
 {$ELSEIF Defined(cpuriscv32)}
 kernel_get_architecture:=kernel_riscv32;
 {$ELSEIF Defined(cpuriscv64)}
 kernel_get_architecture:=kernel_riscv64;
 {$ELSEIF Defined(cpuloongarch32)}
 kernel_get_architecture:=kernel_loongarch32;
 {$ELSEIF Defined(cpuloongarch64)}
 kernel_get_architecture:=kernel_loongarch64;
 {$ENDIF}
end;
{$IF Defined(cpui386)}
procedure kernel_idt_handler_empty;
begin
 
end;
procedure kernel_idt_handler_division_by_zero;
begin
 
end;
procedure kernel_idt_handler_debug_exception;
begin
 
end;
procedure kernel_idt_handler_NMI_Interrupt;
begin
 
end;
procedure kernel_idt_handler_BreakPoint;
begin
 
end;
procedure kernel_idt_handler_OverFlow;
begin
 
end;
procedure kernel_idt_handler_Bound_Range_Exceed;
begin
 
end;
procedure kernel_idt_handler_Invaild_Opcode;
begin
 
end;
procedure kernel_idt_handler_Device_Not_Available;
begin
 
end;
procedure kernel_idt_handler_Double_Fault;
begin
 
end;
procedure kernel_idt_handler_Coprocessor_Segment_overrun;
begin
 
end;
procedure kernel_idt_handler_Invaild_TSS;
begin
 
end;
procedure kernel_idt_handler_Segment_Not_Present;
begin
 
end;
procedure kernel_idt_handler_Stack_Segment_Fault;
begin
 
end;
procedure kernel_idt_handler_General_Protection;
begin
 
end;
procedure kernel_idt_handler_Page_Fault;
begin
 
end;
procedure kernel_idt_handler_FPU_Math_Error;
begin
 
end;
procedure kernel_idt_handler_Alignment_Check;
begin
 
end;
procedure kernel_idt_handler_Machine_check;
begin
 
end;
procedure kernel_idt_handler_SIMD_Floating_Point;
begin
 
end;
procedure kernel_idt_handler_Virtualization_Exception;
begin
 
end;
{$ELSEIF Defined(cpux86_64) or Defined(cpuia64)}
procedure kernel_idt_handler_empty;
begin
end;
procedure kernel_idt_handler_division_by_zero;assembler;
asm
 hlt
end;
procedure kernel_idt_handler_debug_exception;
begin
end;
procedure kernel_idt_handler_NMI_Interrupt;
begin
end;
procedure kernel_idt_handler_BreakPoint;
begin
end;
procedure kernel_idt_handler_OverFlow;
begin
end;
procedure kernel_idt_handler_Bound_Range_Exceed;
begin
end;
procedure kernel_idt_handler_Invaild_Opcode;
begin
end;
procedure kernel_idt_handler_Device_Not_Available;
begin
end;
procedure kernel_idt_handler_Double_Fault;
begin
end;
procedure kernel_idt_handler_Coprocessor_Segment_overrun;
begin
end;
procedure kernel_idt_handler_Invaild_TSS;
begin
end;
procedure kernel_idt_handler_Segment_Not_Present;
begin
end;
procedure kernel_idt_handler_Stack_Segment_Fault;
begin
end;
procedure kernel_idt_handler_General_Protection;
begin
end;
procedure kernel_idt_handler_Page_Fault;
begin
end;
procedure kernel_idt_handler_FPU_Math_Error;
begin
end;
procedure kernel_idt_handler_Alignment_Check;
begin
end;
procedure kernel_idt_handler_Machine_check;
begin
end;
procedure kernel_idt_handler_SIMD_Floating_Point;
begin
end;
procedure kernel_idt_handler_Virtualization_Exception;
begin
end;
//call kernel_handle_function_execute_function
procedure kernel_idt_handler_timer;assembler;
asm
 iretq
end;
{$ENDIF}
{$IF Defined(cpui386)}
procedure kernel_gdt_set_entry(index:word;Base:dword;Limit:dword;AccessByte:byte;Flags:byte);
begin
 PByte(@gdtentry[index].AccessByte)^:=AccessByte;
 gdtentry[index].baselow:=base and $FFFF;
 gdtentry[index].basemid:=(base shr 16) and $FF;
 gdtentry[index].basehigh:=(base shr 24) and $FF;
 gdtentry[index].Flags:=Flags;
 gdtentry[index].limitlow:=Limit and $FFFF;
 gdtentry[index].Limithigh:=(Limit shr 16) and $F;
 gdtentry[index].Reserved:=0;
end;
procedure kernel_idt_set_entry(index:word;address:dword;GateType:byte;PrivilegeLevel:byte);
begin
 idtentry[index].DescriptorPrivilegeLevel:=PrivilegeLevel;
 idtentry[index].Present:=1;
 idtentry[index].SegmentSelector.Index:=1;
 idtentry[index].SegmentSelector.TableIndicator:=0;
 idtentry[index].SegmentSelector.RequestPrivilegeLevel:=0;
 idtentry[index].GateType:=GateType;
 idtentry[index].offsetlow:=address and $FFFF;
 idtentry[index].offsethigh:=(address shr 16) and $FFFF;
 idtentry[index].Reserved1:=0;
 idtentry[index].Reserved2:=0;
 if(address=0) then idtentry[index].Present:=0 else idtentry[index].Present:=1;
end;
procedure kernel_gdt_initialize;
var tempptr:Px86_gdt_descriptor;
begin
 gdt.Offset:=dword(@gdtentry);
 gdt.Size:=sizeof(gdtentry)-1;
 kernel_gdt_set_entry(1,0,0,$0,$0);
 kernel_gdt_set_entry(2,0,$FFFFF,$9A,$A);
 kernel_gdt_set_entry(3,0,$FFFFF,$92,$C);
 kernel_gdt_set_entry(4,0,$FFFFF,$FA,$A);
 kernel_gdt_set_entry(5,0,$FFFFF,$F2,$C);
 tempptr:=@gdt;
 asm
  lgdt tempptr
 end;
end;
procedure kernel_idt_initialize;
var i:word;
    tempptr:Px86_idt_descriptor;
begin
 idt.Offset:=dword(@idtentry);
 idt.Size:=sizeof(idtentry)-1;
 i:=1;
 while(i<=256)do
  begin
   case i of
   1:kernel_idt_set_entry(i,dword(@kernel_idt_handler_division_by_zero),$E,0);
   2:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Debug_exception),$F,0);
   3:kernel_idt_set_entry(i,dword(@kernel_idt_handler_NMI_interrupt),$E,0);
   4:kernel_idt_set_entry(i,dword(@kernel_idt_handler_breakpoint),$F,0);
   5:kernel_idt_set_entry(i,dword(@kernel_idt_handler_overflow),$F,0);
   6:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Bound_Range_exceed),$E,0);
   7:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Invaild_Opcode),$E,0);
   8:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Device_Not_Available),$E,0);
   9:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Double_Fault),$E,0);
   10:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Coprocessor_Segment_overrun),$E,0);
   11:kernel_idt_set_entry(i,dword(@kernel_idt_handler_invaild_TSS),$E,0);
   12:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Segment_Not_Present),$E,0);
   13:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Stack_Segment_Fault),$E,0);
   14:kernel_idt_set_entry(i,dword(@kernel_idt_handler_General_Protection),$E,0);
   15:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Page_Fault),$E,0);
   16:kernel_idt_set_entry(i,0,$E,0);
   17:kernel_idt_set_entry(i,dword(@kernel_idt_handler_FPU_Math_Error),$E,0);
   18:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Alignment_Check),$E,0);
   19:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Machine_Check),$E,0);
   20:kernel_idt_set_entry(i,dword(@kernel_idt_handler_SIMD_Floating_Point),$E,0);
   21:kernel_idt_set_entry(i,dword(@kernel_idt_handler_Virtualization_Exception),$E,0);
   22..32:kernel_idt_set_entry(i,dword(@kernel_idt_handler_empty),$E,0);
   33:kernel_idt_set_entry(i,dword(@kernel_idt_handler_timer),$E,0);
   34..256:kernel_idt_set_entry(i,dword(@kernel_idt_handler_empty),$E,0);
   end;
   inc(i);
  end;
 tempptr:=@idt;
 asm
  lidt tempptr
 end;
end;
{$ELSEIF Defined(cpux86_64) or Defined(cpuia64)}
procedure kernel_gdt_set_entry(index:word;Base:qword;Limit:dword;AccessByte:byte;Flags:byte);
begin
 PByte(@gdtentry[index].AccessByte)^:=AccessByte;
 gdtentry[index].baselow:=base and $FFFF;
 gdtentry[index].basemid:=(base shr 16) and $FF;
 gdtentry[index].Basehigh1:=(base shr 24) and $FF;
 gdtentry[index].Basehigh2:=(base shr 32) and $FFFFFFFF;
 gdtentry[index].Flags:=Flags;
 gdtentry[index].limitlow:=Limit and $FFFF;
 gdtentry[index].Limithigh:=(Limit shr 16) and $F;
 gdtentry[index].Reserved:=0;
end;
procedure kernel_idt_set_entry(index:word;address:qword;GateType:byte;PrivilegeLevel:byte);
begin
 idtentry[index].DescriptorPrivilegeLevel:=PrivilegeLevel;
 idtentry[index].Present:=1;
 idtentry[index].SegmentSelector.Index:=1;
 idtentry[index].SegmentSelector.TableIndicator:=0;
 idtentry[index].SegmentSelector.RequestPrivilegeLevel:=0;
 idtentry[index].GateType:=GateType;
 idtentry[index].offsetlow:=address and $FFFF;
 idtentry[index].offsetmiddle:=(address shr 16) and $FFFF;
 idtentry[index].offsethigh:=(address shr 32) and $FFFFFFFF;
 idtentry[index].Reserved1:=0;
 idtentry[index].Reserved2:=0;
 idtentry[index].Reserved3:=0;
 idtentry[index].IST:=0;
 if(address=0) then idtentry[index].Present:=0 else idtentry[index].Present:=1;
end;
procedure kernel_gdt_initialize;
var tempptr:Px64_gdt_descriptor;
begin
 gdt.Offset:=Qword(@gdtentry);
 gdt.Size:=sizeof(gdtentry)-1;
 kernel_gdt_set_entry(1,0,0,$0,$0);
 kernel_gdt_set_entry(2,0,$FFFFF,$9A,$A);
 kernel_gdt_set_entry(3,0,$FFFFF,$92,$C);
 kernel_gdt_set_entry(4,0,$FFFFF,$FA,$A);
 kernel_gdt_set_entry(5,0,$FFFFF,$F2,$C);
 tempptr:=@gdt;
 asm
  lgdt tempptr
 end;
end;
procedure kernel_idt_initialize;
var i:word;
    tempptr:Px64_idt_descriptor;
begin
 idt.Offset:=Qword(@idtentry);
 idt.Size:=sizeof(idtentry)-1;
 i:=1;
 while(i<=256)do
  begin
   case i of
   1:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_division_by_zero),$E,0);
   2:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Debug_exception),$F,0);
   3:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_NMI_interrupt),$E,0);
   4:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_breakpoint),$F,0);
   5:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_overflow),$F,0);
   6:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Bound_Range_exceed),$E,0);
   7:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Invaild_Opcode),$E,0);
   8:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Device_Not_Available),$E,0);
   9:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Double_Fault),$E,0);
   10:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Coprocessor_Segment_overrun),$E,0);
   11:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_invaild_TSS),$E,0);
   12:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Segment_Not_Present),$E,0);
   13:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Stack_Segment_Fault),$E,0);
   14:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_General_Protection),$E,0);
   15:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Page_Fault),$E,0);
   16:kernel_idt_set_entry(i,0,$E,0);
   17:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_FPU_Math_Error),$E,0);
   18:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Alignment_Check),$E,0);
   19:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Machine_Check),$E,0);
   20:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_SIMD_Floating_Point),$E,0);
   21:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_Virtualization_Exception),$E,0);
   22..32:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_empty),$E,0);
   33:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_timer),$E,3);
   34..256:kernel_idt_set_entry(i,Qword(@kernel_idt_handler_empty),$E,0);
   end;
   inc(i);
  end;
 tempptr:=@idt;
 asm
  lidt tempptr
 end;
end;
{$ENDIF}
procedure kernel_initialize;
var arch:byte;
begin
 arch:=kernel_get_architecture;
 case arch of
 0,1,2:
 begin
  {$IF Defined(cpui386) or Defined(cpux86_64) or Defined(cpuia64)}
  asm
   cli
  end;
  kernel_gdt_initialize;
  kernel_idt_initialize;
  asm
   sti
  end;
  {$ENDIF}
 end;
 end;
end;

end.

