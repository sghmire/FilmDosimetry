function rotateVolume= fn_DicomVRotate_Adv(RTDose, RotationCenter, Angle, NewCenter)
    Volume = squeeze(RTDose);    

    % 1. Translate to New Center
    translateToCenter = [1 0 0 -NewCenter(1);  
                         0 1 0  -NewCenter(2);
                         0 0 1 -NewCenter(3);
                         0 0 0 1];

    % 2. Rotations
    rotationMatrix = getRotationMatrix(RotationCenter, Angle); 

    % 3. Translate back to original center
    translateBack = [1 0 0 NewCenter(1);  
                     0 1 0 NewCenter(2);
                     0 0 1 NewCenter(3);
                     0 0 0 1];

    % Combine transformations (order is crucial) 
    combinedMatrix = translateBack * rotationMatrix * translateToCenter;

    % Apply combined transformation
    transform = affinetform3d(combinedMatrix); 
    centerOutput = affineOutputView(size(Volume),transform,"BoundsStyle","sameAsInput");
    rotateVolume = imwarp(Volume, transform, "cubic", "OutputView", centerOutput);

end


function R = getRotationMatrix(axis, angle)
    angle = deg2rad(angle); % Convert degrees to radians
    c = cos(angle);
    s = sin(angle);

    switch axis
        case 'Pitch' 
            R = [1 0 0 0;
                 0 c -s 0;
                 0 s c 0;
                 0 0 0 1];
            

        case 'Yaw'
            R = [c 0 s 0;
                 0 1 0 0;
                -s 0 c 0;
                 0 0 0 1];

        case 'Roll'
            R = [c -s 0 0;
                 s c 0 0;
                 0 0 1 0;
                 0 0 0 1];
    end
end

