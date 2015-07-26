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

t_start=4681;   %% July 15th~21th
t_end=4848;
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
[c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);
u_OPT=zeros(T,1);
y_OPT=zeros(T,1);
for i=1:yub
    u_OPT=u_OPT+u_temp(:,i);
    y_OPT=y_OPT+y_temp(:,i);
end


% w=10;  %look-ahead window

n=21;

cr_OPT=ones(n,1)*(c_GRID-c_OPT)/c_GRID*100;

cr_BKE=zeros(n,1);
cr_RHC=zeros(n,1);

w=0;  %look-ahead window

for i=1:n
    w=i-1;
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
    
    clear y_BKE
    clear u_BKE
    clear y_RHC
    clear u_RHC
end

save R_w_summer2

clear all
clc
load('FCZ5_COLL_a');
load('FCZ5_COLL_b');
load('FCZ5_COLL_p');
load('FCZ5_COLL_wind');
load('FCZ5_gas');       %   $/therm  12 monthes

% t_start=4345;  %% July 1st  summer
% t_end=4488;
% t_m=7;

% t_start=4489;  %% July 8th
% t_end=4632;
% t_m=7;

t_start=4681;   %% July 15th~21th
t_end=4848;
t_m=7;

% t_start=1;  %% Jan 1st
% t_end=144;

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

beta=1400;        % 6 times full output operational cost ~ 5*(cm+3000*co)  co take mean

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers  

% only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

n=10;

cr_OPT=zeros(n,1);
cr_BKE=zeros(n,1);
cr_RHC=zeros(n,1);

w=3;  %look-ahead window

Tud=max(Tu,Td);

