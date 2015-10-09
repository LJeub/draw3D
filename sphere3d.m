classdef sphere3d<draw3d
    % h = sphere3d(X, Y, Z, options)
    %
    % draw a sphere
    
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
            [X,Y,Z]=sphere(obj.AngularResolution);
            X=X*obj.Radius;
            Y=Y*obj.Radius;
            Z=Z*obj.Radius;
            
            h=patch(surf2patch(X+obj.XData,Y+obj.YData,Z+obj.ZData),'EdgeColor','none');
            obj.patches=h;
        end
    end
end



