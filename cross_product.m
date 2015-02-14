function c=cross_product(a,b)

ind1=[2,3,1];ind2=[3,1,2];
c=a(ind1).*b(ind2)-a(ind2).*b(ind1);
end