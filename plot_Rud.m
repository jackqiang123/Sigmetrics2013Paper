clear all
clc
load('R_Rud_summer2_w3');

tt=1:n;
figure(1);
set(gca,'FontSize',45,'FontName','Arial');
plot(10*tt,cr_OPT,'b-','LineWidth',7);
hold on
plot(10*tt,cr_BKE,'ro--','MarkerSize',10,'LineWidth',7);
hold on
plot(10*tt,cr_RHC,'k^:','MarkerSize',10,'LineWidth',7);

xlabel('% Ru/L (Rd=Ru)','FontSize',45,'FontName','Arial'); 
ylabel('%Cost Reduction','FontSize',45,'FontName','Arial'); 
h = legend('OPT','CHASE','RHC',1);
set(h,'Interpreter','none');