
testData = load('test_cases_18.mat');
testData = testData.test_cases_18;
groundTruth = load('test_data/Full_states_H1_3_20.mat');
groundTruth = groundTruth.state_data_full;
n=18;
num_segments=10;

for i = 1:num_segments,
    load(strcat('SDP_prediction_18_',num2str(i),'.mat'));
    test_case = testData{i};
    
    %X = afmap_exact(test_case.loads', Params.Obs_MU, Params.transition_P, exactParams);
    error{i} = {};
    for j = 1:n,
        startPoint = test_case.absolute_timePoints(1);
        endPoint = test_case.absolute_timePoints(2);
        
        error{i}{j} = abs(sum(states{1}(j,:) - groundTruth{j}(startPoint:endPoint) - 1));
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

label = [1*ones(1,10), 2*ones(1,10), 3*ones(1,10), 4*ones(1,10), 5*ones(1,10), 6*ones(1,10), 7*ones(1,10), 8*ones(1,10), 9*ones(1,10), 10*ones(1,10), 11*ones(1,10), 12*ones(1,10), 13*ones(1,10), 14*ones(1,10), 15*ones(1,10), 16*ones(1,10), 17*ones(1,10), 18*ones(1,10)];
boxplot([tempHolder{1},tempHolder{2},tempHolder{3},tempHolder{4},tempHolder{5}, tempHolder{6},tempHolder{7},tempHolder{8},tempHolder{9},tempHolder{10}, tempHolder{11}, tempHolder{12},tempHolder{13},tempHolder{14},tempHolder{15}, tempHolder{16}, tempHolder{17},tempHolder{18}]);

er = 0;
for j = 1:n,
    temper = 0;
    for i = 1:num_segments,
        temper = temper + error{i}{j};
    end
    er = er + temper/500;
end
er/num_segments

