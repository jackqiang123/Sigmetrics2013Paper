function  R = regret_online( Rp,a,b,p,ps,co,cm,g,e,betag,L )
   [c0,temp]=phi(a,b,p,ps,co,cm,g,e,L,0);
   [c1,temp]=phi(a,b,p,ps,co,cm,g,e,L,1);
   R=Rp+c0-c1;
   R=min(0,max(-betag,R));
end

