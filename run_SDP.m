%script for running on 5 appliances 

t=500;
load('Params2.mat');
load('test_cases_5.mat');
n=5;
[states, x_vars, M_vars, errors]=run_SDP_approximation(Params, test_cases_5,t,n);
save('SDP_prediction_5.mat', 'states', 'x_vars', 'M_vars', 'errors');	
clear all


