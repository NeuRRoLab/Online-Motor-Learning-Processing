clear all;
close all;
addpath(genpath('C:\Users\mouli\OneDrive - Michigan Medicine\Desktop\Things to Add in Dropbox\boundedline-pkg-master\boundedline-pkg-master'))
files = dir('C:\Users\mouli\OneDrive - Michigan Medicine\Desktop\Things to Add in Dropbox\Matlab course\Course Materials\Other Programs\keypressdata\Online\*.xlsx');
fullpaths = fullfile({files.folder}, {files.name});
for i = 1:size(fullpaths,2)
   T{i,:} = readtable(fullpaths{i},'PreserveVariableNames',true);
end
T = cell2table(T);
Tavg =  mean(T.T{:,2:end},1,'omitnan');
nblock = 36;
meanleft = Tavg(1:nblock); 
meanleftmicroonline = Tavg(1+nblock:2*nblock); 
meanleftmicrooffline = Tavg((1+2*nblock):3*nblock); 
meanlefttotal = Tavg((1+3*nblock):4*nblock);
meanright = Tavg((1+4*nblock):5*nblock);
meanrightmicroonline = Tavg((1+5*nblock):6*nblock);
meanrightmicrooffline = Tavg((1+6*nblock):7*nblock);
meanrighttotal = Tavg((1+7*nblock):8*nblock);

%% SEM computation
Tsem = std(T.T{:,2:end},1,'omitnan')/sqrt(size(fullpaths,2));
semleft = Tsem(1:nblock); 
semleftmicroonline = Tsem(1+nblock:2*nblock); 
semleftmicrooffline = Tsem((1+2*nblock):3*nblock); 
semlefttotal = Tsem((1+3*nblock):4*nblock);
semright = Tsem((1+4*nblock):5*nblock);
semrightmicroonline = Tsem((1+5*nblock):6*nblock);
semrightmicrooffline = Tsem((1+6*nblock):7*nblock);
semrighttotal = Tsem((1+7*nblock):8*nblock);

%% Figures
subplot(2,2,1); plot(meanleft,'b.','markersize',20);
axis([0,37,0,max(meanleft)*1.2]);
title('Left');
subplot(2,2,2); plot(meanright,'r.','markersize',20);
axis([0,37,0,max(meanright)*1.2]);
title('Right');

subplot(2,2,3); plot(meanleftmicroonline,'b-.','linewidth',2);
hold on
plot(meanleftmicrooffline(1:35),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(meanlefttotal,'k-','linewidth',2);
axis([0,37, min(min(meanrightmicroonline),min(meanleftmicroonline))*1.5, max(max(meanrightmicrooffline),max(meanleftmicrooffline))*1.5]);
title('Mean Left Microscale Learning');
legend('micro-online','micro-offline','Total');
legend('location', 'southwest');

subplot(2,2,4); plot(meanrightmicroonline,'b-.','linewidth',2);
hold on
plot(meanrightmicrooffline(1:35),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
hold on
plot(meanrighttotal,'k-','linewidth',2);
axis([0,37, min(min(meanrightmicroonline),min(meanleftmicroonline))*1.5, max(max(meanrightmicrooffline),max(meanleftmicrooffline))*1.5]);
title('Right Microscale Learning');
legend('micro-online','micro-offline','Total');
legend('location', 'southwest');
%% boundedline plot
fig = figure;
a = [1:1:36];
subplot(2,2,1);
[l,p] = boundedline(a, meanleft, semleft, '-b.','transparency',0.1);
l.MarkerSize = 20;
% outlinebounds(l,p);
Ti = title('Left Learning'); Ti.FontSize = 18;
axis([0,37,0,max(max(meanleft),max(meanright))*1.2]);
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);
xlabel('Block','FontSize',16);
ylabel('Tapping Speed [Keypress/s]','FontSize',16);

subplot(2,2,2);
[l,p] = boundedline(a, meanright, semright, '-r.','transparency',0.1);
l.MarkerSize = 20;
% outlinebounds(l,p);
Ti = title('Right Learning'); Ti.FontSize = 18;
axis([0,37,0,max(max(meanleft),max(meanright))*1.2]);
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);
xlabel('Block','FontSize',16);
ylabel('Tapping Speed [Keypress/s]','FontSize',16);

subplot(2,2,3);
[l,p] = boundedline(a(1:35), meanleftmicrooffline(1:35), semleftmicrooffline(1:35), '-r.', a, meanleftmicroonline, semleftmicroonline, '-b.', a, meanlefttotal, semlefttotal, '-k.', 'transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;l(3).MarkerSize = 20;
% outlinebounds(l,p);
axis([0,37, min(min(meanrightmicroonline),min(meanleftmicroonline))*2, max(max(meanrightmicrooffline),max(meanleftmicrooffline))*2]);
Ti = title('Mean Left Microscale Learning'); Ti.FontSize = 18;
lgd = legend('micro-offline','micro-online','Total');lgd.FontSize = 14;
legend('location', 'best');
legend('orientation','horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);yticks([-4:1:4]);
xlabel('Block','FontSize',16);
ylabel('Delta','FontSize',16);

subplot(2,2,4);
[l,p] = boundedline(a(1:35), meanrightmicrooffline(1:35), semrightmicrooffline(1:35), '-r.', a, meanrightmicroonline, semrightmicroonline, '-b.', a, meanrighttotal, semrighttotal, '-k.', 'transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;l(3).MarkerSize = 20;
% outlinebounds(l,p);
axis([0,37, min(min(meanrightmicroonline),min(meanleftmicroonline))*2, max(max(meanrightmicrooffline),max(meanleftmicrooffline))*2]);
Ti = title('Mean Right Microscale Learning'); Ti.FontSize = 18;
lgd = legend('micro-offline','micro-online','Total'); lgd.FontSize = 14;
legend('location', 'best');
legend('orientation','horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);yticks([-4:1:4]);
xlabel('Block','FontSize',16);
ylabel('Delta','FontSize',16);

fig.PaperPositionMode = 'manual';
orient(fig,'landscape')
print(fig,'LandscapePage_KeyPressFigure.pdf','-dpdf')

%% 

