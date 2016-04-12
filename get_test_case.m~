function [ test_cases ] = get_test_case(number_of_segments, load_segment, seed , offset)
%GET_TEST_CASE GENERATES THE INDECIES OF ALL OF THE TEST SUBSECTIONS.
%ALLOWS OVERLAPING SECTIONS
%   This generates the indecies of the test cases because when runninging
%   against actual data we need to know where they line up in the appliance
%   data and the main data for test purposes

rng(seed)
test_cases = cell(number_of_segments,1,1);

for i = 1:number_of_segments
    % length(load_segment)
    % rand(1) * length(load_segment)
    start = round(rand(1) * length(load_segment));
    test_cases{i}.loads = load_segment(start:start+499);
    test_cases{i}.relative_timePoints = [start, start+499];
    test_cases{i}.absolute_timePoints = [start, start+499] + double(offset) -1;
end

test_cases_18=test_cases;
save('test_data_18.mat', 'test_cases_18');

