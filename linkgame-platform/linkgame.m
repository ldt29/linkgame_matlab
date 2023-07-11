function varargout = linkgame(varargin)
% LINKGAME MATLAB code for linkgame.fig
%      LINKGAME, by itself, creates a new LINKGAME or raises the existing
%      singleton*.
%
%      H = LINKGAME returns the handle to a new LINKGAME or the handle to
%      the existing singleton*.
%
%      LINKGAME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINKGAME.M with the given input arguments.
%
%      LINKGAME('Property','Value',...) creates a new LINKGAME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before linkgame_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to linkgame_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help linkgame

% Last Modified by GUIDE v2.5 13-Sep-2015 00:04:24

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @linkgame_OpeningFcn, ...
                       'gui_OutputFcn',  @linkgame_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
% End initialization code - DO NOT EDIT
end


% --- Executes just before linkgame is made visible.
function linkgame_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to linkgame (see VARARGIN)

% Choose default command line output for linkgame
    handles.output = hObject;

% Update handles structure
    guidata(hObject, handles);

% UIWAIT makes linkgame wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% 我的初始化代码
% 定义常量
    handles.maxM = 10; % 最大行数
    handles.maxN = 15; % 最大列数
    handles.choseList = [];
% 动态生成连连看按钮
    load('pics.mat');
    handles.picsModule = pics;
    for i = 1 : handles.maxM
        for j = 1 : handles.maxN
            handles.gamePic{i, j} = [];
            handles.gameBtn{i, j} = uicontrol('Style', 'pushbutton', ...
                'Tag', strcat('btn_game_', num2str(i), '_', num2str(j)), ...
                'Units', 'pixels', ...
                'Position', [(j - 1) * 40 + 35, (handles.maxM - i) * 50 + 28, 41, 51], ...
                'String', '', ...
                'UserData', [i, j], ...
                'CreateFcn', @(hObject, eventdata)linkgame('btn_game_CreateFcn', hObject, eventdata, guidata(hObject)), ...
                'Callback', @(hObject, eventdata)linkgame('btn_game_Callback', hObject, eventdata, guidata(hObject)), ...
                'visible', 'off' ...
            );
        end
    end
% 更新用户变量
    guidata(hObject, handles);
% 自动开始新游戏
    startNewGame(hObject, handles);
    drawAllGameBtn(guidata(hObject));
end


% --- Outputs from this function are returned to the command line.
function varargout = linkgame_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;
end


% --- Executes during object creation, after setting all properties.
function edit_regionM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_regionM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes during object creation, after setting all properties.
function edit_regionN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_regionN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in pushbutton_startPlugin.
function pushbutton_startPlugin_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_startPlugin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 关闭按钮
    set(hObject, 'enable', 'off');
% 获得用户设置外挂数据来源
    if (strcmp('radiobutton_pluginSource_internal', get(get(handles.uipanel_pluginSource, 'SelectedObject'), 'Tag')))
        handles.pluginSource = 0;
    else
        handles.pluginSource = 1;
    end
% 获得用户设置外挂输出模式 
    if (strcmp('radiobutton_pluginCall_one', get(get(handles.uipanel_pluginCall, 'SelectedObject'), 'Tag')))
        handles.pluginOutput = 0;
    else
        handles.pluginOutput = 1;
    end
	guidata(hObject, handles);
% % 窗口自动移动至屏幕左上角
     screenSize = get(0,'screensize');
     p0 = get(gcf, 'Position');
%     p0 = [0, screenSize(4) - p0(4), p0(3:4)];
%     set(gcf, 'Position', p0);
% 获得按键坐标参数
    p1 = get(handles.gameBtn{1,1}, 'Position');
    p2 = get(handles.gameBtn{1,2}, 'Position');
    p3 = get(handles.gameBtn{2,1}, 'Position');
    GRID_WIDTH = p2(1) - p1(1);
    GRID_HEIGHT = p1(2) - p3(2);
    GAP_TOP = screenSize(4) - p0(2) - p1(2) - GRID_HEIGHT / 2;
    GAP_LEFT = p0(1) + p1(1) + GRID_WIDTH / 2;
