unit system;

interface 

{$MODE ObjFPC}{$H+}
{$modeswitch advancedrecords}

{Header for system.pas,or the compliation will fail.}
type hresult = LongInt;
     DWord = LongWord;
     Cardinal = LongWord;
     UInt64 = QWord;
     TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkSet,
    tkMethod, tkSString, tkLString, tkAString, tkWString, tkVariant, tkArray,
    tkRecord, tkInterface, tkClass, tkObject, tkWChar, tkBool, tkInt64, tkQWord,
    tkDynArray, tkInterfaceRaw, tkProcVar, tkUString, tkUChar, tkHelper, tkFile,
    tkClassRef, tkPointer);
  PTypeKind=^TTypekind;
  TSystemCodePage=word;
  TTypeInfo=packed record
            Kind:TTypeKind;
            Unused:ShortString;
            end;
  PTypeInfo=^TTypeInfo;
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
    case Byte of
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
{End System.pas Headers}
type Bit=0..1;
     PByte=^Byte;
     PWord=^word;
     PDword=^Dword;
     Pqword=^Qword;
     Psmallint=^smallint;
     Pshortint=^shortint;
     PInteger=^Integer;
     PInt64=^Int64;
     Char=#0..#255;
     UnicodeChar=packed record
                 case Boolean of
                 True:(achar:Char;);
                 False:(WChar:WideChar;);
                 end;
     PChar=^char;
     PAnsiChar=^AnsiChar;
     PWideChar=^WideChar;
     PUnicodeChar=^UnicodeChar;
{$IF Defined(CPU16)}
     Integer=-$7FFF..$7FFF;
     UnsignedInteger=0..$FFFF;
     Natint=-$7FFF..$7FFF;
     Natuint=0..$FFFF;
{$ELSEIF Defined(CPU32)}
     Integer=-$7FFFFFFF..$7FFFFFFF;
     UnsignedInteger=0..$FFFFFFFF;
     Natint=Integer;
     Natuint=UnsignedInteger;
{$ELSE Defined(CPU64)}
     Integer=-$7FFFFFFF..$7FFFFFFF;
     UnsignedInteger=0..$FFFFFFFF;
     Natint=-$7FFFFFFFFFFFFFFF..$7FFFFFFFFFFFFFFF;
     Natuint=0..$7FFFFFFFFFFFFFFF+$7FFFFFFFFFFFFFFF;
{$ENDIF}
     PNatint=^Natint;
     PNatuint=^Natuint;
     Pboolean=^boolean;
     PPointer=^Pointer;
     PPChar=^Char;
     PPWideChar=^WideChar;
     Int96=packed record
            low11:array[1..11] of byte;
            high1:smallint;
            end;
     PInt96=^Int96;
     UInt96=packed record
             low15:array[1..11] of byte;
             high1:byte;
             end;
     PUint96=^Uint96;
     Int128=packed record
            low15:array[1..15] of byte;
            high1:smallint;
            end;
     PInt128=^Int128;
     UInt128=packed record
             low15:array[1..15] of byte;
             high1:byte;
             end;
     PUint128=^Uint128;
     heap_record_item=bitpacked record
                      Left:0..1;
                      RequestLevel:0..1;
                      Allocated:0..31;
                      Right:0..1;
                      end;
     Pheap_record_item=^heap_record_item;
     heap_record_portion=packed record
                         startaddress:Pheap_record_item;
                         endaddress:Pointer;
                         ItemEnd:Natuint;
                         blockpower:byte;
                         RestSize:Natuint;
                         end;
     Pheap_record_portion=^heap_record_portion;
     heap_record=packed record
                 heap:Pheap_record_portion;
                 heapcount:byte;
                 end;
{Then Object Free Pascal Specified}
     dynamic_array_stub=array of byte;
     dynamic_array_header=packed record
                          ReferenceCount:Natint;
                          ArrayHighest:Natint;
                          ItemSize:Natint;
                          end;
     Pdynamic_array_header=^dynamic_array_header;
     string_header=packed record
                   ReferenceCount:Natint;
                   ArrayHighest:Natuint;
                   end;
     Pstring_header=^string_header;
     RawByteString=ansistring;
     Pshortstring=^shortstring;
     PVmt=^TVmt;
     PPVmt=^PVmt;
     TVmt = record
         vInstanceSize: Natint;
         vInstanceSize2: Natint;
         vParentRef: PPVmt;
         vClassName: Pointer;
         vDynamicTable: Pointer;
         vMethodTable: Pointer;
         vFieldTable: Pointer;
         vTypeInfo: Pointer;
         vInitTable: Pointer;
         vAutoTable: Pointer;
         vIntfTable: Pointer;
         vMsgStrPtr: Pointer;
         vDestroy: Pointer;
         vNewInstance: Pointer;
         vFreeInstance: Pointer;
         vSafeCallException: Pointer;
         vDefaultHandler: Pointer;
         vAfterConstruction: Pointer;
         vBeforeDestruction: Pointer;
         vDefaultHandlerStr: Pointer;
         vDispatch: Pointer;
         vDispatchStr: Pointer;
         vEquals: Pointer;
         vGetHashCode: Pointer;
         vToString: Pointer;
         private
         function GetvParent: PVmt;
         public
         property vParent: PVmt read GetvParent;
         end; 
    PInterfaceTable=Pointer;
    PStringMessageTable=Pointer;
    TObject=class
            public
            constructor Create;
            destructor Destroy;
            function NewInstance:Tobject;
            procedure FreeInstance;
            procedure Free;
            procedure CleanupInstance;
            procedure AfterConstruction;
            procedure BeforeDestruction;
            function GetObjectSize:NatInt;
            private
            property ObjectSize:NatInt read GetObjectSize;
            end;
     
const pi:extended=3.1415926535;
      maxextended:extended=1.7E308;
      minextended:extended=-1.7E308;

var sysheap:heap_record;
    sysheap_portion:array[1..11] of heap_record_portion;
    
procedure fpc_specific_handler;compilerproc;
procedure fpc_handleerror;compilerproc;
procedure fpc_lib_exit;compilerproc;
procedure fpc_libinitializeunits;compilerproc;
procedure fpc_initializeunits;compilerproc;
procedure fpc_finalizeunits;compilerproc;
procedure fpc_do_exit;compilerproc;
procedure fpc_div_by_zero;compilerproc;
function fpc_setjmp(var s:jmp_buf):Integer;compilerproc;
function fpc_pushexceptaddr(FormatType:Integer;Buffer,NewAddress:Pointer):Pjmp_buf;compilerproc;
procedure fpc_popaddrstack;compilerproc;
procedure fpc_reraise;compilerproc;
procedure fpc_raise_nested;compilerproc;
procedure fpc_doneexception;compilerproc;
function replace_divide(x:natuint;y:natuint):Natuint;
function replace_modulo(x:natuint;y:natuint):Natuint;
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
function sinh(x:extended):extended;
function cosh(x:extended):extended;
function tanh(x:extended):extended;
function coth(x:extended):extended;
function sech(x:extended):extended;
function csch(x:extended):extended;
function fpc_getmem(size:Natuint):Pointer;compilerproc;
procedure fpc_freemem(var ptr:Pointer);compilerproc;
procedure fpc_move(const Source;var Dest;Size:Natuint);compilerproc;
function heap_initialize(startaddress,endaddress:Pointer;heapbasepower,heapstep,heapmemstep,heapcount:byte):heap_record;
function getmem(size:Natuint):Pointer;
function allocmem(size:Natuint):Pointer;
function getmemsize(ptr:Pointer):Natuint;
procedure freemem(var ptr:Pointer);  
procedure reallocmem(var ptr:Pointer;size:Natuint);
procedure move(Const Source;Var Dest;Size:Natuint);
procedure FillByte(Var Dest;Size:Natuint;Data:byte);
procedure FillChar(Var Dest;Size:Natuint;Data:char);
procedure fpc_initialize(Data,TypeInfo:Pointer);compilerproc;
procedure fpc_finalize(Data,TypeInfo:Pointer);compilerproc;
procedure fpc_dynarray_assign(var Dest:Pointer;Source:Pointer;TypeInfo:Pointer);compilerproc;
function fpc_dynarray_copy(Source:Pointer;TypeInfo:Pointer;LowIndex,Count:Natint):dynamic_array_stub;compilerproc;
function fpc_array_to_dynarray_copy(Source:Pointer;TypeInfo:Pointer;LowIndex,Count,MaxCount:Natint;ElementSize:Natint;ElementType:Pointer):dynamic_array_stub;compilerproc;
function fpc_dynarray_length(ptr:Pointer):Natint;compilerproc;
function fpc_dynarray_high(ptr:Pointer):Natint;compilerproc;
procedure fpc_dynarray_clear(var ptr:Pointer;TypeInfo:Pointer);compilerproc;
procedure fpc_dynarray_incr_ref(ptr:Pointer);compilerproc;
procedure fpc_dynarray_decr_ref(var ptr:Pointer;TypeInfo:Pointer);compilerproc;
procedure fpc_dynarray_setlength(var ptr:Pointer;PtrTypeInfo:Pointer;DimensionCount:Natint;DimensionLength:PNatint);compilerproc;
procedure fpc_dynarray_insert(var ptr:Pointer;Source:Natint;Data:Pointer;Count:Natint;PtrTypeInfo:Pointer);compilerproc;
procedure fpc_dynarray_concat_multi(var dest:Pointer;PtrTypeInfo:Pointer;const SourceArray:array of Pointer);compilerproc;
procedure fpc_dynarray_concat(var dest:Pointer;PtrTypeInfo:Pointer;Const Source1,Source2:Pointer);compilerproc;
procedure fpc_dynarray_delete(var ptr:Pointer;Source,Count:Natint;PtrTypeInfo:Pointer);compilerproc;
procedure fpc_AnsiStr_Assign(Var DestString:Pointer;Source:Pointer);compilerproc;
procedure fpc_AnsiStr_Decr_Ref(var Ptr:Pointer);compilerproc;
procedure fpc_AnsiStr_Incr_Ref(Ptr:Pointer);compilerproc;
procedure fpc_AnsiStr_Concat(var DestString:ansistring;const Source1,Source2:ansistring;CodePage:TSystemCodePage);compilerproc;
procedure fpc_AnsiStr_Concat_multi(var DestString:ansistring;const SourceArray:array of ansistring;CodePage:TSystemCodePage);compilerproc;
function fpc_ansistr_to_ansistr(const Source:ansistring;CodePage:TSystemCodePage):ansistring;compilerproc;
function fpc_char_to_ansistr(Const Source:AnsiChar;CodePage:TSystemCodePage):ansistring;compilerproc;
function fpc_pchar_to_ansistr(Const Source:PAnsiChar;CodePage:TSystemCodePage):ansistring;compilerproc;
function fpc_chararray_to_ansistr(Const CharArray:array of AnsiChar;CodePage:TSystemCodePage;Zerobased:boolean=true):ansistring;compilerproc;
procedure fpc_ansistr_to_chararray(var res:array of AnsiChar;const Source:ansistring);compilerproc;
function fpc_ansistr_compare(const Source1,Source2:ansistring):Natint;compilerproc;
function fpc_ansistr_compare_equal(const Source1,Source2:ansistring):Natint;compilerproc;
procedure fpc_ansistr_setlength(Var Source:ansistring;length:Natint;CodePage:TSystemCodePage);compilerproc;
function fpc_ansistr_copy(var Source:ansistring;Index,Size:Natint):ansistring;compilerproc;
procedure fpc_ansistr_insert(const Source:ansistring;var Dest:ansistring;Index:Natint);compilerproc;
procedure fpc_ansistr_delete(var Dest:ansistring;Index,Size:Natint);compilerproc;
function fpc_ansistr_unique(var Source:Pointer):Pointer;compilerproc;

