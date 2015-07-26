function [ cost,y,u ] = Copy_of_Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Ru,Rd,Tu,Td,y0,u0 )
%OFFLINE Summary of this function goes here
%   Detailed explanation goes here

[T,temp]=size(a);

%variables
Y=binvar(T*yub,1);       %Y T*yub 
SY=binvar(T*yub,1);      %SY T*yub
U=sdpvar(T*yub,1);       %U T*yub   
V=sdpvar(T,1);           %V T  
S=sdpvar(T,1);           %S T 

constraints=[U>=0, V>=0, S>=0];

for i=1:yub
    constraints=constraints+[U(1+(i-1)*T,1)<=L*Y(1+(i-1)*T,1),Y(1+(i-1)*T,1)<=SY(1+(i-1)*T,1)];
    for t=2:T
        constraints=constraints+[U(t+(i-1)*T,1)<=L*Y(t+(i-1)*T,1),Y(t+(i-1)*T,1)-Y(t-1+(i-1)*T,1)<=SY(t+(i-1)*T,1)];
    end
end

for t=1:T
    temp=zeros(1,T*yub);
    for i=1:yub
        temp(1,t+(i-1)*T)=1;
    end
    constraints=constraints+[temp*U+V(t,1)>=a(t,1),e*temp*U+S(t,1)>=b(t,1)];
    clear temp
end

coeff1=ones(1,T);
coeff2=ones(1,T*yub);
%objective function
f=coeff2*(beta*SY+cm*Y+co*U)+coeff1*g*S+p'*V; 

ops = sdpsettings('solver','gurobi');

solvesdp(constraints,f,ops);
cost=double(f);
y=double(Y);
u=double(U);

end

