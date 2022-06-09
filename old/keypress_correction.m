% Takes a processed experiment data and converts it to a Matlab struct
% Adds a correction that changes the computation of micro-offline learning
clear;
close all;

%%
addpath('.\include');
data = readtable('.\data\processed_experiment_5P6U.csv');
% For our way of processing
tapping_speed_column = 'tapping_speed_mean';
% Exclude subjects
excluded_subjects = categorical(["IKLgXSxdg4WBhLQC", "7UaSAihDn1q9Vv05"]);
data = data(~ismember(data.subject_code, excluded_subjects), :);
subjectcodes = unique(data.subject_code);

nblock = 36;
true = 1; false = 0;
saveoutput = true;
data.subjectid = categorical(data.subject_code);
data.subject_code = categorical(data.subject_code);
data.correcttrial = categorical(data.correct_trial);
data.correct_trial = strcmp(data.correct_trial, 'True');
experiment_code = char(unique(data.experiment_code));

blockmeanleft = zeros(length(subjectcodes), nblock);
blockmeanright = zeros(length(subjectcodes), nblock);
leftmicroonline = zeros(length(subjectcodes), nblock);
leftmicrooffline = zeros(length(subjectcodes), nblock);
rightmicroonline = zeros(length(subjectcodes), nblock);
rightmicrooffline = zeros(length(subjectcodes), nblock);
%% Go through each subject
for j = 1:length(subjectcodes)
    ID = subjectcodes(j);
    fprintf("Processing subject %s...\n", char(ID));
    subj_data = data(data.subject_code == ID, :);
    % remove outliers
    % T = rmoutliers(data2(:,9));
    % ix = ismember(data2(:,9),T(:,1));
    % data2 = data2(ix,:);

    % figure; stackedplot(data2);;
    % figure; stackedplot(data2(:,9),'.','markersize',20);
    % data2 = data2(data2.correcttrial == {'True'},:);
    subj_left = subj_data(subj_data.block_id <= nblock, :);
    subj_left = subj_left(subj_left.correcttrial == {'True'}, :);
    subj_right = subj_data(subj_data.block_id > nblock, :);
    subj_right = subj_right(subj_right.correcttrial == {'True'}, :);

    % Computing mean of correct trials within each block
    for i = 1:nblock
        blockvalueleft = subj_left(subj_left.block_id == i, :);
        blockmeanleft(j, i) = mean(blockvalueleft{:, tapping_speed_column}, 1, 'omitnan');
        blockvalueright = subj_right(subj_right.block_id == i + nblock, :);
        blockmeanright(j, i) = mean(blockvalueright{:, tapping_speed_column}, 1, 'omitnan');

        if isnan(blockmeanleft(j, i))
            blockmeanleft(j, i) = 0;
        end

        if isnan(blockmeanright(j, i))
            blockmeanright(j, i) = 0;
        end

        leftB0 = subj_left(subj_left.block_id == i - 1, :);
        leftB1 = subj_left(subj_left.block_id == i, :);
        leftB2 = subj_left(subj_left.block_id == i + 1, :);
        rightB0 = subj_right(subj_right.block_id == i + nblock - 1, :);
        rightB1 = subj_right(subj_right.block_id == i + nblock, :);
        rightB2 = subj_right(subj_right.block_id == i + nblock + 1, :);

        %compute micro learning for left(online and offline)
        if size(leftB1, 1) > 0
            leftmicroonline(j, i) = leftB1{end, tapping_speed_column} - leftB1{1, tapping_speed_column};
        else
            leftmicroonline(j, i) = 0;
        end

        % If both have at least one correct trial
        if size(leftB1, 1) > 0 && size(leftB2, 1) > 0
            leftmicrooffline(j, i) = leftB2{1, tapping_speed_column} - leftB1{end, tapping_speed_column};
            % If the next block doesn't have any correct trials
        elseif size(leftB1, 1) > 0 && size(leftB2, 1) == 0
            % Changed to use mean left
            leftmicrooffline(j, i) = 0;
            % If the next block has one correct trial
        elseif size(leftB1, 1) == 0 && size(leftB2, 1) > 0
            % Changed to use mean left
            if i > 1
                leftmicrooffline(j, i) = leftB2{1, tapping_speed_column} - blockmeanleft(j, i - 1);
            else
                leftmicrooffline(j, i) = leftB2{1, tapping_speed_column};
            end

            % If neither has any correct trials
        else
            leftmicrooffline(j, i) = 0;
        end

        %compute micro learning for right(online and offline)
        if size(rightB1, 1) > 0
            rightmicroonline(j, i) = rightB1{end, tapping_speed_column} - rightB1{1, tapping_speed_column};
        else
            rightmicroonline(j, i) = 0;
        end

        if size(rightB1, 1) > 0 && size(rightB2, 1) > 0
            rightmicrooffline(j, i) = rightB2{1, tapping_speed_column} - rightB1{end, tapping_speed_column};

        elseif size(rightB1, 1) > 0 && size(rightB2, 1) == 0
            % Changed to use mean right
            rightmicrooffline(j, i) = 0;

        elseif size(rightB1, 1) == 0 && size(rightB2, 1) > 0
            % Changed to use mean left
            if i > 1
                rightmicrooffline(j, i) = rightB2{1, tapping_speed_column} - blockmeanright(j, i - 1);
            else
                rightmicrooffline(j, i) = rightB2{1, tapping_speed_column};
            end

        else
            rightmicrooffline(j, i) = 0;
        end

        % Warning: this will overwrite values if the condition is met.
        % If this block has speed 0, then we update the mean speed with the
        % last block, and also the offline learning
        if (blockmeanleft(j, i) == 0 || isnan(blockmeanleft(j, i))) && i > 1

            if size(leftB0, 1) > 0
                blockmeanleft(j, i) = leftB0{end, tapping_speed_column};
            else
                blockmeanleft(j, i) = blockmeanleft(j, i - 1);
            end

        end

        if (blockmeanright(j, i) == 0 || isnan(blockmeanright(j, i))) && i > 1

            if size(rightB0, 1) > 0
                blockmeanright(j, i) = rightB0{end, tapping_speed_column};
            else
                blockmeanright(j, i) = blockmeanright(j, i - 1);
            end

        end

    end

