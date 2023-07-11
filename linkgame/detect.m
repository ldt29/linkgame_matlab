function bool = detect(mtx, x1, y1, x2, y2)
    % ========================== ����˵�� ==========================
    
    % ��������У�mtxΪͼ���ľ������������ĸ�ʽ��
    % [ 1 2 3;
    %   0 2 1;
    %   3 0 0 ]
    % ��ͬ�����ִ�����ͬ��ͼ����0����˴�û�п顣
    % ������[m, n] = size(mtx)��ȡ������������
    % (x1, y1)�루x2, y2��Ϊ���жϵ�������±꣬���ж�mtx(x1, y1)��mtx(x2, y2)
    % �Ƿ������ȥ��
    
    % ע��mtx��������Ϸ�����ͼ����λ�ö�Ӧ��ϵ���±�(x1, y1)��������������
    % ������������½�Ϊԭ�㽨������ϵ��x�᷽���x1����y�᷽���y1��
    
    % �������bool = 1��ʾ������ȥ��bool = 0��ʾ������ȥ��
    
    %% �����������Ĵ���O(��_��)O
    
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