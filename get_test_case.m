function [ test_cases ] = get_test_case( load_segment, seed )
%GET_TEST_CASE GENERATES THE INDECIES OF ALL OF THE TEST SUBSECTIONS.
%ALLOWS OVERLAPING SECTIONS
%   This generates the indecies of the test cases because when runninging
%   against actual data we need to know where they line up in the appliance
%   data and the main data for test purposes

rng(seed)
test_cases = cell(10,1,1);

for i = 1:10
    length(load_segment)
    rand(1) * length(load_segment)
    start = round(rand(1) * length(load_segment))
    test_cases{i} = start:start+499;
end

