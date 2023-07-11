clc;clear;

load('listsorted_gc.mat');

load('subofgc.mat');

figure;

% 相似度最大却不是同一种精灵的十对图像块

index=[17 18 19 20 22 23 24 25 26 27];
for idx=1:10
    idy=index(idx);
    subplot(5,4,idx*2-1);
    imshow(sub_ggt{listsorted(idy,1),listsorted(idy,2)});
    subplot(5,4,idx*2);
    imshow(sub_ggt{listsorted(idy,3),listsorted(idy,4)});
    xlabel(listsorted(idy,5));
end