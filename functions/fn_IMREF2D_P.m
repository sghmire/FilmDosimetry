function fn_IMREF2D_P(Image, PixelSpacingX, PixelSpacingY, Figure, ColorMap)
    [height, width]  = size(Image);
    half_size_X = width * 0.5 * PixelSpacingX;
    half_size_Y = height * 0.5 * PixelSpacingY;
    RI = imref2d(size(Image));
    RI.XWorldLimits = [-half_size_X half_size_X];
    RI.YWorldLimits = [-half_size_Y half_size_Y];

    imshow(mat2gray(Image), RI, 'Parent', Figure);
    colormap(Figure, ColorMap);
end

    
