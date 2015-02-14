classdef line3d<draw3d
    
    properties (AbortSet)
        LineStyle='-';
        LineWidth=0.1;
    end
    
    methods
        % constructor
        function obj=line3d(X,Y,Z,varargin)
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
        
        function delete(obj)
            delete(obj.patch_group);
        end
                
        function set.LineStyle(obj,line_style)
            obj.LineStyle=line_style;
            obj.redraw;
        end
        
        function set.LineWidth(obj,line_width)
            obj.LineWidth=line_width;
            obj.redraw;
        end
    end
    
    methods (Access=protected)
        %redraw
        function redraw(obj)
            if obj.draw_now
                delete(obj.patches);
                X=obj.XData;
                Y=obj.YData;
                Z=obj.ZData;
                width=obj.LineWidth;
                
                hs=[];

                switch obj.LineStyle
                    
                    case '-'
                        dir=[X(2)-X(1),Y(2)-Y(1),Z(2)-Z(1)];
                        [Xo(1,:),Yo(1,:),Zo(1,:)]=circle3d(X(1),Y(1),Z(1),dir,width);
                        for i=2:length(X)-1
                            dir=([X(i)-X(i-1),Y(i)-Y(i-1),Z(i)-Z(i-1)]+[X(i+1)-X(i),Y(i+1)-Y(i),Z(i+1)-Z(i)])/2;
                            [Xo(i,:),Yo(i,:),Zo(i,:)]=circle3d(X(i),Y(i),Z(i),dir,width);
                        end
                        dir=[X(end)-X(end-1),Y(end)-Y(end-1),Z(end)-Z(end-1)];
                        [Xo(end+1,:),Yo(end+1,:),Zo(end+1,:)]=circle3d(X(end),Y(end),Z(end),dir,width);
                        hs(1)=patch(surf2patch(Xo,Yo,Zo));
                        hs(2)=patch(Xo(1,:),Yo(1,:),Zo(1,:),obj.Color);
                        hs(3)=patch(Xo(end,:),Yo(end,:),Zo(end,:),obj.Color);
                    case '--'
                        
                        dir=[X(2)-X(1),Y(2)-Y(1),Z(2)-Z(1)];
                        [Xo(1,:),Yo(1,:),Zo(1,:)]=circle3d(X(1),Y(1),Z(1),dir,width);
                        dash=5*width;
                        skip=5*width;
                        
                        it=1;
                        Xstep=X(1);
                        Ystep=Y(1);
                        Zstep=Z(1);
                        dist=dash+skip;
                        distmax=norm(dir);
                        dir=dir/distmax;
                        for i=1:length(X)-1
                            while dist<distmax
                                hs(it)=patch(Xo(1,:),Yo(1,:),Zo(1,:),obj.Color);
                                it=it+1;
                                [Xo(2,:),Yo(2,:),Zo(2,:)]=circle3d(Xstep+dash*dir(1),Ystep+dash*dir(2),Zstep+dash*dir(3),dir,width);
                                hs(it)=patch(Xo(2,:),Yo(2,:),Zo(2,:),obj.Color);
                                it=it+1;
                                hs(it)=patch(surf2patch(Xo,Yo,Zo));
                                it=it+1;
                                Xstep=Xstep+(dash+skip)*dir(1);
                                Ystep=Ystep+(dash+skip)*dir(2);
                                Zstep=Zstep+(dash+skip)*dir(3);
                                [Xo(1,:),Yo(1,:),Zo(1,:)]=circle3d(Xstep,Ystep,Zstep,dir,width);
                                hs(it)=patch(Xo(1,:),Yo(1,:),Zo(1,:),obj.Color);
                                it=it+1;
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
                            
                            if dist-skip<distmax
                                [Xo(2,:),Yo(2,:),Zo(2,:)]=circle3d(Xstep+dash*dir(1),Ystep+dash*dir(2),Zstep+dash*dir(3),dir,width);
                                hs(it)=patch(Xo(2,:),Yo(2,:),Zo(2,:),obj.Color);
                                it=it+1;
                                hs(it)=patch(surf2patch(Xo,Yo,Zo));
                                it=it+1;
                                dir=dir_next;
                                Xstep=X(i+1)+dir(1)*(dist-distmax);
                                Ystep=X(i+1)+dir(2)*(dist-distmax);
                                Zstep=Z(i+1)+dir(3)*(dist-distmax);
                                [Xo(1,:),Yo(1,:),Zo(1,:)]=circle3d(Xstep,Ystep,Zstep,dir,width);
                                dist=(distmax-dist)+dash+skip;
                                distmax=distmax_next;
                            else
                                [Xo(2,:),Yo(2,:),Zo(2,:)]=circle3d(X(i+1),Y(i+1),Z(i+1),(dir+dir_next)/2,width);
                                hs(it)=patch(Xo(2,:),Yo(2,:),Zo(2,:),obj.Color);
                                it=it+1;
                                hs(it)=patch(surf2patch(Xo,Yo,Zo));
                                it=it+1;
                                Xo(1,:)=Xo(2,:);
                                Yo(1,:)=Yo(2,:);
                                Zo(1,:)=Zo(2,:);
                                dir=dir_next;
                                Xstep=X(i+1)+(dist-skip-dash-distmax)*dir(1);
                                Ystep=Y(i+1)+(dist-skip-dash-distmax)*dir(2);
                                Zstep=Z(i+1)+(dist-skip-dash-distmax)*dir(3);
                                dist=(dist-distmax);
                                distmax=distmax_next;
                                
                            end
                        end
                    otherwise
                        error('unknown linestyle: %s',linestyle);
                end
                set(hs,'Parent',obj.patch_group);
                set(hs,'FaceAlpha',obj.Alpha,'EdgeColor','none','FaceColor',obj.Color);
                obj.patches=hs;
            end
        end
    end
    
    
    
    
end

