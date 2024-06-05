function FilmDosePlane = fn_FilmtoDoseConverter(TIFFFilm, FittingType, Red_Ini_Coefficients, ...
    Red_Fin_Coefficeints, Green_Ini_Coefficients, Green_Fin_Coefficeints, DoseFigure)

     Red_channel = double(TIFFFilm(:,:,1));
     Red_channel = -log10(max(Red_channel, 1) ./ 65535);
     Green_channel = double(TIFFFilm(:,:,2));
     Green_channel = -log10(max(Green_channel, 1) ./ 65535);
     Blue_channel = double(TIFFFilm(:,:,3));
     Blue_channel = -log10(max(Blue_channel, 1) ./ 65535);

     Red_channel_corr = (Red_channel ./ Blue_channel) ;
     Green_channel_corr = (Green_channel ./ Blue_channel);

     switch FittingType
         
         case 'Red Corrected'
            FilmDosePlane = polyval(Red_Ini_Coefficients,  Red_channel_corr); 

         case 'Red Dose Corrected'
            Red_channel_corr = polyval(Red_Ini_Coefficients,  Red_channel_corr); 
            FilmDosePlane = polyval(Red_Fin_Coefficeints, Red_channel_corr);

         case 'Green Corrected'
            FilmDosePlane = polyval(Green_Ini_Coefficients,  Green_channel_corr) ;

         case 'Green Dose Corrected'
            Green_channel_corr = polyval(Green_Ini_Coefficients,  Green_channel_corr) ;
            FilmDosePlane= polyval(Green_Fin_Coefficeints, Green_channel_corr);
     end

     imshow( FilmDosePlane, 'Parent',DoseFigure);
     colormap(DoseFigure, "jet");
end
