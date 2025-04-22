unit system;
{$MODE FPC}

interface

{$IFDEF CPU32}
const maxnatint=$7FFFFFFF;
      maxnatuint=$FFFFFFFF;
{$ELSE CPU32}
const maxnatint=$7FFFFFFFFFFFFFFF;
      maxnatuint=$FFFFFFFFFFFFFFFF;
{$ENDIF CPU32}
type
  bit = 0..1;
  PBit = ^bit;
  hresult = LongInt;
  Char = #0..#255;
  DWord = LongWord;
  Cardinal = LongWord;
  {$IFDEF CPU16}
  Integer = SmallInt;
  {$ELSE CPU16}
  Integer = Longint;
  {$ENDIF CPU16}
  UInt64 = QWord;
  Pbyte=^byte;
  Pchar=^char;
  PWideChar=^WideChar;
  PPWideChar=^PWideChar;
  PWChar=^WideChar;
  PPWChar=^PWChar;
  Pword=^word;
  Pdword=^dword;
  Pqword=^qword;
  PPointer=^Pointer;
  Pboolean=^boolean;
  Pint64=^int64;
  Puint64=^uint64;
  Pextended=^extended;
  {$IFDEF CPU32}
  NatUint=dword;
  PNatUint=^dword;
  Natint=integer;
  PNatint=^integer;
  Uint128=packed record
          Dwords:array[1..4] of dword;
          end;
  Int128=packed record
         Highdword:Integer;
         Lowdwords:array[1..3] of dword;
         end;
  Uint96=packed record
         Dwords:array[1..3] of dword;
         end;
  Int96=packed record
        HighDword:Integer;
        Dwords:array[1..2] of dword;
        end;
  {$ELSE CPU32}
  NatUint=qword;
  PNatUint=^qword;
  Natint=int64;
  PNatint=^int64;
  Uint128=packed record
          High,Low:qword;
          end;
  Int128=packed record
         High:Int64;
         Low:qword;
         end;
  Uint96=packed record
         Dwords:array[1..3] of dword;
         end;
  Int96=packed record
        HighDword:Integer;
        Dwords:qword;
        end;
  {$ENDIF CPU32}
  TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkSet,
    tkMethod, tkSString, tkLString, tkAString, tkWString, tkVariant, tkArray,
    tkRecord, tkInterface, tkClass, tkObject, tkWChar, tkBool, tkInt64, tkQWord,
    tkDynArray, tkInterfaceRaw, tkProcVar, tkUString, tkUChar, tkHelper, tkFile,
    tkClassRef, tkPointer);
  PTypeKind=^TTypekind;
  jmp_buf = packed record
    rbx, rbp, r12, r13, r14, r15, rsp, rip: QWord;
    {$IFDEF CPU64}
    rsi, rdi: QWord;
    xmm6, xmm7, xmm8, xmm9, xmm10, xmm11, xmm12, xmm13, xmm14, xmm15: record 
      m1, m2: QWord;
    end;
    mxcsr: LongWord;
    fpucw: word;
    padding: word;
    {$ENDIF CPU64}
  end;
  Pjmp_buf = ^jmp_buf;
  PExceptAddr = ^TExceptAddr;
  TExceptAddr = record 
    buf: Pjmp_buf;
    next: PExceptAddr;
    {$IFDEF CPU16}
    frametype: SmallInt;
    {$ELSE CPU16}
    frametype: LongInt;
    {$ENDIF CPU16}
  end;
  PGuid = ^TGuid;
  TGuid = packed record
    case Integer of
    1:
     (Data1: DWord;
      Data2: word;
      Data3: word;
      Data4: array [0 .. 7] of byte;
    );
    2:
     (D1: DWord;
      D2: word;
      D3: word;
      D4: array [0 .. 7] of byte;
    );
    3:
    ( { uuid fields according to RFC4122 }
      time_low: DWord; // The low field of the timestamp
      time_mid: word; // The middle field of the timestamp
      time_hi_and_version: word;
      // The high field of the timestamp multiplexed with the version number
      clock_seq_hi_and_reserved: byte;
      // The high field of the clock sequence multiplexed with the sys_variant
      clock_seq_low: byte; // The low field of the clock sequence
      node: array [0 .. 5] of byte; // The spatially unique node identifier
    );
  end;
  sys_variant=packed record
              vartype:byte;
              case Byte of
              0:(varnatuint:Natuint;);
              1:(varnatint:Natint;);
              2:(varextended:extended;);
              3:(varpointer:Pointer;);
              end; 
  heap_item=bitpacked record
            haveprev:boolean;
            allocated:0..63;
            havenext:boolean;
            end;
  Pheap_item=^heap_item;
  heap_record=packed record
              mem_start:Pointer;
              mem_end:Pointer;
              mem_block_power:byte;
              item_max_pos:natuint;
              end;

const pi:extended=3.1415926535;
      maxextended:extended=1.7E308;
      minextended:extended=-1.7E308;
      sys_variant_type_natuint=1;
      sys_variant_type_natint=2;
      sys_variant_type_extended=3;
      sys_variant_type_pointer=4;

procedure fpc_specific_handler;compilerproc;
procedure fpc_handleerror;compilerproc;
procedure fpc_lib_exit;compilerproc;
procedure fpc_libinitializeunits;compilerproc;
procedure fpc_initializeunits;compilerproc;
procedure fpc_finalizeunits;compilerproc;
procedure fpc_do_exit;compilerproc;
procedure fpc_div_by_zero;compilerproc;
procedure fpc_setjmp;compilerproc;
procedure fpc_pushexceptaddr;compilerproc;
operator := (x:natuint)res:sys_variant;
operator := (x:natint)res:sys_variant;
operator := (x:extended)res:sys_variant;
operator := (x:pointer)res:sys_variant;
function fpc_qword_to_double(q:qword):double;compilerproc;
function fpc_int64_to_double(i:int64):double;compilerproc;
function get_bit_from_byte(data:byte;position:byte):bit;
function get_bit_from_word(data:word;position:byte):bit;
function get_bit_from_dword(data:dword;position:byte):bit;
function get_bit_from_qword(data:qword;position:byte):bit;
procedure compheap_initialize(start,totalsize:natuint;blocksize:word);
function fpc_getmem(size:Natuint):Pointer;compilerproc;
function fpc_getmemsize(ptr:Pointer):Natuint;
function fpc_allocmem(size:Natuint):Pointer;compilerproc;
procedure fpc_freemem(var ptr:Pointer);compilerproc;
procedure fpc_reallocmem(var ptr:Pointer;size:natuint);compilerproc;
procedure fpc_move(Const Source;Var Dest;Size:natuint);compilerproc;
procedure sysheap_initialize(start,totalsize:natuint;blocksize:word);
function getmem(size:natuint):Pointer;
function getmemsize(ptr:Pointer):natuint;
function allocmem(size:natuint):Pointer;
procedure freemem(var ptr:Pointer);
procedure reallocmem(var ptr:Pointer;size:natuint);
procedure move(const Source;var Dest;Size:natuint);
procedure exeheap_initialize(start,totalsize:natuint;blocksize:word);
function exeheap_getmem(size:natuint):Pointer;
function exeheap_getmemsize(ptr:Pointer):natuint;
function exeheap_allocmem(size:natuint):Pointer;
procedure exeheap_freemem(var ptr:Pointer);
procedure exeheap_reallocmem(var ptr:Pointer;size:natuint);
procedure exeheap_move(const Source;var Dest;Size:natuint);
function be_to_le_word(num:word):word;
function be_to_le_dword(num:dword):dword;
function be_to_le_qword(num:qword):qword;
function le_to_be_word(num:word):word;
function le_to_be_dword(num:dword):dword;
function le_to_be_qword(num:qword):qword;
function abs(x:natint):natint;
function abs(x:extended):extended;
function frac(x:extended):extended;
function ceil(x:extended):natint;
function floor(x:extended):natint;
function trunc(x:extended):natint;
function round(x:extended):natint;
function banker_round(x:extended):natint;
function sqr(x:natuint):natuint;
function sqr(x:natint):natint;
function sqr(x:extended):extended;
function degtorad(x:extended):extended;
function radtodeg(x:extended):extended;
function sqrt(x:Natuint):Natuint;
function sqrt(x:extended):extended;
function factorial(x:natuint):extended;
function intpower(base:extended;exponent:natint):extended;
function ln(x:extended):extended;
function log2(x:extended):extended;
function lg(x:extended):extended;
function log(base,x:extended):extended;
function exp(x:extended):extended;
function power(base:extended;exponent:extended):extended;
function sin(x:extended):extended;
function cos(x:extended):extended;
function tan(x:extended):extended;
function cot(x:extended):extended;
function sec(x:extended):extended;
function csc(x:extended):extended;
function arcsin(x:extended):extended;
function arccos(x:extended):extended;
function arctan(x:extended):extended;
function arccot(x:extended):extended;
function arcsec(x:extended):extended;
function arccsc(x:extended):extended;
function strlen(str:Pchar):natuint;
function wstrlen(str:PWideChar):natuint;
procedure strinit(var str:PChar;size:natuint);
procedure wstrinit(var str:PWideChar;Size:natuint);
function strcreate(content:PChar):PChar;
function Wstrcreate(content:PWideChar):PWideChar;
procedure strrealloc(var str:PChar;size:natuint);
procedure Wstrrealloc(var str:PwideChar;size:natuint);
procedure strset(var str:PChar;val:Pchar);
procedure wstrset(var str:PWideChar;val:Pwidechar);
function strcmp(str1,str2:Pchar):natint;
function Wstrcmp(str1,str2:PwideChar):natint;
function strpartcmp(str1:PChar;position,length:natuint;str2:PChar):natint;
function Wstrpartcmp(str1:PWideChar;position,length:natuint;str2:PWideChar):natint; 
function strcmpL(str1,str2:Pchar):natint;
function WstrcmpL(str1,str2:PwideChar):natint;
function strpartcmpL(str1:PChar;position,length:natuint;str2:PChar):natint;
function WstrpartcmpL(str1:PWideChar;position,length:natuint;str2:PWideChar):natint; 
procedure strcat(var dest:PChar;src:PChar);
procedure Wstrcat(var dest:PWideChar;src:PWideChar);
procedure strfree(var str:PChar);
procedure Wstrfree(var str:PWideChar);
procedure strUpperCase(var str:PChar);
procedure strLowerCase(var str:PChar);
procedure WstrUpperCase(var str:PWideChar);
procedure WstrLowerCase(var str:PWideChar);
function strcopy(str:PChar;index,count:Natuint):Pchar;
function Wstrcopy(str:PWideChar;index,count:Natuint):PWideChar;
function strcutout(str:PChar;left,right:Natuint):PChar;
function Wstrcutout(str:PWideChar;left,right:Natuint):PWideChar;
procedure strdelete(var str:PChar;index,count:Natuint);
procedure Wstrdelete(var str:PWideChar;index,count:Natuint);
procedure strdeleteinrange(var str:PChar;left,right:Natuint);
procedure WStrdeleteinrange(var str:PWideChar;left,right:Natuint);
procedure strinsert(var str:PChar;insertstr:PChar;index:natuint);
procedure Wstrinsert(var str:PWideChar;insertstr:PWideChar;index:natuint);
function strpos(str,substr:PChar;start:Natuint):Natuint;
function Wstrpos(str,substr:PWideChar;start:natuint):natuint;
function strposdir(str,substr:PChar;start:natuint;direction:shortint):natuint;
function Wstrposdir(str,substr:PWideChar;start:natuint;direction:shortint):natuint;
function strposorder(str,substr:PChar;start,order:natuint):natuint;
function Wstrposorder(str,substr:PWideChar;start,order:natuint):natuint;
function strposdirorder(str,substr:PChar;start,order:natuint;direction:shortint):natuint;
function Wstrposdirorder(str,substr:PWideChar;start,order:natuint;direction:shortint):natuint;
function strcount(str,substr:PChar;start:Natuint):natuint;
function Wstrcount(str,substr:PWideChar;start:Natuint):natuint;
function strposinverse(str,substr:PChar;start:Natuint):Natuint;
function Wstrposinverse(str,substr:PWideChar;start:natuint):natuint;
function IntToPChar(Int:natint):PChar;
function UintToPChar(UInt:Natuint):Pchar;
function ExtendedToPChar(Ext:Extended;decimal:word):PChar;
function IntToHex(Int:natuint):PChar;
function PCharToInt(str:PChar):natint;
function PCharToUInt(str:PChar):natuint;
function PCharToExtended(str:PChar):Extended;
function HexToInt(Hex:PChar):natuint;
function IntToPWChar(Int:natint):PWideChar;
function UintToPWChar(UInt:Natuint):PWidechar;
function ExtendedToPWChar(Ext:Extended;decimal:word):PWideChar;
function IntToWHex(Int:natuint):PWideChar;
function PWCharToInt(str:PWideChar):natint;
function PWCharToUInt(str:PWideChar):natuint;
function PWCharToExtended(str:PWideChar):Extended;
function WHexToInt(Hex:PWideChar):natuint;
procedure randomize(seed_data:Pointer;seed_data_size:natuint);
function random(maxnum:extended):extended;
function random_range(left,right:extended):extended;
function irandom(maxnum:natuint):natint;
function irandom_range(left,right:natint):natint;

