function c=cross_product(a,b)
% cross-product between two vectors without unnecessary overhead.

% Version: 1.0.1
% Date: Tue  3 Jul 2018 12:50:16 CEST
% Author: Lucas Jeub
% Email: lucasjeub@gmail.com

ind1=[2,3,1];ind2=[3,1,2];
c=a(ind1).*b(ind2)-a(ind2).*b(ind1);
end
