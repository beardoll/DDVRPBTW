function [dynamicnodeset, determinednodeset, codemat] = dynamicGeneration(LHs, BHs, dynamicism, adheadtime)
	% 产生动态到达的顾客集
	% dynamicism: 动态到达的顾客数占BHs的比例
	% aheadtime: 动态到达的顾客其必须较start_time提前aheadtime到达
	BHnum = length(BHs);  % BHs的数目
	dynamicnodenum = floor(BHnum * dynamicism);
	dynamicnodepos = randperm(BHnum);  % 产生dynamicnodenum个随机位置，选择动态到达的顾客
    dynamicnodepos = dynamicnodepos(1:dynamicnodenum);
	dynamicnodeset = BHs(dynamicnodepos);   % 动态到达的顾客节点?
    determinedpos = setdiff(1:BHnum, dynamicnodepos, 'stable');
	determinednodeset = BHs(determinedpos);  % 确定到达的顾客节点?
	determinednodeset = [LHs, determinednodeset];  % 把LHs加入到确定到达的顾客中
    totalnodenum = length([LHs, BHs]);  % 总顾客数
    
	% 对两类顾客进行重新编号，并记录下他们的index的对应关系
	% 其中determined类顾客从1-m进行编号，dynamic类顾客从m+1-n进行编号
	codemat = zeros(1, totalnodenum);  % codemat(i)存放顾客节点的真实id
	for i = 1:length(determinednodeset)
		codemat(i) = determinednodeset(i).index;
		determinednodeset(i).index = i;
	end
	
	for i = 1:length(dynamicnodeset)
		codemat(i+length(determinednodeset)) = dynamicnodeset(i).index;
		dynamicnodeset(i).index = i + length(determinednodeset);
		dynamicnodeset(i).proposal_time = max(dynamicnodeset(i).start_time - adheadtime, 0);
	end
end