function [ outdata ] = reprocess_raw_fts_data( indata, calibMatrices, calibOffsets )

devs = fieldnames(indata);
for d = 1 : size(devs)
    outdata.(devs{d}).time = indata.(devs{d}).time;

    outdata.(devs{d}).data = zeros(size(indata.(devs{d}).data));
    for t = 1 : size(indata.(devs{d}).data,1)
        outdata.(devs{d}).data(t,:) = (calibMatrices.(devs{d}) * ...
            (indata.(devs{d}).data(t,:))' + calibOffsets.(devs{d}))';
    end
end
end
