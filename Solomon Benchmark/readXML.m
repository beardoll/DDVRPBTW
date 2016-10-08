% 读取xml文件

infilename = '';   % 要读取文件名

try
    xDoc = xmlread(infilename);
catch
    error('Failed to read XML file %s', infilename);
end
cx = []; % 存放x坐标
cy = []; % 存放y坐标
start_time = []; % 存放时间窗开始时间
end_time = [];   % 存放时间窗结束时间
quantity = [];   % 存放货物需求量
service_time = [];  % 存放服务时间

allXcoordItems = xDoc.getElementsByTagName('cx');  % x坐标
allYcoordItems = xDoc.getElementsByTagName('cy');  % y坐标
capacity = xDoc.getElementsByTagName('capacity');  % 车容量
max_travel_time = xDoc.getElementsByTagName('max_travel_time');  % 车辆的最长运行时间
allStarttimeItems = xDoc.getElementsByTagName('start');  % 时间窗的起始时间
allEndtimeItems = xDoc.getElementsByTagName('end');  % 时间窗的终止时间
allQuantityItems = xDoc.getElementsByTagName('quantity');  % 货物需求量
allServiceTimeItems = xDoc.getElementsByTagName('service_time');  % 服务时间

% 读取x坐标
for i = 0 : allXcoordItems.getLength - 1
    if i == 0  % 仓库坐标
        depotx = char(allXcoordItems.item(i).getData);
    else
        cx = [cx, char(allXcoordItems.item(i).getData)];
    end
end

% 读取y坐标
for i = 0 : allYcoordItems.getLength - 1
    if i == 0  % 仓库坐标
        depoty = char(allYcoordItems.item(i).getData);
    else
        cy = [cy, char(allYcoordItems.item(i).getData)];
    end
end

% 读取时间窗开始时间
for i = 0 : allStarttimeItems.getLength - 1
    start_time = [start_time, char(allStarttimeItems.item(i).getData)];
end

% 读取时间窗结束时间
for i = 0 : allEndtimeItems.getLength - 1
    end_time = [end_time, char(allEndtimeItems.item(i).getData)];
end

% 读取顾客点货物需求量
for i = 0 : allQuantityItems.getLength - 1
    quantity = [quantity, char(allQuantityItems.item(i).getData)];
end

% 读取顾客点服务时间
for i = 0 : allServiceTimeItems.getLength - 1
    service_time = [service_time, char(allServiceTimeItems.item(i).getData)];
end

% 保存为.mat格式
save(infilename, 'cx', 'cy', 'depotx', 'depoty', 'start_time', 'end_time', 'quantity', 'service_time', 'capacity', 'max_travel_time');



% allCoordinatesItems = xDoc.getElementsByTagName_r('node'); % 把坐标的数据给读取出来
% for i = 0 : allCoordinatesItems.getLength - 1 % 每个node挨个读取
%     thisItem = allCoordinatesItems(i);    % 当前node
%     childNode = thisItem.getFirstChild;   % node的第一个子节点（x坐标）
%     k = 0;  % 0表示x坐标，1表示y坐标
%     while ~empty(childNode)
%         if k == 0
%             cx = [cx childNode.getFirstChild.getData];
%         else
%             cy = [cy childNode.getFirstChild.getData];
%         end
%         k = k + 1;
%         childNode = childNode.getNextSibling;  % node的下一个子节点（y坐标）
%     end    
% end
% allRequestItems = xDoc.getElementsByTagName_r('request');  % 读取时间窗、需求信息


