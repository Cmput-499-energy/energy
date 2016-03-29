function [ state, state_time  ] = squarize( load, time, uthresh, lthresh )
%SQUARIZE Summary of this function goes here
%   Detailed explanation goes here

% Calculate initial state.
% assume it started in off state TODO this is probobaly a bad idea
current_state = 0;
state = [current_state];
state_time = time;
% TODO this should be preallocated

for i = 2:length(time);
    if load(i) >= uthresh,
        state = [state, 1];
        current_state = 1;
    else if load(i) <= lthresh,
        state = [state, 0];
        current_state = 0;
    else
        state = [state, current_state];
    end
end

end

