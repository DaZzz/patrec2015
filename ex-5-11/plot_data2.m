function plot_data2(data, class, testclass)
    xmax = max(data(1, :)) + 1;
    xmin = min(data(1, :)) - 1;
    ymax = max(data(2, :)) + 1;
    ymin = min(data(2, :)) - 1;
    
    hold off;
    plot(data(1, class == 1), data(2, class == 1), 'bx', ...
    data(1, class == 2), data(2, class == 2), 'ro');
    axis([xmin xmax ymin ymax]);
    hold on;
    
    plot(data(1, testclass == 1), data(2, testclass == 1), 'bo', ...
    data(1, testclass == 2), data(2, testclass == 2), 'rx');
    axis([xmin xmax ymin ymax]);
    
end