function [ estCalibMatrices, estOffsets, estFullScales ] = estimate_matrices_and_offsets( rawFtsData, expData, wbCalibMatrices, lambda, ftsNames, amtiNames )

% rawFtsData = shoes
% expData = pedane
% wbCalibMatrices = calib matrices both fts
% lambda = regularization parameter

for d=1 : length(ftsNames)
    meanFts = mean(rawFtsData.(ftsNames{d}).data);
    meanExp = mean(expData.(amtiNames{d}).data);
    noMeanFts = rawFtsData.(ftsNames{d}).data - repmat(meanFts,size(rawFtsData.(ftsNames{d}).data,1),1);
    noMeanExp = expData.(amtiNames{d}).data - repmat(meanExp,size(expData.(amtiNames{d}).data,1),1);
    [estCalibMatrices.(ftsNames{d}), estFullScales.(ftsNames{d})] = ...
        estimateCalibMatrixWithReg(noMeanFts, noMeanExp, wbCalibMatrices.(ftsNames{d}), lambda);
    estOffsets.(ftsNames{d}) = meanExp'- estCalibMatrices.(ftsNames{d}) * meanFts';
end
end
