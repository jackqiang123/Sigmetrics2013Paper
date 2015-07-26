function [ cost,y,u ] = Offline_MILP(N,a,b,pb,ps,coO,cmO,g,eO,betaO,LO,TuO,TdO,RuO,RdO,Y0,U0,gap)
%OFFLINE Summary of this function goes here
%   Detailed explanation goes here

yub=sum(N);
type=size(N,1);
Tu=zeros(yub,1);
Td=zeros(yub,1);
Ru=zeros(yub,1);
Rd=zeros(yub,1);
co=zeros(yub,1);
cm=zeros(yub,1);
e=zeros(yub,1);
beta=zeros(yub,1);
L=zeros(yub,1);
k=1;
for i=1:type
    for j=1:N(i)
    Tu(k)=TuO(i);
    Td(k)=TdO(i);
    Ru(k)=RuO(i);
    Rd(k)=RdO(i);
    co(k)=coO(i);
    cm(k)=cmO(i);
    e(k)=eO(i);
    beta(k)=betaO(i);
    L(k)=LO(i);
    k=k+1;
    end
end

[Tud,temp]=size(Y0);
[T,temp]=size(a);

%variables
Y=binvar(T,yub,'full');       %Y T*yub 
SY=binvar(T,yub,'full');      %SY T*yub
U=sdpvar(T,yub,'full');       %U T*yub   
V=sdpvar(T,1);           %V T  
B=sdpvar(T,1);           %back to the main grid T  
S=sdpvar(T,1);           %S T 

constraints=[U>=0, V>=0, S>=0,B>=0];

for i=1:yub                %constraints 1   2
    constraints=constraints+[U(1,i)<=L(i)*Y(1,i),Y(1,i)-Y0(Tud,i)<=SY(1,i)];            
    for t=2:T
    constraints=constraints+[U(t,i)<=L(i)*Y(t,i),Y(t,i)-Y(t-1,i)<=SY(t,i)];
    end
end
for i=1:yub        
for t=1:T                  %constraints 3   4
    constraints=constraints+[sum(U(t,:))+V(t,1)-B(t,1)>=a(t,1),e(i)*sum(U(t,:))+S(t,1)>=b(t,1)];
end
end
for i=1:yub                %constraints 5   6
    constraints=constraints+[U(1,i)-U0(1,i)<=Ru(i), U0(1,i)-U(1,i)<=L(i)*(1-Y(1,i))+Rd(i)*Y(1,i)];            
    for t=2:T
        constraints=constraints+[U(t,i)-U(t-1,i)<=Ru(i), U(t-1,i)-U(t,i)<=L(i)*(1-Y(t,i))+Rd(i)*Y(t,i)];  
    end
end

% for i=1:yub                %constraints 5   6
%     constraints=constraints+[U(1,i)-U0(1,i)<=Ru, U0(1,i)-U(1,i)<=Rd];            
%     for t=2:T
%         constraints=constraints+[U(t,i)-U(t-1,i)<=Ru, U(t-1,i)-U(t,i)<=Rd];  
%     end
% end

for i=1:yub                %constraints 7   8
    for tau=2:min(1+Tu(i)-1,T)             %constraint 7  y(1)-y(0)<=y(tau)
        constraints=constraints+[Y(1,i)-Y0(Tud,i)<=Y(tau,i)];
    end
    
    for t=2:T                             %constraint 7  y(t)-y(t-1)<=y(tau)
        for tau=t+1:min(t+Tu(i)-1,T)
            constraints=constraints+[Y(t,i)-Y(t-1,i)<=Y(tau,i)];
        end
    end
    
    for tau=2:min(1+Td(i)-1,T)               %constraint 8  y(0)-y(1)<=1-y(tau)
        constraints=constraints+[Y0(Tud,i)-Y(1,i)<=1-Y(tau,i)]; 
    end
    
    for t=2:T                             %constraint 8  y(t-1)-y(t)<=1-y(tau)
        for tau=t+1:min(t+Td(i)-1,T)
            constraints=constraints+[Y(t-1,i)-Y(t,i)<=1-Y(tau,i)];
        end
    end
    
end

%initial conditions of constraints 7&8
for i=1:yub
    for t=2:Tud
        %constraint 7  y(t)-y(t-1)<=y(tau)
        for tau=t+1:min(t+Tu(i)-1,T)
            if tau>Tud
               constraints=constraints+[Y0(t,i)-Y0(t-1,i)<=Y(tau-Tud,i)];
            end
        end
        %constraint 8  y(t-1)-y(t)<=1-y(tau)
        for tau=t+1:min(t+Td(i)-1,T)
            if tau>Tud
                constraints=constraints+[Y0(t-1,i)-Y0(t,i)<=1-Y(tau-Tud,i)];
            end
        end
    end
end

%objective function
f=sum(sum(SY))*beta(1)+sum(sum(Y))*cm(1)+sum(sum(U))*co(1)+g*sum(S)+pb'*V-ps'*B;

ops = sdpsettings('solver','gurobi','gurobi.MIPgap',gap);

solvesdp(constraints,f,ops);
cost=double(f);

y=double(Y);
u=double(U);

end

