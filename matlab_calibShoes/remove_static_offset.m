function [ noOffsetDataset ] = remove_static_offset( dataset, offsets, dummy )

    srcs = fieldnames(dataset);
    for s=1 : length(srcs)
       devs = fieldnames(dataset.(srcs{s}));
       for d=1 : length(devs)
           noOffsetDataset.(srcs{s}).(devs{d}).('time') = dataset.(srcs{s}).(devs{d}).('time');
           if dummy
               noOffsetDataset.(srcs{s}).(devs{d}).('data') = dataset.(srcs{s}).(devs{d}).('data');
           else
               noOffsetDataset.(srcs{s}).(devs{d}).('data') = dataset.(srcs{s}).(devs{d}).('data') ...
                               - repmat(offsets.(srcs{s}).(devs{d}), size(dataset.(srcs{s}).(devs{d}).('data'),1),1);
           end
       end
    end
end
