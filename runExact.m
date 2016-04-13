Params = load('learnt_parameters/Params2.mat');
Params = Params.Params;
testData = load('test_data/test_cases_5.mat');
testData = testData.test_cases_5;
groundTruth = load('test_data/Full_states_H1_3_20.mat');
groundTruth = groundTruth.state_data_full;
addpath('Zico''s_code');
addpath /local/scratch/cplex/matlab/x86-64_linux

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

error = {};


for i = 1:length(testData),
    test_case = testData{i};
    
    %X = afmap_exact(test_case.loads', Params.Obs_MU, Params.transition_P, exactParams);
    [X,Z,G] = afamap(test_case.loads', Params.Obs_MU, Params.transition_P, afamapParams);
    
    exactXFull = [];
    error{i} = {};
    for j = 1:length(X),
        applianceState = full(X{j}(1,:));
        startPoint = test_case.absolute_timePoints(1);
        endPoint = test_case.absolute_timePoints(2);
        
        error{i}{j} = abs(sum(applianceState - groundTruth{j}(startPoint:endPoint) - 1));
    end
end


tempHolder = {};
hold on
for j = 1:5,
    temp = [];
    for i = 1:length(testData),
        temp = [temp error{i}{j}];
    end
    tempHolder{j} = temp;
end

label = [3*ones(1,100), 4*ones(1,100), 5*ones(1,100), 6*ones(1,100), 7*ones(1,100)];
boxplot([tempHolder{1},tempHolder{2},tempHolder{3},tempHolder{4},tempHolder{5}], label);


