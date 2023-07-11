clc;clear;

% 宽度 W_B 54
% 高度 H_B 68
% 左侧空白宽度 X_S 20
% 上方空白高度 Y_S 20

pic="graycapture.jpg";

ggt=int32(imread(pic));


[n,m]=size(ggt);

%%%%%  宽度  %%%%%
ex1 = ggt(10,:);

num=20;

for idx=1:num-1
    ex1=ex1+ggt(idx*int32(n/num),:);
end
ex1=ex1/num;

% 消除噪声

ex1 = resample(double(ex1),1,20);
ex1 = resample(ex1,20,1);

figure;

plot(1:length(ex1),ex1);

[ex1_fft,t1]=prefourier(ex1,1);

[max1,i1]=max(ex1_fft);

W_B=round(1/t1(i1));

% 左侧空白宽度 

[temp1,X_S]=max(ex1(1:length(ex1)/2));


figure;

plot(t1,ex1_fft);
ylabel("Amplitude");
xlabel("Frequency");


%%%%%  高度  %%%%%
ex2 = ggt(:,10);

num=20;

for idx=1:num-1
    ex2=ex2+ggt(:,idx*int32(m/num));
end
ex2=ex2/num;

% 消除噪声

ex2 = resample(double(ex2),1,20);
ex2 = resample(ex2,20,1);

figure;

plot(1:length(ex2),ex2);

[ex2_fft,t2]=prefourier(ex2,1);

[max2,i2]=max(ex2_fft);

H_B=round(1/t2(i2));

% 上方空白宽度 

[temp1,Y_S]=max(ex2(1:length(ex2)/2));


figure;

plot(t2,ex2_fft);
ylabel("Amplitude");
xlabel("Frequency");
 
%%%%%  分割  %%%%%

ggt2=imread(pic);


X_N=floor((m-X_S)/W_B);
Y_N=floor((n-Y_S)/H_B);


ggt2(Y_S+H_B*Y_N+1:n,:)=[];
ggt2(1:Y_S,:)=[];
ggt2(:,X_S+W_B*X_N+1:m)=[];
ggt2(:,1:X_S)=[];


figure;
imshow(ggt2);

sub_x=ones(1,X_N)*W_B;
sub_y=ones(1,Y_N)*H_B;
sub_ggt=mat2cell(ggt2,sub_y,sub_x);



%%%%%  复原 %%%%%

figure;
for idy=1:Y_N
    for idx=1:X_N
        subplot('Position',[1/X_N*(idx-1),1-1/Y_N*idy,1/X_N,1/Y_N]);
        temp=sub_ggt{idy,idx};
        imshow(temp);
        
    end
end

