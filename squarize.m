function [ state, state_time  ] = squarize( load, time, uthresh, lthresh )
%SQUARIZE Summary of this function goes here
%   Detailed explanation goes here

% Calculate initial state.
% assume it started in off state TODO this is probobaly a bad idea
current_state = 0;
current_time = time(1);
state = [current_state];
state_time = [current_time];
% TODO this should be preallocated

for i = 2:length(time);
    current_load = load(i);
    prev_time = time(i-1);
    current_time = time(i);
    if (current_state == 0)
        if current_load >= uthresh
            state = [state current_state];
            state_time = [state_time prev_time current_time];
            current_state = 1;
            state = [state current_state];
        end
    else %(current_state == 1)
        if current_load <= lthresh
            state = [state current_state];
            state_time = [state_time prev_time current_time];
            current_state = 0;
            state = [state current_state];
        end
    end
end

end

