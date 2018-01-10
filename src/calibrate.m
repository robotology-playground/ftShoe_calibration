clear all;
close all;

addpath(genpath('../ext'));

%% Load and run acquisition parameters
run('../conf/parameters_right_26bis092017.m')
%run('../conf/parameters_left_26bis092017.m')

%% Compute mean of the static offset for both shoes and forceplates
run('estimateOffset.m')


%% Remove static offset and change referenec frames 
params.removeOffset = true;
params.calibrationInputVarName = 'calibIn';
for e = 1 : size(params.expList,2)
     % Remove static offset
    expDataset.(params.expList{e}) = read_experiment_data(params.acqPath, params.expList{e}, params);
    if params.removeOffset
        params.calibrationInputVarName = 'noOffset';
        expDataset.(params.expList{e}).(params.calibrationInputVarName) = remove_static_offset(expDataset.(params.expList{e}).('filt'), params.staticOffsets, false);
    end
    if ~params.removeOffset
            params.removeOffset
        params.calibrationInputVarName = 'calibIn';
        expDataset.(params.expList{e}).(params.calibrationInputVarName) = remove_static_offset(expDataset.(params.expList{e}).('filt'), params.staticOffsets, true);
    end
    
    % Transform the forceplates measurement in shoes reference frames
    expDataset.(params.expList{e}).(params.calibrationInputVarName).('amtiInFtsSoR') = change_sor(expDataset.(params.expList{e}).(params.calibrationInputVarName).('amti'), params);
    preCalibrationDataset.(params.expList{e}).amtiInFtsSoR = expDataset.(params.expList{e}).(params.calibrationInputVarName).amtiInFtsSoR;
    preCalibrationDataset.(params.expList{e}).fts = expDataset.(params.expList{e}).(params.calibrationInputVarName).fts;
end

%% Generate plot and stats pre calibration%
% names = {'ForeFoot', 'Heel'};
% stats = generate_plots_and_stats(preCalibrationDataset, 'False', params.acqPath, 'PreCalibration_sg', names, 'False');

%% Verify sensors matching
ftsNames = params.ftsNames;
amtiNames = params.amtiNames;
if size(ftsNames,2) ~= size(amtiNames,2)
    disp('[ERROR] Size of experimental devices mismatch! Check data!')
    return
end

% Proper order match is a requirement for all the procedure
for d = 1 : size(ftsNames,2)
    calibDataset.inputs.fts.(ftsNames{d}).data = [];
    calibDataset.inputs.amtiInFtsSoR.(amtiNames{d}).data = [];
end

%% Piling trials
% Need to pile one after the othertrials for one shot calibratio. It works 
% if more than 2 trials are used for the calibration, but the procedure is 
% robust enought also for a single trial.

for e = 1 : size(params.calibExpList,2)
    %% Remove the datasheet matrix calibration from signals --> here after the data can be cosidered 'raw-raw'
    [calibDataset.(params.calibExpList{e}).('fts'), calibDataset.wbCalibMatrices] = get_raw_fts_data(preCalibrationDataset.(params.calibExpList{e}).fts, params);
    for d = 1 : size(ftsNames,2)
        calibDataset.inputs.fts.(ftsNames{d}).data = [calibDataset.inputs.fts.(ftsNames{d}).data; calibDataset.(params.calibExpList{e}).fts.(ftsNames{d}).data];
        calibDataset.inputs.amtiInFtsSoR.(amtiNames{d}).data = [calibDataset.inputs.amtiInFtsSoR.(amtiNames{d}).data; preCalibrationDataset.(params.calibExpList{e}).amtiInFtsSoR.(amtiNames{d}).data];
    end
end

% [Note] At this step we have:
% data forceplates: - filtered
%                   - in shoes reference frames
%                   - with offset removed
% data shoes: - filtered
%             - in their reference frames
%             - with offset removed
%             - in raw-raw form

%% Add fake time to amti calibration data
for d = 1 : size(amtiNames,2)
    calibDataset.inputs.amtiInFtsSoR.(amtiNames{d}).time = 0:0.01:0.01*(size(calibDataset.inputs.amtiInFtsSoR.(amtiNames{d}).data,1)-1);
end

%% Run the calibration (from inSitu-ft-analysis repo)
[calibDataset.estCalibMatrices, calibDataset.estOffsets, calibDataset.estFullScale] = ...
         estimate_matrices_and_offsets(calibDataset.inputs.fts, ...
                                       calibDataset.inputs.amtiInFtsSoR, ...
                                       calibDataset.wbCalibMatrices, ...
                                       2, ...
                                       ftsNames, amtiNames);

%% Reprocess all raw fts data with new estimates for calibration matrices
postCalibrationDataset.calibInputs.amtiInFtsSoR = calibDataset.inputs.amtiInFtsSoR;
postCalibrationDataset.calibInputs.fts = reprocess_raw_fts_data(calibDataset.inputs.fts, ...
        calibDataset.estCalibMatrices, calibDataset.estOffsets);

for e = 1 : size(params.expList,2)
    [expDataset.(params.expList{e}).raw.fts, ~] = get_raw_fts_data(preCalibrationDataset.(params.expList{e}).fts, params);
    postCalibrationDataset.(params.expList{e}).amtiInFtsSoR = preCalibrationDataset.(params.expList{e}).amtiInFtsSoR;
    postCalibrationDataset.(params.expList{e}).fts = reprocess_raw_fts_data(expDataset.(params.expList{e}).raw.fts, ...
        calibDataset.estCalibMatrices, calibDataset.estOffsets);
end

%% Generate plot and stats post calibration
close all

names = {'ForeFoot', 'Heel'};
stats = generate_plots_and_stats(postCalibrationDataset, 'False', params.acqPath, 'PostCalibration_sg', names,'False');

%% Generate Calibration matrices to be used in ftShoe driver
for s = 1:size(ftsNames,2)
   calibMatricesDriver.(ftsNames{s}) = calibDataset.estCalibMatrices.(ftsNames{s})/(calibDataset.wbCalibMatrices.(ftsNames{s}));
end

save('matrices_right.mat', 'calibMatricesDriver')
%save('matrices_left.mat', 'calibMatricesDriver')
