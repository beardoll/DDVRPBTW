function [] = ALNS()
    % adaptive large neighbor search algorithm
end

%% ------------------------ removal algorithms ---------------------- %%
%% shaw removal
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
        selectednodeindex = randi(nodeindexinroute);  % 再次随机选取一个request
    end
    % 现在对D中的编号进行映射，移除掉各条路径中的D中的元素
    [solutions, DD] = removeNodeInRoute(D, solutions)
    removedpath = solutions;
    removedrequestnode = DD;
    removedrequestindex = D; 
end

%% random removal
function [removedpath, removedrequestnode, removedrequestindex] = randomRemoval(solutions, q, n)
    % 随机移除q个节点
    allnodeindex = 1:n;  % 所有节点的编号
    selectednodeindex = [];
    while length(selectednodeindex) < q   % 随机产生q个request的编号
        curselected = randi(allnodeindex);
        selectednodeindex = [selectednodeindex, curselected];
        allnodeindex = setdiff(allnodeindex, curselected);
    end
    [result, removednode] = removeNodeInRoute(selectednodeindex, solutions)
    removedpath = result;
    removedrequestnode = removednode;
    removedrequestindex = selectednodeindex;
end

%% worst removal
function [removedpath, removedrequestnode, removedrequestindex] = worstRemoval(solutions, q, p, n)
    % 移除掉q个“最差”的request
    D = [];  % 要移除的节点
    DD = [];  % 要移除的节点编号
    nodeindexset = 1:n;
    while length(D) < q
        [reducedcost] = computeReducedCost(solutions, nodeindexset, n);
        [sortreducedcost, sortindex] = sort(reducedcost, 'ascend');
        y = rand;
        removenodeindex = sortindex(y^p*length(nodeindexset));
        DD = [DD, removenodeindex];
        [result, removednode] = removeNodeInRoute(removenodeindex, solutions);
        solutions = result;  % 移除节点后更新路径
        nodeindexset = setdiff(nodeindexset, removenodeindex);
        D = [D, removednode];
    end
    removedpath = solutions;
    removedrequestnode = D;
    removedrequestindex = DD;
end

%% 一些附加的函数
function [result, removednode] = removeNodeInRoute(removenodeindex, routeset)
    % removenodeindex: 要移除的节点编号
    % routeset: 所有的路径集合
    DD = [];
    for i = 1:K
        curpath = routeset(i);
        curroute = curpath.route;
        [curremovednodeindex, curremovenodepos] = intersect(curpath.nodeindex, D);  % 找出被移除的节点编号
        for j = 1:length(curremovenodepos)  % 逐个节点进行移除，注意同步更新quantityL和quantityB
            curnode = curroute(curremovenodepos(j)+1);  % 注意第一个节点是depot，nodeindex中只有顾客节点的编号
            DD = [DD, curnode]
            if (curnode.type == 'L')
                curpath.quantityL = curpath.quantityL - curnode.quantity;
            else
                curpath.quantityB = curpath.quantityB - curnode.quantity;
            end
        end
        curpath.nodeindex = curremovednodeindex;
        curroute(curremovenodepos+1) = [];  % 一次性移除掉所有需要移除的节点
        curpath.route = curroute
        routeset(i) = curpath
    end
    result = routeset;
    removednode = DD;
end

function [reducedcost] = computeReducedCost(routeset, nodeindexset, n)
    % 计算routeset中所有节点的移除代价（即移除掉它之后带来的路径代价变化量）
    reducedcost = inf(1,n);
    for i = 1:length(routeset)
        curroute = routeset(i).route;
        for j = 2:length(curroute)-1
            predecessor = curroute(j-1);
            curnode = curroute(j);
            successor = curroute(j+1);
            nodeindex = curroute(j).index;
            temp = -sqrt((predecessor.cx-curnode.cx)^2 + (predecessor.cy-curnode.cy)^2) -...
                   sqrt((successor.cx-curnode.cx)^2 + (successor.cy-curnode.cy)^2) +...
                   sqrt((predecessor.cx-successor.cx)^2 + (predecessor.cy-successor.cy)^2);
            reducedcost(nodeindex) = temp;
        end
    end
end

%% ------------------------ insertion algorithms ---------------------- %%
%% greedy insert
function [] = greedyInsert(removednode, removedroute)
    % 贪婪算法，每次都寻找最好的点插入
    % 把removednode插入到removedroute中
    countInsertCost
end

%% 附加函数
function [] = countInsertCost(nodeset, routeset)
    % 计算nodeset中节点插入到routeset中的最小代价
    for i = 1:length(nodeset)
        curnode = nodeset(i);  % 当前需要计算的节点
        mininsertcost = inf;
        for j = 1:length(routeset)
            curpath = routeset(j);
            curroute = curpath.route;
            for k = 1:length(curroute-1)
                insertnode = curroute(k);  % 插入点，插入到此点后方
                successor = curroute(k+1);
                switch curnode.type
                    case 'L'
                        if curpath.quantityL + curnode.quantity < capacity  % 满足容量约束
                            if timeWindowJudge(k, curroute, curnode) == 1   % 满足时间窗约束
                                temp = sqrt((insertnode.cx-curnode.cx)^2 + (insertnode.cy-curnode.cy)^2) +...
                                       sqrt((successor.cx-curnode.cx)^2 + (successor.cy-curnode.cy)^2) -...
                                       sqrt((insertnode.cx-successor.cx)^2 + (insertnode.cy-successor.cy)^2);
                                if temp < mininsertcost
                                    
                                end
            end
        end
    end
end
        
function [mark] = timeWindowJudge(insertpointindex, path, newcustomer)
    % 判断新插入的客户点是否会使得后续节点的时间窗约束被违反
    time = 0;  % 当前时间为0
    temp = [];
    temp = [temp, path(1:insertpointindex)];
    temp = [temp newcustomer];
    temp = [temp path(insertpointindex + 1:end)];
    path = temp;
    mark = 1;  % 为0表示违反约束
    for i = 1:length(path)-1
        predecessor = path(i); % 前继节点
        successor = path(i+1); % 后继节点
        if (i < insertpointindex) % 在插入点之前的顾客的时间窗都没有受到影响，不需要进行判断
            time = time + sqrt((predecessor.cx - successor.cx)^2 + (predecessor.cy - successor.cy)^2); % 车辆运行时间
            if (time < successor.start_time)  % 车辆在时间窗开始前到达
                time = successor.start_time;
            end
            time = time + successor.service_time;   % 服务时间
        else
            % 插入点之后的顾客的时间窗会受到影响，需要进行判断
            if i ~= length(path) - 1  % 后继节点不是仓库
                time = time + sqrt((predecessor.cx - successor.cx)^2 + (predecessor.cy - successor.cy)^2); % 车辆运行时间
                if time > successor.end_time  % 违反了时间窗约束
                    mark = 0;
                    break;
                else
                    if time < successor.start_time   % 车辆在时间窗开始前到达
                        time = successor.start_time;
                    end
                    time = time + successor.service_time;
                end
            end
        end
    end
end
            
