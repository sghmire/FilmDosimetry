function Plane = fn_PlaneNavigator(RTDose, PlaneLabel, PlaneNumber, Figure, PixelSpacingX, PixelSpacingY, colormap)
    
    %Get rid of the singleton dimension from RT dose file using Squeeze
    Volume = RTDose;
    PlaneNumber = round(PlaneNumber);
    
    %Check for the Plane label and align it with the Eclipse winodows
    if strcmp(PlaneLabel, "YZ")
         Plane = squeeze(Volume(:,PlaneNumber, :));
         Plane = imrotate(Plane, 90);
         Plane = fliplr(Plane);
         title = [PlaneLabel, ' - Sagittal'];

    elseif strcmp(PlaneLabel, "XZ")
        Plane = squeeze(Volume(PlaneNumber, :,:));
        Plane = imrotate(Plane, 90);
        title = [PlaneLabel, ' - Coronal'];

    elseif strcmp(PlaneLabel, "XY")
        Plane = squeeze(Volume(:,:,PlaneNumber));  
        title = [PlaneLabel, ' - Axial'];
    end

    %Update the UIAxes 
    if ~isempty(Figure)
        fn_IMREF2D_P(Plane,PixelSpacingX * 0.1, PixelSpacingY * 0.1, Figure, colormap);
        
        Figure.XAxisLocation = 'bottom';
        Figure.YAxisLocation = 'left';
        Figure.XTickMode = 'auto';
        Figure.YTickMode = 'auto';
        Figure.XTickLabelMode = 'auto';
        Figure.YTickLabelMode = 'auto';
        Figure.XLimitMethod= 'tight';
        Figure.YLimitMethod= 'tight';
        axis(Figure, 'on');
        Figure.Box = 'on';

        Figure.Title.String = title ;

    end

end