% 开始外挂
    h = msgbox({'外挂即将启动。' ; '鼠标移出窗口外将自动停止外挂。'});
    set(h, 'WindowStyle', 'modal');
    uiwait;
    if (handles.pluginOutput == 1) % 多次调用
        while (~isempty(handles.aiCandidateList))
            if (~checkActive()), break; end
            if (handles.pluginSource == 0)
                steps = omg(handles.gameMap);
                autoClick(steps(2 : end), GAP_TOP, GAP_LEFT, GRID_WIDTH, GRID_HEIGHT);
            else
                realcapture = user_camera();
                step = ai(realcapture);
                autoClick(step, GAP_TOP, GAP_LEFT, GRID_WIDTH, GRID_HEIGHT);
            end
            handles = guidata(hObject);
        end
    else
         if (handles.pluginSource == 0)
            steps = omg(handles.gameMap);
            autoClick(steps(2 : 5), GAP_TOP, GAP_LEFT, GRID_WIDTH, GRID_HEIGHT);
        else
            realcapture = user_camera();
            step = ai(realcapture);
            autoClick(step, GAP_TOP, GAP_LEFT, GRID_WIDTH, GRID_HEIGHT);
        end       
    end
% 打开按钮
    set(hObject, 'enable', 'on');
end

% --- Executes on button press in pushbutton_startGame.
function pushbutton_startGame_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_startGame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    startNewGame(hObject, handles);
    drawAllGameBtn(guidata(hObject));
end

% --- Executes during object creation, after setting all properties.
function axes_bg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_bg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_bg

% 显示背景    
    axes(hObject);
    img = imread('bg.jpg');
    pos = get(hObject, 'Position');
    imshow(imresize(img, [pos(4), pos(3)]));
end

function btn_game_CreateFcn(hObject, eventdata, handles)
    drawGameBtn(hObject, handles);
end

function drawGameBtn(hObject, handles)
    sub = get(hObject, 'UserData');
    x = sub(1); y = sub(2);
    if (isfield(handles, 'gameMap') && min(size(handles.gameMap) >= [x, y]) == 1 && handles.gameMap(x, y) ~= 0)
        pic = handles.gamePic{x, y};
        for i = 1 : size(handles.choseList, 1)
            if (isequal([x, y], handles.choseList(i, :))), pic = pic + 100; break; end
        end
        [r, c, d] = size(pic);
        pos = get(hObject, 'Position');
        row = round(r / pos(4));
        col = round(c / pos(3));
        pic = pic(1 : row : end, 1 : col : end, :);
        set(hObject, 'CData', pic);
        set(hObject, 'visible', 'on');
    else
        set(hObject, 'visible', 'off');
    end
end

function drawAllGameBtn(handles)
    for i = 1 : numel(handles.gameBtn)
        drawGameBtn(handles.gameBtn{i}, handles);
    end
end

function updateGameBtn(hObject, handles)
    for i = 1 : handles.regionM
        for j = 1 : handles.regionN
            if (handles.gameMap(i, j) ~= 0)
                handles.gamePic{i, j} = handles.picsModule{handles.gameMap(i, j)};
            else
                handles.gamePic{i, j} = [];
            end
        end
    end
    guidata(hObject, handles);
end

function startNewGame(hObject, handles)
% 获得用户设置游戏区域大小
    regionM = str2num(get(handles.edit_regionM, 'String'));
    regionN = str2num(get(handles.edit_regionN, 'String'));
    if (isempty(regionM) || isempty(regionN))
        errordlg('区域大小必须为整数!');
        return;
    end
    regionM = fix(regionM); regionN = fix(regionN);
    if (~(regionM >= 1 && regionM <= handles.maxM))
        errordlg(strcat('行数必须介于1和', num2str(handles.maxM), '之间!'));
        return;
    end
    if (~(regionN >= 1 && regionN <= handles.maxN))
        errordlg(strcat('列数必须介于1和', num2str(handles.maxN), '之间!'));
        return;
    end
    if (mod(regionN * regionM, 2) ~= 0)
        errordlg('游戏区域块数必须为偶数！');
        return;
    end
    handles.regionM = regionM;
    handles.regionN = regionN;
% 获得用户设置游戏无法进行时的操作
    if (strcmp('radiobutton_stuck_doNothing', get(get(handles.uipanel_stuck, 'SelectedObject'), 'Tag')))
        handles.stuckOp = 0;
    else
        handles.stuckOp = 1;
    end
