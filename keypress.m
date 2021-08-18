clc
clear;
close all;
%% 
addpath('.\myfunctions');
% data = readtable('.\data\bonstrup_processed_C6XN.csv');
data = readtable('.\data\processed_experiment_C6XN.csv');
tapping_speed_column = 'tapping_speed_mean';
% tapping_speed_column = 'tapping_speed_mean_aggregated';
subjectcodes = unique(data.subject_code);
nblock = 36;
true = 1; false = 0;
saveoutput = true;
data.subjectid = categorical(data.subject_code);
data.subject_code = categorical(data.subject_code);
data.correcttrial = categorical(data.correct_trial);
data.correct_trial = strcmp(data.correct_trial,'True');
experiment_code = char(unique(data.experiment_code));

blockmeanleft = zeros(length(subjectcodes),nblock);
blockmeanright = zeros(length(subjectcodes),nblock);
leftmicroonline = zeros(length(subjectcodes),nblock);
leftmicrooffline = zeros(length(subjectcodes),nblock);
rightmicroonline = zeros(length(subjectcodes),nblock);
rightmicrooffline = zeros(length(subjectcodes),nblock);
%% Go through each subject
for j = 1:length(subjectcodes)
    ID = subjectcodes(j);
    fprintf("Processing subject %s...\n",char(ID));
    subj_data = data(data.subject_code == ID,:);
    % remove outliers
    % T = rmoutliers(data2(:,9));
    % ix = ismember(data2(:,9),T(:,1));
    % data2 = data2(ix,:);
    
    % figure; stackedplot(data2);;
    % figure; stackedplot(data2(:,9),'.','markersize',20);
    % data2 = data2(data2.correcttrial == {'True'},:);
    subj_left = subj_data(subj_data.block_id <= nblock,:);
    subj_left = subj_left(subj_left.correcttrial == {'True'},:);
    subj_right = subj_data(subj_data.block_id > nblock,:);
    subj_right = subj_right(subj_right.correcttrial == {'True'},:);

    % Computing mean of correct trials within each block
    for i = 1:nblock
        blockvalueleft = subj_left(subj_left.block_id == i,:);
        blockmeanleft(j,i) = mean(blockvalueleft{:,tapping_speed_column},1,'omitnan');
        blockvalueright = subj_right(subj_right.block_id == i+nblock,:);
        blockmeanright(j,i) = mean(blockvalueright{:,tapping_speed_column},1,'omitnan');

        leftB1 = subj_left(subj_left.block_id == i,:);
        leftB2 = subj_left(subj_left.block_id == i+1,:);
        rightB1 = subj_right(subj_right.block_id == i+nblock,:);
        rightB2 = subj_right(subj_right.block_id == i+nblock+1,:);

        %compute micro learning for left(online and offline)
        
        if size(leftB1,1)>0
            leftmicroonline(j,i) = leftB1{end,tapping_speed_column}-leftB1{1,tapping_speed_column};
        else
            leftmicroonline(j,i) = 0;
        end

        if size(leftB1,1)>0 && size(leftB2,1)>0
            leftmicrooffline(j,i) = leftB2{1,tapping_speed_column}-leftB1{end,tapping_speed_column};

        elseif size(leftB1,1)>0 && size(leftB2,1)==0 && i ~=nblock
            leftmicrooffline(j,i) = 0-leftB1{end,tapping_speed_column};

        elseif size(leftB1,1)==0 && size(leftB2,1)>0
            leftmicrooffline(j,i) = leftB2{1,tapping_speed_column};

        else
            leftmicrooffline(j,i) = 0;
        end

        %compute micro learning for right(online and offline)
        if size(rightB1,1)>0
            rightmicroonline(j,i) = rightB1{end,tapping_speed_column}-rightB1{1,tapping_speed_column};
        else
            rightmicroonline(j,i) = 0;
        end

        if size(rightB1,1)>0 && size(rightB2,1)>0
            rightmicrooffline(j,i) = rightB2{1,tapping_speed_column}-rightB1{end,tapping_speed_column};

        elseif size(rightB1,1)>0 && size(rightB2,1)==0 && i ~=nblock
            rightmicrooffline(j,i) = 0-rightB1{end,tapping_speed_column};

        elseif size(rightB1,1)==0 && size(rightB2,1)>0
            rightmicrooffline(j,i) = rightB2{1,tapping_speed_column};

        else
            rightmicrooffline(j,i) = 0;
        end

    end

    
