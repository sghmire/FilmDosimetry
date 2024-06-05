function [distance,Final_X, left, right]  = fn_FWHMCalc(Profile, Type, Threshold)

        Low_TH = 1 - Threshold;
        Up_TH = 1 + Threshold;
        % Finding the maximum value from the curve
        X_max = max(Profile(:, 2)); % Assuming the second column holds the values
        
        % Define the limits for X_max and Y_max
        X_max_Limit = [Low_TH * X_max, Up_TH * X_max];
        
        % Initialize arrays to store filtered values
        Xi = [];
        X_values = [];
        
        for i = 1:size(Profile, 1)
            if Profile(i, 2) > X_max_Limit(1) && Profile(i, 2) < X_max_Limit(2)
                Xi = [Xi ; Profile(i, 1)];
                X_values = [X_values; Profile(i, 2)];
            end
        end
        Final_X = [Xi, X_values];
        if strcmp(Type, 'Mean')           
            mean_x = mean(Final_X(:,2)) * 0.5;
        elseif strcmp(Type, 'Median')
            mean_x = median(Final_X(:,2)) * 0.5;
        elseif strcmp(Type, 'Maximum')
            mean_x = max(Final_X(:,2)) * 0.5;
        end
        
        % Split X_Profile into left and right profiles
        splitIndex = round(size(Profile, 1) / 2);
        Profile_Left = Profile(1:splitIndex, :);
        Profile_Right = Profile(splitIndex+1:end, :);
        
        % Find the index of the closest value in the left profile
        [Left_value, left_idx] = min(abs(Profile_Left(:,2) - mean_x));
        left = [Left_value, left_idx] ;
        left_distance = Profile_Left(left_idx, 1);
        
        % Find the index of the closest value in the right profile
        [Right_value, right_idx] = min(abs(Profile_Right(:,2) - mean_x));
        right = [Right_value, right_idx] ;
        right_distance = Profile_Right(right_idx, 1);
        
        distance = (abs(left_distance) + abs(right_distance) )* 10;
end

