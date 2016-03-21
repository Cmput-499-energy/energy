
%%
% Example smoothCh1 = smoothData(ch1, 1,'tLocationScale');
%%
function smoothD = smoothData(data, stdvsFactor, distributionName)

%%% http://www.mathworks.com/help/stats/fitdist.html#inputarg_distname
pd = fitdist(diff(data),distributionName);

smoothD = [];
for i = 1:length(data) - 1,
   if abs(data(i) - data(i+1)) > stdvsFactor*pd.sigma,
       smoothD = [smoothD, data(i)];
   end
end

end