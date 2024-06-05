function [Fixed_Data, Old_data] = fn_ResolutionFixer(DPI, TPSData,FilmData, Pixel_spacing) 

    
    [Film_row, Film_col] = size(FilmData);
    [TPS_row, TPS_col] = size(TPSData);

        %Calculting the DPI of the film dose        
    Film_x_cm = Film_row * 2.54 / DPI;
    Film_y_cm = Film_col * 2.54 / DPI;

    
    TPS_x_cm = TPS_col * Pixel_spacing(1) * 0.1;                  
    TPS_y_cm = TPS_row * Pixel_spacing(2) * 0.1;
    
    Film_pixel_x = Film_x_cm / Film_row;
    Film_pixel_y = Film_y_cm / Film_col;

    TPS_pixel_x = TPS_x_cm / TPS_col;
    TPS_pixel_y = TPS_y_cm / TPS_row;

    if Film_row < TPS_row || Film_col < TPS_col   
    
        % Calculate scaling factors for each axis
        scaling_factor_x = Film_pixel_x / TPS_pixel_x;
        scaling_factor_y = Film_pixel_y / TPS_pixel_y;
        
        % Resize TPS matrix for each axis separately
        % Calculate new size based on separate scaling factors
        new_rows = round(size(FilmData, 1) * scaling_factor_y);
        new_cols = round(size(FilmData, 2) * scaling_factor_x);
        resized_Film_dose = imresize(FilmData, [new_rows, new_cols]);
        
        
        % Update the Film_dose in the app with the padded matrix
        Fixed_Data = double(resized_Film_dose);
        Old_data = double(TPSData);

    else
        % Calculate scaling factors for each axis
        scaling_factor_x = TPS_pixel_x /Film_pixel_x ;
        scaling_factor_y = TPS_pixel_y / Film_pixel_y ;
        
        % Resize TPS matrix for each axis separately
        % Calculate new size based on separate scaling factors
        new_rows = round(size(TPSData, 1) * scaling_factor_y);
        new_cols = round(size(TPSData, 2) * scaling_factor_x);
        resized_TPS_dose = imresize(TPSData, [new_rows, new_cols]);        
        
        % Update the Film_dose in the app with the padded matrix
        Fixed_Data = double(resized_TPS_dose);
        Old_data = double(FilmData);
    end
        
end
