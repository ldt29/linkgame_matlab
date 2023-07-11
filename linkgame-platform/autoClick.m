function  autoClick(steps, GAP_TOP, GAP_LEFT, GRID_WIDTH, GRID_HEIGHT)
% steps为向量，每4个一组，为x1,y1,x2,y2
% 调用pressMouse模拟鼠标点击
% pressMouse(x,y)，x、y为坐标
    
% 定义常量
%     GAP_TOP = 71;
%     GAP_LEFT = 52;
%     GRID_WIDTH = 40;
%     GRID_HEIGHT = 50;
    SLEEP_IN = 0.3;
    SLEEP_OUT = 0.6;
    pause(1);
% 开始点击
    for i = 1 : 4 : length(steps)
        if (~checkActive()), break; end
        x1 = steps(i); y1 = steps(i + 1);
        x2 = steps(i + 2); y2 = steps(i + 3);
        click(x1, y1);
        pause(SLEEP_IN);
        click(x2, y2);
        pause(SLEEP_OUT);
    end
    
    function click(x, y)
        px = GAP_LEFT + (y - 1) * GRID_WIDTH;
        py = GAP_TOP + (x - 1) * GRID_HEIGHT;
        pressMouse(px, py);
    end
end

