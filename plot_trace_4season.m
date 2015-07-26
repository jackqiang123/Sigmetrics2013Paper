clear all
clc
load('FCZ5_COLL_a');
load('FCZ5_COLL_b');
load('FCZ5_COLL_p');
load('FCZ5_COLL_wind');
load('FCZ5_gas');       %   $/therm   12 monthes

% winter
t_start=169;  %% Jan 8th~14th      winter
t_end=336;
t_m=1;

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
psell=ones(168,1)*mean(p)*0.3;
T=t_end-t_start+1;

figure(1);
tt=1:T;
subplot(2,1,1);
[AX,H1,H2]=plotyy(tt,a/1000,tt,b/29.3,'plot');
set(get(AX(1),'Ylabel'),'String','MWh','FontSize',38,'FontName','Arial','color','b'); 
set(get(AX(2),'Ylabel'),'String','Therm','FontSize',38,'FontName','Arial','color','r'); 

set(H1,'LineStyle','-','color','b','LineWidth',5);
set(H2,'LineStyle','--','color','r','LineWidth',5);

set(AX(1),'FontSize',38,'ycolor','b','ytick',[0:10:40],'ylim',[0,40],'xticklabel',[],'xlim',[0,168]);
set(AX(2),'FontSize',38,'ycolor','r','ytick',[0:600:1800],'ylim',[0,1800],'xticklabel',[],'xlim',[0,168]);
h = legend('Electricity Net','Heat',1);
set(h,'Interpreter','none','FontSize',38);

subplot(2,1,2);
% set(gca,'FontSize',30,'FontName','Arial');
% plot(tt,p,'k-','LineWidth',3); 
% ylabel('$/KWh','FontSize',30,'FontName','Arial'); 
% xlabel('t/hour','FontSize',30,'FontName','Arial'); 
% set(gca,'ytick',[0:0.1:0.3],'ylim',[0,0.3],'xlim',[0,168]);
[AX,H1,H2]=plotyy(tt,p,tt,psell,'plot');
set(get(AX(1),'Ylabel'),'String','$/KWh','FontSize',38,'FontName','Arial','color','k'); 
%set(get(AX(2),'Ylabel'),'String','$/KWh','FontSize',30,'FontName','Arial','color','r'); 

set(H1,'LineStyle','-','color','k','LineWidth',5);
set(H2,'LineStyle','-.','color','k','LineWidth',5);

set(AX(1),'FontSize',40,'ycolor','k','ytick',[0:0.1:0.3],'ylim',[0,0.3],'xticklabel',[],'xlim',[0,168]);
set(AX(2),'FontSize',40,'ycolor','k','ytick',[0:0.1:0.3],'ylim',[0,0.3],'xticklabel',[],'xlim',[0,168]);
h = legend('Grid Price $p_{b}(t)$','Grid Price $p_{s}(t)$',1);
set(h,'Interpreter','none','FontSize',40);

clear a1
clear a
clear b
clear wind1
clear p

% spring
% t_start=2161;  %% Apr 1st   spring
% t_end=2328;  
% t_m=4;
% 
% a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
% wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));
% 
% a=max(zeros(t_end-t_start+1,1),a1-wind1);
% b=ceil(FCZ5_COLL_b(t_start:t_end,1));
% p=FCZ5_COLL_p(t_start:t_end,1);
% 
% T=t_end-t_start+1;
% 
% figure(2);
% tt=1:T;
% subplot(2,1,1);
% [AX,H1,H2]=plotyy(tt,a/1000,tt,b/29.3,'plot');
% set(get(AX(1),'Ylabel'),'String','MWh','FontSize',30,'FontName','Arial','color','b'); 
% set(get(AX(2),'Ylabel'),'String','Therm','FontSize',30,'FontName','Arial','color','r'); 
% 
% set(H1,'LineStyle','-','color','b','LineWidth',3);
% set(H2,'LineStyle','--','color','r','LineWidth',3);
% 
% set(AX(1),'FontSize',30,'ycolor','b','ytick',[0:10:30],'ylim',[0,30],'xticklabel',[],'xlim',[0,168]);
% set(AX(2),'FontSize',30,'ycolor','r','ytick',[0:600:1800],'ylim',[0,1800],'xticklabel',[],'xlim',[0,168]);
% h = legend('Electricity Net','Heat',1);
% set(h,'Interpreter','none','FontSize',22);
% 
% subplot(2,1,2);
% set(gca,'FontSize',30,'FontName','Arial');
% plot(tt,p,'k-','LineWidth',3); 
% ylabel('$/KWh','FontSize',30,'FontName','Arial'); 
% xlabel('t/hour','FontSize',30,'FontName','Arial'); 
% set(gca,'ytick',[0:0.1:0.3],'ylim',[0,0.3],'xlim',[0,168]);
% 
% clear a1
% clear a
% clear b
% clear wind1
% clear p

