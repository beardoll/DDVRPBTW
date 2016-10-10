function [mark, timeslot, starttimearray, endtimearray] = timeWindowDetect(route)
    % 判断某条路径是否违反时间窗约束
    time = 0;
    mark = 1;
    timeslot = [0];
    starttimearray = [];
    endtimearray = [];
    for i = 1:length(route) - 2
        predecessor = route(i); % 前继节点
        successor = route(i+1); % 后继节点
        time = time + sqrt((predecessor.cx - successor.cx)^2 + (predecessor.cy - successor.cy)^2); % 车辆运行时间
        timeslot = [timeslot, time];
        if time > successor.end_time
            mark = 0;
            break;
        else
            if time < successor.start_time
                time = successor.start_time;
            end
            time = time + successor.service_time;
        end
        starttimearray = [starttimearray, successor.start_time];
        endtimearray = [endtimearray, successor.end_time];
    end            
end