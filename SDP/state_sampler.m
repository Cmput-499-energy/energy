function [states] = state_sampler(x_var,M_var, frequency, t, n, Params, aggregate)

% samples discrete binary states(on/off) given the optimal variables( x vectors and M matrices). Frequency is the number of times the sampler will sample.
% timepoints are the number of samples


rng('shuffle') %initializing random number generator seed
m=2;

for i=1:n
	for j=1:t
		if j<t
			x_var{i,j}(1) = squash(x_var{i,j}(1));
			x_var{i,j}(2) = squash(x_var{i,j}(2));
		else
			x_var{i,j}(3) = squash(x_var{i,j}(3));
			x_var{i,j}(4) = squash(x_var{i,j}(4));			
		end
	end
	Params.transition_P{i} = -log(Params.transition_P{i});
end

min_obj_value=inf;
min_obj_states=0; %just for declaring

for f=1:frequency
	transition_matrix=zeros(m*n,m*(t-1));
	state_matrix=zeros(n, t);

	for i=1:n
		for j=1:t
			if j<t
				p=[x_var{i,j}(1), x_var{i,j}(2)];
			else
				p=[x_var{i,j}(3), x_var{i,j}(4)];
			end
			state=find(mnrnd(1,p)==1);
			state_matrix(i,j)=state;

			if j>1
				if prev_state==1 and state==1
					transition_matrix(m*(i-1)+1, m*(j-2)+1)=1;
				end
				if prev_state==1 and state==2
					transition_matrix(m*(i-1)+1, m*(j-1))=1;
				end
				if prev_state==2 and state==1
					transition_matrix(m*i, m*(j-2)+1)=1;
				end
				if prev_state==2 and state==2
					transition_matrix(m*i, m*(j-1))=1;
				end
			end
			prev_state=state;
		end
	end			

	obj_value= objective(state_matrix, transition_matrix, t, n, m, Params, aggregate);	
	if obj_value < min_obj_value
		min_obj_value=obj_value;
		min_obj_states=state_matrix;
	end

end

states=min_obj_states;
end



function [f_value] = objective(states, transition_matrix, t, n, m, Params, aggregate)

	f_value=0;
	error_1=0;
	error_2=0;

	for j=1:t
		predicted_y=0;
		for i=1:n
			state_index=states(i,j);
			predicted_y= predicted_y + Params.Obs_MU{i}(state_index);
		end
		error1_temp= (aggregate(j) - predicted_y)^2 * (Params.Obs_COV^-1); 
		error_1=error_1 + error1_temp;
	end
	error_1=error_1*0.5;


	for i=1:n
		A=repmat(Params.transition_P{i}, 1, t);
		index=m*(i-1)+1:m*(i);
		T_M_vec=reshape(transition_matrix(index, :), 1, numel(transition_matrix(index, :)));
		error_2 = error_2 + dot(A(:), T_M_vec);
	end

	f_value = error_1 + error_2;
end



function [value] = squash(x)
	value=0;
	tolerance=10^-4;
	if x>0.5
		if 1-x < tolerance % if x is within the threshold value of 1
			value=1;
		end
	else
		if x<tolerance %if x is within the threshold value of 0
			value=0;
		end
	end
end