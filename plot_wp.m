clear all
clc
load('R_wtemp');

pl=19000;
y=90*ones(61,1);
for i=1:61
    for j=1:90
        if vm_BKE(i,j)<=pl;
            y(i,1)=j;
            break
        end
    end
end
    
figure(1);
set(gca,'FontSize',40,'FontName','Arial');
plot(1:61,y/90*100,'b-','LineWidth',7);

xlabel('%Wind Penetration','FontSize',40,'FontName','Arial'); 
ylabel('%Needed Capacity','FontSize',40,'FontName','Arial'); 