end

leftlearning = (leftmicroonline + leftmicrooffline);
rightlearning = (rightmicroonline + rightmicrooffline);

%% Plot data
for j=1:length(subjectcodes)
    ID = subjectcodes(j);
    subj_data = data(data.subject_code == ID,:);
    subj_left = subj_data(subj_data.block_id <= nblock,:);
    subj_left = subj_left(subj_left.correcttrial == {'True'},:);
    subj_right = subj_data(subj_data.block_id > nblock,:);
    subj_right = subj_right(subj_right.correcttrial == {'True'},:);
    
    figure; 
    subplot(2,2,1); h1 = stackedplot(subj_left{:,tapping_speed_column},'.','markersize',20);
    ax1 = findobj(h1.NodeChildren, 'Type','Axes');
    set([ax1.YLabel],'Rotation',90,'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
    title(ID);
    subplot(2,2,2); h2 = stackedplot(subj_right{:,tapping_speed_column},'.','markersize',20);
    ax2 = findobj(h2.NodeChildren, 'Type','Axes');
    set([ax2.YLabel],'Rotation',90,'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
    title(ID);
    subplot(2,2,3); plot(blockmeanleft,'b.','markersize',20);
    axis([0,nblock+1,0,nanmax([blockmeanleft;0.1])*1.2]);
    title('Left');
    subplot(2,2,4); plot(blockmeanright,'r.','markersize',20);
    axis([0,nblock+1,0,nanmax([blockmeanright;0.1])*1.2]);
    title('Right');

    figure; 
    subplot(2,1,1); plot(leftmicroonline,'b-.','linewidth',2);
    hold on
    plot(leftmicrooffline(1:nblock-1),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
    hold on
    plot(leftlearning,'k-','linewidth',2);
    axis([0,nblock+1, min(min(rightmicroonline),min(leftmicroonline))*1.5, max(max(rightmicrooffline),max(leftmicrooffline)) * 1.5]);
    title('Left Microscale Learning');
    legend('micro-online','micro-offline','Total');
    legend('location', 'northeastoutside');

    subplot(2,1,2); plot(rightmicroonline,'b-.','linewidth',2);
    hold on
    plot(rightmicrooffline(1:nblock-1),'r-.','linewidth',2); %note, last value for offline learning is omitted because it will be always 0
    hold on
    plot(rightlearning,'k-','linewidth',2);
    axis([0,nblock+1, min(min(rightmicroonline),min(leftmicroonline))*1.5, max(max(rightmicrooffline),max(leftmicrooffline)) * 1.5]);
    title('Right Microscale Learning');
    legend('micro-online','micro-offline','Total');
    legend('location', 'northeastoutside');
end

 %% Save data
if saveoutput
    headers = {'SubjectID','Blockmeanleft','Leftmicroonline','Leftmicrooffline','Lefttotal','Blockmeanright','Rightmicroonline','Rightmicrooffline','Righttotal'};
    processeddata = table(subjectcodes, blockmeanleft, leftmicroonline, leftmicrooffline, leftlearning, blockmeanright, rightmicroonline, rightmicrooffline, rightlearning,'variablenames', headers);
%     processeddata = [subjectcodes, blockmeanleft, leftmicroonline, leftmicrooffline, leftlearning, blockmeanright, rightmicroonline, rightmicrooffline, rightlearning];
%     for i = 2:size(processeddata,2)
%         processeddata{1,i}=fillmissing(processeddata{1,i},'constant',0);
%     end
%     processeddata = array2table(processeddata,'variablenames', headers);\
    mkdir("data_ready");
    exp_type = "offline";
    if experiment_code == "C6XN"
        exp_type = "online";
    end
    filename = strcat('data_ready\',exp_type,'.xlsx');
    writetable(processeddata,filename);
    save(strcat('data_ready\',exp_type),'processeddata');
end

    
    
%% 