% summer
t_start=4681;   %% July 15th~21th  summer
t_end=4848;
t_m=7;

a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));

a=max(zeros(t_end-t_start+1,1),a1-wind1);
b=ceil(FCZ5_COLL_b(t_start:t_end,1));
p=FCZ5_COLL_p(t_start:t_end,1);
psell=ones(168,1)*mean(p)*0.3;
T=t_end-t_start+1;

figure(3);
tt=1:T;
subplot(2,1,1);
[AX,H1,H2]=plotyy(tt,a/1000,tt,b/29.3,'plot');
set(get(AX(1),'Ylabel'),'String','MWh','FontSize',38,'FontName','Arial','color','b'); 
set(get(AX(2),'Ylabel'),'String','Therm','FontSize',38,'FontName','Arial','color','r'); 

set(H1,'LineStyle','-','color','b','LineWidth',5);
set(H2,'LineStyle','--','color','r','LineWidth',5);

set(AX(1),'FontSize',38,'ycolor','b','ytick',[0:10:40],'ylim',[0,40],'xticklabel',[],'xlim',[0,168]);
set(AX(2),'FontSize',38,'ycolor','r','ytick',[0:600:1800],'ylim',[0,1800],'xticklabel',[],'xlim',[0,168]);
h = legend('Electricity Net','Heat',1);
set(h,'Interpreter','none','FontSize',35);

subplot(2,1,2);
% set(gca,'FontSize',30,'FontName','Arial');
% plot(tt,p,'k-','LineWidth',3); 
% ylabel('$/KWh','FontSize',30,'FontName','Arial'); 
% xlabel('t/hour','FontSize',30,'FontName','Arial'); 
% set(gca,'ytick',[0:0.1:0.3],'ylim',[0,0.3],'xlim',[0,168]);
[AX,H1,H2]=plotyy(tt,p,tt,psell,'plot');
set(get(AX(1),'Ylabel'),'String','$/KWh','FontSize',38,'FontName','Arial','color','k'); 
%set(get(AX(2),'Ylabel'),'String','$/KWh','FontSize',30,'FontName','Arial','color','r'); 

set(H1,'LineStyle','-','color','k','LineWidth',5);
set(H2,'LineStyle','-.','color','k','LineWidth',5);

set(AX(1),'FontSize',40,'ycolor','k','ytick',[0:0.1:0.3],'ylim',[0,0.3],'xticklabel',[],'xlim',[0,168]);
set(AX(2),'FontSize',40,'ycolor','k','ytick',[0:0.1:0.3],'ylim',[0,0.3],'xticklabel',[],'xlim',[0,168]);
h = legend('Grid Price $p_{b}(t)$','Grid Price $p_{s}(t)$',1);
set(h,'Interpreter','none','FontSize',40);

clear a1
clear a
clear b
clear wind1
clear p

% autumn
% t_start=6553;  %% Oct 1st   autumn
% t_end=6720;  
% t_m=10;
% 
% a1=ceil(FCZ5_COLL_a(t_start:t_end,1));
% wind1=ceil(FCZ5_COLL_wind(t_start:t_end,1));
% 
% a=max(zeros(t_end-t_start+1,1),a1-wind1);
% b=ceil(FCZ5_COLL_b(t_start:t_end,1));
% p=FCZ5_COLL_p(t_start:t_end,1);
% 
% T=t_end-t_start+1;
% 
% figure(4);
% tt=1:T;
% subplot(2,1,1);
% [AX,H1,H2]=plotyy(tt,a/1000,tt,b/29.3,'plot');
% set(get(AX(1),'Ylabel'),'String','MWh','FontSize',30,'FontName','Arial','color','b'); 
% set(get(AX(2),'Ylabel'),'String','Therm','FontSize',30,'FontName','Arial','color','r'); 
% 
% set(H1,'LineStyle','-','color','b','LineWidth',3);
% set(H2,'LineStyle','--','color','r','LineWidth',3);
% 
% set(AX(1),'FontSize',30,'ycolor','b','ytick',[0:10:30],'ylim',[0,30],'xticklabel',[],'xlim',[0,168]);
% set(AX(2),'FontSize',30,'ycolor','r','ytick',[0:600:1800],'ylim',[0,1800],'xticklabel',[],'xlim',[0,168]);
% h = legend('Electricity Net','Heat',1);
% set(h,'Interpreter','none','FontSize',22);
% 
% subplot(2,1,2);
% set(gca,'FontSize',30,'FontName','Arial');
% plot(tt,p,'k-','LineWidth',3); 
% ylabel('$/KWh','FontSize',30,'FontName','Arial'); 
% xlabel('t/hour','FontSize',30,'FontName','Arial'); 
% set(gca,'ytick',[0:0.1:0.3],'ylim',[0,0.3],'xlim',[0,168]);
% 
% clear a1
% clear a
% clear b
% clear wind1
% clear p