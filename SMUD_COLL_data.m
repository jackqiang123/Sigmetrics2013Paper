clear all
clc

load('college_elec');   %  kWh
load('college_gas');    %  kBtu
                        %  3.412 kBtu=1 kwh

% 7 sampled colleges
n=7;
% accoding to  SMUD_COLL.xls
heat_demand_factor=(314+71)/389; 
temp1=college_elec/n;
temp2=college_gas/n*heat_demand_factor/3.412;

temp3=zeros(365*24,1);       % price

SMUD_COLL_a=zeros(365*24,1);
SMUD_COLL_b=zeros(365*24,1);

for i=1:365
    for t=1:24
        SMUD_COLL_a((i-1)*24+t,1)=temp1(i,t);
        SMUD_COLL_b((i-1)*24+t,1)=temp2(i,t);
        temp3(i,t)=0.124;
    end
end

%generate price
% SUMMER SEASON - JUNE 1 through SEPTEMBER 30
% On-Peak ?/kWh ................................................................................................................................ 28.37?
% Off-Peak ?/kWh ............................................................................................................................... 10.50?
% On-Peak Hours: Summer weekdays between 3:00 p.m. and 6:00 p.m., exclusive of July 4th and Labor Day holidays.
% Off-Peak Hours: All other summer hours.
%ALL OTHER MONTHS - OCTOBER 1 through MAY 31
% Electricity Usage Charge - ?/kWh for all kWh ......................................................................................... 12.40?

for i=152:273
    for t=1:24
        temp3(i,t)=0.105;
    end
    for t=13:18
        temp3(i,t)=0.2837;
    end
end

SMUD_COLL_p=zeros(365*24,1);

for i=1:365
    for t=1:24
        SMUD_COLL_p((i-1)*24+t,1)=temp3(i,t);
    end
end













