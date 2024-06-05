function Pairs = fn_intersectFinder(Peaks,Film,  UIAxes) 
    Peaks = Peaks';
    Num_rows = size(Peaks, 1);    
    middle_row = ceil(Num_rows / 2);

    if mod(Num_rows, 2) == 0   
        middle_row = middle_row + 1;
        Peaks(middle_row-1, :) = [];
    end
   
    cla(UIAxes);
    imshow(Film, 'Parent', UIAxes);
    colormap(UIAxes, "jet");
    hold(UIAxes, 'on');            
    plot( UIAxes, Peaks(:,1), Peaks(:, 2),  'o', 'MarkerEdgeColor','y', 'MarkerSize', 4, 'MarkerFaceColor','y'); 
    hold(UIAxes, 'on');  
    
    half_Num_peaks =  middle_row - 1;
    Pairs = zeros(half_Num_peaks, 2);
    P1 = Peaks(1, :);               
    P2 = Peaks(middle_row, :);   
    
    for i = 1:half_Num_peaks
        P3 = Peaks(i + 1, :);                 
        P4 = Peaks(middle_row + i, :);        
        [intersX, intersY] = PointofInter(P1, P2, P3, P4);
        Pairs(i, :) = [intersX, intersY];
    end

    for i = size(Peaks, 1)
        sz = size(Peaks,1);
        x1 = Peaks(i, 1); y1 = Peaks(i, 2);
        x2 = Peaks(sz/2+1, 1);  y2 = Peaks(sz/2+1,2 );
        line(UIAxes, [x1, y1], [x2, y2]);
        hold(UIAxes, 'on');
    end


    for i = 1:size(Pairs, 1)
        plot(UIAxes, Pairs(i, 1), Pairs(i, 2), 'o', 'MarkerEdgeColor', 'y', 'MarkerSize', 4, 'MarkerFaceColor', 'r');
        hold(UIAxes, 'on');
    end
    hold(UIAxes, 'off');

end

function [x_intersect, y_intersect] = PointofInter(P1, P2, P3, P4)
    % Extract coordinates of the points
    x1 = P1(1); y1 = P1(2);
    x2 = P2(1); y2 = P2(2);
    x3 = P3(1); y3 = P3(2);
    x4 = P4(1); y4 = P4(2);
    
    % Calculate slopes
    m1 = (y2 - y1) / (x2 - x1);
    m2 = (y4 - y3) / (x4 - x3);
    
    % Check for parallel lines
    if abs(m1 - m2) < eps % Lines are parallel
        x_intersect = NaN;
        y_intersect = NaN;
        return;
    end
    
    % Calculate y-intercepts 
    b1 = y1 - m1 * x1;
    b2 = y3 - m2 * x3;
    
    % Get intersection point
    x_intersect = (b2 - b1) / (m1 - m2);
    y_intersect = m1 * x_intersect + b1;
end
