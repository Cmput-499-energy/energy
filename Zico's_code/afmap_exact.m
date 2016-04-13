function X1 = afmap_exact(Y_bar, mu, P,params)
  
N = length(P);
n = 1;  
T = size(Y_bar,2);

% form joint HMM
siz = zeros(1,N);
siz(1) = size(P{1},1);
P0 = P{1};  
mu0 = mu{1};
for i=2:N,  
  siz(i) = size(P{i},1);
  %mask = kron(ones(siz(i)), eye(size(P0))) | kron(eye(siz(i)), ones(size(P0)));
  P0 = kron(P{i}, P0);
  clear mu0_;
  for j=1:n,
    mu0_(j,:) = log(kron(exp(mu{i}(j,:)), exp(mu0(j,:))));
  end
  mu0 = mu0_;
end

size(mu0)
size(params.Sig)

ln_py = -0.5*sqdist(inv(sqrtm(params.Sig))*mu0, inv(sqrtm(params.Sig))*Y_bar);
p0 = ones(size(mu0,2),1)/size(mu0,2);

% map inference
[ln_p, x0] = simple_viterbi(P0, p0, ln_py);

% decode output state
X0 = cell(N,1); X1 = cell(N,1);
[X0{:}] = ind2sub(siz, x0);
for i=1:N,
  X1{i} = sparse(X0{i}, 1:T, ones(T,1), siz(i), T);
end

end

% matrix for all pairwise differences  
function Dki = diff_k(k)
  [x,y] = ndgrid(1:k,1:k);
  ind = [y(:) x(:)]';
  Dki = sparse(ind(:),kron((1:k^2)',ones(2,1)),kron(ones(k^2,1),[-1;1]), k, k^2);
end
