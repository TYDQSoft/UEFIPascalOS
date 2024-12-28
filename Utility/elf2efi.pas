program elf2efi;
uses binarybase,sysutils,classes;
type natuint=qword;
     natint=int64;
     relocarray=array[1..65535] of pe_image_type_offset;
     Pelf32_rela=^elf32_rela;
     Pelf64_rela=^elf64_rela;
const pecoff_max_alignment=$10000;
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
function CalcCheckSum(Data:Pointer;DataSize:SizeUint):dword;
var Ptr:Pword;
    sum,checksum:dword;
    i:dword;
begin
 Ptr:=Data; sum:=0; checksum:=0;
 for i:=1 to DataSize div 2 do
  begin
   sum:=(Ptr+i-1)^+checksum;
   checksum:=Word(sum)+sum shr 16;
  end;
 CalcCheckSum:=checksum+checksum shr 16;
end;
var i,j:qword;
    ptr:PByte;
    merge:boolean=false;
    mergeindex:byte=0;
    {For elf files input}
    inputfile:TFileStream;
    infilename,outfilename,prostr1,prostr2:string;
    is64bit:boolean;
    elfmachine:word;
    myplatform:byte=0;
    elfheader32:elf32_header;
    elfprogramheader32:^elf32_program_header;
    elfrela32:elf32_section_header;
    elfrela32item:elf32_rela;
    elf32value:dword;
    elfheader64:elf64_header;
    elfprogramheader64:^elf64_program_header;
    elfrela64:elf64_section_header;
    elfrela64item:elf64_rela;
    elf64value:qword;
    elfrelacontent:Pointer;
    elfrelasize:dword;
    elfcodeblock:^Pointer;
    elfloadcount:byte;
    elfloadindex:array[1..4] of byte;
    elflowaddress:SizeUint;
    elfmaxalign:dword;
    {For efi files output}
    peLowAddress:integer=-1;
    pebaseaddr:dword;
    pecoffindex:word;
    pecoffoffset:dword;
    sectionoffset:word;
    peTextOffset:dword;
    peRoDataOffset:dword;
    peDataOffset:dword;
    peRelocationOffset:dword;
    pecoffentry:dword;
    memzero:array[1..65535] of byte;
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
    {For PE Checksum calculation}
    FileBuffer:PByte;
    FileBufferSize:SizeUint;
