function result = extract_hist(dataStruct, binsNumber, filter)
%%%
% Parameters:
%   dataStruct - cells with matrices;
%   binsNumber - number of bins (default is 10)
%   filter - 2d smoothing filter applied to histogram (default is identity)
%       example: @(I) imgaussfilt(I)
%%%

% Default params
if nargin < 3
    filter = @(I) I;
end
if (nargin < 2)
    binsNumber = 10;
end

% Init variables
samplesNumber = size(dataStruct, 1);
result = zeros(binsNumber^2, samplesNumber);

% Iterate samples
for i=1:samplesNumber
    sample = dataStruct{i};
    pointsNumber = size(sample,1);
    hst = zeros(binsNumber);
    
    % Iterate points
    for j=1:pointsNumber
        g = sample(j,:);
        [azimuth, elevation, r] = cart2sph(g(1), g(2), g(3));
        azimuth = min(2*pi, max(azimuth + pi, 0.001));
        elevation = min(pi, max(elevation + pi/2, 0.001));
        bi = ceil(azimuth/(2*pi)*binsNumber);
        bj = ceil(elevation/pi*binsNumber);
        hst(bi,bj) = hst(bi, bj) + r;
    end
    
    s = sum(hst(:));
    hst = filter(hst ./ s); % normalize and filter
    
    result(:, i) = hst(:); 
end

end