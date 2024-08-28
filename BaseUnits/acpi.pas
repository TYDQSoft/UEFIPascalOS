unit acpi;

interface
type acpi_guid=packed record
               data1:dword;
               data2:word;
               data3:word;
               data4:word;
               data5:array[1..6] of byte;
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
               end;
implementation

function acpi_guid_match(guid1,guid2:acpi_guid):boolean;[public,alias:'ACPI_GUID_MATCH'];
var res:boolean;
    i:byte;
begin
 res:=true;
 if(guid1.data1<>guid2.data1) then exit(false);
 if(guid1.data2<>guid2.data2) then exit(false);
 if(guid1.data3<>guid2.data3) then exit(false);
 if(guid1.data4<>guid2.data4) then exit(false);
 for i:=1 to 6 do if(guid1.data5[i]<>guid2.data5[i]) then exit(false);
 acpi_guid_match:=res;
end;
function acpi_check_rsdp_signature(rsdp:acpi_rsdp):boolean;[public,alias:'ACPI_CHECK_RSDP_SIGNATURE'];
begin
end;

end.
