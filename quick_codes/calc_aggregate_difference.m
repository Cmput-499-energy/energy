function [total_agg, aggregate_data, aggregate_data2, estimated_aggregate_data]=calc_aggregate_difference(house_data,channels)
	
	aggregate_data=[house_data.channel(1).time, house_data.channel(1).load];
    aggregate_data2=[house_data.channel(2).time, house_data.channel(2).load];
	total_agg=aggregate_data(:,2)+aggregate_data2(:,2);
    house_T_points=house_data.channel(3).time;

    [~, houseI, j]=intersect(house_T_points, aggregate_data(:,1), 'rows');
    
    aggregate_data=aggregate_data(j,:);
    aggregate_data2=aggregate_data2(j,:);
    total_agg=total_agg(j);
	estimated_aggregate_data=0;

	for i=3:house_data.numChannels
		estimated_aggregate_data= estimated_aggregate_data+house_data.channel(i).load(houseI);
    end
%     estimated_aggregate_data=estimated_aggregate_data+aggregate_data2(:,2);
%     estimated_aggregate_data=estimated_aggregate_data+aggregate_data2(:,2);
%     size(estimated_aggregate_data)
%     estimated_aggregate_data(1000)
%     aggregate_data(1000,2)
%     total_agg(1000)
	Error=mean(abs(estimated_aggregate_data-total_agg));
    Error/mean(estimated_aggregate_data) * 100
% 	Error=0;
end

