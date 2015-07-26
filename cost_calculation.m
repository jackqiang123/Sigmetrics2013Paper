function cost = cost_calculation(  a,b,p,co,cm,g,e,beta,y,u )
%COST_CALCULATION Summary of this function goes here
%   Detailed explanation goes here
[T,temp]=size(a);

cost=cm*y(1,1)+co*u(1,1)+p(1,1)*max(0,a(1,1)-u(1,1))+g*max(0,b(1,1)-e*u(1,1))+beta*y(1,1);   %t=1
for t=2:T
    cost=cost+cm*y(t,1)+co*u(t,1)+p(t,1)*max(0,a(t,1)-u(t,1))+g*max(0,b(t,1)-e*u(t,1))+beta*max(0,y(t,1)-y(t-1,1));    
end


end

