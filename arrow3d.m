classdef arrow3d<line3d
    
    properties (AbortSet)
        HeadOffset=0;
        HeadLength=[];
        HeadWidth=[];
    end
    
    methods
        
        function obj=arrow3d(X,Y,Z,varargin)
            obj.type_store='arrow3d';
            if nargin>0
                set(obj.patch_group,'Tag','arrow3d','UserData',obj);
                obj.XData=X;
                obj.YData=Y;
                obj.ZData=Z;
                set(obj,varargin{:});
                if isempty(obj.HeadLength)
                    obj.HeadLength=10*obj.LineWidth;
                end
                if isempty(obj.HeadWidth)
                    obj.HeadWidth=max(1/3*obj.HeadLength,2*obj.LineWidth);
                end
                obj.add_child(line3d());
                obj.add_child(arrowhead3d());
                obj.draw=true;
            end
        end
        
        function set.HeadOffset(obj,offset)
            obj.HeadOffset=offset;
            obj.redraw;
        end
        
        function set.HeadLength(obj,length)
            obj.HeadLength=length;
            obj.redraw;
        end
        
        function set.HeadWidth(obj,width)
            obj.HeadWidth=width;
            obj.redraw;
        end
    end
    
    methods (Access = protected)
        function redraw(obj)
            if obj.draw_now
                
                X=obj.XData;
                Y=obj.YData;
                Z=obj.ZData;
                
                dir1=[X(end)-X(end-1),Y(end)-Y(end-1),Z(end)-Z(end-1)];
                l=norm(dir1);
                dir1=dir1/l;
                
                X_base=X(end)-(obj.HeadOffset+obj.HeadLength)*dir1(1);
                Y_base=Y(end)-(obj.HeadOffset+obj.HeadLength)*dir1(2);
                Z_base=Z(end)-(obj.HeadOffset+obj.HeadLength)*dir1(3);
                
                
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
                   'Color',obj.Color,'Alpha',obj.Alpha,'HeadWidth',obj.HeadWidth);
                if ~obj.Children{2}.draw
                   obj.Children{2}.draw=true;
               end
            end
        end
    end
end
