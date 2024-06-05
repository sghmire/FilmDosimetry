% Simple Gamma Analysis by SG
% refPlane: Dicom 2D dose plane
% measPlane: Film 2D dose plane

function [gammaImg, passingRate] = fn_SimpleGammaIndex(refPlane, measPlane, Type, GammaType, windowSize, DTA, DD, PixelSize, percentageValue)

    [r_ref, c_ref] = size(refPlane);
    [r_meas, c_meas] = size(measPlane);

    %checking ref and meas plane size so that processing is done only on the measured
    %sized plane
    if (r_meas < r_ref) & (c_meas < c_ref)
      target_size = [r_meas, c_meas];
      win1 = centerCropWindow2d([r_ref, c_ref], target_size);
      refPlane = imcrop(refPlane, win1);
      [rows, cols] = size(refPlane);
    else
      target_size = [r_ref, c_ref];
      win1 = centerCropWindow2d([r_meas, c_meas], target_size);
      measPlane = imcrop(measPlane, win1);
      [rows, cols] = size(measPlane);
    end

    %Initile the gamma map
    gammaImg = zeros(rows, cols);
    
    passingCount = 0;   

    maxRefPlane = max(refPlane(:));

    % Remove the irrelevant signal
    perSignal = maxRefPlane * percentageValue * 1/100;
    refPlane(abs(refPlane) <= perSignal) = 0;
    measPlane(abs(measPlane) <= perSignal) = 0;
 

    if strcmp(Type, "Relative")
        % Normalize the ref and meas plan to [ 0, 100]
        refPlane = 1 + 99 * (refPlane - min(refPlane(:))) / (max(refPlane(:)) - min(refPlane(:)));
        measPlane = 1 + 99 * (measPlane - min(measPlane(:))) / (max(measPlane(:)) - min(measPlane(:)));
    end

    for i = 1 + windowSize: rows - windowSize
        for j = 1 + windowSize : cols - windowSize
            % Initialize gamma to a large value
            min_gamma = inf;
    
            % Calculate window size in pixels based on physical dimensions
            refWindow = refPlane(i - windowSize : i + windowSize, j - windowSize : j + windowSize);            
            measWindow = measPlane(i - windowSize : i + windowSize, j - windowSize : j + windowSize);
    
            % Calculate gamma for each pixel in the window
            for m = 1 : windowSize
                for n = 1 : windowSize
                    delta_distance = sqrt((m - (windowSize + 1) * PixelSize * 1/ 2) ^2 + (n - (windowSize + 1) *PixelSize * 1/ 2) ^2); %Unit correction for distance
    
                    if strcmp(GammaType, 'Global')
                        delta_dose = abs(measWindow(m, n) - refWindow(m, n)) * 100 ./ maxRefPlane; % Unit correction for percentages
                    else
                        delta_dose = abs(measWindow(m, n) - refWindow(m, n)) * 100 ./ refWindow(m, n); %Unit correction for percentages
                    end

                   gamma = sqrt((delta_distance / DTA)^2 + (delta_dose/ DD )^2);  

                    % Update min_gamma if the current gamma is smaller
                    min_gamma = min(min_gamma, gamma);
                end
            end
            
            % Assign the minimum gamma to the current pixel location
            gammaImg(i, j) = min_gamma;
    
            % Update passing count based on the minimum gamma value
            if min_gamma <= 1
                passingCount = passingCount + 1;
                gammaImg(i, j) =min_gamma - (0.15 * min_gamma);
            end
        end
    end
    
    totalEvaluatedPixels = (rows - 2 * windowSize) * (cols - 2 * windowSize);
    passingRate = passingCount * 100/ totalEvaluatedPixels; 
end
