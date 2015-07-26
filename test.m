% % without chp
% cr_RHC_spring1=(c_GRID_spring1-c_RHC_spring1)/c_GRID_spring1*100;
% cr_BKE_spring1=(c_GRID_spring1-c_BKE_spring1)/c_GRID_spring1*100;
% cr_OPT_spring1=(c_GRID_spring1-c_OPT_spring1)/c_GRID_spring1*100;
% 
% cr_RHC_summer1=(c_GRID_summer1-c_RHC_summer1)/c_GRID_summer1*100;
% cr_BKE_summer1=(c_GRID_summer1-c_BKE_summer1)/c_GRID_summer1*100;
% cr_OPT_summer1=(c_GRID_summer1-c_OPT_summer1)/c_GRID_summer1*100;
% 
% cr_RHC_autumn1=(c_GRID_autumn1-c_RHC_autumn1)/c_GRID_autumn1*100;
% cr_BKE_autumn1=(c_GRID_autumn1-c_BKE_autumn1)/c_GRID_autumn1*100;
% cr_OPT_autumn1=(c_GRID_autumn1-c_OPT_autumn1)/c_GRID_autumn1*100;
% 
% cr_RHC_winter1=(c_GRID_winter1-c_RHC_winter1)/c_GRID_winter1*100;
% cr_BKE_winter1=(c_GRID_winter1-c_BKE_winter1)/c_GRID_winter1*100;
% cr_OPT_winter1=(c_GRID_winter1-c_OPT_winter1)/c_GRID_winter1*100;

figure(2)
set(gca,'FontSize',45,'FontName','Arial');
bar([cr_RHC_spring1,cr_BKE_spring1,cr_OPT_spring1;cr_RHC_summer1,cr_BKE_summer1,cr_OPT_summer1;cr_RHC_autumn1,cr_BKE_autumn1,cr_OPT_autumn1;cr_RHC_winter1,cr_BKE_winter1,cr_OPT_winter1]);
ylabel('%Cost Reduction','FontSize',45,'FontName','Arial'); 
set(gca,'xticklabel',[]);
h = legend('RHC','CHASE','OPT',1);
set(h,'Interpreter','none');