var totalmemorysize:natuint;
    compheap,sysheap,exeheap:heap_record;
    ranseed:natuint;
    
implementation

procedure fpc_specific_handler;compilerproc;[public,alias:'__FPC_specific_handler'];
begin
end;
procedure fpc_handleerror;compilerproc;[public,alias:'FPC_HANDLEERROR'];
begin
end;
procedure fpc_lib_exit;compilerproc;[public,alias:'FPC_LIB_EXIT'];
begin
end;
procedure fpc_libinitializeunits;compilerproc;[public,alias:'FPC_LIBINITIALIZEUNITS'];
begin
end;
procedure fpc_initializeunits;compilerproc;[public,alias:'FPC_INITIALIZEUNITS'];
begin
end;
procedure fpc_finalizeunits;compilerproc;[public,alias:'FPC_FINALIZEUNITS'];
begin
end;
procedure fpc_do_exit;compilerproc;[public,alias:'FPC_DI_EXIT'];
begin
end;
procedure fpc_div_by_zero;compilerproc;[public,alias:'FPC_DIVBYZERO'];
begin
end;
procedure fpc_setjmp;compilerproc;[public,alias:'FPC_SETJMP'];
begin
end;
procedure fpc_pushexceptaddr;compilerproc;[public,alias:'FPC_PUSHEXCEPTADDR'];
begin
end;
function fpc_qword_to_double(q:qword):double;compilerproc;[public,alias:'FPC_QWORD_TO_DOUBLE'];
begin
 fpc_qword_to_double:=dword(q and $ffffffff)+dword(q shr 32)*double(4294967296.0);
end;
function fpc_int64_to_double(i:int64):double;compilerproc;[public,alias:'FPC_INT64_TO_DOUBLE'];
begin
 fpc_int64_to_double:=dword(i and $ffffffff)+longint(i shr 32)*double(4294967296.0);
end;
operator := (x:natuint)res:sys_variant;
begin
 res.vartype:=sys_variant_type_natuint;
 res.varnatuint:=x;
end;
operator := (x:natint)res:sys_variant;
begin
 res.vartype:=sys_variant_type_natint;
 res.varnatint:=x;
end;
operator := (x:extended)res:sys_variant;
begin
 res.vartype:=sys_variant_type_extended;
 res.varextended:=x;
end;
operator := (x:pointer)res:sys_variant;
begin
 res.vartype:=sys_variant_type_pointer;
 res.varpointer:=x;
end;
function get_bit_from_byte(data:byte;position:byte):bit;
begin
 get_bit_from_byte:=(data shr position) and $1;
end;
function get_bit_from_word(data:word;position:byte):bit;
begin
 get_bit_from_word:=(data shr position) and $1;
end;
function get_bit_from_dword(data:dword;position:byte):bit;
begin
 get_bit_from_dword:=(data shr position) and $1;
end;
function get_bit_from_qword(data:qword;position:byte):bit;
begin
 get_bit_from_qword:=(data shr position) and $1;
end;
function heap_initialize(startpos,endpos:natuint;blockpower:byte):heap_record;
var res:heap_record;
begin
 res.mem_start:=Pointer(startpos); res.mem_end:=Pointer(endpos);
 res.mem_block_power:=blockpower; res.item_max_pos:=0;
 heap_initialize:=res;
end;
function heap_get_total_size(heap:heap_record):natuint;
begin
 heap_get_total_size:=Natuint(heap.mem_end-heap.mem_start)+1;
end;
function heap_conv_addr_to_index(heap:heap_record;addr:Pointer;isitem:Boolean):natuint;
begin
 if(isitem) then heap_conv_addr_to_index:=(heap.mem_end-addr) shr heap.mem_block_power
 else heap_conv_addr_to_index:=(addr-heap.mem_start) shr heap.mem_block_power+1;
end;
function heap_conv_index_to_addr(heap:heap_record;index:natuint;isitem:boolean):Pointer;
begin
 if(isitem) then heap_conv_index_to_addr:=Pointer(heap.mem_end-index*sizeof(heap_item))
 else heap_conv_index_to_addr:=Pointer(heap.mem_start+(index-1) shl heap.mem_block_power);
end;
function heap_conv_index_to_item(heap:heap_record;index:natuint):heap_item;
begin
 heap_conv_index_to_item:=Pheap_item(heap.mem_end-index*sizeof(heap_item))^;
end;
function heap_conv_mem_to_item(heap:heap_record;mem:Pointer):heap_item;
var index:natuint;
    res:heap_item;
begin
 index:=Natuint(mem-heap.mem_start) shr heap.mem_block_power+1;
 heap_conv_mem_to_item:=Pheap_item(mem-index*sizeof(heap_item))^;
end;
function heap_get_mem_count(heap:heap_record;ptr:Pointer):natuint;
var i1,i2,index:natuint;
    tempitem:heap_item;
begin
 if(ptr=nil) or (ptr<heap.mem_start) or (ptr>heap.mem_end) then exit(0);
 index:=heap_conv_addr_to_index(heap,ptr,false);
 i1:=index; i2:=index;
 tempitem:=heap_conv_index_to_item(heap,i1);
 if(tempitem.havenext) and (tempitem.haveprev) then
  begin
   while(i1<heap.item_max_pos)do
    begin
     tempitem:=heap_conv_index_to_item(heap,i1);
     if(tempitem.havenext=false) then break;
     inc(i1);
    end;
   while(i2>1)do
    begin
     tempitem:=heap_conv_index_to_item(heap,i2);
     if(tempitem.haveprev=false) then break;
     dec(i2);
    end;
   heap_get_mem_count:=i1-i2+1;
  end
 else if(tempitem.havenext) then
  begin
   while(i1<heap.item_max_pos)do
    begin
     tempitem:=heap_conv_index_to_item(heap,i1);
     if(tempitem.havenext=false) then break;
     inc(i1);
    end;
   heap_get_mem_count:=(i1-index+1);
  end
 else if(tempitem.haveprev) then
  begin
   while(i2>1)do
    begin
     tempitem:=heap_conv_index_to_item(heap,i2);
     if(tempitem.haveprev=false) then break;
     dec(i2);
    end;
   heap_get_mem_count:=(index-i2+1);
  end
 else
  begin
   heap_get_mem_count:=1;
  end;
end;
function heap_get_mem_size(heap:heap_record;ptr:Pointer):natuint;
var i1,i2,index:natuint;
    tempitem:heap_item;
begin
 if(ptr=nil) or (ptr<heap.mem_start) or (ptr>heap.mem_end) then exit(0);
 index:=heap_conv_addr_to_index(heap,ptr,false);
 i1:=index; i2:=index;
 tempitem:=heap_conv_index_to_item(heap,i1);
 if(tempitem.havenext) and (tempitem.haveprev) then
  begin
   while(i1<heap.item_max_pos)do
    begin
     tempitem:=heap_conv_index_to_item(heap,i1);
     if(tempitem.havenext=false) then break;
     inc(i1);
    end;
   while(i2>1)do
    begin
     tempitem:=heap_conv_index_to_item(heap,i2);
     if(tempitem.haveprev=false) then break;
     dec(i2);
    end;
   heap_get_mem_size:=(i1-i2+1) shl heap.mem_block_power;
  end
 else if(tempitem.havenext) then
  begin
   while(i1<heap.item_max_pos)do
    begin
     tempitem:=heap_conv_index_to_item(heap,i1);
     if(tempitem.havenext=false) then break;
     inc(i1);
    end;
   heap_get_mem_size:=(i1-index+1) shl heap.mem_block_power;
  end
 else if(tempitem.haveprev) then
  begin
   while(i2>1)do
    begin
     tempitem:=heap_conv_index_to_item(heap,i2);
     if(tempitem.haveprev=false) then break;
     dec(i2);
    end;
   heap_get_mem_size:=(index-i2+1) shl heap.mem_block_power;
  end
 else
  begin
   heap_get_mem_size:=1 shl heap.mem_block_power;
  end;
end;
function heap_get_mem_start(heap:heap_record;ptr:Pointer):Pointer;
var i1,index:natuint;
    tempitem:heap_item;
begin
 if(ptr=nil) or (ptr<heap.mem_start) or (ptr>heap.mem_end) then exit(nil);
 index:=heap_conv_addr_to_index(heap,ptr,false);
 tempitem:=heap_conv_index_to_item(heap,index);
 i1:=index;
 if(tempitem.haveprev) then
  begin
   while(i1>0)do
    begin
     tempitem:=heap_conv_index_to_item(heap,i1);
     if(tempitem.haveprev=false) then break;
     dec(i1);
    end;
   heap_get_mem_start:=heap.mem_start+(i1-1) shl heap.mem_block_power;
  end
 else
  begin
   heap_get_mem_start:=heap.mem_start+(index-1) shl heap.mem_block_power;
  end;
end;
function heap_request_mem(var heap:heap_record;size:natuint;meminit:boolean):Pointer;
var blockcount:Natuint;
    i1,i2,i3,i4:natuint;
    tempptr:Pheap_item;
    tempmemptr:Pqword;
    totalsize:natuint;
