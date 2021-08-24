clear;
close all;

%% Load data
data = load("data_ready\online.mat").processeddata;
% data = load(""data_ready\online.mat").processeddata;
paths = ["data_ready\offline.mat","data_ready\online.mat"];
groups = ["offline","online"];
variable_names = ["SubjectID","Group","left_early_learning","left_early_microoffline","left_earlymicroonline",...
                    "left_learning_day","right_early_learning","right_early_microoffline",...
                    "right_early_microonline","right_learning_day","left_early_accuracy",...
                    "right_early_accuracy","left_late_accuracy","right_late_accuracy","k_left_learning",...
                    "k_right_learning","k_transfer_1","k_transfer_2"];
T = table('Size',[0 18], 'VariableTypes',cellstr(cat(2,["string","string"],repmat({'double'},1,16))),...
    'VariableNames',variable_names);
t_idx = 1;
for i=1:2
    data = load(paths(i)).processeddata;
    group = groups(i);
    num_subjects = size(data,1);
    T{t_idx:t_idx+num_subjects - 1,"Group"} = group;
    T{t_idx:t_idx+num_subjects - 1,"SubjectID"} = data.SubjectID;
    %% Bonstrup metrics
    % Left
    T{t_idx:t_idx+num_subjects - 1,"left_early_learning"} = sum(data{:,"Lefttotal"}(:,1:11),2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"left_early_microoffline"} = sum(data{:,"Leftmicrooffline"}(:,1:10),2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"left_earlymicroonline"} = sum(data{:,"Leftmicroonline"}(:,1:11),2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"left_learning_day"} = sum(data{:,"Lefttotal"},2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"left_early_accuracy"} = mean(data{:,"Accuracyleft"}(:,1:11),2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"left_late_accuracy"} = mean(data{:,"Accuracyleft"}(:,12:end),2,'omitnan');
    
    % Right
    T{t_idx:t_idx+num_subjects - 1,"right_early_learning"} = sum(data{:,"Righttotal"}(:,1:11),2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"right_early_microoffline"} = sum(data{:,"Rightmicrooffline"}(:,1:10),2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"right_early_microonline"} = sum(data{:,"Rightmicroonline"}(:,1:11),2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"right_learning_day"} = sum(data{:,"Righttotal"},2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"right_early_accuracy"} = mean(data{:,"Accuracyright"}(:,1:11),2,'omitnan');
    T{t_idx:t_idx+num_subjects - 1,"right_late_accuracy"} = mean(data{:,"Accuracyright"}(:,12:end),2,'omitnan');    

    %% Our metrics
    T{t_idx:t_idx+num_subjects - 1,"k_left_learning"} = data{:,"Blockmeanleft"}(:,end) - data{:,"Blockmeanleft"}(:,1);
    T{t_idx:t_idx+num_subjects - 1,"k_right_learning"} = data{:,"Blockmeanright"}(:,end) - data{:,"Blockmeanright"}(:,1);
    T{t_idx:t_idx+num_subjects - 1,"k_transfer_1"} = data{:,"Blockmeanright"}(:,1) - data{:,"Blockmeanleft"}(:,1);
    T{t_idx:t_idx+num_subjects - 1,"k_transfer_2"} = data{:,"Blockmeanright"}(:,end) - data{:,"Blockmeanleft"}(:,end);
    
    t_idx = t_idx + num_subjects;
end

%% Export table to Excel
writetable(T,"data_ready\stats.xlsx");


