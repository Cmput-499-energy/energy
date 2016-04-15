%script for running on 18 appliances 

cvx_solver SEDUMI
t=500;
load('Params1.mat');
load('test_cases_18.mat');
n=18;
[states, x_vars, M_vars, errors]=run_SDP_approximation(Params, test_cases_18(1),t,n);
save('SDP_prediction_18_1.mat', 'states', 'x_vars', 'M_vars', 'errors');	
clear all