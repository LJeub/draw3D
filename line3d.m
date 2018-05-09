classdef line3d<draw3d
    %  h = line3d(X,Y,Z,options)
    %
    % draw a 3-dimensional line between points
        
    % Version:
    % Date:
    % Author:
    % Email:
    
    properties (AbortSet)
        LineStyle='-'; % line style: '-' (default), '--', ':'
        LineWidth=0.1; % line width in data units
        LineCap=true; % terminate line with sphere
    end
    
    methods
        % constructor
        function obj=line3d(X,Y,Z,varargin)
            % draw a 3-dimensional line between points
            obj.type_store='line3d';
            if nargin>0
                set(obj.patch_group,'Tag','line3d');
                obj.XData=X;
                obj.YData=Y;
                obj.ZData=Z;
                set(obj,varargin{:});
                obj.draw=true;
            end
        end
        
        function set.LineStyle(obj,line_style)
            obj.LineStyle=line_style;
            obj.request_redraw;
        end
        
        function set.LineWidth(obj,line_width)
            obj.LineWidth=line_width;
            obj.request_redraw;
        end
    end
    
    methods (Hidden,Access=protected)
        %redraw
        function redraw(obj)
            delete(obj.patches);
            obj.delete_children;
            obj.patches=[];
            
            switch obj.LineStyle
                
                case '-'
                    obj.draw_line(obj.XData,obj.YData,obj.ZData);
                case '--'
                    obj.draw_dashed_line(5,5);
                    
                case ':'
                    obj.draw_dashed_line(0,2);
                    
                otherwise
                    error('unknown LineStyle: %s',obj.LineStyle);
                    
            end
            if ~obj.LineCap
                delete(obj.Children{1});
                obj.Children(1)=[];
                delete(obj.Children{end});
                obj.Children(end)=[];
            end
                
        end
        
        function draw_line(obj,X,Y,Z)
            width=obj.LineWidth/2;
            obj.add_child(sphere3d(X(1),Y(1),Z(1),'Radius',width,obj.get_base_options{:}));
            for i=1:length(X)-1
                dir=[X(i+1)-X(i),Y(i+1)-Y(i),Z(i+1)-Z(i)];
                if norm(dir)>obj.LineWidth/100
                    dir=dir/norm(dir);
                    [Xo(1,:),Yo(1,:),Zo(1,:)]=circle3d(X(i),Y(i),Z(i),dir,width,obj.AngularResolution);
                    [Xo(2,:),Yo(2,:),Zo(2,:)]=circle3d(X(i+1),Y(i+1),Z(i+1),dir,width,obj.AngularResolution);
                    obj.add_patches(patch(surf2patch(Xo,Yo,Zo)));
                    obj.add_child(sphere3d(X(i+1),Y(i+1),Z(i+1),'Radius',width,obj.get_base_options{:}));
                end
            end
            
        end
        
        function draw_dashed_line(obj,dash,skip)
            X=obj.XData;
            Y=obj.YData;
            Z=obj.ZData;
            
            dir=[X(2)-X(1),Y(2)-Y(1),Z(2)-Z(1)];
            
            dash=dash*obj.LineWidth;
            skip=skip*obj.LineWidth;
            
            Xstep=X(1);
            Ystep=Y(1);
            Zstep=Z(1);
            dist=dash+skip;
            distmax=norm(dir);
            dir=dir/distmax;
            for i=1:length(X)-1
                while dist<distmax
                    obj.draw_line([Xstep,Xstep+dash*dir(1)],[Ystep,Ystep+dash*dir(2)],[Zstep,Zstep+dash*dir(3)]);
                    Xstep=Xstep+(dash+skip)*dir(1);
                    Ystep=Ystep+(dash+skip)*dir(2);
                    Zstep=Zstep+(dash+skip)*dir(3);
                    dist=dist+dash+skip;
                end
                
                if i<length(X)-1
                    dir_next=[X(i+2)-X(i+1),Y(i+2)-Y(i+1),Z(i+2)-Z(i+1)];
                    distmax_next=norm(dir_next);
                    dir_next=dir_next/distmax_next;
                else
                    dir_next=dir;
                    distmax_next=distmax;
                end
                
                if dist-distmax<=skip
                    obj.draw_line([Xstep,Xstep+dash*dir(1)],[Ystep,Ystep+dash*dir(2)],[Zstep,Zstep+dash*dir(3)]);
                    skip2=dist-distmax;
                    dir=dir_next;
                    Xstep=X(i+1)+dir(1)*(skip2);
                    Ystep=X(i+1)+dir(2)*(skip2);
                    Zstep=Z(i+1)+dir(3)*(skip2);
                    dist=skip2+dash+skip;
                    distmax=distmax_next;
                else
                    if i<length(X)-1
                        dash2=dist-skip-distmax;
                        obj.draw_line([Xstep,X(i+1),X(i+1)+dash2*dir_next(1)],[Ystep,Y(i+1),Y(i+1)+dash2*dir_next(2)],[Zstep,Z(i+1),Z(i+1)+dash2*dir_next(3)]);
                        dir=dir_next;
                        Xstep=X(i+1)+(dash2+skip)*dir(1);
                        Ystep=Y(i+1)+(dash2+skip)*dir(2);
                        Zstep=Z(i+1)+(dash2+skip)*dir(3);
                        dist=dash2+skip+dash+skip;
                        distmax=distmax_next;
                    else
                        obj.draw_line([Xstep,X(i+1)],[Ystep,Y(i+1)],[Zstep,Z(i+1)]);
                    end
                end
            end
        end
        
        
        
    end
end

