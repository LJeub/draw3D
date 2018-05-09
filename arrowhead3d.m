classdef arrowhead3d<draw3d
    % h=arrowhead3d(X,Y,Z,options)
    %
    % draw arrowhead (a cone) from [X(1),Y(1),Z(1)] to [X(2),Y(2),Z(2)]
    %
    % See also: arrow3d, doublearrow3d, draw3d
        
% Version:
% Date:
% Author:
% Email:
    
    properties (AbortSet)
        HeadWidth=0.5; % diameter of base of cone in data units
    end
    
    methods
        function obj=arrowhead3d(X,Y,Z,varargin)
            %draw arrowhead (a cone) from [X(1),Y(1),Z(1)] to [X(2),Y(2),Z(2)]
            obj.type_store='arrowhead3d';
            if nargin>0
                set(obj.patch_group,'Tag','arrowhead3d','UserData',obj);
                obj.XData=X;
                obj.YData=Y;
                obj.ZData=Z;
                set(obj,varargin{:})
                obj.draw=true;
            end
        end
        
        function set.HeadWidth(obj,value)
            obj.HeadWidth=value;
            obj.request_redraw;
        end
    end
    
    methods (Hidden,Access=protected)
        function redraw(obj)
            delete(obj.patches);
            X=obj.XData;
            Y=obj.YData;
            Z=obj.ZData;
            
            dir=[X(2)-X(1),Y(2)-Y(1),Z(2)-Z(1)];
            
            [X_head,Y_head,Z_head]=circle3d(X(1),Y(1),Z(1),dir,obj.HeadWidth/2,obj.AngularResolution);
            hc=patch(X_head,Y_head,Z_head,obj.Color);
            
            X_head(end)=X(2);
            Y_head(end)=Y(2);
            Z_head(end)=Z(2);
            
            if length(X_head)==3
                faces=[1,2,3];
            else
                faces=[(1:length(X_head)-1)',[2:length(X_head)-1,1]',repmat(length(X_head),length(X_head)-1,1)];
            end
            hh=patch('Vertices',[X_head(:),Y_head(:),Z_head(:)],'Faces',faces);
            obj.patches=[hc,hh];
        end
    end
end



