function AlignedImage = fn_AutoImageAlign(TIFFFilm)
    
    Main_image1 = mat2gray(im2gray(TIFFFilm));    
     
    % Extract a region of interest from the center of the image
    [ro , ~] = size(Main_image1) ;
    
    OG_image = Main_image1(ro * 0.5 - (0.25 * ro) + 1: ro * 0.5 + (0.25 * ro), :);
    
    % Find minimum values along the rows
    minValues1 = min(OG_image);
    [~, m_col] = size(minValues1);
    
    % Split the minimum values into two halves
    minValues11 = minValues1(:, 1:m_col/2);
    minValues22 = minValues1(:, m_col/2+1:end);
    
    minValues11 = min(minValues11(:));
    minValues22 = min(minValues22(:));
    
    % Find indices of minimum values in the original image
    [min1_rows1, min1_cols1] = find(OG_image == minValues11);
    [min2_rows1, min2_cols1] = find(OG_image == minValues22);    
    

    % Calculate slope between points specified by min1 and min2
    delta_y = mean(min2_rows1) - mean(min1_rows1);
    delta_x = mean(min2_cols1) - mean(min1_cols1);

    slope = delta_y / delta_x;               

    if slope ~= inf
        AlignedImage  = imrotate(TIFFFilm, slope *180/pi);
    else
        msgbox("No peaks found in the image!");
        return;
    end

end


