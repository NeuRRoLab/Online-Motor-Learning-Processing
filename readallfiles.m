clear;
close all;
addpath('.\myfunctions');
online = load("data_ready\online.mat").processeddata;
offline = load("data_ready\offline.mat").processeddata;
%%
nblock = 36;
meanleft = zeros(nblock, 2);
meanleftmicroonline = zeros(nblock, 2);
meanleftmicrooffline = zeros(nblock, 2);
meanlefttotal = zeros(nblock, 2);
meanright = zeros(nblock, 2);
meanrightmicroonline = zeros(nblock, 2);
meanrightmicrooffline = zeros(nblock, 2);
meanrighttotal = zeros(nblock, 2);
semleft = zeros(nblock, 2);
semleftmicroonline = zeros(nblock, 2);
semleftmicrooffline = zeros(nblock, 2);
semlefttotal = zeros(nblock, 2);
semright = zeros(nblock, 2);
semrightmicroonline = zeros(nblock, 2);
semrightmicrooffline = zeros(nblock, 2);
semrighttotal = zeros(nblock, 2);

to_process = {offline, online};
for i = 1:length(to_process)
    T = to_process{i};
%     Tavg =  mean(T.T{:,2:end},1,'omitnan');
%     nblock = 36;
    meanleft(:,i) = mean(T{:,"Blockmeanleft"},'omitnan');
    meanleftmicroonline(:,i) = mean(T{:,"Leftmicroonline"},'omitnan');
    meanleftmicrooffline(:,i) = mean(T{:,"Leftmicrooffline"},'omitnan');
    meanlefttotal(:,i) = mean(T{:,"Lefttotal"},'omitnan');
    meanright(:,i) = mean(T{:,"Blockmeanright"},'omitnan');
    meanrightmicroonline(:,i) = mean(T{:,"Rightmicroonline"},'omitnan');
    meanrightmicrooffline(:,i) = mean(T{:,"Rightmicrooffline"},'omitnan');
    meanrighttotal(:,i) = mean(T{:,"Righttotal"},'omitnan');

    %% SEM computation
%     Tsem = std(T.T{:,2:end},1,'omitnan')/sqrt(size(fullpaths,2));
    sqrt_subjects = sqrt(size(T,1));
    semleft(:,i) = std(T{:,"Blockmeanleft"},'omitnan') / sqrt_subjects; 
    semleftmicroonline(:,i) = std(T{:,"Leftmicroonline"},'omitnan') / sqrt_subjects;
    semleftmicrooffline(:,i) = std(T{:,"Leftmicrooffline"},'omitnan') / sqrt_subjects; 
    semlefttotal(:,i) = std(T{:,"Lefttotal"},'omitnan') / sqrt_subjects;
    semright(:,i) = std(T{:,"Blockmeanright"},'omitnan') / sqrt_subjects;
    semrightmicroonline(:,i) = std(T{:,"Rightmicroonline"},'omitnan') / sqrt_subjects;
    semrightmicrooffline(:,i) = std(T{:,"Rightmicrooffline"},'omitnan') / sqrt_subjects;
    semrighttotal(:,i) = std(T{:,"Righttotal"},'omitnan') / sqrt_subjects;
end

%% Figures
%% Option 1:
figure;
subplot(3,2,1); plot(meanleft,'.','markersize',20);
axis([0,37,0,max(meanleft,[],'all')*1.2]);
title('Left');
legend("In person","Online")

subplot(3,2,2); plot(meanright,'.','markersize',20);
axis([0,37,0,max(meanright,[],'all')*1.2]);
title('Right');
legend("In person","Online")

