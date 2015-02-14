classdef sphere3d<draw3d
    
    properties (AbortSet)
        Radius=1;
    end
    
    
    methods
        function obj=sphere3d(X,Y,Z,varargin)
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
    methods (Access=protected)
        function redraw(obj)
            delete(obj.patches);
            [X,Y,Z]=sphere(100);
            X=X*obj.Radius;
            Y=Y*obj.Radius;
            Z=Z*obj.Radius;
            
            h=patch(surf2patch(X+obj.XData,Y+obj.YData,Z+obj.ZData),'EdgeColor','none');
            obj.patches=h;
        end
    end
end



