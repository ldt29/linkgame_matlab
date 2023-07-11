clc;clear;

load('listsorted_ggt.mat');

load('subofgc.mat');


[n,m]=size(sub_ggt);

hashs = zeros(n,m);

index=1;

% 映射
for idx=1:250
    x1=listsorted(idx,1);
    y1=listsorted(idx,2);
    x2=listsorted(idx,3);
    y2=listsorted(idx,4);
    if hashs(x1,y1) == 0 && hashs(x2,y2) == 0
        hashs(x1,y1) = index;
        hashs(x2,y2) = index;
        for idy =idx+1:250
            x_1=listsorted(idy,1);
            y_1=listsorted(idy,2);
            x_2=listsorted(idy,3);
            y_2=listsorted(idy,4);
            if x1==x_1 && y1==y_1 || x1==x_2 && y1==y_2 || (x2==x_1 && y2==y_1) || (x2==x_2 && y2==y_2)
                hashs(x_1,y_1) = index;
                hashs(x_2,y_2) = index;
            end
        end
        index=index+1;
    else
        if hashs(x1,y1) == 0
            hashs(x1,y1) = hashs(x2,y2);
        else
            if hashs(x2,y2) == 0
                hashs(x2,y2) = hashs(x1,y1);
            end
        end
    end

end

% 对应关系表
for idx=1:n
    for idy=1:m
        subplot(floor(index/4)+1,4,hashs(idx,idy));
            imshow(sub_ggt{idx,idy});
            xlabel(hashs(idx,idy));
    end
end