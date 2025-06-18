unit objpas;

interface 

{$MODE ObjFPC}{$H+}

{Header for objpas.pas,or the compliation will fail.}
type class_header=packed record 
                  ReferenceCount:Natint;
                  ClassSize:Natint;
                  end;
{End objpas.pas Headers}

implementation

end.
