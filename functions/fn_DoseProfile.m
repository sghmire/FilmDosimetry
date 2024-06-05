%This function throws the pixels profile of the  

function [X_profile, Y_profile, dis_x, dis_y] = fn_DoseProfile(Matrix_data, X_pos, Y_pos, Type,  dosegrid, fraction, Dosescale)        
      

     if strcmp(Type, 'TPS') 
            X_profile = Matrix_data(round(Y_pos),:) * dosegrid * 100 * (1/fraction) *Dosescale;   
            Y_profile = Matrix_data(:,round(X_pos)) * dosegrid * 100 * (1/fraction) * Dosescale;
            dis_X = numel(X_profile) ;
            dis_x = linspace(-dis_X * 0.5, dis_X * 0.5, numel(X_profile)); 
            dis_Y = numel(Y_profile) ;
            dis_y = linspace(-dis_Y * 0.5, dis_Y * 0.5, numel(Y_profile)); 

      elseif strcmp(Type, "Film")        
            X_profile = Matrix_data(round(Y_pos),:);
            Y_profile = Matrix_data(:,round(X_pos));
            dis_X = numel(X_profile);
            dis_x = linspace(-dis_X * 0.5, dis_X * 0.5, numel(X_profile)); 
            dis_Y = numel(Y_profile) ;
            dis_y = linspace(-dis_Y * 0.5, dis_Y * 0.5, numel(Y_profile)); 

      end
  end

