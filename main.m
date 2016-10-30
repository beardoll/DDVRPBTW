clc;clear;
path = 'C:\Users\cfinsbear\Documents\DDVRPBTW\Solomon-Benchmark\solomon-mat\RC102_100';
load(path);
[LHs, BHs, depot] = seperateCustomer(path, 0);

[dynamicnodeset, determinednodeset, codemat] = dynamicGeneration([LHs, BHs], 0.2, depot, 40);
n = length(determinednodeset);
distmat = zeros(n,n);
minquantity = inf;
maxquantity = -inf;
for i = 1:n
	if determinednodeset(i).quantity < minquantity
		minquantity = determinednodeset(i).quantity;
	end
	if determinednodeset(i).quantity > maxquantity
		maxquantity = determinednodeset(i).quantity;
	end
    for j = i+1:n
		onenode = determinednodeset(i)
		anothernode = determinednodeset(j);
        distmat(i,j) = sqrt((onenode.cx-anothernode.cx)^2+(onenode.cy-anothernode.cy)^2);
        distmat(j,i) = distmat(i,j);
    end
end
dmax = max(max(distmat));
quantitydiffmax = maxquantity - minquantity;
[final_path, final_cost] = ALNS(determinednodeset, depot, capacity, dmax, quantitydiffmax, n)
[finalrouteset, finalcost] = simulateDynamicCondition1(final_path, dynamicnodeset)
save('C:\Users\cfinsbear\Documents\DDVRPBTW\DRC102_100.mat', 'finalrouteset', 'finalcost');


% [initial_path] = initial(LHs, BHs, depot, capacity);
% n = length(cx);
% distmat = zeros(n,n);
% for i = 1:n
%     for j = i+1:n
%         distmat(i,j) = sqrt((cx(i)-cx(j))^2+(cy(i)-cy(j))^2);
%         distmat(j,i) = distmat(i,j);
%     end
% end
% dmax = max(max(distmat));
% quantitymax = max(quantity) - min(quantity);
% [final_path, final_cost] = ALNS([LHs, BHs], depot, capacity, dmax, quantitymax, n)
% save('C:\Users\cfinsbear\Documents\DDVRPBTW\RC102_100.mat', 'final_path', 'final_cost', 'initial_path');


% ALNS(initial_path, capacity, dmax, quantitymax, n)
% drawRoute(initial_path)
% for i = 1:length(initial_path)
%     route = initial_path(i).route;
% %     [mark, timeslot, starttimearray, endtimearray] = timeWindowDetect(route);
% %     if mark == 0
% %         fprintf('timewindow violation!');
% %     end
%     fprintf('...route %d ...\n', i);
% %     timeslot, starttimearray, endtimearray
%     for j = 1:length(route)
%         fprintf('-------------node %d, arrival time:%f\n', route(j).index, route(j).arrival_time);
%     end
%     fprintf('\n')
% end










% for i = 1:length(initial_path)
%     fprintf('path %d', i);
%     fprintf('...customer type');
%     temproute = initial_path(i).route;
%     for j = 1:length(temproute)
%         temproute(j).type
%     end
% end