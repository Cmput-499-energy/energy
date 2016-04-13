function X = statesFromExact(Ybar, Params)

params.max_iter = 1;
params.lambda = Inf;
params.dlambda = Inf;
params.dSig = 2*0.01*eye(1);
params.Sig = 0.01*eye(1);

X = afmap_exact(Ybar, Params.Obs_MU, Params.transition_P, params);

end
