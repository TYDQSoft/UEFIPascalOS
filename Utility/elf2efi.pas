program elf2efi;
uses binarybase,sysutils,classes;
type natuint=qword;
     natint=int64;
     relocarray=array[1..2] of pe_image_type_offset;
const pecoff_max_alignment=$2000;
function optimize_integer_divide(a,b:natuint):natuint;[public,alias:'optimize_integer_divide'];
var procnum1,procnum2,degree,res:natuint;
begin
 if(a<b) then exit(0);
 if(a=b) then exit(1);
 if(b=1) or (b=0) then exit(a);
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
 if(a<b) then exit(a);
 if(a=b) then exit(0);
 if(b=1) or (b=0) then exit(0);
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
var i,j:qword;
    ptr:PByte;
    namecustom:boolean=false;
    namestr:string;
    machinenop:byte=$00;
    {For elf files input}
    inputfile:TFileStream;
    inputfilepath:string;
    is64bit:boolean;
    elfmachine:word;
    myplatform:byte=0;
    elfheader32:elf32_header;
    elfsectionheader32:^elf32_section_header;
    elfheader64:elf64_header;
    elfsectionheader64:^elf64_section_header;
    elfcodeblock:^Pointer;
    {For parsing elf file}
    elfmaxalignment:dword;
    elffoundsection:boolean=false;
    elfshname:PChar;
    elfstrtabindex:word;
    elflowaddr:dword;
    elfaddralign:word;
    {For efi files output}
    pehaverdata:boolean;
    pebaseaddr:dword;
    pecoffindex:word;
    pecalindex:word;
    pecalsize:dword;
    pecoffoffsetarray:array[1..256] of dword;
    pecoffindexarray:array[1..256] of word;
    pecoffoffsetcount:array[1..3] of dword;
    pecoffoffset:dword;
    sectionoffset:word;
    peTextOffset:dword;
    peRoDataOffset:dword;
    peDataOffset:dword;
    peRelocationOffset:dword;
    pecoffentry:dword;
    memzero:array[1..8192] of byte;
    outputfile:TFileStream;
    outputpath:string;
    dosheader:pe_image_dos_header;
    signature:dword;
    fileheader:pe_image_file_header;
    optionalheader32:pe_image_nt_header32;
    optionalheader64:pe_image_nt_header64;
    sectionheader:^pe_image_section_header;
    sectionheadercount:word;
    {For PE base relocation}
    relocationheader:pe_image_base_relocation;
    relocationitem:relocarray;
    relocationitemcount:word;
