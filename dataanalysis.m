function [] = dataanalysis()
    % 用来做数据分析
    load('C:\Users\beardollPC\Documents\DDVRPBTW\RC101_050.mat');
    drawRoute(final_path);
    routecost(initial_path)
    routecost(final_path)
% [mark, timeslot, starttimearray, endtimearray] = timeWindowDetect(final_path(4).route)
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