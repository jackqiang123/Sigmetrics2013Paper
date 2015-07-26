clear all
clc
load('R_summer2_battery');

tt=0:n-1;
figure(1);
set(gca,'FontSize',40,'FontName','Arial');
plot(0.3*tt,cr_BKE,'b-','LineWidth',7);
hold on
plot(0.3*tt,cr_BKE3,'ro--','MarkerSize',10,'LineWidth',7);
% hold on
% plot(0:n-1,cr_RHC,'k^:','MarkerSize',10,'LineWidth',7);

xlabel('Battery Capacity/MWh','FontSize',40,'FontName','Arial'); 
ylabel('%Cost Reduction','FontSize',40,'FontName','Arial'); 

h = legend('CHASE w=0','CHASE w=3 h',1);
set(h,'Interpreter','none');