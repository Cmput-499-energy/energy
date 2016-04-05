function [Params]=training(house_data, channels, train_proportion)
    
    %example:
    %  data=loadData();
    %  Params=training(data.house(1),[3: data.house(1).numChannels])
    %
    %

	sum_data=0;
	loads={};
	state_data={};
    state_data_full={};
    states=[0,1]; %changed states as it creates conflicts with MLE functions(doesnt accept 0 as a state);
    no_chains=length(channels);
    isNoisy=false;
    laplacian_coefficient=0.1;
    no_points=int32(length(house_data.channel(3).time)*train_proportion);
    totalPoints=length(house_data.channel(3).time);

	[contiguous_blocks, ~]=extract_contiguousTime(house_data.channel(3).time(1:no_points));

	for i=channels
		sum_data= sum_data+house_data.channel(i).load(1:no_points);
		x=house_data.channel(i).load;
	    [smoothed_data, t, h_thresh, l_thresh]=smoothData(x, 1:totalPoints, 0.7,'normal');
	    [squarized_data, squarized_time]=squarize(smoothed_data, t, h_thresh, l_thresh);
	    filled_data=fillData(squarized_data, squarized_time, totalPoints);
        state_data{end+1}=single(filled_data(1:no_points)); % Number of points for training        
        state_data_full{end+1}=single(filled_data);
	    loads{end+1}=x(1:no_points)';
    end
    
    [T_probs, priors] = trans_MLE(no_chains, state_data, states, contiguous_blocks, laplacian_coefficient);
    loads{end+1}=sum_data';
    [MU_e, COV_e, ~]=obs_gauss_MLE(no_chains, loads, state_data, states, isNoisy);
    
    Params.transition_P=T_probs;
    Params.prior_P=priors;
    Params.Obs_MU=MU_e;
    Params.Obs_COV=COV_e;
    Params.proportion=train_proportion;

    save('Params2.mat','Params');
%     save('test_data_states_H1_3_20.mat','state_data_full');
end