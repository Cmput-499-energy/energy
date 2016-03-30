function trans_MLE_test

	%
	% 	Author: Touqir Sajed    
	% 	Date: March 8, 2016     
	%	Filname: trans_MLE_test.m
	%
	% Description: Used for testing the trans_MLE function which estimates transition probabilities of FHMM using maximum likelihood.
	%
	%

	laplacian_coefficient=0.001;

	states=[4,1,2,3];
	data_1=[1,1,1,2,1,2,2,2,2];
	% timepoints=1:length(data_1);
	% no_chains=1;
	data{1}=data_1;
	% contiguous_blocks=[1,length(data_1)];
	% [probs,priors]=trans_MLE(no_chains, data, timepoints, states, contiguous_blocks, laplacian_coefficient);
	% disp('With no contiguous blocks - Matrix A: ');
	% disp(probs{1});
	% disp('priors: ');
	% disp(priors{1});

	% timepoints=[1,2,3,6,7,8];
	% contiguous_blocks=[1,3; 4,6];
	% [probs, priors]=trans_MLE(no_chains, data, timepoints, states, contiguous_blocks, laplacian_coefficient);
	% disp('With contiguous blocks - Matrix A: ');
	% disp(probs{1});
	% disp('contiguous_blocks were: ');
	% for i=1:size(contiguous_blocks, 1)
	% 	disp(data_1(timepoints(contiguous_blocks(i,1):contiguous_blocks(i,2))));
	% end;
	% disp('priors: ');
	% disp(priors{1});


	timepoints=[1,2,3,6,7,8];
	data_2=[1,2,2,3,2,1,2,3,1];
	data{2}=data_2;
	contiguous_blocks=[1,3; 4,6];
	no_chains=2;
	[probs,priors]=trans_MLE(no_chains, data, timepoints, states, contiguous_blocks, laplacian_coefficient);
	disp('With contiguous blocks - Matrix A for chain 1: ');
	disp(probs{1});
	disp('With contiguous blocks - Matrix A for chain 2: ');
	disp(probs{2});
	disp('contiguous_blocks were: ');
	for i=1:size(contiguous_blocks, 1)
		fprintf('For 1st chain, contiguous block %d is:\n',i);
		disp(data_1(timepoints(contiguous_blocks(i,1):contiguous_blocks(i,2))));
		fprintf('For 2nd chain, contiguous block %d is:\n',i);
		disp(data_2(timepoints(contiguous_blocks(i,1):contiguous_blocks(i,2))));
	end;
	disp('priors: ');
	disp(priors{1});
	disp(priors{2});

end