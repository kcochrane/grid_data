% planesubtraction from martina



      p1=[489 451];
      p2=[14 375]; 
      p3=[270 8];
      r=0; 
      n_x=length(x_nm);
      n_y=length(y_nm);
      delta_x=1/n_x;
      delta_y=1/n_y;
      
      
      
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