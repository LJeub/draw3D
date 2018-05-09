function c=cross_product(a,b)
% cross-product between two vectors without unnecessary overhead.

% Version:
% Date:
% Author:
% Email:

ind1=[2,3,1];ind2=[3,1,2];
c=a(ind1).*b(ind2)-a(ind2).*b(ind1);
end
