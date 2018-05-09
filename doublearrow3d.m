classdef doublearrow3d<arrow3d
    % h=doublearrow3d(X,Y,Z,options)
    % 
    % draw 3-dimensional double arrow between points [X(1),Y(1),Z(1)] and
    % [X(end),Y(end),Z(end)]. 
    %
    % See also: line3d, arrow3d
        
% Version: 1.0
% Date: Wed  9 May 2018 14:22:01 CEST
% Author: Lucas Jeub
% Email: ljeub@iu.edu
    
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
            if length(obj.HeadOffset)==1
                headoffset=repmat(obj.HeadOffset,2,1);
            else
                headoffset=obj.HeadOffset;
            end
            [dir1, skip1]=obj.head_dir_skip(X(end:-1:1),Y(end:-1:1),Z(end:-1:1),headoffset(1));

            X_base=X(1)-(headoffset(1)+obj.HeadLength)*dir1(1);
            Y_base=Y(1)-(headoffset(1)+obj.HeadLength)*dir1(2);
            Z_base=Z(1)-(headoffset(1)+obj.HeadLength)*dir1(3);
            
            
            X_tip=X(1)-headoffset(1)*dir1(1);
            Y_tip=Y(1)-headoffset(1)*dir1(2);
            Z_tip=Z(1)-headoffset(1)*dir1(3);
            
            set(obj.Children{1},...
                'XData',[X_base,X_tip],...
                'YData',[Y_base,Y_tip],...
                'ZData',[Z_base,Z_tip],...
                'HeadWidth',obj.HeadWidth,...
                obj.get_base_options{:});
            if ~obj.Children{1}.draw
                obj.Children{1}.draw=true;
            end
            
            [dir2, skip2]=obj.head_dir_skip(X,Y,Z,headoffset(2));
            
            X_base2=X(end)-(headoffset(2)+obj.HeadLength)*dir2(1);
            Y_base2=Y(end)-(headoffset(2)+obj.HeadLength)*dir2(2);
            Z_base2=Z(end)-(headoffset(2)+obj.HeadLength)*dir2(3);
            
            set(obj.Children{2},...
                'XData',[X_base,X(skip1+1:end-skip2),X_base2],...
                'YData',[Y_base,Y(skip1+1:end-skip2),Y_base2],...
                'ZData',[Z_base,Z(skip1+1:end-skip2),Z_base2],...
                'LineCap',false,...
                'LineStyle',obj.LineStyle,...
                'LineWidth',obj.LineWidth,...
                obj.get_base_options{:});
            if ~obj.Children{2}.draw
                obj.Children{2}.draw=true;
            end
            
            X_tip=X(end)-headoffset(2)*dir2(1);
            Y_tip=Y(end)-headoffset(2)*dir2(2);
            Z_tip=Z(end)-headoffset(2)*dir2(3);
            set(obj.Children{3},...
                'XData',[X_base2,X_tip],...
                'YData',[Y_base2,Y_tip],...
                'ZData',[Z_base2,Z_tip],...
                'HeadWidth',obj.HeadWidth,...
                obj.get_base_options{:});
            if ~obj.Children{3}.draw
                obj.Children{3}.draw=true;
            end
            
            
        end
    end
end
