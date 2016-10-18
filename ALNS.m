% function [final_path, final_cost] = ALNS(initial_path, capacity, dmax, quantitymax)
function [] = ALNS()
    [n, maxd, maxt, maxquantity, capacity, routeset] = ALNStestbench()
    % [result, removednode] = removeNodeInRoute([3,7], routeset)
    % [reducedcost] = computeReducedCost(routeset, [1,4,6,7], n)
    [removedpath, removedrequestnode, removedrequestindex] = shawRemoval(routeset, 4, 5, n, maxd, maxt, maxquantity);
%     [removedpath, removedrequestnode, removedrequestindex] = randomRemoval(routeset, 4, n)
%     [removedpath, removedrequestnode, removedrequestindex] = worstRemoval(routeset, 4, 5, n)
%    [bestinsertcostperroute, bestinsertinfo, secondinsertcostperroute, secondinsertinfo] = computeInsertCostMap(removedrequestnode, removedpath, capacity, 0, 0)
%     mark = ones(1,length(removedrequestnode));
%     [bestinsertcostarr, bestinsertinfoarr, secondinsertcostarr, secondinsertinfoarr] = ...
%         computeInsertCostInARoute(removedrequestnode, removedpath(2).route, removedpath(2).quantityL, removedpath(2).quantityB, capacity, mark, 0, 0)
    [completeroute] = greedyInsert(removedrequestnode, removedpath, capacity, 0, 0)
    fprintf('...');



    % adaptive large neighbor search algorithm
