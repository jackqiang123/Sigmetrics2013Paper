clear all
clc
load('R_ratio1_summer2');

figure(1);
set(gca,'FontSize',40,'FontName','Arial');
plot(0:n-1,ratio_e_BKE,'b-','LineWidth',7);
hold on
plot(0:n-1,ratio_t_BKE,'ro--','MarkerSize',9,'LineWidth',7);

xlabel('w /hour','FontSize',40,'FontName','Arial'); 
ylabel('Ratio','FontSize',40,'FontName','Arial'); 

h = legend('Empirical Ratio','Theoretical Ratio',1);
set(h,'Interpreter','none');