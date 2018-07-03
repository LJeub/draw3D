function [X,Y,Z]=circle3d(X,Y,Z,normal,radius,resolution)
% [X, Y, Z] = circle3d(X, Y, Z, normal, radius, resolution)
%
% Coordinates for a circle in 3d space with centre [X,Y,Z] in plane with
% normal vector `normal'. Returns `resolution' number of points.

% Version: 1.0.1
% Date: Tue  3 Jul 2018 12:50:16 CEST
% Author: Lucas Jeub
% Email: lucasjeub@gmail.com

normal=normal/norm(normal);
accuracy = 10^-14;
if normal(1)==0 && normal(2)==0
    ndir=[1,0,0]*radius;
    ndir2=[0,1,0]*radius;
else
    ndir=[normal(2),-normal(1),0];
    ndir=ndir/norm(ndir)*radius;
    ndir2=cross(normal,ndir);
    ndir2=ndir2/norm(ndir2)*radius;
end
t_list=(0:resolution)*2*pi/resolution;
coslist=round(cos(t_list)/accuracy)*accuracy;
sinlist=round(sin(t_list)/accuracy)*accuracy;
X=X+coslist.*ndir(1)+sinlist.*ndir2(1);
Y=Y+coslist.*ndir(2)+sinlist.*ndir2(2);
Z=Z+coslist.*ndir(3)+sinlist.*ndir2(3);

end
