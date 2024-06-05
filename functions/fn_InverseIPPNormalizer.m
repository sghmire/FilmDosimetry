
function X_cm_value = fn_InverseIPPNormalizer(X_pixel, X_cm_range, X_pixel_range)
    cm_min = X_cm_range(1);
    cm_max = X_cm_range(2);
    pixel_min = X_pixel_range(1);
    pixel_max = X_pixel_range(2);
    
    cm_range = cm_max - cm_min;
    pixel_range = pixel_max - pixel_min;
    
    X_normalized = (X_pixel - pixel_min) / pixel_range;    
    X_cm_value = cm_min + X_normalized * cm_range;
end
