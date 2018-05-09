classdef sphere3d<draw3d
    % h = sphere3d(X, Y, Z, options)
    %
    % draw a sphere
        
% Version: 1.0
% Date: Wed  9 May 2018 14:22:01 CEST
% Author: Lucas Jeub
% Email: ljeub@iu.edu
    
    properties (AbortSet)
        Radius=1; % radius of sphere in data units
    end
    
    
    methods
        function obj=sphere3d(X,Y,Z,varargin)
            % draw a sphere with centre [X,Y,Z]
            if nargin>0
                set(obj.patch_group,'Tag','sphere3d')
                obj.XData=X;
                obj.YData=Y;
                obj.ZData=Z;
                set(obj,varargin{:});
                obj.type_store='sphere3d';
                
                obj.draw=true;
            end
        end
        
        
        function set.Radius(obj,radius)
            obj.Radius=radius;
            obj.request_redraw;
        end
    end
    methods (Hidden,Access=protected)
        function redraw(obj)
            delete(obj.patches);
            if obj.AngularResolution>2
            n=obj.AngularResolution;
            theta = (-n:2:n)/n*pi;
            phi = (-n:2:n)'/n*pi/2;
            cosphi = cos(phi); cosphi(1) = 0; cosphi(n+1) = 0;
            sintheta = sin(theta); sintheta(1) = 0; sintheta(n+1) = 0;

            X=cosphi*cos(theta)*obj.Radius;
            Y=sin(phi)*ones(1,n+1)*obj.Radius;
            Z=cosphi*sintheta*obj.Radius;
            h=patch(surf2patch(X+obj.XData,Y+obj.YData,Z+obj.ZData),'EdgeColor','none');
            else
                [X,Y,Z]=circle3d(obj.XData,obj.YData,obj.ZData,[0,0,1],obj.Radius,100);
                h=patch(X,Y,Z);
            end
            
            obj.patches=h;
        end
    end
end



