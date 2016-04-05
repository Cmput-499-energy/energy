function [MU, COV, noiseParam]= obs_gauss_MLE(no_chains, data, state_data, states, isNoisy)
	
	%
	% 	Author: Touqir Sajed    
	% 	Date: March 23, 2016     
	%	Filname: obs_gauss_MLE.m
	%
	% Description: Learns the parameters for the gaussian likelihood distribution with mu=(sum over all means) and covariance is the common covariance matrix
	%
	% no_chains: number of chains of the FHMM. In our case it is the number of appliances
	%
	% data: a cell containing 'n'+2 data_array where 'n'=no_chains. Each data_array is a 1*m matrix where m is the number of time points or samples.
	%       1st cell element refers to the data array of the cumulative observation(mains meter reading). 2nd element 
	%
	% timePoints: a 1D row matrix that contains all those time points that our MLE algorithm will be using for learning the transition probabilities. 
	%
	% state_data: a matrix similar to 'data' cell only that it contains 'n' data row vectors(without mains) and data arrays contain state numbers 
	%             and not the power readings.
	%
	% states: array containing state indices.
	%
	% MU: A cell containing i number of elements. i is the number of HMMs. Each element is a 1*|s| array where |s| is the number of states.
	% COV: The variance of the univariate guassian. As our observation has single feature/dimension, we are using univariate guassian
	%

	no_samples=size(data{1},2);
    no_states=length(states);
    observedData=data{end};

	if isNoisy==true
		dif=data{1}-data{2};
		noiseMU=mean(dif);
		noiseCOV=mean((dif-noiseMU).^2);
		noiseParam=[noiseMU, noiseCOV];
		a=2;
	else
		noiseParam=[];
		a=1;
	end

	temp=zeros(no_states, no_samples);
	temp_index=1;

	for i=1:no_chains
		chain_data=data{i};
		chain_states=state_data{i};
		for j=states
			indices= chain_states==j;
			state_D=chain_data(indices);
			% size(state_D)
			mu=mean(state_D, 2);
			j_ind=find(states==j);
			MU{i}(j_ind) = mu;
            % t=repmat(mu, [1,no_samples]);
            % indices
            % t
			temp(temp_index, indices) = mu;
			temp_index=temp_index+1;
		end
	end

	MUs = sum(temp, 1);
    % temp
	COV = mean((observedData - MUs).^2);

end