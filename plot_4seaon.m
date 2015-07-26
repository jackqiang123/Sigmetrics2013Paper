clear all
clc
load('FCZ5_COLL_4season');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% with chp
cr_RHC_spring=(c_GRID_spring-c_RHC_spring)/c_GRID_spring*100;
cr_BKE_spring=(c_GRID_spring-c_CHASE_spring)/c_GRID_spring*100;
cr_OPT_spring=(c_GRID_spring-c_OPT_spring)/c_GRID_spring*100;

cr_RHC_summer=(c_GRID_summer-c_RHC_summer)/c_GRID_summer*100;
cr_BKE_summer=(c_GRID_summer-c_CHASE_summer)/c_GRID_summer*100;
cr_OPT_summer=(c_GRID_summer-c_OPT_summer)/c_GRID_summer*100;

cr_RHC_autumn=(c_GRID_autumn-c_RHC_autumn)/c_GRID_autumn*100;
cr_BKE_autumn=(c_GRID_autumn-c_CHASE_autumn)/c_GRID_autumn*100;
cr_OPT_autumn=(c_GRID_autumn-c_OPT_autumn)/c_GRID_autumn*100;

cr_RHC_winter=(c_GRID_winter-c_RHC_winter)/c_GRID_winter*100;
cr_BKE_winter=(c_GRID_winter-c_CHASE_winter)/c_GRID_winter*100;
cr_OPT_winter=(c_GRID_winter-c_OPT_winter)/c_GRID_winter*100;

figure(1)
set(gca,'FontSize',45,'FontName','Arial');
bar([cr_RHC_spring,cr_BKE_spring,cr_OPT_spring;cr_RHC_summer,cr_BKE_summer,cr_OPT_summer;cr_RHC_autumn,cr_BKE_autumn,cr_OPT_autumn;cr_RHC_winter,cr_BKE_winter,cr_OPT_winter]);
ylabel('%Cost Reduction','FontSize',45,'FontName','Arial'); 
set(gca,'xticklabel',[]);
h = legend('RHC','CHASE','OPT',1);
set(h,'Interpreter','none');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% without chp
cr_RHC_spring1=(c_GRID_spring1-c_RHC_spring1)/c_GRID_spring1*100;
cr_BKE_spring1=(c_GRID_spring1-c_CHASE_spring1)/c_GRID_spring1*100;
cr_OPT_spring1=(c_GRID_spring1-c_OPT_spring1)/c_GRID_spring1*100;

cr_RHC_summer1=(c_GRID_summer1-c_RHC_summer1)/c_GRID_summer1*100;
cr_BKE_summer1=(c_GRID_summer1-c_CHASE_summer1)/c_GRID_summer1*100;
cr_OPT_summer1=(c_GRID_summer1-c_OPT_summer1)/c_GRID_summer1*100;

cr_RHC_autumn1=(c_GRID_autumn1-c_RHC_autumn1)/c_GRID_autumn1*100;
cr_BKE_autumn1=(c_GRID_autumn1-c_CHASE_autumn1)/c_GRID_autumn1*100;
cr_OPT_autumn1=(c_GRID_autumn1-c_OPT_autumn1)/c_GRID_autumn1*100;

cr_RHC_winter1=(c_GRID_winter1-c_RHC_winter1)/c_GRID_winter1*100;
cr_BKE_winter1=(c_GRID_winter1-c_CHASE_winter1)/c_GRID_winter1*100;
cr_OPT_winter1=(c_GRID_winter1-c_OPT_winter1)/c_GRID_winter1*100;

figure(2)
set(gca,'FontSize',45,'FontName','Arial');
bar([cr_RHC_spring1,cr_BKE_spring1,cr_OPT_spring1;cr_RHC_summer1,cr_BKE_summer1,cr_OPT_summer1;cr_RHC_autumn1,cr_BKE_autumn1,cr_OPT_autumn1;cr_RHC_winter1,cr_BKE_winter1,cr_OPT_winter1]);
ylabel('%Cost Reduction','FontSize',45,'FontName','Arial'); 
set(gca,'xticklabel',[]);
h = legend('RHC','CHASE','OPT',1);
set(h,'Interpreter','none');

