function [ cost,y,u ] = Offline_MILP_battery( a,b,wind,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,batt,Ramp_batt,Y0,U0, gap)
                                      %     ( a1,b,wind1,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,batt,Y0,U0,0.005);
%OFFLINE Summary of this function goes here
%   Detailed explanation goes here

[Tud,temp]=size(Y0);
[T,temp]=size(a);

%variables
Y=binvar(T,yub,'full');       %Y T*yub 
SY=binvar(T,yub,'full');      %SY T*yub
U=sdpvar(T,yub,'full');       %U T*yub   
V=sdpvar(T,1);           %V T  
S=sdpvar(T,1);           %S T 
Ba=sdpvar(T,1);           %B T 

constraints=[U>=0, V>=0, S>=0, Ba>=0];

for i=1:yub                %constraints 1   2
    constraints=constraints+[U(1,i)<=L*Y(1,i),Y(1,i)-Y0(Tud,i)<=SY(1,i)];            
    for t=2:T
        constraints=constraints+[U(t,i)<=L*Y(t,i),Y(t,i)-Y(t-1,i)<=SY(t,i)];
    end
end

constraints=constraints+[Ba(1,1)<=Ramp_batt,sum(U(1,:))+V(1,1)+wind(1,1)>=a(1,1)+Ba(1,1),e*sum(U(t,:))+S(t,1)>=b(t,1)];
for t=2:T                  %constraints 3   4
    constraints=constraints+[Ba(t,1)<=batt,sum(U(t,:))+V(t,1)+wind(t,1)>=a(t,1)+Ba(t,1)-Ba(t-1,1),e*sum(U(t,:))+S(t,1)>=b(t,1)];
    constraints=constraints+[Ba(t,1)-Ba(t-1,1)<=Ramp_batt, Ba(t-1,1)-Ba(t,1)<=Ramp_batt];
end

for i=1:yub                %constraints 5   6
    constraints=constraints+[U(1,i)-U0(1,i)<=Ru, U0(1,i)-U(1,i)<=L*(1-Y(1,i))+Rd*Y(1,i)];            
    for t=2:T
        constraints=constraints+[U(t,i)-U(t-1,i)<=Ru, U(t-1,i)-U(t,i)<=L*(1-Y(t,i))+Rd*Y(t,i)];  
    end
end

% for i=1:yub                %constraints 5   6
%     constraints=constraints+[U(1,i)-U0(1,i)<=Ru, U0(1,i)-U(1,i)<=Rd];            
%     for t=2:T
%         constraints=constraints+[U(t,i)-U(t-1,i)<=Ru, U(t-1,i)-U(t,i)<=Rd];  
%     end
% end

for i=1:yub                %constraints 7   8
    for tau=2:min(1+Tu-1,T)             %constraint 7  y(1)-y(0)<=y(tau)
        constraints=constraints+[Y(1,i)-Y0(Tud,i)<=Y(tau,i)];
    end
    
    for t=2:T                             %constraint 7  y(t)-y(t-1)<=y(tau)
        for tau=t+1:min(t+Tu-1,T)
            constraints=constraints+[Y(t,i)-Y(t-1,i)<=Y(tau,i)];
        end
    end
    
    for tau=2:min(1+Td-1,T)               %constraint 8  y(0)-y(1)<=1-y(tau)
        constraints=constraints+[Y0(Tud,i)-Y(1,i)<=1-Y(tau,i)]; 
    end
    
    for t=2:T                             %constraint 8  y(t-1)-y(t)<=1-y(tau)
        for tau=t+1:min(t+Td-1,T)
            constraints=constraints+[Y(t-1,i)-Y(t,i)<=1-Y(tau,i)];
        end
    end
    
end

%initial conditions of constraints 7&8
for i=1:yub
    for t=2:Tud
        %constraint 7  y(t)-y(t-1)<=y(tau)
        for tau=t+1:min(t+Tu-1,T)
            if tau>Tud
               constraints=constraints+[Y0(t,i)-Y0(t-1,i)<=Y(tau-Tud,i)];
            end
        end
        %constraint 8  y(t-1)-y(t)<=1-y(tau)
        for tau=t+1:min(t+Td-1,T)
            if tau>Tud
                constraints=constraints+[Y0(t-1,i)-Y0(t,i)<=1-Y(tau-Tud,i)];
            end
        end
    end
end

%objective function
f=sum(sum(SY))*beta+sum(sum(Y))*cm+sum(sum(U))*co+g*sum(S)+p'*V;

ops = sdpsettings('solver','gurobi','gurobi.MIPgap',gap);

solvesdp(constraints,f,ops);
cost=double(f);

y=double(Y);
u=double(U);

end

