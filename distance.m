function dist = distance(x1, x2)

% input: x1: NxC matrix, x2: MxC matric
% output: dist: NxM matrix where 
% dist(i, j) imply the squared distance between ith row of x1 and jth row of x2 
% http://nonconditional.com/2014/04/on-the-trick-for-computing-the-squared-euclidian-distances-between-two-sets-of-vectors/

[N, C1] = size(x1);
[M, C2] = size(x2);
% check row length equal
if C1 ~= C2
    error('Data dimension error')
end

% ||(x - y)||2 = x^2 + y^2 - 2 * x * y

x1_sum = sum(x1 .* 2, 2) * ones(1, M);
x2_sum = ones(N, 1) * sum(x2 .* 2, 2)';

dist = x1_sum + x2_sum - 2 .* x1 * x2'; 

if any(any(dist<0))
  dist(dist<0) = 0;
end

end
