h = data.house(1);
[smoothed, smoothed_time, uthresh, lthresh] = smoothData(h.channel(3).load, h.channel(3).time, 1, 'Normal');
[square, square_time] = squarize(smoothed, smoothed_time, uthresh, lthresh);
figure
subplot(1,3,1)
plot(h.channel(3).time, h.channel(3).load);
title('Original');
subplot(1,3,2)
plot(smoothed_time, smoothed);
title('Smoothed');
subplot(1,3,3)
plot(square_time, square);
title('Squarized');