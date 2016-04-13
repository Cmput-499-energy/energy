Params = load('learnt_parameters/Params1.mat');
testData = load('test_data/test_cases_18.mat');
groundTruth = load('test_data/Full_states_H1_3_20.mat');

exactParams.max_iter = 1;
exactParams.lambda = Inf;
exactParams.dlambda = Inf;
exactParams.dSig = 2*0.01*eye(1);
exactParams.Sig = 0.01*eye(1);

afamapParams.max_iter = 1;
afamapParams.lambda = Inf;
afamapParams.dlambda = Inf;
afamapParams.dSig = 2*0.01*eye(1);
afamapParams.Sig = 0.05*eye(1);

Params
for i = 1:1,%length(test_cases_18),
    test_case = test_cases_18{i};
    load = test_case.loads;
    exactX = afmap_exact(load', Params.Obs_MU, Params.transition_P, exactParams);
    exactXFull = [];
    for j = 1:18,
        exactXFull(j) = full(X{j});
    end
    exactXFull
    %afamapX = afamap(load', Params.Obs_MU, Params.transition_P, afamapParams);
    
    
end

