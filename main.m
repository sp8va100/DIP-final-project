clear all;
close all;
% ./images/left/IMG_8055.jpg
% ./images/img/IMG_8078.jpg
% ./images/img/IMG_8076.jpg
%/middle/IMG_8029.jpg
%/right/IMG_8045.jpg
img_left = imread('./images/img/home_4.jpg');
img_middle = imread('./images/img/home_2.jpg');
img_right = imread('./images/img/home_5.jpg');
img_cells{1} = img_left;
img_cells{2} = img_middle;
img_cells{3} = img_right;
[img_res, H, num_inliers, residual] = stitch_multiple_images(img_cells);
% [img_res, H, num_inliers, residual] = stitch_two_images(img_middle, img_right);
% 
% figure;
% imshow(img_res);

%     figure, imagesc(gd_middle), axis image, colormap(gray), hold on
%     plot(x_middle,y_middle,'ys'),
%     plot(x_middle(match_in_middle),y_middle(match_in_middle),'bs'),
%     predict = homography_tf(cordinate_middle,H);
%     dists = sum((cordinate_right - predict).^2,2);
%     inlier_idx = find(dists < 0.3);
%     plot(cordinate_middle(inlier_idx,1),cordinate_middle(inlier_idx,2),'gs'),
%     
%     figure, imagesc(gd_right), axis image, colormap(gray), hold on
%     plot(x_right,y_right,'ys'),
%     plot(x_right(match_in_right),y_right(match_in_right),'bs'),
%     plot(cordinate_right(inlier_idx,1),cordinate_right(inlier_idx,2),'gs'),
