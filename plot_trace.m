clear all
clc
load('R_w_summer2');

load('solar_radiation');  % w/m^2

% t_start=4489;  %% July 8th
% t_end=4632;
% t_m=7;

t_start=145;  %% Jan 8th
t_end=288;
t_m=1;

array_area=10000;  % 10000 m^2
solar_efficiency=0.3;

SMUD_solar=array_area*solar_efficiency*solar_radiation/1000; % kw

figure(1);
set(gca,'FontSize',45,'FontName','Arial');
plot(a1/1000,'b-','LineWidth',7);
hold on
plot(wind1/1000,'k^:','MarkerSize',7,'LineWidth',7);

xlabel('t /hour','FontSize',45,'FontName','Arial'); 
ylabel('MWh','FontSize',45,'FontName','Arial'); 

h = legend('Electricity','Wind',1);
set(h,'Interpreter','none');

figure(2);
set(gca,'FontSize',45,'FontName','Arial');
plot(a/1000,'b-','LineWidth',7);
hold on
plot(b/1000,'ro--','MarkerSize',8,'LineWidth',7);

xlabel('t /hour','FontSize',45,'FontName','Arial'); 
ylabel('MWh','FontSize',45,'FontName','Arial'); 

h = legend('Net electricity','Heat',1);
set(h,'Interpreter','none');