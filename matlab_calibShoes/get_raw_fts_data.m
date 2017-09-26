function [ outdata, calibMatrices ] = get_raw_fts_data( indata, params )

    devs = fieldnames(indata);
        for d=1 : length(devs)
            calibFile = strcat(params.calibMatPath,'/matrix_', params.ftsSerialNumbers{d},'.txt' );
            if (exist(strcat(calibFile),'file')==2)
                calibMatrices.(devs{d})=readCalibMat(calibFile);
                outdata.(devs{d}).('time') = indata.(devs{d}).('time');
                outdata.(devs{d}).('data') = zeros(size(indata.(devs{d}).('data')));
                for j=1:size(outdata.(devs{d}).('data'),1)
                    outdata.(devs{d}).('data')(j,:)=calibMatrices.(devs{d})\indata.(devs{d}).('data')(j,:)';
                end
            else
                disp('[ERROR] Calibration Matrix file not found!')
                 return
            end
        end
end