unit system;
{$MODE FPC}

interface

{$IFDEF CPU32}
const compilermaxheap=1048576;
      compilermaxsection=16384;
      maxheap=16777216*2;
      maxsection=16384*64;
      maxnatint=$7FFFFFFF;
      maxnatuint=$FFFFFFFF;
{$ELSE CPU32}
const compilermaxheap=4194304;
      compilermaxsection=65536;
      maxheap=67108864*2;
      maxsection=65536*64;
      maxnatint=$7FFFFFFFFFFFFFFF;
      maxnatuint=$FFFFFFFFFFFFFFFF;
{$ENDIF CPU32}
type
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
  {$IFDEF CPU32}
  NatUint=dword;
  PNatUint=^dword;
  Natint=integer;
  PNatint=^integer;
  Uint128=record
          Dwords:array[1..4] of dword;
          end;
  Int128=record
         Highdword:Integer;
         Lowdwords:array[1..3] of dword;
         end;
  {$ELSE CPU32}
  NatUint=qword;
  PNatUint=^qword;
  Natint=int64;
  PNatint=^int64;
  Uint128=record
          High,Low:qword;
          end;
  Int128=record
         High:Int64;
         Low:qword;
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
      // The high field of the clock sequence multiplexed with the variant
      clock_seq_low: byte; // The low field of the clock sequence
      node: array [0 .. 5] of byte; // The spatially unique node identifier
    );
  end;
  compilerheap=packed record
               heapcontent:array[1..compilermaxheap] of byte;
	       heapsection:array[1..compilermaxsection,1..2] of natuint;
	       heapcount,heaprest:natuint;
               end;
  systemheap=packed record
	     heapcontent:array[1..maxheap] of dword;
	     heapsection:array[1..maxsection,1..2] of natuint;
	     heapcount,heaprest:natuint;
             end;
  maskwildcard=packed record
               liststr:^PChar;
               listpos:^natuint;
               listlen:^natuint;
               listcount:natuint;
               end;
  Wmaskwildcard=packed record
                liststr:^PWideChar;
                listpos:^natuint;
                listlen:^natuint;
                listcount:natuint;
                end; 
  sys_parameter_item=packed record
                     item_content:PByte;
                     item_size:natuint;
                     end;
  Psys_parameter_item=^sys_parameter_item;
  sys_parameter=packed record
                param_content:PByte;
                param_size:^natuint;
                param_count:natuint;
                end;
  sys_function=function (parameter:sys_parameter):PByte;
  sys_procedure=procedure (parameter:sys_parameter);
  sys_parameter_function=packed record
                         case Boolean of 
                         True:(func:sys_function;);
                         False:(proc:sys_procedure;);
                         end;
  sys_parameter_function_and_parameter=packed record
                                       parameter_function:sys_parameter_function;
                                       parameter_parameter:sys_parameter;
                                       parameter_result_size:natuint;
                                       parameter_disposed:boolean;
                                       end;
  Psys_parameter_function_and_parameter=^sys_parameter_function_and_parameter;
  
const passwdstr:PChar='rbflMNldcanDUmuuov2CLochbexUVOVdFyuM5sdhxl6tsNMb3kGpMYfq6unhLkLJVHN16dNfGrF0HUyiuJMux9jR29SC9F0MrlJmksMwps5oipJIIwFa7HNixo0oWR9NHpc1sJRpdlXbRIqBZwo7TKSAtXRLLYAXsMwLfZCQsVBDbhm2XAMtomD8hu2DC3KOBW0HNSw2VVDiIKL2xfAOlzhx0EKCULVsdbuDpKi8oxZyFbrMh4DBcFJPtCWlTqFgASL9i7ZxL3R8I0Xoa10llEBt4xy4Be5Oph6KPsifZtc0sDbuxDZjJ85aw1XmNCIof73eBYUFyuoId9TPxAfVeVdrBUfPvxcqliMO82T08lEoXPftR54siClSdSV4PTsjoNZKvIf4j0z4ntESeh2Qq6smyE1pgAQjfY0YG8kvD4mo4AkTUHs3YkvbhCNySrv9f0XEP6Lp35sdlBHG85WCSk15uB6WxaJx9Wke8kRZckuEFSMyV2AjBfrwqGa5R3Rr';
      passwdstroffset:array[1..5,1..11] of shortint=((-1,-3,-4,-7,4,3,9,11,13,-9,2),(-2,-3,-4,-6,4,3,9,13,13,-9,2),(-4,-7,-4,-7,4,3,4,11,21,-9,2),(-2,-3,-4,-7,4,5,9,11,13,-9,4),(-3,-9,-4,-7,4,3,15,11,13,-9,13));
      pi:extended=3.1415926;
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
function fpc_qword_to_double(q:qword):double;compilerproc;
function fpc_int64_to_double(i:int64):double;compilerproc;
function fpc_getmem(size:natuint):Pointer;compilerproc;
procedure fpc_freemem(var p:pointer);compilerproc;
function fpc_allocmem(size:natuint):Pointer;compilerproc;
procedure fpc_reallocmem(var p:Pointer;size:natuint);compilerproc;
procedure fpc_move(const source;var dest;count:natuint);compilerproc;
procedure compheap_initialize;
procedure sysheap_initialize;
procedure sysheap_delete_item(ptr:Pointer);
function getmem(size:natuint):Pointer;
function getmemsize(ptr:Pointer):natuint;
function allocmem(size:natuint):Pointer;
procedure freemem(var Ptr:pointer);
procedure reallocmem(var Ptr:Pointer;newsize:natuint);
procedure move(var Dest;const Source;Size:natuint);
function frac(x:extended):extended;
function ceil(x:extended):natint;
function floor(x:extended):natint;
function trunc(x:extended):natuint;
function optimize_integer_divide(a,b:natuint):natuint;
function optimize_integer_modulo(a,b:natuint):natuint;
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
function UIntToPChar(UInt:natuint):Pchar;
function UIntToPWChar(UInt:natuint):PWideChar;
function PCharToUint(str:PChar):natuint;
function PWCharToUint(str:PWideChar):natuint;
function IntToPChar(Int:natint):Pchar;
function IntToPWChar(Int:natint):PWideChar;
function PCharToInt(str:PChar):natint;
function PWCharToInt(str:PWideChar):natint;
function ExtendedToPChar(num:Extended;Reserveddecimal:byte):PChar;
function ExtendedToPWChar(num:Extended;Reserveddecimal:byte):PWideChar;
function PCharToExtended(str:PChar):extended;
function PWCharToExtended(str:PWideChar):extended;
function IntPower(a:natint;b:natuint):natint;
function UIntPower(a,b:natuint):natuint;
function ExtendedPower(a:extended;b:natuint):extended;
function UintToHex(inputint:natuint):Pchar;
function UintToWhex(inputint:natuint):PWideChar;
function HexToUint(inputhex:PChar):natuint;
function WHexToUint(inputhex:PWideChar):natuint;
function PCharToPWChar(orgstr:PChar):PWideChar;
function PWCharToPChar(orgstr:PWideChar):PChar;
function PCharIsInt(str:PChar):boolean;
function PWCharIsInt(str:PWideChar):boolean;
function PCharMatchMask(orgstr,maskstr:PChar):boolean;
function PWCharMatchMask(orgstr,maskstr:PWideChar):boolean;
function PCharGetWildcard(orgstr,maskstr:PChar):maskwildcard;
function PWCharGetWildcard(orgstr,maskstr:PWideChar):Wmaskwildcard;
function sys_parameter_construct(original_parameter_items:Psys_parameter_item;original_parameter_number:natuint):sys_parameter;
function sys_parameter_and_function_construct(parameter:sys_parameter;func:sys_parameter_function;result_size:natuint):sys_parameter_function_and_parameter;
function sys_parameter_function_execute(func:sys_parameter_function_and_parameter):Pointer;
procedure sys_parameter_and_function_free(var func:sys_parameter_function_and_parameter);
procedure randomize(seed_data:Pointer;seed_data_size:natuint);
function random(maxnum:extended):extended;
function random_range(left,right:extended):extended;
function irandom(maxnum:natuint):natint;
function irandom_range(left,right:natint):natint;
function PChar_encrypt_to_password(str:Pchar;index:natuint):PWideChar;
function PWChar_encrypt_to_password(str:PWideChar;index:natuint):PWideChar;

