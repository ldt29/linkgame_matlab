function gameMap = construct(m, n, classNum)
% ����һ����Ϸ����

% ����˵����

% ���������
% m��nΪ��Ϸ��������������
% classNumΪ������

% ���������
% gameMapΪm*n����������ÿһ��Ԫ��ȡֵ��ΧΪ[1,colorNum]������÷������
    
% �����ص�����㷨������֤�н�
    gameMap = randi(classNum, 1, m * n / 2);
    gameMap = [gameMap, gameMap];
    gameMap = gameMap(randperm(m * n));
    gameMap = reshape(gameMap, m, n);
end

