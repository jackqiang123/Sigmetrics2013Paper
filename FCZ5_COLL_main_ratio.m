clear all
clc
load('FCZ5_COLL_a');
load('FCZ5_COLL_b');
load('FCZ5_COLL_p');
load('FCZ5_COLL_wind');
load('FCZ5_gas');       %   $/therm   12 monthes

% t_start=4345;  %% July 1st
% t_end=4488;
% t_m=7;

t_start=4681;   %% July 17th
t_end=4824;
t_m=7;

% t_start=1;  %% Jan 1st
% t_end=12;

% t_start=2160;  %% Apr 1st
% t_end=2640;  

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);


gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh 

[T,temp]=size(a);

L=3000;               % generator capacity 3000 kw       scale up 30 times
yub=9;                % # of generators
Tu=1;
Td=1;
Ru=3000;
Rd=3000;

% according to tecogen datasheet
% installed costs with heat recovery    3000$/kw
% variable maintenance                  0.02$/kwh
% lifetime                              20 year
cm=110;            %   0.02*3000+3000*3000/20/365/24=113.7
co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency
e=1.8;           %   cogeneration heat efficiency

beta=1400;        % 5 times full output operational cost ~ 5*(cm+3000*co)  co take mean

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                           

%offline MILP
Tud=max(Tu,Td);
Y0=zeros(Tud,yub);
U0=zeros(1,yub);
[c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.0005);
u_OPT=zeros(T,1);
y_OPT=zeros(T,1);
for i=1:yub
    u_OPT=u_OPT+u_temp(:,i);
    y_OPT=y_OPT+y_temp(:,i);
end

n=21;

ratio_t_BKE=zeros(n,1);
ratio_e_BKE=zeros(n,1);


w=0;  %look-ahead window

for i=1:n
    w=i-1;
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    ratio_e_BKE(i,1)=c_BKE/c_OPT;
    ratio_t_BKE(i,1)=ratio_theory1(p,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
    
    clear y_BKE
    clear u_BKE
end

save R_ratio1_summer1

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


% tt=1:T;
% figure(1);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(tt,u_OPT,'b-','LineWidth',2);
% hold on
% plot(tt,u_BKE,'ro--','LineWidth',2);
% hold on
% plot(tt,u_RHC,'k^:','LineWidth',2);
% % hold on
% % plot(tt,u_RHC,'gs-','LineWidth',2);
% xlabel('hour','FontSize',40,'FontName','Arial'); 
% ylabel('kw','FontSize',40,'FontName','Arial'); 
% % 
% % % 
% figure(2);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(tt,y_OPT,'b-','LineWidth',2);
% hold on
% plot(tt,y_BKE,'ro--','LineWidth',2);
% hold on
% plot(tt,y_RHC,'k^--','LineWidth',2);
% hold on
% plot(tt,y_RHC,'gs-','LineWidth',2);

% 
% figure(3);
% set(gca,'FontSize',40,'FontName','Arial');
% plot(tt,a,'b-','LineWidth',2);
% hold on
% plot(tt,b,'ro--','LineWidth',2);


