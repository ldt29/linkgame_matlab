function bool = detect(mtx, x1, y1, x2, y2)
    % ========================== 参数说明 ==========================
    
    % 输入参数中，mtx为图像块的矩阵，类似这样的格式：
    % [ 1 2 3;
    %   0 2 1;
    %   3 0 0 ]
    % 相同的数字代表相同的图案，0代表此处没有块。
    % 可以用[m, n] = size(mtx)获取行数和列数。
    % (x1, y1)与（x2, y2）为需判断的两块的下标，即判断mtx(x1, y1)与mtx(x2, y2)
    % 是否可以消去。
    
    % 注意mtx矩阵与游戏区域的图像不是位置对应关系。下标(x1, y1)在连连看界面中
    % 代表的是以左下角为原点建立坐标系，x轴方向第x1个，y轴方向第y1个
    
    % 输出参数bool = 1表示可以消去，bool = 0表示不能消去。
    
    %% 在下面添加你的代码O(∩_∩)O
    
    [m, n] = size(mtx);
    
    bool = 0;
    
    Zeros1=ZerosofArr(mtx,x1,y1);
    Zeros2=ZerosofArr(mtx,x2,y2);
    % disp(Zeros2(1));
    if mtx(x1,y1) == mtx(x2,y2)
        for idx= 1:1:length(Zeros1(1,:))
              for idy =1:1:length(Zeros2(1,:))
                    if RoworCol(mtx,Zeros1(1,idx),Zeros1(2,idx),Zeros2(1,idy),Zeros2(2,idy))==1
                        bool=1;
                    end
              end
         end
    end
    
       
end
function bool = RoworCol(mtx,x1,y1,x2,y2)
    [m, n] = size(mtx);
    bool=0;
    if x1==x2
        wrong=0;
        for idy= min(y1,y2):1:max(y1,y2)
            if mtx(x1,idy)~=0 && mtx(x1,idy)~=mtx(x1,y1)
                wrong = 1;
            end
        end
        
        if x1==1 || x1==m||wrong==0
            bool=1;
        end
    end
    if y1==y2
        wrong=0;
        
        for idx= min(x1,x2):1:max(x1,x2)
            if mtx(idx,y1)~=0 && mtx(idx,y1)~=mtx(x1,y1)
                wrong = 1;
            end
        end

        if y1==1 || y1==n || wrong==0
            bool=1;
        end
    end
end

function Zeros = ZerosofArr(mtx,x,y)
    x_Zeros=x;
    y_Zeros=y;
    [m, n] = size(mtx);
    flag=1;
    for idx = x+1:1:m
        if mtx(idx,y)==0&&flag==1
            x_Zeros=[x_Zeros,idx];
            y_Zeros=[y_Zeros,y];
           
        else
            if mtx(idx,y)~=0
                flag=0;
            end
        end
    end
    flag=1;
    for idx = x-1:-1:1
        if mtx(idx,y)==0&&flag==1
            x_Zeros=[x_Zeros,idx];
            y_Zeros=[y_Zeros,y];
        else
            if mtx(idx,y)~=0
                flag=0;
            end
        end
    end
    flag=1;
    for idy = y+1:1:n
        if mtx(x,idy)==0&&flag==1
            x_Zeros=[x_Zeros,x];
            y_Zeros=[y_Zeros,idy];
        else
            if mtx(x,idy)~=0
                flag=0;
            end
        end
    end
    flag=1;
    for idy = y-1:-1:1
        if mtx(x,idy)==0&&flag==1
            x_Zeros=[x_Zeros,x];
            y_Zeros=[y_Zeros,idy];
        else
            if mtx(x,idy)~=0
                flag=0;
            end
        end
    end
    Zeros=[x_Zeros;y_Zeros];
end