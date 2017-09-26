function [ outdata ] = reprocess_raw_fts_data( indata, calibMatrices, calibOffsets )

devs = fieldnames(indata);
for d = 1 : size(devs)
    if exist('indata.(devs{d}).time','var') == 1
        outdata.(devs{d}).time = indata.(devs{d}).time;
    else
        outdata.(devs{d}).time = 0:0.01:0.01*(size(indata.(devs{d}).data,1)-1);
    end

    outdata.(devs{d}).data = zeros(size(indata.(devs{d}).data));
     for t = 1 : size(indata.(devs{d}).data,1)
         outdata.(devs{d}).data(t,:) = (calibMatrices.(devs{d}) * ...
             (indata.(devs{d}).data(t,:))' + calibOffsets.(devs{d}))';
     end
end
end
