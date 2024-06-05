function fn_LineMaker(Image, Point1, Point2, UIAxes)
        
        Point3 = Point1;
        Point4 = Point2;
        
        [height, width] = size(Image);
        
        % Calculate slope
        slope = (Point4(2) - Point3(2)) / (Point4(1) - Point3(1));
        a = [];
        b =[];
        
        % Extend to top edge
        for i = 1:width
            y_top = 1;
            x_top = i;
            slope_top = (Point4(2) - y_top) / (Point4(1) - x_top);
            if abs(slope_top - slope) < 0.01
                a = [y_top, x_top];
                break; % Exit the loop once you find the point
            end
        end
        
        % Extend to bottom edge
        for i = 1:width
            y_bottom = height;
            x_bottom = i;
            slope_bottom = (Point3(2) - y_bottom) / (Point3(1) - x_bottom);
            if abs(slope_bottom - slope) < 0.01
                b = [y_bottom, x_bottom];
                break; % Exit the loop once you find the point
            end
        end
        
        if isempty(a) | isempty(b)
                
            % Extend to left edge
            for i = 1:height
                x_left = 1;
                y_left = i;
                slope_left = (Point4(2) - y_left) / (Point4(1) - x_left);
                if abs(slope_left - slope) < 0.01
                    a = [y_left, x_left];
                    break; % Exit the loop once you find the point
                end
            end
            
            
            % Extend to right edge
            for i = 1:height
                x_right = width;
                y_right = i;
                slope_right = (Point3(2) - y_right) / (Point3(1) - x_right);
                if abs(slope_right - slope) < 0.01
                    b = [y_right, x_right];
                    break; % Exit the loop once you find the point
                end
            end
        end

        plot(UIAxes, [a(2), b(2)], [a(1), b(1)], 'r'); % Extended line to top in blue        
end

