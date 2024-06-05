function new_volume = fn_VolumeInterp(info, type, grid)

    X = double(info.Columns);
    Y = double(info.Rows);
    Z = double(info.NumberOfFrames);
    Volume = double(squeeze(dicomread(info)));
    
    
    % Define finer grid size
    finer_grid_size = grid; % You can adjust this value according to your requirement
    
    % Define new dimensions
    new_X = X * finer_grid_size;
    new_Y = Y * finer_grid_size;
    new_Z = Z * finer_grid_size;
    
    % Create new grid coordinates
    [x, y, z] = meshgrid(1:X, 1:Y, 1:Z);
    [new_x, new_y, new_z] = meshgrid(linspace(1, X, new_X), linspace(1, Y, new_Y), linspace(1, Z, new_Z));
    
    % Interpolate the volume data
    new_volume = interp3(x, y, z, Volume, new_x, new_y, new_z, type);

end
