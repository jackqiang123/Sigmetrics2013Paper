function [ cost,y,u] = RHC_error( a,anoise,b,bnoise,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w)

[T,temp]=size(a);
w=min(T-1,w);

Y=zeros(T,yub);
U=zeros(T,yub);

Tud=max(Tu,Td);
Y0=zeros(Tud,yub);
U0=zeros(1,yub);

for t=1:T-w
    if t==1
        [c_temp,Y_temp,U_temp]=Offline_MILP([a(1,1);anoise(2:1+w,1)],[b(1,1);bnoise(2:1+w,1)], p(1:1+w,1),co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.0005);
    elseif t<=Tud
        [c_temp,Y_temp,U_temp]=Offline_MILP([a(t,1);anoise(t+1:t+w,1)],[b(t,1);bnoise(t+1:t+w,1)], p(t:t+w,1),co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,[Y0(t:Tud,:);Y(1:t-1,:)],U(t-1,:),0.0005);
    else
        [c_temp,Y_temp,U_temp]=Offline_MILP([a(t,1);anoise(t+1:t+w,1)],[b(t,1);bnoise(t+1:t+w,1)], p(t:t+w,1),co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y(t-Tud:t-1,:),U(t-1,:),0.0005);        
    end
    if t==T-w
        Y(t:T,:)=Y_temp;
        U(t:T,:)=U_temp;
    else
        Y(t,:)=Y_temp(1,:);
        U(t,:)=U_temp(1,:);
    end
    clear c_temp
    clear Y_temp
    clear U_temp

end
           

Noswitch=0;  % # of turn-on
for i=1:yub
    Noswitch=Noswitch+Y(1,i);
    for t=2:T
        Noswitch=Noswitch+max(0,Y(t,i)-Y(t-1,i));    
    end
end

u=zeros(T,1);
y=zeros(T,1);
for i=1:yub
    u=u+U(:,i);
    y=y+Y(:,i);
end

%cost calculation
cost=beta*Noswitch;
for t=1:T
    cost=cost+cm*y(t,1)+co*u(t,1)+p(t,1)*max(0,a(t,1)-u(t,1))+g*max(0,b(t,1)-e*u(t,1));    
end

end
