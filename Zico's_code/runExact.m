function X = runExact(house, Params)

summedChannel = struct('name', 'summed', 'dim', 745878, 'time', [], 'load', [], 'label', {'summed'});

summedChannel.load = house.channel(3).load;
for j = 4:7,
    summedChannel.load = summedChannel.load + house.channel(j).load;
end


params.max_iter = 1;
params.lambda = Inf;
params.dlambda = Inf;
params.dSig = 2*0.01*eye(1);
params.Sig = 0.01*eye(1);

X = afmap_exact(summedChannel.load', Params.Obs_MU, Params.transition_P, params);

end
