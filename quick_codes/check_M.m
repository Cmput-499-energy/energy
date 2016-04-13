load('Inferred_variables.mat');

zeros16=zeros(4,4);
total=0;
sum_M=0;
% length(M_var)
[s1,s2]=size(M_var);
temp=[1,0; 0,0];
refMat=[temp, temp; temp, temp];
sum2=0;
sum_state1=0;
sum_state2=0;
for i=1:s1
	for j=1:s2
		sum2=sum2+sum(sum((refMat-M_var{i,j})));
		sum_M=sum_M+sum(sum(M_var{i,j}));
		%sum(sum(M_var{i}>=zeros16));
		total=total+sum(sum(M_var{i,j}>=zeros16));
		sum_state1=sum_state1+x_var{i,j}(3);
		sum_state2=sum_state2+x_var{i,j}(4);
	end
end

total
sum_M
sum_state1
sum_state2