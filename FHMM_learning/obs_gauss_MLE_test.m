data={};
data{1}=[0.9, 5.5, 0.92, 0.89, 5.1, 5.2, 4.6, 1.1];
data{2}=[0.88,0.83, 6.1, 6.2,  5.8,  6, 0.81,0.77];
data{3}=[1.7800    6.3300    7.0200    7.0900   10.9000   11.2000    5.4100    1.8700];

state_data={};
state_data{1}= [1 2 1 1 2 2 2 1];
state_data{2}= [1 1 2 2 2 2 1 1];
no_chains=2;
states=[1,2];
isNoisy=false;

MU{1}=[0.95250, 5.1];
MU{2}=[0.82250, 6.0250];

temp_mu=[1.7750, 5.9225, 6.9775, 6.9775, 11.125, 11.125, 5.9225, 1.7750];
cov1=0.063559375;

[MU_e, COV_e, ~]=obs_gauss_MLE(no_chains, data, state_data, states, isNoisy);

MU_e{1}==MU{1}
MU_e{2}==MU{2}
(COV_e-cov1)<10e-8
