clc;clear;
path = 'C:\Users\cfinsbear\Documents\DDVRPBTW\Solomon-Benchmark\solomon-mat\RC101_025';
load(path);
[LHs, BHs, depot] = seperateCustomer(path, 0.3);
[initial_path] = initial(LHs, BHs, depot, capacity);
n = length(cx);
distmat = zeros(n,n);
for i = 1:n
    for j = i+1:n
        distmat(i,j) = sqrt((cx(i)-cx(j))^2+(cy(i)-cy(j))^2);
        distmat(j,i) = distmat(i,j);
    end
end
dmax = max(max(distmat));
quantitymax = max(quantity);
[final_path, final_cost] = ALNS(initial_path, capacity, dmax, quantitymax)
% drawRoute(initial_path)
for i = 1:length(initial_path)
    route = initial_path(i).route;
%     [mark, timeslot, starttimearray, endtimearray] = timeWindowDetect(route);
%     if mark == 0
%         fprintf('timewindow violation!');
%     end
    fprintf('...route %d ...\n', i);
%     timeslot, starttimearray, endtimearray
    for j = 1:length(route)
        fprintf('-------------node %d, arrival time:%f\n', route(j).index, route(j).arrival_time);
    end
    fprintf('\n')
end










% for i = 1:length(initial_path)
%     fprintf('path %d', i);
%     fprintf('...customer type');
%     temproute = initial_path(i).route;
%     for j = 1:length(temproute)
%         temproute(j).type
%     end
% end