var compheap:compilerheap;
    sysheap:systemheap;
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
procedure compheap_delete_item(p:pointer);
var i,j,k,len:natuint;
begin
 i:=1;
 while(i<=compheap.heapcount) do
  begin
   if(natuint(p)>=compheap.heapsection[i,1]) and (natuint(p)<=compheap.heapsection[i,2]) then break;
   inc(i);
  end;
 if(i>compheap.heapcount) then exit;
 len:=compheap.heapsection[i,2]-compheap.heapsection[i,1]+1;
 for j:=i+1 to compheap.heapcount do
  begin
   for k:=compheap.heapsection[j,1] to compheap.heapsection[j,2] do
    begin
     compheap.heapcontent[k-len-Qword(@compheap.heapcontent)+1]:=compheap.heapcontent[k-Qword(@compheap.heapcontent)+1];
     compheap.heapcontent[k-Qword(@compheap.heapcontent)+1]:=0;
    end;
   compheap.heapsection[j-1,1]:=compheap.heapsection[j,1]-len;
   compheap.heapsection[j-1,2]:=compheap.heapsection[j,2]-len;
  end;
 compheap.heapsection[compheap.heapcount,1]:=0;
 compheap.heapsection[compheap.heapcount,2]:=0; 
 dec(compheap.heapcount); inc(compheap.heaprest,len);
end;
function fpc_getmem(size:natuint):Pointer;compilerproc;[public,alias:'FPC_GETMEM'];
var i,istart,cstart:natuint;
begin
 if(compheap.heapcount>=compilermaxsection) then exit(nil);
 if(compheap.heaprest<size) then exit(nil);
 if(size=0) then exit(nil);
 if(compheap.heapcount>0) then istart:=compheap.heapsection[compheap.heapcount,2]+1 else istart:=Natuint(@compheap.heapcontent);
 cstart:=istart-Natuint(@compheap.heapcontent)+1;
 inc(compheap.heapcount);
 compheap.heapsection[compheap.heapcount,1]:=istart;
 compheap.heapsection[compheap.heapcount,2]:=istart+size-1;
 for i:=1 to size do
  begin
   compheap.heapcontent[cstart+i-1]:=0;
  end;
 dec(compheap.heaprest,size);
 fpc_getmem:=Pointer(compheap.heapsection[compheap.heapcount,1]);
end;
procedure fpc_freemem(var p:pointer);compilerproc;[public,alias:'FPC_FREEMEM'];
begin
 if(p<>nil) then 
  begin
   compheap_delete_item(p); p:=nil;
  end
 else p:=nil;
end;
function fpc_allocmem(size:natuint):Pointer;compilerproc;[public,alias:'FPC_ALLOCMEM'];
var i,istart,cstart:natuint;
begin
 if(compheap.heapcount>=compilermaxsection) then exit(nil);
 if(compheap.heaprest<size) then exit(nil);
 if(size=0) then exit(nil);
 if(compheap.heapcount>0) then istart:=compheap.heapsection[compheap.heapcount,2]+1 else istart:=NatUint(@compheap.heapcontent);
 cstart:=istart-Natuint(@compheap.heapcontent)+1;
 inc(compheap.heapcount);
 compheap.heapsection[compheap.heapcount,1]:=istart;
 compheap.heapsection[compheap.heapcount,2]:=istart+size-1;
 for i:=1 to size do
  begin
   compheap.heapcontent[cstart+i-1]:=0;
  end;
 dec(compheap.heaprest,size);
 fpc_allocmem:=Pointer(compheap.heapsection[compheap.heapcount,1]);
end;
procedure fpc_reallocmem(var p:Pointer;size:natuint);compilerproc;[public,alias:'FPC_REALLOCMEM'];
var i,istart,cstart,len,orgsize:Natuint;
    newp:Pointer;
    p1,p2:Pbyte;
begin
 if(compheap.heapcount>=maxsection) then exit;
 if(compheap.heaprest<size) then exit;
 if(size=0) then exit;
 if(compheap.heapcount>0) then istart:=compheap.heapsection[compheap.heapcount,2]+1 else istart:=Natuint(@compheap.heapcontent);
 cstart:=istart-Natuint(@compheap.heapcontent)+1;
 inc(compheap.heapcount);
 compheap.heapsection[compheap.heapcount,1]:=istart;
 compheap.heapsection[compheap.heapcount,2]:=istart+size-1;
 for i:=1 to size do
  begin
   compheap.heapcontent[cstart+i-1]:=0;
  end;
 dec(compheap.heaprest,size);
 newp:=Pointer(compheap.heapsection[compheap.heapcount,1]);
 if(p=nil) then
  begin
   newp:=p; exit;
  end;
 i:=1;
 while(i<=compheap.heapcount)do
  begin
   if(NatUint(p)>=compheap.heapsection[i,1]) and (NatUint(p)<=compheap.heapsection[i,2]) then break;
  end;
 if(i>compheap.heapcount) then exit;
 len:=NatUint(p)-compheap.heapsection[i,1]; 
 orgsize:=compheap.heapsection[i,2]-compheap.heapsection[i,1]+1;
 p1:=Pbyte(compheap.heapsection[i,1]); p2:=@newp^; 
 if(compheap.heapsection[compheap.heapcount,2]-compheap.heapsection[compheap.heapcount,1]+1>=orgsize) then
  begin
   for i:=1 to orgsize do (p2+i-1)^:=(p1+i-1)^;
  end
 else 
  begin
   for i:=1 to compheap.heapsection[compheap.heapcount,2]-compheap.heapsection[compheap.heapcount,1]+1 do (p2+i-1)^:=(p1+i-1)^;
  end;
 compheap_delete_item(p); p:=newp+len-orgsize;
