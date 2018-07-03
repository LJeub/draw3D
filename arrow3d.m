classdef arrow3d<line3d
    % h=arrow3d(X,Y,Z,options)
    %
    % draw 3-dimensional arrow from point [X(1),Y(1),Z(1)] to point
    % [X(end),Y(end),Z(end)].
    %
    % See also: line3d, doublearrow3d
    
% Version: 1.0.1
% Date: Tue  3 Jul 2018 12:50:16 CEST
% Author: Lucas Jeub
% Email: lucasjeub@gmail.com
    
    properties (AbortSet)
        HeadOffset=0; % distance from the arrow tip to the end-point in data units
        HeadLength=[]; % length of arrow head in data units
        HeadWidth=[]; % width of arrow head in data units
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
        
        function length=get.HeadLength(obj)
            if isempty(obj.HeadLength)
                length=5*obj.LineWidth;
            else
                length=obj.HeadLength;
            end
        end
                
        function set.HeadWidth(obj,width)
            obj.HeadWidth=width;
            obj.request_redraw;
        end
        
        function width=get.HeadWidth(obj)
            if isempty(obj.HeadWidth)
                width=3*obj.LineWidth;
            else
                width=obj.HeadWidth;
            end
        end
    end
    
    methods (Hidden,Access = protected)
        function [dir, skip]=head_dir_skip(obj, X, Y, Z, offset)
            % determine arrow head direction
            if nargin <2
                X=obj.XData;
                Y=obj.YData;
                Z=obj.ZData;
            end
            if nargin<5
                offset=obj.HeadOffset;
            end
            skip=1;
            dir=[X(end)-X(end-1),Y(end)-Y(end-1),Z(end)-Z(end-1)];
            l=norm(dir);
            while l<(offset+obj.HeadLength) && skip<length(X)-1
                skip=skip+1;
                dir=[X(end)-X(end-skip),Y(end)-Y(end-skip), Z(end)-Z(end-skip)];
                l=norm(dir);
            end
            dir=dir/l;
        end
        
        function redraw(obj)
            
            X=obj.XData;
            Y=obj.YData;
            Z=obj.ZData;
            
            
            [dir1, dir_skip]=obj.head_dir_skip();
            X_base=X(end)-(obj.HeadOffset+obj.HeadLength)*dir1(1);
            Y_base=Y(end)-(obj.HeadOffset+obj.HeadLength)*dir1(2);
            Z_base=Z(end)-(obj.HeadOffset+obj.HeadLength)*dir1(3);
            
            
            set(obj.Children{1},'XData',[X(1:end-dir_skip),X_base],'YData',[Y(1:end-dir_skip),Y_base],...
                'ZData',[Z(1:end-dir_skip),Z_base],...
                'LineCap',false,'LineStyle',obj.LineStyle,'LineWidth',obj.LineWidth,'Alpha',obj.Alpha,...
                'Color',obj.Color);
            if ~obj.Children{1}.draw
                obj.Children{1}.draw=true;
            end
            
            X_tip=X(end)-obj.HeadOffset*dir1(1);
            Y_tip=Y(end)-obj.HeadOffset*dir1(2);
            Z_tip=Z(end)-obj.HeadOffset*dir1(3);
            set(obj.Children{2},'XData',[X_base,X_tip],'YData',[Y_base,Y_tip],'ZData',[Z_base,Z_tip],...
                'Color',obj.Color,'Alpha',obj.Alpha,'HeadWidth',max(obj.HeadWidth,obj.LineWidth));
            if ~obj.Children{2}.draw
                obj.Children{2}.draw=true;
            end
        end
    end
end
