% Script to estimate offset during the static trial for both the shoes and
% the forceplates.

%% load experimental setup parameters, save to workspace a param struct
%run('parameters.m')

%params.staticOffsetAcqPath = './data/tmp';

staticTrialData.(params.staticOffsetExp) = ...
    read_experiment_data(params.staticOffsetAcqPath, params.staticOffsetExp, params);

for k = 1 : size(params.ftsNames,2)
   params.staticOffsets.('fts').(params.ftsNames{k}) = ...
       mean(staticTrialData.(params.staticOffsetExp).('orig').('fts').(params.ftsNames{k}).('data'));
end

for k = 1 : size(params.amtiNames,2)
   params.staticOffsets.('amti').(params.amtiNames{k}) = ...
       mean(staticTrialData.(params.staticOffsetExp).('orig').('amti').(params.amtiNames{k}).('data'));
end

clearvars -except params