end;
procedure fpc_move(const source;var dest;count:natuint);compilerproc;[public,alias:'FPC_MOVE'];
var p1,p2:Pchar;
    i:natuint;
begin
 p1:=@source; p2:=@dest;
 for i:=1 to count do (p2+i-1)^:=(p1+i-1)^;
end;
procedure compheap_initialize;[public,alias:'compheap_initialize'];
begin
 compheap.heapcount:=0; compheap.heaprest:=compilermaxheap;
end;
procedure sysheap_initialize;[public,alias:'sysheap_initialize'];
begin
 sysheap.heapcount:=0; sysheap.heaprest:=maxheap*sizeof(dword);
end;
procedure sysheap_delete_item(ptr:Pointer);[public,alias:'sysheap_delete_item'];
var procptr1,procptr2:PByte;
    index,i,j,size:natuint;
begin
 index:=1;
 while(index<=sysheap.heapcount) do
  begin
   if(Natuint(ptr)>=sysheap.heapsection[index,1]) and (Natuint(ptr)<=sysheap.heapsection[index,2]) then break;
   inc(index,1);
  end;
 if(index>sysheap.heapcount) then exit;
 size:=sysheap.heapsection[index,2]-sysheap.heapsection[index,1]+1;
 for i:=index+1 to sysheap.heapcount do
  begin
   for j:=sysheap.heapsection[i,1] to sysheap.heapsection[i,2] do
    begin
     procptr1:=Pointer(j-size);
     procptr2:=Pointer(j);
     procptr1^:=procptr2^;
     procptr2^:=0;
    end;
   sysheap.heapsection[i-1,1]:=sysheap.heapsection[i,1]-size;
   sysheap.heapsection[i-1,2]:=sysheap.heapsection[i,2]-size;
  end;
 sysheap.heapsection[sysheap.heapcount,1]:=0;
 sysheap.heapsection[sysheap.heapcount,2]:=0;
 dec(sysheap.heapcount);
 inc(sysheap.heaprest,size);
end;
function getmem(size:natuint):Pointer;[public,alias:'getmem'];
var procptr:PByte;
    i:natuint;
begin 
 if(sysheap.heapcount>=maxsection) then exit(nil);
 if(sysheap.heaprest<size) then exit(nil);
 if(size=0) then exit(nil);
 inc(sysheap.heapcount);
 if(sysheap.heapcount=1) then sysheap.heapsection[sysheap.heapcount,1]:=Natuint(@sysheap.heapcontent) 
 else if(sysheap.heapcount>1) then sysheap.heapsection[sysheap.heapcount,1]:=sysheap.heapsection[sysheap.heapcount-1,2]+1;
 sysheap.heapsection[sysheap.heapcount,2]:=sysheap.heapsection[sysheap.heapcount,1]+size-1;
 for i:=1 to size do
  begin
   procptr:=PByte(sysheap.heapsection[sysheap.heapcount,1]+i-1);
   procptr^:=0;
  end;
 dec(sysheap.heaprest,size);
 getmem:=Pointer(sysheap.heapsection[sysheap.heapcount,1]);
end;
function getmemsize(ptr:Pointer):natuint;[public,alias:'getmemsize'];
var index:natuint;
begin
 if(ptr=nil) then exit(0);
 index:=1;
 while(index<=sysheap.heapcount) do
  begin
   if(Natuint(ptr)>=sysheap.heapsection[index,1]) and (Natuint(ptr)<=sysheap.heapsection[index,2]) then break;
   inc(index,1);
  end;
 if(index<=sysheap.heapcount) then getmemsize:=sysheap.heapsection[index,2]-sysheap.heapsection[index,1]+1 else getmemsize:=0;
end;
function allocmem(size:natuint):Pointer;[public,alias:'allocmem'];
var procptr:PByte;
    i:natuint;
begin 
 if(sysheap.heapcount>=maxsection) then exit(nil);
 if(sysheap.heaprest<size) then exit(nil);
 if(size=0) then exit(nil);
 inc(sysheap.heapcount);
 if(sysheap.heapcount=1) then sysheap.heapsection[sysheap.heapcount,1]:=Natuint(@sysheap.heapcontent) 
 else if(sysheap.heapcount>1) then sysheap.heapsection[sysheap.heapcount,1]:=sysheap.heapsection[sysheap.heapcount-1,2]+1;
 sysheap.heapsection[sysheap.heapcount,2]:=sysheap.heapsection[sysheap.heapcount,1]+size-1;
 for i:=1 to size do
  begin
   procptr:=PByte(sysheap.heapsection[sysheap.heapcount,1]+i-1);
   procptr^:=0;
  end;
 dec(sysheap.heaprest,size);
 allocmem:=Pointer(sysheap.heapsection[sysheap.heapcount,1]);
end;
procedure freemem(var Ptr:pointer);[public,alias:'freemem'];
begin
 if(ptr<>nil) then
  begin
   sysheap_delete_item(ptr); ptr:=nil;
  end;
end;
procedure reallocmem(var Ptr:Pointer;newsize:natuint);[public,alias:'reallocmem'];
var oldptr,newptr:PByte;
    orgsize,i,index,offset:natuint;
begin
 index:=1; 
 while(index<=sysheap.heapcount) do
  begin
   if(Natuint(ptr)>=sysheap.heapsection[index,1]) and (Natuint(ptr)<=sysheap.heapsection[index,2]) then break;
   inc(index,1);
  end;
 if(index>sysheap.heapcount) then 
  begin
   ptr:=allocmem(newsize); exit;
  end;
 oldptr:=Pointer(sysheap.heapsection[index,1]);
 offset:=Natuint(Ptr)-Natuint(oldptr);
 newptr:=allocmem(newsize);
 if(newptr=nil) then exit;
 orgsize:=getmemsize(ptr);
 if(orgsize>=newsize) then
  begin 
   for i:=1 to newsize do (newptr+i-1)^:=(oldptr+i-1)^;
  end
 else if(orgsize<newsize) then
  begin
   for i:=1 to orgsize do (newptr+i-1)^:=(oldptr+i-1)^;
  end;
 freemem(oldptr); ptr:=newptr+offset-orgsize;