for yub=1:n

    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    %offline MILP    
    Y0=zeros(Tud,yub);
    U0=zeros(1,yub);
    [c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);   

    cr_BKE(yub,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(yub,1)=(c_GRID-c_RHC)/c_GRID*100;
    cr_OPT(yub,1)=(c_GRID-c_OPT)/c_GRID*100;   
        
    clear y_BKE
    clear u_BKE
    clear y_RHC
    clear u_RHC
    clear y_temp
    clear u_temp
    clear Y0
    clear U0
    
end

save R_yub_summer2_w3



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

t_start=4681;   %% July 15th~21th
t_end=4848;
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
[c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);
u_OPT=zeros(T,1);
y_OPT=zeros(T,1);
for i=1:yub
    u_OPT=u_OPT+u_temp(:,i);
    y_OPT=y_OPT+y_temp(:,i);
end

n=21;

ratio_t_BKE=zeros(n,1);
ratio_e_BKE=zeros(n,1);

for i=1:n
    w=i-1;
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    ratio_e_BKE(i,1)=c_BKE/c_OPT;
    ratio_t_BKE(i,1)=ratio_theory1(p,co,cm,g,e,beta,L,Tu,Td,Ru,Rd,w);
    
    clear y_BKE
    clear u_BKE
end

save R_ratio1_summer2


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

t_start=4681;   %% July 15th~21th
t_end=4848;
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

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                           

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

save R_ratio_summer2


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

t_start=4681;   %% July 15th~21th
t_end=4848;
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

w=3;  %look-ahead window

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

save R_Rud_summer2_w3


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

t_start=4681;   %% July 15th~21th
t_end=4848;
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

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                           

%only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

%offline MILP
% Tud=max(Tu,Td);
% Y0=zeros(Tud,yub);
% U0=zeros(1,yub);
% [c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0);
% u_OPT=zeros(T,1);
% y_OPT=zeros(T,1);
% for i=1:yub
%     u_OPT=u_OPT+u_temp(:,i);
%     y_OPT=y_OPT+y_temp(:,i);
% end

n=11;

cr_OPT=zeros(n,1);
cr_BKE=zeros(n,1);
cr_RHC=zeros(n,1);

w=3;  %look-ahead window

for i=1:n
    Tu=i;
    Td=i;
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    %offline MILP 
    Tud=max(Tu,Td);
    Y0=zeros(Tud,yub);
    U0=zeros(1,yub);
    [c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0, 0.004); 
    
    cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
    cr_OPT(i,1)=(c_GRID-c_OPT)/c_GRID*100; 
    
    clear y_BKE
    clear u_BKE
    clear y_RHC
    clear u_RHC
    clear y_temp
    clear u_temp
    clear Y0
    clear U0
end

save R_Tud11_summer2_w3

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

t_start=4681;   %% July 15th~21th
t_end=4848;
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
[c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0, 0.002);
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
    [ a_L,anoise_L,b_Le,bnoise_Le,N ]=quantification_error(a,anoise,b,b,L,e); %% N layers      
    
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_error( a_L,anoise_L,b_Le,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC] = RHC_error(a,anoise,b,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
    
    clear y_BKE
    clear u_BKE
    clear y_RHC
    clear u_RHC
    clear a_L
    clear anoise_L
    clear bnoise_Le
    clear b_Le
    clear bnoise
end

save R_sigma_summer2_aerror_w3

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

t_start=4681;   %% July 15th~21th
t_end=4848;
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
[c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);
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

rand_vec=randn(T,1)*20000;

for i=1:n
    sigma=0.1*(i-1);
    error=sigma*rand_vec;
    bnoise=ceil(max(zeros(T,1),error+b));
    [ a_L,anoise_L,b_Le,bnoise_Le,N ]=quantification_error(a,a,b,bnoise,L,e); %% N layers      
    
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_error( a_L,a_L,b_Le,bnoise_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC] = RHC_error(a,a,b,bnoise,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
    
    clear y_BKE
    clear u_BKE
    clear y_RHC
    clear u_RHC
    clear a_L
    clear anoise_L
    clear bnoise_Le
    clear b_Le
    clear bnoise
end

save R_sigma_summer2_berror_w3


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

% t_start=4489;  %% July 8th
% t_end=4632;
% t_m=7;

% t_start=145;  %% Jan 8th
% t_end=288;
% t_m=1;

t_start=4681;   %% July 15th~21th
t_end=4848;
t_m=7;

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
Ru=1000;
Rd=1000;

% according to tecogen datasheet
% installed costs with heat recovery    3000$/kw
% variable maintenance                  0.02$/kwh
% lifetime                              20 year
cm=110;            %   0.02*3000+3000*3000/20/365/24=113.7
co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency
% e=1.8;           %   cogeneration heat efficiency

beta=1400;        % 5 times full output operational cost ~ 5*(cm+3000*co)  co take mean

                     
%only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

n=11;

cr_OPT=zeros(n,1);
cr_BKE=zeros(n,1);
cr_RHC=zeros(n,1);

w=3;  %look-ahead window

Tud=max(Tu,Td);
Y0=zeros(Tud,yub);
U0=zeros(1,yub);

for i=1:n
    e=0.6+(i-1)*0.2;
    [ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers     
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    %offline MILP    

    [c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);   

    cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
    cr_OPT(i,1)=(c_GRID-c_OPT)/c_GRID*100;   
    
    clear y_BKE
    clear u_BKE
    clear y_RHC
    clear u_RHC
    clear a_L
    clear b_Le
    clear y_temp
    clear u_temp
end

save R_e_summer2_w3

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

% t_start=4489;  %% July 8th
% t_end=4632;
% t_m=7;

t_start=169;  %% Jan 8th~14th      winter
t_end=336;
t_m=1;

% 
% t_start=4681;   %% July 15th
% t_end=4848;
% t_m=7;

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
Ru=1000;
Rd=1000;

% according to tecogen datasheet
% installed costs with heat recovery    3000$/kw
% variable maintenance                  0.02$/kwh
% lifetime                              20 year
cm=110;            %   0.02*3000+3000*3000/20/365/24=113.7
co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency
% e=1.8;           %   cogeneration heat efficiency

beta=1400;        % 5 times full output operational cost ~ 5*(cm+3000*co)  co take mean

                     
%only grid
c_GRID=0;
for t=1:T
    c_GRID=c_GRID+a(t,1)*p(t,1)+b(t,1)*g;
end

n=11;

cr_OPT=zeros(n,1);
cr_BKE=zeros(n,1);
cr_RHC=zeros(n,1);

w=3;  %look-ahead window

Tud=max(Tu,Td);
Y0=zeros(Tud,yub);
U0=zeros(1,yub);

for i=1:n
    e=0.6+(i-1)*0.2;
    [ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers     
    % BKE
    [c_BKE,y_BKE,u_BKE] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

    % RHC
    [c_RHC,y_RHC,u_RHC] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
    %offline MILP    

    [c_OPT,y_temp,u_temp] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);   

    cr_BKE(i,1)=(c_GRID-c_BKE)/c_GRID*100;
    cr_RHC(i,1)=(c_GRID-c_RHC)/c_GRID*100;
    cr_OPT(i,1)=(c_GRID-c_OPT)/c_GRID*100;   
    
    clear y_BKE
    clear u_BKE
    clear y_RHC
    clear u_RHC
    clear a_L
    clear b_Le
    clear y_temp
    clear u_temp
end

save R_e_winter2_w3

clear all
clc

L=3000;               % generator capacity 3000 kw       scale up 30 times
Tu=3;
Td=3;
Ru=1000;
Rd=1000;

yub=10;                % # of generators
w=3;                   %look-ahead window

Tud=max(Tu,Td);
Y0=zeros(Tud,yub);
U0=zeros(1,yub);

load('FCZ5_COLL_a');
load('FCZ5_COLL_b');
load('FCZ5_COLL_p');
load('FCZ5_COLL_wind');
load('FCZ5_gas');       %   $/therm   12 monthes

cm=110;            %   0.02*3000+3000*3000/20/365/24=113.7
e=1.8;           %   cogeneration heat efficiency

beta=1400;        % 5 times full output operational cost ~ 5*(cm+3000*co)  co take mean

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

co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

[T,~]=size(a);

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_winter=0;
for t=1:T
    c_GRID_winter=c_GRID_winter+a(t,1)*p(t,1)+b(t,1)*g;
end

% BKE
[c_BKE_winter,~,~] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_winter,~,~] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
%offline MILP    
[c_OPT_winter,~,~] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
clear N


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spring
t_start=2161;  %% Apr 1st   spring
t_end=2328;  
t_m=4;

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          

co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

[T,~]=size(a);

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_spring=0;
for t=1:T
    c_GRID_spring=c_GRID_spring+a(t,1)*p(t,1)+b(t,1)*g;
end

% BKE
[c_BKE_spring,~,~] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_spring,~,~] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
%offline MILP    
[c_OPT_spring,~,~] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
clear N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% summer
t_start=4681;   %% July 15th~21th  summer
t_end=4848;
t_m=7;

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          

co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

[T,~]=size(a);

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_summer=0;
for t=1:T
    c_GRID_summer=c_GRID_summer+a(t,1)*p(t,1)+b(t,1)*g;
end

% BKE
[c_BKE_summer,~,~] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_summer,~,~] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
%offline MILP    
[c_OPT_summer,~,~] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
clear N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% autumn
t_start=6553;  %% Oct 1st   autumn
t_end=6720;  
t_m=10;

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          

co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

[T,~]=size(a);

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_autumn=0;
for t=1:T
    c_GRID_autumn=c_GRID_autumn+a(t,1)*p(t,1)+b(t,1)*g;
end

% BKE
[c_BKE_autumn,~,~] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_autumn,~,~] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
%offline MILP    
[c_OPT_autumn,~,~] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
clear N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% without chp            no heat demand
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% winter
t_start=169;  %% Jan 8th~14th      winter
t_end=336;
t_m=1;

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          

