function [match_in_src, match_in_tar] = matching(d_src,d_tar, num)
    d_src = zscore(d_src')';
    d_tar = zscore(d_tar')';
    
    %compute distance
    dist = distance(d_src, d_tar);
    
    [col, row] = size(dist);
    [~, idx] = sort(reshape(dist, 1, []));
    [r,c] = ind2sub([col,row], idx(1:num));
    match_in_src = r';
    match_in_tar = c';
end

