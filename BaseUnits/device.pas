unit device;

interface

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
                   name:PWideChar;
                   {Stores device information}
                   info:device_info;
                   {Stores device I/O information}
                   io:^device_io_info;
                   iocount:byte;
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
procedure device_list_add_item(var list:device_object_list;item:device_object);
procedure device_list_delete_item(var list:device_object_list;position:natuint);
procedure device_list_delete_item_with_index(var list:device_object_list;index:natuint);
procedure device_list_free(var list:device_object_list);
function device_get_device_index(info:device_info):Natuint;

implementation

function device_list_initialize:device_object_list;[public,alias:'device_list_initialize'];
var res:device_object_list;
begin
 res.item:=nil; res.count:=0; res.maxindex:=0;
 device_list_initialize:=res;
end;
function device_list_construct_device_object(devclass:byte;devsubclass:byte;devpi:byte;
devmanufactureId:word;devuniqueid:word;iolist:Pdevice_io_info;iocount:byte):device_object;[public,alias:'device_list_construct_device_object'];
var res:device_object;
begin
 res.info.deviceclass:=devclass;
 res.info.devicetype:=devsubclass;
 res.info.devicepi:=devpi;
 res.info.devicemanufacturerId:=devmanufactureId;
 res.info.deviceuniqueid:=devuniqueid;
 if(device_get_device_index(res.info)>0) then 
 res.name:=Wstrcreate('Recognized Device') 
 else 
 res.name:=WStrCreate('Unrecognized Device');
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
   list.item^.name:=allocmem(Wstrlen(item.name)*sizeof(WideChar)+sizeof(WideChar));
   Move(item.name^,list.item^.name^,Wstrlen(item.name)*sizeof(WideChar)+sizeof(WideChar));
   list.item^.info:=item.info;
   list.item^.index:=i;
   list.item^.io:=allocmem(item.iocount*sizeof(device_io_info));
   Move(item.io^,list.item^.io^,sizeof(device_io_info)*item.iocount);
   list.item^.iocount:=item.iocount;
  end
 else
  begin
   inc(list.count);
   ReallocMem(list.item,sizeof(device_object)*list.count);
   (list.item+list.count-1)^.name:=allocmem(Wstrlen(item.name)*sizeof(WideChar)+sizeof(WideChar));
   Move(item.name^,(list.item+list.count-1)^.name^,Wstrlen(item.name)*sizeof(WideChar)+sizeof(WideChar));
   (list.item+list.count-1)^.info:=item.info;
   (list.item+list.count-1)^.index:=i;
   (list.item+list.count-1)^.io:=allocmem(item.iocount*sizeof(device_io_info));
   Move(item.io^,(list.item+list.count-1)^.io^,sizeof(device_io_info)*item.iocount);
   (list.item+list.count-1)^.iocount:=item.iocount;
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
 FreeMem(item.name); FreeMem(item.io);
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
   Wstrfree(item.name); FreeMem(item.io);
   inc(i);
  end;
 FreeMem(list.item); list.maxindex:=0; list.count:=0;
end;
function device_get_device_index(info:device_info):Natuint;[public,alias:'device_get_device_index'];
begin
 device_get_device_index:=0;
end;

end.
