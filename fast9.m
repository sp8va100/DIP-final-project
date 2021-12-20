function [x, y] = fast9(image)
%FAST9 Summary of this function goes here
% Corner detection using FAST-9, threshold sets to 50 
threshold = 50;
img = image;
[row, col, dim] = size(image);
if dim == 3
    img = rgb2gray(img);
end
img = double(img);

% 16 points relative position
reference_points = [-3,0;-3,1;-2,2;-1,3;0,3;1,3;2,2;3,1;3,0;3,-1;2,-2;1,-3;0,-3;-1,-3;-2,-2;-3,-1]+[4,4];

s = zeros(row, col);

for x = 4 : row - 3
    for y = 4 : col - 3
        % checking I1, I5, I9, I13
        % at least three pts' intensity difference larger then threshold
        % else dont count
        candidate = img(x, y);
        diff(1) = abs(img(x - 3, y) - candidate) < threshold;
        diff(2) = abs(img(x + 3, y) - candidate) < threshold;
        diff(3) = abs(img(x, y + 3) - candidate) < threshold;
        diff(4) = abs(img(x, y - 3) - candidate) < threshold;
        if sum(diff) < 3
            tmp = img(x - 3 : x + 3, y - 3 : y + 3);
            intensity = [];
            % 16 points' intensity in circle
            for i = 1 : 16
                intensity = [intensity, tmp(reference_points(i, 1), reference_points(i, 2))];
            end
            diff16 = intensity - candidate;
            val = diff16 > threshold;
            if conti9(val) == 1
                s(x, y) = sum(val .* diff16);
            else
                val = -diff16 > threshold;
                if conti9(val) == 1
                    s(x, y) = -sum(val .* diff16);
                end
            end
        end
    end
end

% non Maximal Suppression in 5x5 mask
[x, y] = find(s ~= 0);
for i = 1 : length(x)
    tmp = s(x(i) - 2 : x(i) + 2, y(i) - 2 : y(i) + 2);
    if s(x(i), y(i)) ~= 0
        if length(find(tmp)) ~= 1
            mask = zeros(5, 5);
            [max_x, max_y] = find(tmp == max(tmp(:)));
            mask(max_x(1), max_y(1)) = 1;
            s(x(i) - 2 : x(i) + 2, y(i) - 2 : y(i) + 2) = mask .* tmp;
        end
    end
end

[y, x] = find(s ~= 0);

figure; imshow(image); hold on;

for i = 1 : length(x)
    plot(x(i), y(i), 'g+'); hold on;
end
hold off;

end


