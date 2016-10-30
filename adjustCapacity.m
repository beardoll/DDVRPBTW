function [] = adjustCapacity(routeset, capacity, tradeoff)
    % capacity: 原来为每一辆车分配的固定容量
    % tradeoff: 为初始确定的顾客安排路径时，对每一辆车均空余tradeoff容量以便让服务后面动态到达的顾客
    availablequantityLset = [];
    availablequantityBset = [];
    for i = 1:length(routeset)
        routenode = routeset(i);
        leftcapacity = capacity - max(routenode.quantityL, routenode.quantityB)
end