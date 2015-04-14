function [X,Y,Z]=circle3d(X,Y,Z,normal,radius,resolution)
normal=normal/norm(normal);

ndir=[normal(2),-normal(1),0];
ndir=ndir/norm(ndir)*radius;
ndir2=cross(normal,ndir);
ndir2=ndir2/norm(ndir2)*radius;
t_list=(1:resolution)*2*pi/resolution;

X=X+cos(t_list).*ndir(1)+sin(t_list).*ndir2(1);
Y=Y+cos(t_list).*ndir(2)+sin(t_list).*ndir2(2);
Z=Z+cos(t_list).*ndir(3)+sin(t_list).*ndir2(3);

end