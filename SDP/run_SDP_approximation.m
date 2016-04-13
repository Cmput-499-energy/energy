function [states]= run_SDP_approximation(Params,Y,t,n)

	m=2; %by default 2 states
	frequency=100;

	for i=1:length(Y)
		[X,M,error_]=SDP_inference1((Y{i}.loads) ,Params,t,m,n);
		states{i}=state_sampler(X,M,frequency,t,n,Params, (Y{i}.loads));
		x_vars{i}=X;
		M_vars{i}=M;
		errors{i}=error_;
	end

	save('SDP_prediction.mat', states, x_vars, M_vars, errors);	
end