implementation

procedure fpc_specific_handler;compilerproc;[public,alias:'__FPC_specific_handler'];
begin
end;
procedure fpc_handleerror;compilerproc;
begin
end;
procedure fpc_lib_exit;compilerproc;
begin
end;
procedure fpc_libinitializeunits;compilerproc;
begin
end;
procedure fpc_initializeunits;compilerproc;
begin
end;
procedure fpc_finalizeunits;compilerproc;
begin
end;
procedure fpc_do_exit;compilerproc;
begin
end;
procedure fpc_div_by_zero;compilerproc;
begin
end;
function fpc_setjmp(var s:jmp_buf):Integer;compilerproc;
begin
 fpc_setjmp:=0; 
end;
function fpc_pushexceptaddr(FormatType:Integer;Buffer,NewAddress:Pointer):Pjmp_buf;compilerproc;[public,alias:'FPC_PUSHEXCEPTADDR'];
begin
 fpc_pushexceptaddr:=allocmem(sizeof(jmp_buf));
end;
procedure fpc_popaddrstack;compilerproc;
begin
end;
procedure fpc_reraise;compilerproc;
begin
end;
procedure fpc_raise_nested;compilerproc;
begin
end;
procedure fpc_doneexception;compilerproc;
begin
end;
function fpc_qword_to_double(q:qword):double;compilerproc;
begin
 fpc_qword_to_double:=dword(q and $ffffffff)+dword(q shr 32)*double(4294967296.0);
end;
function fpc_int64_to_double(i:int64):double;compilerproc;
begin
 fpc_int64_to_double:=dword(i and $ffffffff)+longint(i shr 32)*double(4294967296.0);
end;
function replace_divide(x:natuint;y:natuint):Natuint;
var i:byte;
    tempnum1,tempnum2,res:Natuint;
begin
 tempnum1:=x; tempnum2:=y; res:=0;
 while(tempnum2<tempnum1) do tempnum2:=tempnum2 shl 1;
 if(tempnum2>y) then tempnum2:=tempnum2 shr 1;
 while(tempnum2>=y)do
  begin
   if(tempnum1>=tempnum2) then
    begin
     dec(tempnum1,tempnum2);
     res:=res shl 1+1;
    end
   else 
    begin
     res:=res shl 1;
    end;
   tempnum2:=tempnum2 shr 1;
  end;
 replace_divide:=res;
end;
function replace_modulo(x:natuint;y:natuint):Natuint;
var i:byte;
    tempnum1,tempnum2:Natuint;
begin 
 tempnum1:=x; tempnum2:=y; 
 while(tempnum2<tempnum1) do tempnum2:=tempnum2 shl 1;
 if(tempnum2>y) then tempnum2:=tempnum2 shr 1;
 while(tempnum2>=y)do
  begin
   if(tempnum1>=tempnum2) then
    begin
     dec(tempnum1,tempnum2);
    end;
   tempnum2:=tempnum2 shr 1;
  end;
 replace_modulo:=tempnum1;
end;
function abs(x:natint):natint;
begin
 if(x>0) then abs:=x else abs:=-x;
end;
function abs(x:extended):extended;[public,alias:'abs_extended'];
begin
 if(x>0) then abs:=x else abs:=-x;
end;
function frac(x:extended):extended;
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
function ceil(x:extended):natint;
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1; res:=0;
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
function floor(x:extended):natint;
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1; res:=0;
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
function trunc(x:extended):natint;
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1; res:=0;
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
function round(x:extended):natint;
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1; res:=0;
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
function banker_round(x:extended):natint;
var num:extended;
    j,procnum:natuint;
    res:natint;
begin
 if(x>0) then num:=x else num:=-x;
 procnum:=1; res:=0;
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
function sqr(x:natuint):natuint;
begin
 sqr:=x*x;
end;
function sqr(x:natint):natint;
begin
 sqr:=x*x;
end;
function sqr(x:extended):extended;
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
 exp:=res;
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
function permutation_number(m,n:Natuint):extended;
begin
 permutation_number:=factorial(n)/factorial(n-m);
end;
function conbinartorial_number(m,n:Natuint):extended;
begin
 conbinartorial_number:=factorial(n)/(factorial(m)*factorial(n-m));
end;
function bernoulli_number(x:Natuint):extended;
var i,j:Natuint;
    res:extended;
begin
 res:=1;
 if(x=0) then res:=1
 else if(x=1) then res:=-0.5
 else if(x mod 2=1) then res:=0
 else
  begin
   res:=0;
   for i:=0 to x div 2-1 do res:=res+conbinartorial_number(2*i,x+1)*bernoulli_number(2*i);
   res:=0.5-res/(x+1);
  end;
 bernoulli_number:=res;
end;
function euler_number(x:Natuint):extended;
var i,j:Natuint;
    res:extended;
begin
 if(x=0) then res:=1
 else
  begin
   res:=0;
   for i:=0 to x-1 do
    begin
     if(i mod 2=0) then res:=res+conbinartorial_number(2*i,2*x)*euler_number(i)
     else res:=res-conbinartorial_number(2*i,2*x)*euler_number(i);
    end;
   res:=-res;
  end;
 euler_number:=res;
end;
function sinh(x:extended):extended;
var n:byte;
    res:extended;
begin
 res:=0;
 for n:=1 to 10 do
  begin
   res:=res+intpower(x,2*n-1)/factorial(2*n-1);
  end;
 sinh:=res;
end;
function cosh(x:extended):extended;
var n:byte;
    res:extended;
begin
 res:=0;
 for n:=1 to 10 do
  begin
   res:=res+intpower(x,2*(n-1))/factorial(2*(n-1));
  end;
 cosh:=res;
end;
function tanh(x:extended):extended;
var n:byte;
    res:extended;
begin
 res:=0;
 for n:=1 to 10 do
  begin
   res:=res+(intpower(2,2*n)-1)*intpower(2,2*n)*bernoulli_number(2*n)/factorial(2*n)*intpower(x,2*n-1);
  end;
 tanh:=res;
end;
function coth(x:extended):extended;
var n:byte;
    res:extended;
begin
 res:=0;
 for n:=1 to 10 do
  begin
   res:=res+(intpower(2,2*n)*bernoulli_number(2*n))/factorial(2*n)*intpower(x,2*n-1);
  end;
 coth:=res;
end;
function sech(x:extended):extended;
var n:byte;
    res:extended;