begin
 totalsize:=heap_get_total_size(heap);
 blockcount:=(size+1 shl heap.mem_block_power-1) shr heap.mem_block_power;
 if(blockcount=0) then heap_request_mem:=nil
 else
  begin
   if(heap.item_max_pos=0) and (blockcount shl heap.mem_block_power
   +blockcount<=totalsize) then
    begin
     i1:=1;
     while(i1<=blockcount)do
      begin
       tempptr:=heap_conv_index_to_addr(heap,i1,true);
       tempmemptr:=heap_conv_index_to_addr(heap,i1,false);
       if(i1>1) then tempptr^.haveprev:=true else tempptr^.haveprev:=false;
       tempptr^.allocated:=1;
       if(i1<blockcount) then tempptr^.havenext:=true else tempptr^.havenext:=false;
       if(meminit) then
        begin
         for i2:=1 to 1 shl heap.mem_block_power shr 3 do (tempmemptr+i2-1)^:=0;
        end;
       inc(i1);
      end;
     heap_request_mem:=heap.mem_start;
     inc(heap.item_max_pos,blockcount);
    end
   else if(heap.item_max_pos>0) then
    begin
     i1:=1; i2:=0;
     while(i1<=heap.item_max_pos)do
      begin
       tempptr:=heap_conv_index_to_addr(heap,i1,true);
       if(tempptr^.allocated=0) and (i2<blockcount) then inc(i2)
       else if(tempptr^.allocated=0) then break
       else i2:=0;
       inc(i1);
      end;
     if(i2=0) and ((heap.item_max_pos+blockcount)
     shl heap.mem_block_power+(heap.item_max_pos+blockcount)<=totalsize) then
      begin
       i1:=1;
       while(i1<=blockcount)do
        begin
         tempptr:=heap_conv_index_to_addr(heap,heap.item_max_pos+i1,true);
         tempmemptr:=heap_conv_index_to_addr(heap,heap.item_max_pos+i1,false);
         if(i1>1) then tempptr^.haveprev:=true else tempptr^.haveprev:=false;
         tempptr^.allocated:=1;
         if(i1<blockcount) then tempptr^.havenext:=true else tempptr^.havenext:=false;
         if(meminit) then
          begin
           for i4:=1 to 1 shl heap.mem_block_power shr 3 do (tempmemptr+i4-1)^:=0;
          end;
         inc(i1);
        end;
       heap_request_mem:=heap.mem_start+heap.item_max_pos shl heap.mem_block_power;
       inc(heap.item_max_pos,blockcount);
      end
     else if(i2=0) then
      begin
       heap_request_mem:=nil;
      end
     else
      begin
       i3:=i1-i2+1;
       while(i3<=i1)do
        begin
         tempptr:=heap_conv_index_to_addr(heap,i3,true);
         tempmemptr:=heap_conv_index_to_addr(heap,i3,false);
         if(i3>i1-i2+1) then tempptr^.haveprev:=true else tempptr^.haveprev:=false;
         tempptr^.allocated:=1;
         if(i3<i1) then tempptr^.havenext:=true else tempptr^.havenext:=false;
         if(meminit) then
          begin
           for i4:=1 to 1 shl heap.mem_block_power shr 3 do (tempmemptr+i4-1)^:=0;
          end;
         inc(i3);
        end;
       heap_request_mem:=heap.mem_start+(i1-i2) shl heap.mem_block_power;
      end;
    end
   else heap_request_mem:=nil;
  end;
end;
procedure heap_free_mem(var heap:heap_record;var ptr:Pointer;forcenil:boolean);
var start:Pointer;
    index,i,blockcount:natuint;
    tempptr:Pheap_item;
begin
 if(ptr=nil) then exit;
 start:=heap_get_mem_start(heap,ptr);
 index:=heap_conv_addr_to_index(heap,start,true);
 blockcount:=heap_get_mem_size(heap,ptr);
 i:=1;
 while(i<=blockcount)do
  begin
   tempptr:=heap_conv_index_to_addr(heap,index+i-1,true);
   if(tempptr^.allocated<>0) then tempptr^.allocated:=0;
   tempptr^.haveprev:=false; tempptr^.havenext:=false;
   inc(i);
  end;
 i:=heap.item_max_pos;
 while(i>0)do
  begin
   tempptr:=heap_conv_index_to_addr(heap,i-1,true);
   if(tempptr^.allocated<>0) then break;
   dec(i);
  end;
 heap.item_max_pos:=i;
 if(forcenil) then ptr:=nil;
end;
procedure heap_move_mem(heap:heap_record;src,dest:Pointer);
var start1,start2:Pqword;
    size1,size2,i:natuint;
begin
 if(src=nil) or (src<heap.mem_start) or (src>=heap.mem_end-heap.item_max_pos*sizeof(heap_item)) 
 or(dest=nil) or (dest<heap.mem_start) or (dest>=heap.mem_end-heap.item_max_pos*sizeof(heap_item)) then exit;
 start1:=heap_get_mem_start(heap,src);
 start2:=heap_get_mem_start(heap,dest);
 size1:=heap_get_mem_size(heap,src);
 size2:=heap_get_mem_size(heap,dest);
 if(size1<>0) and (size2<>0) then
  begin
   if(size1>size2) then
    begin
     for i:=1 to size2 shr 3 do (start2+i-1)^:=(start1+i-1)^;
    end
   else if(size1<=size2) then
    begin
     for i:=1 to size1 shr 3 do (start2+i-1)^:=(start1+i-1)^;
    end;
  end;
end;
function universial_heap_initialize(startpos,endpos:natuint;blockpower:byte):heap_record;
begin
 universial_heap_initialize:=heap_initialize(startpos,endpos,blockpower);
end;
function universial_getmem(var heap:heap_record;size:natuint):Pointer;
begin
 universial_getmem:=heap_request_mem(heap,size,false);
end;
function universial_getmemsize(heap:heap_record;ptr:Pointer):natuint;
begin
 universial_getmemsize:=heap_get_mem_size(heap,ptr);
end;
function universial_allocmem(var heap:heap_record;size:natuint):Pointer;
begin
 universial_allocmem:=heap_request_mem(heap,size,true);
end;
procedure universial_freemem(var heap:heap_record;var ptr:Pointer);
begin
 heap_free_mem(heap,ptr,true);
end;
procedure universial_move(const src;var dest;Size:natuint);
var i:Natint;
    q1,q2:Pqword;
    d1,d2:Pdword;
    w1,w2:Pword;
    b1,b2:Pbyte;
begin
 if(Size-Size shr 3 shl 3=0) then
  begin
   q1:=Pqword(@src); q2:=Pqword(@dest);
   for i:=1 to Size shr 3 do (q2+i-1)^:=(q1+i-1)^;
  end
 else if(Size-Size shr 2 shl 2=0) then
  begin
   d1:=Pdword(@src); d2:=Pdword(@dest);
   for i:=1 to Size shr 2 do (d2+i-1)^:=(d1+i-1)^;
  end
 else if(Size-Size shr 1 shl 1=0) then
  begin
   w1:=Pword(@src); w2:=Pword(@dest);
   for i:=1 to Size shr 1 do (w2+i-1)^:=(w1+i-1)^;
  end
 else
  begin
   b1:=Pbyte(@src); b2:=Pbyte(@dest);
   for i:=1 to Size do (b2+i-1)^:=(b1+i-1)^;
  end;
end;
function universial_reallocmem(var heap:heap_record;var ptr:Pointer;size:natuint):Pointer;
var newptr,oldptr:Pointer;
begin
 newptr:=heap_request_mem(heap,size,true);
 oldptr:=ptr;
 heap_move_mem(heap,oldptr,newptr);
 heap_free_mem(heap,oldptr,false);
 ptr:=newptr;
 universial_reallocmem:=newptr;
end;
procedure compheap_initialize(start,totalsize:natuint;blocksize:word);
var i,tempnum:Natuint;
begin
 tempnum:=blocksize; i:=0;
 while(tempnum>1)do
  begin
   tempnum:=tempnum shr 1;
   inc(i);
  end;
 compheap:=universial_heap_initialize(start,start+totalsize,i);
end;
function fpc_getmem(size:Natuint):Pointer;compilerproc;[public,alias:'FPC_GETMEM'];
begin
 fpc_getmem:=universial_getmem(compheap,size);
end;
function fpc_getmemsize(ptr:Pointer):Natuint;[public,alias:'FPC_GETMEMSIZE'];
begin
 fpc_getmemsize:=universial_getmemsize(compheap,ptr);
end;
function fpc_allocmem(size:Natuint):Pointer;compilerproc;[public,alias:'FPC_ALLOCMEM'];
begin
 fpc_allocmem:=universial_allocmem(compheap,size);
end;
procedure fpc_freemem(var ptr:Pointer);compilerproc;[public,alias:'FPC_FREEMEM'];
begin
 universial_freemem(compheap,ptr);
end;
procedure fpc_reallocmem(var ptr:Pointer;size:natuint);compilerproc;[public,alias:'FPC_REALLOCMEM'];
begin
 universial_reallocmem(compheap,ptr,size);
end;
procedure fpc_move(Const Source;Var Dest;Size:natuint);compilerproc;[public,alias:'FPC_MOVE'];
begin
 universial_move(Source,Dest,Size);
end;
procedure sysheap_initialize(start,totalsize:natuint;blocksize:word);
var i,tempnum:Natuint;
begin
 tempnum:=blocksize; i:=0;
 while(tempnum>1)do
  begin
   tempnum:=tempnum shr 1;
   inc(i);
  end;
 sysheap:=universial_heap_initialize(start,start+totalsize,i);
end;
function getmem(size:natuint):Pointer;[public,alias:'getmem'];
begin
 getmem:=universial_getmem(sysheap,size);
end;
function getmemsize(ptr:Pointer):natuint;[public,alias:'getmemsize'];
begin
 getmemsize:=universial_getmemsize(sysheap,ptr);
end;
function allocmem(size:natuint):Pointer;[public,alias:'allocmem'];
begin
 allocmem:=universial_allocmem(sysheap,size);
end;
procedure freemem(var ptr:Pointer);[public,alias:'freemem'];
begin
 universial_freemem(sysheap,ptr);
end;
procedure reallocmem(var ptr:Pointer;size:natuint);[public,alias:'reallocmem'];
begin
 universial_reallocmem(sysheap,ptr,size);
end;
procedure move(const Source;var Dest;Size:natuint);[public,alias:'move'];
begin
 universial_move(source,dest,size);
end;
procedure exeheap_initialize(start,totalsize:natuint;blocksize:word);
var i,tempnum:Natuint;
begin
 tempnum:=blocksize; i:=0;
 while(tempnum>1)do
  begin
   tempnum:=tempnum shr 1;
   inc(i);
  end;
 exeheap:=universial_heap_initialize(start,start+totalsize,i);
end;
function exeheap_getmem(size:natuint):Pointer;[public,alias:'exeheap_getmem'];
begin
 exeheap_getmem:=universial_getmem(exeheap,size);
end;
function exeheap_getmemsize(ptr:Pointer):natuint;[public,alias:'exeheap_getmemsize'];
begin
 exeheap_getmemsize:=universial_getmemsize(exeheap,ptr);
end;
function exeheap_allocmem(size:natuint):Pointer;[public,alias:'exeheap_allocmem'];
begin
 exeheap_allocmem:=universial_allocmem(exeheap,size);
end;
procedure exeheap_freemem(var ptr:Pointer);[public,alias:'exeheap_freemem'];
begin
 universial_freemem(exeheap,ptr);
end;
procedure exeheap_reallocmem(var ptr:Pointer;size:natuint);[public,alias:'exeheap_reallocmem'];
begin
 universial_reallocmem(exeheap,ptr,size);
end;
procedure exeheap_move(const Source;var Dest;Size:natuint);[public,alias:'exeheap_move'];
begin
 universial_move(source,dest,size);
end;
function be_to_le_word(num:word):word;
begin
 be_to_le_word:=((num shr 8) and $FF) or ((num shl 8) and $FF00);
end;
function be_to_le_dword(num:dword):dword;
begin
 be_to_le_dword:=((num shr 24) and $FF) or ((num shr 8) and $FF00)
         or((num shl 8) and $FF0000) or ((num shl 24) and $FF000000);
end;
function be_to_le_qword(num:qword):qword;
begin
 be_to_le_qword:=((num shr 56) and $FF) or ((num shr 40) and $FF00)
         or((num shr 24) and $FF0000) or ((num shr 8) and $FF000000)
         or((num shl 8) and $FF00000000) or ((num shl 24) and $FF0000000000)
         or((num shl 40) and $FF000000000000) or ((num shl 56) and $FF00000000000000);
end;
function le_to_be_word(num:word):word;
begin
 le_to_be_word:=((num shr 8) and $FF) or ((num shl 8) and $FF00);
end;
function le_to_be_dword(num:dword):dword;
begin
 le_to_be_dword:=((num shr 24) and $FF) or ((num shr 8) and $FF00)
         or((num shl 8) and $FF0000) or ((num shl 24) and $FF000000);
end;
function le_to_be_qword(num:qword):qword;
begin
 le_to_be_qword:=((num shr 56) and $FF) or ((num shr 40) and $FF00)
         or((num shr 24) and $FF0000) or ((num shr 8) and $FF000000)
         or((num shl 8) and $FF00000000) or ((num shl 24) and $FF0000000000)
         or((num shl 40) and $FF000000000000) or ((num shl 56) and $FF00000000000000);
