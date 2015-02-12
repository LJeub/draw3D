function h=arrow(X,Y,Z,varargin)

[color,varargin]=extract_option(varargin,'color',lines(1));
[width,varargin]=extract_option(varargin,'width',0.1);
[head_offset,varargin]=extract_option(varargin,'headoffset',width);
[head_length,varargin]=extract_option(varargin,'headlength',15*width);
[head_width,varargin]=extract_option(varargin,'headwidth',5*width);
[line_style,varargin]=extract_option(varargin,'linestyle','-');


dir1=[X(2)-X(1),Y(2)-Y(1),Z(2)-Z(1)];
l=norm(dir1);
dir1=dir1/l;



    
hl=line3d([X(1),X(2)-(head_offset+head_length)*dir1(1)],[Y(1),Y(2)-(head_offset+head_length)*dir1(2)],[Z(1),Z(2)-(head_offset+head_length)*dir1(3)],...
    'color',color,'width',width,'linestyle',line_style,varargin{:});
    
[X_head,Y_head,Z_head]=circle3d(X(2)-(head_offset+head_length)*dir1(1),Y(2)-(head_offset+head_length)*dir1(2),Z(2)-(head_offset+head_length)*dir1(3),dir1,head_width);
hc=patch(X_head,Y_head,Z_head,color,'edgecolor','none',varargin{:});

X_head(end+1)=X(2)-head_offset*dir1(1);
Y_head(end+1)=Y(2)-head_offset*dir1(2);
Z_head(end+1)=Z(2)-head_offset*dir1(3);

hh=patch(X_head,Y_head,Z_head,color,'edgecolor','none',varargin{:});


    

   % h=arrow3d([verts(1,1),verts(2,1)],[verts(1,2),verts(2,2)],[verts(1,3),verts(2,3)],1-head_length/l,width,head_width,color);
   % set(h,'FaceAlpha',alpha);
%     verts(3,:)=verts(2,:)-head_length*dir1+(head_width+width)*dir2;
%     verts(4,:)=verts(3,:)-head_width*dir2+0.3*head_length*dir1;
%     
%     h=patch('Vertices',verts,'Faces',[1,2,3,4],'FaceColor','flat','FaceVertexCData',repmat(color,4,1),'EdgeColor','none');
    if nargout
        h=[hl,hc,hh];
    end
end