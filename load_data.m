function [ data ] = load_data(data_location)
%LOAD_DATA Loads the low frequency data from 
%   Loads the data into a structure matching the ones bellow
% data = struct('numHouses', 0, 'house',[]);
% house = struct('numChannels', 0, 'channel', [], 'name', '');
% channel = struct('name', '', 'dim', 0, 'time', [], 'load', [], 'label','');
    data = struct('numHouses', 0, 'house',[]);
    for i = 1:6
        % For debuging purposes can be removed
        disp(['loading house ', num2str(i), '...'])
%         base = 'low_freq/';
        base=data_location;
        house = struct('numChannels', 0, 'channel', [], 'name', '');
        house.name = strcat('house_', num2str(i));
        directory = dir(strcat(base, house.name, '/'));
        for f = 1:size(directory,1)-2-1 %For the ./ ../ and label files
            channel = struct('name', strcat('channel_', num2str(f), '.dat'), 'dim', 0, 'time', [], 'load', [], 'label','');
            if exist(strcat(base, house.name,'/' ,channel.name), 'file') ~= 2
                break
            end
            d = importdata(strcat(base, house.name,'/' ,channel.name));
            channel.time = d(:,1);
            channel.load = d(:,2);
            channel.dim = size(d(:,2),1);
            house.numChannels = house.numChannels + 1;
            house.channel = horzcat(house.channel, channel);
        end
        filename= strcat(base, house.name,'/' , 'labels.dat');
        delimiterIn = ' ';
        labels = importdata(filename,delimiterIn);
        for n = 1:size(labels)
            a = strsplit(char(labels(n)));
            house.channel(n).label = a(2);
        end
        data.numHouses = data.numHouses + 1;
        data.house = horzcat(data.house, house);
    end

end

