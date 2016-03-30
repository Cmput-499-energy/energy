function [Params]=training(house_data)
	sum_data=0;
	loads={};
	state_data={};
    states=[0,1]; %changed states as it creates conflicts with MLE functions(doesnt accept 0 as a state);
    no_chains=house_data.numChannels - 2;
    isNoisy=false;
    laplacian_coefficient=1;

	[contiguous_blocks, timePoints]=extract_contiguousTime(house_data.channel(3).time);

	for i=3:house_data.numChannels
		sum_data= sum_data+house_data.channel(i).load;
		x=house_data.channel(i).load;
	    [smoothed_data, t, h_thresh, l_thresh]=smoothData(x, timePoints, 0.7,'normal');
	    [squarized_data, squarized_time]=squarize(smoothed_data, t, h_thresh, l_thresh);
	    filled_data=fillData(squarized_data, squarized_time, length(timePoints));
        state_data{end+1}=filled_data;
	    loads{end+1}=x';
    end
    
    [T_probs, priors] = trans_MLE(no_chains, loads, timePoints, states, contiguous_blocks, laplacian_coefficient);
    loads{end}=sum_data';
    [MU_e, COV_e, ~]=obs_gauss_MLE(no_chains, loads, state_data, states, isNoisy);
    
    Params.transition_P=T_probs;
    Params.prior_P=priors;
    Params.Obs_MU=MU_e;
    Params.Obs_COV=COV_e;

    save('Params.mat','Params');
end