label label1,label2,label3,label4;
begin
 writeln('Usage:elf2efi <inputfile> <outputpath>');
 {Pass the parameter}
 if(ParamCount<=0) then
  begin
   goto label1;
  end
 else if(ParamCount<=1) then
  begin
   inputfilepath:=ParamStr(1); outputpath:='';
   if(inputfilepath[1]='"') or (inputfilepath[1]=#39) then
    begin
     inputfilepath:=copy(inputfilepath,2,length(inputfilepath)-2);
    end;
   goto label2;
  end
 else if(ParamCount<=2) then
  begin
   inputfilepath:=ParamStr(1); outputpath:=ParamStr(2);
   if(inputfilepath[1]='"') or (inputfilepath[1]=#39) then
    begin
     inputfilepath:=copy(inputfilepath,2,length(inputfilepath)-2);
    end;
   if(outputpath[1]='"') or (outputpath[1]=#39) then
    begin
     outputpath:=copy(outputpath,2,length(outputpath)-2);
    end;
   goto label3;
  end
 else if(ParamCount<=3) then
  begin
   inputfilepath:=ParamStr(1); outputpath:=ParamStr(3);
   if(inputfilepath[1]='"') or (inputfilepath[1]=#39) then
    begin
     inputfilepath:=copy(inputfilepath,2,length(inputfilepath)-2);
    end;
   if(outputpath[1]='"') or (outputpath[1]=#39) then
    begin
     outputpath:=copy(outputpath,2,length(outputpath)-2);
    end;
   if(ParamStr(2)='Custom') or (ParamStr(2)='-Custom') or (ParamStr(2)='custom') or (ParamStr(2)='-custom') then namecustom:=true else namecustom:=false;
   goto label3;
  end
 else if(ParamCount>3) then
  begin
   writeln('Too many parameter passed to program!');
   goto label1;
  end;
 {Read elf file}
 label1:
 writeln('Input the file path you want to convert:');
 readln(inputfilepath);
 if(inputfilepath[1]='"') or (inputfilepath[1]=#39) then
  begin
   inputfilepath:=copy(inputfilepath,2,length(inputfilepath)-2);
  end;
 if(not FileExists(inputfilepath)) then
  begin
   writeln('Error:File does not exist.');
   goto label1;
  end;
 label4:
 writeln('Do you want to input your custom file name:');
 readln(namestr);
 if(namestr='T') or (namestr='True') or (namestr='true') or (namestr='Y') or (namestr='Yes')
 or(namestr='yes') then
  begin
   namecustom:=true;
  end
 else if(namestr='F') or (namestr='False') or (namestr='false') or (namestr='N') or (namestr='No')
 or(namestr='no') then
  begin
   namecustom:=false;
  end
 else
  begin
   writeln('Error:Invaild input.');
   goto label4;
  end;
 label2:
 writeln('Input the output path you want to place the converted file:');
 readln(outputpath);
 if(outputpath[1]='"') or (outputpath[1]=#39) then
  begin
   outputpath:=copy(outputpath,2,length(outputpath)-2);
  end;
 label3:
 is64bit:=false;
 inputfile:=TFileStream.Create(inputfilepath,fmOpenRead);
 inputfile.Read(elfheader32,sizeof(elfheader32));
 if(elfheader32.elf32_identify[elf_class_pos]=2) then
  begin
   is64bit:=true;
   inputfile.Seek(0,0);
   inputfile.Read(elfheader64,sizeof(elfheader64));
  end;
 if(is64bit) then elfmachine:=elfheader64.elf64_machine else elfmachine:=elfheader32.elf32_machine;
 myplatform:=6;
 case elfmachine of
 3:myplatform:=0;
 62:myplatform:=1;
 40:myplatform:=2;
 183:myplatform:=3;
 258:myplatform:=4;
 243:myplatform:=5;
 end;
 if(myplatform=6) then
  begin
   writeln('The architecture does not supported!');
   inputfile.Free;
   goto label1;
  end;
 writeln('Detecting elf file......');
 elflowaddr:=$FFFFFFFF; elfstrtabindex:=0; pehaverdata:=false;
 if(is64bit) then
  begin
   if(elfheader64.elf64_type<>elf_type_executable) and (elfheader64.elf64_type<>elf_type_dynamic) then
    begin
     writeln('Input elf file is not be executable or shared library,cannot be converted.');
     inputfile.Free;
     goto label1;
    end;
   inputfile.Seek(elfheader64.elf64_section_header_offset,0);
   elfsectionheader64:=AllocMem(sizeof(elf64_section_header)*elfheader64.elf64_section_header_number);
   for i:=1 to elfheader64.elf64_section_header_number do
    begin
     inputfile.Read((elfsectionheader64+i-1)^,sizeof(elf64_section_header));
     if((elfsectionheader64+i-1)^.section_header_type=elf_section_header_strtab)
     and ((elfsectionheader64+i-1)^.section_header_flags=0) then elfstrtabindex:=i;
     if(((elfsectionheader64+i-1)^.section_header_type=elf_section_header_progbits) or
     ((elfsectionheader64+i-1)^.section_header_type=elf_section_header_nobits))
     and ((elfsectionheader64+i-1)^.section_header_address<elflowaddr) then
      begin
       elflowaddr:=(elfsectionheader64+i-1)^.section_header_address;
      end;
    end;
   elfcodeblock:=allocmem(sizeof(Pointer)*elfheader64.elf64_section_header_number);
   for i:=1 to elfheader64.elf64_section_header_number do
    begin
     inputfile.Seek((elfsectionheader64+i-1)^.section_header_offset,0);
     (elfcodeblock+i-1)^:=allocmem((elfsectionheader64+i-1)^.section_header_size);
     if((elfsectionheader64+i-1)^.section_header_flags=0) then continue;
     if((elfsectionheader64+i-1)^.section_header_type=elf_section_header_nobits) then continue;
     if((elfsectionheader64+i-1)^.section_header_type=elf_section_header_null) then continue;
     for j:=1 to (elfsectionheader64+i-1)^.section_header_size do
     inputfile.Read(((elfcodeblock+i-1)^+j-1)^,1);
     if((elfsectionheader64+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)=elf_section_header_flag_alloc) then
     pehaverdata:=true;
    end;
  end
 else
  begin
   if(elfheader32.elf32_type<>elf_type_executable) and (elfheader32.elf32_type<>elf_type_dynamic) then
    begin
     writeln('Input elf file is not be executable or shared library,cannot be converted.');
     inputfile.Free;
     goto label1;
    end;
   inputfile.Seek(elfheader32.elf32_section_header_offset,0);
   elfsectionheader32:=AllocMem(sizeof(elf32_section_header)*elfheader32.elf32_section_header_number);
   for i:=1 to elfheader32.elf32_section_header_number do
    begin
     inputfile.Read((elfsectionheader32+i-1)^,sizeof(elf32_section_header));
     if((elfsectionheader32+i-1)^.section_header_type=elf_section_header_strtab)
     and ((elfsectionheader32+i-1)^.section_header_flags=0) then elfstrtabindex:=i;
     if(((elfsectionheader32+i-1)^.section_header_type=elf_section_header_progbits) or
     ((elfsectionheader32+i-1)^.section_header_type=elf_section_header_nobits))
     and ((elfsectionheader32+i-1)^.section_header_address<elflowaddr) then
      begin
       elflowaddr:=(elfsectionheader32+i-1)^.section_header_address;
      end;
    end;
   elfcodeblock:=allocmem(sizeof(Pointer)*elfheader32.elf32_section_header_number);
   for i:=1 to elfheader32.elf32_section_header_number do
    begin
     inputfile.Seek((elfsectionheader32+i-1)^.section_header_offset,0);
     (elfcodeblock+i-1)^:=allocmem((elfsectionheader32+i-1)^.section_header_size);
     if((elfsectionheader32+i-1)^.section_header_flags=0) then continue;
     if((elfsectionheader32+i-1)^.section_header_type=elf_section_header_nobits) then continue;
     if((elfsectionheader32+i-1)^.section_header_type=elf_section_header_null) then continue;
     for j:=1 to (elfsectionheader32+i-1)^.section_header_size do
     inputfile.Read(((elfcodeblock+i-1)^+j-1)^,1);
     if((elfsectionheader32+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)=elf_section_header_flag_alloc) then
     pehaverdata:=true;
    end;
  end;
 writeln('elf file loaded!');
 {Parse elf file}
 writeln('elf file parsing......');
 elfmaxalignment:=0;
 if(is64bit) then
  begin
   for i:=1 to elfheader64.elf64_section_header_number do
    begin
     if ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_nobits)
     and ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_progbits) then
      begin
       continue;
      end;
     elfshname:=PChar((elfcodeblock+elfstrtabindex-1)^+(elfsectionheader64+i-1)^.section_header_name);
     if(StrCmpL(elfshname,'.interp')=0) or (StrCmpL(elfshname,'.eh_frame')=0)
     or (StrCmpL(elfshname,'.fpcdata')=0) then continue;
     if((elfsectionheader64+i-1)^.section_header_address_align>elfmaxalignment)
     and ((elfsectionheader64+i-1)^.section_header_address_align<pecoff_max_alignment)
     and (((elfsectionheader64+i-1)^.section_header_flags and
     (elf_section_header_flag_exec_instr or elf_section_header_flag_alloc or
     elf_section_header_flag_write)
     =(elf_section_header_flag_exec_instr or elf_section_header_flag_alloc))
     or ((elfsectionheader64+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)
     =elf_section_header_flag_alloc)
     or ((elfsectionheader64+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)
     =elf_section_header_flag_alloc or elf_section_header_flag_write)) then
      begin
       elfmaxalignment:=(elfsectionheader64+i-1)^.section_header_address_align;
      end;
    end;
  end
 else
  begin
   for i:=1 to elfheader32.elf32_section_header_number do
    begin
     if ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_nobits)
     and ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_progbits) then
      begin
       continue;
      end;
     elfshname:=PChar((elfcodeblock+elfstrtabindex-1)^+(elfsectionheader32+i-1)^.section_header_name);
     if(StrCmpL(elfshname,'.interp')=0) or (StrCmpL(elfshname,'.eh_frame')=0)
     or (StrCmpL(elfshname,'.fpcdata')=0) then continue;
     if((elfsectionheader32+i-1)^.section_header_address_align>elfmaxalignment)
     and ((elfsectionheader32+i-1)^.section_header_address_align<pecoff_max_alignment)
     and (((elfsectionheader32+i-1)^.section_header_flags and
     (elf_section_header_flag_exec_instr or elf_section_header_flag_alloc
     or elf_section_header_flag_write)
     =(elf_section_header_flag_exec_instr or elf_section_header_flag_alloc))
     or ((elfsectionheader32+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)
     =elf_section_header_flag_alloc)
     or ((elfsectionheader32+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)
     =elf_section_header_flag_alloc or elf_section_header_flag_write)) then
      begin
       elfmaxalignment:=(elfsectionheader32+i-1)^.section_header_address_align;
      end;
    end;
  end;
 {Initialize pe file}
 writeln('PE file initializing......');
 if(is64bit) then
 PeCoffOffset:=sizeof(dosheader)+$40+sizeof(signature)+sizeof(fileheader)+sizeof(optionalheader64)
 else
 PeCoffOffset:=sizeof(dosheader)+$40+sizeof(signature)+sizeof(fileheader)+sizeof(optionalheader32);
 if(pehaverdata) then
 PeCoffOffset:=PeCoffOffset+sizeof(pe_image_section_header)*4
 else
 PeCoffOffset:=PeCoffOffset+sizeof(pe_image_section_header)*3;
 PeCoffOffset:=optimize_integer_divide(PeCoffOffset+elfmaxalignment-1,elfmaxalignment)*
 elfmaxalignment;
 PeBaseAddr:=PeCoffOffset;
 sectionoffset:=0; elffoundSection:=False;
 pecoffoffsetcount[1]:=0; pecoffoffsetcount[2]:=0; pecoffoffsetcount[3]:=0;
 if(is64bit) then
  begin
   elffoundSection:=False;
   for i:=1 to elfheader64.elf64_section_header_number do
    begin
     if ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_nobits)
     and ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_progbits) then
      begin
       continue;
      end;
     elfshname:=PChar((elfcodeblock+elfstrtabindex-1)^+(elfsectionheader64+i-1)^.section_header_name);
     if(StrCmpL(elfshname,'.interp')=0) or (StrCmpL(elfshname,'.eh_frame')=0) or
     (StrCmpL(elfshname,'.fpcdata')=0) then continue;
     if((elfsectionheader64+i-1)^.section_header_flags and
     (elf_section_header_flag_write or
      elf_section_header_flag_exec_instr or elf_section_header_flag_alloc)
     =(elf_section_header_flag_exec_instr or elf_section_header_flag_alloc)) then
      begin
       inc(sectionoffset);
       inc(pecoffoffsetcount[1]);
       if(elfheader64.elf64_entry>=(elfsectionheader64+i-1)^.section_header_address)
       and (elfheader64.elf64_entry<(elfsectionheader64+i-1)^.section_header_address+
       (elfsectionheader64+i-1)^.section_header_size) then
        begin
         pecoffentry:=PeBaseAddr+elfheader64.elf64_entry-elflowaddr;
        end;
       if(not elffoundSection) then
        begin
         PeTextOffset:=PeBaseAddr+(elfsectionheader64+i-1)^.section_header_address-elflowaddr;
         elffoundsection:=true;
        end;
       pecoffoffsetarray[sectionoffset]:=PeBaseAddr
       +(elfsectionheader64+i-1)^.section_header_address-elflowaddr;
       pecoffindexarray[sectionoffset]:=i;
       pecoffoffset:=PeBaseAddr+(elfsectionheader64+i-1)^.section_header_address-elflowaddr+
       (elfsectionheader64+i-1)^.section_header_size;
      end;
    end;
   elffoundSection:=False;
   for i:=1 to elfheader64.elf64_section_header_number do
    begin
     if(not pehaverdata) then break;
     if ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_nobits)
     and ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_progbits) then
      begin
       continue;
      end;
     elfshname:=PChar((elfcodeblock+elfstrtabindex-1)^+(elfsectionheader64+i-1)^.section_header_name);
     if(StrCmpL(elfshname,'.interp')=0) or (StrCmpL(elfshname,'.eh_frame')=0) or
     (StrCmpL(elfshname,'.fpcdata')=0) then continue;
     if((elfsectionheader64+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)=elf_section_header_flag_alloc) then
      begin
       inc(sectionoffset);
       inc(pecoffoffsetcount[2]);
       if(not elffoundSection) then
        begin
         PeRoDataOffset:=PeBaseAddr+(elfsectionheader64+i-1)^.section_header_address-elflowaddr;
         elffoundsection:=true;
        end;
       pecoffoffsetarray[sectionoffset]:=PeBaseAddr
       +(elfsectionheader64+i-1)^.section_header_address-elflowaddr;
       pecoffindexarray[sectionoffset]:=i;
       pecoffoffset:=PeBaseAddr+(elfsectionheader64+i-1)^.section_header_address-elflowaddr+
       (elfsectionheader64+i-1)^.section_header_size;
      end;
    end;
   elffoundSection:=False;
   for i:=1 to elfheader64.elf64_section_header_number do
    begin
     if ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_nobits)
     and ((elfsectionheader64+i-1)^.section_header_type<>elf_section_header_progbits) then
      begin
       continue;
      end;
     elfshname:=PChar((elfcodeblock+elfstrtabindex-1)^+(elfsectionheader64+i-1)^.section_header_name);
     if(StrCmpL(elfshname,'.interp')=0) or (StrCmpL(elfshname,'.eh_frame')=0) or
     (StrCmpL(elfshname,'.fpcdata')=0) then continue;
     if((elfsectionheader64+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)
     =elf_section_header_flag_alloc or elf_section_header_flag_write) then
      begin
       inc(sectionoffset);
       inc(pecoffoffsetcount[3]);
       if(not elffoundSection) then
        begin
         PeDataOffset:=PeBaseAddr+(elfsectionheader64+i-1)^.section_header_address-elflowaddr;
         elffoundsection:=true;
        end;
       pecoffoffsetarray[sectionoffset]:=PeBaseAddr
       +(elfsectionheader64+i-1)^.section_header_address-elflowaddr;
       pecoffindexarray[sectionoffset]:=i;
       pecoffoffset:=PeBaseAddr+(elfsectionheader64+i-1)^.section_header_address-elflowaddr+
       (elfsectionheader64+i-1)^.section_header_size;
      end;
    end;
   PeRelocationOffset:=optimize_integer_divide(pecoffoffset+elfmaxalignment-1
   ,elfmaxalignment)*elfmaxalignment;
  end
 else
  begin
   elffoundSection:=False;
   for i:=1 to elfheader32.elf32_section_header_number do
    begin
     if ((elfsectionheader32+i-1)^.section_header_type<>elf_section_header_nobits)
     and ((elfsectionheader32+i-1)^.section_header_type<>elf_section_header_progbits) then
      begin
       continue;
      end;
     elfshname:=PChar((elfcodeblock+elfstrtabindex-1)^+(elfsectionheader32+i-1)^.section_header_name);
     if(StrCmpL(elfshname,'.interp')=0) or (StrCmpL(elfshname,'.eh_frame')=0) or
     (StrCmpL(elfshname,'.fpcdata')=0) then continue;
     if((elfsectionheader32+i-1)^.section_header_flags and
     (elf_section_header_flag_write or
      elf_section_header_flag_exec_instr or elf_section_header_flag_alloc)
     =(elf_section_header_flag_exec_instr or elf_section_header_flag_alloc)) then
      begin
       inc(sectionoffset);
       inc(pecoffoffsetcount[1]);
       if(elfheader32.elf32_entry>=(elfsectionheader32+i-1)^.section_header_address)
       and (elfheader32.elf32_entry<(elfsectionheader32+i-1)^.section_header_address+
       (elfsectionheader32+i-1)^.section_header_size) then
        begin
         pecoffentry:=PeBaseAddr+elfheader32.elf32_entry-elflowaddr;
        end;
       if(not elffoundSection) then
        begin
         PeTextOffset:=PeBaseAddr+(elfsectionheader32+i-1)^.section_header_address-elflowaddr;
         elffoundsection:=true;
        end;
       pecoffoffsetarray[sectionoffset]:=PeBaseAddr
       +(elfsectionheader32+i-1)^.section_header_address-elflowaddr;
       pecoffindexarray[sectionoffset]:=i;
       pecoffoffset:=PeBaseAddr+(elfsectionheader64+i-1)^.section_header_address-elflowaddr+
       (elfsectionheader32+i-1)^.section_header_size;
      end;
    end;
   elffoundSection:=False;
   for i:=1 to elfheader32.elf32_section_header_number do
    begin
     if(not pehaverdata) then break;
     if ((elfsectionheader32+i-1)^.section_header_type<>elf_section_header_nobits)
     and ((elfsectionheader32+i-1)^.section_header_type<>elf_section_header_progbits) then
      begin
       continue;
      end;
     elfshname:=PChar((elfcodeblock+elfstrtabindex-1)^+(elfsectionheader32+i-1)^.section_header_name);
     if(StrCmpL(elfshname,'.interp')=0) or (StrCmpL(elfshname,'.eh_frame')=0) or
     (StrCmpL(elfshname,'.fpcdata')=0) then continue;
     if((elfsectionheader32+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)=elf_section_header_flag_alloc) then
      begin
       inc(sectionoffset);
       inc(pecoffoffsetcount[2]);
       if(not elffoundSection) then
        begin
         PeRoDataOffset:=PeBaseAddr+(elfsectionheader32+i-1)^.section_header_address-elflowaddr;
         PeCoffOffset:=PeRoDataOffset;
         elffoundsection:=true;
        end;
       pecoffoffsetarray[sectionoffset]:=PeBaseAddr
       +(elfsectionheader32+i-1)^.section_header_address-elflowaddr;
       pecoffindexarray[sectionoffset]:=i;
       pecoffoffset:=PeBaseAddr+(elfsectionheader64+i-1)^.section_header_address-elflowaddr+
       (elfsectionheader32+i-1)^.section_header_size;
      end;
    end;
   elffoundSection:=False;
   for i:=1 to elfheader32.elf32_section_header_number do
    begin
     if ((elfsectionheader32+i-1)^.section_header_type<>elf_section_header_nobits)
     and ((elfsectionheader32+i-1)^.section_header_type<>elf_section_header_progbits) then
      begin
       continue;
      end;
     elfshname:=PChar((elfcodeblock+elfstrtabindex-1)^+(elfsectionheader32+i-1)^.section_header_name);
     if(StrCmpL(elfshname,'.interp')=0) or (StrCmpL(elfshname,'.eh_frame')=0) or
     (StrCmpL(elfshname,'.fpcdata')=0) then continue;
     if((elfsectionheader32+i-1)^.section_header_flags and
     (elf_section_header_flag_write or elf_section_header_flag_alloc or
     elf_section_header_flag_exec_instr)
     =elf_section_header_flag_alloc or elf_section_header_flag_write) then
      begin
       inc(sectionoffset);
       inc(pecoffoffsetcount[3]);
       if(not elffoundSection) then
        begin
         PeDataOffset:=PeBaseAddr+(elfsectionheader32+i-1)^.section_header_address-elflowaddr;
         elffoundsection:=true;
        end;
       pecoffoffsetarray[sectionoffset]:=PeBaseAddr
       +(elfsectionheader32+i-1)^.section_header_address-elflowaddr;
       pecoffindexarray[sectionoffset]:=i;
       pecoffoffset:=PeBaseAddr+(elfsectionheader64+i-1)^.section_header_address-elflowaddr+
       (elfsectionheader32+i-1)^.section_header_size;
      end;
    end;
   PeRelocationOffset:=optimize_integer_divide(pecoffoffset+elfmaxalignment-1
   ,elfmaxalignment)*elfmaxalignment;
  end;
 {Initialize the pe content}
 writeln('Initialize the pe content......');
 ptr:=@dosheader;
 for i:=1 to sizeof(dosheader) do (ptr+i-1)^:=0;
 dosheader.magic_number:=$5A4D;
 dosheader.file_address_of_new_exe_header:=sizeof(dosheader)+$40;
 signature:=$00004550;
 ptr:=@fileheader;
 for i:=1 to sizeof(fileheader) do (ptr+i-1)^:=0;
 for i:=1 to 8192 do memzero[i]:=0;
 case myplatform of
 0:fileheader.Machine:=pe_image_file_machine_i386;
 1:fileheader.Machine:=pe_image_file_machine_amd64;
 2:fileheader.Machine:=pe_image_file_machine_arm;
 3:fileheader.Machine:=pe_image_file_machine_arm64;
 4:fileheader.Machine:=pe_image_file_machine_loongarch64;
 5:fileheader.Machine:=pe_image_file_machine_riscv64;
 end;
 if(pehaverdata) then fileheader.NumberOfSections:=4 else fileheader.NumberOfSections:=3;
 fileheader.Characteristics:=pe_image_file_line_nums_stripped or pe_image_file_local_syms_stripped or
 pe_image_file_debug_stripped or pe_image_file_executable_image;
 if(is64bit) then
  begin
   fileheader.SizeOfOptionalHeader:=sizeof(pe_image_nt_header64);
   ptr:=@optionalheader64;
   for i:=1 to sizeof(optionalheader64) do (ptr+i-1)^:=0;
   optionalheader64.Magic:=pe_image_pe32plus_image_magic;
   if(pehaverdata) then
   optionalheader64.SizeOfCode:=peRoDataOffset-peTextOffset
   else
   optionalheader64.SizeOfCode:=peDataOffset-peTextOffset;
   if(pehaverdata) then
   optionalheader64.SizeOfInitializedData:=peRelocationOffset-peRoDataOffset
   else
   optionalheader64.SizeOfInitializedData:=peRelocationOffset-peDataOffset;
   optionalheader64.AddressOfEntryPoint:=PeCoffEntry;
   optionalheader64.BaseOfCode:=PeTextOffset;
   optionalheader64.ImageBase:=$00000000;
   optionalheader64.SectionAlignment:=elfmaxalignment;
   optionalheader64.FileAlignment:=elfmaxalignment;
   optionalheader64.SizeOfImage:=
   optimize_integer_divide(PeRelocationOffset+12+elfmaxalignment-1,elfmaxalignment)*elfmaxalignment;
   optionalheader64.SizeOfHeaders:=PeTextOffset;
   optionalheader64.Subsystem:=pe_image_subsystem_efi_application;
   optionalheader64.NumberOfRvaandSizes:=16;
   optionalheader64.DataDirectory[6].virtualaddress:=PeRelocationOffset;
   optionalheader64.DataDirectory[6].size:=12;
   optionalheader64.CheckSum:=0;
  end
 else
  begin
   fileheader.SizeOfOptionalHeader:=sizeof(pe_image_nt_header32);
   ptr:=@optionalheader32;
   for i:=1 to sizeof(optionalheader32) do (ptr+i-1)^:=0;
   optionalheader32.Magic:=pe_image_pe32_image_magic;
   if(pehaverdata) then
   optionalheader32.SizeOfCode:=peRoDataOffset-peTextOffset
   else
   optionalheader32.SizeOfCode:=peDataOffset-peTextOffset;
   if(pehaverdata) then
   optionalheader32.SizeOfInitializedData:=peRelocationOffset-peRoDataOffset
   else
   optionalheader32.SizeOfInitializedData:=peRelocationOffset-peDataOffset;
   optionalheader32.AddressOfEntryPoint:=PeCoffEntry;
   optionalheader32.BaseOfCode:=PeTextOffset;
   if(pehaverdata) then
   optionalheader32.BaseOfData:=peRoDataOffset
   else
   optionalheader32.BaseOfData:=peDataOffset;
   optionalheader32.ImageBase:=$00000000;
   optionalheader32.SectionAlignment:=elfmaxalignment;
   optionalheader32.FileAlignment:=elfmaxalignment;
   optionalheader32.SizeOfImage:=
   optimize_integer_divide(PeRelocationOffset+12+elfmaxalignment-1,elfmaxalignment)*elfmaxalignment;
   optionalheader32.SizeOfHeaders:=PeTextOffset;
   optionalheader32.Subsystem:=pe_image_subsystem_efi_application;
   optionalheader32.NumberOfRvaandSizes:=16;
   optionalheader32.DataDirectory[6].virtualaddress:=PeRelocationOffset;
   optionalheader32.DataDirectory[6].size:=12;
   optionalheader32.Checksum:=0;
  end;
 if(pehaverdata) then
 sectionheader:=allocmem(Sizeof(pe_image_section_header)*4)
 else
 sectionheader:=allocmem(Sizeof(pe_image_section_header)*3);
 if(pehaverdata) then
  begin
   sectionheader^.Name:='.text';
   sectionheader^.Misc.VirtualSize:=PeRoDataOffset-PeTextOffset;
   sectionheader^.VirtualAddress:=PeTextOffset;
   sectionheader^.SizeOfRawData:=PeRoDataOffset-PeTextOffset;
   sectionheader^.PointerToRawData:=PeTextOffset;
   sectionheader^.Characteristics:=pe_image_scn_cnt_code or pe_image_mem_execute or pe_image_mem_read;
   (sectionheader+1)^.Name:='.rdata';
   (sectionheader+1)^.Misc.VirtualSize:=PeDataOffset-PeRoDataOffset;
   (sectionheader+1)^.VirtualAddress:=PeRoDataOffset;
   (sectionheader+1)^.SizeOfRawData:=PeDataOffset-PeRoDataOffset;
   (sectionheader+1)^.PointerToRawData:=PeRoDataOffset;
   (sectionheader+1)^.Characteristics:=pe_image_scn_cnt_initialized_data or pe_image_mem_read;
   (sectionheader+2)^.Name:='.data';
   (sectionheader+2)^.Misc.VirtualSize:=PeRelocationOffset-PeDataOffset;
   (sectionheader+2)^.VirtualAddress:=PeDataOffset;
   (sectionheader+2)^.SizeOfRawData:=PeRelocationOffset-PeDataOffset;
   (sectionheader+2)^.PointerToRawData:=PeDataOffset;
   (sectionheader+2)^.Characteristics:=pe_image_scn_cnt_initialized_data or
   pe_image_mem_write or pe_image_mem_read;
   (sectionheader+3)^.Name:='.reloc';
   (sectionheader+3)^.Misc.VirtualSize:=12;
   (sectionheader+3)^.VirtualAddress:=PeRelocationOffset;
   (sectionheader+3)^.SizeOfRawData:=12;
   (sectionheader+3)^.PointerToRawData:=PeRelocationOffset;
   (sectionheader+3)^.Characteristics:=pe_image_scn_cnt_initialized_data or pe_image_mem_read;
  end
 else
  begin
   sectionheader^.Name:='.text';
   sectionheader^.Misc.VirtualSize:=PeDataOffset-PeTextOffset;
   sectionheader^.VirtualAddress:=PeTextOffset;
   sectionheader^.SizeOfRawData:=PeDataOffset-PeTextOffset;
   sectionheader^.PointerToRawData:=PeTextOffset;
   sectionheader^.Characteristics:=pe_image_scn_cnt_code or pe_image_mem_execute or pe_image_mem_read;
   (sectionheader+1)^.Name:='.data';
   (sectionheader+1)^.Misc.VirtualSize:=PeRelocationOffset-PeDataOffset;
   (sectionheader+1)^.VirtualAddress:=PeDataOffset;
   (sectionheader+1)^.SizeOfRawData:=PeRelocationOffset-PeDataOffset;
   (sectionheader+1)^.PointerToRawData:=PeDataOffset;
   (sectionheader+1)^.Characteristics:=pe_image_scn_cnt_initialized_data or
   pe_image_mem_write or pe_image_mem_read;
   (sectionheader+2)^.Name:='.reloc';
   (sectionheader+2)^.Misc.VirtualSize:=12;
   (sectionheader+2)^.VirtualAddress:=PeRelocationOffset;
   (sectionheader+2)^.SizeOfRawData:=12;
   (sectionheader+2)^.PointerToRawData:=PeRelocationOffset;
   (sectionheader+2)^.Characteristics:=pe_image_scn_cnt_initialized_data or pe_image_mem_read;
  end;
 relocationheader.VirtualAddress:=PeDataOffset;
 relocationheader.SizeOfBlock:=12;
 relocationitem[1].Offset:=0;
 relocationitem[1].peType:=0;
 relocationitem[2].Offset:=0;
 relocationitem[2].peType:=0;
 {Write pe file}
 if(namecustom) then
  begin
   outputfile:=TFileStream.Create(outputpath,fmCreate);
  end
 else
   case myplatform of
   0:
    begin
     outputfile:=TFileStream.Create(outputpath+'bootia32.efi',fmCreate);
    end;
   1:
    begin
     outputfile:=TFileStream.Create(outputpath+'bootx64.efi',fmCreate);
    end;
   2:
    begin
     outputfile:=TFileStream.Create(outputpath+'bootarm.efi',fmCreate);
    end;
   3:
    begin
     outputfile:=TFileStream.Create(outputpath+'bootaa64.efi',fmCreate);
    end;
   4:
    begin
     outputfile:=TFileStream.Create(outputpath+'bootloongarch64.efi',fmCreate);
    end;
   5:
    begin
     outputfile:=TFileStream.Create(outputpath+'bootriscv64.efi',fmCreate);
    end;
  end;
 writeln('Writing PE file......');
 outputfile.Seek(0,0);
 for i:=1 to optimize_integer_divide(PeRelocationOffset+12+elfmaxalignment-1,elfmaxalignment) do
  begin
   outputfile.Write(machinenop,elfmaxalignment);
  end;
 outputfile.Seek(0,0);
 outputfile.Write(dosheader,sizeof(dosheader));
 outputfile.Write(memzero,$40);
 outputfile.Write(signature,sizeof(signature));
 outputfile.Write(fileheader,sizeof(fileheader));
 if(is64bit) then outputfile.Write(optionalheader64,sizeof(optionalheader64))
 else outputfile.Write(optionalheader32,sizeof(optionalheader32));
 for i:=1 to fileheader.NumberOfSections do
 outputfile.Write((sectionheader+i-1)^,sizeof(pe_image_section_header));
 if(is64bit) then
  begin
   pecoffindex:=0;
   for i:=1 to pecoffoffsetcount[1] do
    begin
     inc(pecoffindex);
     outputfile.Seek(pecoffoffsetarray[pecoffindex],0);
     pecalindex:=pecoffindexarray[pecoffindex];
     pecalsize:=(elfsectionheader64+pecalindex-1)^.section_header_size;
     for j:=1 to pecalsize do outputfile.Write(((elfcodeblock+pecalindex-1)^+j-1)^,1)
    end;
   if(pehaverdata) then
    begin
     for i:=1 to pecoffoffsetcount[2] do
      begin
       inc(pecoffindex);
       outputfile.Seek(pecoffoffsetarray[pecoffindex],0);
       pecalindex:=pecoffindexarray[pecoffindex];
       pecalsize:=(elfsectionheader64+pecalindex-1)^.section_header_size;
       for j:=1 to pecalsize do outputfile.Write(((elfcodeblock+pecalindex-1)^+j-1)^,1)
      end;
    end;
   for i:=1 to pecoffoffsetcount[3] do
    begin
     inc(pecoffindex);
     outputfile.Seek(pecoffoffsetarray[pecoffindex],0);
     pecalindex:=pecoffindexarray[pecoffindex];
     pecalsize:=(elfsectionheader64+pecalindex-1)^.section_header_size;
     for j:=1 to pecalsize do outputfile.Write(((elfcodeblock+pecalindex-1)^+j-1)^,1)
    end;
   outputfile.Seek(PeRelocationOffset,0);
   outputfile.Write(Relocationheader,sizeof(pe_image_base_relocation));
   outputfile.Write(Relocationitem[1],sizeof(pe_image_type_offset));
   outputfile.Write(Relocationitem[2],sizeof(pe_image_type_offset));
  end
 else
  begin
   pecoffindex:=0;
   for i:=1 to pecoffoffsetcount[1] do
    begin
     inc(pecoffindex);
     outputfile.Seek(pecoffoffsetarray[pecoffindex],0);
     pecalindex:=pecoffindexarray[pecoffindex];
     pecalsize:=(elfsectionheader32+pecalindex-1)^.section_header_size;
     for j:=1 to pecalsize do outputfile.Write(((elfcodeblock+pecalindex-1)^+j-1)^,1)
    end;
   if(pehaverdata) then
    begin
     for i:=1 to pecoffoffsetcount[2] do
      begin
       inc(pecoffindex);
       outputfile.Seek(pecoffoffsetarray[pecoffindex],0);
       pecalindex:=pecoffindexarray[pecoffindex];
       pecalsize:=(elfsectionheader32+pecalindex-1)^.section_header_size;
       for j:=1 to pecalsize do outputfile.Write(((elfcodeblock+pecalindex-1)^+j-1)^,1)
      end;
    end;
   for i:=1 to pecoffoffsetcount[3] do
    begin
     inc(pecoffindex);
     outputfile.Seek(pecoffoffsetarray[pecoffindex],0);
     pecalindex:=pecoffindexarray[pecoffindex];
     pecalsize:=(elfsectionheader32+pecalindex-1)^.section_header_size;
     for j:=1 to pecalsize do outputfile.Write(((elfcodeblock+pecalindex-1)^+j-1)^,1)
    end;
   outputfile.Seek(PeRelocationOffset,0);
   outputfile.Write(Relocationheader,sizeof(pe_image_base_relocation));
   outputfile.Write(Relocationitem[1],sizeof(pe_image_type_offset));
   outputfile.Write(Relocationitem[2],sizeof(pe_image_type_offset));
  end;
 {Free the memory requested by program}
 outputfile.Free;
 freemem(sectionheader);
 if(is64bit) then
  begin
   for i:=elfheader64.elf64_section_header_number downto 1 do FreeMem((elfcodeblock+i-1)^);
   FreeMem(elfcodeblock);
   FreeMem(elfsectionheader64);
  end
 else
  begin
   for i:=elfheader32.elf32_section_header_number downto 1 do FreeMem((elfcodeblock+i-1)^);
   FreeMem(elfcodeblock);
   FreeMem(elfsectionheader32);
  end;
 inputfile.Free;
end.
