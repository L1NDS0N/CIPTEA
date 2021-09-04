unit Utils.ImageFormat;

interface

function ImageFormatFromBuffer(aBuffer: Word): string;

implementation

function ImageFormatFromBuffer(aBuffer: Word): string;
begin
  if aBuffer = $4D42 then //If the first two bytes are 4D42 [low to high]
    begin
      Result := '.BMP';
      //then this is a BMP format file
    end
  else if aBuffer = $D8FF then //if the first two words Section is D8FF [Low to High]
    begin
      //JPEG
      Result := '.JPG';
      //........The same is not commented below
    end
  else if aBuffer = $4947 then
    begin
      //GIF
      Result := '.GIF';
    end
  else if aBuffer = $050A then
    begin
      //PCX
      Result := '.PCX';

    end
  else if aBuffer = $5089 then
    begin
      //PNG
      Result := '.PNG';

    end
  else if aBuffer = $4238 then
    begin
      //PSD
      Result := '.PSD';

    end
  else if aBuffer = $A659 then
    begin
      //RAS
      Result := '.RAS';

    end
  else if aBuffer = $DA01 then
    begin
      //SGI
      Result := '.SGI';

    end
  else if aBuffer = $4949 then
    begin
      //TIFF
      Result := '.TIFF';

    end
  else
    begin
      Result := '';
    end;
end;

end.