begin
 res:=0;
 for n:=1 to 10 do
  begin
   res:=res+(intpower(-1,n))/factorial(2*n)*euler_number(n)*intpower(x,2*n-1);
  end;
 sech:=res;
end;
function csch(x:extended):extended;
var n:byte;
    res:extended;
begin
 res:=0;
 for n:=1 to 10 do
  begin
   res:=res+2*(1-intpower(2,2*n-1))/factorial(2*n)*bernoulli_number(2*n)*intpower(x,2*n-1);
  end;
 csch:=res;
end;
function system_align(value:Pointer;align:Natuint):Pointer;
begin
 system_align:=Pointer((Natuint(value)+align-1) div align*align);
end;
function check_type_need_finalize(TypeInfo:Pointer):boolean;
begin
 case PTypeKind(TypeInfo)^ of
 tkDynArray,tkSString,tkLString,tkAString,tkWString,tkUString,tkInterface,tkClassRef,tkObject,
 tkVariant,tkClass,tkRecord:check_type_need_finalize:=true;
 else check_type_need_finalize:=false;
 end;
end;
function check_type_need_size(TypeInfo:Pointer):Natint;
begin
 check_type_need_size:=PNatint(system_align(TypeInfo+2+Pbyte(TypeInfo+1)^,8))^;
end;
function heap_initialize(startaddress,endaddress:Pointer;heapbasepower,heapstep,heapmemstep,heapcount:byte):heap_record;
var resrec:heap_record;
    i:byte;
    blockcount,blockcounttotal,blockblock,needblock:Natuint;
    tempstartaddress,tempendaddress:Pointer;
begin
 {Initialize the Heap Fundamental Content}
 resrec.heap:=@sysheap_portion[1];
 resrec.heapcount:=heapcount;
 {Initialize the heap base block}
 i:=1; blockcount:=0; blockcounttotal:=0;
 while(i<=heapcount)do
  begin
   blockcount:=blockcount*heapmemstep+1;
   inc(blockcounttotal,blockcount);
   inc(i);
  end;
 blockblock:=Natuint(endaddress-startaddress+1) div blockcounttotal;
 {Initialize the Heap Portion}
 i:=1; tempstartaddress:=startaddress; needblock:=0;
 while(i<=heapcount)do
  begin
   Pheap_record_portion(resrec.heap+i-1)^.startaddress:=tempstartaddress;
   needblock:=needblock*heapmemstep+1;
   tempendaddress:=tempstartaddress+blockblock*needblock-1;
   Pheap_record_portion(resrec.heap+i-1)^.endaddress:=tempendaddress;
   Pheap_record_portion(resrec.heap+i-1)^.blockpower:=heapbasepower+heapstep*(i-1);
   Pheap_record_portion(resrec.heap+i-1)^.ItemEnd:=0;
   Pheap_record_portion(resrec.heap+i-1)^.RestSize:=blockblock*needblock;
   inc(i);
   tempstartaddress:=tempendaddress+1;
  end;
 heap_initialize:=resrec;
end;
function heap_item_to_address(portion:heap_record_portion;itemindex:Natuint):Pointer;
begin
 heap_item_to_address:=portion.endaddress+1-itemindex shl portion.blockpower;
end;
function heap_address_to_item(portion:heap_record_portion;address:Pointer):Natuint;
var block:Natuint;
begin
 block:=Natuint(portion.endaddress-address+1 shl portion.blockpower) shr portion.blockpower;
 heap_address_to_item:=block;
end;
function heap_get_start_index(portion:heap_record_portion;itemindex:Natuint):Natuint;
var i:Natuint;
begin
 i:=itemindex;
 if(i*(1 shl portion.blockpower+1)>(portion.endaddress-portion.startaddress+1)) then exit(0);
 while(i>0)do
  begin
   if(Pheap_record_item(portion.startaddress+i-1)^.Left=0) and 
   (Pheap_record_item(portion.startaddress+i-1)^.Allocated>0) then break;
   dec(i);
  end;
 if(i<>0) then heap_get_start_index:=i else heap_get_start_index:=0;
end;
function heap_get_start_address(portion:heap_record_portion;address:Pointer):Pointer;
var index:Natuint;
begin
 if(address<portion.startaddress) or (address>portion.endaddress) then exit(nil);
 index:=heap_address_to_item(portion,address);
 if(index*(1 shl portion.blockpower+1)>(portion.endaddress-portion.startaddress+1)) then exit(nil);
 while(index>0)do
  begin
   if(Pheap_record_item(portion.startaddress+index-1)^.Left=0) and
   (Pheap_record_item(portion.startaddress+index-1)^.Allocated>0) then break;
   dec(index);
  end;
 if(index<>0) then heap_get_start_address:=heap_item_to_address(portion,index)
 else heap_get_start_address:=portion.startaddress;
end;
function heap_get_block_count(portion:heap_record_portion;itemindex:Natuint):Natuint;
var i,j:Natuint;
begin
 i:=itemindex; j:=itemindex;
 while(i>0) do
  begin
   if(Pheap_record_item(portion.startaddress+i-1)^.Left=0) and
   (Pheap_record_item(portion.startaddress+i-1)^.Allocated>0) then break;
   dec(i);
  end;
 if(i=0) then exit(0);
 while(j<=portion.ItemEnd)do
  begin
   if(Pheap_record_item(portion.startaddress+j-1)^.Right=0) and
   (Pheap_record_item(portion.startaddress+j-1)^.Allocated>0) then break;
   inc(j);
  end;
 if(j>portion.ItemEnd) then exit(0);
 heap_get_block_count:=j-i+1;
end;
function heap_get_size(portion:heap_record_portion;itemindex:Natuint):Natuint;
var i,j:Natuint;
begin
 i:=itemindex; j:=itemindex;
 while(i>0) do
  begin
   if(Pheap_record_item(portion.startaddress+i-1)^.Left=0) and
   (Pheap_record_item(portion.startaddress+i-1)^.Allocated>0) then break;
   dec(i);
  end;
 if(i=0) then exit(0);
 while(j<=portion.ItemEnd)do
  begin
   if(Pheap_record_item(portion.startaddress+j-1)^.Right=0) and
   (Pheap_record_item(portion.startaddress+j-1)^.Allocated>0) then break;
   inc(j);
  end;
 if(j>portion.ItemEnd) then exit(0);
 heap_get_size:=(j-i+1) shl portion.blockpower;
end;
function heap_request_memory(var portion:heap_record_portion;size:Natuint;RequestLevel:boolean;meminit:boolean):Pointer;
var i,j,k,m:Natuint;
    blockcount:Natuint;
    startaddress:Pointer;
begin
 blockcount:=(size+1 shl portion.blockpower-1) shr portion.blockpower;
 {If cannot allocate,return nil}
 if((1 shl portion.blockpower+1)*blockcount>portion.RestSize) or (blockcount=0) then
  begin
   exit(nil);
  end;
 dec(portion.RestSize,blockcount shl portion.blockpower+blockcount);
 {Then allocate the memory for request}
 if(portion.ItemEnd=0) then
  begin
   for i:=1 to blockcount do
    begin
     if(i>1) then Pheap_record_item(portion.startaddress+i-1)^.Left:=1
     else Pheap_record_item(portion.startaddress+i-1)^.Left:=0;
     if(RequestLevel) then Pheap_record_item(portion.startaddress+i-1)^.RequestLevel:=1
     else Pheap_record_item(portion.startaddress+i-1)^.RequestLevel:=0;
     if(i<blockcount) then Pheap_record_item(portion.startaddress+i-1)^.Right:=1
     else Pheap_record_item(portion.startaddress+i-1)^.Right:=0;
     Pheap_record_item(portion.startaddress+i-1)^.Allocated:=1;
     startaddress:=heap_item_to_address(portion,i);
     if(meminit) then
      begin
       for j:=1 to (1 shl portion.blockpower) div Sizeof(Natuint) do (PNatuint(startaddress)+j-1)^:=0;
      end;
    end;
   portion.ItemEnd:=blockcount;
   heap_request_memory:=heap_item_to_address(portion,portion.ItemEnd);
  end
 else
  begin
   {Search for the empty block to allocate memory}
   i:=1; j:=1;
   while(i<=portion.ItemEnd)do
    begin
     if(Pheap_record_item(portion.startaddress+i-1)^.Allocated=0) then
      begin
       j:=i;
       while(j<=portion.ItemEnd) and (Pheap_record_item(portion.startaddress+j-1)^.Allocated=0) do inc(j);
       if(j-i+1>=blockcount) then break;
      end;
     inc(i);
    end;
   if(i>portion.ItemEnd) then
    begin
     j:=portion.ItemEnd+blockcount; inc(portion.ItemEnd,blockcount);
    end;
   {Initialize the block}
   for k:=i to j do
    begin
     if(k>i) then Pheap_record_item(portion.startaddress+k-1)^.Left:=1
     else Pheap_record_item(portion.startaddress+k-1)^.Left:=0;
     if(RequestLevel) then Pheap_record_item(portion.startaddress+k-1)^.RequestLevel:=1
     else Pheap_record_item(portion.startaddress+k-1)^.RequestLevel:=0;
     if(k<j) then Pheap_record_item(portion.startaddress+k-1)^.Right:=1
     else Pheap_record_item(portion.startaddress+k-1)^.Right:=0;
     Pheap_record_item(portion.startaddress+k-1)^.Allocated:=1;
     startaddress:=heap_item_to_address(portion,k);
     if(meminit) then
      begin
       for m:=1 to (1 shl portion.blockpower) div Sizeof(Natuint) do (PNatuint(startaddress)+m-1)^:=0;
      end;
    end;
   heap_request_memory:=heap_item_to_address(portion,j);
  end;
