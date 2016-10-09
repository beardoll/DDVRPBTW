function [LHIndex, BHIndex] = seperateCustomer(start_time, cx, percentage)
    % 以percentage为比例分割原基准测试集
    % benchmarkmat: 基准测试集mat
    % percentage: backhaulcustomer的比例
    % LHIndex, BHIndex为linehaul和backhaul节点在原基准集中的下标
    [sort_starttime, starttimeindex] = sort(start_time);
    totalcustomernum = length(cx);  % 总的顾客数量
    backhaulnum = floor(totalcustomernum * percentage); % backhaul的数量
    LHIndex = starttimeindex(1:totalcustomernum - backhaulnum);
    BHIndex = starttimeindex(totalcustomernum - backhaulnum + 1: end);
end