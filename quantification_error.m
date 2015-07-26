function [a_L,anoise_L,b_Le,bnoise_Le,N ] = quantification_error( a,anoise,b,bnoise,L,e )
% a------- net demand
% anoise-- noisy net demand
% b------- heat demand

[T,temp]=size(a);
N_a=ceil(max(a)/L);
N_anoise=ceil(max(anoise)/L);
N_b=ceil(max(b)/(L*e));
N_bnoise=ceil(max(bnoise)/(L*e));

N=max(N_bnoise,max(N_b,max(N_a,N_anoise)));    %N layers

a_L=zeros(T,N);  % net demand matrix
anoise_L=zeros(T,N); % noisy net demand matrix
b_Le=zeros(T,N);  % heat demand matrix
bnoise_Le=zeros(T,N); % noisy heat demand matrix

for t=1:T
    K_a=floor(a(t,1)/L);
    for i=1:K_a
        a_L(t,i)=L;
    end
    if K_a<N_a
        a_L(t,K_a+1)=a(t,1)-K_a*L;
    end
    
    K_anoise=floor(anoise(t,1)/L);
    for i=1:K_anoise
        anoise_L(t,i)=L;
    end
    if K_anoise<N_anoise
        anoise_L(t,K_anoise+1)=anoise(t,1)-K_anoise*L;
    end
    
    K_b=floor(b(t,1)/(L*e));
    for i=1:K_b
        b_Le(t,i)=L*e;
    end
    if K_b<N_b
        b_Le(t,K_b+1)=b(t,1)-K_b*L*e;
    end
    
    K_bnoise=floor(bnoise(t,1)/(L*e));
    for i=1:K_bnoise
        bnoise_Le(t,i)=L*e;
    end
    if K_bnoise<N_bnoise
        bnoise_Le(t,K_bnoise+1)=bnoise(t,1)-K_bnoise*L*e;
    end
end


end

