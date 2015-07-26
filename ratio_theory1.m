function ratio = ratio_theory1(p,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w)
%FUTURE_THEORY Summary of this function goes here
%   Detailed explanation goes here
pmax=max(p);


r1=1+2*beta*L*(pmax+g*e-co-cm/L)/((pmax+g*e)*(beta*L+w*cm*(L-cm/(pmax+e*g-co))));
r2=1+max((pmax+g*e-co)/(L*co+cm)*max(0,L-Ru),co/cm*max(0,L-Rd));
r3=1+((Tu-1)*(L*pmax+L*g*e+cm)+(Td-1)*L*(pmax+g*e))/beta;
ratio=r1*max(r2,r3);
ratio=min(ratio,L*(pmax+g*e)/(L*co+cm));

end

