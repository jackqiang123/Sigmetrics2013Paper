clear all
clc
load('SMUD_COLL_a');
load('SMUD_COLL_b');
load('SMUD_COLL_p');

% t_start=4345;  %% July 1st
% t_end=4824;

t_start=160;  %% Jan 1st
t_end=240;

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
Tu=3;
Td=3;
Ru=200;
Rd=200;

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

%only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

w=60;  %look-ahead window

% for i=1:n
% 
%     % BKE
%     [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,10,Tu,Td,Ru,Rd,w);
% 
%     % RHC
%     [c_RHC,y_RHC,u_RHC,v_RHC,s_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,10,Tu,Td,Ru,Rd,w);
%     
%     %offline optimal
%     [c_OPT,y_OPT,u_OPT,v_OPT,s_OPT] = Offline_LP_RuRdTuTd(a,b,p,co,cm,g,e,beta,L,10,Ru,Rd,Tu,Td,y0,0);
%     
%     cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
%     cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
%     cr_OPT(i,1)=(c_GRID-c_OPT)/c_GRID*100;
% end

% BKE
[c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC,y_RHC,u_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

%offline MILP
Tud=max(Tu,Td);
Y0=zeros(Tud,yub);
U0=zeros(1,yub);
[c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0);
u_OPT=zeros(T,1);
y_OPT=zeros(T,1);
for i=1:yub
    u_OPT=u_OPT+u_temp(:,i);
    y_OPT=y_OPT+y_temp(:,i);
end
   
% %offline LP
% Tud=max(Tu,Td);
% y0=zeros(Tud,1);
% [c_LP,y_LP,u_LP,v_LP,s_LP] =Offline_LP_RuRdTuTd(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,y0,0);

% %offline optimal round y
% [c_ORy,y_ORy,u_ORy,v_ORy,s_ORy ] = Offline_roundy_RuRdTuTd(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,y0,0);




% figure(1);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(1:n,cr_OPT,'b-','LineWidth',7);
% hold on
% plot(1:n,cr_BKE,'ro--','MarkerSize',10,'LineWidth',7);
% hold on
% plot(1:n,cr_RHC,'k^:','MarkerSize',10,'LineWidth',7);
% 
% xlabel('# of generators','FontSize',40,'FontName','Arial'); 
% ylabel('%Cost Reduction','FontSize',40,'FontName','Arial'); 


tt=1:T;
figure(1);
set(gca,'FontSize',40,'FontName','Arial');
plot(tt,u_OPT,'b-','LineWidth',2);
hold on
plot(tt,u_BKE,'ro--','LineWidth',2);
hold on
plot(tt,u_RHC,'k^:','LineWidth',2);
% hold on
% plot(tt,u_RHC,'gs-','LineWidth',2);
xlabel('hour','FontSize',40,'FontName','Arial'); 
ylabel('kw','FontSize',40,'FontName','Arial'); 
% 
% % 
figure(2);
set(gca,'FontSize',40,'FontName','Arial');
plot(tt,y_OPT,'b-','LineWidth',2);
hold on
plot(tt,y_BKE,'ro--','LineWidth',2);
hold on
plot(tt,y_RHC,'k^--','LineWidth',2);
% hold on
% plot(tt,y_RHC,'gs-','LineWidth',2);

% 
% figure(3);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(tt,a,'b-','LineWidth',2);
% hold on
% plot(tt,b,'ro--','LineWidth',2);


