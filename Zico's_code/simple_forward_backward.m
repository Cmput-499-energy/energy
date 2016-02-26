function [log_alpha, log_beta, log_c] = simple_forward_backward(P, p0, log_py)
  
n = size(P,1);
k = size(log_py,1);
m = size(log_py,2);

log_alpha = zeros(k,m);
log_beta = zeros(k,m);
log_c = zeros(m,1);
ln_P = log(P);

% forward pass
log_alpha = log(p0) + log_py(:,1);
log_c(1) = logsumexp(log_alpha(:,1));
log_alpha(:,1) = log_alpha(:,1) - log_c(1);
for i=2:m,
  log_alpha(:,i) = log_py(:,i) + ...
      logsumexp(ln_P + repmat(log_alpha(:,i-1)',n,1), 2);
  log_c(i) = logsumexp(log_alpha(:,i));
  log_alpha(:,i) = log_alpha(:,i) - log_c(i);
end

%backward pass
for i=m:-1:2,
  log_beta(:,i-1) = logsumexp(ln_P' + ...
                              repmat(log_beta(:,i)' + log_py(:,i)', n, 1),2);
  log_beta(:,i-1) = log_beta(:,i-1) - log_c(i);
end
