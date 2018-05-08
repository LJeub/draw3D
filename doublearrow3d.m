classdef doublearrow3d<arrow3d
    % h=doublearrow3d(X,Y,Z,options)
    % 
    % draw 3-dimensional double arrow between points [X(1),Y(1),Z(1)] and
    % [X(end),Y(end),Z(end)]. 
    %
    % See also: line3d, arrow3d
    
    methods
        
        function obj=doublearrow3d(X,Y,Z,varargin)
            % draw 3-dimensional double arrow between points [X(1),Y(1),Z(1)] and [X(end),Y(end),Z(end)]. 
            obj.type_store='doublearrow3d';
            if nargin>0
                set(obj.patch_group,'Tag','doublearrow3d');
                obj.XData=X;
                obj.YData=Y;
                obj.ZData=Z;
                set(obj,varargin{:});
                obj.add_child(arrowhead3d());
                obj.add_child(line3d());
                obj.add_child(arrowhead3d());
                obj.draw=true;
            end
        end
        
    end
    
    methods (Hidden,Access = protected)
        function redraw(obj)
            X=obj.XData;
            Y=obj.YData;
            Z=obj.ZData;
            
            dir1=[X(2)-X(1),Y(2)-Y(1),Z(2)-Z(1)];
            l=norm(dir1);
            dir1=dir1/l;
            
            X_base=X(1)+(obj.HeadOffset+obj.HeadLength)*dir1(1);
            Y_base=Y(1)+(obj.HeadOffset+obj.HeadLength)*dir1(2);
            Z_base=Z(1)+(obj.HeadOffset+obj.HeadLength)*dir1(3);
            
            
            X_tip=X(1)+obj.HeadOffset*dir1(1);
            Y_tip=Y(1)+obj.HeadOffset*dir1(2);
            Z_tip=Z(1)+obj.HeadOffset*dir1(3);
            
            set(obj.Children{1},'XData',[X_base,X_tip],'YData',[Y_base,Y_tip],'ZData',[Z_base,Z_tip],...
                'Color',obj.Color,'Alpha',obj.Alpha,'HeadWidth',obj.HeadWidth);
            if ~obj.Children{1}.draw
                obj.Children{1}.draw=true;
            end
            
            
            dir1=[X(end)-X(end-1),Y(end)-Y(end-1),Z(end)-Z(end-1)];
            l=norm(dir1);
            dir1=dir1/l;
            
            X_base2=X(end)-(obj.HeadOffset+obj.HeadLength)*dir1(1);
            Y_base2=Y(end)-(obj.HeadOffset+obj.HeadLength)*dir1(2);
            Z_base2=Z(end)-(obj.HeadOffset+obj.HeadLength)*dir1(3);
            
            set(obj.Children{2},'XData',[X_base,X(2:end-1),X_base2],'YData',[Y_base,Y(2:end-1),Y_base2],...
                'ZData',[Z_base,Z(2:end-1),Z_base2],...
                'LineStyle',obj.LineStyle,'LineWidth',obj.LineWidth,'Alpha',obj.Alpha,...
                'Color',obj.Color);
            if ~obj.Children{2}.draw
                obj.Children{2}.draw=true;
            end
            
            X_tip=X(end)-obj.HeadOffset*dir1(1);
            Y_tip=Y(end)-obj.HeadOffset*dir1(2);
            Z_tip=Z(end)-obj.HeadOffset*dir1(3);
            set(obj.Children{3},'XData',[X_base2,X_tip],'YData',[Y_base2,Y_tip],'ZData',[Z_base2,Z_tip],...
                'Color',obj.Color,'Alpha',obj.Alpha,'HeadWidth',obj.HeadWidth);
            if ~obj.Children{3}.draw
                obj.Children{3}.draw=true;
            end
            
            
        end
    end
end
