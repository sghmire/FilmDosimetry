   
function CenteredPlane = fn_PlaneCentering(Plane, Pos1, Pos2)    
    [height, width] = size(Plane);
    image_center = [width, height] / 2;
    desired_center = [Pos1,  Pos2];
    translation =  image_center - desired_center;
    CenteredPlane = imtranslate(Plane, translation);
end
