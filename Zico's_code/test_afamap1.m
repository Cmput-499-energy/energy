function [map_se, afa_se, maptv_se, afatv_se, prior_se, zero_se] = ...
      test_afamap1(T, n, k, p, seed, random_walk);

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
Y = Y + cumsum(random_walk*randn(n,T),2);
  
for i=1:k,
  Y0{i} = mu{i}*X{i};
  Y = Y + Y0{i};
end



% inference
params.lambda = 1;
params.dlambda = 1;
params.dSig = 2*0.01*eye(n);
params.Sig = 0.05*eye(n);
params.max_iter = 20;
X_afatv = afamap(Y, mu, P, params);

params.lambda = Inf;
params.dlambda = Inf;
X_afa = afamap(Y, mu, P, params);

params.Sig = 0.01*eye(n);
X_map = afmap_exact(Y, mu, P, params);
X_map0 = cell2mat(X_map);


% alternating minimization for map with TV
params.lambda = 1;
params.dlambda = 1;
mu_bar = cell2mat(mu);
Z = zeros(size(Y));
for i=1:params.max_iter,
  Y_bar0 = Y - mu_bar*X_map0;
  oldZ = Z;
  for i=1:size(Z,1),
    Z(i,:) = solveTV1_PNc(Y_bar0(i,:)', params.lambda)';
  end
  if (norm(Z - oldZ) < 1e-4), break; end
  X_maptv = afmap_exact(Y - Z, mu, P, params);
  X_map0 = cell2mat(X_maptv);
end



X_prior = af_varmf(Y, mu, P, params, 0, 0);


% compute errors
map_se = 0;
afa_se = 0;
maptv_se = 0;
afatv_se = 0;

prior_se = 0;
zero_se = 0;

for i=1:k,
  map_se = map_se + norm(mu{i}*X_map{i} - mu{i}*X{i},'fro')^2;
  afa_se = afa_se + norm(mu{i}*X_afa{i} - mu{i}*X{i},'fro')^2;
  maptv_se = map_se + norm(mu{i}*X_maptv{i} - mu{i}*X{i},'fro')^2;
  afatv_se = afatv_se + norm(mu{i}*X_afatv{i} - mu{i}*X{i},'fro')^2;
  
  prior_se = prior_se + norm(mu{i}*X_prior{i} - mu{i}*X{i},'fro')^2;
  zero_se = zero_se + norm(mu{i}*X{i},'fro')^2;
end
