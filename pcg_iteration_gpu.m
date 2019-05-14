%Copyright © 2019- Sampsa Pursiainen & GPU-ToRRe Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre
function [x,conv_val,n_iter] = pcg_iteration_gpu(A,b,tol_val,max_it,M,x);

A = gpuArray(A);
b = gpuArray(b);
x = gpuArray(x);
M = gpuArray(M); 

r = b - A*x;
z = M.*r;
p = z;
j = 1;

conv_val = sqrt(max(sum(r.^2)'./sum(b.^2)'));

while (conv_val > tol_val) & (j < max_it)
aux_vec = A*p;
    alpha = sum(z.*r)./sum(p.*aux_vec);
    x = x + alpha*p;
    rnew = r - alpha*aux_vec;
    znew = M.*rnew;
    beta = sum(znew.*rnew)./sum(z.*r);
    p = znew + beta*p;
    r = rnew;
    z = znew;
    j = j + 1;
    conv_val = sqrt(max(sum(r.^2)'./sum(b.^2)'));
end

n_iter = j;

return