function [R, corner_r, corner_c] = harris(image, sigma, thresh, sizeofmask, k)

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

% R = det(M)-k*(trace(M))^2
R = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;

% perform nonmaximal suppression and threshold
mx = ordfilt2(R,sizeofmask^2,ones(sizeofmask)); % Grey-scale dilate.
R = (R==mx)&(R>thresh);       % Find maxima.

[corner_r, corner_c] = find(R);
figure, imagesc(image), axis image, colormap(gray), hold on
plot(corner_c,corner_r,'ys'), title('corners detected');
end

