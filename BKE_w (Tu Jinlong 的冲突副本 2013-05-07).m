function [ cost,y,u ] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,betag,L,yub,Tu,Td,Ru,Rd,w)

[T,temp]=size(a_L);

yub=min(N,yub);

R=-betag*ones(1,yub);   % regret function
                        % yub generators

Y=zeros(T,yub);
U=zeros(T,yub);

a=zeros(T,1);
b=zeros(T,1);
y=zeros(T,1);
u=zeros(T,1);

threshold_on=0;
threshold_off=-betag;

p1=ones(T+w,1);
p1(1:T,1)=p;

a1=zeros(T+w,yub);
a1(1:T,1:yub)=a_L(1:T,1:yub);

b1=zeros(T+w,yub);
b1(1:T,1:yub)=b_Le(1:T,1:yub);

for i=1:yub              %% yub generators regret function
    for t=1:1         
        Rp=R(1,i);
        for j=t:t+w
            R(1,i)=regret_online(R(1,i),a1(j,i),b1(j,i),p1(j,1),co,cm,g,e,betag,L );        % ( Rp,a,b,p,co,cm,g,e,betag )
            if R(1,i)>=threshold_on
               Y(t,i)=1;
               break
            elseif R(1,i)<=threshold_off
                Y(t,i)=0;
                break
            else
               Y(t,i)=0;
            end
        end    
        R(1,i)=regret_online(Rp,a1(t,i),b1(t,i),p(t,1),co,cm,g,e,betag,L );  
        
        [temp,U(t,i)]=phi(a1(t,i),b1(t,i),p(t,1),co,cm,g,e,L,Y(t,i));        
        %nonideal          ramp limit
        U(t,i)=min(U(t,i),Ru);          
    end
    
    for t=2:T         
        Rp=R(1,i);
        for j=t:t+w
            R(1,i)=regret_online( R(1,i),a1(j,i),b1(j,i),p1(j,1),co,cm,g,e,betag,L );        
            if (R(1,i)>=threshold_on)&&min_on_off(Y(1:t-1,i),Td,1)
               Y(t,i)=1;
               break
            elseif (R(1,i)<=threshold_off)&&min_on_off(Y(1:t-1,i),Tu,2)
                Y(t,i)=0;
                break
            else
               Y(t,i)=Y(t-1,i);
            end
        end    
        R(1,i)=regret_online(Rp,a1(t,i),b1(t,i),p(t,1),co,cm,g,e,betag,L );  
        
        [temp,U(t,i)]=phi(a1(t,i),b1(t,i),p(t,1),co,cm,g,e,L,Y(t,i));
        %nonideal          ramp limit
        U(t,i)=min(U(t,i),Ru+U(t-1,i)); 
        U(t,i)=max(U(t,i),U(t-1,i)-Rd);        
    end
end


for i=1:N
    a=a+a_L(:,i);
    b=b+b_Le(:,i);
end

for i=1:yub
    y=y+Y(:,i);
    u=u+U(:,i);
end

Noswitch=0;  % # of turn-on
for i=1:yub
    Noswitch=Noswitch+Y(1,i);
    for t=2:T
        Noswitch=Noswitch+max(0,Y(t,i)-Y(t-1,i));    
    end
end

%cost calculation
cost=betag*Noswitch;
for t=1:T
    cost=cost+cm*y(t,1)+co*u(t,1)+p(t,1)*max(0,a(t,1)-u(t,1))+g*max(0,b(t,1)-e*u(t,1));    
end

% cost = cost_calculation(  a,b,p,co,cm,g,e,betag,y,u );

end
