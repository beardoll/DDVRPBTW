function [dynamicnodeset, determinednodeset, codemat] = dynamicGeneration(nodeset, dynamicism, adheadtime)
	% 产生动态到达的顾客集
	% dynamicism: 动态到达的顾客数占总顾客数的比例
	% aheadtime: 动态到达的顾客其必须较start_time提前aheadtime到达
	totalnodenum = length(nodeset);  % 总顾客数
	dynamicnodenum = floor(totalnodenum * dynamicism);
	dynamicnodepos = randi([1 totalnodenum], 1, dynamicnodenum);  % 产生dynamicnodenum个随机位置，选择动态到达的顾客
	dynamicnodeset = nodeset(dynamicnodepos);   % 动态到达的顾客节点?
	determinednodeset = setdiff(nodeset, dynamicnodeset, 'stable');  % 确定到达的顾客节点?
	
	% 对两类顾客进行重新编号，并记录下他们的index的对应关系
	% 其中determined类顾客从1-m进行编号，dynamic类顾客从m+1-n进行编号
	codemat = zeors(1, totalnodenum);  % codemat(i)存放顾客节点的真实id
	for i = 1:length(determinednodeset)
		codemat(i) = determinednodeset(i).index;
		determinednodeset(i).index = i;
	end
	
	for i = 1:length(dynamicnodeset)
		codemat(i+length(determinednodeset)) = dynamicnodeset(i).index;
		dynamicnodeset(i).index = i + length(determinednodeset);
		dynamicnodeset(i).proprosal_time = max(dynamicnodeset(i).start_time - adheadtime, 0);
	end
end