% 调用construct初始化游戏区域
    handles.gameMap = construct(handles.regionM, handles.regionN, numel(handles.picsModule));
% 更新游戏区域图片
    updateGameBtn(hObject, handles); handles = guidata(hObject);
% 初始化算法参数
    handles.aiMap = handles.gameMap;
    [m, n] = size(handles.aiMap);
    handles.aiMap = [zeros(m, 1), handles.aiMap, zeros(m, 1)];
    handles.aiMap = [zeros(1, n + 2); handles.aiMap; zeros(1, n + 2)];
    [handles.aiDisMap, handles.aiConnectMap, handles.aiSubList, handles.aiVerIdList, handles.aiHorIdList] = buildMap(handles.aiMap);
    [handles.aiDisMap, handles.aiConnectMap] = floydZeros(handles.aiDisMap, handles.aiConnectMap, handles.aiVerIdList, handles.aiHorIdList, handles.aiMap);
    
    initCandidateList(hObject, handles); handles = guidata(hObject);
    checkCandidateList(hObject, handles); handles = guidata(hObject);
% 绘制游戏区
    drawAllGameBtn(handles);
% 更新用户变量
    guidata(hObject, handles);
end

function btn_game_Callback(hObject, eventdata, handles)
    sub = get(hObject, 'UserData');
    if (size(handles.choseList, 1) == 0)
        handles.choseList = sub;
        drawGameBtn(hObject, handles);
    elseif (isequal(handles.choseList, sub))
        handles.choseList = [];
        drawGameBtn(hObject, handles);
    else
        handles.choseList = [handles.choseList; sub];
        drawGameBtn(hObject, handles);
        x1 = handles.choseList(1, 1); y1 = handles.choseList(1, 2);
        x2 = handles.choseList(2, 1); y2 = handles.choseList(2, 2);
        tmpLinkable = linkable(handles, x1, y1, x2, y2);
        if (detect(handles.gameMap, x1, y1, x2, y2) ~= tmpLinkable)
            errordlg('detect模块有误！');
        end
        if (tmpLinkable)
            route = getRoute(handles, x1, y1, x2, y2);
            flash(handles, route);
            handles.gameMap(x1, y1) = 0;
            handles.gameMap(x2, y2) = 0;
            % 更新算法
            [handles.aiDisMap, handles.aiConnectMap, updList1] = floyd(handles.aiVerIdList(x1 + 1, y1 + 1), handles.aiDisMap, handles.aiConnectMap);
            [handles.aiDisMap, handles.aiConnectMap, updList2] = floyd(handles.aiHorIdList(x1 + 1, y1 + 1), handles.aiDisMap, handles.aiConnectMap);
            [handles.aiDisMap, handles.aiConnectMap, updList3] = floyd(handles.aiVerIdList(x2 + 1, y2 + 1), handles.aiDisMap, handles.aiConnectMap);
            [handles.aiDisMap, handles.aiConnectMap, updList4] = floyd(handles.aiHorIdList(x2 + 1, y2 + 1), handles.aiDisMap, handles.aiConnectMap);
            updList = [updList1; updList2; updList3; updList4];
            deleteCandidateList(hObject, handles, x1, y1);  handles = guidata(hObject);
            deleteCandidateList(hObject, handles, x2, y2);  handles = guidata(hObject);
            addCandidateList(hObject, handles, updList);  handles = guidata(hObject);
            if (any(handles.gameMap(:)))
                checkCandidateList(hObject, handles); handles = guidata(hObject);
            else
                msgbox('棒棒哒~~');
            end
        end
        handles.choseList = [];
        drawGameBtn(handles.gameBtn{x1, y1}, handles);
        drawGameBtn(handles.gameBtn{x2, y2}, handles);
    end
    guidata(hObject, handles); 
end

