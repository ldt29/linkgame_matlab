function gameMap = construct(m, n, classNum)
% 生成一个游戏区域

% 参数说明：

% 输入参数：
% m、n为游戏区域行数和列数
% classNum为分类数

% 输出参数：
% gameMap为m*n的整数矩阵，每一个元素取值范围为[1,colorNum]，代表该方块类别
    
% 最朴素的随机算法，不保证有解
    gameMap = randi(classNum, 1, m * n / 2);
    gameMap = [gameMap, gameMap];
    gameMap = gameMap(randperm(m * n));
    gameMap = reshape(gameMap, m, n);
end

