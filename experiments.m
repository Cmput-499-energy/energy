folds = 20;
ci_f = tinv(0.975, folds);
T = 500;
n = 4;
N = 4;
m = 4;


% varying # of HMMs
for N0 = 2:10,
  res{N0} = cell(folds,7);
  for i=1:folds,
    disp([num2str(N0) ' ' num2str(i)]);
    [res{N0}{i,:}] = test_afamap0(T, n, N0, m, i);
  end
end
save results.mat;


for N0 = 2:10,
  X = cell2mat(res{N0});
  perfs = sqrt(X(:,1:6)./repmat(X(:,7),1,6));
  perfs_mean(N0,:) = mean(perfs)
  perfs_ci(N0,:) = ci_f*std(perfs,1)/sqrt(folds);
end
hFig = figure(1);
clf;
hold on;
set(hFig, 'Position', [100 100 410 340])
errorbar(2:10, perfs_mean(2:10,1), perfs_ci(2:10,1), 'rx-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,2), perfs_ci(2:10,2), 'bo-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,5), perfs_ci(2:10,5), 'g+-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,3), perfs_ci(2:10,3), 'm*-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,4), perfs_ci(2:10,4), 'cs-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,6), perfs_ci(2:10,6), 'kd-', 'LineWidth', 1);
xlim([2 10]);
ylim([0 0.9]);
xlabel('Number of HMMs');
ylabel('Normalized Diaggregation Error');
legend('Exact MAP', 'AFAMAP', 'Structured Mean Field', 'AFAMAP, no diff', 'AFAMAP, no add', 'Prior', 'Location', 'NorthWest');



% varying # of states
for m0 = 2,
  res_m{m0} = cell(folds,7);
  for i=1:folds,
    disp([num2str(m0) ' ' num2str(i)]);
    [res_m{m0}{i,:}] = test_afamap0(T, n, N, m0, i);
  end
end
save results.mat;

for N0 = 2:10,
  X = cell2mat(res_m{N0});
  perfs = sqrt(X(:,1:6)./repmat(X(:,7),1,6));
  perfs_mean(N0,:) = mean(perfs)
  perfs_ci(N0,:) = ci_f*std(perfs,1)/sqrt(folds);
end
hFig = figure(1);
clf;
hold on;
set(hFig, 'Position', [100 100 410 340])
errorbar(2:10, perfs_mean(2:10,1), perfs_ci(2:10,1), 'rx-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,2), perfs_ci(2:10,2), 'bo-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,5), perfs_ci(2:10,5), 'g+-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,3), perfs_ci(2:10,3), 'm*-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,4), perfs_ci(2:10,4), 'cs-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,6), perfs_ci(2:10,6), 'kd-', 'LineWidth', 1);
xlim([2 10]);
ylim([0 0.9]);
xlabel('Number of States');
ylabel('Normalized Diaggregation Error');
legend('Exact MAP', 'AFAMAP', 'Structured Mean Field', 'AFAMAP, no diff', 'AFAMAP, no add', 'Prior', 'Location', 'NorthWest');




% varying output dimensionality
for n0 = 1:10,
  res_n{n0} = cell(folds,7);
  for i=1:folds,
    disp([num2str(n0) ' ' num2str(i)]);
    [res_n{n0}{i,:}] = test_afamap0(T, n0, N, m, i);
  end
end
save results.mat;

for N0 = 1:10,
  X = cell2mat(res_n{N0});
  perfs = sqrt(X(:,1:6)./repmat(X(:,7),1,6));
  perfs_mean(N0,:) = mean(perfs)
  perfs_ci(N0,:) = ci_f*std(perfs,1)/sqrt(folds);
end
hFig = figure(1);
clf;
hold on;
set(hFig, 'Position', [100 100 410 340])
errorbar(2:10, perfs_mean(2:10,1), perfs_ci(2:10,1), 'rx-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,2), perfs_ci(2:10,2), 'bo-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,5), perfs_ci(2:10,5), 'g+-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,3), perfs_ci(2:10,3), 'm*-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,4), perfs_ci(2:10,4), 'cs-', 'LineWidth', 1);
errorbar(2:10, perfs_mean(2:10,6), perfs_ci(2:10,6), 'kd-', 'LineWidth', 1);
xlim([2 10]);
ylim([0 0.9]);
xlabel('Dimensionality of Output');
ylabel('Normalized Diaggregation Error');
legend('Exact MAP', 'AFAMAP', 'Structured Mean Field', 'AFAMAP, no diff', 'AFAMAP, no add', 'Prior', 'Location', 'NorthWest');




% Total variation component
for t=0:10,
  res_tv{t+1} = cell(folds, 6);
  for i=1:folds,
    disp([num2str(t) ' ' num2str(i)]);
    [res_tv{t+1}{i,:}] = test_afamap1(T, n, N, m, i, t*0.01);
  end
end
save results_tv.mat;

clear perfs_mean; clear perfs_ci;
for t = 1:11,
  X = cell2mat(res_tv{t});
  perfs = sqrt(X(:,1:5)./repmat(X(:,6),1,5));
  perfs_mean(t,:) = mean(perfs)
  perfs_ci(t,:) = ci_f*std(perfs,1)/sqrt(folds);
end
hFig = figure(1);
clf;
hold on;
set(hFig, 'Position', [100 100 410 340])
errorbar(0:0.01:0.1, perfs_mean(1:11,2), perfs_ci(1:11,2), 'g+-','LineWidth',1);
errorbar(0:0.01:0.1, perfs_mean(1:11,1), perfs_ci(1:11,1), 'm*-','LineWidth',1);
errorbar(0:0.01:0.1, perfs_mean(1:11,4), perfs_ci(1:11,4), 'bo-','LineWidth',1);
errorbar(0:0.01:0.1, perfs_mean(1:11,3), perfs_ci(1:11,3), 'rx-','LineWidth',1);
errorbar(0:0.01:0.1, perfs_mean(1:11,5), perfs_ci(1:11,5), 'kd-','LineWidth',1);
xlim([0 0.1]);
ylim([0 0.9]);
xlabel('Std Dev. of Random Walk Noise');
ylabel('Normalized Disaggregation Error');
legend('AFAMAP', 'Exact MAP', 'AFAMAP, Robust', 'Exact Map, Robust', 'Prior', 'Location', 'NorthWest');


  
  