%     removeheuristicnum = 3;  % remove algorithm的数量
%     insertheuristicnum = 2;  % insert algorithm的数量
%     removeprob = 1/removeheuristicnum * (1/removeheuristicnum); % 各个remove algorithm的概率
%     insertprob = 1/insertheuristicnum * (1/insertheuristicnum); % 各个insert algorihtm的概率
%     maxiter = 25000;  % 总的迭代次数
%     segment = 100;  % 每隔一个segment更新removeprob和insertprob
%     curpath = initial_path;
%     curcost = routecost(initial_path);
%     curglobalmincost = curcost; % 当前全局最优解
%     initialroutecode = routecode(initial_path);  % 把初始解编码，用来生成harsh key
%     hashtable = [];
%     hashtable = [hashtable, hash(initialroutecode,'MD2')];
%     noiseprobability = 0.5;  % 在计算插入代价时添加噪声的概率 
%     T = w*curcost / log(2);  % 初始温度
%     r,q,p,dmax,tmax,quantitymax,eta,c;  % 需要定义的参数
%     for iter = 1:maxiter
%         % 产生随机数选取remove算子和insert算子
%         if mod(iter, segment) == 1  % 开始新的segment，应该要将加分相关的变量全部清零
%             if iter ~= 1  % 如果不是刚开始，则应该更新各算子的概率
%                 for i = 1:removeheusticnum
%                     removeprob(i) = removeprob(i) * (1-r) + r * removescore(i)/removeusefrequency(i);
%                 end
%                 for j = 1:insertheuristicnum
%                     insertprob(j) = insertprob(j) * (1-r) + r * insertprob(j)/insertusefrequency(j);
%                 end
%                 removeprob = removeprob / sum(removeprob); % 归一化
%                 insertprob = insertprob / sum(insertprob);
%                 noiseprob = noiseprob * (1-r) + r * noiseaddscore(1) / noiseaddfrequency;
%                 noiseprobnot = (1-noiseprob) * (1-r) + r * noiseaddscore(2) / (segment - noiseaddfrequency);
%                 noiseprobability = noiseprob/(noiseprob + noiseprobnot);
%             end
%             removescore = zeros(1,removeheuristicnum);  % 各个remove算子在当前segment中的评分
%             insertscore = zeros(1,insertheuristicnum);  % 各个insert算子在当前segment中的评分
%             removeusefrequency = zeros(1,removeheuristicnum); % 各个remove算子使用的次数
%             insertusefrequency = zeros(1,insertheuristicnum); % 各个insert算子使用的次数
%             noiseaddfrequency = 0;  % 噪声使用的次数
%             noiseaddscore = zeros(1,2);  % 第1个元素是加噪声的得分，第2个元素是不加噪声的得分 
%         end 
%         removeselect = rand;
%         removeindex = 1;
%         while sum(removeprob(1:removeindex)) < removeselect 
%             removeindex = removeindex + 1;
%         end
%         insertselect = rand;
%         insertindex = 1;
%         while sum(insertprob(1:insertindex)) < insertselect
%             insertindex = insertindex + 1;
%         end
%         removeusefrequency(removeindex) = removeusefrequency(removeindex) + 1;
%         insertusefrequency(insertindex) = insertusefrequency(insertindex) + 1;
%         switch removeindex
%             case 1
%                 tmax = countMaxValue(curpath);
%                 [removedpath, removedrequestnode, removedrequestindex] = shawRemoval(curpath, q, p, n, dmax, tmax, quantitymax)
%             case 2
%                 randomRemoval(curpath, q, n)
%             case 3
%                 [removedpath, removedrequestnode, removedrequestindex] = worstRemoval(curpath, q, p, n)
%         end
%         switch insertindex
%             case 1
%                 if noiseprobability > rand 
%                     noiseadd = 1;
%                     noiseaddfrequency = noiseaddfrequency + 1;
%                 else
%                     noiseadd = 0;
%                 end
%                 [completeroute] = greedyInsert(removedrequestnode, removedpath, capacity, noiseadd, noiseamount)
%             case 2
%                 if noiseprobability > rand 
%                     noiseadd = 1;
%                     noiseaddfrequency = noiseaddfrequency + 1;
%                 else
%                     noiseadd = 0;
%                 end
%                 [completeroute] = regretInsert(removedrequestnode, removedpath, capacity, noiseadd, noiseamount)
%         end
%         newcost = routecost(completeroute);
%         acceptprobability = exp(-(newcost - curcost)/T);
%         accept = 0;
%         if acceptprobability > rand
%             accept = 1;
%         end
%         T = T * c;  % 降温
%         newroutecode = routecode(completeroute);
%         newroutehashkey = hash(newroutecode, 'MD2');
%         % 接下来判断是否需要加分
%         % 加分情况如下：
%         % 1. 当得到一个全局最优解时
%         % 2. 当得到一个尚未被接受过的更好的解
%         % 3. 当得到一个尚未被接受过的解，虽然这个解比当前解差，但是这个解被接受了
%         if newcost < curglobalmincost   
%             removescore(removeindex) = removescore(removeindex) + 1;
%             insertscore(insertindex) = insertscore(insertindex) + 1;
%             curglobalmincost = newcost;
%             if noiseadd == 1
%                 noiseaddscore(1) = noiseaddscore(1) + 1;
%             else
%                 noiseaddscore(2) = noiseaddscore(2) + 1;
%             end
%         else
%             if ismember(newroutehashkey, hashtable) == 0  % 该路径还没有被接受过
%                 if newcost < curcost  % 得到了一个更好的解，加分
%                     removescore(removeindex) = removescore(removeindex) + 1;
%                     insertscore(insertindex) = insertscore(insertindex) + 1;
%                     if noiseadd == 1
%                         noiseaddscore(1) = noiseaddscore(1) + 1;
%                     else
%                         noiseaddscore(2) = noiseaddscore(2) + 1;
%                     end
%                 else
%                     if accept == 1  % 虽然得到了一个不太好的解，但是被接受了，加分
%                         hashtable = [hashtable, newroutehashkey];
%                         removescore(removeindex) = removescore(removeindex) + 1;
%                         insertscore(insertindex) = insertscore(insertindex) + 1;
%                         if noiseadd == 1
%                             noiseaddscore(1) = noiseaddscore(1) + 1;
%                         else
%                             noiseaddscore(2) = noiseaddscore(2) + 1;
%                         end
%                     end
%                 end
%             end
%         end
%         if accept == 1  % 如果被接受了，先判断当前解是否在hashtable中，若无，则添加到hashtable中
%             if ismember(newroutehashkey, hashtable) == 0  % 该路径还没有被接受过
%                 hashtable = [hashtable, newroutehashkey];
%             end
%             curcost = newcost;  % 更新当前的cost
%             curpath = completeroute;  % 更新当前的path
%         end            
%     end
%     final_path = curpath;
%     final_cost = curcost;
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
    psi = 2;
    K = length(solutions); % 车辆数
    % 下面是随机选取路径中的一个节点
    selectedrouteindex = randi([1,K]);  % 随机选取一条路径
    selectedroute = solutions(selectedrouteindex).route; % 随机选中的路径
    selectedroutelen = length(selectedroute) - 2;  % 去头去尾的长度
    selectednodeindex = randi([1,selectedroutelen]);  % 随机选取该路径中的一个节点
    selectednode = selectedroute(selectednodeindex + 1); % 注意第一个节点是仓库
    R = inf(n,n);  % 衡量节点之间的相近程度
    temp = [];
    for i = 1:K  % 先把所有节点的放到一个临时向量temp中
        curroute = solutions(i).route;
        for j = 2 : length(curroute) - 1
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
                                        psi * abs(node1.quantity - node2.quantity)/quantitymax;
            R(node2index, node1index) = R(node1index, node2index);
        end
    end
    D = [selectednode.index];  % D存储的是被移除节点的编号
    nodeindexinroute = setdiff(1:n, selectednode.index);  % 尚在路径中的节点编号
    selectednodenum = selectednode.index;
    while length(D) < q
        % 一直循环执行到D中的request数量为q为止
        [sortR, sortRindex] = sort(R(selectednodenum, nodeindexinroute), 'ascend');  
        % 将相近程度从低到高进行排序
        % 只考虑尚在路径中的节点
        y = rand;
        removenum = ceil(y^p * length(nodeindexinroute));  % 移除的request的数量
        removenodeindex = nodeindexinroute(sortRindex(1:removenum)); % 被移除的路径节点的编号
        nodeindexinroute = setdiff(nodeindexinroute, removenodeindex);
        D = [D, removenodeindex];
        randompos = randi([1 length(nodeindexinroute)]);
        selectednodenum = nodeindexinroute(randompos);  % 再次随机选取一个request
    end
    % 现在对D中的编号进行映射，移除掉各条路径中的D中的元素
    [solutions, DD] = removeNodeInRoute(D, solutions);
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
        randomvalue = randi([1 length(allnodeindex)]);
        curselected = allnodeindex(randomvalue);
        selectednodeindex = [selectednodeindex, curselected];
        allnodeindex = setdiff(allnodeindex, curselected);
    end
    [result, removednode] = removeNodeInRoute(selectednodeindex, solutions);
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
        removenodeindex = sortindex(1:ceil(y^p*length(nodeindexset)));
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
    D = removenodeindex;
    DD = [];
    for i = 1:length(routeset)
        curpath = routeset(i);
        curroute = curpath.route;
        [curremovednodeindex, curremovenodepos] = intersect(curpath.nodeindex, D);  % 找出被移除的节点编号
        for j = 1:length(curremovenodepos)  % 逐个节点进行移除，注意同步更新quantityL和quantityB
            curnode = curroute(curremovenodepos(j)+1);  % 注意第一个节点是depot，nodeindex中只有顾客节点的编号
            DD = [DD, curnode];
            if (curnode.type == 'L')
                curpath.quantityL = curpath.quantityL - curnode.quantity;
            else
                curpath.quantityB = curpath.quantityB - curnode.quantity;
            end
        end
        curpath.nodeindex = setdiff(curpath.nodeindex, curremovednodeindex);  % 更新路径中的node下标
        curroute(curremovenodepos+1) = [];  % 一次性移除掉所有需要移除的节点
        curpath.route = curroute;
        routeset(i) = curpath;
    end
    result = routeset;
    removednode = DD;
