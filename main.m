clear all
clc
load('FCZ5_COLL_a');
load('FCZ5_COLL_b');
load('FCZ5_COLL_p');
load('FCZ5_COLL_wind');
load('FCZ5_gas');       %   $/therm   12 monthes
load('NetWinterEst')
load('NetSummerEst')
load('WH_est')
load('WHS_est')
% t_start=4345;  %% July 1st
% t_end=4488;
% t_m=7;

t_startS=4681;   %% July 15th~21th
t_endS=4848;
t_mS=7;
t_startW=169;  %% Jan 8th~14th      winter
t_endW=336;
t_mW=1;
% t_start=1;  %% Jan 1st
% t_end=12;

% t_start=2160;  %% Apr 1st
% t_end=2640;  



a_est=NetSummerEst;
b_est=WHS_est;
a=FCZ5_COLL_a(t_startS:t_endS);
b=FCZ5_COLL_b(t_startS:t_endS);
p=FCZ5_COLL_p(t_startS:t_endS,1);


gas=FCZ5_gas(t_mS,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh 

[T,temp]=size(a);

L=[3500;3000;2500];               % generator capacity 3000 kw       scale up 30 times
N=[3;4;3];                % # of generators
Tu=[4;3;1];
Td=[4;3;1];
Ru=[1500;1000;1000];
Rd=[1500;1000;1000];

% according to tecogen datasheet
% installed costs with heat recovery    3000$/kw
% variable maintenance                  0.02$/kwh
% lifetime                              20 year
cm=[110;110;110];            %   0.02*3000+3000*3000/20/365/24=113.7
co=[gas/0.28;gas/0.28;gas/0.28];           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency
e=[1.8;1.8;1.8];           %   cogeneration heat efficiency

beta=[1400;1400;1400];        % 5 times full output operational cost ~ 5*(cm+3000*co)  co take mean                    

%only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

[Tg,temp]=size(L);
%offline MILP
yub=sum(N);
Tud=max(Tu,Td);
Y0=zeros(3,sum(N));
U0=zeros(1,sum(N));
ps=ones(168,1)*mean(p)*0.3;
[c_OPT,y_temp,u_temp] = Offline_MILP(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,Y0,U0,0.005);
% u_OPT=zeros(T,1);
% y_OPT=zeros(T,1);
% for i=1:yub
%     u_OPT=u_OPT+u_temp(:,i);
%     y_OPT=y_OPT+y_temp(:,i);
% end
% 
% cr_OPT=(c_GRID-c_OPT)/c_GRID*100;

%   w=24;  %look-ahead window
%  [c_RHC,y_RHC,u_RHC] = RHC_w(N,a_est,b_est,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
 %%compute the cost of RHC
%  Noswitch=0;  % # of turn-on
% for i=1:yub
%     Noswitch=Noswitch+y_RHC(1,i);
%     for t=2:T
%         Noswitch=Noswitch+max(0,y_RHC(t,i)-y_RHC(t-1,i));    
%     end
% end
% 
% u=zeros(T,1);
% y=zeros(T,1);
% for i=1:yub
%     u=u+U(:,i);
%     y=y+Y(:,i);
% end
% 
% %cost calculation
% cost=beta(1)*Noswitch;
% for t=1:T
%     cost=cost+cm(1)*y(t,1)+co(1)*u(t,1)+p(t,1)*max(0,a(t,1)-u(t,1))-ps(t,1)*max(0,u(t,1)-a(t,1))+g*max(0,b(t,1)-e(1)*u(t,1));    
% end
 
 
 
 
    % BKE
%   [c_CHASE,y_CHASE,u_CHASE] = CHASE_w(a_est,b_est,p,ps,g,e,co,cm,L,N,beta,Tu,Td,Ru,Rd,w);
%     
%     cr_CHASE=(c_GRID-c_CHASE)/c_GRID*100;
%     
%     [a_L,b_Le]=quantification(a,b,L(1,1),e(1,1),10); %% N layers         
%                                   %( a_L,b_Le,N,p,co,cm,g,e,betag,L,yub,Tu,Td,Ru,Rd,w)
%     
%     [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,10,p,co(1,1),cm(1,1),g,e(1,1),beta(1,1),L(1,1),10,Tu(1,1),Td(1,1),Ru(1,1),Rd(1,1),w);
%     
%     tt=1:T;
%     figure(1);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(tt,u_CHASE,'b-','LineWidth',3);
% hold on
% plot(tt,u_BKE,'ro--','MarkerSize',9,'LineWidth',3);
% 
%     figure(2);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(tt,y_CHASE,'b-','LineWidth',3);
% hold on
% plot(tt,y_BKE,'ro--','MarkerSize',9,'LineWidth',3);