end;
procedure move(var Dest;const Source;Size:natuint);[public,alias:'move'];
var srcptr,destptr:PByte;
    i:natuint;
begin
 srcptr:=@source; destptr:=@dest;
 for i:=1 to size do
  begin
   (destptr+i-1)^:=(srcptr+i-1)^;
  end;
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
 if(num>0) then dec(res);
 floor:=res;
end;
function trunc(x:extended):natuint;[public,alias:'trunc'];
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
function optimize_integer_divide(a,b:natuint):natuint;[public,alias:'optimize_integer_divide'];
var procnum1,procnum2,degree,res:natuint;
begin
 procnum1:=a; procnum2:=b; degree:=1; res:=0;
 while(procnum2<=procnum1 shr 1) do
  begin
   procnum2:=procnum2 shl 1;
   degree:=degree shl 1;
  end;
 while(procnum1>=b) do
  begin
   if(procnum1>=procnum2) then
    begin
     procnum1:=procnum1-procnum2;
     res:=res+degree;
    end;
   degree:=degree shr 1;
   procnum2:=procnum2 shr 1;
  end;
 optimize_integer_divide:=res;
end;
function optimize_integer_modulo(a,b:natuint):natuint;[public,alias:'optimize_integer_modulo'];
var res,procnum:natuint;
begin
 res:=a; procnum:=b;
 while(procnum<=res shr 1) do
  begin
   procnum:=procnum shl 1;
  end;
 while(res>=b) do
  begin
   if(res>=procnum) then res:=res-procnum;
   procnum:=procnum shr 1;
  end;
 optimize_integer_modulo:=res;
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
function UIntToPChar(UInt:natuint):Pchar;[public,alias:'uinttochar'];
const numchar:PChar='0123456789';
var i:byte;
    myint:natuint;
    mychar:PChar;
begin
 mychar:=allocmem(sizeof(Char)*31);
 i:=20; myint:=uint; (mychar+30)^:=#0;
 repeat
  begin
   (mychar+i-1)^:=(numchar+myint mod 10)^;
   myint:=myint div 10;
   dec(i);
  end;
 until (myint=0);
 UIntToPChar:=mychar+i;
end;
function UIntToPWChar(UInt:natuint):PWideChar;[public,alias:'uinttopwchar'];
const numchar:PWideChar='0123456789';
var i:byte;
    myint:natuint;
    mychar:PWideChar;
begin
 mychar:=allocmem(sizeof(WideChar)*31);
 i:=20; myint:=uint; (mychar+30)^:=#0;
 repeat
  begin
   (mychar+i-1)^:=(numchar+myint mod 10)^;
   myint:=myint div 10;
   dec(i);
  end;
 until (myint=0);
 UIntToPWChar:=mychar+i;
