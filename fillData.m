function [data]= fillData(s,s_time,timePoints_no)
	data=zeros(1,timePoints_no);
	data(1,1:s_time(2)-1)=s(1);

	for i=2:length(s)-1
		data(1,s_time(i):s_time(i+1)-1)=s(i);
		% prevTime=s_time(i);
	end

	data(1,s_time(end):end)=s(end);
end