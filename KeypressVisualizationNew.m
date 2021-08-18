clc
clear all;
close all;
%% defines location of path for functions and data files
addpath('C:\Users\mouli\OneDrive - Michigan Medicine\Desktop\Things to Add in Dropbox\Matlab course\Course Materials\Other Programs\myfunctions');
addpath('C:\Users\mouli\OneDrive - Michigan Medicine\Desktop\Herokuapp');
data = readtable('raw_experiment_C6XN_25.csv');
%% variables to define
left = 0; right = 1;%do not change these values, change below on the side
side = left;%defines the side of the training
nblock = 36;% defines the number of training blocks performed per hand
nkeys = 5;
trialduration = 10000; %defines duration of the trial in milliseconds
%% 
subjectcode = unique(data.subject_code);
nsubjects = size(subjectcode,1);

for z = 1:nsubjects
    clearvars -except data left nblock nkeys right side trialduration subjectcode nsubjects z maxtappingspeed keypressvisualarray
    ID = subjectcode(z,1);
    data.subjectid = categorical(data.subject_code);
    data.correcttrial = categorical(data.was_trial_correct);
    data2 = data(data.subjectid == ID,:);

%% remove outliers
% T = rmoutliers(data2(:,11));
% ix = ismember(data2(:,11),T(:,1));
% data2 = data2(ix,:);
if side == left
    
    data2new = data2(data2.block_id <= nblock,:);
    data2new = data2new(data2new.correcttrial == {'True'},:);
    data2new.tapspeed = 1000./data2new.diff_between_keypresses_ms;
    
else

    data2new = data2(data2.block_id > nblock,:);
    data2new = data2new(data2new.correcttrial == {'True'},:);
    data2new.tapspeed = 1000./data2new.diff_between_keypresses_ms;
    
end
%% 

% figure; 
% h1 = stackedplot(data2new.tapspeed,'.','markersize',20);
% ax1 = findobj(h1.NodeChildren, 'Type','Axes');
% set([ax1.YLabel],'Rotation',90,'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom');
% title(ID);

%% 
maxntrial = max((data2new.trial_id));

% d2ms = 86400000; %this is to convert timestamp to millisecond data but
% millisecond function also provides the same value
trialmeantappingspeed = ones(nblock,maxntrial)*NaN;
trialtime = ones(nblock,maxntrial)*NaN;

for i = 1:nblock
    if side == left
        ivalue = i;
    else
        ivalue = i+nblock;
    end
    
    blockvalue = data2new(data2new.block_id == ivalue,:);
    ntrial = unique(blockvalue.trial_id); 
    k = 1;
    
    for j = 1:max(ntrial)
        trialvalue = blockvalue(blockvalue.trial_id ==j,:);
        trialmeanintertime = mean(trialvalue.diff_between_keypresses_ms(2:end),'omitnan');
        trialmeantappingspeed(i,j) = 1000/trialmeanintertime;
       
        %the below loop finds the execution time, which is computed as the
        %time between the first key press of the sequence to the first key
        %press of the next sequence
        
        if ismember(j,ntrial)
            if j < max(ntrial)
                trialtime(i,j) = milliseconds(blockvalue.keypress_timestamp(nkeys*k+1)-blockvalue.keypress_timestamp(nkeys*k-(nkeys-1)));
                k = k+1;
            else
                trialtime(i,j) = milliseconds(blockvalue.keypress_timestamp(end)-blockvalue.keypress_timestamp(end-(nkeys-1)));
            end
        else
            trialtime(i,j) = NaN;
        end
        exectime = nancumsum(trialtime,2,2);
    end
end
%% 
nseq = size(trialmeantappingspeed,2);
timearray = zeros(nblock,trialduration);
prevtappingspeed = 0;

for i = 1:nblock
    startindx = 1;endindx = 0;flag = 0;
    for j = 1:nseq
        if(~isnan(trialmeantappingspeed(i,j)) && flag==0) %When rows don't start with a NaN
            %If tappingspeed is specified, need to assign the tapping speed
            endindx = exectime(i,j);
            timearray(i,startindx:endindx)=trialmeantappingspeed(i,j);
            prevtappingspeed = trialmeantappingspeed(i,j);
            startindx = exectime(i,j)+1;
            
        elseif(~isnan(trialmeantappingspeed(i,j)) && flag==1) %If a prev NaN block existed in that row,all data is now offset by 1
            if(j<nseq && ~isnan(trialmeantappingspeed(i,j+1))) %Check if the next value in the row is not NaN
                endindx = exectime(i,j+1);
                timearray(i,startindx:endindx)=trialmeantappingspeed(i,j);
                prevtappingspeed = trialmeantappingspeed(i,j);
                startindx = exectime(i,j+1)+1;
                
            else
                prevtappingspeed = trialmeantappingspeed(i,j); %If current value is valid, just update tapping speed
            end
            
        else %Current value is NaN
            if(j<nseq && ~isnan(trialmeantappingspeed(i,j+1))) %Check if the next value in the row is not NaN
                endindx = exectime(i,j+1);
                timearray(i,startindx:endindx)=prevtappingspeed;
                startindx = exectime(i,j+1)+1;
                flag = 1; %Flag is set to indicate that there is a NaN
                
            end
            
            
        end
    end
    timearray(i,startindx:trialduration) = prevtappingspeed;    

end
timearray = [timearray nan(nblock,trialduration)];

% 
%% reshape array and plot individual data
keypressvisual = timearray';
keypressvisual = reshape(keypressvisual,1,[]);
maxtappingspeed(z,1) = nanmax(keypressvisual);
keypressvisualarray(z,:) = keypressvisual;
subplot(nsubjects,1,z); plot(keypressvisual,'LineWidth',2);
ylim([0 15]);
end
%% plot ensemble average of all subjects
ensembleaverage = nanmean(keypressvisualarray,1);
figure; plot(ensembleaverage,'LineWidth',2);
ax = gca; 
ax.FontSize = 14;
ylabel('Tapping Speed (keypress/s)','FontSize',16,'FontWeight','bold');
xlabel('Time (ms)','FontSize',16,'FontWeight','bold');
ylim([0 1.2*nanmax(ensembleaverage)]);
if side == left
    title('Left Ensemble Average','FontSize',18);
else
    title('Right Ensemble Average','FontSize',18);
end