end;
function PCharToUint(str:PChar):natuint;[public,alias:'PCharToUint'];
const numchar:Pchar='0123456789';
var i,j,res:natuint;
begin
 res:=0; i:=0;
 if(str=nil) then exit(0);
 while ((str+i)^<>#0) do
  begin
   for j:=0 to 9 do 
    if((str+i)^=(numchar+j)^) then 
     begin
      res:=res*10+j;
      break;
     end;
   inc(i);
  end;
 PCharToUint:=res;
end;
function PWCharToUint(str:PWidechar):natuint;[public,alias:'PWCharToUint'];
const numchar:PWidechar='0123456789';
var i,j,res:natuint;
begin
 res:=0; i:=0;
 if(str=nil) then exit(0);
 while ((str+i)^<>#0) do
  begin
   for j:=0 to 9 do 
    if((str+i)^=(numchar+j)^) then 
     begin
      res:=res*10+j;
      break;
     end;
   inc(i);
  end;
 PWCharToUint:=res;
end;
function IntToPChar(int:natint):PChar;[public,alias:'IntToPChar'];
const numchar:Pchar='0123456789';
var negative:boolean=false;
    procnum:natint;
    mystr:Pchar;
    myrightnum:natint=30;
begin
 procnum:=int; strinit(mystr,30);
 if(int<0) then
  begin
   procnum:=-int;
   negative:=true;
  end;
 repeat 
  begin
   (mystr+myrightnum-1)^:=(numchar+procnum mod 10)^;
   dec(myrightnum);
   procnum:=procnum div 10;
  end;
 until (procnum=0);
 if(negative=true)then 
  begin
   (mystr+myrightnum-1)^:='-';
   IntToPChar:=mystr+myrightnum-1;
  end
 else
  begin
   IntToPChar:=mystr+myrightnum;
  end;
end;
function IntToPWChar(int:natint):PWideChar;[public,alias:'IntToPWChar'];
const numchar:PWidechar='0123456789';
var negative:boolean=false;
    procnum:natint;
    mystr:PWidechar;
    myrightnum:natint=30;
begin
 procnum:=int; Wstrinit(mystr,30);
 if(int<0) then
  begin
   procnum:=-int;
   negative:=true;
  end;
 repeat 
  begin
   (mystr+myrightnum-1)^:=(numchar+procnum mod 10)^;
   dec(myrightnum);
   procnum:=procnum div 10;
  end;
 until (procnum=0);
 if(negative=true)then 
  begin
   (mystr+myrightnum-1)^:='-';
   IntToPWChar:=mystr+myrightnum-1;
  end
 else
  begin
   IntToPWChar:=mystr+myrightnum;
  end;
end;
function PCharToInt(str:PChar):natint;[public,alias:'PCharToInt'];
const numchar:PChar='0123456789';
var i,j:natuint;
    res,start:natint;
    negative:boolean;
begin
 res:=0; start:=1;
 if(str=nil) then exit(0);
 if(str^='-') then 
  begin
   start:=2;
   negative:=true;
  end;
 for i:=start to strlen(str) do
  begin
   for j:=0 to 9 do 
    if((str+i-1)^=(numchar+j)^) then 
     begin
      res:=res*10+j;
      break;
     end; 
  end;
 if(negative=true) then PCharToInt:=-res else PCharToInt:=res;
end;
function PWCharToInt(str:PWideChar):natint;[public,alias:'PWCharToInt'];
const numchar:PWideChar='0123456789';
var i,j:natuint;
    res,start:natint;
    negative:boolean;
begin
 res:=0; start:=1;
 if(str=nil) then exit(0);
 if(str^='-') then 
  begin
   start:=2;
   negative:=true;
  end;
 for i:=start to Wstrlen(str) do
  begin
   for j:=0 to 9 do 
    if((str+i-1)^=(numchar+j)^) then 
     begin
      res:=res*10+j;
      break;
     end; 
  end;
 if(negative=true) then PWCharToInt:=-res else PWCharToInt:=res;
end;
function ExtendedToPChar(num:Extended;Reserveddecimal:byte):PChar;[public,alias:'ExtendedToPChar'];
const numchar:PChar='0123456789';
var orgnum,intpart,decpart,procnum:extended;
    partstr1,partstr2,res:PChar;
    isnegative,havedecimal,judge:boolean;
    len1,len2,i,size:natuint;
begin
 if(num>0) then
  begin
   orgnum:=num; isnegative:=false;
  end
 else
  begin
   orgnum:=-num; isnegative:=true;
  end;
 intpart:=orgnum-frac(orgnum); decpart:=frac(orgnum)*ExtendedPower(10,Reserveddecimal);
 partstr1:=nil; partstr2:=nil;
 len1:=0; len2:=0;
 if(decpart<1) then havedecimal:=false else havedecimal:=true;
 procnum:=1;
 while(procnum<=intpart) do
  begin
   procnum:=procnum*10;
  end;
 while(intpart>0) do
  begin
   inc(len1);
   if(procnum>1) then procnum:=procnum/10;
   i:=0;
   while(i<=9) do
    begin
     if(intpart>=procnum*i) and (intpart<procnum*(i+1)) then break;
     inc(i);
    end;
   intpart:=intpart-procnum*i;
   strrealloc(partstr1,len1);
   (partstr1+len1-1)^:=(numchar+i)^;
   if(i>=10) or (procnum<=1) then break;
  end;
 procnum:=1;
 while(procnum<=decpart) do
  begin
   procnum:=procnum*10;
  end;
 while(decpart>=1) do
  begin
   inc(len2);
   if(procnum>1) then procnum:=procnum/10;
   i:=0;
   while(i<=9) do
    begin
     if(decpart>=procnum*i) and (decpart<procnum*(i+1)) then break;
     inc(i);
    end;
   if(decpart>=procnum*(i+0.5)) and (procnum<10) then judge:=true else judge:=false;
   decpart:=decpart-procnum*i;
   strrealloc(partstr2,len2);
   if(judge=false) then (partstr2+len2-1)^:=(numchar+i)^ else (partstr2+len2-1)^:=(numchar+i+1)^;
   if(i>=10) or (procnum<=1) then break;
  end;
 if(len2>0) then size:=len1+len2+2 else size:=len1+1;
 if(isnegative) then
  begin
   if(havedecimal) then
    begin
     strinit(res,1+len1+1+reserveddecimal);
     strset(res,'-');
     strcat(res,partstr1);
     strcat(res,'.');
     for i:=1 to reserveddecimal-len2 do strcat(res,'0');
     strcat(res,partstr2);
    end
   else
    begin
     strinit(res,1+len1);
     strset(res,'-');
     strcat(res,partstr1);
    end;
  end
 else
  begin
   if(havedecimal) then
    begin
     strinit(res,len1+1+reserveddecimal);
     strset(res,partstr1);
     strcat(res,'.');
     for i:=1 to reserveddecimal-len2 do strcat(res,'0');
     strcat(res,partstr2);
    end
   else
    begin
     strinit(res,len1);
     strset(res,partstr1);
    end;
  end;
 size:=getmemsize(partstr1)+getmemsize(partstr2);
 if(havedecimal) then strfree(partstr2);
 strfree(partstr1);
 res:=Pointer(Pointer(res)-size);
 ExtendedToPChar:=res;
end; 
function ExtendedToPWChar(num:Extended;Reserveddecimal:byte):PWideChar;[public,alias:'ExtendedToPWChar'];
const numchar:PWideChar='0123456789';
var orgnum,intpart,decpart,procnum:extended;
    partstr1,partstr2,res:PWideChar;
    isnegative,havedecimal,judge:boolean;
    len1,len2,i,size:natuint;
begin
 if(num>0) then
  begin
   orgnum:=num; isnegative:=false;
  end
 else
  begin
   orgnum:=-num; isnegative:=true;
  end;
 intpart:=orgnum-frac(orgnum); decpart:=frac(orgnum)*ExtendedPower(10,Reserveddecimal);
 partstr1:=nil; partstr2:=nil;
 len1:=0; len2:=0;
 if(decpart<1) then havedecimal:=false else havedecimal:=true;
 procnum:=1;
 while(procnum<=intpart) do
  begin
   procnum:=procnum*10;
  end;
 while(intpart>0) do
  begin
   inc(len1);
   if(procnum>1) then procnum:=procnum/10;
   i:=0;
   while(i<=9) do
    begin
     if(intpart>=procnum*i) and (intpart<procnum*(i+1)) then break;
     inc(i);
    end;
   intpart:=intpart-procnum*i;
   Wstrrealloc(partstr1,len1);
   (partstr1+len1-1)^:=(numchar+i)^;
   if(i>=10) or (procnum<=1) then break;
  end;
 procnum:=1;
 while(procnum<=decpart) do
  begin
   procnum:=procnum*10;
  end;
 while(decpart>=1) do
  begin
   inc(len2);
   if(procnum>1) then procnum:=procnum/10;
   i:=0;
   while(i<=9) do
    begin
     if(decpart>=procnum*i) and (decpart<procnum*(i+1)) then break;
     inc(i);
    end;
   if(decpart>=procnum*(i+0.5)) and (procnum<10) then judge:=true else judge:=false;
   decpart:=decpart-procnum*i;
   Wstrrealloc(partstr2,len2);
   if(judge=false) then (partstr2+len2-1)^:=(numchar+i)^ else (partstr2+len2-1)^:=(numchar+i+1)^;
   if(i>=10) or (procnum<=1) then break;
  end;
 if(len2>0) then size:=len1+len2+2 else size:=len1+1;
 if(isnegative) then
  begin
   if(havedecimal) then
    begin
     Wstrinit(res,1+len1+1+reserveddecimal);
     Wstrset(res,'-');
     Wstrcat(res,partstr1);
     Wstrcat(res,'.');
     for i:=1 to reserveddecimal-len2 do Wstrcat(res,'0');
     Wstrcat(res,partstr2);
    end
   else
    begin
     Wstrinit(res,1+len1);
     Wstrset(res,'-');
     Wstrcat(res,partstr1);
    end;
  end
 else
  begin
   if(havedecimal) then
    begin
     Wstrinit(res,len1+1+reserveddecimal);
     Wstrset(res,partstr1);
     Wstrcat(res,'.');
     for i:=1 to reserveddecimal-len2 do Wstrcat(res,'0');
     Wstrcat(res,partstr2);
    end
   else
    begin
     Wstrinit(res,len1);
     Wstrset(res,partstr1);
    end;
  end;
 size:=getmemsize(partstr1)+getmemsize(partstr2);
 if(havedecimal) then Wstrfree(partstr2);
 Wstrfree(partstr1);
 res:=Pointer(Pointer(res)-size);
 ExtendedToPWChar:=res;
end;
function PCharToExtended(str:PChar):extended;[public,alias:'PCharToExtended'];
const numchar:PChar='0123456789';
var intpart,decpart:extended;
    position,startx,i,j,len:natuint;
begin
 position:=strpos(str,'.',1);
 if(str^='-') then startx:=2 else startx:=1;
 len:=Strlen(str); intpart:=0; decpart:=0;
 if(position>0) then
  begin
   for i:=startx to position-1 do
    begin
     j:=0;
     while(j<=9) do if((str+i-1)^=(numchar+j)^) then break;
     intpart:=intpart*10+j;
    end;
   for i:=position+1 to len do
    begin
     j:=0;
     while(j<=9) do if((str+i-1)^=(numchar+j)^) then break;
     decpart:=decpart*10+j;
    end;
  end
 else
  begin
   for i:=startx to len do
    begin
     j:=0;
     while(j<=9) do if((str+i-1)^=(numchar+j)^) then break;
     intpart:=intpart*10+j;
    end;
  end;
 if(startx=2) then
  begin
   PCharToExtended:=intpart+decpart/ExtendedPower(10,len-position);
  end
 else if(startx=1) then
  begin
   PCharToExtended:=intpart+decpart/ExtendedPower(10,len-position);
  end;
end; 
function PWCharToExtended(str:PWideChar):extended;[public,alias:'PWCharToExtended'];
const numchar:PWideChar='0123456789';
var intpart,decpart:extended;
    position,startx,i,j,len:natuint;
begin
 position:=Wstrpos(str,'.',1);
 if(str^='-') then startx:=2 else startx:=1;
 len:=WStrlen(str); intpart:=0; decpart:=0;
 if(position>0) then
  begin
   for i:=startx to position-1 do
    begin
     j:=0;
     while(j<=9) do if((str+i-1)^=(numchar+j)^) then break;
     intpart:=intpart*10+j;
    end;
   for i:=position+1 to len do
    begin
     j:=0;
     while(j<=9) do if((str+i-1)^=(numchar+j)^) then break;
     decpart:=decpart*10+j;
    end;
  end
 else
  begin
   for i:=startx to len do
    begin
     j:=0;
     while(j<=9) do if((str+i-1)^=(numchar+j)^) then break;
     intpart:=intpart*10+j;
    end;
  end;
 if(startx=2) then
  begin
   PWCharToExtended:=intpart+decpart/ExtendedPower(10,len-position);
  end
 else if(startx=1) then
  begin
   PWCharToExtended:=intpart+decpart/ExtendedPower(10,len-position);
  end;
end; 
function IntPower(a:natint;b:natuint):natint;[public,alias:'IntPower'];
var i:natuint;
    res:natint;
begin
 res:=1;
 for i:=1 to b do
  begin
   res:=res*a;
  end;
 intPower:=res;
end;
function UIntPower(a,b:natuint):natuint;[public,alias:'UintPower'];
var res,i:natuint;
begin
 res:=1;
 for i:=1 to b do
  begin
   res:=res*a;
  end;
 UintPower:=res;
end;
function ExtendedPower(a:extended;b:natuint):extended;[public,alias:'ExtendedPower'];
var res:extended;
    i:natuint;
begin
 res:=1;
 for i:=1 to b do
  begin
   res:=res*a;
  end;
 ExtendedPower:=res;
end;
function UintToHex(inputint:natuint):Pchar;[public,alias:'UintToHex'];
const hexcode:PChar='0123456789ABCDEF';
var i,j,k,procint,procnum:natuint;
    str:PChar;
begin
 i:=0; procint:=inputint; procnum:=1;
 while(optimize_integer_divide(procint,procnum)>=16) do 
  begin
   procnum:=procnum*16;
   inc(i);
  end;
 strinit(str,i+1);
 for j:=i+1 downto 1 do
  begin 
   (str+j-1)^:=(hexcode+procint mod 16)^;
   procint:=procint div 16;
  end;
 (str+i+1)^:=#0;
 UintToHex:=str;
end;
function UintToWhex(inputint:natuint):PWideChar;[public,alias:'UintToWHex'];
const hexcode:PWideChar='0123456789ABCDEF';
var i,j,k,procint,procnum:natuint;
    str:PWideChar;
begin
 i:=0; procint:=inputint; procnum:=1;
 while(optimize_integer_divide(procint,procnum)>=16) do 
  begin
   procnum:=procnum*16;
   inc(i);
  end;
 Wstrinit(str,i+1);
 for j:=i+1 downto 1 do
  begin 
   (str+j-1)^:=(hexcode+procint mod 16)^;
   procint:=procint div 16;
  end;
 (str+i+1)^:=#0;
 UintToWHex:=str;
end;
function HexToUint(inputhex:PChar):natuint;[public,alias:'HexToUint'];
const hexcode1:PChar='0123456789ABCDEF';
      hexcode2:PChar='0123456789abcdef';
var res,i,j:natuint;
begin
 i:=1; res:=0;
 while((inputhex+i-1)^<>#0) do
  begin
   j:=0;
   while(j<=15) and ((inputhex+i-1)^<>(hexcode1+j)^) and ((inputhex+i-1)^<>(hexcode2+j)^) do inc(j);
   res:=res*16+j;
  end;
 HexToUint:=res;
end;
function WHexToUint(inputhex:PWideChar):natuint;[public,alias:'WHexToUint'];
const hexcode1:PWideChar='0123456789ABCDEF';
      hexcode2:PWideChar='0123456789abcdef';
var res,i,j:natuint;
begin
 i:=1; res:=0;
 while((inputhex+i-1)^<>#0) do
  begin
   j:=0;
   while(j<=15) and ((inputhex+i-1)^<>(hexcode1+j)^) and ((inputhex+i-1)^<>(hexcode2+j)^) do inc(j);
   res:=res*16+j;
  end;
 WHexToUint:=res;
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
function PCharMatchMask(orgstr,maskstr:PChar):boolean;[public,alias:'PCharMatchMask'];
var i,j,k,len1,len2:natuint;
begin
 len1:=strlen(orgstr); len2:=strlen(maskstr); i:=1; j:=1;
 while(i<=len1) and (j<=len2) do
  begin
   if((maskstr+j-1)^='*') then
    begin
     if((maskstr+j)^='*') then
      begin
       inc(j); inc(i);
      end
     else
      begin
       k:=i+1;
       while(k<=len1) do
        begin
         if((maskstr+j)^=(orgstr+k-1)^) then break;
         inc(k);
        end;
       if(k>len1) then break else
        begin
         i:=k; inc(j);
        end;
      end;
    end
   else if((maskstr+j-1)^='?') then
    begin
     inc(j); inc(i);
    end
   else if((maskstr+j-1)^=(orgstr+i-1)^) then
    begin
     inc(j); inc(i);
    end
   else break;
  end;
 if(i<=len1) and (j<=len2) then PCharMatchMask:=false else PCharMatchMask:=true;
end;
function PWCharMatchMask(orgstr,maskstr:PWideChar):boolean;[public,alias:'PWCharMatchMask'];
var i,j,k,len1,len2:natuint;
begin
 len1:=Wstrlen(orgstr); len2:=Wstrlen(maskstr); i:=1; j:=1;
 while(i<=len1) and (j<=len2) do
  begin
   if((maskstr+j-1)^='*') then
    begin
     if((maskstr+j)^='*') then
      begin
       inc(j); inc(i);
      end
     else
      begin
       k:=i+1;
       while(k<=len1) do
        begin
         if((maskstr+j)^=(orgstr+k-1)^) then break;
         inc(k);
        end;
       if(k>len1) then break else
        begin
         i:=k; inc(j);
        end;
      end;
    end
   else if((maskstr+j-1)^='?') then
    begin
     inc(j); inc(i);
    end
   else if((maskstr+j-1)^=(orgstr+i-1)^) then
    begin
     inc(j); inc(i);
    end
   else break;
  end;
 if(i<=len1) and (j<=len2) then PWCharMatchMask:=false else PWCharMatchMask:=true;
end;
function PCharGetWildcard(orgstr,maskstr:PChar):maskwildcard;[public,alias:'PCharGetWildcard'];
var res:maskwildcard;
    i,j,k,m,len1,len2,spos,slen,size:natuint;
begin
 res.liststr:=nil; res.listcount:=0;
 len1:=strlen(orgstr); len2:=strlen(maskstr); i:=1; j:=1;
 while(i<=len1) and (j<=len2) do
  begin
   if((maskstr+j-1)^='*') then
    begin
     inc(res.listcount);
     size:=getmemsize(res.liststr);
     ReallocMem(res.liststr,sizeof(PChar)*res.listcount);
     res.listlen:=Pointer(Pointer(res.listlen)-size);
     size:=size+getmemsize(res.listlen);
     ReallocMem(res.listlen,sizeof(natuint)*res.listcount);
     res.listpos:=Pointer(Pointer(res.listpos)-size);
     size:=size+getmemsize(res.listpos);
     ReallocMem(res.listpos,sizeof(natuint)*res.listcount);
     for m:=1 to res.listcount-1 do (res.liststr+m-1)^:=PChar(Pointer((res.liststr+m-1)^)-size);
     k:=j+1; spos:=i; slen:=0;
     while((maskstr+k-1)^='*') do inc(k);
     while((orgstr+spos+slen-1)^<>(maskstr+k-1)^) and (spos+slen<=len1) do inc(slen);
     if(k>len1) then
      begin
       dec(res.listcount);
       size:=getmemsize(res.liststr);
       ReallocMem(res.liststr,sizeof(PChar)*res.listcount);
       for m:=1 to res.listcount do (res.liststr+m-1)^:=PChar(Pointer((res.liststr+m-1)^)-size);
       break;
      end;
     (res.liststr+res.listcount-1)^:=strcopy(orgstr,spos,slen);
     (res.listlen+res.listcount-1)^:=spos;
     (res.listpos+res.listcount-1)^:=k-j;
     i:=spos+slen; j:=k;
    end
   else if((maskstr+j-1)^='?') then
    begin
     inc(res.listcount);
     size:=getmemsize(res.liststr);
     ReallocMem(res.liststr,sizeof(PChar)*res.listcount);
     res.listlen:=Pointer(Pointer(res.listlen)-size);
     size:=size+getmemsize(res.listlen);
     ReallocMem(res.listlen,sizeof(natuint)*res.listcount);
     res.listpos:=Pointer(Pointer(res.listpos)-size);
     size:=size+getmemsize(res.listpos);
     ReallocMem(res.listpos,sizeof(natuint)*res.listcount);
     for m:=1 to res.listcount-1 do (res.liststr+m-1)^:=PChar(Pointer((res.liststr+m-1)^)-size);
     k:=j+1; spos:=i; slen:=1;
     while((maskstr+k+slen-1)^='?') do inc(slen);
     (res.liststr+res.listcount-1)^:=strcopy(orgstr,spos,slen);
     (res.listlen+res.listcount-1)^:=spos;
     (res.listpos+res.listcount-1)^:=slen;
     i:=spos+slen; j:=k;
    end
   else if((maskstr+j-1)^=(orgstr+i-1)^) then
    begin
     inc(i); inc(j);
    end
   else break;
  end;
 if(i<=len1) and (j<=len2) then
  begin
   res.liststr:=nil; res.listcount:=0;
  end;
 PCharGetWildCard:=res;
end;
function PWCharGetWildcard(orgstr,maskstr:PWideChar):Wmaskwildcard;[public,alias:'PWCharGetWildcard'];
var res:Wmaskwildcard;
    i,j,k,m,len1,len2,spos,slen,size:natuint;
begin
 res.liststr:=nil; res.listcount:=0;
 len1:=Wstrlen(orgstr); len2:=Wstrlen(maskstr); i:=1; j:=1;
 while(i<=len1) and (j<=len2) do
  begin
   if((maskstr+j-1)^='*') then
    begin
     inc(res.listcount);
     size:=getmemsize(res.liststr);
     ReallocMem(res.liststr,sizeof(PWideChar)*res.listcount);
     res.listlen:=Pointer(Pointer(res.listlen)-size);
     size:=size+getmemsize(res.listlen);
     ReallocMem(res.listlen,sizeof(natuint)*res.listcount);
     res.listpos:=Pointer(Pointer(res.listpos)-size);
     size:=size+getmemsize(res.listpos);
     ReallocMem(res.listpos,sizeof(natuint)*res.listcount);
     for m:=1 to res.listcount-1 do (res.liststr+m-1)^:=PWideChar(Pointer((res.liststr+m-1)^)-size);
     k:=j+1; spos:=i; slen:=0;
     while((maskstr+k-1)^='*') do inc(k);
     while((orgstr+spos+slen-1)^<>(maskstr+k-1)^) and (spos+slen<=len1) do inc(slen);
     if(k>len1) then
      begin
       dec(res.listcount);
       size:=getmemsize(res.liststr);
       ReallocMem(res.liststr,sizeof(PWideChar)*res.listcount);
       for m:=1 to res.listcount do (res.liststr+m-1)^:=PWideChar(Pointer((res.liststr+m-1)^)-size);
       break;
      end;
     (res.liststr+res.listcount-1)^:=Wstrcopy(orgstr,spos,slen);
     (res.listlen+res.listcount-1)^:=spos;
     (res.listpos+res.listcount-1)^:=k-j;
     i:=spos+slen; j:=k;
    end
   else if((maskstr+j-1)^='?') then
    begin
     inc(res.listcount);
     size:=getmemsize(res.liststr);
     ReallocMem(res.liststr,sizeof(PWideChar)*res.listcount);
     res.listlen:=Pointer(Pointer(res.listlen)-size);
     size:=size+getmemsize(res.listlen);
     ReallocMem(res.listlen,sizeof(natuint)*res.listcount);
     res.listpos:=Pointer(Pointer(res.listpos)-size);
     size:=size+getmemsize(res.listpos);
     ReallocMem(res.listpos,sizeof(natuint)*res.listcount);
     for m:=1 to res.listcount-1 do (res.liststr+m-1)^:=PWideChar(Pointer((res.liststr+m-1)^)-size);
     k:=j+1; spos:=i; slen:=1;
     while((maskstr+k+slen-1)^='?') do inc(slen);
     (res.liststr+res.listcount-1)^:=Wstrcopy(orgstr,spos,slen);
     (res.listlen+res.listcount-1)^:=spos;
     (res.listpos+res.listcount-1)^:=slen;
     i:=spos+slen; j:=k;
    end
   else if((maskstr+j-1)^=(orgstr+i-1)^) then
    begin
     inc(i); inc(j);
    end
   else break;
  end;
 if(i<=len1) and (j<=len2) then
  begin
   res.liststr:=nil; res.listcount:=0;
  end;
 PWCharGetWildCard:=res;
end; 
function sys_parameter_construct(original_parameter_items:Psys_parameter_item;original_parameter_number:natuint):sys_parameter;[public,alias:'sys_parameter_construct'];
var i,size,totalsize:natuint;
    res:sys_parameter;
begin
 res.param_size:=allocmem(sizeof(natuint)*original_parameter_number);
 res.param_count:=original_parameter_number; size:=0; totalsize:=0;
 res.param_content:=nil;
 for i:=1 to original_parameter_number do
  begin
   size:=(original_parameter_items+i-1)^.item_size;
   ReallocMem(res.param_content,totalsize+size);
   Move((res.param_content+totalsize)^,(original_parameter_items+i-1)^.item_content^,size);
   totalsize:=totalsize+size;
   (res.param_size+i-1)^:=size;
  end;
 sys_parameter_construct:=res;
end;
function sys_parameter_and_function_construct(parameter:sys_parameter;func:sys_parameter_function;result_size:natuint):sys_parameter_function_and_parameter;[public,alias:'sys_parameter_and_function_construct'];
var res:sys_parameter_function_and_parameter;
begin
 res.parameter_function:=func;
 res.parameter_parameter:=parameter;
 res.parameter_result_size:=result_size;
 res.parameter_disposed:=false;
 sys_parameter_and_function_construct:=res;
end;
function sys_parameter_function_execute(func:sys_parameter_function_and_parameter):Pointer;[public,alias:'sys_parameter_function_execute'];
var ptr:PByte;
begin
 if(func.parameter_result_size>0) then
  begin
   ptr:=func.parameter_function.func(func.parameter_parameter);
   sys_parameter_function_execute:=ptr;
  end
 else if(func.parameter_result_size=0) then
  begin
   func.parameter_function.proc(func.parameter_parameter);
   sys_parameter_function_execute:=nil;
  end;
end;
procedure sys_parameter_and_function_free(var func:sys_parameter_function_and_parameter);[public,alias:'sys_parameter_and_function_free'];
begin
 freemem(func.parameter_parameter.param_content); 
 freemem(func.parameter_parameter.param_size); 
 func.parameter_parameter.param_count:=0; 
 func.parameter_disposed:=true;
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
function PChar_encrypt_to_password(str:Pchar;index:natuint):PWideChar;[public,alias:'PChar_encrypt_to_password'];
var res:PWideChar;
    mybyte,mybyte1,mybyte2:byte;
    i,passwdindex1,passwdindex2,len:natuint;
begin
 passwdindex1:=(index*4+3) mod 5+1; len:=strlen(str); Wstrinit(res,len);
 for i:=1 to index do
  begin
   passwdindex2:=(i*3+7) mod 11+1;
   mybyte:=Byte((str+i-1)^);
   mybyte1:=(Byte((passwdstr+mybyte*2)^)+passwdstroffset[passwdindex1,passwdindex2]+256) mod 256;
   mybyte2:=(Byte((passwdstr+mybyte*2+1)^)+passwdstroffset[passwdindex1,passwdindex2]+256) mod 256;
   (res+i-1)^:=WideChar(mybyte1*255+mybyte2);
  end;
 (res+len)^:=#0;
end;
function PWChar_encrypt_to_password(str:PWideChar;index:natuint):PWideChar;[public,alias:'PWChar_to_encrypt_to_password'];
var res:PWideChar;
    mybyte,mysubbyte1,mysubbyte2,mybyte1,mybyte2,mybyte3,mybyte4:word;
    i,passwdindex1,passwdindex2,len:natuint;
begin
 passwdindex1:=(index*4+3) mod 5+1; len:=Wstrlen(str); Wstrinit(res,len*2);
 for i:=1 to index do
  begin
   passwdindex2:=(i*3+7) mod 11+1;
   mybyte:=word((str+i-1)^); mysubbyte1:=mybyte shr 8; mysubbyte2:=mybyte-mybyte shr 8 shl 8;
   mybyte1:=(Byte((passwdstr+mysubbyte1*2)^)+passwdstroffset[passwdindex1,passwdindex2]+256) mod 256;
   mybyte2:=(Byte((passwdstr+mysubbyte1*2+1)^)+passwdstroffset[passwdindex1,passwdindex2]+256) mod 256;
   mybyte3:=(Byte((passwdstr+mysubbyte2*2)^)+passwdstroffset[passwdindex1,passwdindex2]+256) mod 256;
   mybyte4:=(Byte((passwdstr+mysubbyte2*2+1)^)+passwdstroffset[passwdindex1,passwdindex2]+256) mod 256;
   (res+i*2-2)^:=WideChar(mybyte1*256+mybyte2);
   (res+i*2-1)^:=WideChar(mybyte3*256+mybyte4);
  end;
 (res+len*2)^:=#0;
end;

end.
