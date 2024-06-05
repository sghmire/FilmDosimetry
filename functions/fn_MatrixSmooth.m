function film_smooth = fn_MatrixSmooth(FilmData, method, window_strength)

    if strcmp(method, 'Average')
        film_smooth = smoothdata2(FilmData, "movmean", window_strength);
    elseif strcmp(method, 'Median')
        film_smooth = medfilt2(FilmData, [window_strength window_strength]);
    elseif strcmp(method, 'Gaussian')
        film_smooth = imgaussfilt(FilmData, window_strength);
    elseif strcmp(method, 'Lowess')
        film_smooth = smoothdata2(FilmData, "lowess", window_strength);
    elseif strcmp(method, 'Loess')
        film_smooth = smoothdata2(FilmData, "loess", window_strength);
    else
        film_smooth = FilmData; 
    end        
end