unit convbase;

{$mode ObjFPC}

interface

uses Classes,SysUtils,binarybase,convmem;

type file_section_list=packed record
                       secindex:Pword;
                       seccount:byte;
                       end;

function conv_read_elf(fn:string):elf_file;
function conv_elf_to_efi(elf:elf_file;apptype:byte):pe_file;
procedure conv_efi_write(efi:pe_file;fn:string);
procedure conv_elf_free(var elf:elf_file);
procedure conv_pe_free(var pe:pe_file);
procedure conv_heap_initialize;
procedure conv_heap_finalize;

implementation

procedure conv_io_read(fn:string;var dest;offset,size:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 f:=TFileStream.Create(fn,fmOpenRead);
 f.Seek(offset,0);
 if(size-size shr 2 shl 2=0) then
  begin
   for i:=1 to size shr 2 do f.Read(Pdword(Pointer(@dest)+(i-1)*4)^,4);
  end
 else if(size-size shr 1 shl 1=0) then
  begin
   for i:=1 to size shr 1 do f.Read(Pword(Pointer(@dest)+(i-1)*2)^,2);
  end
 else
  begin
   for i:=1 to size do f.Read(PByte(Pointer(@dest)+i-1)^,1);
  end;
 f.Free;
end;
procedure conv_io_write(fn:string;const source;offset,size:SizeUint);
var f:TFileStream;
    i:SizeUint;
begin
 if(FileExists(fn)) then f:=TFileStream.Create(fn,fmOpenWrite) else f:=TFileStream.Create(fn,fmCreate);
 f.Seek(offset,0);
 if(size-size shr 2 shl 2=0) then
  begin
   for i:=1 to size shr 2 do f.Write(Pdword(Pointer(@source)+(i-1)*4)^,4);
  end
 else if(size-size shr 1 shl 1=0) then
  begin
   for i:=1 to size shr 1 do f.Write(Pword(Pointer(@source)+(i-1)*2)^,2);
  end
 else
  begin
   for i:=1 to size do f.Write(Pbyte(Pointer(@source)+i-1)^,1);
  end;
 f.Free;
end;
function conv_check_elf_header(fn:string):boolean;
var checkbyte:array[1..16] of byte;
    i:byte;
begin
 conv_io_read(fn,checkbyte,0,16);
 i:=1;
 while(i<=4)do
  begin
   if(checkbyte[i]<>elf_file_identify[i]) then break;
   inc(i);
  end;
 if(i>4) then Result:=true else Result:=false;
end;
procedure conv_heap_initialize;
var ptr:Pointer;
begin
 ptr:=allocmem(1024*1024*512);
 memheap:=heap_initialize(SizeUint(ptr),SizeUint(ptr+1024*1024*512-1),4);
end;
function conv_allocmem(Size:SizeUint):Pointer;
begin
 conv_allocmem:=tydq_allocmem(Size);
end;
function conv_reallocmem(var ptr:Pointer;Size:SizeUint):Pointer;
begin
 conv_reallocmem:=tydq_reallocmem(ptr,Size);
end;
procedure conv_freemem(var ptr:Pointer);
begin
 tydq_freemem(ptr);
end;
procedure conv_move(const Source;Var Dest;Size:SizeUint);
begin
 tydq_move(source,dest,size);
end;
procedure conv_heap_finalize;
begin
 FreeMem(memheap.mem_start);
end;
function conv_read_elf(fn:string):elf_file;
var checkbyte:array[1..16] of byte;
    contentoffset,contentsize,j:SizeUint;
    i:word;
begin
 if(conv_check_elf_header(fn)=false) then
  begin
   writeln('ERROR:It is not elf file,program terminated.');
   readln;
   abort;
  end;
 conv_io_read(fn,checkbyte,0,16);
 if(checkbyte[elf_class_pos]=elf_class_none) then
  begin
   writeln('ERROR:Elf Class is not specified.');
   readln;
   abort;
  end
 else if(checkbyte[elf_class_pos]=elf_class_32) then
  begin
   Result.bit:=32; conv_io_read(fn,Result.header.head32,0,sizeof(elf32_header));
   if(Result.header.head32.elf32_type<>elf_type_executable) and
   (Result.header.head32.elf32_type<>elf_type_dynamic) then
    begin
     writeln('ERROR:Elf file type is not executable or library.');
     readln;
     abort;
    end;
   if(Result.header.head32.elf32_machine<>elf_machine_386)
   and(Result.header.head32.elf32_machine<>elf_machine_arm)
   and(Result.header.head32.elf32_machine<>elf_machine_riscv)
   and(Result.header.head32.elf32_machine<>elf_machine_loongarch) then
    begin
     writeln('ERROR:Architecture of elf file is unsupported.');
     readln;
     abort;
    end;
   Result.secheader:=conv_allocmem(Result.header.head32.elf32_section_header_number*sizeof(elf_section_header));
   Result.seccontent:=conv_allocmem(Result.header.head32.elf32_section_header_number*sizeof(elf_content));
   i:=1;
   while(i<=Result.header.head32.elf32_section_header_number)do
    begin
     conv_io_read(fn,Pelf_section_header(Result.secheader+i-1)^.sec32,
     Result.header.head32.elf32_section_header_offset+(i-1)*sizeof(elf32_section_header),
     sizeof(elf32_section_header));
     if(Pelf_section_header(Result.secheader+i-1)^.sec32.section_header_size>0)
     and(Pelf_section_header(Result.secheader+i-1)^.sec32.section_header_type<>
     elf_section_header_nobits) then
      begin
       contentoffset:=Pelf_section_header(Result.secheader+i-1)^.sec32.section_header_offset;
       contentsize:=Pelf_section_header(Result.secheader+i-1)^.sec32.section_header_size;
       Pelf_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(contentsize);
       for j:=1 to contentsize do
         begin
          conv_io_read(fn,(Pelf_content(Result.seccontent+i-1)^.ptr1+j-1)^,
          contentoffset+j-1,1);
         end;
      end
     else if(Pelf_section_header(Result.secheader+i-1)^.sec32.section_header_size>0)
     and(Pelf_section_header(Result.secheader+i-1)^.sec32.section_header_type=
     elf_section_header_nobits) then
      begin
       contentoffset:=Pelf_section_header(Result.secheader+i-1)^.sec32.section_header_offset;
       contentsize:=Pelf_section_header(Result.secheader+i-1)^.sec32.section_header_size;
       Pelf_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(contentsize);
      end
     else Pelf_content(Result.seccontent+i-1)^.ptr1:=nil;
     inc(i);
    end;
   Result.proheader:=conv_allocmem(Result.header.head32.elf32_program_header_number*sizeof(elf_program_header));
   i:=1;
   while(i<=Result.header.head32.elf32_program_header_number)do
    begin
     conv_io_read(fn,Pelf_program_header(Result.proheader+i-1)^.pro32,
     Result.header.head32.elf32_program_header_offset+(i-1)*sizeof(elf32_program_header),
     sizeof(elf32_program_header));
     inc(i);
    end;
  end
 else if(checkbyte[elf_class_pos]=elf_class_64) then
  begin
   Result.bit:=64; conv_io_read(fn,Result.header.head64,0,sizeof(elf64_header));
   if(Result.header.head64.elf64_type<>elf_type_executable) and
   (Result.header.head64.elf64_type<>elf_type_dynamic) then
    begin
     writeln('ERROR:Elf file type is not executable or library.');
     readln;
     abort;
    end;
   if(Result.header.head64.elf64_machine<>elf_machine_x86_64)
   and(Result.header.head64.elf64_machine<>elf_machine_aarch64)
   and(Result.header.head64.elf64_machine<>elf_machine_riscv)
   and(Result.header.head64.elf64_machine<>elf_machine_loongarch)then
    begin
     writeln('ERROR:Architecture of elf file is unsupported.');
     readln;
     abort;
    end;
   Result.secheader:=conv_allocmem(Result.header.head64.elf64_section_header_number*sizeof(elf_section_header));
   Result.seccontent:=conv_allocmem(Result.header.head64.elf64_section_header_number*sizeof(elf_content));
   i:=1;
   while(i<=Result.header.head64.elf64_section_header_number)do
    begin
     conv_io_read(fn,Pelf_section_header(Result.secheader+i-1)^.sec64,
     Result.header.head64.elf64_section_header_offset+(i-1)*sizeof(elf64_section_header),
     sizeof(elf64_section_header));
     if(Pelf_section_header(Result.secheader+i-1)^.sec64.section_header_size>0)
     and(Pelf_section_header(Result.secheader+i-1)^.sec64.section_header_type<>
     elf_section_header_nobits) then
      begin
       contentoffset:=Pelf_section_header(Result.secheader+i-1)^.sec64.section_header_offset;
       contentsize:=Pelf_section_header(Result.secheader+i-1)^.sec64.section_header_size;
       Pelf_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(contentsize);
       for j:=1 to contentsize do
         begin
          conv_io_read(fn,(Pelf_content(Result.seccontent+i-1)^.ptr1+j-1)^,
          contentoffset+j-1,1);
         end;
      end
     else if(Pelf_section_header(Result.secheader+i-1)^.sec64.section_header_size>0)
     and(Pelf_section_header(Result.secheader+i-1)^.sec64.section_header_type=
     elf_section_header_nobits) then
      begin
       contentoffset:=Pelf_section_header(Result.secheader+i-1)^.sec64.section_header_offset;
       contentsize:=Pelf_section_header(Result.secheader+i-1)^.sec64.section_header_size;
       Pelf_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(contentsize);
      end
     else Pelf_content(Result.seccontent+i-1)^.ptr1:=nil;
     inc(i);
    end;
   Result.proheader:=conv_allocmem(Result.header.head64.elf64_program_header_number*sizeof(elf_program_header));
   i:=1;
   while(i<=Result.header.head64.elf64_program_header_number)do
    begin
     conv_io_read(fn,Pelf_program_header(Result.proheader+i-1)^.pro64,
     Result.header.head64.elf64_program_header_offset+(i-1)*sizeof(elf64_program_header),
     sizeof(elf64_program_header));
     inc(i);
    end;
  end;
 writeln('elf file loaded to memory!');
end;
function conv_get_elf_section_name(elf:elf_file;index:SizeUint):PChar;
var i,len:SizeUint;
    ptr:PChar;
begin
 Result:=conv_allocmem(1); len:=0;
 if(elf.bit=32) then
  begin
   i:=Pelf_section_header(elf.secheader+index-1)^.sec32.section_header_name;
   ptr:=PChar(Pelf_content(
   elf.seccontent+elf.header.head32.elf32_section_header_string_table_index)^.ptr1);
   while((ptr+i-1)^<>#0)do
    begin
     inc(len);
     conv_reallocmem(Result,len+1);
     (Result+len-1)^:=(ptr+i-1)^;
     inc(i);
    end;
   (Result+len)^:=#0;
  end
 else if(elf.bit=64) then
  begin
   i:=Pelf_section_header(elf.secheader+index-1)^.sec64.section_header_name;
   ptr:=PChar(Pelf_content(
   elf.seccontent+elf.header.head64.elf64_section_header_string_table_index)^.ptr1);
   while((ptr+i-1)^<>#0)do
    begin
     inc(len);
     conv_reallocmem(Result,len+1);
     (Result+len-1)^:=(ptr+i-1)^;
     inc(i);
    end;
   (Result+len)^:=#0;
  end;
end;
function conv_generate_crc32(buf:PByte;buflen:Dword;initvalue:Dword):Dword;
const crc32_table:array[1..256] of dword=
($00000000, $04c11db7, $09823b6e, $0d4326d9,
 $130476dc, $17c56b6b, $1a864db2, $1e475005,
 $2608edb8, $22c9f00f, $2f8ad6d6, $2b4bcb61,
 $350c9b64, $31cd86d3, $3c8ea00a, $384fbdbd,
 $4c11db70, $48d0c6c7, $4593e01e, $4152fda9,
 $5f15adac, $5bd4b01b, $569796c2, $52568b75,
 $6a1936c8, $6ed82b7f, $639b0da6, $675a1011,
 $791d4014, $7ddc5da3, $709f7b7a, $745e66cd,
 $9823b6e0, $9ce2ab57, $91a18d8e, $95609039,
 $8b27c03c, $8fe6dd8b, $82a5fb52, $8664e6e5,
 $be2b5b58, $baea46ef, $b7a96036, $b3687d81,
 $ad2f2d84, $a9ee3033, $a4ad16ea, $a06c0b5d,
 $d4326d90, $d0f37027, $ddb056fe, $d9714b49,
 $c7361b4c, $c3f706fb, $ceb42022, $ca753d95,
 $f23a8028, $f6fb9d9f, $fbb8bb46, $ff79a6f1,
 $e13ef6f4, $e5ffeb43, $e8bccd9a, $ec7dd02d,
 $34867077, $30476dc0, $3d044b19, $39c556ae,
 $278206ab, $23431b1c, $2e003dc5, $2ac12072,
 $128e9dcf, $164f8078, $1b0ca6a1, $1fcdbb16,
 $018aeb13, $054bf6a4, $0808d07d, $0cc9cdca,
 $7897ab07, $7c56b6b0, $71159069, $75d48dde,
 $6b93dddb, $6f52c06c, $6211e6b5, $66d0fb02,
 $5e9f46bf, $5a5e5b08, $571d7dd1, $53dc6066,
 $4d9b3063, $495a2dd4, $44190b0d, $40d816ba,
 $aca5c697, $a864db20, $a527fdf9, $a1e6e04e,
 $bfa1b04b, $bb60adfc, $b6238b25, $b2e29692,
 $8aad2b2f, $8e6c3698, $832f1041, $87ee0df6,
 $99a95df3, $9d684044, $902b669d, $94ea7b2a,
 $e0b41de7, $e4750050, $e9362689, $edf73b3e,
 $f3b06b3b, $f771768c, $fa325055, $fef34de2,
 $c6bcf05f, $c27dede8, $cf3ecb31, $cbffd686,
 $d5b88683, $d1799b34, $dc3abded, $d8fba05a,
 $690ce0ee, $6dcdfd59, $608edb80, $644fc637,
 $7a089632, $7ec98b85, $738aad5c, $774bb0eb,
 $4f040d56, $4bc510e1, $46863638, $42472b8f,
 $5c007b8a, $58c1663d, $558240e4, $51435d53,
 $251d3b9e, $21dc2629, $2c9f00f0, $285e1d47,
 $36194d42, $32d850f5, $3f9b762c, $3b5a6b9b,
 $0315d626, $07d4cb91, $0a97ed48, $0e56f0ff,
 $1011a0fa, $14d0bd4d, $19939b94, $1d528623,
 $f12f560e, $f5ee4bb9, $f8ad6d60, $fc6c70d7,
 $e22b20d2, $e6ea3d65, $eba91bbc, $ef68060b,
 $d727bbb6, $d3e6a601, $dea580d8, $da649d6f,
 $c423cd6a, $c0e2d0dd, $cda1f604, $c960ebb3,
 $bd3e8d7e, $b9ff90c9, $b4bcb610, $b07daba7,
 $ae3afba2, $aafbe615, $a7b8c0cc, $a379dd7b,
 $9b3660c6, $9ff77d71, $92b45ba8, $9675461f,
 $8832161a, $8cf30bad, $81b02d74, $857130c3,
 $5d8a9099, $594b8d2e, $5408abf7, $50c9b640,
 $4e8ee645, $4a4ffbf2, $470cdd2b, $43cdc09c,
 $7b827d21, $7f436096, $7200464f, $76c15bf8,
 $68860bfd, $6c47164a, $61043093, $65c52d24,
 $119b4be9, $155a565e, $18197087, $1cd86d30,
 $029f3d35, $065e2082, $0b1d065b, $0fdc1bec,
 $3793a651, $3352bbe6, $3e119d3f, $3ad08088,
 $2497d08d, $2056cd3a, $2d15ebe3, $29d4f654,
 $c5a92679, $c1683bce, $cc2b1d17, $c8ea00a0,
 $d6ad50a5, $d26c4d12, $df2f6bcb, $dbee767c,
 $e3a1cbc1, $e760d676, $ea23f0af, $eee2ed18,
 $f0a5bd1d, $f464a0aa, $f9278673, $fde69bc4,
 $89b8fd09, $8d79e0be, $803ac667, $84fbdbd0,
 $9abc8bd5, $9e7d9662, $933eb0bb, $97ffad0c,
 $afb010b1, $ab710d06, $a6322bdf, $a2f33668,
 $bcb4666d, $b8757bda, $b5365d03, $b1f740b4);
var len:Dword;
    ptr:Pbyte;
begin
 Result:=initvalue; len:=buflen; ptr:=buf;
 while(len>0)do
  begin
   Result:=(Result shl 8) xor (crc32_table[1+((Result shr 24) xor (ptr^)) and $FF]);
   inc(ptr); dec(len);
  end;
end;
function conv_generate_timestamp:dword;
const monthdata1:array[1..12] of byte=(31,28,31,30,31,30,31,31,30,31,30,31);
      monthdata2:array[1..12] of byte=(31,29,31,30,31,30,31,31,30,31,30,31);
var tempres:TSystemTime;
    i,j:word;
    bool:boolean;
    res:dword;
begin
 DateTimeToSystemTime(Now,tempres);
 i:=1970; Result:=0;
 while(i<=tempres.Year)do
  begin
   if(i<tempres.Year) then
    begin
     if(tempres.Year mod 4=0) then
      begin
       if(tempres.Year mod 100=0) and (tempres.Year mod 400=0) then
       inc(Result,366*24*60*60)
       else if(tempres.Year mod 100<>0) then
       inc(Result,366*24*60*60)
       else
       inc(Result,365*24*60*60)
      end
     else inc(Result,365*24*60*60);
    end
   else
    begin
     j:=1; bool:=false;
     if(tempres.Year mod 4=0) then
      begin
       if(tempres.Year mod 100=0) and (tempres.Year mod 400=0) then bool:=true
       else if(tempres.Year mod 100<>0) then bool:=true
       else bool:=false;
      end
     else bool:=false;
     if(bool=true) then
      begin
       while(j<=tempres.Month)do
        begin
         if(j<tempres.Month) then
          begin
           inc(Result,monthdata1[j]*24*60*60);
          end
         else
          begin
           inc(Result,(tempres.Day-1)*24*60*60+(tempres.Hour-1)*60*60+(tempres.Minute-1)*60+tempres.Second-1);
          end;
         inc(j);
        end;
      end
     else
      begin
       while(j<=tempres.Month)do
        begin
         if(j<tempres.Month) then
          begin
           inc(Result,monthdata2[j]*24*60*60);
          end
         else
          begin
           inc(Result,(tempres.Day-1)*24*60*60+(tempres.Hour-1)*60*60+(tempres.Minute-1)*60+tempres.Second-1);
          end;
         inc(j);
        end;
      end;
    end;
   inc(i);
  end;
end;
function conv_efi_to_buffer(efi:pe_file):PByte;
var buf:Pbyte=nil;
    i,size,writepos:SizeUint;
begin
 if(efi.bit=32) then buf:=conv_allocmem(efi.imageheader.OptionalHeader.SizeOfImage)
 else if(efi.bit=64) then buf:=conv_allocmem(efi.imageheader.OptionalHeader64.SizeOfImage);
 writepos:=0;
 conv_move(efi.dosheader,buf^,sizeof(pe_image_dos_header));
 writepos:=sizeof(pe_image_dos_header);
 i:=1;
 while(i<=efi.dosstubsize)do
  begin
   Pbyte(buf+writepos+i-1)^:=PByte(efi.dosstub+i-1)^;
   inc(i);
  end;
 inc(writepos,efi.dosstubsize);
 conv_move(efi.Imageheader.Signature,(buf+writepos)^,sizeof(dword));
 inc(writepos,sizeof(dword));
 conv_move(efi.imageheader.FileHeader,(buf+writepos)^,sizeof(pe_image_file_header));
 inc(writepos,sizeof(pe_image_file_header));
 if(efi.bit=32) then
 conv_move(efi.imageheader.OptionalHeader,(buf+writepos)^,sizeof(pe_image_nt_header32))
 else if(efi.bit=64) then
 conv_move(efi.imageheader.OptionalHeader64,(buf+writepos)^,sizeof(pe_image_nt_header64));
 writepos:=efi.secheaderaddress;
 conv_move(efi.secheader^,(buf+writepos)^,sizeof(pe_image_section_header)*
 efi.Imageheader.FileHeader.NumberOfSections);
 writepos:=efi.seccontentaddress;
 i:=1;
 while(i<=efi.Imageheader.FileHeader.NumberOfSections)do
  begin
   size:=Ppe_image_section_header(efi.secheader+i-1)^.SizeOfRawData;
   writepos:=Ppe_image_section_header(efi.secheader+i-1)^.PointerToRawData;
   conv_move(Ppe_content(efi.seccontent+i-1)^.ptr1^,(buf+writepos)^,size);
   inc(i);
  end;
 Result:=buf;
end;
function conv_elf_to_efi(elf:elf_file;apptype:byte):pe_file;
var entrystart,highaddress,addralign:SizeUint;
    elftextaddress,elfrodataaddress,elfdataaddress:SizeUint;
    perodataaddress,pedataaddress,perelocaddress:SizeUint;
    rela:elf_rela_list;
    havetext,haverodata,havedata:boolean;
    textlist,rodatalist,datalist:file_section_list;
    i,j,k:SizeUint;
    breloclist:pe_base_relocation_list;
    relocsize:SizeUint;
    efiseccount:byte;
    tempaddress1,tempaddress2:SizeUint;
    tempsize:SizeUint;
    newoffset,newaddend,baseoffset,typeoffsetcount:SizeUint;
    writeoffset,writeptr:SizeUint;
    efibuf:PByte;
begin
 elftextaddress:=0; elfrodataaddress:=0; elfdataaddress:=0;
 havetext:=false; haverodata:=false; havedata:=false;
 textlist.seccount:=0; rodatalist.seccount:=0; datalist.seccount:=0;
 textlist.secindex:=nil; rodatalist.secindex:=nil; datalist.secindex:=nil;
 baseoffset:=0;
 {Initialize the PE header}
 for i:=1 to sizeof(pe_file) do PByte(Pointer(@Result)+i-1)^:=0;
 Result.dosheader.magic_number:=$5A4D;
 Result.dosheader.file_address_of_new_exe_header:=sizeof(pe_image_dos_header)+$40;
 Result.dosstub:=conv_allocmem($40);
 pe_move_dos_code_to_dos_stub(pe_dos_code,Result.dosstub^);
 Result.dosstubsize:=$40;
 Result.imageheader.Signature:=$00004550;
 entrystart:=0; highaddress:=0;
 addralign:=0; haverodata:=false;
 {Collect any elf file info used after parsing}
 Result.bit:=elf.bit;
 if(elf.bit=32) then
  begin
   rela.list32.count:=0; rela.list32.item:=nil;
   entrystart:=elf.header.head32.elf32_entry;
   i:=2;
   while(i<=elf.header.head32.elf32_section_header_number)do
    begin
     if(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_flags=
     elf_section_header_flag_exec_instr or elf_section_header_flag_alloc) and (havetext=false) then
      begin
       elftextaddress:=Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_address;
       havetext:=true;
      end
     else if(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_flags=
     elf_section_header_flag_alloc) and (havetext) and (haverodata=false) then
      begin
       elfrodataaddress:=Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_address;
       haverodata:=true;
      end
     else if(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_flags=
     elf_section_header_flag_alloc or elf_section_header_flag_write)
     and (havetext) and (havedata=false) then
      begin
       elfdataaddress:=Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_address;
       havedata:=true;
      end;
     if(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_flags=
     elf_section_header_flag_exec_instr or elf_section_header_flag_alloc) and (havetext)
     and (haverodata=false) and (havedata=false) then
      begin
       inc(textlist.seccount);
       conv_reallocmem(textlist.secindex,textlist.seccount*2);
       (textlist.secindex+textlist.seccount-1)^:=i;
      end
     else if(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_flags=
     elf_section_header_flag_alloc) and (havetext) and (haverodata) then
      begin
       inc(rodatalist.seccount);
       conv_reallocmem(rodatalist.secindex,rodatalist.seccount*2);
       (rodatalist.secindex+rodatalist.seccount-1)^:=i;
      end
     else if(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_flags=
     elf_section_header_flag_write or elf_section_header_flag_alloc) and (havetext)
     and (havedata) then
      begin
       inc(datalist.seccount);
       conv_reallocmem(datalist.secindex,datalist.seccount*2);
       (datalist.secindex+datalist.seccount-1)^:=i;
      end;
     if(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_address
     +Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_size>highaddress)
     and(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_flags and
     elf_section_header_flag_alloc=elf_section_header_flag_alloc) and (havetext) then
     highaddress:=Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_address
     +Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_size;
     if(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_type=elf_section_header_rela) then
      begin
       inc(rela.list32.count); conv_reallocmem(rela.list32.item,rela.list32.count*sizeof(elf32_rela_item));
       Pelf32_rela_item(rela.list32.item+rela.list32.count-1)^.rela:=
       conv_allocmem(Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_size);
       Pelf32_rela_item(rela.list32.item+rela.list32.count-1)^.count:=
       Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_size div
       Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_entry_size;
       conv_move(Pelf_content(elf.seccontent+i-1)^.ptr1^,
       Pelf32_rela_item(rela.list32.item+rela.list32.count-1)^.rela^,
       Pelf_section_header(elf.secheader+i-1)^.sec32.section_header_size);
      end;
     inc(i);
    end;
   i:=1;
   while(i<=elf.header.head32.elf32_program_header_number)do
    begin
     if(Pelf_program_header(elf.proheader+i-1)^.pro32.program_align>addralign) then
     addralign:=Pelf_program_header(elf.proheader+i-1)^.pro32.program_align;
     inc(i);
    end;
   if(addralign>$1000) then addralign:=$1000;
   Result.imageheader.FileHeader.NumberOfSections:=Byte(havetext)+Byte(haverodata)+Byte(havedata)+1;
   efiseccount:=Result.imageheader.FileHeader.NumberOfSections;
   Result.imageheader.FileHeader.NumberOfSymbols:=0;
   Result.imageheader.FileHeader.PointerToSymbolTable:=0;
   Result.imageheader.FileHeader.SizeOfOptionalHeader:=sizeof(pe_image_nt_header32);
   Result.imageheader.FileHeader.Characteristics:=
   pe_image_file_executable_image or pe_image_file_line_nums_stripped
   or pe_image_file_local_syms_stripped or pe_image_file_debug_stripped;
   Result.imageheader.FileHeader.TimeDateStamp:=conv_generate_timestamp;
   if(elf.header.head32.elf32_machine=elf_machine_386) then
    begin
     Result.imageheader.FileHeader.Machine:=pe_image_file_machine_i386;
    end
   else if(elf.header.head32.elf32_machine=elf_machine_arm) then
    begin
     Result.imageheader.FileHeader.Machine:=pe_image_file_machine_arm;
    end
   else if(elf.header.head32.elf32_machine=elf_machine_riscv) then
    begin
     Result.imageheader.FileHeader.Machine:=pe_image_file_machine_riscv32;
    end
   else if(elf.header.head32.elf32_machine=elf_machine_loongarch) then
    begin
     Result.imageheader.FileHeader.Machine:=pe_image_file_machine_loongarch32;
    end;
   Result.secheaderaddress:=sizeof(pe_image_dos_header)+Result.dosstubsize+sizeof(dword)+
   sizeof(pe_image_file_header)+sizeof(pe_image_nt_header32);
   Result.secheader:=conv_allocmem(sizeof(pe_image_section_header)*
   Result.imageheader.FileHeader.NumberOfSections);
   Result.seccontentaddress:=(Result.secheaderaddress+
   sizeof(pe_image_section_header)*Result.imageheader.FileHeader.NumberOfSections+
   addralign-1) div addralign*addralign;
   Result.seccontent:=conv_allocmem(sizeof(pe_content)*efiseccount);
   {Generate the PE section position}
   if(elfrodataaddress<>0) then
    begin
     perodataaddress:=Result.seccontentaddress+elfrodataaddress-elftextaddress;
     pedataaddress:=perodataaddress+elfdataaddress-elfrodataaddress;
     perelocaddress:=pedataaddress+highaddress-elfdataaddress;
    end
   else
    begin
     perodataaddress:=0;
     pedataaddress:=Result.seccontentaddress+elfdataaddress-elftextaddress;
     perelocaddress:=pedataaddress+highaddress-elfdataaddress;
    end;
   {Generate the Optional Header}
   Result.imageheader.OptionalHeader.AddressOfEntryPoint:=
   entrystart-elftextaddress+Result.seccontentaddress;
   Result.imageheader.OptionalHeader.Magic:=pe_image_pe32_image_magic;
   Result.imageheader.OptionalHeader.MajorLinkerVersion:=1;
   Result.imageheader.OptionalHeader.MinorLinkerVersion:=0;
   Result.imageheader.OptionalHeader.MajorImageVersion:=1;
   Result.imageheader.OptionalHeader.MinorImageVersion:=0;
   Result.imageheader.OptionalHeader.MajorOperatingSystemVersion:=1;
   Result.imageheader.OptionalHeader.MinorOperatingSystemVersion:=0;
   Result.imageheader.OptionalHeader.MajorSubsystemVersion:=1;
   Result.imageheader.OptionalHeader.MinorSubsystemVersion:=0;
   Result.imageheader.OptionalHeader.Checksum:=0;
   Result.imageheader.OptionalHeader.ImageBase:=0;
   Result.imageheader.OptionalHeader.BaseOfCode:=Result.seccontentaddress;
   if(elfrodataaddress<>0) then
   Result.imageheader.OptionalHeader.BaseOfData:=elfrodataaddress-elftextaddress+Result.seccontentaddress
   else
   Result.imageheader.OptionalHeader.BaseOfData:=elfdataaddress-elftextaddress+Result.seccontentaddress;
   Result.ImageHeader.OptionalHeader.SectionAlignment:=addralign;
   Result.imageheader.OptionalHeader.Subsystem:=apptype;
   Result.imageheader.OptionalHeader.Win32VersionValue:=0;
   Result.imageheader.OptionalHeader.SizeOfImage:=0;
   Result.imageheader.OptionalHeader.SizeOfHeaders:=
   (sizeof(pe_image_dos_header)+Result.dosstubsize+sizeof(dword)+
   sizeof(pe_image_file_header)+sizeof(pe_image_nt_header32)+
   sizeof(pe_image_section_header)*
   Result.imageheader.FileHeader.NumberOfSections+addralign-1) div addralign*addralign;
   Result.imageheader.OptionalHeader.DllCharacteristics:=0;
   Result.imageheader.OptionalHeader.NumberOfRvaandSizes:=16;
   if(elfrodataaddress<>0) then
    begin
     Result.imageheader.OptionalHeader.SizeOfCode:=elfrodataaddress-elftextaddress;
     Result.imageheader.OptionalHeader.SizeOfUninitializedData:=0;
     Result.imageheader.OptionalHeader.SizeOfInitializedData:=highaddress-elfrodataaddress;
    end
   else
    begin
     Result.imageheader.OptionalHeader.SizeOfCode:=elfdataaddress-elftextaddress;
     Result.imageheader.OptionalHeader.SizeOfUninitializedData:=0;
     Result.imageheader.OptionalHeader.SizeOfInitializedData:=highaddress-elfdataaddress;
    end;
   Result.imageheader.OptionalHeader.LoaderFlags:=0;
   Result.imageheader.OptionalHeader.SizeOfStackCommit:=0;
   Result.imageheader.OptionalHeader.SizeOfStackReserve:=0;
   Result.imageheader.OptionalHeader.SizeOfHeapCommit:=0;
   Result.imageheader.OptionalHeader.SizeOfHeapReserve:=0;
   {Generate the Section Content}
   if(haverodata) then
    begin
     i:=1;
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(elfrodataaddress-elftextaddress);
     for j:=1 to textlist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(textlist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(textlist.secindex+j-1)^
       -1)^.sec32.section_header_address-elftextaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(textlist.secindex+j-1)^
       -1)^.sec32.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
     inc(i);
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(elfdataaddress-elfrodataaddress);
     for j:=1 to rodatalist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(rodatalist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(rodatalist.secindex+j-1)^
       -1)^.sec32.section_header_address-elfrodataaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(rodatalist.secindex+j-1)^
       -1)^.sec32.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
     inc(i);
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(highaddress-elfdataaddress);
     for j:=1 to datalist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(datalist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(datalist.secindex+j-1)^
       -1)^.sec32.section_header_address-elfdataaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(datalist.secindex+j-1)^
       -1)^.sec32.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
    end
   else
    begin
     i:=1;
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(elfdataaddress-elftextaddress);
     for j:=1 to textlist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(textlist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(textlist.secindex+j-1)^
       -1)^.sec32.section_header_address-elftextaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(textlist.secindex+j-1)^
       -1)^.sec32.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
     inc(i);
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(highaddress-elfdataaddress);
     for j:=1 to datalist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(datalist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(datalist.secindex+j-1)^
       -1)^.sec32.section_header_address-elfdataaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(datalist.secindex+j-1)^
       -1)^.sec32.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
    end;
   {Generate the Base Relocation Table}
   breloclist.count:=0; breloclist.item:=nil; relocsize:=0; i:=1;
   while(i<=rela.list32.count)do
    begin
     j:=1; typeoffsetcount:=Pelf32_rela_item(rela.list32.item+i-1)^.count;
     while(j<=typeoffsetcount)do
      begin
       newoffset:=Pelf32_rela(Pelf32_rela_item(rela.list32.item+i-1)^.rela+j-1)^.rela_offset
       -elftextaddress+Result.seccontentaddress;
       newaddend:=Pelf32_rela(Pelf32_rela_item(rela.list32.item+i-1)^.rela+j-1)^.rela_addend
       -elftextaddress+Result.seccontentaddress;
       {Search for the address it is exist}
       if(elfrodataaddress=0) then
        begin
         if(Pelf32_rela(Pelf32_rela_item(rela.list32.item+i-1)^.rela+j-1)^.rela_offset<=elfdataaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress;
           Pqword(Ppe_content(Result.seccontent)^.ptr1+writeoffset)^:=newaddend;
          end
         else if(Pelf32_rela(Pelf32_rela_item(rela.list32.item+i-1)^.rela+j-1)^.rela_offset<=highaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress-(elfdataaddress-elftextaddress);
           Pqword(Ppe_content(Result.seccontent+1)^.ptr1+writeoffset)^:=newaddend;
          end;
        end
       else
        begin
         if(Pelf32_rela(Pelf32_rela_item(rela.list32.item+i-1)^.rela+j-1)^.rela_offset<=elfrodataaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress;
           Pqword(Ppe_content(Result.seccontent)^.ptr1+writeoffset)^:=newaddend;
          end
         else if(Pelf32_rela(Pelf32_rela_item(rela.list32.item+i-1)^.rela+j-1)^.rela_offset<=elfdataaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress-(elfrodataaddress-elftextaddress);
           Pqword(Ppe_content(Result.seccontent+1)^.ptr1+writeoffset)^:=newaddend;
          end
         else if(Pelf32_rela(Pelf32_rela_item(rela.list32.item+i-1)^.rela+j-1)^.rela_offset<=highaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress-(elfdataaddress-elftextaddress);
           Pqword(Ppe_content(Result.seccontent+1)^.ptr1+writeoffset)^:=newaddend;
          end;
        end;
       if(j=1) or (newoffset-baseoffset>4095) then
        begin
         inc(breloclist.count); inc(relocsize,8);
         conv_reallocmem(breloclist.item,sizeof(pe_base_relocation_item)*breloclist.count);
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.VirtualAddress:=newoffset;
         baseoffset:=newoffset;
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.SizeOfBlock:=8;
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count:=0;
        end;
       inc(relocsize,2);
       inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.SizeOfBlock,2);
       inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
       conv_reallocmem(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc,j*2);
       Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
       Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
       pe_image_rel_base_highlow;
       Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
       Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=
       newoffset-baseoffset;
       inc(j);
      end;
     if(typeoffsetcount<2) or (typeoffsetcount-typeoffsetcount shr 1 shl 1<>0) then
      begin
       if(typeoffsetcount<2) then
       k:=2-typeoffsetcount
       else
       k:=2-(typeoffsetcount-typeoffsetcount shr 1 shl 1);
       while(k>0)do
        begin
         inc(relocsize,2);
         inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.SizeOfBlock,2);
         inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
         conv_reallocmem(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc,j*2);
         Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
         pe_image_rel_base_absolute;
         Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=0;
         dec(k); inc(j);
        end;
      end;
     inc(i);
    end;
   if(rela.list32.count=0) then
    begin
     inc(breloclist.count);
     conv_reallocmem(breloclist.item,sizeof(pe_base_relocation_item)*breloclist.count);
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.VirtualAddress:=
     Result.seccontentaddress;
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.SizeOfBlock:=12;
     conv_reallocmem(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc,4);
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count:=0;
     inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
     pe_image_rel_base_absolute;
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=0;
     inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
     pe_image_rel_base_absolute;
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=0;
     relocsize:=12;
    end;
   {Free the Rela Section Content}
   i:=1;
   while(i<=rela.list32.count)do
    begin
     conv_freemem(Pelf32_rela_item(rela.list32.item+i-1)^.rela);
     inc(i);
    end;
   if(rela.list32.item<>nil) then conv_freemem(rela.list32.item);
   {Generate the Base Relocation Table in Memory}
   Ppe_content(Result.seccontent+efiseccount-1)^.ptr1:=conv_allocmem(relocsize); writeptr:=0;
   i:=1;
   while(i<=breloclist.count)do
    begin
     Ppe_image_base_relocation(Pointer(Ppe_content(Result.seccontent+efiseccount-1)^.ptr1)+writeptr)^:=
     Ppe_base_relocation_item(breloclist.item+i-1)^.base;
     inc(writeptr,8);
     j:=1;
     while(j<=Ppe_base_relocation_item(breloclist.item+i-1)^.count)do
      begin
       Ppe_image_type_offset(Pointer(Ppe_content(Result.seccontent+efiseccount-1)^.ptr1)+writeptr)^:=
       (Ppe_base_relocation_item(breloclist.item+i-1)^.reloc+j-1)^;
       inc(writeptr,2);
       inc(j);
      end;
     conv_freemem(Ppe_base_relocation_item(breloclist.item+i-1)^.reloc);
     Ppe_base_relocation_item(breloclist.item+i-1)^.count:=0;
     inc(i);
    end;
   if(breloclist.item<>nil) then conv_freemem(breloclist.item);
   {Generate the section header}
   i:=1;
   if(havetext=true) then
    begin
     Ppe_image_section_header(Result.secheader+i-1)^.Name:='.text';
     if(haverodata) then
     Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=elfrodataaddress-elftextaddress
     else Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=elfdataaddress-elftextaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.NumberOfLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToLineNumbers:=0;
     if(haverodata) then
     Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=
     perodataaddress-Result.seccontentaddress
     else Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=
     pedataaddress-Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRawData:=Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRelocation:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.VirtualAddress:=Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.Characteristics:=
     pe_image_scn_cnt_code or pe_image_mem_read or pe_image_mem_execute;
    end;
   if(haverodata=true) then
    begin
     inc(i);
     Ppe_image_section_header(Result.secheader+i-1)^.Name:='.rdata';
     Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=elfdataaddress-elfrodataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.NumberOfLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=
     perodataaddress-Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRawData:=perodataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRelocation:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.VirtualAddress:=elfrodataaddress-elftextaddress+
     Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.Characteristics:=
     pe_image_scn_cnt_initialized_data or pe_image_mem_read;
    end;
   if(havedata=true) then
    begin
     inc(i);
     Ppe_image_section_header(Result.secheader+i-1)^.Name:='.data';
     Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=highaddress-elfdataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.NumberOfLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=perelocaddress-pedataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRawData:=pedataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRelocation:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.VirtualAddress:=elfdataaddress-elftextaddress+
     Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.Characteristics:=
     pe_image_scn_cnt_initialized_data or pe_image_mem_read or pe_image_mem_write;
    end;
   inc(i);
   Ppe_image_section_header(Result.secheader+i-1)^.Name:='.reloc';
   Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=relocsize;
   Ppe_image_section_header(Result.secheader+i-1)^.NumberOfLineNumbers:=0;
   Ppe_image_section_header(Result.secheader+i-1)^.PointerToLineNumbers:=0;
   Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=relocsize;
   Ppe_image_section_header(Result.secheader+i-1)^.PointerToRawData:=perelocaddress;
   Ppe_image_section_header(Result.secheader+i-1)^.PointerToRelocation:=0;
   Ppe_image_section_header(Result.secheader+i-1)^.VirtualAddress:=highaddress
   -elftextaddress+Result.seccontentaddress;
   Result.imageheader.OptionalHeader.DataDirectory[6].virtualaddress:=highaddress
   -elftextaddress+Result.seccontentaddress;
   Result.ImageHeader.OptionalHeader.DataDirectory[6].Size:=relocsize;
   Result.imageheader.OptionalHeader.FileAlignment:=addralign;
   Result.imageheader.OptionalHeader.SizeOfImage:=(perelocaddress+relocsize+addralign-1)
   div addralign*addralign;
   Result.ImageHeader.OptionalHeader.Checksum:=0;
   efibuf:=conv_efi_to_buffer(Result);
   Result.ImageHeader.OptionalHeader.Checksum:=
   conv_generate_crc32(efibuf,Result.ImageHeader.OptionalHeader.SizeOfImage,$FFFFFFFF);
   conv_freemem(efibuf);
  end
 else if(elf.bit=64) then
  begin
   i:=1;
   rela.list64.count:=0; rela.list64.item:=nil;
   entrystart:=elf.header.head64.elf64_entry;
   i:=1;
   while(i<=elf.header.head64.elf64_section_header_number)do
    begin
     if(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_flags=
     elf_section_header_flag_exec_instr or elf_section_header_flag_alloc) and (havetext=false) then
      begin
       elftextaddress:=Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_address;
       havetext:=true;
      end
     else if(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_flags=
     elf_section_header_flag_alloc) and (havetext) and (haverodata=false) then
      begin
       elfrodataaddress:=Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_address;
       haverodata:=true;
      end
     else if(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_flags=
     elf_section_header_flag_alloc or elf_section_header_flag_write)
     and (havetext) and (havedata=false) then
      begin
       elfdataaddress:=Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_address;
       havedata:=true;
      end;
     if(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_flags=
     elf_section_header_flag_exec_instr or elf_section_header_flag_alloc) and (havetext)
     and (haverodata=false) and (havedata=false) then
      begin
       inc(textlist.seccount);
       conv_reallocmem(textlist.secindex,textlist.seccount*2);
       (textlist.secindex+textlist.seccount-1)^:=i;
      end
     else if(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_flags=
     elf_section_header_flag_alloc) and (havetext) and (haverodata) then
      begin
       inc(rodatalist.seccount);
       conv_reallocmem(rodatalist.secindex,rodatalist.seccount*2);
       (rodatalist.secindex+rodatalist.seccount-1)^:=i;
      end
     else if(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_flags=
     elf_section_header_flag_write or elf_section_header_flag_alloc) and (havetext)
     and (havedata) then
      begin
       inc(datalist.seccount);
       conv_reallocmem(datalist.secindex,datalist.seccount*2);
       (datalist.secindex+datalist.seccount-1)^:=i;
      end;
     if(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_address
     +Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_size>highaddress)
     and(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_flags and
     elf_section_header_flag_alloc=elf_section_header_flag_alloc) and (havetext) then
     highaddress:=Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_address
     +Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_size;
     if(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_type=elf_section_header_rela) then
      begin
       inc(rela.list64.count); conv_reallocmem(rela.list64.item,rela.list64.count*sizeof(elf64_rela_item));
       Pelf64_rela_item(rela.list64.item+rela.list64.count-1)^.rela:=
       conv_allocmem(Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_size);
       Pelf64_rela_item(rela.list64.item+rela.list64.count-1)^.count:=
       Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_size div
       Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_entry_size;
       conv_move(Pelf_content(elf.seccontent+i-1)^.ptr1^,
       Pelf64_rela_item(rela.list64.item+rela.list64.count-1)^.rela^,
       Pelf_section_header(elf.secheader+i-1)^.sec64.section_header_size);
      end;
     inc(i);
    end;
   i:=1;
   while(i<=elf.header.head64.elf64_program_header_number)do
    begin
     if(Pelf_program_header(elf.proheader+i-1)^.pro64.program_align>addralign)then
     addralign:=Pelf_program_header(elf.proheader+i-1)^.pro64.program_align;
     inc(i);
    end;
   if(addralign>$1000) then addralign:=$1000;
   Result.imageheader.FileHeader.NumberOfSections:=Byte(havetext)+Byte(haverodata)+Byte(havedata)+1;
   efiseccount:=Result.imageheader.FileHeader.NumberOfSections;
   Result.imageheader.FileHeader.NumberOfSymbols:=0;
   Result.imageheader.FileHeader.PointerToSymbolTable:=0;
   Result.imageheader.FileHeader.SizeOfOptionalHeader:=sizeof(pe_image_nt_header64);
   Result.imageheader.FileHeader.Characteristics:=
   pe_image_file_executable_image or pe_image_file_line_nums_stripped
   or pe_image_file_local_syms_stripped or pe_image_file_debug_stripped
   or pe_image_file_large_address_aware;
   Result.imageheader.FileHeader.TimeDateStamp:=conv_generate_timestamp;
   if(elf.header.head64.elf64_machine=elf_machine_x86_64) then
    begin
     Result.imageheader.FileHeader.Machine:=pe_image_file_machine_amd64;
    end
   else if(elf.header.head64.elf64_machine=elf_machine_aarch64) then
    begin
     Result.imageheader.FileHeader.Machine:=pe_image_file_machine_arm64;
    end
   else if(elf.header.head64.elf64_machine=elf_machine_riscv) then
    begin
     Result.imageheader.FileHeader.Machine:=pe_image_file_machine_riscv64;
    end
   else if(elf.header.head64.elf64_machine=elf_machine_loongarch) then
    begin
     Result.imageheader.FileHeader.Machine:=pe_image_file_machine_loongarch64;
    end;
   Result.secheaderaddress:=sizeof(pe_image_dos_header)+Result.dosstubsize+sizeof(dword)+
   sizeof(pe_image_file_header)+sizeof(pe_image_nt_header64);
   Result.secheader:=conv_allocmem(sizeof(pe_image_section_header)*
   Result.imageheader.FileHeader.NumberOfSections);
   Result.seccontentaddress:=(Result.secheaderaddress+
   sizeof(pe_image_section_header)*Result.imageheader.FileHeader.NumberOfSections+
   addralign-1) div addralign*addralign;
   Result.seccontent:=conv_allocmem(sizeof(pe_content)*efiseccount);
   {Generate the PE section position}
   if(elfrodataaddress<>0) then
    begin
     perodataaddress:=Result.seccontentaddress+elfrodataaddress-elftextaddress;
     pedataaddress:=perodataaddress+elfdataaddress-elfrodataaddress;
     perelocaddress:=pedataaddress+highaddress-elfdataaddress;
    end
   else
    begin
     perodataaddress:=0;
     pedataaddress:=Result.seccontentaddress+elfdataaddress-elftextaddress;
     perelocaddress:=pedataaddress+highaddress-elfdataaddress;
    end;
   {Generate the Optional Header}
   Result.imageheader.OptionalHeader64.AddressOfEntryPoint:=
   entrystart-elftextaddress+Result.seccontentaddress;
   Result.imageheader.OptionalHeader64.Magic:=pe_image_pe32plus_image_magic;
   Result.imageheader.OptionalHeader64.MajorLinkerVersion:=1;
   Result.imageheader.OptionalHeader64.MinorLinkerVersion:=0;
   Result.imageheader.OptionalHeader64.MajorImageVersion:=1;
   Result.imageheader.OptionalHeader64.MinorImageVersion:=0;
   Result.imageheader.OptionalHeader64.MajorOperatingSystemVersion:=1;
   Result.imageheader.OptionalHeader64.MinorOperatingSystemVersion:=0;
   Result.imageheader.OptionalHeader64.MajorSubsystemVersion:=1;
   Result.imageheader.OptionalHeader64.MinorSubsystemVersion:=0;
   Result.imageheader.OptionalHeader64.Checksum:=0;
   Result.imageheader.OptionalHeader64.ImageBase:=0;
   Result.imageheader.OptionalHeader64.BaseOfCode:=Result.seccontentaddress;
   Result.ImageHeader.OptionalHeader64.SectionAlignment:=addralign;
   Result.imageheader.OptionalHeader64.Subsystem:=apptype;
   Result.imageheader.OptionalHeader64.Win32VersionValue:=0;
   Result.imageheader.OptionalHeader64.SizeOfImage:=0;
   Result.imageheader.OptionalHeader64.SizeOfHeaders:=
   (sizeof(pe_image_dos_header)+Result.dosstubsize+sizeof(dword)+
   sizeof(pe_image_file_header)+sizeof(pe_image_nt_header64)+
   sizeof(pe_image_section_header)*
   Result.imageheader.FileHeader.NumberOfSections+addralign-1) div addralign*addralign;
   Result.imageheader.OptionalHeader64.DllCharacteristics:=0;
   Result.imageheader.OptionalHeader64.NumberOfRvaandSizes:=16;
   if(elfrodataaddress<>0) then
    begin
     Result.imageheader.OptionalHeader64.SizeOfCode:=elfrodataaddress-elftextaddress;
     Result.imageheader.OptionalHeader64.SizeOfUninitializedData:=0;
     Result.imageheader.OptionalHeader64.SizeOfInitializedData:=highaddress-elfrodataaddress;
    end
   else
    begin
     Result.imageheader.OptionalHeader64.SizeOfCode:=elfdataaddress-elftextaddress;
     Result.imageheader.OptionalHeader64.SizeOfUninitializedData:=0;
     Result.imageheader.OptionalHeader64.SizeOfInitializedData:=highaddress-elfdataaddress;
    end;
   Result.imageheader.OptionalHeader64.LoaderFlags:=0;
   Result.imageheader.OptionalHeader64.SizeOfStackCommit:=0;
   Result.imageheader.OptionalHeader64.SizeOfStackReserve:=0;
   Result.imageheader.OptionalHeader64.SizeOfHeapCommit:=0;
   Result.imageheader.OptionalHeader64.SizeOfHeapReserve:=0;
   {Generate the Section Content}
   if(haverodata) then
    begin
     i:=1;
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(elfrodataaddress-elftextaddress);
     for j:=1 to textlist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(textlist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(textlist.secindex+j-1)^
       -1)^.sec64.section_header_address-elftextaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(textlist.secindex+j-1)^
       -1)^.sec64.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
     inc(i);
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(elfdataaddress-elfrodataaddress);
     for j:=1 to rodatalist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(rodatalist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(rodatalist.secindex+j-1)^
       -1)^.sec64.section_header_address-elfrodataaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(rodatalist.secindex+j-1)^
       -1)^.sec64.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
     inc(i);
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(highaddress-elfdataaddress);
     for j:=1 to datalist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(datalist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(datalist.secindex+j-1)^
       -1)^.sec64.section_header_address-elfdataaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(datalist.secindex+j-1)^
       -1)^.sec64.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
    end
   else
    begin
     i:=1;
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(elfdataaddress-elftextaddress);
     for j:=1 to textlist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(textlist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(textlist.secindex+j-1)^
       -1)^.sec64.section_header_address-elftextaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(textlist.secindex+j-1)^
       -1)^.sec64.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
     inc(i);
     Ppe_content(Result.seccontent+i-1)^.ptr1:=conv_allocmem(highaddress-elfdataaddress);
     for j:=1 to datalist.seccount do
      begin
       tempaddress1:=SizeUint(Pelf_content(elf.seccontent+(datalist.secindex+j-1)^-1)^.ptr1);
       tempaddress2:=Pelf_section_header(elf.secheader+(datalist.secindex+j-1)^
       -1)^.sec64.section_header_address-elfdataaddress+
       SizeUint(Ppe_content(Result.seccontent+i-1)^.ptr1);
       tempsize:=Pelf_section_header(elf.secheader+(datalist.secindex+j-1)^
       -1)^.sec64.section_header_size;
       conv_move(Pbyte(tempaddress1)^,Pbyte(tempaddress2)^,tempsize);
      end;
    end;
   {Generate the Base Relocation Table}
   breloclist.count:=0; breloclist.item:=nil; relocsize:=0; i:=1;
   while(i<=rela.list64.count)do
    begin
     j:=1; typeoffsetcount:=Pelf64_rela_item(rela.list64.item+i-1)^.count;
     while(j<=typeoffsetcount)do
      begin
       newoffset:=Pelf64_rela(Pelf64_rela_item(rela.list64.item+i-1)^.rela+j-1)^.rela_offset
       -elftextaddress+Result.seccontentaddress;
       newaddend:=Pelf64_rela(Pelf64_rela_item(rela.list64.item+i-1)^.rela+j-1)^.rela_addend
       -elftextaddress+Result.seccontentaddress;
       {Search for the address exists}
       if(elfrodataaddress=0) then
        begin
         if(Pelf64_rela(Pelf64_rela_item(rela.list64.item+i-1)^.rela+j-1)^.rela_offset<=elfdataaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress;
           Pqword(Ppe_content(Result.seccontent)^.ptr1+writeoffset)^:=newaddend;
          end
         else if(Pelf64_rela(Pelf64_rela_item(rela.list64.item+i-1)^.rela+j-1)^.rela_offset<=highaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress-(elfdataaddress-elftextaddress);
           Pqword(Ppe_content(Result.seccontent+1)^.ptr1+writeoffset)^:=newaddend;
          end;
        end
       else
        begin
         if(Pelf64_rela(Pelf64_rela_item(rela.list64.item+i-1)^.rela+j-1)^.rela_offset<=elfrodataaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress;
           Pqword(Ppe_content(Result.seccontent)^.ptr1+writeoffset)^:=newaddend;
          end
         else if(Pelf64_rela(Pelf64_rela_item(rela.list64.item+i-1)^.rela+j-1)^.rela_offset<=elfdataaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress-(elfrodataaddress-elftextaddress);
           Pqword(Ppe_content(Result.seccontent+1)^.ptr1+writeoffset)^:=newaddend;
          end
         else if(Pelf64_rela(Pelf64_rela_item(rela.list64.item+i-1)^.rela+j-1)^.rela_offset<=highaddress) then
          begin
           writeoffset:=newoffset-Result.seccontentaddress-(elfdataaddress-elftextaddress);
           Pqword(Ppe_content(Result.seccontent+2)^.ptr1+writeoffset)^:=newaddend;
          end;
        end;
       if(j=1) or (newoffset-baseoffset>4095) then
        begin
         inc(breloclist.count); inc(relocsize,8);
         conv_reallocmem(breloclist.item,sizeof(pe_base_relocation_item)*breloclist.count);
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.VirtualAddress:=newoffset;
         baseoffset:=newoffset;
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.SizeOfBlock:=8;
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count:=0;
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc:=nil;
        end;
       inc(relocsize,2);
       inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.SizeOfBlock,2);
       inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
       conv_reallocmem(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc,j*2);
       Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
       Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
       pe_image_rel_base_dir64;
       Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
       Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=
       newoffset-baseoffset;
       inc(j);
      end;
     if(typeoffsetcount<4) or (typeoffsetcount-typeoffsetcount shr 2 shl 2<>0) then
      begin
       if(typeoffsetcount<4) then
       k:=4-typeoffsetcount
       else
       k:=4-(typeoffsetcount-typeoffsetcount shr 2 shl 2);
       while(k>0)do
        begin
         inc(relocsize,2);
         inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.SizeOfBlock,2);
         inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
         conv_reallocmem(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc,j*2);
         Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
         pe_image_rel_base_absolute;
         Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
         Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=0;
         dec(k); inc(j);
        end;
      end;
     inc(i);
    end;
   if(rela.list64.count=0) then
    begin
     inc(breloclist.count);
     conv_reallocmem(breloclist.item,sizeof(pe_base_relocation_item)*breloclist.count);
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.VirtualAddress:=
     Result.seccontentaddress;
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.base.SizeOfBlock:=16;
     conv_reallocmem(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc,4);
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count:=0;
     inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
     pe_image_rel_base_absolute;
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=0;
     inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
     pe_image_rel_base_absolute;
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=0;
     inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
     pe_image_rel_base_absolute;
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=0;
     inc(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count);
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.peType:=
     pe_image_rel_base_absolute;
     Ppe_image_type_offset(Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.reloc+
     Ppe_base_relocation_item(breloclist.item+breloclist.count-1)^.count-1)^.Offset:=0;
     relocsize:=16;
    end;
   {Free the Rela Section Content}
   i:=1;
   while(i<=rela.list64.count)do
    begin
     conv_freemem(Pelf64_rela_item(rela.list64.item+i-1)^.rela);
     inc(i);
    end;
   if(rela.list64.item<>nil) then conv_freemem(rela.list64.item);
   {Generate the Base Relocation Table in Memory}
   Ppe_content(Result.seccontent+efiseccount-1)^.ptr1:=conv_allocmem(relocsize); writeptr:=0;
   i:=1;
   while(i<=breloclist.count)do
    begin
     Ppe_image_base_relocation(Pointer(Ppe_content(Result.seccontent+efiseccount-1)^.ptr1)+writeptr)^:=
     Ppe_base_relocation_item(breloclist.item+i-1)^.base;
     inc(writeptr,8);
     j:=1;
     while(j<=Ppe_base_relocation_item(breloclist.item+i-1)^.count)do
      begin
       Ppe_image_type_offset(Pointer(Ppe_content(Result.seccontent+efiseccount-1)^.ptr1)+writeptr)^:=
       (Ppe_base_relocation_item(breloclist.item+i-1)^.reloc+j-1)^;
       inc(writeptr,2);
       inc(j);
      end;
     conv_freemem(Ppe_base_relocation_item(breloclist.item+i-1)^.reloc);
     Ppe_base_relocation_item(breloclist.item+i-1)^.count:=0;
     inc(i);
    end;
   if(breloclist.item<>nil) then conv_freemem(breloclist.item);
   {Generate the section header}
   i:=1;
   if(havetext=true) then
    begin
     Ppe_image_section_header(Result.secheader+i-1)^.Name:='.text';
     if(haverodata) then
     Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=elfrodataaddress-elftextaddress
     else Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=elfdataaddress-elftextaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.NumberOfLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToLineNumbers:=0;
     if(haverodata) then
     Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=
     perodataaddress-Result.seccontentaddress
     else Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=
     pedataaddress-Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRawData:=Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRelocation:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.VirtualAddress:=Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.Characteristics:=
     pe_image_scn_cnt_code or pe_image_mem_read or pe_image_mem_execute;
    end;
   if(haverodata=true) then
    begin
     inc(i);
     Ppe_image_section_header(Result.secheader+i-1)^.Name:='.rdata';
     Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=elfdataaddress-elfrodataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.NumberOfLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=
     perodataaddress-Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRawData:=perodataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRelocation:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.VirtualAddress:=elfrodataaddress-elftextaddress+
     Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.Characteristics:=
     pe_image_scn_cnt_initialized_data or pe_image_mem_read;
    end;
   if(havedata=true) then
    begin
     inc(i);
     Ppe_image_section_header(Result.secheader+i-1)^.Name:='.data';
     Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=highaddress-elfdataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.NumberOfLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToLineNumbers:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=perelocaddress-pedataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRawData:=pedataaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.PointerToRelocation:=0;
     Ppe_image_section_header(Result.secheader+i-1)^.VirtualAddress:=elfdataaddress-elftextaddress+
     Result.seccontentaddress;
     Ppe_image_section_header(Result.secheader+i-1)^.Characteristics:=
     pe_image_scn_cnt_initialized_data or pe_image_mem_read or pe_image_mem_write;
    end;
   inc(i);
   Ppe_image_section_header(Result.secheader+i-1)^.Name:='.reloc';
   Ppe_image_section_header(Result.secheader+i-1)^.Misc.VirtualSize:=relocsize;
   Ppe_image_section_header(Result.secheader+i-1)^.NumberOfLineNumbers:=0;
   Ppe_image_section_header(Result.secheader+i-1)^.PointerToLineNumbers:=0;
   Ppe_image_section_header(Result.secheader+i-1)^.SizeOfRawData:=relocsize;
   Ppe_image_section_header(Result.secheader+i-1)^.PointerToRawData:=perelocaddress;
   Ppe_image_section_header(Result.secheader+i-1)^.PointerToRelocation:=0;
   Ppe_image_section_header(Result.secheader+i-1)^.VirtualAddress:=highaddress
   -elftextaddress+Result.seccontentaddress;
   Ppe_image_section_header(Result.secheader+i-1)^.Characteristics:=
   pe_image_scn_cnt_initialized_data or pe_image_mem_read or pe_image_mem_discardable;
   Result.imageheader.OptionalHeader64.DataDirectory[6].virtualaddress:=highaddress
   -elftextaddress+Result.seccontentaddress;
   Result.ImageHeader.OptionalHeader64.DataDirectory[6].Size:=relocsize;
   Result.imageheader.OptionalHeader64.FileAlignment:=addralign;
   Result.imageheader.OptionalHeader64.SizeOfImage:=
   (perelocaddress+relocsize+addralign-1) div addralign*addralign;
   Result.ImageHeader.OptionalHeader64.Checksum:=0;
   efibuf:=conv_efi_to_buffer(Result);
   Result.ImageHeader.OptionalHeader64.Checksum:=
   conv_generate_crc32(efibuf,Result.ImageHeader.OptionalHeader64.SizeOfImage,$FFFFFFFF);
   conv_freemem(efibuf);
  end;
end;
procedure conv_efi_write(efi:pe_file;fn:string);
var efibuf:Pbyte;
    i:SizeUint;
begin
 efibuf:=conv_efi_to_buffer(efi);
 if(efi.bit=32) then
  begin
   for i:=1 to efi.imageheader.OptionalHeader.SizeOfImage shr 2 do
    begin
     conv_io_write(fn,Pdword(efibuf+(i-1)*4)^,(i-1)*4,4);
    end;
  end
 else if(efi.bit=64) then
  begin
   for i:=1 to efi.imageheader.OptionalHeader64.SizeOfImage shr 2 do
    begin
     conv_io_write(fn,Pdword(efibuf+(i-1)*4)^,(i-1)*4,4);
    end;
  end;
 conv_freemem(efibuf);
end;
procedure conv_elf_free(var elf:elf_file);
var i,total:SizeUint;
begin
 if(elf.bit=32) then total:=elf.header.head32.elf32_section_header_number
 else if(elf.bit=64) then total:=elf.header.head64.elf64_section_header_number;
 i:=1;
 while(i<=total)do
  begin
   if(Pelf_content(elf.seccontent+i-1)^.ptr1<>nil) then
   conv_freemem(Pelf_content(elf.seccontent+i-1)^.ptr1);
   inc(i);
  end;
 if(elf.seccontent<>nil) then conv_freemem(elf.seccontent);
 if(elf.secheader<>nil) then conv_freemem(elf.secheader);
 if(elf.proheader<>nil) then conv_freemem(elf.proheader);
end;
procedure conv_pe_free(var pe:pe_file);
var i:SizeUint;
begin
 conv_freemem(pe.dosstub);
 i:=1;
 while(i<=pe.imageheader.FileHeader.NumberOfSections)do
  begin
   conv_freemem((pe.seccontent+i-1)^.ptr1);
   inc(i);
  end;
 conv_freemem(pe.secheader); conv_freemem(pe.seccontent);
end;

end.