end;
procedure heap_free_memory(var portion:heap_record_portion;var ptr:Pointer;RequestLevel:boolean;NeedNull:boolean);
var blockstart,blockcount,i:Natuint;
begin
 blockstart:=heap_get_start_index(portion,heap_address_to_item(portion,ptr));
 if(blockstart=0) or
 (Pheap_record_item(portion.startaddress+blockstart-1)^.RequestLevel>Byte(RequestLevel)) then exit;
 blockcount:=heap_get_block_count(portion,blockstart);
 inc(portion.RestSize,blockcount*(1 shl portion.blockpower+1));
 for i:=blockstart to blockstart+blockcount-1 do
  begin
   Pbyte(portion.startaddress+i-1)^:=0;
  end;
 if(blockstart+blockcount-1=portion.ItemEnd) then
  begin
   i:=portion.ItemEnd;
   while(i>0)do
    begin
     if(Pheap_record_item(portion.startaddress+i-1)^.Allocated>0) then
      begin
       portion.ItemEnd:=i; break;
      end;
     dec(i);
    end;
  end;
 if(NeedNull) then ptr:=nil;
end;
procedure heap_move_memory(portion1:heap_record_portion;portion2:heap_record_portion;Source:Pointer;Dest:Pointer);
var start1,start2:Pointer;
    index1,index2:Natuint;
    count1,count2,mincount:Natuint;
    i:Natuint;
begin
 start1:=heap_get_start_address(portion1,Source);
 if(start1=nil) then exit;
 index1:=heap_address_to_item(portion1,start1);
 count1:=heap_get_block_count(portion1,index1);
 start2:=heap_get_start_address(portion2,Dest);
 if(start2=nil) then exit;
 index2:=heap_address_to_item(portion2,start2);
 count2:=heap_get_block_count(portion2,index2);
 if(count1>count2) then mincount:=count2 else mincount:=count1;
 if(Pheap_record_item(portion1.startaddress+index1-1)^.RequestLevel<
 Pheap_record_item(portion2.startaddress+index2-1)^.RequestLevel) then exit;
 for i:=1 to mincount div sizeof(Natuint) do
  begin
   PNatuint(start2+i-1)^:=PNatuint(start1+i-1)^;
  end;
end;
procedure heap_move(const Source;var Dest;Size:Natuint);
var i,j,offset,total,rest:Natuint;
    {$IFDEF CPU64}
    q1,q2:Pqword;
    {$ENDIF}
    d1,d2:Pdword;
    w1,w2:Pword;
    b1,b2:Pbyte;
    conflict:boolean;
begin
 conflict:=false;
 if(Size=0) then exit;
 if(Pointer(@Dest)=nil) or (Pointer(@Source)=nil) then exit;
 if((Pointer(@Dest)>=Pointer(@Source)) and (Pointer(@Dest)<=Pointer(@Source)+Size))
 or((Pointer(@Source)>=Pointer(@Dest)) and (Pointer(@Source)<=Pointer(@Dest)+Size)) then
 conflict:=true;
 if(conflict=false) then
  begin
   {$IFDEF CPU64}
   total:=size shr 3; rest:=size-total shl 3;
   q1:=Pqword(@Source); q2:=Pqword(@Dest);
   for i:=1 to total do (q2+i-1)^:=(q1+i-1)^;
   offset:=i shl 3;
   if(rest>=4) then
    begin
     d1:=PDword(Pointer(q1)+offset); d2:=PDword(Pointer(q2)+offset); d2^:=d1^;
     inc(offset,4); dec(rest,4);
    end;
   if(rest>=2) then
    begin
     w1:=Pword(Pointer(q1)+offset); w2:=Pword(Pointer(q2)+offset); w2^:=w1^;
     inc(offset,2); dec(rest,2);
    end;
   if(rest>=1) then
    begin
     b1:=Pbyte(Pointer(q1)+offset); b2:=Pbyte(Pointer(q2)+offset); b2^:=b1^;
     inc(offset); dec(rest);
    end;
   {$ELSE}
   total:=size shr 2; rest:=size-total shl 2;
   d1:=Pdword(@Source); d2:=Pdword(@Dest);
   for i:=1 to total do (d2+i-1)^:=(d1+i-1)^;
   offset:=i shl 2;
   if(rest>=2) then
    begin
     w1:=Pword(Pointer(q1)+offset); w2:=Pword(Pointer(q2)+offset); w2^:=w1^;
     inc(offset,2); dec(rest,2);
    end;
   if(rest>=1) then
    begin
     b1:=Pbyte(Pointer(q1)+offset); b2:=Pbyte(Pointer(q2)+offset); b2^:=b1^;
     inc(offset); dec(rest);
    end;
   {$ENDIF}
  end
 else
  begin
   {$IFDEF CPU64}
   total:=size shr 3; rest:=size-total shl 3;
   q1:=Pqword(@Source); q2:=Pqword(@Dest);
   offset:=size;
   if(rest>=4) then
    begin
     d1:=PDword(Pointer(q1)+offset); d2:=PDword(Pointer(q2)+offset); d2^:=d1^;
     dec(offset,4); dec(rest,4);
    end;
   if(rest>=2) then
    begin
     w1:=Pword(Pointer(q1)+offset); w2:=Pword(Pointer(q2)+offset); w2^:=w1^;
     dec(offset,2); dec(rest,2);
    end;
   if(rest>=1) then
    begin
     b1:=Pbyte(Pointer(q1)+offset); b2:=Pbyte(Pointer(q2)+offset); b2^:=b1^;
     dec(offset); dec(rest);
    end;
   for i:=total downto 1 do (q2+i-1)^:=(q1+i-1)^;
   {$ELSE}
   total:=size shr 2; rest:=size-total shl 2;
   d1:=Pdword(@Source); d2:=Pdword(@Dest);
   offset:=size;
   if(rest>=2) then
    begin
     w1:=Pword(Pointer(q1)+offset); w2:=Pword(Pointer(q2)+offset); w2^:=w1^;
     dec(offset,2); dec(rest,2);
    end;
   if(rest>=1) then
    begin
     b1:=Pbyte(Pointer(q1)+offset); b2:=Pbyte(Pointer(q2)+offset); b2^:=b1^;
     dec(offset); dec(rest);
    end;
   for i:=total downto 1 do (d2+i-1)^:=(d1+i-1)^;
   {$ENDIF}
  end;
end;
function heap_getmem(var heap:heap_record;size:Natuint;RequestLevel:boolean):Pointer;
var i:Natuint;
    ptr:Pointer;
begin
 i:=heap.heapcount; ptr:=nil;
 while(i>0)do
  begin
   if(i=1) or (size>=1 shl Pheap_record_portion(heap.heap+i-1)^.blockpower) then
    begin
     ptr:=heap_request_memory(Pheap_record_portion(heap.heap+i-1)^,size,RequestLevel,false);
     if(ptr<>nil) then exit(ptr);
    end;
   dec(i);
  end;
 heap_getmem:=ptr;
end;
function heap_allocmem(var heap:heap_record;size:Natuint;RequestLevel:boolean):Pointer;
var i:Natuint;
    ptr:Pointer;
begin
 i:=heap.heapcount; ptr:=nil;
 while(i>0)do
  begin
   if(i=1) or (size>=1 shl Pheap_record_portion(heap.heap+i-1)^.blockpower) then
    begin
     ptr:=heap_request_memory(Pheap_record_portion(heap.heap+i-1)^,size,RequestLevel,true);
     if(ptr<>nil) then exit(ptr);
    end;
   dec(i);
  end;
 heap_allocmem:=ptr;
end;
procedure heap_freemem(var heap:heap_record;var ptr:Pointer;RequestLevel:boolean);
var i:Natuint;
begin
 i:=heap.heapcount;
 while(i>0)do
  begin
   if(ptr>=Pheap_record_portion(heap.heap+i-1)^.startaddress) and
   (ptr<=Pheap_record_portion(heap.heap+i-1)^.endaddress) then
    begin
     heap_free_memory(Pheap_record_portion(heap.heap+i-1)^,ptr,RequestLevel,false); exit;
    end;
   dec(i);
  end;
end;
function heap_getmemsize(var heap:heap_record;ptr:Pointer;RequestLevel:boolean):Natuint;
var i,size:Natuint;
    tempptr:Pointer;
    index:Natuint;
