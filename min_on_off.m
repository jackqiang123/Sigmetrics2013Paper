function  flag = min_on_off( y,Tud,a)

[T,temp]=size(y);
y1=[0;y];

flag=1;

if a==1
    for t=T:-1:max(T-Tud+2,1)
        if (y1(t)==1)&&(y1(t+1)==0)
            flag=0;
            break
        end
    end           
else
    for t=T:-1:max(T-Tud+2,1)
        if (y1(t)==0)&&(y1(t+1)==1)
            flag=0;
            break
        end
    end  
end

end