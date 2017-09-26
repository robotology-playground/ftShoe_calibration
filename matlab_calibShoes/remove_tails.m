function [ data ] = remove_tails( rawDataset )
%REMOVE_TAILS removes tails from signals that have been introducted by lag 
% in YARP. The output 'Data' contains signal with the same length.

lengths = [];
for k=1:length(rawDataset.ftsNames)
    startI = find(rawDataset.ftsTime{k} - rawDataset.highestStartTime <= 1e-9);
    endI = find(rawDataset.ftsTime{k}-rawDataset.lowestEndTime >= -1e-9);
    data.('fts').(rawDataset.ftsNames{k}).('data') = rawDataset.ftsData{k}(max(startI):min(endI), :);
    data.('fts').(rawDataset.ftsNames{k}).('time') = rawDataset.ftsTime{k}(max(startI):min(endI), :);
    lengths = [lengths; length(data.('fts').(rawDataset.ftsNames{k}).('time'))];
end

for k=1:length(rawDataset.amtiNames)
    startI = find(rawDataset.amtiTime{k} - rawDataset.highestStartTime <= 1e-9);
    endI = find(rawDataset.amtiTime{k}-rawDataset.lowestEndTime >= -1e-9);
    data.('amti').(rawDataset.amtiNames{k}).('data') = rawDataset.amtiData{k}(max(startI):min(endI), :);
    data.('amti').(rawDataset.amtiNames{k}).('time') = rawDataset.amtiTime{k}(max(startI):min(endI), :);
    lengths = [lengths; length(data.('amti').(rawDataset.amtiNames{k}).('time'))];
end

minSampleN = min(lengths);
for k=1:length(rawDataset.amtiNames)
    data.('amti').(rawDataset.amtiNames{k}).('data') = data.('amti').(rawDataset.amtiNames{k}).('data')(1:minSampleN, :);
    data.('amti').(rawDataset.amtiNames{k}).('time') = data.('amti').(rawDataset.amtiNames{k}).('time')(1:minSampleN, :);
end

for k=1:length(rawDataset.ftsNames)
    data.('fts').(rawDataset.ftsNames{k}).('data') = data.('fts').(rawDataset.ftsNames{k}).('data')(1:minSampleN, :);
    data.('fts').(rawDataset.ftsNames{k}).('time') = data.('fts').(rawDataset.ftsNames{k}).('time')(1:minSampleN, :);
end

end
