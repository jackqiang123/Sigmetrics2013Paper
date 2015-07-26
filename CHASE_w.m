function [ cost,y,u] = CHASE_w( a,b,p,ps,g,e,co,cm,Lg,Ng,betag,Tu,Td,Ru,Rd,w)

[T,temp]=size(a);

[N_tg,temp]=size(co);   % N_tg types of generators

p1=ones(T+w,1);
p1(1:T,1)=p;
p2=ones(T+w,1);
p2(1:T,1)=ps;

R=-ones(max(Ng),N_tg);
for i=1:max(Ng)
    R(i,:)=-betag';   %regret function
end

Y=zeros(T,max(Ng),N_tg);
U=zeros(T,max(Ng),N_tg);

y=zeros(T,N_tg);
u=zeros(T,N_tg);

threshold_on=zeros(N_tg,1);
threshold_off=-betag;

LgN=Lg.*Ng;
A=zeros(T+w,max(Ng),N_tg);  % electricity demand
B=zeros(T+w,max(Ng),N_tg);  % heat demand
for type=1:N_tg
    [A(1:T,1:Ng(type,1),type),B(1:T,1:Ng(type,1),type)]=quantification(min(LgN(type,1)*ones(T,1),max(zeros(T,1),a-sum(LgN(1:type-1,1))*ones(T,1))),min(e(type,1)*LgN(type,1)*ones(T,1),max(zeros(T,1),b-sum(e(1:type-1,1).*LgN(1:type-1,1))*ones(T,1))),Lg(type,1),e(type,1),Ng(type,1));
end

cost=0;

for type=1:N_tg        %% N_tg types
for i=1:Ng(type,1)             %% Ng generators   regret function
    for t=1:1
        Rp=R(i,type);
        for j=t:t+w
            R(i,type)=regret_online( R(i,type),A(j,i,type),B(j,i,type),p1(j,1),p2(j,1),co(type,1),cm(type,1),g,e(type,1),betag(type,1),Lg(type,1) );        
            if R(i,type)>=threshold_on(type,1)
               Y(t,i,type)=1;
               break
            elseif R(i,type)<=threshold_off(type,1)
                Y(t,i,type)=0;
                break
            else
               Y(t,i,type)=0;
            end
        end    
        R(i,type)=regret_online( Rp,A(t,i,type),B(t,i,type),p1(t,1),p2(t,1),co(type,1),cm(type,1),g,e(type,1),betag(type,1),Lg(type,1) );  
        
        [temp,U(t,i,type)]=phi(A(t,i,type),B(t,i,type),p1(t,1),p2(t,1),co(type,1),cm(type,1),g,e(type,1),Lg(type,1),Y(t,i,type));  
        %nonideal          ramp limit
        U(t,i,type)=min(U(t,i,type),Ru(type,1));   
        cost=cost+betag(type,1)*Y(t,i,type);
    end     
    
    for t=2:T
        Rp=R(i,type);
        for j=t:t+w
            R(i,type)=regret_online( R(i,type),A(j,i,type),B(j,i,type),p1(j,1),p2(j,1),co(type,1),cm(type,1),g,e(type,1),betag(type,1),Lg(type,1) );        
            if (R(i,type)>=threshold_on(type,1))&&min_on_off(Y(1:t-1,i,type),Td(type,1),1)
               Y(t,i,type)=1;
               break
            elseif (R(i,type)<=threshold_off(type,1))&&min_on_off(Y(1:t-1,i,type),Tu(type,1),2)
                Y(t,i,type)=0;
                break
            else
               Y(t,i,type)=Y(t-1,i,type);
            end
        end    
        R(i,type)=regret_online( Rp,A(t,i,type),B(t,i,type),p1(t,1),p2(t,1),co(type,1),cm(type,1),g,e(type,1),betag(type,1),Lg(type,1) );  
        
        [temp,U(t,i,type)]=phi(A(t,i,type),B(t,i,type),p1(t,1),p2(t,1),co(type,1),cm(type,1),g,e(type,1),Lg(type,1),Y(t,i,type));        
        %nonideal          ramp limit
        U(t,i,type)=min(U(t,i,type),Ru(type,1)+U(t-1,i,type));   
        U(t,i,type)=max(U(t,i,type),U(t-1,i,type)-Rd(type,1)); 
        cost=cost+betag(type,1)*max(0,Y(t,i,type)-Y(t-1,i,type));
    end

end
end

for type=1:N_tg
for i=1:Ng(type,1)
    y(:,type)=y(:,type)+Y(:,i,type);
    u(:,type)=u(:,type)+U(:,i,type);
end
end

%cost calculation
for t=1:T
    cost=cost+y(t,:)*cm+u(t,:)*co+p(t,1)*max(0,a(t,1)-sum(u(t,:)))-p2(t,1)*max(0,sum(u(t,:))-a(t,1))+g*max(0,b(t,1)-u(t,:)*e(1));    
end

end
