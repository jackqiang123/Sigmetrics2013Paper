function  [output,u] = phi(a,b,p,ps,co,cm,g,e,L,y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if co>=p+g*e
    u=0;
elseif co<=p
    u=min(L*y,a);
else
    u=min(L*y,min(b/e,a));
end

output=co*u+p*max(a-u,0)-ps*max(u-a,0)+g*max(b-e*u,0)+cm*y;

end

