function [X,Y,Z]=ellipse3d(X,Y,Z,axis1,axis2)

t_list=(0:100)*2*pi/100;

X=X+cos(t_list).*axis1(1)+sin(t_list).*axis2(1);
Y=Y+cos(t_list).*axis1(2)+sin(t_list).*axis2(2);
Z=Z+cos(t_list).*axis1(3)+sin(t_list).*axis2(3);

end