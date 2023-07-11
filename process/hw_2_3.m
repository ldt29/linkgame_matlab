clc;clear

load('subofgc.mat');


% 设计滤波器
H=[0 0 0 0.01 0 -0.03 0 0.1 0 -0.3 0.5];

H2=ones(21,21);

for idx=1:11
    H2(idx,idx:22-idx)=H2(idx,idx:22-idx)*H(idx);
    if idx<11
        H2(22-idx,idx:22-idx)=H2(22-idx,idx:22-idx)*H(idx);
        H2(idx+1:21-idx,idx)=H2(idx+1:21-idx,idx)*H(idx);
        H2(idx+1:21-idx,22-idx)=H2(idx+1:21-idx,22-idx)*H(idx);
    end

end
figure;
mesh(H2);

% 测试

figure;
imshow(sub_ggt{6,7});

figure;
mesh(sub_ggt{6,7});

ex1= filter2(H2,sub_ggt{6,7});
figure;
mesh(ex1);
figure;
imshow(ex1);


% 批处理
[n,m]=size(sub_ggt);

sub_ggt_H=sub_ggt;

for idx = 1:n
    for idy =1:m
        sub_ggt_H{idx,idy}=filter2(H2,sub_ggt{idx,idy});
    end
end


%相似度排序

list=zeros((n*m+1)*n*m/2,5);
i=1;
for idx=1:n*m
    for idy=idx+1:n*m
        x1=floor((idx-1)/m)+1;
        y1=mod(idx-1,m)+1;
        x2=floor((idy-1)/m)+1;
        y2=mod(idy-1,m)+1;
        list(i,:)=[x1 y1 x2 y2 ssim(sub_ggt_H{x1,y1},sub_ggt_H{x2,y2})];
        i=i+1;
    end
end

[ssimsorted,I]=sort(list(:,5),'descend');


list_A=list(:,1);
list_B=list(:,2);
list_C=list(:,3);
list_D=list(:,4);
listsorted=[list_A(I) list_B(I) list_C(I) list_D(I) ssimsorted];

% 最相似的十对图像块

figure;
for idx=1:10
    subplot(5,4,idx*2-1);
    imshow(sub_ggt{listsorted(idx,1),listsorted(idx,2)});
    subplot(5,4,idx*2);
    imshow(sub_ggt{listsorted(idx,3),listsorted(idx,4)});
    xlabel(listsorted(idx,5));
end