label label1,label2,label3,label4;
begin
 if(ParamCount<>2) then
  begin
   writeln('ERROR:Program run when only two parameters provided.');
   goto label1;
  end
 else
  begin
   infilename:=ParamStr(1);
   if(infilename[1]='"') or (infilename[1]=#39) then
    begin
     infilename:=copy(infilename,2,length(infilename)-2);
    end;
   if(not FileExists(infilename)) then
    begin
     writeln('ERROR:File does not exist.');
     goto label1;
    end;
   outfilename:=ParamStr(2);
   if(outfilename[1]='"') or (outfilename[1]=#39) then
    begin
     outfilename:=copy(outfilename,2,length(outfilename)-2);
    end;
   prostr1:=ExtractFilePath(outfilename);
   prostr2:=copy(prostr1,1,length(prostr1)-1);
   if(not DirectoryExists(prostr2)) then
    begin
     writeln('ERROR:File Path does not exist.');
     goto label1;
    end;
   if(ExtractFileName(outfilename)='.efi') or (ExtractFileName(outfilename)='.EFI') then
    begin
     writeln('ERROR:File Extended name does not to be UEFI file.');
     goto label1;
    end;
   goto label2;
  end;
 label1:
 label3:
 writeln('Input your input file name to convert:');
 readln(infilename);
 if(infilename[1]='"') or (infilename[1]=#39) then
  begin
   infilename:=copy(infilename,2,length(infilename)-2);
  end;
 if(not FileExists(infilename)) then
  begin
   writeln('ERROR:File does not exist.');
   goto label3;
  end;
 label4:
 writeln('Input your output file name converted:');
 readln(outfilename);
 if(outfilename[1]='"') or (outfilename[1]=#39) then
  begin
   outfilename:=copy(outfilename,2,length(outfilename)-2);
  end;
 prostr1:=ExtractFilePath(outfilename);
 prostr2:=copy(prostr1,1,length(prostr1)-1);
 if(not DirectoryExists(prostr2)) then
  begin
   writeln('ERROR:File Path does not exist.');
   goto label4;
  end;
 if(ExtractFileName(outfilename)='.efi') or (ExtractFileName(outfilename)='.EFI') then
  begin
   writeln('ERROR:File Extended name does not to be UEFI file.');
   goto label4;
  end;
 label2:
 merge:=false; mergeindex:=0; is64bit:=false;
 inputfile:=TFileStream.Create(infilename,fmOpenRead);
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
 {$ifdef cpu32}elflowaddress:=$7FFFFFFF;{$endif cpu32}
 {$ifdef cpu64}elflowaddress:=$7FFFFFFFFFFFFFFF;{$endif cpu64}
 elfloadcount:=0; elfmaxalign:=0;
 if(is64bit) then
  begin
   if(elfheader64.elf64_type<>elf_type_executable) and (elfheader64.elf64_type<>elf_type_dynamic) then
    begin
     writeln('Input elf file is not be executable or shared library,cannot be converted.');
     inputfile.Free;
     goto label1;
    end;
   elfprogramheader64:=AllocMem(sizeof(elf64_program_header)*elfheader64.elf64_program_header_number);
   inputfile.Seek(elfheader64.elf64_program_header_offset,0);
   for i:=1 to elfheader64.elf64_program_header_number do
    begin
     inputfile.Read((elfprogramheader64+i-1)^,sizeof(elf64_program_header));
     if((elfprogramheader64+i-1)^.program_type=elf_program_table_load) and
     ((elfprogramheader64+i-1)^.program_file_size>0) then
      begin
       inc(elfloadcount);
       elfloadindex[elfloadcount]:=i;
       if((elfprogramheader64+i-1)^.program_virtual_address<elflowaddress) then
       elflowaddress:=(elfprogramheader64+i-1)^.program_virtual_address;
       if((elfprogramheader64+i-1)^.program_align>elfmaxalign) then
       elfmaxalign:=(elfprogramheader64+i-1)^.program_align;
      end;
    end;
   elfcodeblock:=AllocMem(sizeof(elf64_program_header)*sizeof(Pointer));
   for i:=1 to elfheader64.elf64_program_header_number do
    begin
     if((elfprogramheader64+i-1)^.program_type<>elf_program_table_load) then continue;
     if((elfprogramheader64+i-1)^.program_file_size=0) then continue;
     inputfile.Seek((elfprogramheader64+i-1)^.program_offset,0);
     (elfcodeblock+i-1)^:=AllocMem((elfprogramheader64+i-1)^.program_memory_size);
     for j:=1 to (elfprogramheader64+i-1)^.program_file_size do inputfile.Read(((elfcodeblock+i-1)^+j-1)^,1);
    end;
   inputfile.Seek(elfheader64.elf64_section_header_offset,0);
   i:=1; elfrelasize:=0;
   while(i<=elfheader64.elf64_section_header_number) do
    begin
     inputfile.Read(elfrela64,sizeof(elf64_section_header));
     if(elfrela64.section_header_type=elf_section_header_rela) then break;
     inc(i);
    end;
   if(i<=elfheader64.elf64_section_header_number) then
    begin
     inputfile.Seek(elfrela64.section_header_offset,0);
     elfrelasize:=elfrela64.section_header_size;
     elfrelacontent:=AllocMem(elfrelasize);
     for j:=1 to elfrela64.section_header_size do inputfile.Read((elfrelacontent+j-1)^,1);
    end
   else elfrelasize:=0;
  end
 else
  begin
   if(elfheader32.elf32_type<>elf_type_executable) and (elfheader32.elf32_type<>elf_type_dynamic) then
    begin
     writeln('Input elf file is not be executable or shared library,cannot be converted.');
     inputfile.Free;
     goto label1;
    end;
   elfprogramheader32:=AllocMem(sizeof(elf32_program_header)*elfheader32.elf32_program_header_number);
   inputfile.Seek(elfheader32.elf32_program_header_offset,0);
   for i:=1 to elfheader32.elf32_program_header_number do
    begin
     inputfile.Read((elfprogramheader32+i-1)^,sizeof(elf32_program_header));
     if((elfprogramheader32+i-1)^.program_type=elf_program_table_load) and
     ((elfprogramheader32+i-1)^.program_file_size>0) then
      begin
       inc(elfloadcount);
       elfloadindex[elfloadcount]:=i;
       if((elfprogramheader32+i-1)^.program_virtual_address<elflowaddress) then
       elflowaddress:=(elfprogramheader32+i-1)^.program_virtual_address;
       if((elfprogramheader32+i-1)^.program_align>elfmaxalign) then
       elfmaxalign:=(elfprogramheader32+i-1)^.program_align;
      end;
    end;
   elfcodeblock:=AllocMem(sizeof(elf32_program_header)*sizeof(Pointer));
   for i:=1 to elfheader32.elf32_program_header_number-1 do
    begin
     if((elfprogramheader32+i-1)^.program_type<>elf_program_table_load) then continue;
     if((elfprogramheader32+i-1)^.program_file_size=0) then continue;
     inputfile.Seek((elfprogramheader32+i-1)^.program_offset,0);
     (elfcodeblock+i-1)^:=AllocMem((elfprogramheader32+i-1)^.program_memory_size);
     for j:=1 to (elfprogramheader32+i-1)^.program_file_size do inputfile.Read(((elfcodeblock+i-1)^+j-1)^,1);
    end;
   i:=1; elfrelasize:=0;
   while(i<=elfheader32.elf32_section_header_number) do
    begin
     inputfile.Read(elfrela32,sizeof(elf64_section_header));
     if(elfrela32.section_header_type=elf_section_header_rela) then break;
     inc(i);
    end;
   if(i<=elfheader32.elf32_section_header_number) then
    begin
     inputfile.Seek(elfrela32.section_header_offset,0);
     elfrelasize:=elfrela32.section_header_size;
     elfrelacontent:=AllocMem(elfrelasize);
     for j:=1 to elfrela32.section_header_size do inputfile.Read((elfrelacontent+j-1)^,1);
    end
   else elfrelasize:=0;
  end;
 writeln('elf file loaded!');
 {Initialize pe file}
 writeln('PE file initializing......');
 if(elfmaxalign>$1000) then elfmaxalign:=$1000;
 if(is64bit) then
 PeCoffOffset:=sizeof(dosheader)+$40+sizeof(signature)+sizeof(fileheader)+sizeof(optionalheader64)
 else
 PeCoffOffset:=sizeof(dosheader)+$40+sizeof(signature)+sizeof(fileheader)+sizeof(optionalheader32);
 PeCoffOffset:=PeCoffOffset+sizeof(pe_image_section_header)*4;
 PeCoffOffset:=optimize_integer_divide(PeCoffOffset+elfmaxalign-1,elfmaxalign)*elfmaxalign;
 PeBaseAddr:=PeCoffOffset; PeRoDataOffset:=0;
 if(is64bit) then
  begin
   if(elfloadcount=2) then
    begin
     PeTextOffset:=PeBaseAddr+(elfprogramheader64+elfloadindex[1]-1)^.program_virtual_address-elflowaddress;
     PeDataOffset:=PeBaseAddr+(elfprogramheader64+elfloadindex[2]-1)^.program_virtual_address-elflowaddress;
     PeRelocationOffset:=optimize_integer_divide(
     PeBaseAddr+(elfprogramheader64+elfloadindex[2]-1)^.program_virtual_address-elflowaddress+
     (elfprogramheader64+elfloadindex[2]-1)^.program_memory_size+elfmaxalign-1,elfmaxalign)*elfmaxalign;
    end
   else if(elfloadcount=3) then
    begin
     PeTextOffset:=PeBaseAddr+(elfprogramheader64+elfloadindex[1]-1)^.program_virtual_address-elflowaddress;
     PeRoDataOffset:=PeBaseAddr+(elfprogramheader64+elfloadindex[2]-1)^.program_virtual_address-elflowaddress;
     PeDataOffset:=PeBaseAddr+(elfprogramheader64+elfloadindex[3]-1)^.program_virtual_address-elflowaddress;
     PeRelocationOffset:=optimize_integer_divide(
     PeBaseAddr+(elfprogramheader64+elfloadindex[3]-1)^.program_virtual_address-elflowaddress+
     (elfprogramheader64+elfloadindex[3]-1)^.program_memory_size+elfmaxalign-1,elfmaxalign)*elfmaxalign;
    end
   else if(elfloadcount=4) then
    begin
     mergeindex:=elfloadindex[2]; merge:=true;
     elfloadindex[2]:=elfloadindex[3]; elfloadindex[3]:=elfloadindex[4];
     PeTextOffset:=PeBaseAddr+(elfprogramheader64+elfloadindex[1]-1)^.program_virtual_address-elflowaddress;
     PeRoDataOffset:=PeBaseAddr+(elfprogramheader64+elfloadindex[2]-1)^.program_virtual_address-elflowaddress;
     PeDataOffset:=PeBaseAddr+(elfprogramheader64+elfloadindex[3]-1)^.program_virtual_address-elflowaddress;
     PeRelocationOffset:=optimize_integer_divide(
     PeBaseAddr+(elfprogramheader64+elfloadindex[3]-1)^.program_virtual_address-elflowaddress+
     (elfprogramheader64+elfloadindex[3]-1)^.program_memory_size+elfmaxalign-1,elfmaxalign)*elfmaxalign;
    end;
   PeCoffEntry:=PeBaseAddr+elfheader64.elf64_entry-elflowaddress;
  end
 else
  begin
   if(elfloadcount=2) then
    begin
     PeTextOffset:=PeBaseAddr+(elfprogramheader32+elfloadindex[1]-1)^.program_virtual_address-elflowaddress;
     PeDataOffset:=PeBaseAddr+(elfprogramheader32+elfloadindex[2]-1)^.program_virtual_address-elflowaddress;
     PeRelocationOffset:=optimize_integer_divide(
     PeBaseAddr+(elfprogramheader32+elfloadindex[2]-1)^.program_virtual_address-elflowaddress+
     (elfprogramheader32+elfloadindex[2]-1)^.program_memory_size+elfmaxalign-1,elfmaxalign)*elfmaxalign;
    end
   else if(elfloadcount=3) then
    begin
     PeTextOffset:=PeBaseAddr+(elfprogramheader32+elfloadindex[1]-1)^.program_virtual_address-elflowaddress;
     PeRoDataOffset:=PeBaseAddr+(elfprogramheader32+elfloadindex[2]-1)^.program_virtual_address-elflowaddress;
     PeDataOffset:=PeBaseAddr+(elfprogramheader32+elfloadindex[3]-1)^.program_virtual_address-elflowaddress;
     PeRelocationOffset:=optimize_integer_divide(
     PeBaseAddr+(elfprogramheader32+elfloadindex[3]-1)^.program_virtual_address-elflowaddress+
     (elfprogramheader32+elfloadindex[3]-1)^.program_memory_size+elfmaxalign-1,elfmaxalign)*elfmaxalign;
    end
   else if(elfloadcount=4) then
    begin
     mergeindex:=elfloadindex[2]; merge:=true;
     elfloadindex[2]:=elfloadindex[3]; elfloadindex[3]:=elfloadindex[4];
     PeTextOffset:=PeBaseAddr+(elfprogramheader32+elfloadindex[1]-1)^.program_virtual_address-elflowaddress;
     PeRoDataOffset:=PeBaseAddr+(elfprogramheader32+elfloadindex[2]-1)^.program_virtual_address-elflowaddress;
     PeDataOffset:=PeBaseAddr+(elfprogramheader32+elfloadindex[3]-1)^.program_virtual_address-elflowaddress;
     PeRelocationOffset:=optimize_integer_divide(
     PeBaseAddr+(elfprogramheader32+elfloadindex[3]-1)^.program_virtual_address-elflowaddress+
     (elfprogramheader32+elfloadindex[3]-1)^.program_memory_size+elfmaxalign-1,elfmaxalign)*elfmaxalign;
    end;
   PeCoffEntry:=PeBaseAddr+elfheader32.elf32_entry-elflowaddress;
  end;
 {Initialize the pe content}
 writeln('PeCoff Text Offset:',IntToHex(PeTextOffset));
 if(PeRoDataOffset>0) then writeln('PeCoff RoData Offset:',IntToHex(PeRoDataOffset));
 writeln('PeCoff Data Offset:',IntToHex(PeDataOffset));
 writeln('PeCoff Relocation Offset:',IntToHex(PeRelocationOffset));
 writeln('Initialize the pe content......');
 ptr:=@dosheader;
 for i:=1 to sizeof(dosheader) do (ptr+i-1)^:=0;
 dosheader.magic_number:=$5A4D;
 dosheader.file_address_of_new_exe_header:=sizeof(dosheader)+$40;
 signature:=$00004550;
 ptr:=@fileheader;
 for i:=1 to sizeof(fileheader) do (ptr+i-1)^:=0;
 for i:=1 to 65535 do memzero[i]:=0;
 case myplatform of
 0:fileheader.Machine:=pe_image_file_machine_i386;
 1:fileheader.Machine:=pe_image_file_machine_amd64;
 2:fileheader.Machine:=pe_image_file_machine_arm;
 3:fileheader.Machine:=pe_image_file_machine_arm64;
 4:fileheader.Machine:=pe_image_file_machine_loongarch64;
 5:fileheader.Machine:=pe_image_file_machine_riscv64;
 end;
 if(PeRoDataOffset>0) then fileheader.NumberOfSections:=4 else fileheader.NumberOfSections:=3;
 fileheader.Characteristics:=pe_image_file_line_nums_stripped or pe_image_file_local_syms_stripped or
 pe_image_file_debug_stripped or pe_image_file_executable_image;
 if(is64bit) then
  begin
   fileheader.SizeOfOptionalHeader:=sizeof(pe_image_nt_header64);
   ptr:=@optionalheader64;
   for i:=1 to sizeof(optionalheader64) do (ptr+i-1)^:=0;
   optionalheader64.Magic:=pe_image_pe32plus_image_magic;
   if(PeRoDataOffset>0) then
   optionalheader64.SizeOfCode:=peRoDataOffset-peTextOffset
   else
   optionalheader64.SizeOfCode:=peDataOffset-peTextOffset;
   if(PeRoDataOffset>0) then
   optionalheader64.SizeOfInitializedData:=peRelocationOffset-peRoDataOffset
   else
   optionalheader64.SizeOfInitializedData:=peRelocationOffset-peDataOffset;
   optionalheader64.AddressOfEntryPoint:=PeCoffEntry;
   optionalheader64.BaseOfCode:=PeTextOffset;
   optionalheader64.ImageBase:=$00000000;
   optionalheader64.SectionAlignment:=elfmaxalign;
   optionalheader64.FileAlignment:=elfmaxalign;
   optionalheader64.SizeOfImage:=optimize_integer_divide(
   PeRelocationOffset+12+optimize_integer_divide(elfrelasize,24)*2+elfmaxalign-1,elfmaxalign)*elfmaxalign;
   optionalheader64.SizeOfHeaders:=PeTextOffset;
   optionalheader64.Subsystem:=pe_image_subsystem_efi_application;
   optionalheader64.NumberOfRvaandSizes:=16;
   optionalheader64.DataDirectory[6].virtualaddress:=PeRelocationOffset;
   optionalheader64.DataDirectory[6].size:=12+optimize_integer_divide(elfrelasize,24)*2;
   optionalheader64.CheckSum:=0;
  end
 else
  begin
   fileheader.SizeOfOptionalHeader:=sizeof(pe_image_nt_header32);
   ptr:=@optionalheader32;
   for i:=1 to sizeof(optionalheader32) do (ptr+i-1)^:=0;
   optionalheader32.Magic:=pe_image_pe32_image_magic;
   if(PeRoDataOffset>0) then
   optionalheader32.SizeOfCode:=peRoDataOffset-peTextOffset
   else
   optionalheader32.SizeOfCode:=peDataOffset-peTextOffset;
   if(PeRoDataOffset>0) then
   optionalheader32.SizeOfInitializedData:=peRelocationOffset-peRoDataOffset
   else
   optionalheader32.SizeOfInitializedData:=peRelocationOffset-peDataOffset;
   optionalheader32.AddressOfEntryPoint:=PeCoffEntry;
   optionalheader32.BaseOfCode:=PeTextOffset;
   if(PeRoDataOffset>0) then
   optionalheader32.BaseOfData:=peRoDataOffset
   else
   optionalheader32.BaseOfData:=peDataOffset;
   optionalheader32.ImageBase:=$00000000;
   optionalheader32.SectionAlignment:=elfmaxalign;
   optionalheader32.FileAlignment:=elfmaxalign;
   optionalheader32.SizeOfImage:=optimize_integer_divide(
   PeRelocationOffset+12+optimize_integer_divide(elfrelasize,12)*2+elfmaxalign-1,elfmaxalign)*elfmaxalign;
   optionalheader32.SizeOfHeaders:=PeTextOffset;
   optionalheader32.Subsystem:=pe_image_subsystem_efi_application;
   optionalheader32.NumberOfRvaandSizes:=16;
   optionalheader32.DataDirectory[6].virtualaddress:=PeRelocationOffset;
   optionalheader32.DataDirectory[6].size:=12+optimize_integer_divide(elfrelasize,12)*2;
   optionalheader32.Checksum:=0;
  end;
 if(PeRoDataOffset>0) then
 sectionheader:=allocmem(Sizeof(pe_image_section_header)*4)
 else
 sectionheader:=allocmem(Sizeof(pe_image_section_header)*3);
 if(PeRoDataOffset>0) then
  begin
   sectionheader^.Name:='.text';
   sectionheader^.Misc.VirtualSize:=PeRoDataOffset-PeTextOffset;
   sectionheader^.VirtualAddress:=PeTextOffset;
   sectionheader^.SizeOfRawData:=PeRoDataOffset-PeTextOffset;
   sectionheader^.PointerToRawData:=PeTextOffset;
   sectionheader^.Characteristics:=pe_image_scn_cnt_code or pe_image_mem_execute
   or pe_image_mem_read;
   (sectionheader+1)^.Name:='.rdata';
   (sectionheader+1)^.Misc.VirtualSize:=PeDataOffset-PeRoDataOffset;
   (sectionheader+1)^.VirtualAddress:=PeRoDataOffset;
   (sectionheader+1)^.SizeOfRawData:=PeDataOffset-PeRoDataOffset;
   (sectionheader+1)^.PointerToRawData:=PeRoDataOffset;
   (sectionheader+1)^.Characteristics:=pe_image_scn_cnt_initialized_data
   or pe_image_mem_read;
   (sectionheader+2)^.Name:='.data';
   (sectionheader+2)^.Misc.VirtualSize:=PeRelocationOffset-PeDataOffset;
   (sectionheader+2)^.VirtualAddress:=PeDataOffset;
   (sectionheader+2)^.SizeOfRawData:=PeRelocationOffset-PeDataOffset;
   (sectionheader+2)^.PointerToRawData:=PeDataOffset;
   (sectionheader+2)^.Characteristics:=pe_image_scn_cnt_initialized_data
   or pe_image_mem_write or pe_image_mem_read;
   if(is64bit) then
    begin
     (sectionheader+3)^.Name:='.reloc';
     (sectionheader+3)^.Misc.VirtualSize:=12+optimize_integer_divide(elfrelasize,24)*2;
     (sectionheader+3)^.VirtualAddress:=PeRelocationOffset;
     (sectionheader+3)^.SizeOfRawData:=12+optimize_integer_divide(elfrelasize,24)*2;
     (sectionheader+3)^.PointerToRawData:=PeRelocationOffset;
     (sectionheader+3)^.Characteristics:=pe_image_scn_cnt_initialized_data
     or pe_image_mem_read or pe_image_mem_discardable;
    end
   else
    begin
     (sectionheader+3)^.Name:='.reloc';
     (sectionheader+3)^.Misc.VirtualSize:=12+optimize_integer_divide(elfrelasize,12)*2;
     (sectionheader+3)^.VirtualAddress:=PeRelocationOffset;
     (sectionheader+3)^.SizeOfRawData:=12+optimize_integer_divide(elfrelasize,12)*2;
     (sectionheader+3)^.PointerToRawData:=PeRelocationOffset;
     (sectionheader+3)^.Characteristics:=pe_image_scn_cnt_initialized_data
     or pe_image_mem_read or pe_image_mem_discardable;
    end;
  end
 else
  begin
   sectionheader^.Name:='.text';
   sectionheader^.Misc.VirtualSize:=PeDataOffset-PeTextOffset;
   sectionheader^.VirtualAddress:=PeTextOffset;
   sectionheader^.SizeOfRawData:=PeDataOffset-PeTextOffset;
   sectionheader^.PointerToRawData:=PeTextOffset;
   sectionheader^.Characteristics:=pe_image_scn_cnt_code or
   pe_image_mem_execute or pe_image_mem_read;
   (sectionheader+1)^.Name:='.data';
   (sectionheader+1)^.Misc.VirtualSize:=PeRelocationOffset-PeDataOffset;
   (sectionheader+1)^.VirtualAddress:=PeDataOffset;
   (sectionheader+1)^.SizeOfRawData:=PeRelocationOffset-PeDataOffset;
   (sectionheader+1)^.PointerToRawData:=PeDataOffset;
   (sectionheader+1)^.Characteristics:=pe_image_scn_cnt_initialized_data or
   pe_image_mem_write or pe_image_mem_read;
   (sectionheader+2)^.Name:='.reloc';
   if(is64bit) then
    begin
     (sectionheader+2)^.Misc.VirtualSize:=12+optimize_integer_divide(elfrelasize,24)*2;
     (sectionheader+2)^.VirtualAddress:=PeRelocationOffset;
     (sectionheader+2)^.SizeOfRawData:=12+optimize_integer_divide(elfrelasize,24)*2;
     (sectionheader+2)^.PointerToRawData:=PeRelocationOffset;
     (sectionheader+2)^.Characteristics:=pe_image_scn_cnt_initialized_data or
     pe_image_mem_read or pe_image_mem_discardable;
    end
   else
    begin
     (sectionheader+2)^.Misc.VirtualSize:=12+optimize_integer_divide(elfrelasize,12)*2;
     (sectionheader+2)^.VirtualAddress:=PeRelocationOffset;
     (sectionheader+2)^.SizeOfRawData:=12+optimize_integer_divide(elfrelasize,12)*2;
     (sectionheader+2)^.PointerToRawData:=PeRelocationOffset;
     (sectionheader+2)^.Characteristics:=pe_image_scn_cnt_initialized_data or
     pe_image_mem_read or pe_image_mem_discardable;
    end;
  end;
 pelowaddress:=-1;
 if(is64bit) then
  begin
   relocationheader.SizeOfBlock:=12+optimize_integer_divide(elfrelasize,24)*2;
   relocationitemcount:=optimize_integer_divide(elfrelasize,24);
   i:=0;
   while(i<optimize_integer_divide(elfrelasize,24)) do
    begin
     inc(i);
     relocationitem[i].peType:=10;
     if(pelowaddress=-1) then pelowaddress:=Pelf64_rela(elfrelacontent+(i-1)*24)^.rela_offset;
     relocationitem[i].Offset:=Pelf64_rela(elfrelacontent+(i-1)*24)^.rela_offset-pelowaddress;
    end;
   relocationitem[i+1].peType:=0;
   relocationitem[i+2].peType:=0;
   relocationitem[i+1].Offset:=0;
   relocationitem[i+2].Offset:=0;
  end
 else
  begin
   relocationheader.SizeOfBlock:=12+optimize_integer_divide(elfrelasize,12)*2;
   relocationitemcount:=optimize_integer_divide(elfrelasize,12);
   i:=0;
   while(i<optimize_integer_divide(elfrelasize,12)) do
    begin
     inc(i);
     relocationitem[i].peType:=3;
     if(pelowaddress=-1) then pelowaddress:=Pelf32_rela(elfrelacontent+(i-1)*12)^.rela_offset;
     relocationitem[i].Offset:=Pelf32_rela(elfrelacontent+(i-1)*12)^.rela_offset-pelowaddress;
    end;
   relocationitem[i+1].peType:=0;
   relocationitem[i+2].peType:=0;
   relocationitem[i+1].Offset:=0;
   relocationitem[i+2].Offset:=0;
  end;
 if(pelowaddress>-1) then relocationheader.VirtualAddress:=PeBaseAddr+pelowaddress
 else relocationheader.VirtualAddress:=PeTextOffset;
 {Write pe file}
 outputfile:=TFileStream.Create(outfilename,fmCreate);
 writeln('Writing PE file......');
 outputfile.Seek(0,0);
 for i:=1 to optimize_integer_divide(PeRelocationOffset+12+relocationitemcount*2+elfmaxalign-1,elfmaxalign) do
  begin
   outputfile.Write(memzero,elfmaxalign);
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
   outputfile.Seek(PeTextOffset,0);
   for i:=1 to (elfprogramheader64+elfloadindex[1]-1)^.program_memory_size do
    begin
     outputfile.Write(((elfcodeblock+elfloadindex[1]-1)^+i-1)^,1);
    end;
   if(merge) then
    begin
     outputfile.Seek(PeBaseAddr+(elfprogramheader64+mergeindex-1)^.program_virtual_address-elflowaddress,0);
     for i:=1 to (elfprogramheader64+mergeindex-1)^.program_memory_size do
      begin
       outputfile.Write(((elfcodeblock+mergeindex-1)^+i-1)^,1);
      end;
    end;
   if(PeRodataOffset>0) then
    begin
     outputfile.Seek(PeRoDataOffset,0);
     for i:=1 to (elfprogramheader64+elfloadindex[2]-1)^.program_memory_size do
      begin
       outputfile.Write(((elfcodeblock+elfloadindex[2]-1)^+i-1)^,1);
      end;
     outputfile.Seek(PeDataOffset,0);
     for i:=1 to (elfprogramheader64+elfloadindex[3]-1)^.program_memory_size do
      begin
       outputfile.Write(((elfcodeblock+elfloadindex[3]-1)^+i-1)^,1);
      end;
    end
   else
    begin
     outputfile.Seek(PeDataOffset,0);
     for i:=1 to (elfprogramheader64+elfloadindex[2]-1)^.program_memory_size do
      begin
       outputfile.Write(((elfcodeblock+elfloadindex[2]-1)^+i-1)^,1);
      end;
    end;
   outputfile.Seek(PeRelocationOffset,0);
   outputfile.Write(relocationheader,sizeof(relocationheader));
   for i:=1 to relocationitemcount+2 do
    begin
     outputfile.Write(Relocationitem[i],sizeof(pe_image_type_offset));
    end;
   outputfile.Seek(PeBaseAddr+pelowaddress,0);
   for i:=1 to elfrelasize div 24 do
    begin
     elfrela64item:=Pelf64_rela(elfrelacontent+(i-1)*24)^;
     elf64value:=PeBaseAddr+elfrela64item.rela_addend;
     outputfile.Write(elf64value,sizeof(qword));
    end;
   outputfile.Seek(0,0);
   FileBuffer:=allocmem(optionalheader64.SizeOfImage);
   for i:=1 to optionalheader64.SizeOfImage do
    begin
     outputfile.Read((FileBuffer+i-1)^,1);
    end;
   optionalheader64.Checksum:=CalcCheckSum(FileBuffer,optionalheader64.SizeOfImage);
   outputfile.Seek(sizeof(dosheader)+$40+sizeof(signature)+sizeof(fileheader),0);
   outputfile.Write(optionalheader64,sizeof(optionalheader64));
  end
 else
  begin
   outputfile.Seek(PeTextOffset,0);
   for i:=1 to (elfprogramheader32+elfloadindex[1]-1)^.program_memory_size do
    begin
     outputfile.Write(((elfcodeblock+elfloadindex[1]-1)^+i-1)^,1);
    end;
   if(merge) then
    begin
     outputfile.Seek(PeBaseAddr+(elfprogramheader32+mergeindex-1)^.program_virtual_address-elflowaddress,0);
     for i:=1 to (elfprogramheader32+mergeindex-1)^.program_memory_size do
      begin
       outputfile.Write(((elfcodeblock+mergeindex-1)^+i-1)^,1);
      end;
    end;
   if(PeRodataOffset>0) then
    begin
     outputfile.Seek(PeRoDataOffset,0);
     for i:=1 to (elfprogramheader32+elfloadindex[2]-1)^.program_memory_size do
      begin
       outputfile.Write(((elfcodeblock+elfloadindex[2]-1)^+i-1)^,1);
      end;
     outputfile.Seek(PeDataOffset,0);
     for i:=1 to (elfprogramheader32+elfloadindex[3]-1)^.program_memory_size do
      begin
       outputfile.Write(((elfcodeblock+elfloadindex[3]-1)^+i-1)^,1);
      end;
    end
   else
    begin
     outputfile.Seek(PeDataOffset,0);
     for i:=1 to (elfprogramheader32+elfloadindex[2]-1)^.program_memory_size do
      begin
       outputfile.Write(((elfcodeblock+elfloadindex[2]-1)^+i-1)^,1);
      end;
    end;
   outputfile.Seek(PeRelocationOffset,0);
   outputfile.Write(Relocationheader,sizeof(pe_image_base_relocation));
   for i:=1 to relocationitemcount+2 do
    begin
     outputfile.Write(Relocationitem[i],sizeof(pe_image_type_offset));
    end;
   outputfile.Seek(PeBaseAddr+pelowaddress,0);
   for i:=1 to elfrelasize div 12 do
    begin
     elfrela32item:=Pelf32_rela(elfrelacontent+(i-1)*12)^;
     elf32value:=PeBaseAddr+elfrela32item.rela_addend;
     outputfile.Write(elf32value,sizeof(dword));
    end;
   outputfile.Seek(0,0);
   FileBuffer:=allocmem(optionalheader32.SizeOfImage);
   for i:=1 to optionalheader32.SizeOfImage do
    begin
     outputfile.Read((FileBuffer+i-1)^,1);
    end;
   optionalheader32.Checksum:=CalcCheckSum(FileBuffer,optionalheader32.SizeOfImage);
   outputfile.Seek(sizeof(dosheader)+$40+sizeof(signature)+sizeof(fileheader),0);
   outputfile.Write(optionalheader32,sizeof(optionalheader32));
  end;
 {Free the memory requested by program}
 Freemem(filebuffer);
 outputfile.Free;
 freemem(sectionheader);
 Freemem(elfrelacontent);
 if(is64bit) then
  begin
   for i:=elfheader64.elf64_program_header_number downto 1 do FreeMem((elfcodeblock+i-1)^);
   FreeMem(elfcodeblock);
   FreeMem(elfprogramheader64);
  end
 else
  begin
   for i:=elfheader32.elf32_program_header_number downto 1 do FreeMem((elfcodeblock+i-1)^);
   FreeMem(elfcodeblock);
   FreeMem(elfprogramheader32);
  end;
 inputfile.Free;
end.
