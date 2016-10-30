function [finalrouteset, finalcost] = simulateDynamicCondition1(initialrouteset, newcustomerset)
    % newcustomerset: eachnode: index, proposal_time, cx, cy, quantity, type
    %                   itself: indexset -- 便于索引某个index对应的customer在哪里                   
    
    eventlist = [];  % 时间表，用以触发状态机
    
    % 首先把初始路径的第一个顾客节点接受服务的事件录入到eventlist中
    for i = 1:length(initialrouteset)
       curroute = initialrouteset(i).route;
       initialrouteset(i).finishedmark = zeros(1,length(curroute)-2); 
       depot = curroute(1);      % 仓库节点
       firstnode = curroute(2);  % 第一个服务的节点
       servicestarttime = sqrt((depot.cx - firstnode.cx)^2 + (depot.cy - firstnode.cy)^2);
       if servicestarttime < firstnode.start_time
           servicestarttime = firstnode.start_time;
       end
       listelement = [servicestarttime, 'service', firstnode.index, firstnode.carindex];    % 服务顾客
       eventlist(length(eventlist)+1,:) = listelement;
    end
    
    % 换个名字
    routeinfolist = initialrouteset;
    
    % 然后把新到达的顾客需求的时间置入eventlist中
    for i = 1:length(newcustomerset)
        curcustomer = newcustomerset(i);
        listelement = [curcustomer.proposal_time, 'newdemandarrive', curcustomer.index, -1];  % 新到达的顾客还没有分配路径
        eventlist(length(eventlist)+1,:) = listelement;
    end
    
    % 按时间对eventlist进行排序
    eventlist = sortEventlist(eventlist);
    
    % 执行状态机
	backtimetable = [];  % 各车辆返回仓库的时间表
    while isempty(eventlist) == 0  
        curevent = eventlist(1,:);
		curtime = curevent(1);
        eventlist(1,:) = [];  % 删除掉该事件
        switch curevent(2)
            case 'service'   % 在此处定义服务完成时间
                routeindex = curevent(4);
                finishedmark = routeinfolist(routeindex).finishedmark;
                curfinishedpos = find(finishedmark == 0);  % 当前服务的节点在nodeindex中的位置
                curfinishedpos = curfinishedpos(1);
				onservicenode = routeinfolist(routeindex).route(curfinishedpos+1);  % 当前接受服务的节点
                finishedmark(curfinishedpos) = 1;  % 标记该位置的节点已走过
				departuretime = curtime + onservicenode.service_time;
				listelement = [departuretime, 'departure', onservicenode.index, onservicenode.carindex];    % 车辆出发
				eventlist(length(eventlist)+1,:) = listelement;
				eventlist = sortEventlist(eventlist);
                routeinfolist(routeindex).finishedmark = finishedmark;
            case 'newdemandarrive'
                index = curevent(3);
                customerpos = find(index == newcustomerset.indexset);
                customernode = newcustomerset(customerpos);
                [bestrouteindex, bestinsertpos, newrouteinfolist] = searchBestInsertPos(customernode, routeinfolist);
				if bestrouteindex == -1   % 如果没有可行路径，需要手动添加服务开始事件，因为这是新路径的第一个节点
					newroutenode = newrouteinfolist(end);   % 新增加的路径
					startnode = newroutenode.route(1);
					nextnode = newroutenode.route(2);
					servicestarttime = curtime + sqrt((startnode.cx - nextnode.cx)^2+(startnode.cy - nextnode.cy)^2);
					if servicestarttime < nextnode.start_time
						servicestarttime = nextnode.start_time;
						listelement = [servicestarttime, 'service', nextnode.index, nextnode.carindex];    % 服务顾客
						eventlist(length(eventlist)+1,:) = listelement;
						eventlist = sortEventlist(eventlist);
					end
				end	
                routeinfolist = newrouteinfolist;
            case 'departure'  % 这时候要确定该货车的下一个出发点
                routeindex = curevent(4);
                curroutenode = routeinfolist(routeindex);
                nextnodepos = find(curroutenode.finishedmark == 0);
				if isempty(nextnodepos) == 1  % 如果此路径的所有节点已经走完，则应该回到仓库
					depot = curroutenode.route(end);
					lastnode = curroutenode.route(end-1);
					backtime = curtime + sqrt((lastnode.cx - depot.cx)^2 + (lastnode.cy - depot.cy)^2);
					listelement = [backtime, 'back', lastnode.index, lastnode.carindex];    % 车辆返回仓库
					eventlist(length(eventlist)+1,:) = listelement;
					eventlist = sortEventlist(eventlist);
				else
					nextnodepos = nextnodepos(1);
					curnode = curroutenode.route(nextnodepos);      % 当前节点
					nextnode = curroutenode.route(nextnodepos+1);   % 下一个节点
					servicestarttime = curtime + sqrt((curnode.cx - nextnode.cx)^2 + (curnode.cy - nextnode.cy)^2);
					if servicestarttime < nextnode.start_time
						servicestarttime = nextnode.start_time;
					end
					listelement = [servicestarttime, 'service', nextnode.index, nextnode.carindex];    % 车辆返回仓库
					eventlist(length(eventlist)+1,:) = listelement;
					eventlist = sortEventlist(eventlist);
				end
			case 'back'
				backtimetable(length(backtimetable)+1,:) = [curevent(1), curevent(4)];
        end
    end  
	finalrouteset = routeinfolist;
	finalcost = routecost(finalrouteset)
end

function [neweventlist] = sortEventlist(initialeventlist)
    timetable = initialeventlist(:,1);  % 取出时间表的事件
    [sortresult, sortindex] = sort(timetable, 'ascend');
    neweventlist = initialeventlist(sortindex,:);
