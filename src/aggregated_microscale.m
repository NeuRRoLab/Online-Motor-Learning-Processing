% Plots aggregated microscale learning across groups

clear;
close all;
addpath('.\include');
online = load("results\online.mat").processeddata;
offline = load("results\offline.mat").processeddata;
all_data = [online; offline];

%% Excluding subject that performed it too fast (Peter)
% grand_mean = mean(all_data.Blockmeanleft, 'all')
% grand_std = std(all_data.Blockmeanleft, 0, 'all')
% peters_mean = mean(all_data(strcmp(all_data.SubjectID, "IKLgXSxdg4WBhLQC"), :).Blockmeanleft)
% % Peter is 2.54 standard deviations away from grand mean when aggregating all data for the left.
% % It is 3.03 std dev away from grand mean when aggregating all data for the
% % right.
% quantile(all_data.Blockmeanleft, 0.75, 'all') + 1.5 * iqr(all_data.Blockmeanleft, 'all')
% % Peter is an outlier by Tukey's fences criterion

%% Microscale learning
meanleftmicrooffline = mean(all_data.Leftmicrooffline);
meanleftmicroonline = mean(all_data.Leftmicroonline);
meanlefttotal = mean(all_data.Lefttotal);
semleftmicrooffline = std(all_data.Leftmicrooffline) / sqrt(height(all_data));
semleftmicroonline = std(all_data.Leftmicroonline) / sqrt(height(all_data));
semlefttotal = std(all_data.Lefttotal) / sqrt(height(all_data));

meanrightmicrooffline = mean(all_data.Rightmicrooffline);
meanrightmicroonline = mean(all_data.Rightmicroonline);
meanrighttotal = mean(all_data.Righttotal);
semrightmicrooffline = std(all_data.Rightmicrooffline) / sqrt(height(all_data));
semrightmicroonline = std(all_data.Rightmicroonline) / sqrt(height(all_data));
semrighttotal = std(all_data.Righttotal) / sqrt(height(all_data));

figure
% Aggregated figure for left hand
a = 1:36;
% Bounded line plot
[l, p] = boundedline_mod(a(2:end), meanleftmicrooffline(2:end), semleftmicrooffline(2:end), 'r-.', a, meanleftmicroonline, semleftmicroonline, '-b.', a, meanlefttotal, semlefttotal, '-k.', 'transparency', 0.1);
l(1).MarkerSize = 20; l(2).MarkerSize = 20; l(3).MarkerSize = 20;
% outlinebounds(l,p);
axis([0, 37, min(min(meanrightmicroonline, [], 'all'), min(meanleftmicrooffline, [], 'all')) * 2, max(max(meanrightmicroonline, [], 'all'), max(meanleftmicrooffline, [], 'all')) * 2]);
Ti = title('Aggregated Mean Left Microscale Learning'); Ti.FontSize = 18;
lgd = legend(l, 'micro-offline', 'micro-online', 'Total'); lgd.FontSize = 14;
legend('location', 'best');
legend('orientation', 'horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]); yticks([-4:1:4]);
xlabel('Block', 'FontSize', 16);
ylabel('Delta', 'FontSize', 16);

figure
% Aggregated figure for left hand
a = 1:36;
[l, p] = boundedline_mod(a(2:end), meanrightmicrooffline(2:end), semrightmicrooffline(2:end), 'r-.', a, meanrightmicroonline, semrightmicroonline, '-b.', a, meanrighttotal, semrighttotal, '-k.', 'transparency', 0.1);
l(1).MarkerSize = 20; l(2).MarkerSize = 20; l(3).MarkerSize = 20;
% outlinebounds(l,p);
axis([0, 37, min(min(meanrightmicroonline, [], 'all'), min(meanleftmicrooffline, [], 'all')) * 2, max(max(meanrightmicroonline, [], 'all'), max(meanleftmicrooffline, [], 'all')) * 2]);
Ti = title('Aggregated Mean Right Microscale Learning'); Ti.FontSize = 18;
lgd = legend(l, 'micro-offline', 'micro-online', 'Total'); lgd.FontSize = 14;
legend('location', 'best');
legend('orientation', 'horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]); yticks([-4:1:4]);
xlabel('Block', 'FontSize', 16);
ylabel('Delta', 'FontSize', 16);
