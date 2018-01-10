function [ outdata ] = change_sor( indata, params )

    devs = fieldnames(indata);
        for d=1 : length(devs)
            outdata.(devs{d}).('time') = indata.(devs{d}).('time');
            outdata.(devs{d}).('data') = zeros(size(indata.(devs{d}).('data')));
            
            for t = 1 : size(indata.(devs{d}).('data'),1)
                data_sample = indata.(devs{d}).('data')(t,:);
                outdata.(devs{d}).('data')(t,:) = (params.fts_T_fp{d}.asAdjointTransformWrench().toMatlab()*data_sample')';
            end
        end
end
