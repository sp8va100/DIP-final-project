function [H, max_num_inliers,residual] = ransac(XY_src, XY_des, ransac_iter_times)
    %ransac_iter_times set to 100000
    max_num_inliers = 0;
    for i = 1:ransac_iter_times
        ind = randperm(size(XY_src,1));
        ind_select = ind(1:4);
        ind_residual = ind(5:end);
        tmp_H = my_homography_fit(XY_src(ind_select,:), XY_des(ind_select,:));
        predict = my_homography_tf(XY_src(ind_residual,:),tmp_H);
        
        dists = sum((XY_des(ind_residual,:) - predict).^2,2);
        
        inlier_idx = find(dists < 0.1);
        tmp_num_inliers = length(inlier_idx);
        
        if tmp_num_inliers > max_num_inliers
            H = tmp_H;
            max_num_inliers = tmp_num_inliers;
            residual = mean(dists(inlier_idx));%可以不要但刪了會影響到前面我先不刪
        end
    end
end

