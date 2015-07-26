clear all
clc
load('R_sigma_summer2_berror_w3');

tt=0:n-1;
figure(1);
set(gca,'FontSize',40,'FontName','Arial');
plot(0.1*tt,cr_OPT,'b-','LineWidth',7);
hold on
plot(0.1*tt,cr_BKE,'ro--','MarkerSize',10,'LineWidth',7);
hold on
plot(0.1*tt,cr_RHC,'k^:','MarkerSize',10,'LineWidth',7);
hold on

clear all
clc
load('R_sigma_summer2_berror_w1');

tt=0:n-1;
plot(0.1*tt,cr_BKE,'ro--','MarkerSize',10,'LineWidth',7);
hold on
plot(0.1*tt,cr_RHC,'k^:','MarkerSize',10,'LineWidth',7);
xlabel('standard deviation','FontSize',40,'FontName','Arial'); 
ylabel('%Cost Reduction','FontSize',40,'FontName','Arial'); 

h = legend('OFFLINE','CHASE','RHC',1);
set(h,'Interpreter','none');