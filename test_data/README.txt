housei_j_k.mat: i is the house number, j is the starting channel number and k is the ending channel number. These files contain the summation of those channels over the last 20000 time points.

Full_states_H1_i_j.mat : contains states of channels from channel i to channel j over all time points for house 1.

Full_testData_i.mat : contains all the test points(last 20% of data) which is the signal we get by summing over i many appliances.

test_cases_i.mat : contains 100 test cases(each cases/section contains 500 points) randomly sampled from the Full_testData_i.mat with corresponding i.
