tt=1:480;
figure(1);
set(gca,'FontSize',40,'FontName','Arial');
plot(tt,SMUD_COLL_a(4345:4824),'b','LineWidth',3);
hold on
plot(tt,SMUD_COLL_b(4345:4824),'r','LineWidth',3);

xlabel('hour','FontSize',40,'FontName','Arial'); 
ylabel('kwh','FontSize',40,'FontName','Arial'); 

figure(2);
set(gca,'FontSize',40,'FontName','Arial');
plot(tt,SMUD_COLL_p(4345:4824),'b','LineWidth',3);

xlabel('hour','FontSize',40,'FontName','Arial'); 
ylabel('$/kwh','FontSize',40,'FontName','Arial'); 

