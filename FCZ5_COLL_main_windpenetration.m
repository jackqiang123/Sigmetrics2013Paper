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

t_start=4632;  % July 15th
t_end=4776;
t_m=7;

% t_start=1;  %% Jan 1st
% t_end=12;

% t_start=2160;  %% Apr 1st
% t_end=2640;  

a_o=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind_o=ceil(FCZ5_COLL_wind(t_start:t_end,1));

[T,temp]=size(a_o);

percent_o=sum(wind_o)/sum(a_o);


b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh 


L=3000;               % generator capacity 3000 kw       scale up 30 times
yub=9;                % # of generators
Tu=3;
Td=3;
Ru=1000;
Rd=1000;
Tud=max(Tu,Td);

% according to tecogen datasheet
% installed costs with heat recovery    3000$/kw
% variable maintenance                  0.02$/kwh
% lifetime                              20 year
cm=110;            %   0.02*3000+3000*3000/20/365/24=113.7
co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency
e=1.8;           %   cogeneration heat efficiency

beta=1400;        % 5 times full output operational cost ~ 5*(cm+3000*co)  co take mean                    

n=7;

cost_OPT=zeros(n,9);
cost_BKE=zeros(n,9);
cost_RHC=zeros(n,9);
vm_OPT=zeros(n,9);
vm_BKE=zeros(n,9);
vm_RHC=zeros(n,9);

w=3;  %look-ahead window

for i=1:n
    percent=0.1*(i-1);
    wind1=wind_o*percent/percent_o;
    a=max(zeros(T,1),a_o-wind1);
    [ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers      
    for yub=1:9
         % BKE
        [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
         vm_BKE(i,yub)=max(max(a-u_BKE),0);
         
         % RHC
        [c_RHC,y_RHC,u_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
         vm_RHC(i,yub)=max(max(a-u_RHC),0);
         
         %offline MILP    
         Y0=zeros(Tud,yub);
         U0=zeros(1,yub);
         [c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);   
         u_OPT=zeros(T,1);
         for j=1:yub
             u_OPT=u_OPT+u_temp(:,j);
         end
         vm_OPT(i,yub)=max(max(a-u_OPT),0);
    
        cost_BKE(i,yub)=c_BKE;
        cost_RHC(i,yub)=c_RHC;
        cost_OPT(i,yub)=c_OPT;
    
        clear y_BKE
        clear u_BKE
        clear y_RHC
        clear u_RHC
        clear u_temp
        clear y_temp
        clear u_OPT
    end
    clear wind1
    clear a
    clear a_L
    clear b_Le
end

save R_w_summer1

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