subplot(3,2,3); plot(meanleftmicroonline(:,1),'b-.','linewidth',2);
hold on
plot(meanleftmicrooffline(1:35,1),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(meanlefttotal(:,1),'k-','linewidth',2);
axis([0,37, min(min(meanrightmicroonline,[],'all'),min(meanleftmicroonline,[],'all'))*1.5, max(max(meanrightmicrooffline,[],'all'),max(meanleftmicrooffline,[],'all'))*1.5]);
title('Left Microscale Learning - In Person');
legend('micro-online','micro-offline','Total');
legend('location', 'southwest');

subplot(3,2,4); plot(meanrightmicroonline(:,1),'b-.','linewidth',2);
hold on
plot(meanrightmicrooffline(1:35,1),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(meanrighttotal(:,1),'k-','linewidth',2);
axis([0,37, min(min(meanrightmicroonline,[],'all'),min(meanleftmicroonline,[],'all'))*1.5, max(max(meanrightmicrooffline,[],'all'),max(meanleftmicrooffline,[],'all'))*1.5]);
title('Right Microscale Learning - In Person');
legend('micro-online','micro-offline','Total');
legend('location', 'southwest');

subplot(3,2,5); plot(meanleftmicroonline(:,2),'b-.','linewidth',2);
hold on
plot(meanleftmicrooffline(1:35,2),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(meanlefttotal(:,2),'k-','linewidth',2);
axis([0,37, min(min(meanrightmicroonline,[],'all'),min(meanleftmicroonline,[],'all'))*1.5, max(max(meanrightmicrooffline,[],'all'),max(meanleftmicrooffline,[],'all'))*1.5]);
title('Left Microscale Learning - Online');
legend('micro-online','micro-offline','Total');
legend('location', 'southwest');

subplot(3,2,6); plot(meanrightmicroonline(:,2),'b-.','linewidth',2);
hold on
plot(meanrightmicrooffline(1:35,2),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(meanrighttotal(:,2),'k-','linewidth',2);
axis([0,37, min(min(meanrightmicroonline,[],'all'),min(meanleftmicroonline,[],'all'))*1.5, max(max(meanrightmicrooffline,[],'all'),max(meanleftmicrooffline,[],'all'))*1.5]);
title('Right Microscale Learning - Online');
legend('micro-online','micro-offline','Total');
legend('location', 'southwest');

%% Option 2: boundedline plot
fig = figure;
a = 1:36;
subplot(3,2,1);
[l,p] = boundedline_mod(a, meanleft, semleft, '-.','transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;
% outlinebounds(l,p);
Ti = title('Left Learning'); Ti.FontSize = 18;
axis([0,37,0,max(max(meanleft,[],'all'),max(meanright,[],'all'))*1.2]);
ax = gca; ax.FontSize = 14;
xticks(0:4:36);
xlabel('Block','FontSize',16);
ylabel('Tapping Speed [Keypress/s]','FontSize',14);
legend('location', 'best');
legend(l,["In person", "Online"])

subplot(3,2,2);
[l,p] = boundedline_mod(a, meanright, semright, '-.','transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;
% outlinebounds(l,p);
Ti = title('Right Learning'); Ti.FontSize = 18;
axis([0,37,0,max(max(meanleft,[],'all'),max(meanright,[],'all'))*1.2]);
ax = gca; ax.FontSize = 14;
xticks(0:4:36);
xlabel('Block','FontSize',16);
ylabel('Tapping Speed [Keypress/s]','FontSize',14);
legend('location', 'best');
legend(l,["In person", "Online"])

subplot(3,2,3);
[l,p] = boundedline_mod(a(1:35), meanleftmicrooffline(1:35,1), semleftmicrooffline(1:35,1), 'r-.', a, meanleftmicroonline(:,1), semleftmicroonline(:,1), '-b.', a, meanlefttotal(:,1), semlefttotal(:,1), '-k.', 'transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;l(3).MarkerSize = 20;
% outlinebounds(l,p);
axis([0,37, min(min(meanrightmicroonline,[],'all'),min(meanleftmicroonline,[],'all'))*2, max(max(meanrightmicrooffline,[],'all'),max(meanleftmicrooffline,[],'all'))*2]);
Ti = title('Mean Left Microscale Learning - In Person'); Ti.FontSize = 18;
lgd = legend(l,'micro-offline','micro-online','Total');lgd.FontSize = 14;
legend('location', 'best');
legend('orientation','horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);yticks([-4:1:4]);
xlabel('Block','FontSize',16);
ylabel('Delta','FontSize',16);

subplot(3,2,4);
[l,p] = boundedline_mod(a(1:35), meanrightmicrooffline(1:35,1), semrightmicrooffline(1:35,1), '-r.', a, meanrightmicroonline(:,1), semrightmicroonline(:,1), '-b.', a, meanrighttotal(:,1), semrighttotal(:,1), '-k.', 'transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;l(3).MarkerSize = 20;
% outlinebounds(l,p);
axis([0,37, min(min(meanrightmicroonline,[],'all'),min(meanleftmicroonline,[],'all'))*2, max(max(meanrightmicrooffline,[],'all'),max(meanleftmicrooffline,[],'all'))*2]);
Ti = title('Mean Right Microscale Learning - In Person'); Ti.FontSize = 18;
lgd = legend(l,'micro-offline','micro-online','Total'); lgd.FontSize = 14;
legend('location', 'best');
legend('orientation','horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);yticks([-4:1:4]);
xlabel('Block','FontSize',16);
ylabel('Delta','FontSize',16);


subplot(3,2,5);
[l,p] = boundedline_mod(a(1:35), meanleftmicrooffline(1:35,2), semleftmicrooffline(1:35,2), 'r-.', a, meanleftmicroonline(:,2), semleftmicroonline(:,2), '-b.', a, meanlefttotal(:,2), semlefttotal(:,2), '-k.', 'transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;l(3).MarkerSize = 20;
% outlinebounds(l,p);
axis([0,37, min(min(meanrightmicroonline,[],'all'),min(meanleftmicroonline,[],'all'))*2, max(max(meanrightmicrooffline,[],'all'),max(meanleftmicrooffline,[],'all'))*2]);
Ti = title('Mean Left Microscale Learning - Online'); Ti.FontSize = 18;
lgd = legend(l,'micro-offline','micro-online','Total');lgd.FontSize = 14;
legend('location', 'best');
legend('orientation','horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);yticks([-4:1:4]);
xlabel('Block','FontSize',16);
ylabel('Delta','FontSize',16);

subplot(3,2,6);
[l,p] = boundedline_mod(a(1:35), meanrightmicrooffline(1:35,2), semrightmicrooffline(1:35,2), '-r.', a, meanrightmicroonline(:,2), semrightmicroonline(:,2), '-b.', a, meanrighttotal(:,2), semrighttotal(:,2), '-k.', 'transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;l(3).MarkerSize = 20;
% outlinebounds(l,p);
axis([0,37, min(min(meanrightmicroonline,[],'all'),min(meanleftmicroonline,[],'all'))*2, max(max(meanrightmicrooffline,[],'all'),max(meanleftmicrooffline,[],'all'))*2]);
Ti = title('Mean Right Microscale Learning - Online'); Ti.FontSize = 18;
lgd = legend(l,'micro-offline','micro-online','Total'); lgd.FontSize = 14;
legend('location', 'best');
legend('orientation','horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);yticks([-4:1:4]);
xlabel('Block','FontSize',16);
ylabel('Delta','FontSize',16);

%%
fig.PaperPositionMode = 'manual';
orient(fig,'landscape')
print(fig,'LandscapePage_KeyPressFigure.pdf','-dpdf')

%% Save data
data.left.meanleft = meanleft;
data.left.microonline = meanleftmicroonline;
data.left.microoffline = meanleftmicrooffline;
data.left.meanlefttotal = meanlefttotal;
data.left.semleft = semleft;
data.left.semmicroonline = semleftmicroonline;
data.left.semmicrooffline = semleftmicrooffline;
data.left.semlefttotal = semlefttotal;

data.right.meanright = meanright;
data.right.microonline = meanrightmicroonline;
data.right.microoffline = meanrightmicrooffline;
data.right.meanrighttotal = meanrighttotal;
data.right.semright = semright;
data.right.semmicroonline = semrightmicroonline;
data.right.semmicrooffline = semrightmicrooffline;
data.right.semrighttotal = semrighttotal;

save('data_ready/all_data','data');
