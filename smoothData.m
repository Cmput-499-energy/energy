%%
% Example smoothCh1 = smoothData(ch1, 1,'tLocationScale');
%%
function [smoothD, time, highThresh, lowThresh] = smoothData(data, timeArr, stdvsFactor, distributionName)

%%% http://www.mathworks.com/help/stats/fitdist.html#inputarg_distname
pd = fitdist(diff(data),distributionName);

time = [timeArr(1)];
smoothD = [data(1)];

currentVal = data(1);
for i = 2:2:length(data) - 1,
   if abs(currentVal - data(i+1)) > stdvsFactor*pd.sigma,
         if time(end) == timeArr(i-1)
            smoothD = [smoothD, data(i), data(i+1)];
            time = [time, timeArr(i), timeArr(i+1)];            
         else
            smoothD = [smoothD, smoothD(end), data(i), data(i+1)];
            time = [time, timeArr(i-1), timeArr(i), timeArr(i+1)]; 
         end
         currentVal = data(i+1);    
   end
   currentVal = data(i+1);
end
smoothD = [smoothD, data(end)];
time = [time, timeArr(end)];


pd = fitdist(smoothD','Normal');
lowThresh = pd.mu;
peaks = [];
for i = 1:length(smoothD),
    if smoothD(i) > pd.mu,
        peaks = [peaks, smoothD(i)];
    end
end

pd = fitdist(peaks','Normal');

highThresh = max(pd.mu - pd.sigma, lowThresh);

end
