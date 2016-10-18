function [n, maxd, maxt, maxquantity, capacity, routeset] = ALNStestbench()
    % set testbench to detect the ALNS algorithm
    n = 10;
    maxd = 8;
    maxt = 10;
    maxquantity = 3;
    capacity = 8;
    
    depot.cx = 0;
    depot.cy = 0;
    depot.start_time = 0;
    depot.end_time = 0;
    depot.service_time = 0;
    depot.quantity = 0;
    depot.type = 'D';
    depot.index = 0;
    depot.arrival_time = 0;
    cx = [1, 3, 5, 7, 8, 1.5, 3, 4.5, 6, 8];
    cy = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    quantity = [1 2 1 3 1 2 3 2 1 1];
    start_time = [1 2 4 6 6 1 2 3 3 5 6];
    end_time = [2 5 6 9 10 2 4 6 7 10];
    service_time = [0 0 0 0 0 0 0 0 0 0];
    arrival_time = [1 3 5 7 8 1.5 3 4.5 6 8]
    nodearr = [];
    BHmark = [4 5 10];  % 标记哪些编号下的节点是BHs
    for i = 1:10
        if ismember(i, BHmark) == 1
            node.type = 'B';
        else
            node.type = 'L';
        end
        node.index = i;
        node.start_time = start_time(i);
        node.end_time = end_time(i);
        node.cx = cx(i);
        node.cy = cy(i);
        node.service_time = service_time(i);
        node.quantity = quantity(i);
        node.arrival_time = arrival_time(i);
        nodearr = [nodearr, node];
    end
    routenodeindexarr = [];
    node = [];
    node.nodeindex = [1 2 3 4 5]; % 第一条路径所包含的节点
    routenodeindexarr = [routenodeindexarr, node];
    node.nodeindex = [6 7 8 9 10]; % 第二条路径所包含的节点
    routenodeindexarr = [routenodeindexarr, node];
    routeset = [];
    for i = 1:length(routenodeindexarr)
        depot.carindex = i;
        nodeindexinroute = routenodeindexarr(i).nodeindex;
        nodeinroute = [];
        qL = 0;
        qB = 0;
        for j = 1:length(nodeindexinroute)
            curnode = nodearr(nodeindexinroute(j));
            curnode.carindex = i;
            if curnode.type == 'L'
                qL = qL + curnode.quantity;
            else
                qB = qB + curnode.quantity;
            end
            nodeinroute = [nodeinroute, curnode];
        end
        routenode.route = [depot, nodeinroute, depot];
        BHindex = intersect(nodeindexinroute, BHmark);
        LHindex = setdiff(nodeindexinroute, BHindex);
        routenode.quantityL = qL;
        routenode.quantityB = qB;
        routenode.index = i;
        routenode.nodeindex = nodeindexinroute;
        routeset = [routeset, routenode];
    end
end