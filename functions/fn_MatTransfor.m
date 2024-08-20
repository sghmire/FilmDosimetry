function tMatrix = fn_MatTransfor(iMatrix, SelectedPoint)
    [rows, cols, channels] = size(iMatrix);
    
    % Calculate the current center of the image
    ImageCenter = [cols / 2, rows / 2];
    
    % Calculate the translation vector to move the image center to the selected point
    Translation = ( ImageCenter -SelectedPoint );
    
    % Create a 2-D rigid transformation object with translation only
    tform = rigidtform2d(eye(2), Translation);
    
    % Define the output view with centered bounds
    followOutput = affineOutputView([rows, cols], tform, "BoundsStyle", "CenterOutput");
    
    % Initialize the transformed matrix
    tMatrix = zeros(size(iMatrix), 'like', iMatrix);
    
    % Apply the transformation to each channel individually
    for ch = 1:channels
        tMatrix(:, :, ch) = imwarp(iMatrix(:, :, ch), tform, "OutputView", followOutput);
    end
end