begin
 i:=heap.heapcount;
 while(i>0)do
  begin
   if(ptr>=Pheap_record_portion(heap.heap+i-1)^.startaddress) and
   (ptr<=Pheap_record_portion(heap.heap+i-1)^.endaddress) then
    begin
     tempptr:=heap_get_start_address(Pheap_record_portion(heap.heap+i-1)^,ptr);
     if(tempptr<>nil) then
      begin
       index:=heap_address_to_item(Pheap_record_portion(heap.heap+i-1)^,tempptr);
       if(Pheap_record_item(Pheap_record_portion(heap.heap+i-1)^.startaddress+index-1)^.RequestLevel>
       Byte(RequestLevel)) then exit(0);
       size:=heap_get_size(Pheap_record_portion(heap.heap+i-1)^,index);
       exit(size);
      end;
    end;
   dec(i);
  end;
 heap_getmemsize:=0;
end;
function heap_getmemindex(var heap:heap_record;ptr:Pointer):Natuint;
var i:Natuint;
begin
 i:=heap.heapcount;
 while(i>0)do
  begin
   if(Pheap_record_portion(heap.heap+i-1)^.startaddress<=ptr) and
   (Pheap_record_portion(heap.heap+i-1)^.endaddress>=ptr) then exit(i);
   dec(i);
  end;
 heap_getmemindex:=i;
end;
procedure heap_reallocmem(var heap:heap_record;var ptr:Pointer;size:Natuint;RequestLevel:boolean);
var oldptr,newptr:Pointer;
    oldsize,newsize:Natuint;
    oldindex,newindex:Natuint;
begin
 oldindex:=heap_getmemindex(heap,ptr);
 oldptr:=heap_get_start_address(Pheap_record_portion(heap.heap+oldindex-1)^,ptr);
 newptr:=heap_allocmem(heap,size,RequestLevel);
 newindex:=heap_getmemindex(heap,newptr);
 oldsize:=heap_getmemsize(heap,oldptr,RequestLevel);
 newsize:=heap_getmemsize(heap,newptr,RequestLevel);
 if(oldindex=0) and (newindex=0) then exit;
 if(oldindex<>0) and (newindex<>0) and (oldsize<>0) and (newsize<>0) then
  begin
   heap_move_memory(Pheap_record_portion(heap.heap+oldindex-1)^,Pheap_record_portion(heap.heap+newindex-1)^,oldptr,newptr);
   heap_freemem(heap,oldptr,true);
   ptr:=newptr;
  end
 else if(oldsize=newsize) and (oldsize<>0) then
  begin
   heap_freemem(heap,newptr,true);
  end
 else if(oldsize<>0) and (newsize=0) then
  begin
   heap_freemem(heap,oldptr,true);
   ptr:=nil;
  end;
end; 
function fpc_getmem(size:Natuint):Pointer;compilerproc;
begin
 fpc_getmem:=heap_getmem(sysheap,size,true);
end;
procedure fpc_freemem(var ptr:Pointer);compilerproc;
begin
 heap_freemem(sysheap,ptr,true); ptr:=nil;
end;
procedure fpc_move(const Source;var Dest;Size:Natuint);compilerproc;[public,alias:'FPC_MOVE'];
begin
 heap_move(Source,Dest,Size);
end;
function getmem(size:Natuint):Pointer;
begin
 getmem:=heap_getmem(sysheap,size,true);
end;
function allocmem(size:Natuint):Pointer;
begin
 allocmem:=heap_allocmem(sysheap,size,true);
end;
function getmemsize(ptr:Pointer):Natuint;
begin
 getmemsize:=heap_getmemsize(sysheap,ptr,true);
end;
procedure freemem(var ptr:Pointer);       
begin
 heap_freemem(sysheap,ptr,true); ptr:=nil;
end;
procedure reallocmem(var ptr:Pointer;size:Natuint);
begin
 heap_reallocmem(sysheap,ptr,size,true);
end;
procedure move(Const Source;Var Dest;Size:Natuint);
begin
 heap_move(Source,Dest,Size);
end;
procedure FillByte(Var Dest;Size:Natuint;Data:byte);
var tempptr:Pointer;
    i:Natuint;
begin
 tempptr:=Pointer(@Dest);
 for i:=1 to Size do Pbyte(tempptr+i-1)^:=Data;
end;
procedure FillChar(Var Dest;Size:Natuint;Data:char);
var tempptr:Pointer;
    i:Natuint;
begin
 tempptr:=Pointer(@Dest);
 for i:=1 to Size do PChar(tempptr+i-1)^:=Data;
end;
procedure fpc_initialize(Data,TypeInfo:Pointer);compilerproc;
begin
 PPointer(@Data)^:=nil;
end;
procedure fpc_finalize(Data,TypeInfo:Pointer);compilerproc;
begin
 freemem(Data); PPointer(@Data)^:=nil;
end;
function fpc_dynamic_array_get_length(ptr:Pointer):Natint;
begin
 if(ptr=nil) then exit(0);
 fpc_dynamic_array_get_length:=Pdynamic_array_header(ptr-sizeof(dynamic_array_header))^.ArrayHighest+1;
end;
function fpc_dynamic_array_get_reference(ptr:Pointer):Natint;
begin
 if(ptr=nil) then exit(0);
 fpc_dynamic_array_get_reference:=Pdynamic_array_header(ptr-sizeof(dynamic_array_header))^.ReferenceCount;
end;
procedure fpc_dynamic_array_increase_reference(ptr:Pointer);
begin
 if(ptr=nil) then exit;
 inc(Pdynamic_array_header(ptr-sizeof(dynamic_array_header))^.ReferenceCount);
end;
procedure fpc_dynamic_array_decrease_reference(ptr:Pointer);
begin
 if(ptr=nil) then exit;
 dec(Pdynamic_array_header(ptr-sizeof(dynamic_array_header))^.ReferenceCount);
end;
function fpc_dynamic_array_get_high(ptr:Pointer):Natint;
begin
 if(ptr=nil) then exit(-1);
 fpc_dynamic_array_get_high:=Pdynamic_array_header(ptr-sizeof(dynamic_array_header))^.ArrayHighest;
end;
function fpc_dynamic_array_get_element_size(ptr:Pointer):Natint;
begin
 if(ptr=nil) then exit(0);
 fpc_dynamic_array_get_element_size:=Pdynamic_array_header(ptr-sizeof(dynamic_array_header))^.ItemSize;
end;
procedure fpc_dynarray_assign(var Dest:Pointer;Source:Pointer;TypeInfo:Pointer);compilerproc;
begin
 if(Source=nil) then
  begin
   Dest:=getmem(sizeof(dynamic_array_header));
   Pdynamic_array_header(Dest)^.ReferenceCount:=1;
   Pdynamic_array_header(Dest)^.ArrayHighest:=-1;
   Pdynamic_array_header(Dest)^.ItemSize:=check_type_need_size(TypeInfo);
   inc(Dest,sizeof(dynamic_array_header));
  end
 else
  begin
   freemem(Dest); Dest:=Source;
   Pdynamic_array_header(Dest)^.ReferenceCount:=1;
  end;
end;
function fpc_dynarray_copy(Source:Pointer;TypeInfo:Pointer;LowIndex,Count:Natint):dynamic_array_stub;compilerproc;
var tempptr:Pointer;
    elementsize:Natint;
    arrayhighest:Natint;
begin 
 elementsize:=fpc_dynamic_array_get_element_size(Source);
 if(elementsize=0) then elementsize:=check_type_need_size(TypeInfo);
 arrayhighest:=fpc_dynamic_array_get_high(Source);
 if(LowIndex+Count-1>ArrayHighest) then
  begin
   tempptr:=getmem(sizeof(dynamic_array_header)+elementsize*(ArrayHighest-LowIndex+1));
   Pdynamic_array_header(tempptr)^.ReferenceCount:=1;
   Pdynamic_array_header(tempptr)^.ArrayHighest:=ArrayHighest-LowIndex;
   Pdynamic_array_header(tempptr)^.ItemSize:=fpc_dynamic_array_get_element_size(Source);
   inc(tempptr,sizeof(dynamic_array_header));
   Move(Source^,tempptr^,elementsize*(ArrayHighest-LowIndex+1));
  end
 else if(LowIndex>0) then
  begin
   tempptr:=getmem(sizeof(dynamic_array_header)+elementsize*Count);
   Pdynamic_array_header(tempptr)^.ReferenceCount:=1;
   Pdynamic_array_header(tempptr)^.ArrayHighest:=Count-1;
   Pdynamic_array_header(tempptr)^.ItemSize:=fpc_dynamic_array_get_element_size(Source);
   inc(tempptr,sizeof(dynamic_array_header));
   Move(Source^,tempptr^,elementsize*Count);
  end
 else if(LowIndex+Count-1>0) then
  begin
   tempptr:=getmem(sizeof(dynamic_array_header)+elementsize*(LowIndex+Count-1));
   Pdynamic_array_header(tempptr)^.ReferenceCount:=1;
   Pdynamic_array_header(tempptr)^.ArrayHighest:=(LowIndex+Count-2);
   Pdynamic_array_header(tempptr)^.ItemSize:=ElementSize;
   inc(tempptr,sizeof(dynamic_array_header));
   Move(Source^,tempptr^,elementsize*(LowIndex+Count-1));
  end
 else tempptr:=nil;
 fpc_dynarray_copy:=Dynamic_array_stub(tempptr);
