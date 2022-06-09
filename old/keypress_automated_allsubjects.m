clc
clear all;
close all;
%%
addpath('C:\Users\mouli\Desktop\Things to Add in Dropbox\Matlab course\Course Materials\Other Programs\myfunctions');
addpath('C:\Users\mouli\Desktop\Herokuapp');
data = readtable('processed_experiment_5P6U_06.28.21.csv');
%%
subjectcode = unique(data.subject_code);
nsubjects = size(subjectcode, 1);

for z = 1:nsubjects
    ID = subjectcode(z, 1);
    data.subjectid = categorical(data.subject_code);
    data.correcttrial = categorical(data.correct_trial);
    data2 = data(data.subjectid == ID, :);
    %% remove outliers
    % T = rmoutliers(data2(:,9));
    % ix = ismember(data2(:,9),T(:,1));
    % data2 = data2(ix,:);
    %%
    % figure; stackedplot(data2);;
    % figure; stackedplot(data2(:,9),'.','markersize',20);
    % data2 = data2(data2.correcttrial == {'True'},:);
    %%
    data2left = data2(data2.block_id < 37, :);
    data2left = data2left(data2left.correcttrial == {'True'}, :);
    data2right = data2(data2.block_id > 36, :);
    data2right = data2right(data2right.correcttrial == {'True'}, :);

    figure;
    subplot(2, 2, 1); h1 = stackedplot(data2left(:, 9), '.', 'markersize', 20);
    ax1 = findobj(h1.NodeChildren, 'Type', 'Axes');
    set([ax1.YLabel], 'Rotation', 90, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
    title(ID);
    subplot(2, 2, 2); h2 = stackedplot(data2right(:, 9), '.', 'markersize', 20);
    ax2 = findobj(h2.NodeChildren, 'Type', 'Axes');
    set([ax2.YLabel], 'Rotation', 90, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
    title(ID);
    %% Computing mean of correct trials within each block

    for i = 1:36
        blockvalueleft = data2left(data2left.block_id == i, :);
        blockmeanleft(i, :) = mean(blockvalueleft{:, 9}, 1, 'omitnan');
        blockvalueright = data2right(data2right.block_id == i + 36, :);
        blockmeanright(i, :) = mean(blockvalueright{:, 9}, 1, 'omitnan');

        leftB1 = data2left(data2left.block_id == i, :);
        leftB2 = data2left(data2left.block_id == i + 1, :);
        rightB1 = data2right(data2right.block_id == i + 36, :);
        rightB2 = data2right(data2right.block_id == i + 36 + 1, :);

        %compute micro learning for left(online and offline)
        if size(leftB1, 1) > 0
            leftmicroonline(i, :) = leftB1{end, 9} - leftB1{1, 9};
        else
            leftmicroonline(i, :) = 0;
        end

        if size(leftB1, 1) > 0 && size(leftB2, 1) > 0
            leftmicrooffline(i, :) = leftB2{1, 9} - leftB1{end, 9};

        elseif size(leftB1, 1) > 0 && size(leftB2, 1) == 0 && i ~= 36
            leftmicrooffline(i, :) = 0 - leftB1{end, 9};

        elseif size(leftB1, 1) == 0 && size(leftB2, 1) > 0
            leftmicrooffline(i, :) = leftB2{1, 9};

        else
            leftmicrooffline(i, :) = 0;
        end

        %compute micro learning for right(online and offline)
        if size(rightB1, 1) > 0
            rightmicroonline(i, :) = rightB1{end, 9} - rightB1{1, 9};
        else
            rightmicroonline(i, :) = 0;
        end

        if size(rightB1, 1) > 0 && size(rightB2, 1) > 0
            rightmicrooffline(i, :) = rightB2{1, 9} - rightB1{end, 9};

        elseif size(rightB1, 1) > 0 && size(rightB2, 1) == 0 && i ~= 36
            rightmicrooffline(i, :) = 0 - rightB1{end, 9};

        elseif size(rightB1, 1) == 0 && size(rightB2, 1) > 0
            rightmicrooffline(i, :) = rightB2{1, 9};

        else
            rightmicrooffline(i, :) = 0;
        end

    end

    subplot(2, 2, 3); plot(blockmeanleft, 'b.', 'markersize', 20);
    axis([0, 37, 0, max(blockmeanleft) * 1.2]);
    title('Left');
    subplot(2, 2, 4); plot(blockmeanright, 'r.', 'markersize', 20);
    axis([0, 37, 0, max(blockmeanright) * 1.2]);
    title('Right');

    leftlearning = (leftmicroonline + leftmicrooffline);
    rightlearning = (rightmicroonline + rightmicrooffline);
    figure;
    subplot(2, 1, 1); plot(leftmicroonline, 'b-.', 'linewidth', 2);
    hold on
    plot(leftmicrooffline(1:35), 'r-.', 'linewidth', 2); %note, last value for offline learning is omitted because it will be always 0
    hold on
    plot(leftlearning, 'k-', 'linewidth', 2);
    axis([0, 37, min(min(rightmicroonline), min(leftmicroonline)) * 1.5, max(max(rightmicrooffline), max(leftmicrooffline)) * 1.5]);
    title('Left Microscale Learning');
    legend('micro-online', 'micro-offline', 'Total');
    legend('location', 'northeastoutside');

    subplot(2, 1, 2); plot(rightmicroonline, 'b-.', 'linewidth', 2);
    hold on
    plot(rightmicrooffline(1:35), 'r-.', 'linewidth', 2); %note, last value for offline learning is omitted because it will be always 0
    hold on
    plot(rightlearning, 'k-', 'linewidth', 2);
    axis([0, 37, min(min(rightmicroonline), min(leftmicroonline)) * 1.5, max(max(rightmicrooffline), max(leftmicrooffline)) * 1.5]);
    title('Right Microscale Learning');
    legend('micro-online', 'micro-offline', 'Total');
    legend('location', 'northeastoutside');
    %% Save data
    headers = {'SubjectID', 'Blockmeanleft', 'Leftmicroonline', 'Leftmicrooffline', 'Lefttotal', 'Blockmeanright', 'Rightmicroonline', 'Rightmicrooffline', 'Righttotal'};
    processeddata = [ID, blockmeanleft, leftmicroonline, leftmicrooffline, leftlearning, blockmeanright, rightmicroonline, rightmicrooffline, rightlearning];

    for i = 2:size(processeddata, 2)
        processeddata{1, i} = fillmissing(processeddata{1, i}, 'constant', 0);
    end

    processeddata = array2table(processeddata, 'variablenames', headers);
    newID = char(ID);
    filename = strcat(newID, '.xlsx');
    writetable(processeddata, filename);
end
