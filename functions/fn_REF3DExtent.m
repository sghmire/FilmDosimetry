function [X_extent, Y_extent, Z_extent] = fn_REF3DExtent(DCM_VOL, IPP,IO, PixelSpacing)
    DCM_VOL = squeeze(DCM_VOL);
    % Define the voxel size
    voxelsize = PixelSpacing;

    % Extract orientation information
    imageOrientation = IO';
    imagePosition = IPP;

    % Create a coordinate transformation matrix (handles most orientations)
    orientationMatrix = [imageOrientation(1:3); imageOrientation(4:6); 0 0 1];


    % Create the reference object 
    refVol = imref3d(size(DCM_VOL), voxelsize(1), voxelsize(2), voxelsize(1));

    % Apply orientation and adjust for position
    worldLimits = orientationMatrix * [refVol.XWorldLimits; refVol.YWorldLimits; refVol.ZWorldLimits];

    worldLimits = worldLimits(1:3,:) + imagePosition;

    % Assign outputs 
    X_extent = worldLimits(1,:);
    Y_extent = worldLimits(2,:);
    Z_extent = worldLimits(3,:);
    
end
