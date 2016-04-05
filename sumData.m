function [sum_data]=sumData(house, channels)
    sum_data=0;
    for i=channels
        sum_data=sum_data+house.channel(i).load;
    end

end