function [y,x] = prefourier(ex,fs)
%PERFOURIER 此处显示有关此函数的摘要
%   此处显示详细说明
% ex 样本
% fs 取样频率
    y =fft(ex);
    y(1)=[];
    n = length(ex);
    y = abs(y(1:floor(n/2))).^2;
    x=(1:n/2)/n*fs;
    %figure;
    %plot(x,y);
end

