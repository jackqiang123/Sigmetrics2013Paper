clear all
clc
load('R_Tud11_summer2_w3');

tt=1:1:10;
figure(1);
set(gca,'FontSize',45,'FontName','Arial');
plot(tt,cr_OPT(1:10,1),'b-','LineWidth',7);
hold on
plot(tt,cr_BKE(1:10,1),'ro--','MarkerSize',10,'LineWidth',7);
hold on
plot(tt,cr_RHC(1:10,1),'k^:','MarkerSize',10,'LineWidth',7);

xlabel('Tu/hour (Tu=Td)','FontSize',45,'FontName','Arial'); 
ylabel('%Cost Reduction','FontSize',45,'FontName','Arial'); 
h = legend('OPT','CHASE','RHC',1);
set(h,'Interpreter','none');