function [degrees, vertical_distance] = fn_synchronicity(img, cutoff, angle_baseline, pixel_size)
   
    cheese_diameter = 300;
    pixel_size = 25.4 / pixel_size;
    
    if size(img, 1) < size(img, 2)
        img = img';
    end
        
    img = img ./ max(img(:));
    img = imadjust(img, [min(img(:)) 1.0]);
    img = imadjust(img, [0.1 1.0]);
    img = img(cutoff+1:end-cutoff,cutoff+1:end-cutoff);% to crop the white backgroud (by Chenyang 04/28/2023)
    
    [peaks, locs] = findpeaks(imhist(img, 100));
    [max1, loc1] = max(peaks);
    [~, loc2] = max(peaks(peaks < max1));
    binary_threshold = (locs(loc1) + locs(loc2)) / 2 / 100;
    
    b = img < binary_threshold;
    b = imfill(b, 'holes');
    b = bwareaopen(b, 10000);
    stats = regionprops(b, 'Centroid', 'Area');
    pts = sortrows(reshape([stats.Centroid], [2 15])', 1);
    pts = sortrows(pts,1);% to sort the points (by Chenyang 04/28/2023)
    pts = [sortrows(pts(1:5, :), 2); sortrows(pts(6:10, :), 2); sortrows(pts(11:15, :), 2)];
    d = pixel_size * pdist2(pts, pts);
    
    horizontal_distance = [d(1, 2) d(2, 3) d(3, 4) d(4, 5); d(6, 7) d(7, 8) d(8, 9) d(9, 10); d(11, 12) d(12, 13) d(13, 14) d(14, 15)];
    degrees = 360 * horizontal_distance / (pi * cheese_diameter);
    vertical_distance = [d(1, 6) d(2, 7) d(3, 8) d(4, 9) d(5, 10); d(6, 11) d(7, 12) d(8, 13) d(9, 14) d(10, 15)];
    
    % format compact
    % disp(' ');
    % disp(fn);
    % disp('Horizontal distance between adjacent squares [mm]'); 
    % disp(horizontal_distance);
    % max_error_1 = max(abs(horizontal_distance(:) - dist_baseline));
    % if max_error_1 > 0.5
    %     disp(abs(horizontal_distance - dist_baseline) <= 0.5);
    %     fprintf('   %s Max error: %.4f\n\n', char(10006), max_error_1);
    % else
    %     fprintf('   %s Max error: %.4f\n\n', char(10004), max_error_1);
    % end
    
    disp('Angle formed by two radii to horizontally adjacent squares [degree]'); 
    disp(degrees);
    max_error_2 = max(abs(degrees(:) - angle_baseline));
    if max_error_2 > 0.5
        disp(abs(degrees - angle_baseline) <= 0.5);
        fprintf('   %s Max error: %.4f\n', char(10006), max_error_2);
    else
        fprintf('   %s Max error: %.4f\n', char(10004), max_error_2);
    end
    disp('Vertical distance between adjacent squares [mm]');
    disp(vertical_distance);
    max_error_3 = max(abs(vertical_distance(:) - 42));
    if max_error_3 > 0.5
        disp(abs(vertical_distance - 42) <= 0.5);
        fprintf('   %s Max error: %.4f\n', char(10006), max_error_3);
    else
        fprintf('   %s Max error: %.4f\n', char(10004), max_error_3);
    end
    

    figure;
    imshow(img', []);
    daspect([1 1 1]);
    hold('on');
    plot( ...
        pts(1:2, 2), pts(1:2, 1), ...
        pts(2:3, 2), pts(2:3, 1), ...
        pts(3:4, 2), pts(3:4, 1), ...
        pts(4:5, 2), pts(4:5, 1), ...
        pts(6:7, 2), pts(6:7, 1), ...
        pts(7:8, 2), pts(7:8, 1), ...
        pts(8:9, 2), pts(8:9, 1), ...
        pts(9:10, 2), pts(9:10, 1), ...
        pts(11:12, 2), pts(11:12, 1), ...
        pts(12:13, 2), pts(12:13, 1), ...
        pts(13:14, 2), pts(13:14, 1), ...
        pts(14:15, 2), pts(14:15, 1), ...
        pts([1 6], 2), pts([1 6], 1), ...
        pts([2 7], 2), pts([2 7], 1), ...
        pts([3 8], 2), pts([3 8], 1), ...
        pts([4 9], 2), pts([4 9], 1), ...
        pts([5 10], 2), pts([5 10], 1), ...
        pts([6 11], 2), pts([6 11], 1), ...
        pts([7 12], 2), pts([7 12], 1), ...
        pts([8 13], 2), pts([8 13], 1), ...
        pts([9 14], 2), pts([9 14], 1), ...
        pts([10 15], 2), pts([10 15], 1), 'color', 'red');
    hold('off');
end

