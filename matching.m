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
%     match_in_src = [];
%     match_in_tar = [];
%     for i = 1:col
%         [~,idx]=sort(dist(i,:));
%         if dist(i,idx(1))/dist(i,idx(2)) < 0.8
%             match_in_src = [match_in_src;i];
%             match_in_tar = [match_in_tar;idx(1)];
%             if length(match_in_src) == num
%                 break;
%             end
%         end
%     end
end

