function [] = make_boxplot( house )
%MAKE_BOXPLOT takes a house data in a makes a boxplot of it separating out
%the main data
% House data should be a struct in the format bellow
% house = struct('numChannels', 0, 'channel', [], 'name', '');
% channel = struct('name', '', 'dim', 0, 'time', [], 'load', [], 'label','');
    subplot(1,house.numChannels,[1,2])
    loads = [house.channel(1).load house.channel(2).load];
    labels = [house.channel(1).label; house.channel(2).label];
    boxplot(loads, 'Labels', labels, 'labelorientation','inline');
    title([house.name, ' mains']);
    subplot(1,house.numChannels,3:house.numChannels);
    loads = [house.channel(3:house.numChannels).load];
    labels = [house.channel(3:house.numChannels).label];
    boxplot(loads, 'Labels', labels,'labelorientation','inline');
    title([house.name, ' appliances']);
end

