clear all
clc

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

e=[1.8;1.8;1.8];           %   cogeneration heat efficiency

beta=[1400;1400;1400];        % 5 times full output operational cost ~ 5*(cm+3000*co)  co take mean                    




yub=10;                % # of generators
w=3;                   %look-ahead window

Tud=max(max(Tu,Td));
Y0=zeros(Tud,yub);
U0=zeros(1,yub);

load('FCZ5_COLL_a');
load('FCZ5_COLL_b');
load('FCZ5_COLL_p');
load('FCZ5_COLL_wind');
load('FCZ5_gas');       %   $/therm   12 monthes



% t_start=169;  %% Jan 8th~14th      winter
% t_end=336;
% t_m=1;
 
% t_start=2161;  %% Apr 1st   spring
% t_end=2328;  
% t_m=4;

% t_start=4681;   %% July 15th~21th  summer
% t_end=4848;
% t_m=7;

% t_start=6553;  %% Oct 1st   autumn
% t_end=6720;  
% t_m=10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% winter
t_start=169;  %% Jan 8th~14th      winter
t_end=336;
t_m=1;

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          



co=[gas/0.28;gas/0.28;gas/0.28];           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
ps=ones(168,1)*mean(p)*0.3;
[T,~]=size(a);

%[ a_L,b_Le,N]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_winter=0;
for t=1:T
    c_GRID_winter=c_GRID_winter+a(t,1)*p(t,1)+b(t,1)*g;
end

% CHASE
[c_CHASE_winter,~,~] = CHASE_w(a,b,p,ps,g,e,co,cm,L,N,beta,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_winter,~,~] = RHC_w(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
  
%offline MILP    
[c_OPT_winter,~,~] = Offline_MILP(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,Y0,U0,0.005);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % spring
t_start=2161;  %% Apr 1st   spring
t_end=2328;  
t_m=4;
% 
gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          



co=[gas/0.28;gas/0.28;gas/0.28];           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
ps=ones(168,1)*mean(p)*0.3;
[T,~]=size(a);

%[ a_L,b_Le,N]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_spring=0;
for t=1:T
    c_GRID_spring=c_GRID_spring+a(t,1)*p(t,1)+b(t,1)*g;
end

% CHASE
[c_CHASE_spring,~,~] = CHASE_w(a,b,p,ps,g,e,co,cm,L,N,beta,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_spring,~,~] = RHC_w(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
  
%offline MILP    
[c_OPT_spring,~,~] = Offline_MILP(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,Y0,U0,0.005);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % summer
t_start=4681;   %% July 15th~21th  summer
t_end=4848;
t_m=7;
% 
gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          



co=[gas/0.28;gas/0.28;gas/0.28];           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
ps=ones(168,1)*mean(p)*0.3;
[T,~]=size(a);

%[ a_L,b_Le,N]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_summer=0;
for t=1:T
    c_GRID_summer=c_GRID_summer+a(t,1)*p(t,1)+b(t,1)*g;
end

% CHASE
[c_CHASE_summer,~,~] = CHASE_w(a,b,p,ps,g,e,co,cm,L,N,beta,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_summer,~,~] = RHC_w(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
  
%offline MILP    
[c_OPT_summer,~,~] = Offline_MILP(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,Y0,U0,0.005);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
%  
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % autumn
t_start=6553;  %% Oct 1st   autumn
t_end=6720;  
t_m=10;
% 
gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          



co=[gas/0.28;gas/0.28;gas/0.28];           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
ps=ones(168,1)*mean(p)*0.3;
[T,~]=size(a);

%[ a_L,b_Le,N]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_autumn=0;
for t=1:T
    c_GRID_autumn=c_GRID_autumn+a(t,1)*p(t,1)+b(t,1)*g;
end

% CHASE
[c_CHASE_autumn,~,~] = CHASE_w(a,b,p,ps,g,e,co,cm,L,N,beta,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_autumn,~,~] = RHC_w(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
  
%offline MILP    
[c_OPT_autumn,~,~] = Offline_MILP(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,Y0,U0,0.005);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % without chp            no heat demand
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % winter1
t_start=169;  %% Jan 8th~14th      winter
t_end=336;
t_m=1;
% 
gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          



co=[gas/0.28;gas/0.28;gas/0.28];           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=0*ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
ps=ones(168,1)*mean(p)*0.3;
[T,~]=size(a);

%[ a_L,b_Le,N]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_winter1=0;
for t=1:T
    c_GRID_winter1=c_GRID_winter1+a(t,1)*p(t,1)+b(t,1)*g;
end

% CHASE
[c_CHASE_winter1,~,~] = CHASE_w(a,b,p,ps,g,e,co,cm,L,N,beta,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_winter1,~,~] = RHC_w(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
  
%offline MILP    
[c_OPT_winter1,~,~] = Offline_MILP(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,Y0,U0,0.005);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % spring1
t_start=2161;  %% Apr 1st   spring
t_end=2328;  
t_m=4;
% 
gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          



co=[gas/0.28;gas/0.28;gas/0.28];           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=0*ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
ps=ones(168,1)*mean(p)*0.3;
[T,~]=size(a);

%[ a_L,b_Le,N]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_spring1=0;
for t=1:T
    c_GRID_spring1=c_GRID_spring1+a(t,1)*p(t,1)+b(t,1)*g;
end

% CHASE
[c_CHASE_spring1,~,~] = CHASE_w(a,b,p,ps,g,e,co,cm,L,N,beta,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_spring1,~,~] = RHC_w(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
  
%offline MILP    
[c_OPT_spring1,~,~] = Offline_MILP(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,Y0,U0,0.005);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % summer1
t_start=4681;   %% July 15th~21th  summer
t_end=4848;
t_m=7;
% 
gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          



co=[gas/0.28;gas/0.28;gas/0.28];           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=0*ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
ps=ones(168,1)*mean(p)*0.3;
[T,~]=size(a);

%[ a_L,b_Le,N]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_summer1=0;
for t=1:T
    c_GRID_summer1=c_GRID_summer1+a(t,1)*p(t,1)+b(t,1)*g;
end

% CHASE
[c_CHASE_summer1,~,~] = CHASE_w(a,b,p,ps,g,e,co,cm,L,N,beta,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_summer1,~,~] = RHC_w(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
  
%offline MILP    
[c_OPT_summer1,~,~] = Offline_MILP(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,Y0,U0,0.005);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % autumn1
t_start=6553;  %% Oct 1st   autumn
t_end=6720;  
t_m=10;
% 
gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          



co=[gas/0.28;gas/0.28;gas/0.28];           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=0*ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
ps=ones(168,1)*mean(p)*0.3;
[T,~]=size(a);

%[ a_L,b_Le,N]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_autumn1=0;
for t=1:T
    c_GRID_autumn1=c_GRID_autumn1+a(t,1)*p(t,1)+b(t,1)*g;
end

% CHASE
[c_CHASE_autumn1,~,~] = CHASE_w(a,b,p,ps,g,e,co,cm,L,N,beta,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_autumn1,~,~] = RHC_w(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
  
%offline MILP    
[c_OPT_autumn1,~,~] = Offline_MILP(N,a,b,p,ps,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,Y0,U0,0.005);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
 

save FCZ5_COLL_4season