function tMatrix = fn_MatTransfor(iMatrix, Translation)

    Mat_size = size(iMatrix);
    Mat_center = Mat_size * 0.5;
    Translation = [Mat_center(2) Mat_center(1)] - Translation;
    Translation = [1 0 Translation(1);
                    0 1 Translation(2);
                    0  0 1];
   
    tform = rigidtform2d(Translation);
    followOutput = affineOutputView(size(iMatrix), tform, "BoundsStyle","CenterOutput");
    tMatrix = imwarp(iMatrix, tform, "OutputView",followOutput );

end
