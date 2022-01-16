function [img_res, H, num_inliers, residual] = stitch_two_images(img_left, img_right)

gd_middle = im2double(rgb2gray(img_left));
gd_right = im2double(rgb2gray(img_right));

disp('Harris......');
% harris corner detection
k = 0.04;
sizeofmask = 5;
threshold = 0.05;
harris_sigma = 2;

[~, y_middle, x_middle] = harris(gd_middle, harris_sigma, threshold, sizeofmask, k);
[~, y_right, x_right] = harris(gd_right, harris_sigma, threshold, sizeofmask, k);

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
[H, num_inliers,residual] = ransac(cordinate_middle, cordinate_right, iter);

disp('Stitch...');
% stitch
img_res = stitchH(img_left, H, img_right);

 figure;
 imshow(img_res);
end