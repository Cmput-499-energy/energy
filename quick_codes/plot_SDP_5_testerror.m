function [] = calc_SDP_error

testData = load('test_cases_5.mat');
testData = testData.test_cases_5;
load('SDP_prediction_5.mat');
groundTruth = load('test_data/Full_states_H1_3_20.mat');
groundTruth = groundTruth.state_data_full;
n=5;
num_segments=100

for i = 1:100,
    test_case = testData{i};
    
    %X = afmap_exact(test_case.loads', Params.Obs_MU, Params.transition_P, exactParams);
    error{i} = {};
    for j = 1:n,
        startPoint = test_case.absolute_timePoints(1);
        endPoint = test_case.absolute_timePoints(2);
        
        error{i}{j} = abs(sum(states{i}(j,:) - groundTruth{j}(startPoint:endPoint) - 1));
    end
end


tempHolder = {};
hold on
for j = 1:n,
    temp = [];
    for i = 1:num_segments,
        temp = [temp error{i}{j}];
    end
    tempHolder{j} = temp;
end

label = [3*ones(1,100), 4*ones(1,100), 5*ones(1,100), 6*ones(1,100), 7*ones(1,100)];
boxplot([tempHolder{1},tempHolder{2},tempHolder{3},tempHolder{4},tempHolder{5}], label);

