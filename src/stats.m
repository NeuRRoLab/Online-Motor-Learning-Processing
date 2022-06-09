% Extracts the information from all the experiments using the variables
% described in the paper

clear;
close all;

%% Load data
paths = ["data_ready\offline.mat", "data_ready\online.mat", "data_ready\online_reversed.mat"];
early_learning_limit = 11;
groups = ["offline", "online", "right_first"];
variable_names = ["SubjectID", "Group"];
T = table('Size', [0 2], 'VariableTypes', cellstr(cat(2, ["string", "string"])), ...
    'VariableNames', variable_names);
t_idx = 1;

for i = 1:3
    data = load(paths(i)).processeddata;
    group = groups(i);
    num_subjects = size(data, 1);
    T{t_idx:t_idx + num_subjects - 1, "Group"} = group;
    T{t_idx:t_idx + num_subjects - 1, "SubjectID"} = data.SubjectID;
    % Left
    T{t_idx:t_idx + num_subjects - 1, "left_early_learning"} = sum(data{:, "Lefttotal"}(:, 1:early_learning_limit), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "left_early_microoffline"} = sum(data{:, "Leftmicrooffline"}(:, 1:early_learning_limit - 1), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "left_early_microonline"} = sum(data{:, "Leftmicroonline"}(:, 1:early_learning_limit), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "left_early_accuracy"} = mean(data{:, "Accuracyleft"}(:, 1:early_learning_limit), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "left_late_accuracy"} = mean(data{:, "Accuracyleft"}(:, 12:end), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "left_early_accuracy_bonstrup"} = mean(data{:, "Accuracyleftbonstrup"}(:, 1:early_learning_limit), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "left_late_accuracy_bonstrup"} = mean(data{:, "Accuracyleftbonstrup"}(:, 12:end), 2, 'omitnan');

    % Right
    T{t_idx:t_idx + num_subjects - 1, "right_early_learning"} = sum(data{:, "Righttotal"}(:, 1:early_learning_limit), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "right_early_microoffline"} = sum(data{:, "Rightmicrooffline"}(:, 1:early_learning_limit - 1), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "right_early_microonline"} = sum(data{:, "Rightmicroonline"}(:, 1:early_learning_limit), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "right_early_accuracy"} = mean(data{:, "Accuracyright"}(:, 1:early_learning_limit), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "right_late_accuracy"} = mean(data{:, "Accuracyright"}(:, 12:end), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "right_early_accuracy_bonstrup"} = mean(data{:, "Accuracyrightbonstrup"}(:, 1:early_learning_limit), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "right_late_accuracy_bonstrup"} = mean(data{:, "Accuracyrightbonstrup"}(:, 12:end), 2, 'omitnan');
    T{t_idx:t_idx + num_subjects - 1, "total_left_learning"} = data{:, "Blockmeanleft"}(:, end) - data{:, "Blockmeanleft"}(:, 1);
    T{t_idx:t_idx + num_subjects - 1, "total_right_learning"} = data{:, "Blockmeanright"}(:, end) - data{:, "Blockmeanright"}(:, 1);

    %% Transfer metrics
    if i < 3
        T{t_idx:t_idx + num_subjects - 1, "k_transfer_1"} = data{:, "Blockmeanright"}(:, 1) - data{:, "Blockmeanleft"}(:, 1);
        T{t_idx:t_idx + num_subjects - 1, "k_transfer_2"} = data{:, "Blockmeanright"}(:, end) - data{:, "Blockmeanleft"}(:, end);
    else
        T{t_idx:t_idx + num_subjects - 1, "k_transfer_1"} = data{:, "Blockmeanleft"}(:, 1) - data{:, "Blockmeanright"}(:, 1);
        T{t_idx:t_idx + num_subjects - 1, "k_transfer_2"} = data{:, "Blockmeanleft"}(:, end) - data{:, "Blockmeanright"}(:, end);
    end

    t_idx = t_idx + num_subjects;
end

%% Violin plot
colors = ["#808080", "red", "blue"];
offline_t = T(T.Group == "offline", :);
online_t = T(T.Group == "online", :);
all_left_first = [offline_t; online_t];
figure;
title("In Person - Left");
violins = violinplot(cat(2, offline_t.left_early_learning, offline_t.left_early_microoffline, offline_t.left_early_microonline));

for i = 1:3
    violins(i).ViolinColor = colors(i);
end

xticklabels(["Total Early learning", "Micro-offline", "Micro-online"]);
hold on;
yline(0)

