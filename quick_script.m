[smoothed, smoothed_time, uthresh, lthresh] = smoothData(h.channel(chan).load, h.channel(chan).time, 1, 'Normal');
[square, square_time] = squarize(smoothed, smoothed_time, uthresh, lthresh);
figure
subplot(1,3,1)
plot(h.channel(chan).time, h.channel(chan).load);
%title('Original');
subplot(1,3,2)
plot(smoothed_time, smoothed);
%title('Smoothed');
subplot(1,3,3)
plot(square_time, square);
%title('Squarized');