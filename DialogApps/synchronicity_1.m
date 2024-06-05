clc; 
clearvars;

Image = imread("Dec_Synchronicity_300DPI.tif");
Image_red = double(Image(:, :, 1));
Image_green = double(Image(:, :, 2));
Image_blue = double(Image(:, :, 3));

% Blue correction over Red and Green channel

Image_red_norm = -log10(Image_red ./ 65535);
Image_green_norm = -log10(Image_green ./ 65535);
Image_blue_norm = -log10(Image_blue ./ 65535);

Image_red = mat2gray(Image_red);

figure;
imshow(Image_red);

rec = drawrectangle;
X1 = round(rec.Position(1));
Y1 = round(rec.Position(2));
width = round(rec.Position(3));
height = round(rec.Position(4));
Image_red_binary = imcrop(Image_red, [X1, Y1, width, height]);

threshold = 0.95;
for i = 1 : size(Image_red_binary, 1)
    Profile = Image_red_binary(i, :);
    if max(Profile(:)) > threshold
        plot(Profile(:));
        hold on;
    end  
end