end;  
function abs(x:natint):natint;[public,alias:'abs_natint'];
begin
 if(x>0) then abs:=x else abs:=-x;
end;
function abs(x:extended):extended;[public,alias:'abs_extended'];
begin
 if(x>0) then abs:=x else abs:=-x;
end;
function frac(x:extended):extended;[public,alias:'frac'];
var j:natuint;
    num:extended;
    procnum:natuint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1;
 while(procnum shl 4<num) do
  begin
   procnum:=procnum shl 4;
  end;
 while(num>=1) do
  begin
   j:=0;
   while(j<=15) do
    begin
     if(num>=j*procnum) and (num<(j+1)*procnum) then break;
     j:=j+1;
    end;
   if(j>=16) then break;
   num:=num-j*procnum;
   if(procnum>1) then procnum:=procnum shr 4 else break;
  end;
 if(x>0) then frac:=num else frac:=-num;
end;
function ceil(x:extended):natint;[public,alias:'ceil'];
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1;
 while(procnum shl 4<num) do procnum:=procnum shl 4;
 while(num>=1) do
  begin
   j:=0;
   while(j<=15) do
    begin
     if(num>=j*procnum) and (num<(j+1)*procnum) then break;
     inc(j);
    end;
   if(j>=16) then break;
   res:=res+procnum*j;
   num:=num-j*procnum;
   if(procnum>1) then procnum:=procnum shr 4 else break;
  end;
 if(x<0) then res:=-res;
 if(num>0) then inc(res);
 ceil:=res;
end;
function floor(x:extended):natint;[public,alias:'floor'];
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1;
 while(procnum shl 4<num) do procnum:=procnum shl 4;
 while(num>=1) do
  begin
   j:=0;
   while(j<=15) do
    begin
     if(num>=j*procnum) and (num<(j+1)*procnum) then break;
     inc(j);
    end;
   if(j>=16) then break;
   res:=res+procnum*j;
   num:=num-j*procnum;
   if(procnum>1) then procnum:=procnum shr 4 else break;
  end;
 if(x<0) then res:=-res;
 if(num<0) then dec(res);
 floor:=res;
end;
function trunc(x:extended):natint;[public,alias:'trunc'];
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1;
 while(procnum shl 4<num) do procnum:=procnum shl 4;
 while(num>=1) do
  begin
   j:=0;
   while(j<=15) do
    begin
     if(num>=j*procnum) and (num<(j+1)*procnum) then break;
     inc(j);
    end;
   if(j>=16) then break;
   res:=res+procnum*j;
   num:=num-j*procnum;
   if(procnum>1) then procnum:=procnum shr 4 else break;
  end;
 if(x<0) then res:=-res;
 trunc:=res;
end;
function round(x:extended):natint;[public,alias:'round'];
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1;
 while(procnum shl 4<num) do procnum:=procnum shl 4;
 while(num>=1) do
  begin
   j:=0;
   while(j<=15) do
    begin
     if(num>=j*procnum) and (num<(j+1)*procnum) then break;
     inc(j);
    end;
   if(j>=16) then break;
   res:=res+procnum*j;
   num:=num-j*procnum;
   if(procnum>1) then procnum:=procnum shr 4 else break;
  end;
 if(x<0) then res:=-res;
 if(num>=0.5) then inc(res);
 round:=res;
end;
function banker_round(x:extended):natint;[public,alias:'banker_round'];
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1;
 while(procnum shl 4<num) do procnum:=procnum shl 4;
 while(num>=1) do
  begin
   j:=0;
   while(j<=15) do
    begin
     if(num>=j*procnum) and (num<(j+1)*procnum) then break;
     inc(j);
    end;
   if(j>=16) then break;
   res:=res+procnum*j;
   num:=num-j*procnum;
   if(procnum>1) then procnum:=procnum shr 4 else break;
  end;
 if(x<0) then res:=-res;
 if(num>=0.5) and (res-res shr 1 shl 1=1) then inc(res);
 banker_round:=res;
end;
function sqr(x:natuint):natuint;[public,alias:'sqr_natuint'];
begin
 sqr:=x*x;
end;
function sqr(x:natint):natint;[public,alias:'sqr_natint'];
begin
 sqr:=x*x;
end;
function sqr(x:extended):extended;[public,alias:'sqr_extended'];
begin
 sqr:=x*x;
end;
function degtorad(x:extended):extended;
begin
 degtorad:=(x/180)*pi;
end;
function radtodeg(x:extended):extended;
begin
 radtodeg:=(x/pi)*180;
end;
function sqrt(x:Natuint):Natuint;
var i:Natuint;
begin
 if(x=0) then sqrt:=0
 else
  begin
   i:=1;
   while(i*i<=x)do inc(i);
   sqrt:=i-1;
  end;
end;
function sqrt(x:extended):extended;
var base,step:extended;
    i:byte;
begin
 base:=0; step:=1; i:=1;
 while(i<=10)do
  begin
   while(base*base<=x)do base:=base+step;
   base:=base-step; step:=step/10; inc(i);
  end;
 sqrt:=base;
end;
function sqrt(x:extended;precision:byte):extended;
var base,step:extended;
    i:byte;
begin
 base:=0; step:=1; i:=1;
 while(i<=precision)do
  begin
   while(base*base<=x)do base:=base+step;
   base:=base-step; step:=step/10; inc(i);
  end;
 sqrt:=base;
end;
function factorial(x:natuint):extended;
var res:extended;
    i:natuint;
begin
 i:=1; res:=1;
 while(i<=x)do
  begin
   res:=res*i; inc(i);
  end;
 factorial:=res;
end;
function intpower(base:extended;exponent:natint):extended;
var res:extended;
    i:natint;
begin
 if(exponent>0) then
  begin
   res:=1;
   for i:=1 to exponent do res:=res*base;
   intpower:=res;
  end
 else if(exponent=0) then intpower:=1
 else if(exponent<0) then
  begin
   res:=1;
   for i:=-1 downto exponent do res:=res*base;
   intpower:=1/res;
  end;
end;
function ln(x:extended):extended;
const ln2:extended=0.6931471806;
var a,n,res:extended;
    i:byte;
begin
 if(x<=0) then exit(0);
 n:=1;
 while(n<=x)do n:=n*16;
 a:=x/n; res:=0;
 for i:=1 to 10 do
  begin
   if(i-i shr 1 shl 1=0) then res:=res-(1/i)*IntPower(a-1,i)
   else res:=res+(1/i)*IntPower(a-1,i);
  end;
 ln:=res+4*n*ln2;
end;
function log2(x:extended):extended;
begin
 log2:=ln(x)/ln(2);
end;
function lg(x:extended):extended;
begin
 lg:=ln(x)/ln(10);
end;
function log(base,x:extended):extended;
begin
 if(base<0) then exit(0);
 log:=ln(x)/ln(base);
end;
function exp(x:extended):extended;
var i:byte;
    res:extended;
begin
 res:=0;
 for i:=1 to 10 do res:=res+intpower(x,i-1)/factorial(i-1);
end;
function power(base:extended;exponent:extended):extended;
var i:byte;
    res:extended;
begin
 res:=0;
 for i:=1 to 10 do res:=res+intpower(exponent*ln(base),i-1)/factorial(i-1);
 power:=res;
end;
function get_radian_offset(x:extended):extended;
var tempval:extended;
begin
 tempval:=x;
 while(tempval<0) or (tempval>pi*2) do
  begin
   if(tempval<0) then tempval:=tempval+pi*2
   else tempval:=tempval-pi*2;
  end;
 get_radian_offset:=tempval;
end;
function sin(x:extended):extended;
var tempfloat,res:extended;
    i:byte;
begin
 tempfloat:=get_radian_offset(x); res:=0;
 for i:=1 to 10 do
  begin
   if(i-i shr 1 shl 1=0) then
   res:=res-IntPower(x,2*i-1)/Factorial(2*i-1)
   else
   res:=res+IntPower(x,2*i-1)/Factorial(2*i-1);
  end;
 sin:=res;
end;
function cos(x:extended):extended;
var tempfloat,res:extended;
    i:byte;
begin
 tempfloat:=get_radian_offset(x); res:=0;
 for i:=1 to 10 do
  begin
   if(i-i shr 1 shl 1=0) then
   res:=res-IntPower(x,2*i-2)/Factorial(2*i-2)
   else
   res:=res+IntPower(x,2*i-2)/Factorial(2*i-2);
  end;
 cos:=res;
end;
function tan(x:extended):extended;
var sinval,cosval:extended;
begin
 sinval:=sin(x); cosval:=cos(x);
 if(cosval=0) then tan:=maxextended else tan:=sinval/cosval;
end;
function cot(x:extended):extended;
var sinval,cosval:extended;
begin
 sinval:=sin(x); cosval:=cos(x);
 if(cosval=0) then cot:=maxextended else cot:=sinval/cosval;
end;
function sec(x:extended):extended;
var cosval:extended;
begin
 cosval:=cos(x);
 if(cosval=0) then sec:=maxextended else sec:=1/cosval;
end;
function csc(x:extended):extended;
var sinval:extended;
begin
 sinval:=sin(x);
 if(sinval=0) then csc:=maxextended else csc:=1/sinval;
end;
function arcsin(x:extended):extended;
var res,b1,b2:extended;
    n,m:byte;
begin
 if(x<-1) or (x>1) then exit(maxextended);
 res:=0;
 for n:=1 to 10 do
  begin
   b1:=1; b2:=1;
   for m:=1 to n-1 do
    begin
     b1:=b1*(2*m-1); b2:=b2*(2*m);
    end;
   res:=res+b1/b2*IntPower(x,2*n-1)/(2*n-1);
  end;
 arcsin:=res;
end;
function arccos(x:extended):extended;
begin
 if(x<-1) or (x>1) then exit(maxextended);
 arccos:=pi/2-arcsin(x);
end;
function arctan(x:extended):extended;
var n:byte;
    res:extended;
begin
 res:=0;
 for n:=1 to 10 do
  begin
   if(n-n shr 1 shl 1=0) then
   res:=res-IntPower(x,2*n-1)/(2*n-1)
   else
   res:=res+IntPower(x,2*n-1)/(2*n-1);
  end;
 arctan:=res;
end;
function arccot(x:extended):extended;
begin
 arccot:=pi/2-arctan(x);
end;
function arcsec(x:extended):extended;
begin
 arcsec:=arccos(1/x);
end;
function arccsc(x:extended):extended;
begin
 arccsc:=arcsin(1/x);
