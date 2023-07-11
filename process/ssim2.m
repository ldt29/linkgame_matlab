function maxy = ssim(in1,in2)
%SSIM 此处显示有关此函数的摘要
%   求相关性
%   升级版
    y =corr2(in1,in2);
    maxy=y;
end



