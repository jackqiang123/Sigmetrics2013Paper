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
sigma=0.1;
error=sigma*randn(T,1)*12000;

wind2=ceil(max(zeros(T,1),error+wind1));


a=ceil(max(zeros(T,1),a1-wind1));
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);

anoise=ceil(max(zeros(T,1),a1-wind2));

figure(1);
set(gca,'FontSize',45,'FontName','Arial');
plot(wind1,'b-','LineWidth',7);
hold on
plot(wind2,'ro--','MarkerSize',8,'LineWidth',7);
% hold on
% plot(wind1/1000,'k^:','MarkerSize',7,'LineWidth',7);

% xlabel('t /hour','FontSize',45,'FontName','Arial'); 
% ylabel('MWh','FontSize',45,'FontName','Arial'); 
% 
% h = legend('Electricity','Heat','Wind',1);
% set(h,'Interpreter','none');