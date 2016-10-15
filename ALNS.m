function [] = ALNS()
    % adaptive large neighbor search algorithm
end

%%%%%%%%%%%%%%%%%%%%%%%%%% removal algorithms %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [removedpath, removedrequestnode, removedrequestindex] = shawRemoval(solutions, q, p, n, dmax, tmax, quantitymax)
    % solutions: 当前的路径
    % q: 要移除的request的数量
    % p: 增加removal的随机性
    % n: 总的节点数目
    % dmax: 顾客节点间的最大距离
    % tmax: 货车的最晚到达顾客点的时间
    % quantitymax: 顾客的最大需求量
    % 每次循环移除的request数量为y^p * |L|，L为移除某些节点后的当前路径
    phi = 9;
    kai = 3;
    phi = 2;
    K = length(solutions); % 车辆数
    % 下面是随机选取路径中的一个节点
    selectedrouteindex = randi([1,K]);  % 随机选取一条路径
    selectedroute = solutions(selectedrouteindex).route; % 随机选中的路径
    selectedroutelen = length(selectedroute) - 2;  % 去头去尾的长度
    selectednodeindex = randi([1 selectedroutelen]);  % 随机选取该路径中的一个节点
    selectednode = selectedroute(selectednodeindex + 1); % 注意第一个节点是仓库
    R = inf(n,n);  % 衡量节点之间的相近程度
    temp = []
    for i = 1:K  % 先把所有节点的放到一个临时向量temp中
        curroute = solutions(i).route;
        for j = 2 : length(curroute - 1)
            temp = [temp, curroute(j)];
        end
    end
    for i = 1:n
        for j = i+1:n
            node1 = temp(i);
            node2 = temp(j);
            node1index = node1.index;
            node2index = node2.index;
            R(node1index, node2index) = phi * sqrt((node1.cx - node2.cx)^2 + (node1.cy - node2.cy)^2)/dmax + ...
                                        kai * abs(node1.arrival_time - node2.arrival_time)/tmax + ...
                                        phi * abs(node1.quantity - node2.quantity);
            R(node2index, node1index) = R(node1index, node2index);
        end
    end
    D = [selectednode.index];  % D存储的是被移除节点的编号
    nodeindexinroute = setdiff(1:n, selectednode.index);  % 尚在路径中的节点编号
    while length(D) < q
        % 一直循环执行到D中的request数量为q为止
        [sortR, sortRindex] = sort(R(selectednodeindex, nodeindexinroute), 'ascend');  
        % 将相近程度从低到高进行排序
        % 只考虑尚在路径中的节点
        y = rand;
        removenum = y^p * length(nodeindexinroute);  % 移除的request的数量
        removenodeindex = nodeindexinroute(sortRindex(1:removenum)); % 被移除的路径节点的编号
        nodeindexinroute = setdiff(nodeindexinroute, removenodeindex);
        D = [D, removenodeindex];
    end
    % 现在对D中的编号进行映射，移除掉各条路径中的D中的元素
    DD = [];  % DD存放的是D中的编号对应的节点
    for i = 1:K
        curpath = solutions(i);
        [curremovednodeindex, curremovenodepos] = intersect(curpath.nodeindex, D);  % 找出被移除的节点编号
        for j = 1:length(curremovenodepos)  % 逐个节点进行移除，注意同步更新quantityL和quantityB
            curnode = curpath(curremovenodepos+1);  % 注意第一个节点是depot，nodeindex中只有顾客节点的编号
            DD = [DD, curnode]
            if (curnode.type == 'L')
                curpath.quantityL = curpath.quantityL - curnode.quantity;
            else
                curpath.quantityB = curpath.quantityB - curnode.quantity;
            end
        end
        curpath.nodeindex = curremovednodeindex;
        solutions(i) = curpath
    end
    removedpath = solutions;
    removedrequestnode = DD;
    removedrequestindex = D; 
end