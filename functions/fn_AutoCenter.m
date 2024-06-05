function AlignedImage = fn_AutoCenter(TIFFFilm)
    % Rotate the image
    Main_image = mat2gray(rgb2gray(TIFFFilm));
    
    % Extract a region of interest from the center of the image
    [ro, col] = size(Main_image);
    MidIndex = Main_image(:, round(col * 0.5 - 0.25 * col) + 1 : round(col * 0.5 + 0.25 * col));
        
    % Find Midpoint in the Main Image
    [~, minIndex] = min(MidIndex(:));
    [minRow_ROI, minCol_ROI] = ind2sub(size(MidIndex), minIndex);
    global_min_col_ROI = round(col * 0.5 - 0.25 * col) + minCol_ROI;     % Convert column index to global coordinate
    minRow_Main = minRow_ROI;      % Find corresponding position in the main image
    minCol_Main = global_min_col_ROI;
    Middle_point = [minRow_Main, minCol_Main];
    

    %Find the two index on the film side
    LeftRightIndex = Main_image(round(ro * 0.5) - round(0.25 * ro) + 1: round(ro * 0.5) + round(0.25 * ro), :);
    % Find minimum values along the rows
    minValues = min(LeftRightIndex);
    [~, m_col] = size(minValues);
    
    % Split the minimum values into two halves
    minValues1 = minValues(:, 1:m_col/2);
    minValues2 = minValues(:, m_col/2+1:end);
    
    minValues1 = min(minValues1(:));
    minValues2 = min(minValues2(:));
    
    % Find indices of minimum values in the original image
    [min1_rows, min1_cols] = find(LeftRightIndex == minValues1);
    [min2_rows, min2_cols] = find(LeftRightIndex == minValues2);    

    First_point = [min1_rows + round(ro * 0.5 - (0.25 * ro)), min1_cols];
    Second_point = [min2_rows + round(ro * 0.5 - (0.25 * ro)), min2_cols];

    % Calculate center point
    center_point = [ First_point(1), Middle_point(2)];
    
    % Calculate translation vector to move the center to the desired location
    translation_vector = [size(TIFFFilm, 2)/2 - center_point(2), size(TIFFFilm, 1)/2 - center_point(1)];
    
    % Translate the rotated image
    Translated_image = imtranslate(TIFFFilm, translation_vector, 'OutputView','full');    

        % Display the points on the image
    imshow(Main_image);
    hold on;
    plot(Middle_point(2), Middle_point(1), 'ro', 'MarkerSize', 10); % Middle point
    plot(First_point(2), First_point(1), 'gx', 'MarkerSize', 10); % First point(s)
    plot(Second_point(2), Second_point(1), 'bx', 'MarkerSize', 10); % Second point(s)
    plot(center_point(2), center_point(1), 'yo', 'MarkerSize', 10); % Center point
    hold off;

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
        AlignedImage  = imrotate( Translated_image , slope *180/pi);
    else
        msgbox("No peaks found in the image!");
        return;
    end

    

end
