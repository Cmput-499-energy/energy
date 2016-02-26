function [map_se, afa_se, afand_se, afana_se, vmf_se, prior_se, zero_se] = ...
      test_afamap0(T, n, k, p, seed);

% random problem
p = p*ones(k,1);  
randn('state', seed);
rand('state', seed);

% random means and transition matrices
clear P; clear mu;
for i=1:k,
  mu{i} = 2*rand(n,p(i));
  P{i} = spdiags([1+rand(p(i),1) 30*ones(p(i),1)], [-1 0], p(i), p(i));
  P{i}(1,end) = rand;
  P{i} = P{i}*spdiags(1./full(sum(P{i})'), 0, p(i), p(i));
end

% random samples
clear X;
for i=1:k, 
  X{i} = zeros(p(i),T);
  X{i}(ceil(rand*p(i)),1) = 1; 
end
for t=2:T,
  for i=1:k, 
    X{i}(:,t) = 0;
    X{i}(rand_state(P{i}*X{i}(:,t-1)),t) = 1;
  end
end

Y = 0.1*randn(n,T);
for i=1:k,
  Y0{i} = mu{i}*X{i};
  Y = Y + Y0{i};
end


% inference
params.max_iter = 1;
params.lambda = Inf;
params.dlambda = Inf;
params.dSig = 2*0.01*eye(n);
params.Sig = 0.05*eye(n);
X_afa = afamap(Y, mu, P, params);

params.dSig = 100000*0.01*eye(n);
params.Sig = 0.05*eye(n);
X_afa_nodiff = afamap(Y, mu, P, params);

params.dSig = 2*0.01*eye(n);
params.Sig = 100000*0.05*eye(n);
X_afa_noadd = afamap(Y, mu, P, params);

params.Sig = 0.01*eye(n);
if (p(1)^k < 2000)
  X_exact = afmap_exact(Y, mu, P, params);
else
  X_exact = cell(1,k); for i=1:k, X_exact{i} = nan*ones(size(X_afa{1})); end
end

X_vmf = af_varmf(Y, mu, P, params, 20, 15);
X_prior = af_varmf(Y, mu, P, params, 0, 0);


% compute errors
map_se = 0;
afa_se = 0;
afand_se = 0;
afana_se = 0;
vmf_se = 0;
prior_se = 0;
zero_se = 0;

for i=1:k,
  map_se = map_se + norm(mu{i}*X_exact{i} - mu{i}*X{i},'fro')^2;
  afa_se = afa_se + norm(mu{i}*X_afa{i} - mu{i}*X{i},'fro')^2;
  afand_se = afand_se + norm(mu{i}*X_afa_nodiff{i} - mu{i}*X{i},'fro')^2;
  afana_se = afana_se + norm(mu{i}*X_afa_noadd{i} - mu{i}*X{i},'fro')^2;
  
  vmf_se = vmf_se + norm(mu{i}*X_vmf{i} - mu{i}*X{i},'fro')^2;
  prior_se = prior_se + norm(mu{i}*X_prior{i} - mu{i}*X{i},'fro')^2;
  zero_se = zero_se + norm(mu{i}*X{i},'fro')^2;
end
