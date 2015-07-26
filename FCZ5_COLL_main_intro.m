clear all
clc
load('FCZ5_COLL_a');
load('FCZ5_COLL_b');
load('FCZ5_COLL_p');
load('FCZ5_COLL_wind');
load('FCZ5_gas');       %   $/therm    12 monthes
                        

% t_start=4345;  %% July 1st  summer
% t_end=4488;
% t_m=7;

t_start=4632;  % July 15th
t_end=4800;
t_m=7;

% t_start=1;  %% Jan 1st~7th
% t_end=144;

% 
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
yub=8;                % # of generators
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

% offline schedule y according to the demand, however, supply the
% netdemand during execution
% [c_OSOS,y_OSOS,u_OSOS] = Off_schedule_On_supply(a1,wind, L, price,co,cm,beta,yub,Ru,Rd,Tu,Td);          

%offline MILP
Tud=max(Tu,Td);
Y0=zeros(Tud,yub);
U0=zeros(1,yub);
[c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);
u_OPT=zeros(T,1);
y_OPT=zeros(T,1);
for i=1:yub
    u_OPT=u_OPT+u_temp(:,i);
    y_OPT=y_OPT+y_temp(:,i);
end

%only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

w=2;  %look-ahead window

% BKE
[c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

turnon_y=0;
for t=2:T
    turnon_y=turnon_y+max(0,y_BKE(t,1)-y_BKE(t-1));    
end
at_y=turnon_y/T;

cost_BKE=zeros(T,1);
cost_GRID=zeros(T,1);

for t=1:T;
    cost_BKE(t,1)=beta*at_y+cm*y_BKE(t,1)+co*u_BKE(t,1)+p(t,1)*max(0,a(t,1)-u_BKE(t,1))+g*max(0,b(t,1)-e*u_BKE(t,1)); 
    cost_GRID(t,1)=a(t,1)*p(t,1)+b(t,1)*g;
end

tt=1:T;
subplot(4,1,1);
[AX,H1,H2]=plotyy(tt,a/1000,tt,b/29.3,'plot');
set(get(AX(1),'Ylabel'),'String','MWh','FontSize',15,'FontName','Arial','color','b'); 
set(get(AX(2),'Ylabel'),'String','Therm','FontSize',15,'FontName','Arial','color','r'); 

set(H1,'LineStyle','-','color','b','LineWidth',3);
set(H2,'LineStyle','--','color','r','LineWidth',3);

set(AX(1),'FontSize',15,'ycolor','b','ytick',[0:9:27],'ylim',[0,27],'xticklabel',[],'xlim',[0,168]);
set(AX(2),'FontSize',15,'ycolor','r','ytick',[0:400:1200],'ylim',[0,1200],'xticklabel',[],'xlim',[0,168]);
h = legend('Net Electricity','Heat',1);
set(h,'Interpreter','none');

subplot(4,1,2);
set(gca,'FontSize',15,'FontName','Arial');
plot(tt,y_BKE,'b-','LineWidth',3); 
hold on
plot(tt,y_OPT,'k--','LineWidth',3); 
h = legend('CHASE','OFFLINE',1);
ylabel('# of Generators','FontSize',15,'FontName','Arial'); 
set(gca,'xticklabel',[],'xlim',[0,168]);

subplot(4,1,3);
set(gca,'FontSize',15,'FontName','Arial');
plot(tt,u_BKE,'b-','LineWidth',3);
hold on
plot(tt,u_OPT,'k--','LineWidth',3); 
h = legend('CHASE','OFFLINE',1);
ylabel('Output','FontSize',15,'FontName','Arial'); 
set(gca,'xticklabel',[],'xlim',[0,168]);

subplot(4,1,4);
set(gca,'FontSize',15,'FontName','Arial');
plot(tt,cost_BKE,'b-','LineWidth',3);
hold on
plot(tt,cost_GRID,'r--','LineWidth',3);
xlabel('Time/hour','FontSize',15,'FontName','Arial'); 
ylabel('Cost','FontSize',15,'FontName','Arial'); 
h = legend('CHASE','Grid',1);
set(gca,'xlim',[0,168]);


