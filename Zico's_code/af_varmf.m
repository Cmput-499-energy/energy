function [X] = af_varmf(Y_bar, mu, P, params, n_total, n_anneal)
  
N = length(P);
n = size(mu{1},1);  
T = size(Y_bar,2);


% initialize posteriors with prior
Y_hat = zeros(size(Y_bar));
for i=1:N,
  P0 = P{i}^1000;
  p = P0(:,1);
  p0{i} = ones(size(p,1),1) / size(p,1);
  X{i} = repmat(p, 1, T);
  Y_hat = Y_hat + mu{i}*X{i};
end


% iterate inference with annealed variance parameter
Z = zeros(size(Y_hat));
for t=1:n_total,
  for i=1:N,
    Y_hat = Y_hat - mu{i}*X{i} - Z;
    if (t <= n_anneal)
      Sig = (1 + 100/t)*params.Sig;
    else
      Sig = params.Sig;
    end
    
    delta = diag(mu{i}'*inv(Sig)*mu{i});
    logp = mu{i}'*inv(Sig)*(Y_bar - Y_hat) - repmat(0.5*delta, 1, T);
    
    [log_alpha, log_beta, log_c] = simple_forward_backward(P{i}, p0{i}, logp);
    X{i} = exp(log_alpha + log_beta);
    X{i} = X{i} ./ repmat(sum(X{i}), size(X{i},1), 1);
    Y_hat = Y_hat + mu{i}*X{i};
  end
end




  
