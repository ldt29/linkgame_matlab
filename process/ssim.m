function maxy = ssim(in1,in2)
%SSIM 此处显示有关此函数的摘要
%   求相关性
    y =xcorr2(in1,in2);
    y1 = xcorr2(in1,in1);
    y2 = xcorr2(in2,in2);
    maxy=max(max(y))/sqrt(max(max(y1)))/sqrt(max(max(y2)));
end

