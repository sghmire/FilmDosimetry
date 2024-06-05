%This function rotates the DICOM volume using coordinates from Eclipse
%Treatement Planning System. The volume is first tranlated to the new
%volume center using the Eclipse coordinates and then rotated around the
%desired axis by angle, and then translated back to its original center.

function rotateVOlume=  fn_DicomVRotate_Simple(RTDose, RotationCenter,Angle, NewCenter )     

        Volume = squeeze(RTDose);
        [Y_row, X_columns, Z_frames] = size(Volume);
        OldCenter = [Y_row, X_columns, Z_frames] .* 1/2;
        NewCenter1 =  OldCenter - NewCenter ;
                
        rotateVOlume = imtranslate(Volume, NewCenter1, 'OutputView','same');

        if strcmp(RotationCenter, 'Pitch')
            rotateVOlume = imrotate3(rotateVOlume, Angle, [1, 0, 0], "crop");
        end
        if strcmp(RotationCenter, 'Yaw')
            rotateVOlume = imrotate3(rotateVOlume, Angle, [0, 1, 0], "crop");
        end
        if strcmp(RotationCenter, 'Roll')
            rotateVOlume = imrotate3(rotateVOlume, Angle, [0, 0, 1], "crop");
        end

        rotateVOlume = imtranslate(rotateVOlume, -NewCenter1);  

         % Crop the volume to match the original size
        rotateVOlume = rotateVOlume(1:Y_row, 1:X_columns, 1:Z_frames);
end