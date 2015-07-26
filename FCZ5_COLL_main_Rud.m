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
yub=10;                % # of generators
Tu=3;
Td=3;


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

%only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

%offline MILP
Tud=max(Tu,Td);
Y0=zeros(Tud,yub);
U0=zeros(1,yub);
% [c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0);
% u_OPT=zeros(T,1);
% y_OPT=zeros(T,1);
% for i=1:yub
%     u_OPT=u_OPT+u_temp(:,i);
%     y_OPT=y_OPT+y_temp(:,i);
% end

n=10;

cr_OPT=zeros(n,1);
cr_BKE=zeros(n,1);
cr_RHC=zeros(n,1);

w=4;  %look-ahead window

for i=1:n
    Ru=i*300;
    Rd=i*300;
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    %offline MILP 
    [c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0, 0.003); 
    
    cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
    cr_OPT(i,1)=(c_GRID-c_OPT)/c_GRID*100; 
    
    clear y_BKE
    clear u_BKE
    clear y_RHC
    clear u_RHC
    clear y_temp
    clear u_temp
end

save R_Rud_summer1_w4



