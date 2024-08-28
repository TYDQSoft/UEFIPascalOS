unit storage;

interface

type fat32_header=packed record
                  JumpOrder:array[1..3] of byte;
                  OemCode:array[1..8] of char;
                  BytesPerSector:word;
                  SectorPerCluster:byte;
                  ReservedSectorCount:word;
                  NumFATs:byte;
                  RootEntryCount:word;
                  TotalSector16:word;
                  Media:byte;
                  FATSectors16:word;
                  SectorPerTrack:word;
                  NumHeads:word;
                  HiddenSectors:dword;
                  TotalSectors32:dword;
                  FATSector32:dword;
                  ExtendedFlags:word;
                  FileSystemVersion:word;
                  RootCluster:dword;
                  FileSystemInfo:word;
                  BootSector:word;
                  Reserved:array[1..12] of byte;
                  DriverNumber:byte;
                  Reserved1:byte;
                  BootSignature:byte;
                  VolumeID:dword;
                  VolumeLabel:array[1..11] of char;
                  FileSystemType:array[1..8] of char;
                  Reserved2:array[1..420] of byte;
                  SignatureWord:word;
                  Reserved3:array[1..65023] of byte;
                  end;
     fat32_file_system_info=packed record
                            FSI_leadSig:dword;
                            FSI_Reserved1:array[1..480] of byte;
                            FSI_StrucSig:dword;
                            FSI_FreeCount:dword;
                            FSI_NextFree:dword;
                            FSI_Reserved2:array[1..12] of byte;
                            FSI_TrailSig:dword;
                            FSI_Reserved3:array[1..65023] of byte;
                            end;

implementation

end.
