function w = percep(class, data)
%%%
% Implements batch perceptron algorithm
%%%
    function xs = getMissclassed(data, w)
        xs = [];
        for x = data
            wTx = w' * x;

            if (wTx < 0)
                xs = [xs, x];
            end
        end
    end
    
    % Padding
    data = [data; ones(1, size(data, 2))];
    w = rand(size(data, 1), 1); 
    
    % Normalization
    for i = 1:size(data, 2)
        if class(i) == 2
            data(:,i) = -data(:,i);
        end
    end
    
    % Initialization
    xmax = max(data(1, :)) + 1;
    xmin = min(data(1, :)) - 1;
    ymax = max(data(2, :)) + 1;
    ymin = min(data(2, :)) - 1;
    
    % Algorithm
    for t = 1:10000
       pt = 0.1/t;
       xs = getMissclassed(data, w);
       
       if (isempty(xs)) 
            break;
       end
       
       w = w - pt * sum(-1*xs,2);
       
       % Plot data and discriminant
       if (mod(t, 50) == 0)
         hold off;
         plot(data(1, class==1), data(2, class==1), 'bx', ...
            -data(1, class==2), -data(2, class==2), 'ro');
         axis([xmin xmax ymin ymax]);
         hold on;

         line([xmin xmax], [(-(w(1) * xmin + w(3)) ...
             / w(2)) (-(w(1) * xmax + w(3)) / w(2))]);

         pause(0.1);
       end

    end
    
    hold off;
    plot(data(1, class==1), data(2, class==1), 'bx', ...
            -data(1, class==2), -data(2, class==2), 'ro');
    axis([xmin xmax ymin ymax]);
    hold on;

    line([xmin xmax], [(-(w(1) * xmin + w(3)) ...
             / w(2)) (-(w(1) * xmax + w(3)) / w(2))]);
end
