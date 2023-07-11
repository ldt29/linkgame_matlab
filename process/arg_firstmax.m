function answer = arg_firstmax(ex,t)
%FIRSTMAX 此处显示有关此函数的摘要
%   此处显示详细说明
    t(ex<max(ex)/3)=[];
    answer=t(1);
end

