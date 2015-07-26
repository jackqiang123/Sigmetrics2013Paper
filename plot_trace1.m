clear all
clc
load('FCZ5_COLL_a');
load('FCZ5_COLL_b');
load('FCZ5_COLL_p');
load('FCZ5_COLL_wind');
load('FCZ5_gas');       %   $/therm   12 monthes

load('solar_radiation');  % w/m^2

% t_start=4489;  %% July 8th
% t_end=4632;
% t_m=7;

% t_start=4300;  %% July 8th
% t_end=4440;

t_start=4681;   %% July 14th
t_end=4848;
t_m=7;

% t_start=4777;  %% July 8th
% t_end=4920;
% t_m=7;

array_area=10000;  % 10000 m^2
solar_efficiency=0.3;

SMUD_solar=array_area*solar_efficiency*solar_radiation/1000; % kw

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);


figure(1);
set(gca,'FontSize',45,'FontName','Arial');
plot(a1/1000,'b-','LineWidth',7);
hold on
plot(wind1/1000,'g^:','MarkerSize',8,'LineWidth',7);
hold on
plot(a/1000,'ko--','MarkerSize',8,'LineWidth',7);
% hold on
% plot(SMUD_solar(t_start:t_end,1)/1000,'gs-','MarkerSize',10,'LineWidth',7);

xlabel('t /hour','FontSize',45,'FontName','Arial'); 
ylabel('MWh','FontSize',45,'FontName','Arial'); 

h = legend('Electricity','Wind','Net',1);
set(h,'Interpreter','none');

figure(2);
set(gca,'FontSize',45,'FontName','Arial');
plot(b/29.3,'r-','LineWidth',7);

xlabel('t /hour','FontSize',45,'FontName','Arial'); 
ylabel('Therm','FontSize',45,'FontName','Arial'); 

h = legend('Heat',1);
set(h,'Interpreter','none');