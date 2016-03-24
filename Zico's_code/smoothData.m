
%%
% Example smoothCh1 = smoothData(ch1, 1,'tLocationScale');
%%
function smoothD, time, highThresh, lowThresh = smoothData(data, stdvsFactor, distributionName)

%%% http://www.mathworks.com/help/stats/fitdist.html#inputarg_distname
pd = fitdist(diff(data),distributionName);

time = [];
smoothD = [];
for i = 1:length(data) - 1,
   if abs(data(i) - data(i+1)) > stdvsFactor*pd.sigma,
       smoothD = [smoothD, data(i)];
       time = [time, i];
   end
end

pd = fitdist(diff(smoothD),'Normal');
highThresh = pd.mu + pd.sigma;
lowThres = pd.mu - pd.sigma

end