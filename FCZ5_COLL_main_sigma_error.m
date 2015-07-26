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

t_start=4489;  %% July 8th
t_end=4632;
t_m=7;

% t_start=1;  %% Jan 1st
% t_end=12;

% t_start=2160;  %% Apr 1st
% t_end=2640;  

a1=FCZ5_COLL_a(t_start:t_end,1);
wind1=FCZ5_COLL_wind(t_start:t_end,1);

[T,temp]=size(a1);

% wind prediction error ~ gaussian(0,0.1)   sigma=0.1
% standardized as a fraction of the installed capacity

a=ceil(max(zeros(T,1),a1-wind1));
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh 

L=3000;               % generator capacity 3000 kw       scale up 30 times
yub=10;                % # of generators
Tu=3;
Td=3;
Ru=1000;
Rd=1000;

% according to tecogen datasheet
% installed costs with heat recovery    3000$/kw
% variable maintenance                  0.02$/kwh
% lifetime                              20 year
cm=110;            %   0.02*3000+3000*3000/20/365/24=113.7
co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency
e=1.8;           %   cogeneration heat efficiency

beta=1400;        % 5 times full output operational cost ~ 5*(cm+3000*co)  co take mean                    

%only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

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

n=13;

cr_OPT=ones(n,1)*(c_GRID-c_OPT)/c_GRID*100;

cr_BKE=zeros(n,1);
cr_RHC=zeros(n,1);

w=3;  %look-ahead window

rand_vec=randn(T,1)*12000;

for i=1:n
    sigma=0.1*(i-1);
    error=sigma*rand_vec;
    wind2=ceil(max(zeros(T,1),error+wind1));
    anoise=ceil(max(zeros(T,1),a1-wind2));
    [ a_L,anoise_L,b_Le,N ]=quantification_error(a,anoise,b,L,e); %% N layers      
    
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_error( a_L,anoise_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC] = RHC_error(a,anoise,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
    
    clear y_BKE
    clear u_BKE
    clear y_RHC
    clear u_RHC
    clear a_L
    clear anoise_L
    clear b_Le
end

save R_sigma_summer1_error_w3

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


