% Takes a processed experiment, calculates microscale learning
% and converts it to a Matlab struct and an Excel file

clear;
close all;
%%
addpath('.\include');
% Change this to the experiment we are interested in
data = readtable('.\data\processed_experiment_DHXY.csv');
% For our way of processing
tapping_speed_column = 'tapping_speed_mean';
% Exclude subjects
excluded_subjects = categorical(["IKLgXSxdg4WBhLQC", "7UaSAihDn1q9Vv05"]);
data = data(~ismember(data.subject_code, excluded_subjects), :);
subjectcodes = unique(data.subject_code);

nblock = 36;
saveoutput = true;
data.subjectid = categorical(data.subject_code);
data.subject_code = categorical(data.subject_code);
% Column will have true if trial is correct, or false if incorrect
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

    if experiment_code ~= "DHXY"
        % Left first
        subj_left = subj_data(subj_data.block_id <= nblock, :);
        subj_right = subj_data(subj_data.block_id > nblock, :);
    else
        % Right first
        subj_left = subj_data(subj_data.block_id > nblock, :);
        subj_right = subj_data(subj_data.block_id <= nblock, :);
    end

    subj_left = subj_left(subj_left.correct_trial, :);
    subj_right = subj_right(subj_right.correct_trial, :);

    % Computing mean of correct trials within each block
    for i = 1:nblock

        if experiment_code ~= "DHXY"
            % Left first
            idx_left = i;
            idx_right = i + nblock;
        else
            % Right first
            idx_left = i + nblock;
            idx_right = i;
        end

        blockvalueleft = subj_left(subj_left.block_id == idx_left, :);
        blockmeanleft(j, i) = mean(blockvalueleft{:, tapping_speed_column}, 1, 'omitnan');
        blockvalueright = subj_right(subj_right.block_id == idx_right, :);
        blockmeanright(j, i) = mean(blockvalueright{:, tapping_speed_column}, 1, 'omitnan');

        if isnan(blockmeanleft(j, i))
            blockmeanleft(j, i) = 0;
        end

        if isnan(blockmeanright(j, i))
            blockmeanright(j, i) = 0;
        end

        leftB1 = subj_left(subj_left.block_id == idx_left, :);
        leftB2 = subj_left(subj_left.block_id == idx_left + 1, :);
        rightB1 = subj_right(subj_right.block_id == idx_right, :);
        rightB2 = subj_right(subj_right.block_id == idx_right + 1, :);

        % Compute micro learning for left

        if size(leftB1, 1) > 0
            % Last minus first trial
            leftmicroonline(j, i) = leftB1{end, tapping_speed_column} - leftB1{1, tapping_speed_column};
        else
            leftmicroonline(j, i) = 0;
        end

        if size(leftB1, 1) > 0 && size(leftB2, 1) > 0
            % If both have at least one correct trial
            % First trial of this block minus last trial of last block
            leftmicrooffline(j, i) = leftB2{1, tapping_speed_column} - leftB1{end, tapping_speed_column};
        elseif size(leftB1, 1) > 0 && size(leftB2, 1) == 0 && i ~= nblock
            % If the next block doesn't have any correct trials
            leftmicrooffline(j, i) = 0 - leftB1{end, tapping_speed_column};
        elseif size(leftB1, 1) == 0 && size(leftB2, 1) > 0
            % If the next block has one correct trial
            leftmicrooffline(j, i) = leftB2{1, tapping_speed_column};
        else
            % If neither has any correct trials
            leftmicrooffline(j, i) = 0;
        end

        % Compute micro learning for right
        if size(rightB1, 1) > 0
            rightmicroonline(j, i) = rightB1{end, tapping_speed_column} - rightB1{1, tapping_speed_column};
        else
            rightmicroonline(j, i) = 0;
        end

        if size(rightB1, 1) > 0 && size(rightB2, 1) > 0
            % If both have at least one correct trial
            rightmicrooffline(j, i) = rightB2{1, tapping_speed_column} - rightB1{end, tapping_speed_column};

        elseif size(rightB1, 1) > 0 && size(rightB2, 1) == 0 && i ~= nblock
            % If the next block doesn't have any correct trials
            rightmicrooffline(j, i) = 0 - rightB1{end, tapping_speed_column};

        elseif size(rightB1, 1) == 0 && size(rightB2, 1) > 0
            % If the next block has one correct trial
            rightmicrooffline(j, i) = rightB2{1, tapping_speed_column};

        else
            % If neither has any correct trials
            rightmicrooffline(j, i) = 0;
        end

    end

end

% Shift the micro-offline values
leftmicrooffline = circshift(leftmicrooffline, [0 1]);
leftmicrooffline(:, 1) = nan;
rightmicrooffline = circshift(rightmicrooffline, [0 1]);
rightmicrooffline(:, 1) = nan;
% Total learning
leftlearning = sum(cat(3, leftmicroonline, leftmicrooffline), 3, 'omitnan');
rightlearning = sum(cat(3, rightmicroonline, rightmicrooffline), 3, 'omitnan');

%% Save data
if saveoutput
    headers = {'SubjectID', 'Blockmeanleft', 'Leftmicroonline', 'Leftmicrooffline', 'Lefttotal', 'Blockmeanright', 'Rightmicroonline', 'Rightmicrooffline', 'Righttotal'};
    processeddata = table(subjectcodes, blockmeanleft, leftmicroonline, leftmicrooffline, leftlearning, blockmeanright, rightmicroonline, rightmicrooffline, rightlearning, 'variablenames', headers);

    exp_type = "offline";

    if experiment_code == "C6XN"
        exp_type = "online";
    elseif experiment_code == "DHXY"
        exp_type = "online_reversed";
    end

    filename = strcat('results\', exp_type, '.xlsx');
    writetable(processeddata, filename);
    save(strcat('results\', exp_type), 'processeddata');
end
