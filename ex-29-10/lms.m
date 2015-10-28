function w = lms(class, data)
%%%
% Implements batch perceptron algorithm
%%% 
    % Padding
    data = [data; ones(1, size(data, 2))];
    
    % Normalization
    y = [];
    for i = 1:size(data, 2)
        if class(i) == 1
            y = [y; 1];
        else 
            y = [y; -1];
        end
    end
    
    w = inv(data * data') * data * y;
    
    % Initialization
    xmax = max(data(1, :)) + 1;
    xmin = min(data(1, :)) - 1;
    ymax = max(data(2, :)) + 1;
    ymin = min(data(2, :)) - 1;
    

    
    hold off;
    plot(data(1, class==1), data(2, class==1), 'bx', ...
            data(1, class==2), data(2, class==2), 'ro');
    axis([xmin xmax ymin ymax]);
    hold on;

    line([xmin xmax], [(-(w(1) * xmin + w(3)) ...
             / w(2)) (-(w(1) * xmax + w(3)) / w(2))]);
end
