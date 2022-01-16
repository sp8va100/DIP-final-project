function image_order = get_stitch_order(image_array)
num_of_image = length(image_array);
image_order = zeros(1, num_of_image);
inlier_matrix = zeros(num_of_image, num_of_image);
for i = 1 : num_of_image
    for j = 1 : num_of_image
        [~, ~, inliers, ~] = stitch_two_images(image_array{i}, image_array{j});
        inlier_matrix(i, j) = inliers;
        inlier_matrix(j, i) = inliers;
    end
end

% get the image with most inliers to serve as base image
owned_inliers = sum(inlier_matrix, 2);
[~, idx] = max(owned_inliers);
image_order(1) = idx;

candidate_inliers = [];
candidate_idx = [];
for i = 1 : num_of_image
    if i ~= idx
        candidate_inliers = [candidate_inliers inlier_matrix(idx, i)];
        candidate_idx = [candidate_idx i];
    end
end

% already used image
used = zeros(1, num_of_image);
used(idx) = 1;

for i = 2 : num_of_image
    [~, idx] = max(candidate_inliers);
    image_order(i) = candidate_idx(idx);
    used(candidate_idx(idx)) = 1;
    
    tmp_inliers = [];
    tmp_idx = [];
    for j = 1 : length(candidate_idx)
        if used(candidate_idx(j)) == 0
            tmp_inliers = [tmp_inliers candidate_inliers(j)];
            tmp_idx = [tmp_idx candidate_idx(j)];
        end
    end

    
    for j = 1 : num_of_image
        if used(j) == 0
            tmp_inliers = [tmp_inliers inlier_matrix(candidate_idx(idx), j)];
            tmp_idx = [tmp_idx j];
        end
    end

    candidate_inliers = tmp_inliers;
    candidate_idx = tmp_idx;



end