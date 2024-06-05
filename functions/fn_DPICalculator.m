function DPI_info = fn_DPICalculator(imagefile )

    info = imfinfo(imagefile);
    
    if isfield(info, 'XResolution') && isfield(info, 'YResolution')
        XResolution = info.XResolution;
        YResolution = info.YResolution;
        DPI_width = XResolution(1);
        DPI_height = YResolution(1);
        DPI_info = (DPI_width + DPI_height) / 2;
    else
    end
    
end