end

function [reducedcost] = computeReducedCost(routeset, nodeindexset, n)
    % 计算routeset中所有节点的移除代价（即移除掉它之后带来的路径代价变化量）
    reducedcost = inf(1,n);  % 没有被计算的node的移除代价记为inf
    for i = 1:length(routeset)
        curroute = routeset(i).route;
        computednodeindex = intersect(routeset(i).nodeindex, nodeindexset); % 此路径中需要计算reducedcost的节点下标
        for j = 1:length(computednodeindex)
            nodeindex = computednodeindex(j);
            pos = find(routeset(i).nodeindex == nodeindex);
            predecessor = curroute(pos);
            curnode = curroute(pos+1);
            successor = curroute(pos+2);
            temp = -sqrt((predecessor.cx-curnode.cx)^2 + (predecessor.cy-curnode.cy)^2) -...
                   sqrt((successor.cx-curnode.cx)^2 + (successor.cy-curnode.cy)^2) +...
                   sqrt((predecessor.cx-successor.cx)^2 + (predecessor.cy-successor.cy)^2);
            reducedcost(nodeindex) = temp;
        end
    end
end

%% ------------------------ insertion algorithms ---------------------- %%
%% greedy insert
function [completeroute] = greedyInsert(removednode, removedroute, capacity, noiseadd, noiseamount)
    % 贪婪算法，每次都寻找最好的点插入
    % 把removednode插入到removedroute中
    % 如果没有找到可行插入点，应该再立一条新的路径
    alreadyinsert = [];
    [bestinsertcostperroute, bestinsertinfo, secondinsertcostperroute, secondinsertinfo] = computeInsertCostMap(removednode, removedroute, capacity, noiseadd, noiseamount);
    while length(alreadyinsert) < length(removednode)
        m = length(removednode);
        K = length(removedroute);
        mincost = min(min(bestinsertcostperroute));
        index = find(bestinsertcostperroute == mincost);
        index = index(1);
        col = floor(index/m)+1;  % 最小插入代价所在列（车辆编号）
        row = index - m*(col-1); % 最小插入代价所在行（节点编号，在removednode中的位置）
        if row == 0
            row = m;
            col = col - 1;
        end
        row;
        alreadyinsert = [alreadyinsert, row];
        selectednode = removednode(row); % 此次被选中的节点
        selectednode.carindex = col;   % 所属货车
        bestinsertcostperroute(row,:) = inf;  % 该节点已不在待插入序列中，故将其所有插入代价置为inf
        insertpointindex = bestinsertinfo(row, col) % 最佳插入点
        nodeindexinroute = removedroute(col).nodeindex;  % 要插入的路径中其所拥有的节点编号（全局）
        temp = [];
        temp = [temp, nodeindexinroute(1:insertpointindex-1)];
        temp = [temp, selectednode.index];
        temp = [temp, nodeindexinroute(insertpointindex:end)];
        removedroute(col).nodeindex = temp;
        selectedroute = removedroute(col).route;
        temp = [];
        temp = [temp, selectedroute(1:insertpointindex)];
        temp = [temp, selectednode];
        temp = [temp, selectedroute(insertpointindex+1:end)];
        removedroute(col).route = temp;
        switch selectednode.type
            case 'L'
                removedroute(col).quantityL = removedroute(col).quantityL + selectednode.quantity;
            case 'B'
                removedroute(col).quantityB = removedroute(col).quantityB + selectednode.quantity;
        end
        % 插入了新的节点后，对插入的路径代价进行重新估算
        % 只需要更新路径信息有变化的那一列数据就可以
        mark = ones(1,m);  % 1表示节点还没有插入，0表示节点已经插入
        mark(alreadyinsert) = 0;  % 已经插入过的节点置为0
        [bestinsertcostarr, bestinsertinfoarr, secondinsertcostarr, secondinsertinfoarr] = ...
            computeInsertCostInARoute(removednode, removedroute(col).route, removedroute(col).quantityL, removedroute(col).quantityB, capacity, mark, noiseadd, noiseamount);
        bestinsertcostperroute(:,col) = bestinsertcostarr;
        bestinsertinfo(:,col) = bestinsertinfoarr;
    end
    completeroute = removedroute;  
