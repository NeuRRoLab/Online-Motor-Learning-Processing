% Script to plot the data from only one subject

clear;
close all;

% Change subject ID and filename as necessary
filename = ".\results\online_corrected.mat";
ID = "WxmBjfZ1mQeOcJ65";

% Load data
data = load(filename).processeddata;
subj_data = data(strcmp(data.SubjectID, ID), :);

%% Plot data
figure;
sgtitle(strcat("Subject ", ID))
subplot(2, 2, 1); plot(subj_data.Blockmeanleft, '.', 'markersize', 20);
axis([0, 37, 0, max(max(subj_data.Blockmeanleft), max(subj_data.Blockmeanright)) * 1.2]);
title('Left');
ylabel("Tapping speed (keypr./s)")
xticks(1:5:36)
xlabel("Block")

subplot(2, 2, 2); plot(subj_data.Blockmeanright, '.', 'markersize', 20);
axis([0, 37, 0, max(max(subj_data.Blockmeanleft), max(subj_data.Blockmeanright)) * 1.2]);
title('Right');
ylabel("Tapping speed (keypr./s)")
xticks(1:5:36)
xlabel("Block")

subplot(2, 2, 3); plot(subj_data.Leftmicroonline, 'b-.', 'linewidth', 2);
hold on
plot(subj_data.Leftmicrooffline(1:35), 'r-.', 'linewidth', 2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(subj_data.Lefttotal, 'k-', 'linewidth', 2);
axis([0, 37, min(min(subj_data.Rightmicroonline), min(subj_data.Leftmicroonline)) * 1.5, max(max(subj_data.Leftmicrooffline), max(subj_data.Rightmicrooffline)) * 1.5]);
title('Left Microscale Learning');
legend('micro-online', 'micro-offline', 'Total');
legend('location', 'southwest');
ylabel("Delta");
xticks(1:5:36)

subplot(2, 2, 4); plot(subj_data.Rightmicroonline, 'b-.', 'linewidth', 2);
hold on
plot(subj_data.Rightmicrooffline(1:35), 'r-.', 'linewidth', 2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(subj_data.Righttotal, 'k-', 'linewidth', 2);
axis([0, 37, min(min(subj_data.Rightmicroonline), min(subj_data.Leftmicroonline)) * 1.5, max(max(subj_data.Leftmicrooffline), max(subj_data.Rightmicrooffline)) * 1.5]);
title('Right Microscale Learning');
legend('micro-online', 'micro-offline', 'Total');
legend('location', 'southwest');
ylabel("Delta");
xticks(1:5:36)
