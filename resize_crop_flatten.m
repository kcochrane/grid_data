% July 12th, 2013
    
    % Script to correct the creep of Z images from the grids: you can
    % correct the horizontal shear and resize the image after. You can also
    % subtract a plane to your images ONLY if they are square
    
 % clear all;clc;
% close all 
% USER INPUTS

f=flat_parse('20130920-092545_AFM_NonContact_QPlus-Au(111)--148_1.I(V)_flat');
filename=f;            
 % file_cell=1; %If file_cell is equal to one means that the file has a cell
                % format that must be load with flat_parse etc;
                % otherwise the file is just a matrix
                % If the Z file is in cell structure in the first cell
                % there is the all Z values for x and y; second cell
                % contains the x values and third cell contains the y
                % values 
    
  % CROPPING  
    crop=0; %If crop is equal to one means that the image is cropped
              % size; otherwise one consider the all image in size
    xcrop_in=17;
    xcrop_fin=512;
    ycrop_in=1;
    ycrop_fin=496;
    
  % PLANE SUBTRACTION
    plane_sub=1; % If plane_sub is equal to one you want to subtract a plane 
               % to the image and so you also have to insert the 3 points
               % reference for the plane to be subtracted
    % Three points for the plane subtraction
      p1=[165 18];
      p2=[76 375]; 
      p3=[270 8];
      r=0;     
      
   % ANGLE CORRECTION              
    correction=1; % If correction is equal to one it means that one is ready              
                % to apply the angle correction to the image; if it is zero
                % it means that one is not ready yet
    % Angle of disortion in degree
    theta_degree=120;    
  
  % RESIZING
    resize=1; %If resize is zero it means that the molecules dimensions are 
            % correct; otherwise you want to resize it. In order to do that
            % you have to insert three points on the molecule - see below
    % Molecule wrong size in points
      A=[385 150]; % Bottom left corner
      B=[563 150]; % Bottom right corner
      C=[565 218]; % Top right corner        
    % Image size in nm
      x_scan_size=5;
      y_scan_size=5;
    % Molecule right size in nm
      long_side=1.681;
      short_side=0.486;




%_________________________________________________________________________

%if file_cell==1
   [x_var,y_var,Z]=Import_Z_flat_cell_structure(filename,1,0); 
     
   if crop==1
      Z=Z(xcrop_in:xcrop_fin,ycrop_in:ycrop_fin);
      n_x=(xcrop_fin-xcrop_in)+1;
      n_y=(ycrop_fin-ycrop_in)+1;
      delta_x=1/n_x;
      delta_y=1/n_y;
   elseif crop==0
      n_x=length(x_var);
      n_y=length(y_var);
      delta_x=1/n_x;
      delta_y=1/n_y;
   end
   
