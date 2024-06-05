%This function converts the DICOM volume in pixels into physical dimension
%based off Image Position Patient, Orientation and Pixel spacing/Slice
%Thickness.

function [Dicom_extent_X, Dicom_extent_Y, Dicom_extent_Z] = fn_DicomExtent( RTDose, sign1, sign2) 
    % Extract DICOM information
    dicom_info = dicominfo(RTDose);
    rows = dicom_info.Rows;
    columns = dicom_info.Columns;
    num_frames = dicom_info.NumberOfFrames;
    pixel_spacing = dicom_info.PixelSpacing;
    image_position_patient = dicom_info.ImagePositionPatient;
    image_orientation_patient = dicom_info.ImageOrientationPatient;
    
    % Determine slice thickness
    if ~isempty(dicom_info.SliceThickness)
        slice_thickness = dicom_info.SliceThickness;
    else
        slice_thickness = dicom_info.PixelSpacing(1);                    
    end
    
    % Calculate extent in X, Y, and Z directions
    extent_x = (columns - 1) * pixel_spacing(1);
    extent_y = (rows - 1) * pixel_spacing(2);
    extent_z = (num_frames - 1) * slice_thickness;
    
    % Calculate transformation matrix
    direction_cosines = reshape(image_orientation_patient, 3, 2);
    cross_product = cross(direction_cosines(:, 1), direction_cosines(:, 2));
    transformation_matrix = [direction_cosines cross_product];
    
    % Calculate direction vectors for X, Y, and Z axes
    x_direction = transformation_matrix(:, 1);
    y_direction = transformation_matrix(:, 2);
    z_direction = transformation_matrix(:, 3);
    
    % Calculate extent in X direction accounting for directionality
    x_start = round(double(image_position_patient(1)), 2);
    x_end = round(double(x_start + extent_x * sign(x_direction(1))), 2);
    Dicom_extent_X = [x_start, x_end];
    if Dicom_extent_X(1) > Dicom_extent_X(2)
        Dicom_extent_X = [Dicom_extent_X(2), Dicom_extent_X(1)];
    end
   
    % Calculate extent in Y direction accounting for directionality
    y_start = round(double(image_position_patient(2)), 2);
    y_end = round(double(y_start + extent_y * sign(y_direction(2))), 2);
    Dicom_extent_Y = [y_start, y_end];
    if Dicom_extent_Y(1) > Dicom_extent_Y(2)
        Dicom_extent_Y = [Dicom_extent_Y(2), Dicom_extent_Y(1)];
    end
    
    % Calculate extent in Z direction accounting for directionality
    z_start = sign1 * (round(double(image_position_patient(3)), 2));
    z_end = round(double(z_start + extent_z * sign(z_direction(3))), 2);  

    Dicom_extent_Z = sign2 * [z_start, z_end];

    if Dicom_extent_Z(1) > Dicom_extent_Z(2)
        Dicom_extent_Z = [Dicom_extent_Z(2), Dicom_extent_Z(1)];
    end


  end