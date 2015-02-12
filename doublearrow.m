function h=doublearrow(X,Y,Z,varargin)

[color,varargin]=extract_option(varargin,'color',lines(1));
[width,varargin]=extract_option(varargin,'width',0.1);
[head_offset,varargin]=extract_option(varargin,'headoffset',width);
[head_length,varargin]=extract_option(varargin,'headlength',15*width);
[head_width,varargin]=extract_option(varargin,'headwidth',5*width);
[line_style,varargin]=extract_option(varargin,'linestyle','-');


dir1=[X(2)-X(1),Y(2)-Y(1),Z(2)-Z(1)];
l=norm(dir1);
dir1=dir1/l;

X1=X(1)+(head_offset+head_length)*dir1(1);
X2=X(2)-(head_offset+head_length)*dir1(1);
Y1=Y(1)+(head_offset+head_length)*dir1(2);
Y2=Y(2)-(head_offset+head_length)*dir1(2);
Z1=Z(1)+(head_offset+head_length)*dir1(3);
Z2=Z(2)-(head_offset+head_length)*dir1(3);

    
hl=line3d([X1,X2],[Y1,Y2],[Z1,Z2],...
    'color',color,'width',width,'linestyle',line_style,varargin{:});
    
[X_head,Y_head,Z_head]=circle3d(X1,Y1,Z1,dir1,head_width);
hc1=patch(X_head,Y_head,Z_head,color,'edgecolor','none',varargin{:});

X_head(end+1)=X(1)+head_offset*dir1(1);
Y_head(end+1)=Y(1)+head_offset*dir1(2);
Z_head(end+1)=Z(1)+head_offset*dir1(3);

hh1=patch(X_head,Y_head,Z_head,color,'edgecolor','none',varargin{:});

[X_head,Y_head,Z_head]=circle3d(X2,Y2,Z2,dir1,head_width);
hc2=patch(X_head,Y_head,Z_head,color,'edgecolor','none',varargin{:});

X_head(end+1)=X(2)-head_offset*dir1(1);
Y_head(end+1)=Y(2)-head_offset*dir1(2);
Z_head(end+1)=Z(2)-head_offset*dir1(3);

hh2=patch(X_head,Y_head,Z_head,color,'edgecolor','none',varargin{:});

    if nargout
        h=[hl,hc1,hh1,hc2,hh2];
    end
end