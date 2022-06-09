% Compute accuracy for each subject/trial, using the metric
% from Bonstrup and the normal metric

clear;
close all;

% Read raw data
% Includes the reversed experiment data
paths = ["raw_data_5P6U.csv", "raw_data_C6XN.csv", "raw_data_DHXY.csv"];
excluded_subjects = categorical(["IKLgXSxdg4WBhLQC", "7UaSAihDn1q9Vv05"]);
filenames = ["results\offline.mat", "results\online.mat", "results\online_reversed.mat"];
nblocks = 36;

for i = 1:3
    data = readtable(strcat("data/", paths(i)));
    % Exclude subjects
    data = data(~ismember(data.subject_code, excluded_subjects), :);
    subjectcodes = unique(data.subject_code);
    % Set up arrays
    accuracy = zeros(nblocks, 2, length(subjectcodes));
    accuracy_bonstrup = zeros(nblocks, 2, length(subjectcodes));

    for subj = 1:length(subjectcodes)
        ID = subjectcodes(subj);
        subj_data = data(strcmp(data.subject_code, ID), :);

        if i < 3
            % left hand first
            subj_left = subj_data(subj_data.block_id <= nblocks, :);
            subj_right = subj_data(subj_data.block_id > nblocks, :);
        else
            % right hand first
            subj_left = subj_data(subj_data.block_id > nblocks, :);
            subj_right = subj_data(subj_data.block_id <= nblocks, :);
        end

        % Compute accuracy for each block
        for block = 1:nblocks

            if i < 3
                % Left hand first
                idx_left = block;
                idx_right = block + nblocks;
            else
                % Right hand first
                idx_left = block + nblocks;
                idx_right = block;
            end

            leftB = subj_left(subj_left.block_id == idx_left, :);
            rightB = subj_right(subj_right.block_id == idx_right, :);
            accuracy(block, 1, subj) = sum(leftB.was_keypress_correct == "True") / size(leftB, 1);
            accuracy(block, 2, subj) = sum(rightB.was_keypress_correct == "True") / size(rightB, 1);
            b_val_left = 1 - sum(leftB.was_keypress_correct == "False") / sum(leftB.was_keypress_correct == "True");
            b_val_right = 1 - sum(rightB.was_keypress_correct == "False") / sum(rightB.was_keypress_correct == "True");
            accuracy_bonstrup(block, 1, subj) = max(b_val_left, 0);
            accuracy_bonstrup(block, 2, subj) = max(b_val_right, 0);
        end

    end

    % Modify the saved file
    filename = filenames(i);
    processeddata = load(filename).processeddata;
    processeddata.Accuracyleft = squeeze(accuracy(:, 1, :)).';
    processeddata.Accuracyright = squeeze(accuracy(:, 2, :)).';
    processeddata.Accuracyleftbonstrup = squeeze(accuracy_bonstrup(:, 1, :)).';
    processeddata.Accuracyrightbonstrup = squeeze(accuracy_bonstrup(:, 2, :)).';
    save(filename, 'processeddata');
end