end;
function fpc_array_to_dynarray_copy(Source:Pointer;TypeInfo:Pointer;LowIndex,Count,MaxCount:Natint;ElementSize:Natint;ElementType:Pointer):dynamic_array_stub;compilerproc;
var tempptr:Pointer;
begin 
 if(LowIndex+Count-1>MaxCount) then
  begin
   tempptr:=getmem(sizeof(dynamic_array_header)+elementsize*(MaxCount-LowIndex));
   Pdynamic_array_header(tempptr)^.ReferenceCount:=1;
   Pdynamic_array_header(tempptr)^.ArrayHighest:=MaxCount-LowIndex;
   Pdynamic_array_header(tempptr)^.ItemSize:=ElementSize;
   inc(tempptr,sizeof(dynamic_array_header));
   Move(Source^,tempptr^,elementsize*(MaxCount-LowIndex+1));
  end
 else if(LowIndex>0) then
  begin
   tempptr:=getmem(sizeof(dynamic_array_header)+elementsize*Count);
   Pdynamic_array_header(tempptr)^.ReferenceCount:=1;
   Pdynamic_array_header(tempptr)^.ArrayHighest:=Count-1;
   Pdynamic_array_header(tempptr)^.ItemSize:=ElementSize;
   inc(tempptr,sizeof(dynamic_array_header));
   Move(Source^,tempptr^,elementsize*Count);
  end
 else if(LowIndex+Count-1>0) then
  begin
   tempptr:=getmem(sizeof(dynamic_array_header)+elementsize*(LowIndex+Count-1));
   Pdynamic_array_header(tempptr)^.ReferenceCount:=1;
   Pdynamic_array_header(tempptr)^.ArrayHighest:=(LowIndex+Count-2);
   Pdynamic_array_header(tempptr)^.ItemSize:=ElementSize;
   inc(tempptr,sizeof(dynamic_array_header));
   Move(Source^,tempptr^,elementsize*(LowIndex+Count-2));
  end
 else tempptr:=nil;
 fpc_array_to_dynarray_copy:=Dynamic_array_stub(tempptr);
end;
function fpc_dynarray_length(ptr:Pointer):Natint;compilerproc;
begin
 fpc_dynarray_length:=fpc_dynamic_array_get_length(ptr);
end;
function fpc_dynarray_high(ptr:Pointer):Natint;compilerproc;
begin
 fpc_dynarray_high:=fpc_dynamic_array_get_high(ptr);
end;
procedure fpc_dynarray_clear(var ptr:Pointer;TypeInfo:Pointer);compilerproc;
var bool:boolean;
    count,elementsize,i:Natint;
begin
 bool:=check_type_need_finalize(TypeInfo); 
 if(ptr=nil) then 
  begin
   ptr:=nil; exit;
  end;
 count:=fpc_dynamic_array_get_high(ptr); if(count<0) then exit;
 elementsize:=fpc_dynamic_array_get_element_size(ptr); if(elementsize=0) then exit;
 if(bool) then for i:=0 to count do freemem(PPointer(ptr+i*elementsize)^);
 freemem(ptr); ptr:=nil;
end;
procedure fpc_dynarray_incr_ref(ptr:Pointer);compilerproc;
begin
 if(fpc_dynamic_array_get_reference(ptr)>0) then 
 Pdynamic_array_header(ptr-sizeof(dynamic_array_header))^.ReferenceCount:=1;
end;
procedure fpc_dynarray_decr_ref(var ptr:Pointer;TypeInfo:Pointer);compilerproc;
var bool:boolean;
    count,elementsize,i:Natint;
begin
 bool:=check_type_need_finalize(TypeInfo); 
 if(ptr=nil) then exit;
 count:=fpc_dynamic_array_get_high(ptr); if(count<0) then exit;
 elementsize:=fpc_dynamic_array_get_element_size(ptr); if(elementsize=0) then exit;
 if(bool) then for i:=0 to count do freemem(PPointer(ptr+i*elementsize)^);
 freemem(ptr); ptr:=nil;
end;
procedure fpc_dynamic_array_setlength(var ptr:Pointer;PtrTypeInfo:Pointer;DimensionCount:Natint;DimensionLength:PNatint);
var oldptr,newptr:Pointer;
    oldlen,newlen,minlen:Natint;
    elementsize,i:Natint;
begin
 newlen:=DimensionLength^; 
 if(newlen<=0) then 
  begin
   freemem(ptr); ptr:=nil; exit;
  end;
 oldlen:=fpc_dynamic_array_get_length(ptr); 
 oldptr:=ptr; elementsize:=fpc_dynamic_array_get_element_size(ptr);
 if(oldlen=newlen) then exit;
 if(elementsize=0) then elementsize:=check_type_need_size(PtrTypeInfo);
 newptr:=allocmem(sizeof(dynamic_array_header)+elementsize*newlen);
 Pdynamic_array_header(newptr)^.ReferenceCount:=1;
 Pdynamic_array_header(newptr)^.ArrayHighest:=Newlen-1;
 Pdynamic_array_header(newptr)^.ItemSize:=elementsize;
 inc(newptr,sizeof(dynamic_array_header));
 if(oldlen>newlen) then minlen:=newlen else minlen:=oldlen;
 Move(oldptr^,newptr^,elementsize*minlen);
 if(DimensionCount>1) then
  begin
   for i:=0 to newlen-1 do
   fpc_dynamic_array_setlength(PPointer(newptr+i*elementsize)^,PtrTypeInfo,DimensionCount-1,DimensionLength+1);
  end;
 ptr:=newptr; freemem(oldptr); oldptr:=nil;
end;
procedure fpc_dynarray_setlength(var ptr:Pointer;PtrTypeInfo:Pointer;DimensionCount:Natint;DimensionLength:PNatint);compilerproc;
begin
 fpc_dynamic_array_setlength(ptr,ptrtypeinfo,DimensionCount,DimensionLength);
end;
procedure fpc_dynarray_delete(var ptr:Pointer;Source,Count:Natint;PtrTypeInfo:Pointer);compilerproc;
var bool:boolean;
    oldptr,newptr:Pointer;
    realstart,realend:Natint;
    i,index,oldlen,newlen:Natint;
    elementsize:Natint;
begin
 bool:=check_type_need_finalize(PtrTypeInfo); 
 if(Count=0) then exit;
 oldlen:=fpc_dynamic_array_get_length(ptr); elementsize:=fpc_dynamic_array_get_element_size(ptr);
 if(Source>oldlen) or (Source+Count-1<0) then exit
 else 
  begin
   realstart:=Source; realend:=Source+Count-1;
   if(realstart<0) then realstart:=0;
   if(realend>oldlen-1) then realend:=oldlen-1;
  end;
 oldptr:=ptr; newlen:=oldlen-(realend-realstart+1);
 if(newlen=0) then 
  begin
   freemem(ptr); ptr:=nil; exit;
  end;
 newptr:=getmem(sizeof(dynamic_array_header)+elementsize*newlen);
 Pdynamic_array_header(newptr)^.ReferenceCount:=1;
 Pdynamic_array_header(newptr)^.ArrayHighest:=Newlen-1;
 Pdynamic_array_header(newptr)^.ItemSize:=elementsize;
 inc(newptr,sizeof(dynamic_array_header));
 move(oldptr^,newptr^,elementsize*realstart);
 move((oldptr+(realend+1)*elementsize)^,(newptr+realstart*elementsize)^,elementsize*(oldlen-realend));
 i:=realstart; 
 while(i<=realend)do
  begin
   if(bool) then 
    begin
     freemem(PPointer(oldptr+i*elementsize)^); PPointer(oldptr+i*elementsize)^:=nil;
    end;
   inc(i);
  end;
 freemem(oldptr); oldptr:=nil; ptr:=newptr;
end;
procedure fpc_dynarray_insert(var ptr:Pointer;Source:Natint;Data:Pointer;Count:Natint;PtrTypeInfo:Pointer);compilerproc;
var oldlen,newlen,newindex,elementsize:Natint;
    oldptr,newptr:Pointer;
begin
 if(count=0) then exit;
 oldlen:=fpc_dynamic_array_get_length(ptr); elementsize:=fpc_dynamic_array_get_element_size(ptr);
 if(Source<0) then Newindex:=0 else if(Source>oldlen-1) then Newindex:=oldlen-1 else Newindex:=Source;
 if(elementsize=0) then elementsize:=check_type_need_size(PtrTypeInfo);
 newlen:=oldlen+Count; oldptr:=ptr;
 newptr:=getmem(sizeof(dynamic_array_header)+Pdynamic_array_header(ptr)^.ItemSize*newlen);
 Pdynamic_array_header(newptr)^.ReferenceCount:=1;
 Pdynamic_array_header(newptr)^.ArrayHighest:=Newlen-1;
 Pdynamic_array_header(newptr)^.ItemSize:=elementsize;
 inc(newptr,sizeof(dynamic_array_header));
 move(oldptr^,newptr^,elementsize*NewIndex);
 move(Data^,(newptr+NewIndex*elementsize)^,elementsize*Count);
 move((oldptr+NewIndex*elementsize)^,(newptr+(NewIndex+Count)*elementsize)^,elementsize*(oldlen-NewIndex));
 freemem(oldptr); oldptr:=nil; ptr:=newptr;
