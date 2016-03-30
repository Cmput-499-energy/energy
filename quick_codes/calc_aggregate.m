function [house_data]= calc_aggregate(house_data)
    for j=1:6
        Agg=0;
        for i=3:house_data(j).numChannels
            Agg = Agg + house_data(j).channel(i).load;
        end
        index=house_data(j).numChannels+1;
        house_data(j).numChannels=index;
        house_data(j).channel(index).load=Agg;
        house_data(j).channel(index).label='unofficial Sum';
        house_data(j).channel(index).dim=house_data(j).channel(index-1).dim;
        house_data(j).channel(index).time=house_data(j).channel(index-1).time;
        house_data(j).channel(index).name='Channel_total';
    end
end