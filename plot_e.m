clear all
clc
load('R_e_summer2_w3');

tt=0.6:0.2:2.6;
figure(1);
set(gca,'FontSize',45,'FontName','Arial');
plot(tt,cr_OPT,'b-','LineWidth',7);
hold on
plot(tt,cr_BKE,'ro--','MarkerSize',10,'LineWidth',7);
hold on
plot(tt,cr_RHC,'k^:','MarkerSize',10,'LineWidth',7);

xlabel('\eta','FontSize',45,'FontName','Arial'); 
ylabel('%Cost Reduction','FontSize',45,'FontName','Arial'); 
h = legend('OPT','CHASE','RHC',1);
set(h,'Interpreter','none');