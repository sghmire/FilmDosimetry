function interpolatedMatrix  =  fn_DoseSampling(DoseMatrix, samplingDensity, method )
    DoseMatrix = double(DoseMatrix);
    % Define the desired sampling density increase factor
    samplingDensityIncreaseFactor = samplingDensity; 
    
    % Define the original grid
    [m, n] = size(DoseMatrix);
    [x, y] = meshgrid(1:n, 1:m);
    
    % Define the new grid with increased sampling density
    newGridX = linspace(1, n, samplingDensityIncreaseFactor*n);
    newGridY = linspace(1, m, samplingDensityIncreaseFactor*m);
    [newX, newY] = meshgrid(newGridX, newGridY);
    
    % Interpolate the original matrix onto the new grid
    interpolatedMatrix = interp2(x, y, DoseMatrix, newX, newY, method);                        
end