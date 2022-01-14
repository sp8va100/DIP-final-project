clear all;
close all;
% ./images/img/IMG_8078.jpg
% ./images/img/IMG_8076.jpg
%/middle/IMG_8029.jpg
%/right/IMG_8045.jpg
img_middle = imread('./images/middle/IMG_8029.jpg');
img_right = imread('./images/right/IMG_8045.jpg');

gd_middle = im2double(rgb2gray(img_middle));
gd_right = im2double(rgb2gray(img_right));

% % fast 9
% [yf_mid, xf_mid] = fast9(img_middle);
% [yf_right, xf_right] = fast9(img_right);
disp('Harris......');
% harris corner detection
k = 0.04;
sizeofmask = 5;
threshold = 0.05;
harris_sigma = 2;
harris_radius = 2;
[~, y_middle, x_middle] = harris(gd_middle, harris_sigma, threshold, sizeofmask, k);
[~, y_right, x_right] = harris(gd_right, harris_sigma, threshold, sizeofmask, k);
% [~,y_middle,x_middle] = harris2(gd_middle,harris_sigma,threshold,harris_radius,0);
%[~,y_right,x_right] = harris2(gd_right,harris_sigma,threshold,harris_radius,0);


disp('SIFT....');
% sift
sift_radius = 5;
discriptor_middle = find_sift(gd_middle, [x_middle, y_middle, sift_radius*ones(length(x_middle),1)], 1.5);
discriptor_right = find_sift(gd_right, [x_right, y_right, sift_radius*ones(length(x_right),1)], 1.5);

disp('matching...')
% matching
num_matching = 100;
[match_in_middle, match_in_right] = matching(discriptor_middle, discriptor_right, num_matching);
cordinate_middle = [x_middle(match_in_middle), y_middle(match_in_middle)];
cordinate_right = [x_right(match_in_right), y_right(match_in_right)];

disp('RANSAC...');
% RANSAC
iter = 5000;
[H, max_num_inliers,residual] = ransac(cordinate_middle, cordinate_right, iter);

disp('Stitch...');
% stitch
img_res = stitchH(img_middle, H, img_right);

figure;
imshow(img_res);

    figure, imagesc(gd_middle), axis image, colormap(gray), hold on
    plot(x_middle,y_middle,'ys'),
    plot(x_middle(match_in_middle),y_middle(match_in_middle),'bs'),
    predict = homography_tf(cordinate_middle,H);
    dists = sum((cordinate_right - predict).^2,2);
    inlier_idx = find(dists < 0.3);
    plot(cordinate_middle(inlier_idx,1),cordinate_middle(inlier_idx,2),'gs'),
    
    figure, imagesc(gd_right), axis image, colormap(gray), hold on
    plot(x_right,y_right,'ys'),
    plot(x_right(match_in_right),y_right(match_in_right),'bs'),
    plot(cordinate_right(inlier_idx,1),cordinate_right(inlier_idx,2),'gs'),
