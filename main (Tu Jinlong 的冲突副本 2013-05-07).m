clear all
clc
load('SA_demand201201');
load('SA_price201201');
load('SA_wind201201');

price=SA_price201201(601:800,1)*0.8;   %   $/0.5 MWh
a=round(SA_demand201201(601:800,1));
wind=ceil(SA_wind201201(601:800,1));

[T,temp]=size(a);

% schedule
a1=a-max(a-1200*ones(T,1),zeros(T,1));

neta=max(a1-wind,zeros(T,1));
b=0.6*neta;

beta=4000;            % 6 times full output operational cost
L=100;               % generator capacity
yub=10;                % # of generators
Tu=1;
Td=1;
Ru=50;
Rd=50;

cm=200;            %   20% of full output incremental cost = 0.2*L*co
co=16;           %   $/0.5 MWh elec
g=8;             %   $/0.5 MWh heat
e=0.5;           %   cogeneration heat efficiency

pmax=max(price);
pmin=min(price);

[ a_L,b_Le,N ]=quantification(neta,b,L,e); %% N layers

%static provisioning  ---- benchmark
% benchmark=demandq'*price;

w=0;  %look-ahead window

%our online algorithm
[c_ON,y_ON,u_ON] = ONA_w_limgenerator( a_L,b_Le,N,price,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
% [cost_off,temp] = Offline_LP_nonideal( demandq,L,price,co,cm,beta,n,Tu,Td,Ru,Rd );

% RHC
[c_RHC,y_RHC,u_RHC,v_RHC,s_RHC] = RHC_w( neta,b,price,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% offline schedule y according to the demand, however, supply the
% netdemand during execution
% [c_OSOS,y_OSOS,u_OSOS] = Off_schedule_On_supply(a1,wind, L, price,co,cm,beta,yub,Ru,Rd,Tu,Td);

Tud=max(Tu,Td);
y0=zeros(Tud,1);
%offline optimal
[c_OPT,y_OPT,u_OPT,v_OPT,s_OPT] = Offline_LP_RuRdTuTd(neta,b,price,co,cm,g,e,beta,L,yub,Ru,Rd,Tu,Td,y0,0);                                

% %offline optimal ideal generator
% [c_OPT_ideal,y_OPT_ideal,u_OPT_ideal,v_OPT_ideal] = Offline_LP_ideal(neta,L, price,co,cm,beta,yub);

% only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+neta(t,1)*price(t,1)+b(t,1)*g;
end


% cr_on_h=(benchmark-cost_on_h)/benchmark*100;
% cr_off_h=(benchmark-cost_off_h)/benchmark*100;
% cr_on_o=(benchmark-cost_on_o)/benchmark*100;
% cr_off_o=(benchmark-cost_off_o)/benchmark*100;

tt=1:T;
figure(1);
set(gca,'FontSize',40,'FontName','Arial');
plot(tt,u_ON,'b-','LineWidth',2);
hold on
plot(tt,u_RHC,'ro--','LineWidth',2);
hold on
% plot(tt,u_OSOS,'k^--','LineWidth',2);
% hold on
plot(tt,u_OPT,'gs-.','LineWidth',2);
% hold on
% plot(tt,b,'k^--','LineWidth',2);


figure(2);
set(gca,'FontSize',40,'FontName','Arial');
plot(tt,y_ON,'b-','LineWidth',2);
hold on
plot(tt,y_RHC,'ro--','LineWidth',2);
hold on
% plot(tt,y_OSOS,'k^--','LineWidth',2);
% hold on
plot(tt,y_OPT,'gs-.','LineWidth',2);
% 
figure(3);
set(gca,'FontSize',40,'FontName','Arial');
plot(tt,a1,'b-','LineWidth',2);
hold on
plot(tt,wind,'ro--','LineWidth',2);
hold on
plot(tt,neta,'k^--','LineWidth',2);

