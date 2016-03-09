function [T_probs] = trans_MLE(no_chains, data, timePoints, states, contiguous_blocks, laplacian_coefficient)

	%
	% 	Author: Touqir Sajed    
	% 	Date: March 8, 2016     
	%	Filname: trans_MLE.m
	%
	% Description: This function estimates the transition probabilities of each of the chains of FHMM using maximum likelihood in a supervised fashion. 
	%			   It also uses laplacian approximation to make sure that there are no zero probabilities. If you dont see a state in your data, it doesnt
	%              mean that seeing that state in new data from the same distribution will have a zero probability.
	%
	% no_chains: number of chains of the FHMM. In our case it is the number of appliances
	%
	% data: a structure containing 'n' data_array where 'n'=no_chains. Each data_array is a 1*m matrix where m is the number of time points or samples.
	%
	% timePoints: a 1D row matrix that contains all those time points that our MLE algorithm will be using for learning the transition probabilities. 
	%
	% states: a structure containing 'n' state_array where n=no_chains and 'state_array' is a 1D row matrix containing the different states 
	% 		  by integers.
	%
	% contiguous_blocks: a 2D matrix of dimension k*2 where k is the number of contiguous blocks. Suppose your timePoints=[1,2,3,5,6,9,10].
	%                    [1,2,3], [5,6], [9,10] are the contiguous blocks as each of the time points are one after the another unlke 3,5 and 6,9.
	%                    This needed as we may have timePoints with more than 1 contiguous blocks and our learning algorithm will treat the resulting
	%                    extracted data_array as 1 contiguous block and that would be an error as then the model assumes that even timepoints say
	%					 6,9 comes immediately one(9) after the other(6) which is not correct as the data was extracted with timepoints[...5,6,7,8,9,...].
	%                    Thus our algorithm will assign our transition parameters wrong values.
	%
	% T_probs: a structure contain 'n' 'A' arrays where 'n'=no_chains and 'A' is the transition probability matrix.
	%
	
	no_contiguous_blocks=size(contiguous_blocks, 1);
	contiguous_data={};
	T_probs={};

	for i=1:no_contiguous_blocks
		start_t = contiguous_blocks(i,1);
		end_t = contiguous_blocks(i,2);
		for j=1:no_chains
			ts=timePoints(start_t:end_t);
			X = data{j}(ts);
			contiguous_data{i,j} = X; 

		end
	end

	% contiguous_data{1,1}

	for i=1:no_chains %looping through the chains
		A=zeros(length(states), length(states));
		for current_state=states %looping through the states at time=t
			calcaluated_frequency_CS=false;
			frequency_current_state=0;
			for next_state=states %looping through the states at time=t+1
				frequency_next_state=0;
				for j=1:no_contiguous_blocks %looping through the contiguous blocks
					for t=1:(length(contiguous_data{j,i})-1);
						if (contiguous_data{j,i}(t)==current_state && contiguous_data{j,i}(t+1)==next_state)
							frequency_next_state = frequency_next_state + 1;
						end
					end
					if calcaluated_frequency_CS == false
						frequency_current_state = frequency_current_state + sum(contiguous_data{j,i}(1:end-1)==current_state);
					end
				end
				calcaluated_frequency_CS=true;
                
				if frequency_current_state==0
					A(current_state, :)=repmat([1/length(states)], [1,length(states)]); % all the next state transitions have same probability
					break;
				end				
				A(current_state, next_state)= (frequency_next_state+laplacian_coefficient)/ (frequency_current_state+laplacian_coefficient*length(states)); % Probability estimation with Laplace smoothing.
			end
		end
		T_probs{i}=A;
	end
end


