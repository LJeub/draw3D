classdef line3d<matlab.mixin.SetGet
    properties (Hidden,Access = private)
        line_patch_group=hggroup('tag','line3d');
        line_patches=[];
        draw=false;
    end
    
    properties (AbortSet)
        LineStyle='-';
        LineWidth=0.1;
        Color=lines(1);
        Alpha=1;
        Lighting='gouraud';
        BackLighting='reverslit';
        CDataMapping='scaled';
        XData=[];
        YData=[];
        ZData=[];
    end
    
    properties
        Tag='';
    end
    
    properties (SetAccess = immutable)
        Type='line3d';
        Children=[];
    end
    
    properties (Dependent)
        Visible;
        Clipping;
        Annotation;
        Parent;
        HandleVisibility;
    end
    
    
    methods
        % constructor
        function obj=line3d(X,Y,Z,varargin)
            %draw 3d line
            set(obj,varargin{:});
            set(obj.line_patches,'Parent',gca);
            
            obj.XData=X;
            obj.YData=Y;
            obj.ZData=Z;
            obj.draw=true;
            obj.draw_line;
        end
        
        function delete(obj)
            delete(obj.line_patch_group);
        end
        
        
        function set.LineStyle(obj,line_style)
            obj.LineStyle=line_style;
            obj.draw_line;
        end
        
        function set.LineWidth(obj,line_width)
            obj.LineWidth=line_width;
            obj.draw_line;
        end
        
        function set.Color(obj,color)
            obj.Color=color;
            obj.update_patches('FaceColor',color);
        end
        
        function set.Alpha(obj,alpha)
            obj.Alpha=alpha;
            obj.update_patches('FaceAlpha',alpha);
        end
        
        function set.Lighting(obj,light)
            obj.Lighting=light;
            obj.update_patches('FaceLighting',light);
        end
        
        function set.BackLighting(obj,light)
            obj.BackLighting=light;
            obj.update_patches('BackFaceLighting',light);
        end
        
        function set.CDataMapping(obj,mapping)
            obj.CDataMapping=mapping;
            obj.update_patches('CDataMapping',mapping);
        end
        
        function set.XData(obj,xdata)
            obj.XData=xdata;
            obj.draw_line;
        end
        
        function set.YData(obj,ydata)
            obj.YData=ydata;
            obj.draw_line;
        end
        
        function set.ZData(obj,zdata)
            obj.ZData=zdata;
            obj.draw_line;
        end
        
        function set.Visible(obj,visible)
            set(obj.line_patch_group,'Visible',visible);
        end
        
        function visible=get.Visible(obj)
            visible=get(obj.line_patch_group,'Visible');
        end
        
        function set.Clipping(obj,clipping)
            set(obj.line_patch_group,'Clipping',clipping);
        end
        
        function clipping=get.Clipping(obj)
            clipping=get(obj.line_patch_group,'Clipping');
        end
        
        function set.Annotation(obj,annotation)
            set(obj.line_patch_group,'Annotation',annotation);
        end
        
        function annotation=get.Annotation(obj)
            annotation=get(obj.line_patch_group,'Annotation');
        end
        
        function set.Parent(obj,parent)
            set(obj.line_patch_group,'Parent',parent);
        end
        
        function parent=get.Parent(obj)
            parent=get(obj.line_patch_group,'Parent');
        end
        
        function set.HandleVisibility(obj,visibility)
            set(obj.line_patch_group,'HandleVisibility',visibility);
        end
        
        function visibility=get.HandleVisibility(obj)
            visibility=get(obj.line_patch_group,'HandleVisibility');
        end
    end
    
    methods (Access=private)
        %redraw
        function draw_line(obj)
            if obj.draw
                delete(obj.line_patches);
                X=obj.XData;
                Y=obj.YData;
                Z=obj.ZData;
                width=obj.LineWidth;
                
                hs=[];
                
                nextplot=get(gca,'nextplot');
                set(gca,'nextplot','add');
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
                        hs(1)=patch(Xo(1,:),Yo(1,:),Zo(1,:),obj.Color);
                        it=2;
                        Xstep=X(1);
                        Ystep=Y(1);
                        Zstep=Z(1);
                        dist=3*width;
                        distmax=norm(dir);
                        dir=dir/distmax;
                        for i=1:length(X)-1
                            while dist<distmax
                                [Xo(2,:),Yo(2,:),Zo(2,:)]=circle3d(Xstep+2*width*dir(1),Ystep+2*width*dir(2),Zstep+2*width*dir(3),dir,width);
                                hs(it)=patch(Xo(2,:),Yo(2,:),Zo(2,:),obj.Color);
                                it=it+1;
                                hs(it)=patch(surf2patch(Xo,Yo,Zo));
                                it=it+1;
                                Xstep=Xstep+3*width*dir(1);
                                Ystep=Ystep+3*width*dir(2);
                                Zstep=Zstep+3*width*dir(3);
                                [Xo(1,:),Yo(1,:),Zo(1,:)]=circle3d(Xstep,Ystep,Zstep,dir,width);
                                hs(it)=patch(Xo(1,:),Yo(1,:),Zo(1,:),obj.Color);
                                it=it+1;
                                dist=dist+3*width;
                            end
                            
                            if i<length(X)-1
                                dir_next=[X(i+2)-X(i+1),Y(i+2)-Y(i+1),Z(i+2)-Z(i+1)];
                                distmax_next=norm(dir_next);
                                dir_next=dir_next/distmax_next;
                            else
                                dir_next=dir;
                                distmax_next=distmax;
                            end
                            
                            if dist-width<distmax
                                [Xo(2,:),Yo(2,:),Zo(2,:)]=circle3d(Xstep+2*width*dir(1),Ystep+2*width*dir(2),Zstep+2*width*dir(3),dir,width);
                                hs(it)=patch(Xo(2,:),Yo(2,:),Zo(2,:),obj.Color);
                                it=it+1;
                                hs(it)=patch(surf2patch(Xo,Yo,Zo));
                                it=it+1;
                                dir=dir_next;
                                Xstep=X(i+1)+dir(1)*(dist-distmax);
                                Ystep=X(i+1)+dir(2)*(dist-distmax);
                                Zstep=Z(i+1)+dir(3)*(dist-distmax);
                                [Xo(1,:),Yo(1,:),Zo(1,:)]=circle3d(Xstep,Ystep,Zstep,dir,width);
                                hs(it)=patch(Xo(1,:),Yo(1,:),Zo(1,:),obj.Color);
                                it=it+1;
                                dist=(distmax-dist)+3*width;
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
                                Xstep=X(i+1)+(dist-3*width-distmax)*dir(1);
                                Ystep=Y(i+1)+(dist-3*width-distmax)*dir(2);
                                Zstep=Z(i+1)+(dist-3*width-distmax)*dir(3);
                                dist=(dist-distmax);
                                distmax=distmax_next;
                                
                            end
                        end
                        set(gca,'nextplot',nextplot);
                    otherwise
                        error('unknown linestyle: %s',linestyle);
                end
                set(hs,'Parent',obj.line_patch_group,'FaceAlpha',obj.Alpha,'EdgeColor','none','FaceColor',obj.Color);
                obj.line_patches=hs;
            end
        end
        
        function update_patches(obj,property,value)
            if obj.draw
                set(obj.line_patches,property,value);
            end
        end
    end
    
    
    
    
end