co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=0*ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

[T,~]=size(a);

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_winter1=0;
for t=1:T
    c_GRID_winter1=c_GRID_winter1+a(t,1)*p(t,1)+b(t,1)*g;
end

% BKE
[c_BKE_winter1,~,~] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_winter1,~,~] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
%offline MILP    
[c_OPT_winter1,~,~] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
clear N


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spring
t_start=2161;  %% Apr 1st   spring
t_end=2328;  
t_m=4;

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          

co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=0*ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

[T,~]=size(a);

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_spring1=0;
for t=1:T
    c_GRID_spring1=c_GRID_spring1+a(t,1)*p(t,1)+b(t,1)*g;
end

% BKE
[c_BKE_spring1,~,~] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_spring1,~,~] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
%offline MILP    
[c_OPT_spring1,~,~] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
clear N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% summer
t_start=4681;   %% July 15th~21th  summer
t_end=4848;
t_m=7;

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          

co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=0*ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

[T,~]=size(a);

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_summer1=0;
for t=1:T
    c_GRID_summer1=c_GRID_summer1+a(t,1)*p(t,1)+b(t,1)*g;
end

% BKE
[c_BKE_summer1,~,~] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_summer1,~,~] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
%offline MILP    
[c_OPT_summer1,~,~] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
clear N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% autumn
t_start=6553;  %% Oct 1st   autumn
t_end=6720;  
t_m=10;

gas=FCZ5_gas(t_m,1)/29.3;  %  natural gas price  Jan
                         %  1 therm = 29.3 KWh                          

co=gas/0.28;           % elec   efficiency 0.28
g=gas/0.8;        % boiler efficiency

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=0*ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

[T,~]=size(a);

[ a_L,b_Le,N ]=quantification(a,b,L,e); %% N layers                                  

% only grid
c_GRID_autumn1=0;
for t=1:T
    c_GRID_autumn1=c_GRID_autumn1+a(t,1)*p(t,1)+b(t,1)*g;
end

% BKE
[c_BKE_autumn1,~,~] = BKE_w( a_L,b_Le,N,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);

% RHC
[c_RHC_autumn1,~,~] = RHC_w(a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,w);
    
%offline MILP    
[c_OPT_autumn1,~,~] = Offline_MILP( a,b,p,co,cm,g,e,beta,L,yub,Tu,Td,Ru,Rd,Y0,U0,0.002);

clear a
clear b
clear p
clear a1
clear wind1
clear a_L
clear b_Le
clear N

save FCZ5_COLL_4season





