clc
clear all
close all
%% 
addpath('C:\Users\mouli\OneDrive - Michigan Medicine\Desktop\Things to Add in Dropbox\Matlab course\Course Materials\Other Programs\myfunctions');
data = xlsread('mean_tapping_speed.xlsx');
meanleft1 = data(:,1);
semleft1 = data(:,2);
meanright1 = data(:,3);
semright1 = data(:,4);
meanleft2 = data(:,5);
semleft2 = data(:,6);
meanright2 = data(:,7);
semright2 = data(:,8);
%% 
fig = figure;
a = [1:1:36];
subplot(1,2,1);
[l,p] = boundedline(a, meanleft1, semleft1, '-r.', a, meanleft2, semleft2, '-b.','transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;
% outlinebounds(l,p);
axis([0,37, 0, max(max(meanleft1),max(meanleft2))*1.2]);
Ti = title('Mean Left Learning'); Ti.FontSize = 18;
lgd = legend('Online','In-person');lgd.FontSize = 14;
legend('location', 'northwest');
legend('orientation','horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);yticks([0:1:6]);
xlabel('Block','FontSize',16);
ylabel('Tapping Speed [Keypress/s]','FontSize',16);
%% 
subplot(1,2,2);
[l,p] = boundedline(a, meanright1, semright1, '-r.', a, meanright2, semright2, '-b.','transparency',0.1);
l(1).MarkerSize = 20;l(2).MarkerSize = 20;
% outlinebounds(l,p);
axis([0,37, 0, max(max(meanright1),max(meanright2))*1.2]);
Ti = title('Mean Right Learning'); Ti.FontSize = 18;
lgd = legend('Online','In-person');lgd.FontSize = 14;
legend('location', 'northwest');
legend('orientation','horizontal');
ax = gca; ax.FontSize = 14;
xticks([0:4:36]);yticks([0:1:6]);
xlabel('Block','FontSize',16);
ylabel('Tapping Speed [Keypress/s]','FontSize',16);