end

%% regret insert
function [completeroute] = regretInsert(removednode, removedroute, capacity, noiseadd, noiseamount)
    % 每次选择最好的与次好的只差最大者所对应的节点插入到路径中
    % 其思想是：如果我现在不把这个节点插入，将来要付出更大的代价
    alreadyinsert = [];
    m = length(removednode);
    [bestinsertcostperroute, bestinsertinfo, secondinsertcostperroute, secondinsertinfo] = computeInsertCostMap(removednode, removedroute, capacity);
    while length(alreadyinsert) < length(removednode)
        costdiffarr = [];  % 存放每个节点最好和最差插入点之差
        for i = 1:length(removednode)
            tempbest = bestinsertcostperroute;
            if ismember(i,alreadyinsert) == 0  % 已插入不做考虑
                [best1, index1] = min(tempbest(i,:));
                for j = 1:length(index1)
                    col = floor(index1/m)+1;
                    row = index1 - (m-1) * col;
                    if row == 0
                        row = m;
                        col = col - 1;
                    end
                    tempbest(row, col) = inf;
                end
                [best2, index2] = min(tempbest(i,:));
                tempsecond = secondinsertcostperroute;
                [best3, index3] = min(tempsecond(i,:));
                if best2(1) < best3(1)
                    costdiffarr = [costdiffarr, abs(best1(1) - best2(1))];
                else
                    costdiffarr = [costdiffarr, abs(best1(1) - best3(1))];
                end
            else
                costdiffarr = [costdiffarr, -inf];  % 已经插入到路径中的节点，其代价差赋为-∞
            end
        end
        [maxdiff, maxdiffindex] = max(costdiffarr);
        nodeindex = maxdiffindex(1);  % 当前regret cost最大的点的下标（在removednode中位置）
        [mincost, mincostindex] = min(bestinsertcostperroute(nodeindex,:)); 
        mincostindex = mincostindex(1);
        col = floor(mincostindex/m)+1;
        row = mincostindex - (col-1) * m;
        if row == 0
            row = m;
            col = col - 1;
        end
        alreadyinsert = [alreadyinsert, row];
        selectednode = removednode(row); % 此次被选中的节点
        selectednode.carindex = col;   % 所属货车
        bestinsertcostperroute(row,:) = inf;  % 该节点已不在待插入序列中，故将其所有插入代价置为inf
        secondinsertcostperroute(row,:) = inf;
        insertpointindex = bestinsertinfo(row, col); % 最佳插入点
        nodeindexinroute = removedroute(col).nodeindex;
        temp = [];
        temp = [temp, nodeindexinroute(1:insertpointindex)];
        temp = [temp, selectednode.index];
        temp = [temp, nodeindexinroute(insertpointindex+1:end)];
        removedroute(col).nodeindex = temp;
        selectedroute = removedroute(col).route;
        temp = [];
        temp = [temp, selectedroute(1:insertpointindex)];
        temp = [temp, selectednode];
        temp = [temp, selectedroute(insertpointindex+1:end)];
        removedroute(col).route = temp;
        switch selectednode.type
            case 'L'
                removedroute(col).quantityL = removedroute(col).quantityL + selectednode.quantity;
            case 'B'
                removedroute(col).quantityB = removedroute(col).quantityB + selectednode.quantity;
        end
        % 插入了新的节点后，对插入的路径代价进行重新估算
        % 只需要更新路径信息有变化的那一列数据就可以
        mark = ones(1,m);  % 1表示节点还没有插入，0表示节点已经插入
        mark(alreadyinsert) = 0;  % 已经插入过的节点置为0
        [bestinsertcostarr, bestinsertinfoarr, secondinsertcostarr, secondinsertinfoarr] = ...
            computeInsertCostInARoute(removednode, removedroute(col).route, removedroute(col).quantityL, removedroute(col).quantityB, capacity, mark)
        bestinsertcostperroute(:,col) = bestinsertcostarr;
        bestinsertinfo(:,col) = bestinsertinfoarr;
        secondinsertcostperroute(:,col) = secondinsertcostarr;
        secondinsertinfo(:,col) = secondinsertinfoarr;
    end
    completeroute = removedroute;
