function [x_var, M_var, errors] = SDP_inference1(data,Params,t,m,n) 

%This solution relies on x (column vector) having size of 2*m which is each x denotes the states of each appliances over 2 timesteps. M=x*x'
%Number of variables in terms of x = n*2m*(t-1)
%Number of variables in terms of M = 4m^2*n*(t-1)
% n=number of appliances
% m=number of states
% t=number of timesteps

% n=20; % Number of appliances
% m=2; % Number of states
% t=100; %Number of timepoints
sum_t=ones(1,t); %variable for summing over all timepoints
sum_m=ones(1,m); %variable for summing over all states
y=data;
rep_A=[];
x_size=2*m;
A=Params.transition_P;
mu=Params.Obs_MU;
M_size=(2*m);

str1='variable M';
str2='(x_size,x_size) semidefinite';

str3='variable x';
str4='(x_size)';
log_A={};
offdiagonal= 1-eye(m,m);




cvx_begin
	expressions aggregate_hat(t);
	tic
	first_TIME=true;
	for j=1:t
		t_str=num2str(j);
		s_str=''; %corresponding to x
		s2_str=''; %corresponding to M
		eval(strcat('agg',t_str,'=0'));
		for i=1:n
			n_str=num2str(i);
			M_str=strcat('M',n_str,'_',t_str);
			x_str=strcat('x',n_str,'_',t_str);
			if j>1
				x_prev_str=strcat('x',n_str,'_',num2str(j-1));
				M_prev_str=strcat('M',n_str,'_',num2str(j-1));
			end
			
			if first_TIME == true
				log_A{i} = log(Params.transition_P{i});
			end

			if j<t
				eval(strcat(str3,n_str,'_',t_str, str4)); %creates the xn_t vectors
				eval(strcat('sum_m*',x_str,'(1:m)==1')); %summation of state indicator variables for each appliance for previous time period is 1.
				eval(strcat('sum_m*',x_str,'(m+1:2*m)==1')); %summation of state indicator variables for each appliance for next time period is 1.
				eval(strcat(x_str,'(:)>=0')); %constraint that all entries of x vectors must be positive eg greater/equal than 0
				eval(strcat(str1,n_str,'_',t_str, str2)); %creates the Mn_t PSD matrices
				eval(strcat(M_str,'(:)>=0'));
				% eval(strcat(M_str,'(1:m,m+1:2*m)>=0'));

				% strcat(str3,n_str,'_',t_str, str4) %creates the xn_t vectors
				% strcat('sum_m*',x_str,'(1:m)==1') %summation of state indicator variables for each appliance for previous time period is 1.
				% strcat('sum_m*',x_str,'(m+1:2*m)==1') %summation of state indicator variables for each appliance for next time period is 1.
				% strcat(x_str,'(:)>=0') %constraint that all entries of x vectors must be positive eg greater/equal than 0
				% strcat(str1,n_str,'_',t_str, str2) %creates the Mn_t PSD matrices



				eval(strcat('[',M_str,',',x_str,';','transpose(',x_str,'), 1]==semidefinite(M_size+1)'));
				% strcat('[',M_str,',',x_str,';','transpose(',x_str,'), 1]==semidefinite(M_size+1)')

				eval(strcat('d=diag(',M_str,')'));
				sum_m*d(1:m)==1; %diagonals of M matrices sum to 1
				sum_m*d(m+1:2*m)==1; %diagonals of M matrices sum to 1.
				eval(strcat('offdiagonal.*',M_str,'(1:m,1:m)==0'));
				eval(strcat('offdiagonal.*',M_str,'(1+m:2*m,1+m:2*m)==0'));

				if j>1
					eval(strcat(x_prev_str,'(m+1:2*m) == ',x_str,'(1:m)'));
					eval(strcat('d_prev=diag(',M_prev_str,')'));
					d_prev(m+1:2*m) == d(1:m);
				end

				eval(strcat('agg',t_str,'=','agg',t_str,'+mu{i}*x',n_str,'_',t_str,'(1:m)')); %this basically means aggi=rep_A(i,:)*xi where i is the number
				% strcat('agg',t_str,'=','agg',t_str,'+mu{i}*x',n_str,'_',t_str,'(1:m)') %this basically means aggi=rep_A(i,:)*xi where i is the number
				
				% if i==1
				% 	s_str=strcat('s=',x_str); %one at a time constraint for x vectors.
				% 	s2_str=strcat('s2=','sum_m*diag(',M_str,'(1:m,1+m:2*m))'); %one at a time constraint for M matrices.					
				% else
				% 	s_str=strcat(s_str,'+',x_str); %one at a time constraint for x vectors.
				% 	s2_str=strcat(s2_str,'+sum_m*diag(',M_str,'(1:m,1+m:2*m))'); %one at a time constraint for M matrices.					
				% end

			else
				t_str=num2str(t-1);
				strcat('agg',t_str,'=','agg',t_str,'+mu{i}*x',n_str,'_',t_str,'(1+m:2*m)'); %this basically means aggi=rep_A(i,:)*xi where i is the number
				t_str=num2str(j);
			end

		end

		first_term=false;
		eval(s_str);
		eval(s2_str);

		% sum_m*(s(1:m)-s(m+1:2*m))<=  1; %one at a time constraint for x vectors.
		% sum_m*(s(1:m)-s(m+1:2*m))>= -1; %one at a time constraint for x vectors.
		% s2>= n-1; %one at a time constraint for M matrices. 

		eval(strcat('aggregate_hat(j)=agg',t_str));
	end
	toc

	tic
	first_term= 0.5*sum_t*((y-aggregate_hat).^2 * (Params.Obs_COV^-1)); %First term of Obj function of exact MAP. For 1D observation. Need to change for vector observation
	% first_term= 0.5*sum_t*((y-aggregate_hat).^2); %First term of Obj function of exact MAP. For 1D observation. Need to change for vector observation
	toc

	expression second_term;
	second_term_str='second_term= ';
	
	tic
	for j=1:t-1
		t_str=num2str(j);
		for i=1:n
			n_str=num2str(i);
			M_str=strcat('M',n_str,'_',t_str,'(1:m, m+1:2*m)');
			second_term_str=strcat(second_term_str,'-','reshape(',M_str,',1, m^2)*log_A{i}(:)');
		end
	end

	% second_term_str
	eval(second_term_str); %second term of the exact MAP equation.
	toc

	minimize first_term+second_term;
	% minimize first_term;

	tic
	for j=1:t-1
		t_str=num2str(j);
		for i=1:n
			n_str=num2str(i);
			M_str=strcat('M',n_str,'_',t_str); %big M matrix
			x_str=strcat('x',n_str,'_',t_str); %x vectors
			for k=1:m
				m_str=num2str(k);
				eval(strcat(M_str,'(',m_str,',m+1:2*m)*transpose(sum_m)==',x_str,'(',m_str,')'));
				% strcat(M_str,'(',m_str,',m+1:2*m)*transpose(sum_m)==',x_str,'(',m_str,')')
				eval(strcat('sum_m*',M_str,'(1:m,',m_str,'+m)==',x_str,'(',m_str,'+m)'));
				% strcat('sum_m*',M_str,'(1:m,',m_str,'+m)==',x_str,'(',m_str,'+m)')
			end
		end
	end
	toc

cvx_end

second_term
first_term*Params.Obs_COV
errors=[first_term+second_term,first_term,first_term*Params.Obs_COV, second_term];

x_var={};
M_var={};

for j=1:t-1
	t_str=num2str(j);
	for i=1:n 
		n_str=num2str(i);
		M_str=strcat('M',n_str,'_',t_str);
		x_str=strcat('x',n_str,'_',t_str);
		eval(strcat('x_var{i,j}=',x_str,';'));
		eval(strcat('M_var{i,j}=',M_str,';'));
	end
end

% save('Inferred_variables.mat', 'x_var','M_var');

