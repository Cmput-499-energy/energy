function [ house ] = gen_mini_house( orig_house, num_channels, seed )
%GEN_MINI_HOUSE Generates a small house based of input house
%   Detailed explanation goes here
if nargin > 2
    rng(seed);
end
house = struct('numChannels', 0, 'channel', [], 'name', '');
agr = orig_house.channel(3);
agr.load = agr.load * 0;
agr.label = 'mains';
agr.name = 'min_channel_1.dat';
order = randperm(orig_house.numChannels-2)+2;
order = order(1:num_channels);
for c = order
    agr.load = agr.load + orig_house.channel(c).load;
    house.channel = horzcat(house.channel, orig_house.channel(c));
end
house.channel = horzcat(agr, agr, house.channel);
house.name = strcat('house_', char(order+65));
house.numChannels = num_channels + 2;
end

