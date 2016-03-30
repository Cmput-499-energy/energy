function [contiguous_timepoints, timepoints]= extract_contiguousTime(T)
	timepoints=1:length(T);
	lastTime=T(1);
	firstCTime=1;
	contiguous_timepoints=[1,0];
	c_index=1;

	for i=2:length(T)
		if T(i)-lastTime>5
			contiguous_timepoints(c_index,2)=i-1;
			contiguous_timepoints=[contiguous_timepoints;[i,0]];
			c_index=c_index+1;
		end
		lastTime=T(i);
	end

	contiguous_timepoints(end,2)=timepoints(end);
end