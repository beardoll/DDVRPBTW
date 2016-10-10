function [] = drawRoute(path)
    % 画出路径
    coloroption = char('r-', 'b-', 'g-', 'm-', 'k-'); % 可选颜色
    for i = 1:length(path)  % 逐条路径画出来
        route = path(i).route;
        selectcolor = mod(i,5);
        if selectcolor == 0
            selectcolor = 1;
        end
        linecolor = coloroption(selectcolor);
        rlen = length(route);
        for nodeindex = 1: rlen - 1
            plot([route(nodeindex).cx route(nodeindex+1).cx], [route(nodeindex).cy route(nodeindex+1).cy], linecolor, 'LineWidth', 2);
            axis([0 100 0 100])
            hold on;
            switch route(nodeindex).type
                case 'D'
                    plot(route(nodeindex).cx, route(nodeindex).cy, 'b*', 'MarkerSize', 8);
                    hold on;
                case 'L'
                    plot(route(nodeindex).cx, route(nodeindex).cy, 'go', 'MarkerSize', 8);
                    hold on;
                case 'B'
                    plot(route(nodeindex).cx, route(nodeindex).cy, 'bd', 'MarkerSize', 8);
                    hold on;
            end
        end 
    end
    hold off;
end