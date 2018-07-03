function [X,Y,Z]=ellipse3d(X,Y,Z,axis1,axis2, resolution)
% [X, Y, Z] = ellipse3d(X, Y, Z, axis1, axis2, resolution)
%
% Coordinates for an ellipse in 3d space with centre [X,Y,Z] and
% axes `axis1' and 'axis2'.
% Returns `resolution' number of points.

% Version: 1.0.1
% Date: Tue  3 Jul 2018 12:50:17 CEST
% Author: Lucas Jeub
% Email: lucasjeub@gmail.com
    
t_list=(0:resolution)*2*pi/resolution;

X=X+cos(t_list).*axis1(1)+sin(t_list).*axis2(1);
Y=Y+cos(t_list).*axis1(2)+sin(t_list).*axis2(2);
Z=Z+cos(t_list).*axis1(3)+sin(t_list).*axis2(3);

end
