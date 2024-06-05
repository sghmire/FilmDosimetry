function Center = fn_VolumeCenterCalc(RTDose)

    % Load the DICOM volume
    DCM_Info = dicominfo(RTDose);
    DCM_vol = squeeze(dicomread(DCM_Info));
    
    threshold = 0.5;  % Example threshold
    BW_vol = DCM_vol > threshold;
    
    % --- Step 2: Connected components ---
    CC = bwconncomp(BW_vol);
    numObjects = CC.NumObjects;
    
    % Assuming the first object is the largest
    mainObjectPixels = CC.PixelIdxList{1}; 
    
    % --- Step 3: Centroid calculation ---
    stats = regionprops3(CC, 'Centroid'); 
    Center = stats.Centroid; 

end
