classdef draw3d<matlab.mixin.SetGet
    
    % draw3d base class
    properties (Hidden,Access = protected)
        patch_group;
        patches=[];
    end
    
    properties (AbortSet)
        Color=lines(1);
        Alpha=1;
        Lighting='gouraud';
        BackLighting='reverselit';
        CDataMapping='scaled';
        XData=[];
        YData=[];
        ZData=[];
        draw=false;
    end
    
    properties
        Tag='';
    end
    
    properties (SetAccess = protected)
        Children={};
        Parent=[];
    end
    
    properties (Dependent, SetAccess=immutable)
        Type;
    end
    
    properties(Access=protected)
        type_store;
        setting=false;
        dirty=false;
    end
    
    properties (Dependent)
        Visible;
        Clipping;
        Annotation;
        
        HandleVisibility;
    end
    
    methods
        
        function obj=draw3d(X,Y,Z,varargin)
            obj.patch_group=hggroup('Parent',gca,'UserData',obj);
            set(obj.patch_group,'DeleteFcn',@obj.delete_callback);
            if nargin>0
                obj.XData=X;
                obj.YData=Y;
                obj.ZData=Z;
                set(obj,varargin{:});
            end
        end
        
        function delete(obj)
            delete(obj.patch_group);
            obj.delete_children;
        end
        
        function set(obj,varargin)
            obj.setting=true;
            set@matlab.mixin.SetGet(obj,varargin{:});
            obj.setting=false;
            if obj.dirty
                obj.request_redraw;
            end
        end
        
        function type=get.Type(obj)
            type=obj.type_store;
        end
        
        function set.draw(obj,value)
            obj.draw=value;
            if value
                obj.request_redraw;
            end
        end
        
        function set.patches(obj,handles)
            obj.patches=handles;
            obj.set_patches();
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
            obj.request_redraw;
        end
        
        function set.YData(obj,ydata)
            obj.YData=ydata;
            obj.request_redraw;
        end
        
        function set.ZData(obj,zdata)
            obj.ZData=zdata;
            obj.request_redraw;
        end
        
        function set.Parent(obj,parent)
            obj.Parent=parent;
            obj.add_parent(parent);
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
                set(obj.patches,property,value);
                for i=1:length(obj.Children)
                    obj.Children{i}.update_patches(property,value);
                end
            end
        end
        
        function add_parent(obj,parent)
            set(obj.patch_group,'Parent',parent.patch_group);
        end
        
        function add_child(obj,child)
            obj.Children{end+1}=child;
            child.Parent=obj;
        end
        
        function add_patches(obj,h)
            obj.patches=[obj.patches,h];
        end
        
        function set_patches(obj)
            set(obj.patches,'Parent',obj.patch_group,'FaceColor',obj.Color,'FaceAlpha',obj.Alpha,...
                'FaceLighting',obj.Lighting,'BackFaceLighting',obj.BackLighting,...
                'CDataMapping',obj.CDataMapping,'EdgeColor','none');
        end
        
        function options=get_base_options(obj)
            options={'Color',obj.Color,'Alpha',obj.Alpha,'Lighting',obj.Lighting,...
                'BackLighting',obj.BackLighting,'CDataMapping',obj.CDataMapping};
        end
        
        function delete_callback(obj,~,~)
            obj.delete();
        end
        
        function delete_children(obj)
            for i=1:length(obj.Children)
                delete(obj.Children{i});
            end
            obj.Children={};
        end
        
        function comp=draw_now(obj)
            comp=~obj.setting&&obj.draw&&~(isempty(obj.XData)||isempty(obj.YData)||isempty(obj.ZData));
        end
        
        function request_redraw(obj)
            if obj.draw_now
                obj.redraw
                obj.dirty=false;
            else
                obj.dirty=true;
            end
        end
    end
    
    methods (Access=protected, Abstract)
        redraw(obj)
    end
end

