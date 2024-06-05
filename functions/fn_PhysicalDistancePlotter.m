function [plan_profile_x, plan_profile_y, plan_x_dis, plan_y_dis, ...
    film_profile_x, film_profile_y, film_x_dis, film_y_dis] = fn_PhysicalDistancePlotter(TPS_data, Film_data, DoseGrid,fx, scale,pixelspacing, DPI, Figure1, Figure2)

if ~isempty(TPS_data)

    % --- Plan Data ---
    plan_dose_data = TPS_data;
    plan_dose_data = plan_dose_data * DoseGrid * 100 * scale* 1/fx;

    % Plan dimensions and calculations
    [plan_height, plan_width] = size(plan_dose_data);
    plan_center_y = round(plan_height * 0.5);
    plan_center_x = round(plan_width * 0.5);

    % Original physical dimensions of the Plan
    plan_dis_x_original = plan_width * pixelspacing(2);
    plan_dis_y_original = plan_height * pixelspacing(1);

    % Distance vectors for plotting
    plan_x_dis = linspace(-plan_dis_x_original * 0.5, plan_dis_x_original * 0.5, plan_width);
    plan_y_dis = linspace(-plan_dis_y_original * 0.5, plan_dis_y_original * 0.5, plan_height);

    % --- Profiles ---
    plan_profile_x = plan_dose_data(plan_center_y, :);
    plan_profile_y = plan_dose_data(:, plan_center_x);

end

if ~isempty(Film_data)

    % --- Film Data ---
    film_data = Film_data;
    [film_height, film_width] = size(film_data);
    film_center_y = round(film_height * 0.5);
    film_dis_y = film_height * 25.4 / DPI;
    film_center_x = round(film_width * 0.5);
    film_dis_x = film_width * 25.4 / DPI;

    % Distance vectors for Film
    film_x_dis = linspace(-film_dis_x * 0.5, film_dis_x * 0.5, film_width);
    film_y_dis = linspace(-film_dis_y * 0.5, film_dis_y * 0.5, film_height);

    film_profile_x =  film_data(film_center_y, :);
    film_profile_y = film_data(:, film_center_x);

end

    % Plotting
    plot(plan_x_dis, plan_profile_x, 'Parent', Figure1,'Color','b', 'LineWidth', 0.5); 
    hold(Figure1, 'on');
    plot(film_x_dis, film_profile_x, 'Parent', Figure1, 'Color','r', 'LineWidth', 0.5); 
    xlabel(Figure1, 'X Distance (mm)'); 
    ylabel(Figure1, 'Dose (cGy)'); 
    h =legend(Figure1, 'Plan', 'Film');        
    set(h,'FontSize',6, 'FontWeight', 'bold');
    xlim(Figure1, [-film_dis_x * 0.75 film_dis_x * 0.75]);
    hold(Figure1, 'off');   
    
    plot(plan_y_dis, plan_profile_y, 'Parent', Figure2, 'Color','b', 'LineWidth', 0.5); 
    hold(Figure2, 'on');        
    plot(film_y_dis, film_profile_y, 'Parent', Figure2, 'Color','r', 'LineWidth',0.5);
    xlabel(Figure2, 'Y Distance (mm)'); 
    ylabel(Figure2, 'Dose (cGy)');  
    g = legend(Figure2, 'Plan', 'Film');
    set(g,'FontSize',6, 'FontWeight', 'bold');
    xlim(Figure2, [-film_dis_y * 0.75 film_dis_y * 0.75]);          
    hold(Figure2, 'off');

end