end

leftmicrooffline = circshift(leftmicrooffline, [0 1]);
leftmicrooffline(:, 1) = nan;
rightmicrooffline = circshift(rightmicrooffline, [0 1]);
rightmicrooffline(:, 1) = nan;

leftlearning = sum(cat(3, leftmicroonline, leftmicrooffline), 3, 'omitnan');
rightlearning = sum(cat(3, rightmicroonline, rightmicrooffline), 3, 'omitnan');

%% Save data
if saveoutput
    headers = {'SubjectID', 'Blockmeanleft', 'Leftmicroonline', 'Leftmicrooffline', 'Lefttotal', 'Blockmeanright', 'Rightmicroonline', 'Rightmicrooffline', 'Righttotal'};
    processeddata = table(subjectcodes, blockmeanleft, leftmicroonline, leftmicrooffline, leftlearning, blockmeanright, rightmicroonline, rightmicrooffline, rightlearning, 'variablenames', headers);
    %     processeddata = [subjectcodes, blockmeanleft, leftmicroonline, leftmicrooffline, leftlearning, blockmeanright, rightmicroonline, rightmicrooffline, rightlearning];
    %     for i = 2:size(processeddata,2)
    %         processeddata{1,i}=fillmissing(processeddata{1,i},'constant',0);
    %     end
    %     processeddata = array2table(processeddata,'variablenames', headers);\
    mkdir("data_ready");
    exp_type = "offline_corrected";

    if experiment_code == "C6XN"
        exp_type = "online_corrected";
    end

    filename = strcat('data_ready\', exp_type, '.xlsx');
    writetable(processeddata, filename);
    save(strcat('data_ready\', exp_type), 'processeddata');
end

%%