end;
function strlen(str:Pchar):natuint;[public,alias:'strlen'];
var res:natuint;
begin
 res:=0;
 if(str=nil) then exit(0);
 while((str+res)^<>#0) do inc(res);
 strlen:=res;
end;
function wstrlen(str:PWideChar):natuint;[public,alias:'Wstrlen'];
var res:natuint;
begin
 res:=0;
 if(str=nil) then exit(0);
 while((str+res)^<>#0) do inc(res);
 wstrlen:=res;
end;
function strcmp(str1,str2:Pchar):natint;[public,alias:'strcmp'];
var i:natint;
begin
 i:=0;
 if(str1=nil) and (str2=nil) then exit(0);
 if(str1=nil) then exit(-1) else if(str2=nil) then exit(1);
 while((str1+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0) do inc(i);
 if((str1+i)^>(str2+i)^) then strcmp:=1
 else if((str1+i)^<(str2+i)^) then strcmp:=-1
 else strcmp:=0;
end;
function Wstrcmp(str1,str2:PwideChar):natint;[public,alias:'Wstrcmp'];
var i:natint;
begin
 i:=0;
 if(str1=nil) and (str2=nil) then exit(0);
 if(str1=nil) then exit(-1) else if(str2=nil) then exit(1);
 while((str1+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0) do inc(i);
 if((str1+i)^>(str2+i)^) then Wstrcmp:=1
 else if((str1+i)^<(str2+i)^) then Wstrcmp:=-1
 else Wstrcmp:=0;
end;
function strpartcmp(str1:PChar;position,length:natuint;str2:PChar):natint;[public,alias:'strpartcmp'];
var i,len:natuint;
begin
 i:=0; len:=strlen(str1);
 if(str1=nil) and (str2=nil) then exit(0);
 if(str1=nil) then exit(-1) else if(str2=nil) then exit(1);
 if(position+length-1>len) then
  begin
   while((str1+position+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0)
   and (i<len-position+1) do inc(i);
   if(i>=len-position+1) then strpartcmp:=0
   else if((str1+position+i)^<(str2+i)^) then strpartcmp:=-1
   else if((str1+position+i)^>(str2+i)^) then strpartcmp:=1
   else strpartcmp:=0;
  end
 else
  begin
   while((str1+position+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0)
   and (i<length) do inc(i);
   if(i>=length) then strpartcmp:=0
   else if((str1+position+i)^<(str2+i)^) then strpartcmp:=-1
   else if((str1+position+i)^>(str2+i)^) then strpartcmp:=1
   else strpartcmp:=0;
  end;
end;
function Wstrpartcmp(str1:PWideChar;position,length:natuint;str2:PWideChar):natint;[public,alias:'Wstrpartcmp'];
var i,len:natuint;
begin
 i:=0; len:=Wstrlen(str1);
 if(str1=nil) and (str2=nil) then exit(0);
 if(str1=nil) then exit(-1) else if(str2=nil) then exit(1);
 if(position+length-1>len) then
  begin
   while((str1+position+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0)
   and (i<len-position+1) do inc(i);
   if(i>=len-position+1) then Wstrpartcmp:=0
   else if((str1+position+i)^<(str2+i)^) then Wstrpartcmp:=-1
   else if((str1+position+i)^>(str2+i)^) then Wstrpartcmp:=1
   else Wstrpartcmp:=0;
  end
 else
  begin
   while((str1+position+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0)
   and (i<length) do inc(i);
   if(i>=length) then Wstrpartcmp:=0
   else if((str1+position+i)^<(str2+i)^) then Wstrpartcmp:=-1
   else if((str1+position+i)^>(str2+i)^) then Wstrpartcmp:=1
   else Wstrpartcmp:=0;
  end;
end;  
function strcmpL(str1,str2:Pchar):natint;[public,alias:'strcmpL'];
var i,len1,len2:natint;
begin
 i:=0; len1:=strlen(str1); len2:=strlen(str2);
 if(str1=nil) and (str2=nil) then exit(0);
 if(len1>len2) then exit(1) else if(len1<len2) then exit(-1);
 if(str1=nil) then exit(-1) else if(str2=nil) then exit(1);
 while((str1+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0) do inc(i);
 if((str1+i)^>(str2+i)^) then strcmpL:=1
 else if((str1+i)^<(str2+i)^) then strcmpL:=-1
 else strcmpL:=0;
end;
function WstrcmpL(str1,str2:PwideChar):natint;[public,alias:'WstrcmpL'];
var i,len1,len2:natint;
begin
 i:=0; len1:=Wstrlen(str1); len2:=Wstrlen(str2);
 if(str1=nil) and (str2=nil) then exit(0);
 if(len1>len2) then exit(1) else if(len1<len2) then exit(-1);
 if(str1=nil) then exit(-1) else if(str2=nil) then exit(1);
 while((str1+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0) do inc(i);
 if((str1+i)^>(str2+i)^) then WstrcmpL:=1
 else if((str1+i)^<(str2+i)^) then WstrcmpL:=-1
 else WstrcmpL:=0;
end;
function strpartcmpL(str1:PChar;position,length:natuint;str2:PChar):natint;[public,alias:'strpartcmpL'];
var i,len,sublen:natuint;
begin
 i:=0; len:=strlen(str1); sublen:=strlen(str2);
 if(str1=nil) and (str2=nil) then exit(0);
 if(str1=nil) then exit(-1) else if(str2=nil) then exit(1);
 if(position+length-1>len) then
  begin
   if(len-position+1>sublen) then exit(1) else if(len-position+1<sublen) then exit(-1);
   while((str1+position+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0)
   and (i<len-position+1) do inc(i);
   if(i>=len-position+1) then strpartcmpL:=0
   else if((str1+position+i)^<(str2+i)^) then strpartcmpL:=-1
   else if((str1+position+i)^>(str2+i)^) then strpartcmpL:=1
   else strpartcmpL:=0;
  end
 else
  begin
   if(length>sublen) then exit(1) else if(length<sublen) then exit(-1);
   while((str1+position+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0)
   and (i<length) do inc(i);
   if(i>=length) then strpartcmpL:=0
   else if((str1+position+i)^<(str2+i)^) then strpartcmpL:=-1
   else if((str1+position+i)^>(str2+i)^) then strpartcmpL:=1
   else strpartcmpL:=0;
  end;
end;
function WstrpartcmpL(str1:PWideChar;position,length:natuint;str2:PWideChar):natint;[public,alias:'WstrpartcmpL'];
var i,len,sublen:natuint;
begin
 i:=0; len:=Wstrlen(str1); sublen:=Wstrlen(str2);
 if(str1=nil) and (str2=nil) then exit(0);
 if(str1=nil) then exit(-1) else if(str2=nil) then exit(1);
 if(position+length-1>len) then
  begin
   if(len-position+1>sublen) then exit(1) else if(len-position+1<sublen) then exit(-1);
   while((str1+position+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0)
   and (i<len-position+1) do inc(i);
   if(i>=len-position+1) then WstrpartcmpL:=0
   else if((str1+position+i)^<(str2+i)^) then WstrpartcmpL:=-1
   else if((str1+position+i)^>(str2+i)^) then WstrpartcmpL:=1
   else WstrpartcmpL:=0;
  end
 else
  begin
   if(length>sublen) then exit(1) else if(length<sublen) then exit(-1);
   while((str1+position+i)^=(str2+i)^) and ((str1+i)^<>#0) and ((str2+i)^<>#0)
   and (i<length) do inc(i);
   if(i>=length) then WstrpartcmpL:=0
   else if((str1+position+i)^<(str2+i)^) then WstrpartcmpL:=-1
   else if((str1+position+i)^>(str2+i)^) then WstrpartcmpL:=1
   else WstrpartcmpL:=0;
  end;
end;
procedure strinit(var str:PChar;size:natuint);[public,alias:'strinit'];
begin
 str:=allocmem(sizeof(char)*(size+1));
end;
procedure wstrinit(var str:PWideChar;Size:natuint);[public,alias:'wstrinit'];
begin
 str:=allocmem(sizeof(WideChar)*(size+1));
end;
function strcreate(content:PChar):PChar;[public,alias:'strcreate'];
var i,len:natuint;
    res:PChar;
begin
 len:=strlen(content);
 res:=allocmem(sizeof(char)*(len+1));
 for i:=1 to len do (res+i-1)^:=(content+i-1)^;
 (res+len)^:=#0;
 strcreate:=res;
end;
function Wstrcreate(content:PWideChar):PWideChar;[public,alias:'wstrcreate'];
var i,len:natuint;
    res:PWideChar;
begin
 len:=Wstrlen(content);
 res:=allocmem(sizeof(WideChar)*(len+1));
 for i:=1 to len do (res+i-1)^:=(content+i-1)^;
 (res+len)^:=#0;
 Wstrcreate:=res;
end;
procedure strrealloc(var str:PChar;size:natuint);[public,alias:'strrealloc'];
begin
 ReallocMem(str,sizeof(char)*(size+1));
 (str+size)^:=#0;
end;
procedure Wstrrealloc(var str:PwideChar;size:natuint);[public,alias:'Wstrrealloc'];
begin
 ReallocMem(str,sizeof(WideChar)*(size+1));
 (str+size)^:=#0;
end;
procedure strset(var str:PChar;val:Pchar);[public,alias:'strset'];
var i:natuint;
begin
 i:=0;
 while((val+i)^<>#0) do
  begin
   (str+i)^:=(val+i)^; inc(i);
  end;
 (str+i)^:=#0;
end;
procedure wstrset(var str:PWideChar;val:Pwidechar);[public,alias:'Wstrset'];
var i:natuint;
begin
 i:=0;
 while((val+i)^<>#0) do
  begin
   (str+i)^:=(val+i)^; inc(i);
  end;
 (str+i)^:=#0;
end;
procedure strcat(var dest:PChar;src:PChar);[public,alias:'strcat'];
var i,len:natuint;
begin
 if(src=nil) then exit;
 len:=strlen(dest);
 for i:=1 to strlen(src) do
  begin
   (dest+len+i-1)^:=(src+i-1)^;
  end;
 (dest+len+strlen(src))^:=#0;
end;
procedure Wstrcat(var dest:PWideChar;src:PWideChar);[public,alias:'Wstrcat'];
var i,len:natuint;
begin
 if(src=nil) then exit;
 len:=Wstrlen(dest);
 for i:=1 to Wstrlen(src) do
  begin
   (dest+len+i-1)^:=(src+i-1)^;
  end;
 (dest+len+Wstrlen(src))^:=#0;
end;
procedure strfree(var str:PChar);[public,alias:'strfree'];
begin
 freemem(str); if(str<>nil) then str:=nil;
end;
procedure Wstrfree(var str:PWideChar);[public,alias:'Wstrfree'];
begin
 freemem(str); if(str<>nil) then str:=nil;
end;
procedure strUpperCase(var str:PChar);[public,alias:'strUpperCase'];
var i,len:natuint;
begin
 len:=strlen(str);
 for i:=1 to len do
  begin
   if(str^>='a') and (str^<='z') then str^:=Char(Byte(str^)-32);
  end;
end;
procedure strLowerCase(var str:PChar);[public,alias:'strLowerCase'];
var i,len:natuint;
begin
 len:=strlen(str);
 for i:=1 to len do
  begin
   if(str^>='A') and (str^<='Z') then str^:=Char(Byte(str^)+32);
  end;
end;
procedure WstrUpperCase(var str:PWideChar);[public,alias:'WstrUpperCase'];
var i,len:natuint;
begin
 len:=Wstrlen(str);
 for i:=1 to len do
  begin
   if(str^>='a') and (str^<='z') then str^:=WideChar(Word(str^)-32);
  end;
end;
procedure WstrLowerCase(var str:PWideChar);[public,alias:'WstrLowerCase'];
var i,len:natuint;
begin
 len:=Wstrlen(str);
 for i:=1 to len do
  begin
   if(str^>='A') and (str^<='Z') then str^:=WideChar(Word(str^)+32);
  end;
end;  
function strcopy(str:PChar;index,count:Natuint):Pchar;[public,alias:'strcopy'];
var newstr:PChar;
    i,len:natuint;
begin
 len:=strlen(str);
 if(index>len) then exit(nil);
 if(index+count-1>len) then
  begin
   strinit(newstr,len-index+1);
   for i:=1 to len-index+1 do
    begin
     (newstr+i-1)^:=(str+index-1+i-1)^;
    end;
   (newstr+len-index+1)^:=#0;
  end
 else
  begin
   strinit(newstr,count);
   for i:=1 to count do
    begin
     (newstr+i-1)^:=(str+index-1+i-1)^;
    end;
   (newstr+count)^:=#0;
  end;
 strcopy:=newstr;
end;
function Wstrcopy(str:PWideChar;index,count:Natuint):PWideChar;[public,alias:'Wstrcopy'];
var newstr:PWideChar;
    i,len:natuint;
begin
 len:=Wstrlen(str);
 if(index>len) then exit(nil);
 if(index+count-1>len) then
  begin
   Wstrinit(newstr,len-index+1);
   for i:=1 to len-index+1 do
    begin
     (newstr+i-1)^:=(str+index-1+i-1)^;
    end;
   (newstr+len-index+1)^:=#0;
  end
 else
  begin
   Wstrinit(newstr,count);
   for i:=1 to count do
    begin
     (newstr+i-1)^:=(str+index-1+i-1)^;
    end;
   (newstr+count)^:=#0;
  end;
 Wstrcopy:=newstr;
end;
function strcutout(str:PChar;left,right:Natuint):PChar;[public,alias:'strcutout'];
var newstr:Pchar;
    i,len:natuint;
begin
 len:=strlen(str); 
 if(left>len) or (left>right) then exit(nil);
 if(right<=len) then
  begin
   strinit(newstr,right-left+1);
   for i:=left to right do
    begin
     (newstr+i-left)^:=(str+i-1)^;
    end;
   (newstr+right-left+1)^:=#0;
  end
 else if(right>len) then
  begin
   strinit(newstr,len-left+1);
   for i:=left to len do
    begin
     (newstr+i-1)^:=(str+i-1)^;
    end;
   (newstr+len-left+1)^:=#0;
  end;
 strcutout:=newstr;
end;
function Wstrcutout(str:PWideChar;left,right:Natuint):PWideChar;[public,alias:'Wstrcutout'];
var newstr:PWidechar;
    i,len:natuint;
begin
 len:=Wstrlen(str); 
 if(left>len) or (left>right) then exit(nil);
 if(right<=len) then
  begin
   Wstrinit(newstr,right-left+1);
   for i:=left to right do
    begin
     (newstr+i-left)^:=(str+i-1)^;
    end;
   (newstr+right-left+1)^:=#0;
  end
 else if(right>len) then
  begin
   Wstrinit(newstr,len-left+1);
   for i:=left to len do
    begin
     (newstr+i-1)^:=(str+i-1)^;
    end;
   (newstr+len-left+1)^:=#0;
  end;
 Wstrcutout:=newstr;
end;
procedure strdelete(var str:PChar;index,count:Natuint);[public,alias:'strdelete'];
var i,len:natuint;
begin
 len:=strlen(str);
 for i:=index+count to len do
  begin
   (str+i-1-count)^:=(str+i-1)^;
   (str+i-1)^:=#0;
  end;
 (str+len-count)^:=#0;
end;
procedure Wstrdelete(var str:PWideChar;index,count:Natuint);[public,alias:'Wstrdelete'];
var i,len:natuint;
begin
 len:=Wstrlen(str);
 for i:=index+count to len do
  begin
   (str+i-1-count)^:=(str+i-1)^;
   (str+i-1)^:=#0;
  end;
 (str+len-count)^:=#0;
end;
procedure strdeleteinrange(var str:PChar;left,right:Natuint);[public,alias:'strdeleteinrange'];
var i,len,distance:natuint;
begin
 len:=strlen(str); distance:=right-left+1;
 for i:=right+1 to len do
  begin
   (str+i-1-distance)^:=(str+i-1)^;
   (str+i-1)^:=#0;
  end;
 (str+len-distance)^:=#0;
end;
procedure WStrdeleteinrange(var str:PWideChar;left,right:Natuint);[public,alias:'Wstrdeleteinrange'];
var i,len,distance:natuint;
begin
 len:=Wstrlen(str); distance:=right-left+1;
 for i:=right+1 to len do
  begin
   (str+i-1-distance)^:=(str+i-1)^;
   (str+i-1)^:=#0;
  end;
 (str+len-distance)^:=#0;
end;
procedure strinsert(var str:PChar;insertstr:PChar;index:natuint);[public,alias:'strinsert'];
var strlength,partlength,i:natuint;
begin
 strlength:=strlen(str);
 partlength:=strlen(insertstr);
 for i:=strlength downto index do
  begin
   (str+i-1+partlength)^:=(str+i-1)^;
  end;
 for i:=1 to partlength do
  begin
   (str+index-1+i-1)^:=(insertstr+i-1)^;
  end;
 (str+strlength+partlength)^:=#0;
end;
procedure Wstrinsert(var str:PWideChar;insertstr:PWideChar;index:natuint);[public,alias:'Wstrinsert'];
var strlength,partlength,i:natuint;
begin
 strlength:=Wstrlen(str);
 partlength:=Wstrlen(insertstr);
 for i:=strlength downto index do
  begin
   (str+i-1+partlength)^:=(str+i-1)^;
  end;
 for i:=1 to partlength do
  begin
   (str+index-1+i-1)^:=(insertstr+i-1)^;
  end;
 (str+strlength+partlength)^:=#0;
end;
function strpos(str,substr:PChar;start:Natuint):Natuint;[public,alias:'strpos'];
var i,mylen,mysublen:natuint;
    partstr:PChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=strlen(str)-strlen(substr)+1; mysublen:=strlen(substr);
 if(start>=mylen) then exit(0);
 i:=start;
 while(i<=mylen) do
  begin
   partstr:=strcopy(str,i,mysublen);
   if(strcmp(substr,partstr)=0) then 
    begin
     strfree(partstr); break;
    end;
   strfree(partstr);
   inc(i);
  end;
 if(i>mylen) then strpos:=0 else strpos:=i;
end;
function Wstrpos(str,substr:PWideChar;start:natuint):natuint;[public,alias:'Wstrpos'];
var i,mylen,mysublen:natuint;
    partstr:PWideChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=Wstrlen(str)-Wstrlen(substr)+1; mysublen:=Wstrlen(substr);
 if(start>mylen) then exit(0);
 i:=start;
 while(i<=mylen) do
  begin
   partstr:=Wstrcopy(str,i,mysublen);
   if(Wstrcmp(substr,partstr)=0) then 
    begin
     Wstrfree(partstr);
     break;
    end;
   Wstrfree(partstr);
   inc(i);
  end;
 if(i>mylen) then Wstrpos:=0 else Wstrpos:=i;
end;
function strposdir(str,substr:PChar;start:natuint;direction:shortint):natuint;[public,alias:'strposdir'];
var i,mylen,mysublen:natuint;
    partstr:PChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=strlen(str)-strlen(substr)+1; mysublen:=strlen(substr);
 if(start>mylen) and (direction=1) then exit(0);
 if(start<1) and (direction=-1) then exit(0);
 if(direction=1) then
  begin
   i:=start;
   while(i<=mylen) do 
    begin
     partstr:=strcopy(str,i,mysublen);
     if(strcmp(substr,partstr)=0) then 
      begin
       strfree(partstr);
       break;
      end;
     strfree(partstr);
     inc(i);
    end;
   if(i>mylen) then strposdir:=0 else strposdir:=i;
  end
 else if(direction=-1) then
  begin
   i:=start;
   while(i>=1) do
    begin
     partstr:=strcopy(str,i,mysublen);
     if(strcmp(substr,partstr)=0) then 
      begin
       strfree(partstr);
       break;
      end;
     strfree(partstr);
     dec(i);
    end;
   if(i=0) then strposdir:=0 else strposdir:=i;
  end
 else if(direction=0) then strposdir:=0;
end;
function Wstrposdir(str,substr:PWideChar;start:natuint;direction:shortint):natuint;[public,alias:'Wstrposdir'];
var i,mylen,mysublen:natuint;
    partstr:PWideChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=Wstrlen(str)-Wstrlen(substr)+1; mysublen:=Wstrlen(substr);
 if(start>mylen) and (direction=1) then exit(0);
 if(start<1) and (direction=-1) then exit(0);
 if(direction=1) then
  begin
   i:=start;
   while(i<=mylen) do 
    begin
     partstr:=Wstrcopy(str,i,mysublen);
     if(Wstrcmp(substr,partstr)=0) then 
      begin
       Wstrfree(partstr);
       break;
      end;
     Wstrfree(partstr);
     inc(i);
    end;
   if(i>mylen) then Wstrposdir:=0 else Wstrposdir:=i;
  end
 else if(direction=-1) then
  begin
   i:=start;
   while(i>=1) do
    begin
     partstr:=Wstrcopy(str,i,mysublen);
     if(Wstrcmp(substr,partstr)=0) then 
      begin
       Wstrfree(partstr);
       break;
      end;
     Wstrfree(partstr);
     dec(i);
    end;
   if(i=0) then Wstrposdir:=0 else Wstrposdir:=i;
  end
 else if(direction=0) then Wstrposdir:=0;
end;
function strposorder(str,substr:PChar;start,order:natuint):natuint;[public,alias:'strposorder'];
var i,forder,mylen,mysublen:natuint;
    partstr:Pchar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=strlen(str)-strlen(substr)+1; mysublen:=strlen(substr);
 if(start>mylen) then exit(0);
 if(order=0) then exit(0);
 i:=start; forder:=0;
 while(i<=mylen) do
  begin 
   partstr:=strcopy(str,i,mysublen);
   if(strcmp(substr,partstr)=0) then
    begin
     inc(forder);
     strfree(partstr);
     if(forder>=order) then break else inc(i,mysublen);
    end
   else 
    begin
     strfree(partstr);
     inc(i);
    end;
  end;
 if(i>mylen) then strposorder:=0 else strposorder:=i;
end;
function Wstrposorder(str,substr:PWideChar;start,order:natuint):natuint;[public,alias:'Wstrposorder'];
var i,forder,mylen,mysublen:natuint;
    partstr:PWideChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=Wstrlen(str)-Wstrlen(substr)+1; mysublen:=Wstrlen(substr);
 if(start>mylen) then exit(0);
 if(order=0) then exit(0);
 i:=start; forder:=0;
 while(i<=mylen) do
  begin 
   partstr:=Wstrcopy(str,i,mysublen);
   if(Wstrcmp(substr,partstr)=0) then
    begin
     inc(forder);
     Wstrfree(partstr);
     if(forder>=order) then break else inc(i,mysublen);
    end
   else 
    begin
     Wstrfree(partstr);
     inc(i);
    end;
  end;
 if(i>mylen) then Wstrposorder:=0 else Wstrposorder:=i;
end;
function strposdirorder(str,substr:PChar;start,order:natuint;direction:shortint):natuint;[public,alias:'strposdirorder'];
var i,forder,mylen,mysublen:natuint;
    partstr:PChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=strlen(str)-strlen(substr)+1; mysublen:=strlen(substr);
 if(start>mylen) and (direction=1) then exit(0);
 if(start<1) and (direction=-1) then exit(0);
 if(direction=0) then exit(0);
 if(order=0) then exit(0);
 i:=start; forder:=0;
 if(direction=1) then
  begin
   while(i<=mylen) do
    begin
     partstr:=strcopy(str,i,mysublen);
     if(strcmp(substr,partstr)=0) then
      begin
       inc(forder);
       strfree(partstr);
       if(forder>=order) then break else inc(i,mysublen);
      end
     else 
      begin
       strfree(partstr);
       inc(i);
      end;
    end;
   if(i>mylen) then strposdirorder:=0 else strposdirorder:=i;
  end
 else if(direction=-1) then
  begin
   while(i>=1) do
    begin
     partstr:=strcopy(str,i,mysublen);
     if(strcmp(substr,partstr)=0) then
      begin
       inc(forder);
       strfree(partstr);
       if(forder>=order) then break else dec(i,mysublen);
      end
     else 
      begin
       strfree(partstr);
       dec(i);
      end;
    end;
   if(i=0) then strposdirorder:=0 else strposdirorder:=i;
  end;
end;
function Wstrposdirorder(str,substr:PWideChar;start,order:natuint;direction:shortint):natuint;[public,alias:'Wstrposdirorder'];
var i,forder,mylen,mysublen:natuint;
    partstr:PWideChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=Wstrlen(str)-Wstrlen(substr)+1; mysublen:=Wstrlen(substr);
 if(start>mylen) and (direction=1) then exit(0);
 if(start<1) and (direction=-1) then exit(0);
 if(direction=0) then exit(0);
 if(order=0) then exit(0);
 i:=start; forder:=0;
 if(direction=1) then
  begin
   while(i<=mylen) do
    begin
     partstr:=Wstrcopy(str,i,mysublen);
     if(Wstrcmp(substr,partstr)=0) then
      begin
       inc(forder);
       Wstrfree(partstr);
       if(forder>=order) then break else inc(i,mysublen);
      end
     else 
      begin
       Wstrfree(partstr);
       inc(i);
      end;
    end;
   if(i>mylen) then Wstrposdirorder:=0 else Wstrposdirorder:=i;
  end
 else if(direction=-1) then
  begin
   while(i>=1) do
    begin
     partstr:=Wstrcopy(str,i,mysublen);
     if(Wstrcmp(substr,partstr)=0) then
      begin
       inc(forder);
       Wstrfree(partstr);
       if(forder>=order) then break else dec(i,mysublen);
      end
     else 
      begin
       Wstrfree(partstr);
       dec(i);
      end;
    end;
   if(i=0) then Wstrposdirorder:=0 else Wstrposdirorder:=i;
  end;
end;
function strcount(str,substr:PChar;start:Natuint):natuint;[public,alias:'strcount'];
var i,len1,len2,res:natuint;
    partstr:PChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 len1:=strlen(str); len2:=strlen(substr);
 if(len1=0) or (len2=0) then res:=0
 else if(len2>len1) then
  begin
   res:=0;
  end
 else if(len2=len1) then
  begin
   if(start>1) then res:=0
   else 
    begin
     if(StrCmp(str,substr)=0) then res:=1 else res:=0;
    end;
  end
 else
  begin
   res:=0; i:=start;
   while(i<=len1-len2+1) do
    begin
     partstr:=strcopy(str,i,len2);
     if(StrCmp(substr,partstr)=0) then 
      begin
       strfree(partstr); inc(i,len2); inc(res);
      end
     else 
      begin
       strfree(partstr); inc(i);
      end;
    end;
  end;
 strcount:=res;
end;
function Wstrcount(str,substr:PWideChar;start:Natuint):natuint;[public,alias:'Wstrcount'];
var i,len1,len2,res:natuint;
    partstr:PWideChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 len1:=Wstrlen(str); len2:=Wstrlen(substr);
 if(len1=0) or (len2=0) then res:=0
 else if(len2>len1) then
  begin
   res:=0;
  end
 else if(len2=len1) then
  begin
   if(start>1) then res:=0
   else 
    begin
     if(WStrCmp(str,substr)=0) then res:=1 else res:=0;
    end;
  end
 else
  begin
   res:=0; i:=start;
   while(i<=len1-len2+1) do
    begin
     partstr:=Wstrcopy(str,i,len2);
     if(WStrCmp(substr,partstr)=0) then 
      begin
       Wstrfree(partstr); inc(i,len2); inc(res);
      end
     else 
      begin
       Wstrfree(partstr); inc(i);
      end;
    end;
  end;
 Wstrcount:=res;
end;
function strposinverse(str,substr:PChar;start:Natuint):Natuint;[public,alias:'strposinverse'];
var i,mylen,mysublen:natuint;
    partstr:Pchar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=strlen(str)-strlen(substr)+1; i:=mylen; mysublen:=strlen(substr);
 while(i>=start) do
  begin
   partstr:=strcopy(str,i,mysublen);
   if(strcmp(substr,partstr)=0) then 
    begin
     strfree(partstr);
     break;
    end;
   strfree(partstr);
   dec(i);
  end;
 if(i<start) then strposinverse:=0 else strposinverse:=i;
end;
function Wstrposinverse(str,substr:PWideChar;start:natuint):natuint;[public,alias:'Wstrposinverse'];
var i,mylen,mysublen:natuint;
    partstr:PWideChar;
begin
 if(str=nil) or (substr=nil) then exit(0);
 mylen:=Wstrlen(str)-Wstrlen(substr)+1; i:=mylen; mysublen:=Wstrlen(substr);
 while(i>=start) do
  begin
   partstr:=Wstrcopy(str,i,mysublen);
   if(Wstrcmp(substr,partstr)=0) then 
    begin
     Wstrfree(partstr);
     break;
    end;
   Wstrfree(partstr);
   dec(i);
  end;
 if(i<start) then Wstrposinverse:=0 else Wstrposinverse:=i;
end;
function PCharToPWChar(orgstr:PChar):PWideChar;[public,alias:'PCharToPWChar'];
var res:PWideChar;
    len,i:natuint;
begin
  len:=strlen(orgstr); i:=1;
  Wstrinit(res,len);
  while(i<=len+1) do
   begin
    (res+i-1)^:=WideChar(Word((orgstr+i-1)^)); inc(i);
   end;
  PCharToPWChar:=res;
end;
function PWCharToPChar(orgstr:PWideChar):PChar;[public,alias:'PWCharToPChar'];
var res:PChar;
    len,i:natuint;
begin
  len:=Wstrlen(orgstr); i:=1;
  strinit(res,len);
  while(i<=len+1) do
   begin
    (res+i-1)^:=Char(Byte((orgstr+i-1)^)); inc(i);
   end;
  PWCharToPChar:=res;
end;
function PCharIsInt(str:PChar):boolean;[public,alias:'PCharIsInt'];
const numchar:PChar='0123456789';
var i,j,len:natuint;
begin
 len:=strlen(str);
 for i:=1 to len do
  begin
   j:=0;
   while(j<=9) do if((str+i-1)^=(numchar+j)^) then break else inc(j);
   if(j>9) then break;
  end;
 if(j>9) then PCharIsInt:=false else PCharIsInt:=true;
end;
function PWCharIsInt(str:PWideChar):boolean;[public,alias:'PWCharIsInt'];
const numchar:PWideChar='0123456789';
var i,j,len:natuint;
begin
 len:=Wstrlen(str);
 for i:=1 to len do
  begin
   j:=0;
   while(j<=9) do if((str+i-1)^=(numchar+j)^) then break else inc(j);
   if(j>9) then break;
  end;
 if(j>9) then PWCharIsInt:=false else PWCharIsInt:=true;
end;
function IntToPChar(Int:natint):PChar;
const numchar:PChar='0123456789';
var negative:boolean;
    tempnum1,tempnum2:Natuint;
    numlength,i,starti,endi:byte;
    res:PChar;
begin
 if(Int>=0) then
  begin
   negative:=false; tempnum1:=int;
  end
 else
  begin
   negative:=true; tempnum1:=-int;
  end;
 numlength:=0; tempnum2:=1;
 while(tempnum2<=tempnum1)do
  begin
   tempnum2:=tempnum2 shl 3+tempnum2 shl 1;
   inc(numlength);
  end;
 tempnum2:=tempnum2 shr 1 div 5;
 if(negative)then
  begin
   res:=allocmem(numlength+2); starti:=2; endi:=numlength+1; res^:='-';
  end
 else if(Int=0) then
  begin
   res:=allocmem(2); res^:='0'; exit(res);
  end
 else
  begin
   res:=allocmem(numlength+1); starti:=1; endi:=numlength;
  end;
 i:=starti;
 while(i<=endi)do
  begin
   (res+i-1)^:=(numchar+tempnum1 div tempnum2)^;
   tempnum1:=tempnum1 mod tempnum2;
   tempnum2:=tempnum2 shr 1 div 5;
   inc(i);
  end;
 IntToPChar:=res;
end;
function UintToPChar(UInt:Natuint):Pchar;
const numchar:PChar='0123456789';
var tempnum1,tempnum2:natuint;
    numlength,i:byte;
    res:PChar;
begin
 tempnum1:=Uint; tempnum2:=1; numlength:=0;
 while(tempnum2<=tempnum1)do
  begin
   tempnum2:=tempnum2 shl 3+tempnum2 shl 1;
   inc(numlength);
  end;
 tempnum2:=tempnum2 shr 1 div 5;
 if(UInt=0) then
  begin
   res:=allocmem(2); res^:='0'; exit(res);
  end
 else res:=allocmem(numlength+1);
 i:=1;
 while(i<=numlength)do
  begin
   (res+i-1)^:=(numchar+tempnum1 div tempnum2)^;
   tempnum1:=tempnum1 mod tempnum2;
   tempnum2:=tempnum2 shr 1 div 5;
   inc(i);
  end;
 UintToPChar:=res;
end;
function ExtendedToPChar(Ext:Extended;decimal:word):PChar;
const numchar:PChar='0123456789';
var negative:boolean;
    tempnum1,tempnum2,intpart,decpart:extended;
    intstr,decstr:PChar;
    i,intlen,declen:word;
    res:PChar;
begin
 if(Ext>=0) then
  begin
   negative:=false; decpart:=frac(Ext); intpart:=Ext-decpart;
  end
 else
  begin
   negative:=true; decpart:=frac(-Ext); intpart:=(-Ext)-decpart;
  end;
 intstr:=allocmem(512); tempnum1:=1; intlen:=0;
 while(tempnum1<=intpart)do
  begin
   tempnum1:=tempnum1*10;
   inc(intlen);
  end;
 if(intlen=0) then intstr^:='0'; 
 tempnum1:=tempnum1/10; i:=1;
 while(i<=intlen)do
  begin
   (intstr+i-1)^:=(numchar+floor(intpart/tempnum1))^;
   intpart:=intpart-floor(intpart/tempnum1)*tempnum1;
   tempnum1:=tempnum1/10;
   inc(i);
  end;
 decstr:=allocmem(512); tempnum2:=1; declen:=decimal; i:=1;
 while(i<=decimal)do
  begin
   tempnum2:=tempnum2*10; decpart:=decpart*10; inc(i);
  end;
 tempnum2:=tempnum2/10; i:=1;
 while(i<=declen)do
  begin
   (decstr+i-1)^:=(numchar+floor(decpart/tempnum2))^;
   decpart:=decpart-floor(decpart/tempnum2)*tempnum2;
   tempnum2:=tempnum2/10;
   inc(i);
  end;
 res:=allocmem(1024);
 if(negative) then res^:='-';
 StrCat(res,intstr);
 if(decimal>0) then
  begin
   StrCat(res,'.');
   StrCat(res,decstr);
  end;
 FreeMem(intstr); FreeMem(decstr);
 ExtendedToPChar:=res;
end;
function IntToHex(Int:natuint):PChar;
const hexchar:PChar='0123456789ABCDEF';
var tempnum1,tempnum2:Natuint;
    hexlen,i:byte;
    res:PChar;
begin
 hexlen:=0; tempnum1:=Int; tempnum2:=1; i:=1;
 while(tempnum2<=tempnum1)do
  begin
   tempnum2:=tempnum2 shl 4; inc(hexlen);
  end;
 if(tempnum2 shl 4<>0) and (tempnum2 shr 4<>0) then tempnum2:=tempnum2 shr 4;
 res:=allocmem(17);
 while(i<=hexlen)do
  begin
   (res+i-1)^:=(hexchar+tempnum1 div tempnum2)^;
   tempnum1:=tempnum1-(tempnum1 div tempnum2)*tempnum2;
   tempnum2:=tempnum2 shr 4;
   inc(i);
  end;
 if(Int=0) then
  begin
   res^:='0';
  end;
 IntToHex:=res;
end;
function PCharToInt(str:PChar):natint;
const numchar:PChar='0123456789';
var negative:boolean;
    i,j,len:byte;
    res:natint;
begin
 len:=strlen(str); res:=0;
 if(len>0) and (str^='-') then
  begin
   negative:=true; i:=2;
  end
 else
  begin
   negative:=false; i:=1;
  end;
 while(i<=len)do
  begin
   j:=0;
   while(j<10)do
    begin
     if((str+i-1)^=(numchar+j-1)^) then break;
     inc(j);
    end;
   if(j=10) then break;
   res:=res*10+j;
   inc(i);
  end;
 if(negative) then PCharToInt:=-res else PCharToInt:=res;
end;
function PCharToUInt(str:PChar):natuint;
const numchar:PChar='0123456789';
var i,j,len:byte;
    res:natuint;
begin
 i:=1; len:=strlen(str); res:=0;
 while(i<=len)do
  begin
   j:=0;
   while(j<10)do
    begin
     if((str+i-1)^=(numchar+j-1)^) then break;
     inc(j);
    end;
   if(j=10) then break;
   res:=res*10+j;
   inc(i);
  end;
 PCharToUint:=res;
end;
function PCharToExtended(str:PChar):Extended;
const numchar:PChar='0123456789';
var negative,decbool:boolean;
    intpart,decpart:extended;
    i,k,len:word;
    j:byte;
begin
 len:=strlen(str);
 if(len>0) and (str^='-') then
  begin
   negative:=true; i:=2;
  end
 else
  begin
   negative:=false; i:=1;
  end;
 intpart:=0; decpart:=0; decbool:=false;
 while(i<=len)do
  begin
   if((str+i-1)^='.') then
    begin
     inc(i); k:=i; decbool:=true; continue;
    end
   else
    begin
     j:=0;
     while(j<10)do
      begin
       if((str+i-1)^=(numchar+j-1)^) then break;
       inc(j);
      end;
     if(j=10) then break;
     if(decbool) then
      begin
       decpart:=decpart+j/IntPower(10,i-k);
      end
     else
      begin
       intpart:=intpart*10+j;
      end;
    end;
   inc(i);
  end;
 if(negative=false) then PCharToExtended:=intpart+decpart
 else PCharToExtended:=-(intpart+decpart);
end;
function HexToInt(Hex:PChar):natuint;
const hexchar1:PChar='0123456789ABCDEF';
      hexchar2:PChar='0123456789abcdef';
var i,j,len:byte;
    res:natuint;
begin
 i:=1; len:=strlen(Hex); res:=0;
 while(i<=len)do
  begin
   j:=0;
   while(j<16)do
    begin
     if((hex+i-1)^=(hexchar1+j)^) then break;
     if((hex+i-1)^=(hexchar2+j)^) then break;
     inc(j);
    end;
   if(j=16) then break;
   res:=res shl 4+j;
   inc(i);
  end;
 HexToInt:=res;
end;
function IntToPWChar(Int:natint):PWideChar;
const numchar:PWideChar='0123456789';
var negative:boolean;
    tempnum1,tempnum2:Natuint;
    numlength,i,starti,endi:byte;
    res:PWideChar;
begin
 if(Int>=0) then
  begin
   negative:=false; tempnum1:=int;
  end
 else
  begin
   negative:=true; tempnum1:=-int;
  end;
 numlength:=0; tempnum2:=1;
 while(tempnum2<=tempnum1)do
  begin
   tempnum2:=tempnum2 shl 3+tempnum2 shl 1;
   inc(numlength);
  end;
 tempnum2:=tempnum2 shr 1 div 5;
 if(negative) then
  begin
   res:=allocmem((numlength+2)*sizeof(WideChar)); starti:=2; endi:=numlength+1; res^:='-';
  end
 else if(Int=0) then
  begin
   res:=allocmem(2*sizeof(WideChar)); res^:='0'; exit(res);
  end
 else
  begin
   res:=allocmem((numlength+1)*sizeof(WideChar)); starti:=1; endi:=numlength;
  end;
 i:=starti;
 while(i<=endi)do
  begin
   (res+i-1)^:=(numchar+tempnum1 div tempnum2)^;
   tempnum1:=tempnum1 mod tempnum2;
   tempnum2:=tempnum2 shr 1 div 5;
   inc(i);
  end;
 IntToPWChar:=res;
end;
function UintToPWChar(UInt:Natuint):PWideChar;
const numchar:PWideChar='0123456789';
var tempnum1,tempnum2:natuint;
    numlength,i:byte;
    res:PWideChar;
begin
 tempnum1:=Uint; tempnum2:=1; numlength:=0;
 while(tempnum2<=tempnum1)do
  begin
   tempnum2:=tempnum2 shl 3+tempnum2 shl 1;
   inc(numlength);
  end;
 tempnum2:=tempnum2 shr 1 div 5;
 if(UInt=0) then
  begin
   res:=allocmem(2*sizeof(WideChar)); res^:='0'; exit(res);
  end
 else res:=allocmem((numlength+1)*sizeof(WideChar));
 i:=1;
 while(i<=numlength)do
  begin
   (res+i-1)^:=(numchar+tempnum1 div tempnum2)^;
   tempnum1:=tempnum1 mod tempnum2;
   tempnum2:=tempnum2 shr 1 div 5;
   inc(i);
  end;
 UintToPWChar:=res;
end;
function ExtendedToPWChar(Ext:Extended;decimal:word):PWideChar;
const numchar:PWideChar='0123456789';
var negative:boolean;
    tempnum1,tempnum2,intpart,decpart:extended;
    intstr,decstr:PWideChar;
    i,intlen,declen:word;
    res:PWideChar;
begin
 if(Ext>=0) then
  begin
   negative:=false; decpart:=frac(Ext); intpart:=Ext-decpart;
  end
 else
  begin
   negative:=true; decpart:=frac(-Ext); intpart:=(-Ext)-decpart;
  end;
 intstr:=allocmem(1024); tempnum1:=1; intlen:=0;
 while(tempnum1<=intpart)do
  begin
   tempnum1:=tempnum1*10;
   inc(intlen);
  end;
 if(intlen=0) then intstr^:='0'; 
 tempnum1:=tempnum1/10; i:=1;
 while(i<=intlen)do
  begin
   (intstr+i-1)^:=(numchar+floor(intpart/tempnum1))^;
   intpart:=intpart-floor(intpart/tempnum1)*tempnum1;
   tempnum1:=tempnum1/10;
   inc(i);
  end;
 decstr:=allocmem(1024); tempnum2:=1; declen:=decimal; i:=1;
 while(i<=decimal)do
  begin
   tempnum2:=tempnum2*10; decpart:=decpart*10; inc(i);
  end;
 tempnum2:=tempnum2/10; i:=1;
 while(i<=declen)do
  begin
   (decstr+i-1)^:=(numchar+floor(decpart/tempnum2))^;
   decpart:=decpart-floor(decpart/tempnum2)*tempnum2;
   tempnum2:=tempnum2/10;
   inc(i);
  end;
 res:=allocmem(2048);
 if(negative) then res^:='-';
 WStrCat(res,intstr);
 if(decimal>0) then
  begin
   WStrCat(res,'.');
   WStrCat(res,decstr);
  end;
 FreeMem(intstr); FreeMem(decstr);
 ExtendedToPWChar:=res;
end;
function IntToWHex(Int:natuint):PWideChar;
const Hexchar:PWideChar='0123456789ABCDEF';
var tempnum1,tempnum2:Natuint;
    Hexlen,i:byte;
    res:PWideChar;
begin
 Hexlen:=0; tempnum1:=Int; tempnum2:=1; i:=1;
 while(tempnum2<=tempnum1)do
  begin
   tempnum2:=tempnum2 shl 4; inc(Hexlen);
  end;
 if(tempnum2 shl 4<>0) and (tempnum2 shr 4<>0) then tempnum2:=tempnum2 shr 4;
 res:=allocmem(34);
 while(i<=Hexlen)do
  begin
   (res+i-1)^:=(Hexchar+tempnum1 div tempnum2)^;
   tempnum1:=tempnum1-(tempnum1 div tempnum2)*tempnum2;
   tempnum2:=tempnum2 shr 4;
   inc(i);
  end;
 if(Int=0) then res^:='0';
 IntToWHex:=res;
end;
function PWCharToInt(str:PWideChar):natint;
const numchar:PWideChar='0123456789';
var negative:boolean;
    i,j,len:byte;
    res:natint;
begin
 len:=Wstrlen(str); res:=0;
 if(len>0) and (str^='-') then
  begin
   negative:=true; i:=2;
  end
 else
  begin
   negative:=false; i:=1;
  end;
 while(i<=len)do
  begin
   j:=0;
   while(j<10)do
    begin
     if((str+i-1)^=(numchar+j-1)^) then break;
     inc(j);
    end;
   if(j=10) then break;
   res:=res*10+j;
   inc(i);
  end;
 if(negative) then PWCharToInt:=-res else PWCharToInt:=res;
end;
function PWCharToUInt(str:PWideChar):natuint;
const numchar:PWideChar='0123456789';
var i,j,len:byte;
    res:natuint;
begin
 i:=1; len:=Wstrlen(str); res:=0;
 while(i<=len)do
  begin
   j:=0;
   while(j<10)do
    begin
     if((str+i-1)^=(numchar+j-1)^) then break;
     inc(j);
    end;
   if(j=10) then break;
   res:=res*10+j;
   inc(i);
  end;
 PWCharToUint:=res;
end;
function PWCharToExtended(str:PWideChar):Extended;
const numchar:PWideChar='0123456789';
var negative,decbool:boolean;
    intpart,decpart:extended;
    i,k,len:word;
    j:byte;
begin
 len:=Wstrlen(str);
 if(len>0) and (str^='-') then
  begin
   negative:=true; i:=2;
  end
 else
  begin
   negative:=false; i:=1;
  end;
 intpart:=0; decpart:=0; decbool:=false;
 while(i<=len)do
  begin
   if((str+i-1)^='.') then
    begin
     inc(i); k:=i; decbool:=true; continue;
    end
   else
    begin
     j:=0;
     while(j<10)do
      begin
       if((str+i-1)^=(numchar+j-1)^) then break;
       inc(j);
      end;
     if(j=10) then break;
     if(decbool) then
      begin
       decpart:=decpart+j/IntPower(10,i-k);
      end
     else
      begin
       intpart:=intpart*10+j;
      end;
    end;
   inc(i);
  end;
 if(negative=false) then PWCharToExtended:=intpart+decpart
 else PWCharToExtended:=-(intpart+decpart);
end;
function WHexToInt(Hex:PWideChar):natuint;
const Hexchar1:PWideChar='0123456789ABCDEF';
      Hexchar2:PWideChar='0123456789abcdef';
var i,j,len:byte;
    res:natuint;
begin
 i:=1; len:=Wstrlen(Hex); res:=0;
 while(i<=len)do
  begin
   j:=0;
   while(j<16)do
    begin
     if((Hex+i-1)^=(Hexchar1+j)^) then break;
     if((Hex+i-1)^=(Hexchar2+j)^) then break;
     inc(j);
    end;
   if(j=16) then break;
   res:=res shl 4+j;
   inc(i);
  end;
 WHexToInt:=res;
end;
procedure randomize(seed_data:Pointer;seed_data_size:natuint);[public,alias:'randomize'];
var i:natuint;
    ptr:Pbyte;
begin
 ptr:=PByte(seed_data);
 ranseed:=0;
 for i:=1 to seed_data_size do
  begin
   if(i mod 7=1) then ranseed:=ranseed+(ptr+i-1)^*7+21
   else if(i mod 7=2) then ranseed:=ranseed-(ptr+i-1)^*6-18
   else if(i mod 7=3) then ranseed:=ranseed+(ptr+i-1)^*5+16
   else if(i mod 7=4) then ranseed:=ranseed-(ptr+i-1)^*4-13
   else if(i mod 7=5) then ranseed:=ranseed+(ptr+i-1)^*3+10
   else if(i mod 7=6) then ranseed:=ranseed-(ptr+i-1)^*2-8
   else ranseed:=ranseed+(ptr+i-1)^+5;
  end;
end;
function random(maxnum:extended):extended;[public,alias:'random'];
begin
 random:=maxnum*(ranseed/maxnatuint)*0.55;
 ranseed:=ranseed*2+7;
end;
function random_range(left,right:extended):extended;[public,alias:'random_range'];
begin
 random_range:=left+(right-left)*(ranseed/maxnatuint)*0.52;
 ranseed:=ranseed*2+7;
end;
function irandom(maxnum:natuint):natint;[public,alias:'irandom'];
begin
 irandom:=floor(maxnum*(ranseed/maxnatuint)*0.57);
 ranseed:=ranseed*2+7;
end;
function irandom_range(left,right:natint):natint;[public,alias:'irandom_range'];
begin
 irandom_range:=floor(left+(right-left)*(ranseed/maxnatuint)*0.54);
 ranseed:=ranseed*2+7;
end;

end.