end

function [bestrouteindex, bestinsertpos, newrouteinfolist] = searchBestInsertPos(customernode, routeinfolist)
    % 为customernode寻找最佳插入位置和相应的路径
    bestcost = inf;
    bestrouteindex = -1;
    bestinsertpos = -1;
    for i = 1:length(routeinfolist)
        curroutenode = routeinfolist(i);
        accessinsertpos = find(curroutenode.finishedmark == 0); % 可行插入点，相对于route
        if isempty(accessinsertpos) == 1 % 没有可行插入点（车辆要驶回仓库） 
            continue
        else
            accessinsertpos = accessinsertpos(1);  % 转化为在route中的索引
        end
        for j = accessinsertpos : length(curroutenode.route)-1
            predecessor = curroutenode.route(j);   % 插入点
            successor = curroutenode.route(j+1);   % 后继节点
            switch customernode.type
                case 'L'
                    if predecessor.type == 'D' || predecessor.type == 'L' % 是可插入点
                        if curroutenode.quantityL + customernode.quantity < capacity  % 满足容量约束
                            if timeWindowJudge(j, curroutenode.route, newcustomer) == 1  % 满足时间窗约束
                                temp = sqrt((predecessor.cx - customernode.cx)^2 + (predecessor.cy - customernode.cy)^2);
                                if temp < bestcost
                                    bestcost = temp;
                                    bestrouteindex = i;
                                    bestinsertpos = j;
                                end
                            end
                        end
                    end
                case 'B'
                    if predecessor.type == 'L' && successor.type == 'B' || predecessor.type == 'L' && successor.type == 'D' || predecessor.type == 'B'
                        if curroutenode.quantityB + customernode.quantity < capacity  % 满足容量约束
                            if timeWindowJudge(j, curroutenode.route, newcustomer) == 1  % 满足时间窗约束
                                temp = sqrt((predecessor.cx - customernode.cx)^2 + (predecessor.cy - customernode.cy)^2);
                                if temp < bestcost
                                    bestcost = temp;
                                    bestrouteindex = i;
                                    bestinsertpos = j;
                                end
                            end
                        end
                    end
            end
        end
    end
    customernode = rmfield(customernode, 'proposal_time');  % 删除掉请求到达的事件这一属性
    if bestrouteindex == -1  % 没有可行插入点
        newrouteindex = length(routeinfolist) + 1;
        newroutenode.index = newrouteindex;
        depot = routeinfolist(1).route(1);
        depot.carindex = newrouteindex;
        customernode.carindex = newrouteindex;
        newroutenode.route = [depot, customernode, depot];
        switch customernode.type
            case 'L'
                newroutenode.quantityL = customernode.quantity;
                newroutenode.quantityB = 0;
            case 'B'
                newroutenode.quantityB = customernode.quantity;
                newroutenode.quantityL = 0;
        end
        newroutenode.finishedmark = [];
        routeinfolist = [routeinfolist, newroutenode];
    else
        selectedroutenode = routeinfolist(bestrouteindex);  % customernode插入到该节点中
        % 更新nodeindex, finishedmark等信息
        temp = [];
        temp = [temp, selectedroutenode.nodeindex(1:bestinsertpos-1)];
        temp = [temp, customernode.index];
        temp = [temp, selectedroutenode.nodeindex(bestinsertpos:end)];
        routeinfolist(bestrouteindex).nodeindex = temp;
        temp = [];
        temp = [temp, selectedroutenode.route(1:bestinsertpos)];
        customernode.carindex = bestrouteindex;
        temp = [temp, customernode];
        temp = [temp, selectedroutenode.route(bestinsertpos+1:end)];
        selectedroutenode.finishedmark = [selectedroutenode.finishedmark, 0];
        switch customernode.type
            case 'L'
                selectedroutenode.quantityL = selectedroutenode.quantityL + customernode.quantity;
            case 'B'
                selectedroutenode.quantityB = selectedroutenode.quantityB + customernode.quantity;
        end
        routeinfolist(bestrouteindex) = selectedroutenode;
    end
    newrouteinfolist = routeinfolist;
end

function [mark] = timeWindowJudge(insertpointpos, route, newcustomer)
    % 判断新插入的客户点是否会使得后续节点的时间窗约束被违反
    time = 0;  % 当前时间为0
    temp = [];
    temp = [temp, route(1:insertpointpos)];
    temp = [temp newcustomer];
    temp = [temp route(insertpointpos + 1:end)];
    route = temp;
    mark = 1;  % 为0表示违反约束
    for i = 1:length(route)-2
        predecessor = route(i); % 前继节点
        successor = route(i+1); % 后继节点
        if (i < insertpointpos) % 在插入点之前的顾客的时间窗都没有受到影响，不需要进行判断
            time = time + sqrt((predecessor.cx - successor.cx)^2 + (predecessor.cy - successor.cy)^2); % 车辆运行时间
            if (time < successor.start_time)  % 车辆在时间窗开始前到达
                time = successor.start_time;
            end
            time = time + successor.service_time;   % 服务时间
        else
            % 插入点之后的顾客的时间窗会受到影响，需要进行判断
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

function [cost] = routecost(routeset)
    % 计算path的总路长
    cost = 0;
    for i = 1:length(routeset)
        curroute = routeset(i).route;
        for j = 1:length(curroute)-1
            front = curroute(j);
            back = curroute(j+1);
            cost = cost + sqrt((front.cx-back.cx)^2+(front.cy-back.cy)^2);
        end
    end
end