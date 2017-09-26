function dataset = read_experiment_data(acqPath, experimentName, params)
%READ_EXPERIMENT_DATA is a function that:
% - reads data dumped from YARP
% - remove tails that are presente in the signal due to YARP lag
% - detects if the signal it is saturated

    experimentName
    if (exist(strcat(acqPath,'/preprocData/',experimentName,'.mat'),'file')==2)
        %% Load to workspace preprocessed data previously saved
        load(strcat(acqPath,'/preprocData/',experimentName,'.mat'),'dataset')

    else

        rawDataset.highestStartTime = 0;
        rawDataset.lowestEndTime = 1e25;

        ftDataPath=strcat(acqPath, '/', params.ftsPortName);
        amtiDataPath=strcat(acqPath, '/', params.amtiPortName);

        expDataFileName = strcat(experimentName, '/data.log');

        rawDataset.ftsData = cell(size(params.ftsNames));
        rawDataset.ftsTime = cell(size(params.ftsNames));

        rawDataset.ftsNames = params.ftsNames;
        for i=1:size(params.ftsNames,2)
            dataFileName=strcat(ftDataPath, '/', params.ftsNames{i},'/',expDataFileName);
            [rawDataset.ftsData{i},rawDataset.ftsTime{i}]=readDataDumper(dataFileName);
            if rawDataset.highestStartTime < rawDataset.ftsTime{i}(1)
                rawDataset.highestStartTime = rawDataset.ftsTime{i}(1);
            end
            if rawDataset.lowestEndTime > rawDataset.ftsTime{i}(end)
                rawDataset.lowestEndTime = rawDataset.ftsTime{i}(end);
            end
        end

        rawDataset.amtiData = cell(size(params.amtiNames));
        rawDataset.amtiTime = cell(size(params.amtiNames));

        rawDataset.amtiNames = params.amtiNames;
        for i=1:size(params.amtiNames,2)
            dataFileName=strcat(amtiDataPath, '/', params.amtiNames{i},'/',expDataFileName);
            [rawDataset.amtiData{i}, rawDataset.amtiTime{i}]=readDataDumper(dataFileName);
            if rawDataset.highestStartTime < rawDataset.amtiTime{i}(1)
                rawDataset.highestStartTime = rawDataset.amtiTime{i}(1);
            end
            if rawDataset.lowestEndTime > rawDataset.amtiTime{i}(end)
                rawDataset.lowestEndTime = rawDataset.amtiTime{i}(end);
            end
        end

        %% Remove tails due to non common dumping start and end
        dataset.('orig') = remove_tails(rawDataset);
        
        %% Detect saturation and, if present, set to true the saturationError variable
        dataset.ftsSaturation = detect_saturation(dataset.('orig').('fts'));
        
        %% TODO: Handle the saturation

        % If no saturation detected, continue
%         if(dataset.ftsSaturation == 'False')
        %% Filter data with Zero-lag Butterworth filter -->Sgolay
        dataset.('filt') = filter_force_torque_data_sgolay(dataset.('orig'));
%         end
    end
end