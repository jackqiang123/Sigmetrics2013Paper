clear all
clc
load('R_w_summer2');

figure(1);
set(gca,'FontSize',40,'FontName','Arial');
plot(0:n-1,cr_OPT,'b-','LineWidth',7);
hold on
plot(0:n-1,cr_CHASE,'ro--','MarkerSize',10,'LineWidth',7);
hold on
plot(0:n-1,cr_RHC,'k^:','MarkerSize',10,'LineWidth',7);

xlabel('w /hour','FontSize',40,'FontName','Arial'); 
ylabel('%Cost Reduction','FontSize',40,'FontName','Arial'); 

h = legend('OPT','CHASE','RHC',1);
set(h,'Interpreter','none');