end;
procedure fpc_dynarray_concat_multi(var dest:Pointer;PtrTypeInfo:Pointer;const SourceArray:array of Pointer);compilerproc;
var totallen,elementsize,realoffset,i:Natint;
    newptr,tempptr:Pointer;
begin
 if(dest<>nil) then
  begin
   freemem(dest); dest:=nil;
  end;
 {Calculate the Total Length}
 totallen:=0; elementsize:=fpc_dynamic_array_get_element_size(SourceArray[0]);
 for i:=1 to length(SourceArray) do 
  begin
   inc(totallen,fpc_dynamic_array_get_length(SourceArray[i-1]));
  end;
 {Request the Total Memory}
 newptr:=getmem(sizeof(dynamic_array_header)+elementsize*totallen);
 Pdynamic_array_header(newptr)^.ReferenceCount:=1;
 Pdynamic_array_header(newptr)^.ArrayHighest:=totallen-1;
 Pdynamic_array_header(newptr)^.ItemSize:=elementsize;
 inc(newptr,sizeof(dynamic_array_header));
 {Then Fill the Dynamic Array with Source Array}
 realoffset:=0;
 for i:=1 to length(SourceArray) do
  begin
   if(SourceArray[i-1]=nil) then continue;
   Move(SourceArray[i-1]^,(newptr+realoffset)^,fpc_dynamic_array_get_length(SourceArray[i-1])*elementsize);
   inc(realoffset,fpc_dynamic_array_get_length(SourceArray[i-1])*elementsize);
   tempptr:=SourceArray[i-1]; freemem(tempptr);
  end;
 tempptr:=Dest; FreeMem(Dest); Dest:=nil;
 Dest:=newptr;
end;
procedure fpc_dynarray_concat(var dest:Pointer;PtrTypeInfo:Pointer;Const Source1,Source2:Pointer);compilerproc;
var totallen,elementsize,realoffset,i:Natint;
    newptr,tempptr:Pointer;
begin
 if(dest<>nil) then
  begin
   freemem(dest); dest:=nil;
  end;
 {Calculate the Total Length}
 totallen:=fpc_dynamic_array_get_length(Source1)+fpc_dynamic_array_get_length(Source2);
 elementsize:=fpc_dynamic_array_get_element_size(Source1);
 {Request the Total Memory}
 newptr:=getmem(sizeof(dynamic_array_header)+elementsize*totallen);
 Pdynamic_array_header(newptr)^.ReferenceCount:=1;
 Pdynamic_array_header(newptr)^.ArrayHighest:=totallen-1;
 Pdynamic_array_header(newptr)^.ItemSize:=elementsize;
 inc(newptr,sizeof(dynamic_array_header));
 realoffset:=0;
 if(Source1<>nil) then Move(Source1^,newptr^,fpc_dynamic_array_get_length(Source1)*elementsize);
 inc(realoffset,fpc_dynamic_array_get_length(Source1)*elementsize);
 if(Source2<>nil) then Move(Source2^,(newptr+realoffset)^,fpc_dynamic_array_get_length(Source2)*elementsize);
 tempptr:=Dest; FreeMem(Dest); Dest:=nil;
 Dest:=newptr;
end;
function fpc_ansistring_get_reference_count(ptr:Pointer):Natint;
begin
 if(ptr=nil) then exit(0);
 fpc_ansistring_get_reference_count:=Pstring_header(ptr-sizeof(string_header))^.ReferenceCount;
end;
function fpc_ansistring_get_length(ptr:Pointer):Natuint;
begin
 if(ptr=nil) then exit(0);
 fpc_ansistring_get_length:=Pstring_header(ptr-sizeof(string_header))^.ArrayHighest;
end;
procedure fpc_AnsiStr_Assign(Var DestString:Pointer;Source:Pointer);compilerproc;
begin
 if(DestString=Source) then exit;
 if(DestString<>nil) then
  begin
   freemem(DestString); DestString:=nil;
  end;
 if(Source=nil) then
  begin
   DestString:=getmem(sizeof(string_header));
   Pstring_header(DestString)^.ReferenceCount:=1;
   Pstring_header(DestString)^.ArrayHighest:=0;
   inc(DestString,sizeof(string_header));
  end
 else DestString:=Source;
end;
procedure fpc_AnsiStr_Decr_Ref(var Ptr:Pointer);compilerproc;
begin
 freemem(Ptr); ptr:=nil;
end;
procedure fpc_AnsiStr_Incr_Ref(Ptr:Pointer);compilerproc;
begin
 if(Ptr<>nil) and (fpc_ansistring_get_reference_count(ptr)>0) then
 Pstring_header(ptr-sizeof(string_header))^.ReferenceCount:=1;
end;
procedure fpc_AnsiStr_Concat(var DestString:ansistring;const Source1,Source2:ansistring;CodePage:TSystemCodePage);compilerproc;
var newptr,ptr1,ptr2,tempptr:Pointer;
    len1,len2:Natuint;
begin 
 ptr1:=PPointer(@Source1)^; ptr2:=PPointer(@Source2)^;
 len1:=fpc_ansistring_get_length(ptr1); len2:=fpc_ansistring_get_length(ptr2);
 newptr:=getmem(sizeof(string_header)+len1+len2);
 Pstring_header(newptr)^.ReferenceCount:=1;
 Pstring_header(newptr)^.ArrayHighest:=len1+len2;
 inc(newptr,sizeof(string_header));
 if(ptr1<>nil) then Move(ptr1^,newptr^,len1);
 if(ptr2<>nil) then Move(ptr2^,(newptr+len1)^,len2);
 tempptr:=PPointer(@DestString)^;
 if(tempptr<>nil) then
  begin
   freemem(tempptr); tempptr:=nil; PPointer(@DestString)^:=nil;
  end;
 PPointer(@DestString)^:=newptr;
end;
procedure fpc_AnsiStr_Concat_multi(var DestString:ansistring;const SourceArray:array of ansistring;CodePage:TSystemCodePage);compilerproc;
var newptr,ptr,tempptr:Pointer;
    i,offset,len:Natuint;
begin
 i:=1; len:=0; 
 for i:=1 to length(SourceArray) do 
  begin
   ptr:=PPointer(@SourceArray[i-1])^;
   inc(len,fpc_ansistring_get_length(ptr));
  end;
 newptr:=getmem(sizeof(string_header)+len); 
 Pstring_header(newptr)^.ReferenceCount:=1; 
 Pstring_header(newptr)^.ArrayHighest:=len; 
 inc(newptr,sizeof(string_header));
 offset:=0;
 for i:=1 to length(SourceArray) do
  begin
   ptr:=PPointer(@SourceArray[i-1])^;
   Move(ptr^,(newptr+offset)^,fpc_ansistring_get_length(ptr));
   inc(offset,fpc_ansistring_get_length(ptr));
  end;
 tempptr:=PPointer(@DestString)^;
 if(tempptr<>nil) then
  begin
   freemem(tempptr); tempptr:=nil; PPointer(@DestString)^:=nil;
  end;
 PPointer(@DestString)^:=newptr;
end;
function fpc_ansistr_to_ansistr(const Source:ansistring;CodePage:TSystemCodePage):ansistring;compilerproc;
var ptr,newptr:Pointer;
    len:Natuint;
begin
 ptr:=PPointer(@Source)^; len:=fpc_ansistring_get_length(ptr);
 if(ptr=nil) then exit('');
 newptr:=getmem(sizeof(string_header)+len);
 Pstring_header(newptr)^.ReferenceCount:=1;
 Pstring_header(newptr)^.ArrayHighest:=len;
 inc(newptr,sizeof(string_header));
 Move(ptr^,newptr^,len);
 PPointer(@Result)^:=newptr;
end;
function fpc_char_to_ansistr(Const Source:AnsiChar;CodePage:TSystemCodePage):ansistring;compilerproc;
var newptr:Pointer;
begin
 newptr:=getmem(sizeof(string_header)+1);
 Pstring_header(newptr)^.ReferenceCount:=1;
 Pstring_header(newptr)^.ArrayHighest:=1;
 inc(newptr,sizeof(string_header));
 PChar(newptr)^:=Source;
 PPointer(@Result)^:=newptr;
end;
function fpc_pchar_to_ansistr(Const Source:PAnsiChar;CodePage:TSystemCodePage):ansistring;compilerproc;
var i,len:Natuint;
    newptr:Pointer;
