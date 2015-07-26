function [a_L,b_Le,N ] = quantification( a,b,L,e )
% a------- elec demand
% b------- heat demand

%step----------the quantification step
[T,temp]=size(a);
N_a=ceil(max(a)/L);
N_b=ceil(max(b)/(L*e));

N=max(N_a,N_b);    %N layers

a_L=zeros(T,N);  % elec demand matrix
b_Le=zeros(T,N);  % heat demand matrix

for t=1:T
    K_a=floor(a(t,1)/L);
    for i=1:K_a
        a_L(t,i)=L;
    end
    if K_a<N_a
        a_L(t,K_a+1)=a(t,1)-K_a*L;
    end
    K_b=floor(b(t,1)/(L*e));
    for i=1:K_b
        b_Le(t,i)=L*e;
    end
    if K_b<N_b
        b_Le(t,K_b+1)=b(t,1)-K_b*L*e;
    end
end


end