function flash(handles, route)
    for i = 1 : size(route, 1) - 1
        ui(i) = uicontrol('style', 'text', ...
            'units', 'pixels', ...
            'backgroundcolor', 'black', ...
            'position', getPosition(route(i, :), route(i + 1, :)), ...
            'visible', 'off' ...
        );
    end
    for i = 1 : length(ui)
        set(ui(i), 'visible', 'on');
    end
    pause(0.3);
    for i = 1 : length(ui)
        delete(ui(i));
    end    
    
    %[(j - 1) * 40 + 35, (handles.maxM - i) * 50 + 28, 41, 51]
    function position = getPosition(d1, d2)
        x1 = max(d1(1), d2(1));
        x2 = min(d1(1), d2(1));
        y1 = min(d1(2), d2(2));
        y2 = max(d1(2), d2(2));
        position(1) = y1 * 40 + 15;
        position(2) = (handles.maxM - x1) * 50 + 53;
        position(3) = (y2 - y1) * 40 + 2;
        position(4) = (x1 - x2) * 50 + 2;
    end
end

function edit_regionM_Callback(hObject, eventdata, handles)
% hObject    handle to edit_regionM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_regionM as text
%        str2double(get(hObject,'String')) returns contents of edit_regionM as a double
end


function edit_regionN_Callback(hObject, eventdata, handles)
% hObject    handle to edit_regionN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_regionN as text
%        str2double(get(hObject,'String')) returns contents of edit_regionN as a double
end

% --- Executes on button press in pushbutton_showCandidateList.
function pushbutton_showCandidateList_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_showCandidateList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    msgbox(num2str(handles.aiCandidateList));
end

%% 算法部分

% 初始化邻接矩阵
function [disMap, connectMap, subList, verIdList, horIdList] = buildMap(mtx)
    m = size(mtx, 1);
    n = size(mtx, 2);
    
    len = m * n;
    disMap = repmat(intmax / 3, 2 * len, 2 * len);
    for i = 1 : 2 * len
        disMap(i, i) = 0;
    end
    
    connectMap = zeros(2 * len);
    
    verIdList = 1 : len;
    verIdList = reshape(verIdList, m, n);
    
    horIdList = len + 1 : 2 * len;
    horIdList = reshape(horIdList, m, n);
    
    subList = cell(2 * len, 1);
    
    for i = 1 : m
        for j = 1 : n
            subList(verIdList(i, j)) = {[i, j]};
            subList(horIdList(i, j)) = {[i, j]};
            connect(verIdList(i, j), horIdList(i, j), 1);
            if (i > 1), connect(verIdList(i, j), verIdList(i - 1, j), 0); end
            if (j > 1), connect(horIdList(i, j), horIdList(i, j - 1), 0); end
        end
    end
    
    function connect(a, b, w)
        disMap(a, b) = min(disMap(a, b), w);
        disMap(b, a) = disMap(a, b);
    end
end

% floyd算法
function [disMap, connectMap, updList] = floyd(k, disMap, connectMap)
    disMap2 = repmat(disMap(:, k), 1, size(disMap, 2)) + repmat(disMap(k, :), size(disMap, 1), 1);
    disMap3 = min(disMap, disMap2);
    [I, J] = ind2sub(size(disMap), find(disMap ~= disMap3));
    updList = [I, J];
    updList = unique(sort(updList, 2), 'rows');
    connectMap(disMap ~= disMap3) = k;
    disMap = disMap3;
end

function [disMap, connectMap] = floydZeros(disMap, connectMap, verIdList, horIdList, mtx)
    for x = 1 : size(mtx, 1)
        for y = 1 : size(mtx, 2)
            if (mtx(x, y) == 0)
                [disMap, connectMap, ~] = floyd(verIdList(x, y), disMap, connectMap); 
                [disMap, connectMap, ~] = floyd(horIdList(x, y), disMap, connectMap); 
            end
        end
    end
end

function dis = getDis(handles, x1, y1, x2, y2)
    dis = intmax;
    dis = min(dis, handles.aiDisMap(handles.aiVerIdList(x1, y1), handles.aiVerIdList(x2, y2)));
    dis = min(dis, handles.aiDisMap(handles.aiVerIdList(x1, y1), handles.aiHorIdList(x2, y2)));
    dis = min(dis, handles.aiDisMap(handles.aiHorIdList(x1, y1), handles.aiVerIdList(x2, y2)));
    dis = min(dis, handles.aiDisMap(handles.aiHorIdList(x1, y1), handles.aiHorIdList(x2, y2)));
end

