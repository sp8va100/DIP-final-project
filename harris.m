function [result, corner_r, corner_c] = harris(image, sigma, k)

% halfwid = sigma * 3;
%  
% [xx, yy] =  meshgrid(-halfwid:halfwid, -halfwid:halfwid);
%  
% Gx = xx .*  exp (-(xx .^ 2 + yy .^ 2) / (2 * sigma ^ 2));
% Gy = yy .*  exp (-(xx .^ 2 + yy .^ 2) / (2 * sigma ^ 2));


% sobel in horizontal and vertical direction
fx = [-1 0 1; -1 0 1; -1 0 1];
fy = fx';

Ix = conv2(image, fx, 'same');
Iy = conv2(image, fy, 'same');

Ix2 = Ix .* Ix;
Iy2 = Iy .* Iy;
Ixy = Ix .* Iy;

clear Ix;
clear Iy;

% apply guassian filter
h = fspecial('gaussian', [7, 7], sigma);
Ix2 = conv2(Ix2, h, 'same');
Iy2 = conv2(Iy2, h, 'same');
Ixy = conv2(Ixy, h, 'same');
[height, width] = size(image);

% calculate R
result = zeros(height, width);
R = zeros(height, width);
Rmax = 0;

%M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)]
%R = det(M)-k*(trace(M))^2
% k = 0.04 ~0.06
for i = 1 : height
    for j = 1 : width
        M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];
        R(i, j) = det(M) - k * (trace(M)^ 2);
        if R(i, j) > Rmax
            Rmax = R(i, j);
        end
    end
end
disp(R);
% perform nonmaximal suppression and threshold
num_corner = 0;
threshold = 0.1 * Rmax;
for  i  = 2:height-1
     for  j  = 2:width-1
         if  R(i, j) > threshold && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1) && R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)
             result(i, j) = 1;
             num_corner = num_corner +1;
         end
     end
end

[corner_r, corner_c] = find(result==1);
figure(1);
imshow(image);
hold on;
plot(corner_r, corner_c, 'r.')
end

