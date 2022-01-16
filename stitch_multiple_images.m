function [img_res, H, num_inliers, residual] = stitch_multiple_images(image_cells)
image_order = get_stitch_order(image_cells);
disp(image_order)
img_res = image_cells{image_order(1)};
figure; imshow(img_res);
for i = 2 : length(image_order)
    [img_res, H, num_inliers, residual] = stitch_two_images(image_cells{image_order(i)}, img_res);
    figure; imshow(img_res);
end

end