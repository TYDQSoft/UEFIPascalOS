unit device;

interface

type device_info=packed record
                 deviceclass:word;
                 devicetype:word;
                 devicemanufacturers:dword;
                 end;
     device_io_info=packed record 
                    ismmio:boolean;
                    case Boolean of 
                    True:(ioport:word);
                    False:(ioaddress:Pointer);
                    end;
     device_object=packed record
                   {Stores device information}
                   info:device_info;
                   {Stores device I/O information}
                   io:^device_io_info;
                   iocount:byte;
                   end;

implementation

end.
