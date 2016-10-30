function [] = dataanalysis()
    % 用来做数据分析
%     load('C:\Users\cfinsbear\Documents\DDVRPBTW\RC102_100.mat');
%     drawRoute(final_path);
%     routecost(initial_path)
%     routecost(final_path)
%     [nodeindex1, nodeindex2] = showNodeindexInRouteSet(final_path)
%     sort(nodeindex2, 'ascend')
%     for i = 1:length(final_path)
%         [mark, timeslot, starttimearray, endtimearray] = timeWindowDetect(final_path(i).route)
%     end
%     load('tempfinalrouteset');
%     [temp1, temp2] = showNodeindexInRouteSet(globalbestrouteset);
%     sort(temp1);
%     sort(temp2);
%     routecost(globalbestrouteset);
%     for i = 1:length(globalbestrouteset)
%         [mark, timeslot, starttimearray, endtimearray] = timeWindowDetect(globalbestrouteset(i).route)
%     end

    load('C:\Users\cfinsbear\Documents\DDVRPBTW\removedrouteset2.mat');
    [nodeindex1, nodeindex2] = showNodeindexInRouteSet(removedrouteset)
    [nodeindex] = showNodeindexInNodeSet(removednodeset)
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

function [nodeindex1, nodeindex2] = showNodeindexInRouteSet(routeset)
    % 将routeset中的节点编号取出来
    % nodeindex1取的是routeset(x).nodeindex
    % nodeindex2取的是routeset(x).route.node.index
    nodeindex1 = [];
    nodeindex2 = [];
    for i = 1:length(routeset)
        nodeindex1 = [nodeindex1, routeset(i).nodeindex];
        for j = 2:length(routeset(i).route) - 1
            nodeindex2 = [nodeindex2, routeset(i).route(j).index];
        end
    end
end

function [nodeindex] = showNodeindexInNodeSet(nodeset)
    nodeindex = [];
    for i = 1:length(nodeset)
        nodeindex = [nodeindex, nodeset(i).index];
    end
end
