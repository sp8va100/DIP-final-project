function [bool] = conti9(val)
%CONTI9 Summary of this function goes here
% determine if there appear 9 consecutive 1 in val

idx_zero = find(val == 0);
% all 1
if isempty(idx_zero)
    bool = 1;
else
    % fisrt zero idx greater than 9
    if idx_zero(1) > 9
        bool = 1;
    else
        val = [0, val(idx_zero(1) + 1 : end), val(1 : idx_zero(1))];
        bool = max(diff(find(~val))) - 1 >= 9;
    end
end
end


