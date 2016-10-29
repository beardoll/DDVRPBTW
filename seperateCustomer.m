function [LHs, BHs, depot] = seperateCustomer(path, percentage)
    % 以percentage为比例分割原基准测试集
    % path: 基准测试集mat的路径
    % percentage: backhaulcustomer的比例
    % LHs, BHs为linehaul和backhaul节点，包含各种信息如货物需求量，位置等信息
    load(path);
    [sort_starttime, starttimeindex] = sort(start_time, 'ascend'); % 服务起始时间升序排列
    totalcustomernum = length(cx);  % 总的顾客数量
    backhaulnum = floor(totalcustomernum * percentage); % backhaul的数量
    LHIndex = starttimeindex(1:totalcustomernum - backhaulnum);  % LHs在原顾客集中的定位
    BHIndex = starttimeindex(totalcustomernum - backhaulnum + 1: end);  % BHs在原顾客集中的定位
    depot.cx = depotx;
    depot.cy = depoty;
    depot.start_time = 0;
    depot.end_time = 0;
    depot.service_time = 0;
    depot.index = 0;
    depot.quantity = inf;
    depot.type = 'D';
    LHs = [];
    for i = 1:length(LHIndex)
        node.index = LHIndex(i);   % 节点在原顾客集中的定位
        node.start_time = start_time(node.index);
        node.end_time = end_time(node.index);
        node.service_time = service_time(node.index);
        node.cx = cx(node.index);
        node.cy = cy(node.index);
        node.quantity = quantity(node.index);
        node.carindex = 1;
        node.type = 'L';
        LHs = [LHs, node];
    end
    BHs = [];
    for i = 1:length(BHIndex)
        node.index = BHIndex(i);   % 节点在原顾客集中的定位
        node.start_time = start_time(node.index);
        node.end_time = end_time(node.index);
        node.service_time = service_time(node.index);
        node.cx = cx(node.index);
        node.cy = cy(node.index);
        node.quantity = quantity(node.index);
        node.carindex = 1;
        node.type = 'B';
        BHs = [BHs, node];
    end
end