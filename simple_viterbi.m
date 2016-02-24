function [ln_p, z] = simple_viterbi(P, p0, ln_py)
% [lnp, z] = viterbi(ln_P, ln_p0, ln_py)
%   P: n times transition matrix
%   ln_p0: n times 1 initial log probability vector
%   ln_py: n times m observation probability matrix
%   z_last: last_state
%   ln_p: log probability of most likely path
%   z: most likely path
  
n = size(P,1);
m = size(ln_py,2);  
omega = zeros(n,m);
psi = zeros(n,m);

ln_P = log(P);
omega(:,1) = log(p0) + ln_py(:,1);
for i=2:m,
  [omega(:,i),psi(:,i-1)] = max(ln_P + repmat(omega(:,i-1)',n,1),[],2);
  omega(:,i) = omega(:,i) + ln_py(:,i);
end

z = zeros(1,m);
[ln_p, z(m)] = max(omega(:,m));

for i=m-1:-1:1,
  z(i) = psi(z(i+1),i);
end
