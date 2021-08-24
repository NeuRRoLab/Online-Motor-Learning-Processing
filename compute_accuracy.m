clear;
close all;

% Read raw data
paths = ["raw_data_5P6U.csv","raw_data_C6XN.csv"];
excluded_subjects = categorical(["IKLgXSxdg4WBhLQC","7UaSAihDn1q9Vv05"]);
nblocks = 36;
for i=1:2
    data = readtable(strcat("data/",paths(i)));
    % Exclude subjects
    data = data(~ismember(data.subject_code, excluded_subjects),:);
    subjectcodes = unique(data.subject_code);
    accuracy = zeros(nblocks,2,length(subjectcodes));
    for subj = 1:length(subjectcodes)
        ID = subjectcodes(subj);
        subj_data = data(strcmp(data.subject_code,ID),:);
        subj_left = subj_data(subj_data.block_id <= nblocks,:);
        subj_right = subj_data(subj_data.block_id > nblocks,:);
        % Compute accuracy for each block
        for block=1:nblocks
            leftB = subj_left(subj_left.block_id == block,:);
            rightB = subj_right(subj_right.block_id == block+nblocks,:);
            accuracy(block, 1,subj) = sum(leftB.was_keypress_correct == "True") / size(leftB,1);
            accuracy(block, 2,subj) = sum(rightB.was_keypress_correct == "True") / size(rightB,1);
        end
    end
    % Modify the saved file
    filename = "data_ready\offline.mat";
    if i == 2
        filename = "data_ready\online.mat";
    end
    processeddata = load(filename).processeddata;
    processeddata.Accuracyleft = squeeze(accuracy(:,1,:)).';
    processeddata.Accuracyright = squeeze(accuracy(:,2,:)).';
    save(filename,'processeddata');
end