end

%% 附加函数
function [bestinsertcostperroute, bestinsertinfo, secondinsertcostperroute, secondinsertinfo] = computeInsertCostMap(nodeset, routeset, capacity, noiseadd, noiseamount)
    % 计算nodeset中节点插入到routeset中的最小代价和次小代价
    % bestinsertcostperroute: 各个节点在各条路径中的最小插入代价，secondxxx为次小
    % bestinsertinfo: 各个节点在各条路径的最小插入点信息，secondxxx为次小
    K = length(routeset);  % 车辆数目
    m = length(nodeset);
    bestinsertcostperroute = [];
    bestinsertinfo = [];
    secondinsertcostperroute = [];
    secondinsertinfo = [];
    for i = 1:m
        curnode = nodeset(i);  % 当前需要计算的节点
        for j = 1:K
            curpath = routeset(j);
            curroute = curpath.route;
            mininsertcost = inf;
            mininsert.insertpointindex = -1;
            secondinsertcost = inf;
            secondinsert.insertpointindex = -1;
            for k = 1:length(curroute) - 1
                insertnode = curroute(k);  % 插入点，插入到此点后方
                successor = curroute(k+1);
                switch curnode.type
                    case 'L'
                        if insertnode.type == 'D' || insertnode.type == 'L' % 是可插入点
                            if curpath.quantityL + curnode.quantity < capacity  % 满足容量约束
                                if timeWindowJudge(k, curroute, curnode) == 1   % 满足时间窗约束
                                    temp = sqrt((insertnode.cx-curnode.cx)^2 + (insertnode.cy-curnode.cy)^2) +...
                                           sqrt((successor.cx-curnode.cx)^2 + (successor.cy-curnode.cy)^2) -...
                                           sqrt((insertnode.cx-successor.cx)^2 + (insertnode.cy-successor.cy)^2);
                                    if noiseadd == 1
                                        noise = -noiseamount + 2*noiseamount*rand;
                                        temp = max(temp + noise,0);
                                    end
                                    if temp < mininsertcost
                                        secondinsertcost = mininsertcost;  % 原来“最好的”变成了“次好的”
                                        secondinsert.insertpointindex = mininsert.insertpointindex; 
                                        mininsertcost = temp;           
                                        mininsert.insertpointindex = k;  % 插入点
                                    end
                                end
                            end
                        end
                    case 'B'
                        if insertnode.type == 'L' && successor.type == 'B' || insertnode.type == 'L' && successor.type == 'D' ||insertnode.type == 'B'
                            if curpath.quantityB + curnode.quantity < capacity  % 满足容量约束
                                if timeWindowJudge(k, curroute, curnode) == 1   % 满足时间窗约束
                                    temp = sqrt((insertnode.cx-curnode.cx)^2 + (insertnode.cy-curnode.cy)^2) +...
                                           sqrt((successor.cx-curnode.cx)^2 + (successor.cy-curnode.cy)^2) -...
                                           sqrt((insertnode.cx-successor.cx)^2 + (insertnode.cy-successor.cy)^2);
                                    if noiseadd == 1
                                        noise = -noiseamount + 2*noiseamount*rand;
                                        temp = max(temp + noise,0);
                                    end   
                                    if temp < mininsertcost
                                        secondinsertcost = mininsertcost;  % 原来“最好的”变成了“次好的”
                                        secondinsert.insertpointindex = mininsert.insertpointindex;     
                                        mininsertcost = temp;       
                                        mininsert.insertpointindex = k;  % 插入点
                                    end
                                end
                            end
                        end
                end                
            end
            bestinsertcostperroute(i,j) = mininsertcost;
            bestinsertinfo(i,j) = mininsert.insertpointindex;
            secondinsertcostperroute(i,j) = secondinsertcost;
            secondinsertinfo(i,j) = secondinsert.insertpointindex;
        end
    end