figure;
title("In Person - Right");
violins = violinplot(cat(2, offline_t.right_early_learning, offline_t.right_early_microoffline, offline_t.right_early_microonline));

for i = 1:3
    violins(i).ViolinColor = colors(i);
end

xticklabels(["Total Early learning", "Micro-offline", "Micro-online"]);
hold on;
yline(0)

figure;
title("Online - Left");
violins = violinplot(cat(2, online_t.left_early_learning, online_t.left_early_microoffline, online_t.left_early_microonline));

for i = 1:3
    violins(i).ViolinColor = colors(i);
end

xticklabels(["Total Early learning", "Micro-offline", "Micro-online"]);
hold on;
yline(0)

figure;
title("Online - Right");
violins = violinplot(cat(2, online_t.right_early_learning, online_t.right_early_microoffline, online_t.right_early_microonline));

for i = 1:3
    violins(i).ViolinColor = colors(i);
end

xticklabels(["Total Early learning", "Micro-offline", "Micro-online"]);
hold on;
yline(0)

% People grouped together
figure;
title("Total - Left");
violins = violinplot(cat(2, all_left_first.left_early_learning, all_left_first.left_early_microoffline, all_left_first.left_early_microonline));

for i = 1:3
    violins(i).ViolinColor = colors(i);
end

xticklabels(["Total Early learning", "Micro-offline", "Micro-online"]);
hold on;
yline(0)
ylabel("Tapping Speed [Keypress/s]")
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12)
figure;
title("Total - Right");
violins = violinplot(cat(2, all_left_first.right_early_learning, all_left_first.right_early_microoffline, all_left_first.right_early_microonline));

for i = 1:3
    violins(i).ViolinColor = colors(i);
end

xticklabels(["Total Early learning", "Micro-offline", "Micro-online"]);
hold on;
yline(0)
ylabel("Tapping Speed [Keypress/s]")
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12)

%% Bar plot interlimb transfer
figure
mean_transfer_1 = mean(T.k_transfer_1);
std_transfer_1 = std(T.k_transfer_1);
mean_transfer_2 = mean(T.k_transfer_2);
std_transfer_2 = std(T.k_transfer_2);
X = categorical({'Early Transfer', 'Late Transfer'});
X = reordercats(X, {'Early Transfer', 'Late Transfer'});
bar(X, [mean_transfer_1; mean_transfer_2])
hold on;
ylabel("Tapping speed (kp/s)")
ylim([-0.5, 2])
errorbar(X, [mean_transfer_1; mean_transfer_2], [std_transfer_1 / sqrt(height(T)); std_transfer_2 / sqrt(height(T))], 'k.')

%% Interlimb transfer comparison between groups
group1_t = T(T.Group == "left_first", :);
group2_t = online_reversed_t;

g1_mean_transfer_1 = mean(group1_t.k_transfer_1);
g1_std_transfer_1 = std(group1_t.k_transfer_1);
g1_mean_transfer_2 = mean(group1_t.k_transfer_2);
g1_std_transfer_2 = std(group1_t.k_transfer_2);

g2_mean_transfer_1 = mean(group2_t.k_transfer_1);
g2_std_transfer_1 = std(group2_t.k_transfer_1);
g2_mean_transfer_2 = mean(group2_t.k_transfer_2);
g2_std_transfer_2 = std(group2_t.k_transfer_2);

figure
X = categorical({'Early Transfer', 'Late Transfer'});
X = reordercats(X, {'Early Transfer', 'Late Transfer'});
subplot(1, 2, 1)
bar(X, [g1_mean_transfer_1; g1_mean_transfer_2])
hold on;
title("Left first");
ylabel("Tapping speed (kp/s)")
ylim([-0.5, 2])
errorbar(X, [g1_mean_transfer_1; g1_mean_transfer_2], [g1_std_transfer_1 / sqrt(height(group1_t)); g1_std_transfer_2 / sqrt(height(group1_t))], 'k.')

subplot(1, 2, 2)
bar(X, [g2_mean_transfer_1; g2_mean_transfer_2])
hold on;
title("Right first");
ylabel("Tapping speed (kp/s)")
ylim([-0.5, 2])
errorbar(X, [g2_mean_transfer_1; g2_mean_transfer_2], [g2_std_transfer_1 / sqrt(height(group2_t)); g2_std_transfer_2 / sqrt(height(group2_t))], 'k.')

%% Export table to Excel
writetable(T, "results\stats.xlsx");
