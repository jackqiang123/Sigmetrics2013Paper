clear all
clc
load('SMUD_COLL_a');
load('SMUD_COLL_b');
load('SMUD_COLL_p');

% t_start=4345;  %% July 1st
% t_end=4824;

t_start=1;  %% Jan 1st
t_end=480;

% t_start=2160;  %% Apr 1st
% t_end=2640;  

a=ceil(SMUD_COLL_a(t_start:t_end,1));
b=ceil(SMUD_COLL_b(t_start:t_end,1));
p=SMUD_COLL_p(t_start:t_end,1);
gas=0.034;  % natural gas price  1$/therm ~ 0.034 $/ kwh

[T,temp]=size(a);

beta=200;            % 6 times full output operational cost
L=500;               % generator capacity 500 kw
yub=10;                % # of generators
Tu=4;
Td=4;
Ru=125;
Rd=125;

cm=10;            %   20% of full output incremental cost = 0.2*L*co
co=gas/0.35;           % elec   efficiency 0.4
g=gas/0.8;        % boiler efficiency
e=1.3;           %   cogeneration heat efficiency

pmax=max(p);
pmin=min(p);

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers

% offline schedule y according to the demand, however, supply the
% netdemand during execution
% [c_OSOS,y_OSOS,u_OSOS] = Off_schedule_On_supply(a1,wind, L, price,co,cm,beta,yub,Ru,Rd,Tu,Td);

Tud=max(Tu,Td);
y0=zeros(Tud,1);
% %offline optimal
% [c_OPT,y_OPT,u_OPT,v_OPT,s_OPT] = Offline_LP_RuRdTuTd(a,b,p,co,cm,g,e,beta,L,yub,Ru,Rd,Tu,Td,y0,0);                                

% only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

n=10;
cr_OPT=zeros(n,1);

cr_BKE=zeros(n,1);
cr_RHC=zeros(n,1);

w=5;  %look-ahead window

for i=1:n

    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,i,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC,v_RHC,s_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,i,Tu,Td,Ru,Rd,w);
    
    %offline optimal
    [c_OPT,y_OPT,u_OPT,v_OPT,s_OPT] = Offline_LP_RuRdTuTd(a,b,p,co,cm,g,e,beta,L,i,Ru,Rd,Tu,Td,y0,0);
    
    cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
    cr_OPT(i,1)=(c_GRID-c_OPT)/c_GRID*100;
end

figure(1);
set(gca,'FontSize',40,'FontName','Arial');
plot(1:n,cr_OPT,'b-','LineWidth',7);
hold on
plot(1:n,cr_BKE,'ro--','MarkerSize',10,'LineWidth',7);
hold on
plot(1:n,cr_RHC,'k^:','MarkerSize',10,'LineWidth',7);

xlabel('# of generators','FontSize',40,'FontName','Arial'); 
ylabel('%Cost Reduction','FontSize',40,'FontName','Arial'); 


% tt=1:T/3;
% figure(2);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(tt,a(1:T/3),'b-','LineWidth',2);
% hold on
% plot(tt,b(1:T/3),'ro--','LineWidth',2);
% hold on
% plot(tt,u_RHC(1:T/3),'k^:','LineWidth',2);
% xlabel('hour','FontSize',40,'FontName','Arial'); 
% ylabel('kw','FontSize',40,'FontName','Arial'); 

% 
% 
% figure(2);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(tt,y_ON,'b-','LineWidth',2);
% hold on
% plot(tt,y_RHC,'ro--','LineWidth',2);
% hold on
% % plot(tt,y_OSOS,'k^--','LineWidth',2);
% % hold on
% plot(tt,y_OPT,'gs-.','LineWidth',2);
% % 
% figure(3);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(tt,a,'b-','LineWidth',2);
% hold on
% plot(tt,b,'ro--','LineWidth',2);