end

function [bestinsertcostarr, bestinsertinfoarr, secondinsertcostarr, secondinsertinfoarr] = computeInsertCostInARoute(nodeset, route, quantityL, quantityB, capacity, mark, noiseadd, noiseamount)
    % 计算nodeset中节点到route中的最小和次小插入代价
    % mark = 0 表示对应的节点已经插入过，否则未插入过
    % quantityL, quantityB: 该路径上的LHs和BHs的货物量
    m = length(nodeset);
    bestinsertcostarr = inf(1,m);
    bestinsertinfoarr = -1 * ones(1,m);
    secondinsertcostarr = inf(1,m);
    secondinsertinfoarr = -1 * ones(1,m);
    curroute = route;
    for i = 1:m
        curnode = nodeset(i);
        mininsertcost = inf;
        mininsert.insertpointindex = -1;
        secondinsertcost = inf;
        secondinsert.insertpointindex = -1;
        if mark(i) == 1  % 只考虑没有插入过的节点
            for j = 1:length(route)-1
                insertnode = route(j);  % 插入在该节点后面
                successor = route(j+1); % 插入点后方
                switch curnode.type
                    case 'L'
                        if insertnode.type == 'D' || successor.type == 'L' % 是可插入点
                            if quantityL + curnode.quantity < capacity  % 满足容量约束
                                if timeWindowJudge(j, route, curnode) == 1   % 满足时间窗约束
                                    temp = sqrt((insertnode.cx-curnode.cx)^2 + (insertnode.cy-curnode.cy)^2) +...
                                           sqrt((successor.cx-curnode.cx)^2 + (successor.cy-curnode.cy)^2) -...
                                           sqrt((insertnode.cx-successor.cx)^2 + (insertnode.cy-successor.cy)^2);
                                    if noiseadd == 1
                                        noise = -noiseamount + 2*noiseamount*rand;
                                        temp = max(temp + noise,0);
                                    end
                                    if temp < mininsertcost
                                        secondinsertcost = mininsertcost;  % 原来“最好的”变成了“次好的”
                                        secondinsert.insertpointindex = mininsert.insertpointindex;  
                                        mininsertcost = temp;          
                                        mininsert.insertpointindex = j;  % 插入点
                                    end
                                end
                            end
                        end
                    case 'B'
                        if insertnode.type == 'L' && successor.type == 'B' || insertnode.type == 'L' && successor.type == 'D' || insertnode.type == 'B'
                            if quantityB + curnode.quantity < capacity  % 满足容量约束
                                if timeWindowJudge(j, curroute, curnode) == 1   % 满足时间窗约束
                                    temp = sqrt((insertnode.cx-curnode.cx)^2 + (insertnode.cy-curnode.cy)^2) +...
                                           sqrt((successor.cx-curnode.cx)^2 + (successor.cy-curnode.cy)^2) -...
                                           sqrt((insertnode.cx-successor.cx)^2 + (insertnode.cy-successor.cy)^2);
                                    if noiseadd == 1
                                        noise = -noiseamount + 2*noiseamount*rand;
                                        temp = max(temp + noise,0);
                                    end   
                                    if temp < mininsertcost
                                        secondinsertcost = mininsertcost;  % 原来“最好的”变成了“次好的”
                                        secondinsert.insertpointindex = mininsert.insertpointindex;  
                                        mininsertcost = temp;          
                                        mininsert.insertpointindex = j;  % 插入点
                                    end
                                end
                            end
                        end
                end
            end
            bestinsertcostarr(i) = mininsertcost;
            bestinsertinfoarr(i) = mininsert.insertpointindex;
            secondinsertcostarr(i) = secondinsertcost;
            secondinsertinfoarr(i) = secondinsert.insertpointindex;
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

