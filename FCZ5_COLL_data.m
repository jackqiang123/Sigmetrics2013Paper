clear all
clc

% load('fcz5_college_elec');   %  kWh
% load('fcz5_college_heat');    %  kBtu
%                         %  3.412 kBtu=1 kwh
% 
% % 11 sampled colleges    total site kwh
% % small    3                   600,780
% % medium   3                 2,670,037
% % large    3                21,012,683
% % census   2                43,808,644
% 
% % percent of one census
% percent_census=0.5*43808644/(600780+2670037+21012683+43808644);
% 
% % accoding to  SMUD_COLL.xls
% heat_demand_factor=(1201+350)/1579;  
% temp1=fcz5_college_elec*percent_census;
% temp2=fcz5_college_heat*percent_census*heat_demand_factor/3.412;
% 
% FCZ5_COLL_a=zeros(365*24,1);
% FCZ5_COLL_b=zeros(365*24,1);
% 
% for i=1:365
%     for t=1:24
%         FCZ5_COLL_a((i-1)*24+t,1)=temp1(i,t);
%         FCZ5_COLL_b((i-1)*24+t,1)=temp2(i,t);
%     end
% end

%generate price
% SUMMER SEASON - MAY 1 through OCT 31            $/KWh
% 0~8 ........................................... 0.056
% 8~12 .......................................... 0.103
% 12~18 ......................................... 0.232
% 18~21 ......................................... 0.103
% 21~24 ......................................... 0.056

% WINTER SEASON - other time                      $/KWh
% 0~8 ........................................... 0.072
% 8~21 .......................................... 0.116
% 21~24 ......................................... 0.072

temp3=zeros(365*24,1);       % price

for i=1:120
    for t=1:24
        temp3(i,t)=0.072;
    end
    for t=8:21
        temp3(i,t)=0.116;
    end
end

for i=305:365
    for t=1:24
        temp3(i,t)=0.072;
    end
    for t=8:21
        temp3(i,t)=0.116;
    end
end

for i=121:304
    for t=1:8
        temp3(i,t)=0.056;
    end
    for t=8:12
        temp3(i,t)=0.103;
    end
    for t=12:18
        temp3(i,t)=0.232;
    end
    for t=18:21
        temp3(i,t)=0.103;
    end
    for t=21:24
        temp3(i,t)=0.056;
    end
end

FCZ5_COLL_p=zeros(365*24,1);

for i=1:365
    for t=1:24
        FCZ5_COLL_p((i-1)*24+t,1)=temp3(i,t);
    end
end













