function plot_data(data, class, w, w0)
    xmax = max(data(1, :)) + 1;
    xmin = min(data(1, :)) - 1;
    ymax = max(data(2, :)) + 1;
    ymin = min(data(2, :)) - 1;
    hold off;
    plot(data(1, class == 1), data(2, class == 1), 'bx', ...
    data(1, class == 2), data(2, class == 2), 'ro');
    axis([xmin xmax ymin ymax]);
    hold on;
    line([xmin xmax], ....
         [-(w(1) * xmin + w0) / w(2), -(w(1) * xmax + w0) / w(2)]);
end