begin
 len:=0;
 while((Source+len)^<>#0) do inc(len);
 newptr:=getmem(sizeof(string_header)+len);
 Pstring_header(newptr)^.ReferenceCount:=1;
 Pstring_header(newptr)^.ArrayHighest:=len;
 inc(newptr,sizeof(string_header));
 Move(Source^,newptr^,len);
 PPointer(@Result)^:=newptr;
end;
function fpc_chararray_to_ansistr(Const CharArray:array of AnsiChar;CodePage:TSystemCodePage;Zerobased:boolean=true):ansistring;compilerproc;
var len:Natuint;
    oldptr,newptr:Pointer;
begin
 len:=length(CharArray);
 newptr:=getmem(sizeof(string_header)+len);
 Pstring_header(newptr)^.ReferenceCount:=1;
 Pstring_header(newptr)^.ArrayHighest:=len;
 inc(newptr,sizeof(string_header));
 oldptr:=PPointer(@CharArray)^;
 Move(oldptr^,newptr^,len);
 PPointer(@Result)^:=newptr;
end;
procedure fpc_ansistr_to_chararray(var res:array of AnsiChar;const Source:ansistring);compilerproc;
var len:Natuint; 
    oldptr,newptr:Pointer;
begin
 oldptr:=PPointer(@Source)^;
 len:=fpc_ansistring_get_length(oldptr);
 newptr:=getmem(sizeof(dynamic_array_header)+len);
 Pdynamic_array_header(newptr)^.ReferenceCount:=1;
 Pdynamic_array_header(newptr)^.ArrayHighest:=len;
 Pdynamic_array_header(newptr)^.ItemSize:=1;
 inc(newptr,sizeof(dynamic_array_header));
 Move(oldptr^,newptr^,len);
 PPointer(@res)^:=newptr;
end;
function fpc_ansistr_compare(const Source1,Source2:ansistring):Natint;compilerproc;
var ptr1,ptr2:Pointer;
    len1,len2,minlen,i:Natuint;
begin
 ptr1:=PPointer(@Source1)^; ptr2:=PPointer(@Source2)^;
 len1:=fpc_ansistring_get_length(ptr1); len2:=fpc_ansistring_get_length(ptr2); 
 if(len1>len2) then minlen:=len2 else minlen:=len1;
 for i:=1 to minlen do
  begin
   if(Source1[i]<>Source2[i]) then exit(Natint(Source1[i])-Natint(Source2[i]));
  end;
 Result:=len1-len2; 
end;
function fpc_ansistr_compare_equal(const Source1,Source2:ansistring):Natint;compilerproc;
var ptr1,ptr2:Pointer;
    len1,len2,minlen,i:Natuint;
begin
 ptr1:=PPointer(@Source1)^; ptr2:=PPointer(@Source2)^;
 len1:=fpc_ansistring_get_length(ptr1); len2:=fpc_ansistring_get_length(ptr2); 
 if(len1>len2) then minlen:=len2 else minlen:=len1;
 for i:=1 to minlen do
  begin
   if(Source1[i]<>Source2[i]) then exit(Natint(Source1[i])-Natint(Source2[i]));
  end;
 Result:=len1-len2; 
end;
procedure fpc_ansistr_rangecheck(ptr:Pointer;Index:Natint);compilerproc;
begin
end;
procedure fpc_ansistr_zerobased_rangecheck(ptr:Pointer;Index:Natint);compilerproc;
begin
end;
procedure fpc_ansistr_setlength(Var Source:ansistring;length:Natint;CodePage:TSystemCodePage);compilerproc;
var oldptr,newptr:Pointer;
    oldlen,minlen:Natuint;
begin
 if(length=0) then 
  begin
   freemem(oldptr); oldptr:=nil; PPointer(@Source)^:=oldptr; exit;
  end;
 oldptr:=PPointer(@Source)^;
 oldlen:=fpc_ansistring_get_length(oldptr); 
 if(oldlen>length) then minlen:=length else minlen:=oldlen;
 newptr:=getmem(sizeof(string_header)+length);
 Pstring_header(newptr)^.ReferenceCount:=1;
 Pstring_header(newptr)^.ArrayHighest:=length;
 inc(newptr,sizeof(string_header));
 Move(oldptr^,newptr^,minlen);
 freemem(oldptr); oldptr:=nil;
 PPointer(@Source)^:=newptr;
end;
function fpc_ansistr_copy(var Source:ansistring;Index,Size:Natint):ansistring;compilerproc;
var oldptr,newptr:Pointer;
    oldlen,newlen,StartX,EndX:Natuint;
begin
 oldptr:=PPointer(@Source)^; oldlen:=fpc_ansistring_get_length(oldptr);
 if(oldlen=0) then exit;
 if(Index+Size-1>oldlen) then EndX:=oldlen else EndX:=Index+Size-1;
 if(Index+Size-1<1) then StartX:=1 else StartX:=Index;
 if(StartX>EndX) then exit;
 newlen:=EndX-StartX+1;
 newptr:=getmem(sizeof(string_header)+newlen);
 Pstring_header(newptr)^.ReferenceCount:=1;
 Pstring_header(newptr)^.ArrayHighest:=newlen;
 inc(newptr,sizeof(string_header));
 Move((oldptr+StartX-1)^,newptr^,EndX-StartX+1);
 PPointer(@Result)^:=newptr;
end;
procedure fpc_ansistr_insert(const Source:ansistring;var Dest:ansistring;Index:Natint);compilerproc;
var oldptr,tempptr,newptr:Pointer;
    oldlen,templen,newlen,StartX:Natuint;
begin
 oldptr:=PPointer(@Dest)^; oldlen:=fpc_ansistring_get_length(oldptr);
 tempptr:=PPointer(@Source)^; templen:=fpc_ansistring_get_length(tempptr);
 if(templen=0) then exit;
 if(Index<=oldlen) then StartX:=oldlen else if(Index>1) then StartX:=Index else StartX:=1;
 newlen:=oldlen+templen;
 newptr:=getmem(sizeof(string_header)+newlen);
 Pstring_header(newptr)^.ReferenceCount:=1;
 Pstring_header(newptr)^.ArrayHighest:=newlen;
 inc(newptr,sizeof(string_header));
 Move(oldptr^,newptr^,StartX);
 Move(tempptr^,(newptr+StartX-1)^,templen);
 Move((oldptr+StartX-1)^,(newptr+StartX+templen-2)^,oldlen-StartX+1);
 freemem(oldptr); oldptr:=nil;
 PPointer(@Dest)^:=newptr;
end;
procedure fpc_ansistr_delete(var Dest:ansistring;Index,Size:Natint);compilerproc;
var oldptr,newptr:Pointer;
    oldlen,newlen,StartX,EndX:Natuint;
begin
 oldptr:=PPointer(@Dest)^; oldlen:=fpc_ansistring_get_length(oldptr);
 if(oldlen=0) then exit;
 if(Index+Size-1>oldlen) then EndX:=oldlen else EndX:=Index+Size-1;
 if(Index+Size-1<1) then StartX:=1 else StartX:=Index;
 if(StartX>EndX) then exit;
 newlen:=oldlen-(EndX-StartX+1);
 if(newlen=0) then
  begin
   freemem(oldptr); oldptr:=nil; PPointer(@Dest)^:=oldptr; exit;
  end;
 newptr:=getmem(sizeof(string_header)+newlen);
 Pstring_header(newptr)^.ReferenceCount:=1;
 Pstring_header(newptr)^.ArrayHighest:=newlen;
 inc(newptr,sizeof(string_header));
 Move(oldptr^,newptr^,StartX-1);
 Move((oldptr+EndX)^,(newptr+StartX-1)^,oldlen-EndX);
 freemem(oldptr); oldptr:=nil;
 PPointer(@Dest)^:=newptr;
end;
function fpc_ansistr_unique(var Source:Pointer):Pointer;compilerproc;
begin
 fpc_ansistr_unique:=Source; Source:=nil;
end;
function TVmt.GetvParent:PVmt;
begin
 Result:=vParentRef^;
end;
constructor TObject.Create;
begin
 PPointer(@Self)^:=allocmem(ObjectSize);
end;
destructor TObject.Destroy;
var tempptr:Pointer;
begin 
 tempptr:=PPointer(@Self)^;
 freemem(tempptr); PPointer(@Self)^:=nil;
end;
function TObject.NewInstance:Tobject;
begin
 PPointer(@Self)^:=allocmem(ObjectSize);
 Result:=Self;
end;
procedure TObject.FreeInstance;
var tempptr:Pointer;
begin 
 tempptr:=PPointer(@Self)^;
 freemem(tempptr); PPointer(@Self)^:=nil;
end;
procedure TObject.Free;
var tempptr:Pointer;
begin 
 tempptr:=PPointer(@Self)^;
 freemem(tempptr); PPointer(@Self)^:=nil;
end;
procedure TObject.CleanupInstance;
var tempptr:Pointer;
begin 
 tempptr:=PPointer(@Self)^;
 freemem(tempptr); PPointer(@Self)^:=nil;
end;
procedure TObject.AfterConstruction;
begin
end;
procedure TObject.BeforeDestruction;
begin
end;
function TObject.GetObjectSize:NatInt;
begin
 Result:=PVmt(PPointer(@Self)^)^.vInstanceSize;
end;

end.
