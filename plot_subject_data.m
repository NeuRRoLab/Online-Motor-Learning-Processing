clear;

% Change subject index and filename as necessary
subj_index = 3;
filename = ".\data_ready\offline.mat";

% Load data
data = load(filename).processeddata;
ID = char(data.SubjectID(subj_index));
subj_data = data(strcmp(data.SubjectID,ID),:);
%% Plot data
figure;
sgtitle(strcat("Subject ",ID))
subplot(2,2,1); plot(subj_data.Blockmeanleft,'.','markersize',20);
axis([0,37,0,max(max(subj_data.Blockmeanleft),max(subj_data.Blockmeanright))*1.2]);
title('Left');
ylabel("Tapping speed (keypr./s)")
xticks(1:5:36)
xlabel("Block")

subplot(2,2,2); plot(subj_data.Blockmeanright,'.','markersize',20);
axis([0,37,0,max(max(subj_data.Blockmeanleft),max(subj_data.Blockmeanright))*1.2]);
title('Right');
ylabel("Tapping speed (keypr./s)")
xticks(1:5:36)
xlabel("Block")

subplot(2,2,3); plot(subj_data.Leftmicroonline,'b-.','linewidth',2);
hold on
plot(subj_data.Leftmicrooffline(1:35),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(subj_data.Lefttotal,'k-','linewidth',2);
axis([0,37, min(min(subj_data.Rightmicroonline),min(subj_data.Leftmicroonline))*1.5, max(max(subj_data.Leftmicrooffline),max(subj_data.Rightmicrooffline))*1.5]);
title('Left Microscale Learning');
legend('micro-online','micro-offline','Total');
legend('location', 'southwest');
ylabel("Delta");
xticks(1:5:36)

subplot(2,2,4); plot(subj_data.Rightmicroonline,'b-.','linewidth',2);
hold on
plot(subj_data.Rightmicrooffline(1:35),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(subj_data.Righttotal,'k-','linewidth',2);
axis([0,37, min(min(subj_data.Rightmicroonline),min(subj_data.Leftmicroonline))*1.5, max(max(subj_data.Leftmicrooffline),max(subj_data.Rightmicrooffline))*1.5]);
title('Right Microscale Learning');
legend('micro-online','micro-offline','Total');
legend('location', 'southwest');
ylabel("Delta");
xticks(1:5:36)


% %% Plot data
% figure; 
% subplot(2,2,1); h1 = stackedplot(subj_left{:,tapping_speed_column},'.','markersize',20);
% ax1 = findobj(h1.NodeChildren, 'Type','Axes');
% set([ax1.YLabel],'Rotation',90,'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
% title(ID);
% subplot(2,2,2); h2 = stackedplot(subj_right{:,tapping_speed_column},'.','markersize',20);
% ax2 = findobj(h2.NodeChildren, 'Type','Axes');
% set([ax2.YLabel],'Rotation',90,'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
% title(ID);
% subplot(2,2,3); plot(blockmeanleft,'b.','markersize',20);
% axis([0,nblock+1,0,nanmax([blockmeanleft;0.1])*1.2]);
% title('Left');
% subplot(2,2,4); plot(blockmeanright,'r.','markersize',20);
% axis([0,nblock+1,0,nanmax([blockmeanright;0.1])*1.2]);
% title('Right');
% 
% figure; 
% subplot(2,1,1); plot(leftmicroonline,'b-.','linewidth',2);
% hold on
% plot(leftmicrooffline(1:nblock-1),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
% hold on
% plot(leftlearning,'k-','linewidth',2);
% axis([0,nblock+1, min(min(rightmicroonline),min(leftmicroonline))*1.5, max(max(rightmicrooffline),max(leftmicrooffline)) * 1.5]);
% title('Left Microscale Learning');
% legend('micro-online','micro-offline','Total');
% legend('location', 'northeastoutside');
% 
% subplot(2,1,2); plot(rightmicroonline,'b-.','linewidth',2);
% hold on
% plot(rightmicrooffline(1:nblock-1),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
% hold on
% plot(rightlearning,'k-','linewidth',2);
% axis([0,nblock+1, min(min(rightmicroonline),min(leftmicroonline))*1.5, max(max(rightmicrooffline),max(leftmicrooffline)) * 1.5]);
% title('Right Microscale Learning');
% legend('micro-online','micro-offline','Total');
% legend('location', 'northeastoutside');