%% --------------------- 其余的附加函数 ------------------------- %%
function [code] = routecode(codepath)
    % 将codepath进行编码
    code = ''
    for i = 1:length(codepath)
        nodeindexarr = codepath(i).nodeindex;
        for j = 1:length(nodeindexarr)
            code = strcat(code, num2str(nodeindexarr(j)));
        end
    end
end

function [cost] = routecost(path)
    % 计算path的总路长
    cost = 0;
    for i = 1:length(path)
        curroute = path(i).route;
        for j = 1:length(curroute)-1
            front = curroute(j);
            back = curroute(j+1);
            cost = cost + sqrt((front.cx-back.cx)^2+(front.cy-back.cy)^2);
        end
    end
end

function [tmax] = countMaxValue(path)
    % 计算path中的最晚货车到达时间以及最长距离
    tmax = -inf;
    for i = 1:length(path)
        curroute = path(i).route;
        time = 0;
        for j = 2:length(curroute) - 2
            predecessor = curroute(j-1);
            successor = curroute(j);
            time = time + sqrt((predecessor.cx-successor.cx)^2 + (predecessor.cy-successor.cy)^2);
            if time < sucessor.start_time
                time = sucessor.start_time
            end
            time = time + successor.service_time;
        end
        predecessor = curroute(j);
        successor = curroute(j+1);
        time = time + sqrt((predecessor.cx-successor.cx)^2 + (predecessor.cy-successor.cy)^2);
        if time > tmax
            tmax = time
        end
    end
end
            
