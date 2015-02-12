classdef draw3d<matlab.mixin.SetGet
    properties (Hidden,Access = draw3dACL)
        patch_group=hggroup('Parent',gca);
        patches=[];
    end
    
    properties (AbortSet)
        Color=lines(1);
        Alpha=1;
        Lighting='gouraud';
        BackLighting='reverslit';
        CDataMapping='scaled';
        XData=[];
        YData=[];
        ZData=[];
        draw=false;
    end
    
    properties
        Tag='';
    end
    
    properties (SetAccess = immutable)
        Children=[];
    end
    
    properties(SetAccess = immutable,Abstract = true)
        Type;
    end
    
    properties (Dependent)
        Visible;
        Clipping;
        Annotation;
        Parent;
        HandleVisibility;
    end
    
    methods
        
        %constructor
        function obj=draw3d(X,Y,Z,varargin)
            %parse options
            set(obj,varargin{:});
            obj.XData=X;
            obj.YData=Y;
            obj.ZData=Z;
            obj.draw=true;
        end
        
        function delete(obj)
            delete(obj.patch_group);
        end
        
        function set.draw(obj,value)
            obj.draw=value;
            if value
                obj.redraw;
            end
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
            obj.redraw;
        end
        
        function set.YData(obj,ydata)
            obj.YData=ydata;
            obj.redraw;
        end
        
        function set.ZData(obj,zdata)
            obj.ZData=zdata;
            obj.redraw;
        end
        
        function set.Visible(obj,visible)
            set(obj.patch_group,'Visible',visible);
        end
        
        function visible=get.Visible(obj)
            visible=get(obj.patch_group,'Visible');
        end
        
        function set.Clipping(obj,clipping)
            set(obj.patch_group,'Clipping',clipping);
        end
        
        function clipping=get.Clipping(obj)
            clipping=get(obj.patch_group,'Clipping');
        end
        
        function set.Annotation(obj,annotation)
            set(obj.patch_group,'Annotation',annotation);
        end
        
        function annotation=get.Annotation(obj)
            annotation=get(obj.patch_group,'Annotation');
        end
        
        function set.Parent(obj,parent)
            set(obj.patch_group,'Parent',parent);
        end
        
        function parent=get.Parent(obj)
            parent=get(obj.patch_group,'Parent');
        end
        
        function set.HandleVisibility(obj,visibility)
            set(obj.patch_group,'HandleVisibility',visibility);
        end
        
        function visibility=get.HandleVisibility(obj)
            visibility=get(obj.patch_group,'HandleVisibility');
        end
    end
    
    methods (Access=protected)
        function update_patches(obj,property,value)
            if obj.draw
                set(obj.line_patches,property,value);
            end
        end
    end
    
    methods (Access=protected, Abstract=true)
        redraw(obj)
    end
end
        
    