%    figure
%    colormap(bone)
%    imagesc(Z')
%    imagesc(x_var,y_var,Z')
%    axis xy
%    
   % Plane subtraction
   if plane_sub==1
%       p1=p1.Position;
%       p2=p2.Position;
%       p3=p3.Position;
      X = [p1(1), p2(1), p3(1)];
      Y = [p1(1,2), p2(1,2), p3(1,2)];
   
      p1Z = sum( sum( Z( p1(1,2)-r:p1(1,2)+r,p1(1)-r:p1(1)+r ) ) );
      p2Z = sum( sum( Z( p2(1,2)-r:p2(1,2)+r,p2(1)-r:p2(1)+r ) ) );
      p3Z = sum( sum( Z( p3(1,2)-r:p3(1,2)+r,p3(1)-r:p3(1)+r ) ) );

      R = [p1Z, p2Z, p3Z]/((2*r+1)^2);
   
      a = det([1,Y(1), R(1); 1,Y(2),R(2); 1,Y(3),R(3)]);
      b = det([X(1),1,R(1); X(2),1,R(2); X(3),1,R(3)]);
      c = det([X(1),Y(1),1; X(2),Y(2),1; X(3),Y(3),1]);
      d = -det([X(1),Y(1),R(1); X(2),Y(2),R(2); X(3),Y(3),R(3)]);
   
      X = zeros(n_y);
      X(1,:) = 1:n_y;
      I = eye(n_y);
      I(:,1) = 1;
      X = I*X;
      Y = X';
      D = d*ones(n_y);

      plane = -(a*X + b*Y + D)/c;

      Z = Z - plane;
      figure
      colormap(bone)
      %imagesc(x_var,y_var,Z')
      imagesc(Z')
      axis xy
      axis image;
      title('Z image');
      ylabel('y [nm]');
      xlabel('x [nm]');
      colorbar;
   end  
   
% elseif file_cell==0
%     Z=importdata(filename);
%     n_y=length(Z(:,1));
%     n_x=length(Z(1,:));
%     figure
%     colormap(bone)
%     imagesc(Z)
%     Z=Z';
% end


if correction==1
    
    %Transformation matrix
     theta_rad=(2*pi*theta_degree)/360;
     T=[1 cot(theta_rad); 0 1];
     I=inv(T);  
 
     %Z_new=zeros(n_x,n_y);
     new_x_matrix=zeros(n_x,n_y);
     new_y_matrix=zeros(n_x,n_y);
     
     long_side_wrong_points=B(1)-A(1);
     long_side_correct_point=(n_x*long_side)/x_scan_size;  
     long_factor=long_side_correct_point/long_side_wrong_points;
     short_side_wrong_ponits=C(1,2)-B(1,2); 
     short_side_correct_point=(n_y*short_side)/y_scan_size;
     short_factor=short_side_correct_point/short_side_wrong_ponits;
    
   if crop==1
       x_in_norm=xcrop_in*delta_x;
       x_fin_norm=xcrop_fin*delta_x;
       y_in_norm=ycrop_in*delta_y;
       y_fin_norm=ycrop_fin*delta_y;
    elseif crop==0
       x_in_norm=delta_x;
       x_fin_norm=1;
       y_in_norm=delta_y;
       y_fin_norm=1;
    end
    
    for y=y_in_norm:delta_y:y_fin_norm
       for x=x_in_norm:delta_x:x_fin_norm
         old_coord=[x;y];
         new=I*old_coord;
         new_coord_x=round(new(1)/delta_x);
         new_coord_y=round(new(2)/delta_y);
         x_old=round(x/delta_x);
         y_old=round(y/delta_y); 
        if new_coord_x>0 && new_coord_y>0 %&& new_coord_x<=n_x && new_coord_y<=n_y 
            if resize==1 
              new_coord_x=round(new_coord_x*long_factor);
              new_coord_y=round(new_coord_y*short_factor);
           end
           Z_new(new_coord_x,new_coord_y)=Z(x_old,y_old);
           new_x_matrix(x_old,y_old)=new_coord_x;
           new_y_matrix(x_old,y_old)=new_coord_y;
        end  
      end
    end 
    
   n_x_new=length(Z_new(:,1));
   n_y_new=length(Z_new(1,:));

 % Background value: Resizing enlarge the size of the image so the new
 % matrix poitions are assigned to be equal to the mean value of the matrix
   m_Z=mean(Z);
   m=mean(m_Z);
   
   for y=1:n_y_new
     for x=1:n_x_new
         if Z_new(x,y)==0
            Z_new(x,y)=m; 
         end
     end
   end
   
% Resizing can leave some points to not be reassigned with a new value
% therefore they are "filled" with the average value of the neighbor points
      for y=2:(n_y_new-1)
       for x=2:(n_x_new-1)
           if Z_new(x,y)==m
              if Z_new(x+1,y)~=m && Z_new(x-1,y)~=m
                 Z_new(x,y)=(Z_new(x+1,y)+Z_new(x-1,y))/2;   
              end    
           end    
       end
      end 
  
  if crop==1
     %Z_new_cropped=Z_new(xcrop_in:xcrop_fin,ycrop_in:ycrop_fin);
     Z_new_cropped=Z_new;
     figure
     colormap(bone)
     imagesc(x_var,y_var,Z_new_cropped')
     axis xy
     axis image;
     title('Z image');
     ylabel('y [nm]');
     xlabel('x [nm]');
     colorbar;
  else   
    figure
    imagesc(Z_new');
    colormap(bone)
    axis xy  
    axis image;
    title('Z image');
    ylabel('y [nm]');
    xlabel('x [nm]');
    colorbar;
  end
 %save('20130527_123530_32.1_Z_ang120_resized.mat','Z_new', '-mat');
end