function route = getRoute(handles, x1, y1, x2, y2)
    dis = getDis(handles, x1 + 1, y1 + 1, x2 + 1, y2 + 1);
    id(1, 1) = handles.aiHorIdList(x1 + 1, y1 + 1);  
    id(1, 2) = handles.aiVerIdList(x1 + 1, y1 + 1);
    id(2, 1) = handles.aiHorIdList(x2 + 1, y2 + 1);
    id(2, 2) = handles.aiVerIdList(x2 + 1, y2 + 1);
    if (handles.aiDisMap(id(1, 1), id(2, 1)) == dis)
        id1 = id(1, 1); id2 = id(2, 1);
    elseif (handles.aiDisMap(id(1, 1), id(2, 2)) == dis)
        id1 = id(1, 1); id2 = id(2, 2);
    elseif (handles.aiDisMap(id(1, 2), id(2, 1)) == dis)
        id1 = id(1, 2); id2 = id(2, 1);
    else
        id1 = id(1, 2); id2 = id(2, 2);
    end
    ids = [-1; searchRoute(id1, id2)];
    route = [];
    for i = 2 : length(ids)
        tV = handles.aiSubList{ids(i)};
        route = [route; tV(1) - 1, tV(2) - 1];
    end
    
    function route = searchRoute(id1, id2)
        id3 = handles.aiConnectMap(id1, id2);
        if (id3 == 0)
            route = [id1; id2];
        else
            route = searchRoute(id1, id3);
            route = route(1 : end - 1, :);
            route = [route; searchRoute(id3, id2)];
        end
    end
end

function b = linkable(handles, x1, y1, x2, y2)
    b = inRegion(1, 1, handles.regionM, handles.regionN, x1, y1) && ...
        inRegion(1, 1, handles.regionM, handles.regionN, x2, y2) && ...
        handles.gameMap(x1, y1) ~= 0 && handles.gameMap(x1, y1) == handles.gameMap(x2, y2) && ...
        getDis(handles, x1 + 1, y1 + 1, x2 + 1, y2 + 1) <= 2;
end

function initCandidateList(hObject, handles)
    handles.aiCandidateList = [];
    for i = 1 : numel(handles.gameMap)
        for j = i + 1 : numel(handles.gameMap)
            [x1, y1] = ind2sub(size(handles.gameMap), i);
            [x2, y2] = ind2sub(size(handles.gameMap), j);
            if (linkable(handles, x1, y1, x2, y2))
                handles.aiCandidateList = [handles.aiCandidateList; x1, y1, x2, y2];
            end
        end
    end
    guidata(hObject, handles); 
end

function checkCandidateList(hObject, handles)
    while (size(handles.aiCandidateList, 1) == 0 && handles.stuckOp == 1)
        ids = handles.gameMap ~= 0;
        nums = handles.gameMap(ids);
        nums = nums(randperm(numel(nums)));
        handles.gameMap(ids) = nums;
        initCandidateList(hObject, handles); handles = guidata(hObject);
    end
    updateGameBtn(hObject, handles); handles = guidata(hObject);
    guidata(hObject, handles);
end


function deleteCandidateList(hObject, handles, x, y)
    for i = size(handles.aiCandidateList, 1) : -1 : 1
        if (isequal(handles.aiCandidateList(i, 1 : 2), [x, y]) || isequal(handles.aiCandidateList(i, 3 : 4), [x, y]))
            handles.aiCandidateList(i, :) = [];
        end
    end
    guidata(hObject, handles);
end

function addCandidateList(hObject, handles, updList)
    for i = 1 : size(updList, 1)
        sub1 = handles.aiSubList{updList(i, 1)};
        sub2 = handles.aiSubList{updList(i, 2)};
        x1 = sub1(1) - 1; y1 = sub1(2) - 1;
        x2 = sub2(1) - 1; y2 = sub2(2) - 1;
        if (linkable(handles, x1, y1, x2, y2))
            handles.aiCandidateList = [handles.aiCandidateList; x1, y1, x2, y2];
        end
    end
    guidata(hObject, handles);
end

function b = inRegion(x, y, height, width, dx, dy)
    b = dx >= x && dx <= x + height - 1 && dy >= y && dy <= y + width - 1;
end
