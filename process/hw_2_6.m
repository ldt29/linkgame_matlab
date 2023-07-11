clc;clear;

load('fix_hash.mat');

load('subofgc.mat');

mtx=hashs;

[n,m]=size(sub_ggt);

[N,M]=size(sub_ggt{1,1});

dec_pic=zeros(N,M);

detected=n*m/2;


%%%%%  复原 %%%%%

figure;
for idy=1:n
    for idx=1:m
        subplot('Position',[1/m*(idx-1),1-1/n*idy,1/m,1/n]);
        temp=sub_ggt{idy,idx};
        imshow(temp);
        
    end
end

%%%%% 消除 %%%%%

for idx =1:detected
    pause(2);
    step=omg(mtx);
    x1=step(2);
    y1=step(3);
    x2=step(4);
    y2=step(5);
    mtx(x1,y1)=0;
    mtx(x2,y2)=0;
    subplot('Position',[1/m*(y1-1),1-1/n*x1,1/m,1/n]);
    imshow(dec_pic);
    subplot('Position',[1/m*(y2-1),1-1/n*x2,1/m,1/n]);
    imshow(dec_pic);
    pause(1)
    subplot('Position',[1/m*(y1-1),1-1/n*x1,1/m,1/n]);
    imshow(sub_ggt{x1,y1});
    subplot('Position',[1/m*(y2-1),1-1/n*x2,1/m,1/n]);
    imshow(sub_ggt{x2,y2});
    pause(1);
    subplot('Position',[1/m*(y1-1),1-1/n*x1,1/m,1/n]);
    imshow(dec_pic);
    subplot('Position',[1/m*(y2-1),1-1/n*x2,1/m,1/n]);
    imshow(dec_pic);
end

