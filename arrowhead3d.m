classdef arrowhead3d<draw3d
    
    
    properties (AbortSet)
        HeadWidth=0.5;
    end
    
    methods 
        function obj=arrowhead3d(X,Y,Z,varargin)
            obj.type_store='arrowhead3d';
            if nargin>0
                set(obj.patch_group,'Tag','arrowhead3d','UserData',obj);
                set(obj,varargin{:})
            end
        end
        
        function set.HeadWidth(obj,value)
            obj.HeadWidth=value;
            obj.redraw;
        end
    end
    
    methods (Access=protected)
        function redraw(obj)
            if obj.draw_now
                delete(obj.patches);
                X=obj.XData;
                Y=obj.YData;
                Z=obj.ZData;
                
                dir=[X(2)-X(1),Y(2)-Y(1),Z(2)-Z(1)];
                
                [X_head,Y_head,Z_head]=circle3d(X(1),Y(1),Z(1),dir,obj.HeadWidth);
                hc=patch(X_head,Y_head,Z_head,obj.Color);
                
                X_head(end+1)=X(2);
                Y_head(end+1)=Y(2);
                Z_head(end+1)=Z(2);
                
                hh=patch(X_head,Y_head,Z_head,obj.Color);
                
                obj.patches=[hc,hh];
                set(obj.patches,'Parent',obj.patch_group,'FaceAlpha',obj.Alpha,'EdgeColor','none','FaceColor',obj.Color);
            end
        end
    end
end
                
                
    
    