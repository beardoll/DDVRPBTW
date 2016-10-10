clc;clear;
path = 'C:\Users\cfinsbear\Documents\DDVRPBTW\Solomon-Benchmark\solomon-mat\RC101_025';
load(path);
[LHs, BHs, depot] = seperateCustomer(path, 0.3);
[initial_path] = initial(LHs, BHs, depot, capacity);
% drawRoute(initial_path)
for i = 1:length(initial_path)
    route = initial_path(i).route;
    [mark, timeslot, starttimearray, endtimearray] = timeWindowDetect(route);
    if mark == 0
        fprintf('timewindow violation!');
    end
    fprintf('...route %d ...\n', i);
    timeslot, starttimearray, endtimearray
end










% for i = 1:length(initial_path)
%     fprintf('path %d', i);
%     fprintf('...customer type');
%     temproute = initial_path(i).route;
%     for j = 1:length(temproute)
%         temproute(j).type
%     end
% end