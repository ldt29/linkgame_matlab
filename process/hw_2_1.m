clc;clear;

% 宽度 W_B 79
% 高度 H_B 97
% 左侧空白宽度 X_S 25
% 上方空白高度 Y_S 35

pic="graygroundtruth.jpg";

ggt=abs(int32(imread(pic))-255);

[n,m]=size(ggt);

%%%%%  宽度  %%%%%
ex1 = ggt(1,:);

num=int32(n/50);

for idx=1:num-1
    ex1=ex1+ggt(idx*50,:);
end
ex1=ex1/num;

figure;

plot(1:length(ex1),ex1);

ex1(ex1<max(ex1)/1.5)=0;

figure;

plot(1:length(ex1),ex1);

% 左侧空白宽度

X_S=arg_firstmax(ex1,1:length(ex1));

[ex1_fft,t1]=prefourier(ex1,1);

figure;

plot(t1,ex1_fft);
ylabel("Amplitude");
xlabel("Frequency");

basefreq1=arg_firstmax(ex1_fft,t1);

W_B=floor(1/basefreq1)+1;


%%%%%  高度  %%%%%

ex2 = ggt(:,1);

num=int32(m/50);

for idy=1:num-1
    ex2=ex2+ggt(:,idy*50);
end
ex2=ex2/num;

figure;

plot(1:length(ex2),ex2);

ex2(ex2<max(ex2)/1.5)=0;

figure;

plot(1:length(ex2),ex2);

% 上方空白宽度

Y_S=arg_firstmax(ex2,1:length(ex2));

[ex2_fft,t2]=prefourier(ex2,1);
figure;

plot(t2,ex2_fft);
ylabel("Amplitude");
xlabel("Frequency");

basefreq2=arg_firstmax(ex2_fft,t2);

H_B=floor(1/basefreq2)+1;

%%%%%  分割  %%%%%

ggt2=imread(pic);


X_N=floor((m-X_S)/W_B);
Y_N=floor((n-Y_S)/H_B);

figure;
imshow(ggt2);

ggt2(Y_S+H_B*Y_N+1:n,:)=[];
ggt2(1:Y_S,:)=[];
ggt2(:,X_S+W_B*X_N+1:m)=[];
ggt2(:,1:X_S)=[];


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