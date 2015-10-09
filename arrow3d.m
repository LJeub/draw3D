classdef arrow3d<line3d
    % h=arrow3d(X,Y,Z,options)
    % 
    % draw 3-dimensional arrow from point [X(1),Y(1),Z(1)] to point
    % [X(end),Y(end),Z(end)]. 
    %
    % See also: line3d, doublearrow3d
    properties (AbortSet)
        HeadOffset=0; % distance from the arrow tip to the end-point in data units
        HeadLength=5; % length of arrow head as a multiple of LineWidth
        HeadWidth=3; % width of arrow head as a multiple of LineWidth
    end
    
    methods
        
        
        function obj=arrow3d(X,Y,Z,varargin)
            % draw 3-dimensional arrow from point [X(1),Y(1),Z(1)] to point [X(end),Y(end),Z(end)]. 
             
            obj.type_store='arrow3d';
            if nargin>0
                set(obj.patch_group,'Tag','arrow3d','UserData',obj);
                obj.XData=X;
                obj.YData=Y;
                obj.ZData=Z;
                set(obj,varargin{:});
                obj.add_child(line3d());
                obj.add_child(arrowhead3d());
                obj.draw=true;
            end
        end
        
        function set.HeadOffset(obj,offset)
            obj.HeadOffset=offset;
            obj.request_redraw;
        end
        
        function set.HeadLength(obj,length)
            obj.HeadLength=length;
            obj.request_redraw;
        end
        
        function set.HeadWidth(obj,width)
            obj.HeadWidth=width;
            obj.request_redraw;
        end
    end
    
    methods (Hidden,Access = protected)
        function redraw(obj)
            
            X=obj.XData;
            Y=obj.YData;
            Z=obj.ZData;
            
            dir1=[X(end)-X(end-1),Y(end)-Y(end-1),Z(end)-Z(end-1)];
            l=norm(dir1);
            dir1=dir1/l;
            
            X_base=X(end)-(obj.HeadOffset+obj.HeadLength*obj.LineWidth)*dir1(1);
            Y_base=Y(end)-(obj.HeadOffset+obj.HeadLength*obj.LineWidth)*dir1(2);
            Z_base=Z(end)-(obj.HeadOffset+obj.HeadLength*obj.LineWidth)*dir1(3);
            
            
            set(obj.Children{1},'XData',[X(1:end-1),X_base],'YData',[Y(1:end-1),Y_base],...
                'ZData',[Z(1:end-1),Z_base],...
                'LineStyle',obj.LineStyle,'LineWidth',obj.LineWidth,'Alpha',obj.Alpha,...
                'Color',obj.Color);
            if ~obj.Children{1}.draw
                obj.Children{1}.draw=true;
            end
            
            X_tip=X(end)-obj.HeadOffset*dir1(1);
            Y_tip=Y(end)-obj.HeadOffset*dir1(2);
            Z_tip=Z(end)-obj.HeadOffset*dir1(3);
            set(obj.Children{2},'XData',[X_base,X_tip],'YData',[Y_base,Y_tip],'ZData',[Z_base,Z_tip],...
                'Color',obj.Color,'Alpha',obj.Alpha,'HeadWidth',obj.HeadWidth*obj.LineWidth);
            if ~obj.Children{2}.draw
                obj.Children{2}.draw=true;
            end
        end
    end
end
