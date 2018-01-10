function [ outdata ] = filter_force_torque_data( indata )

    srcs = fieldnames(indata);
    for s=1 : length(srcs)
       devs = fieldnames(indata.(srcs{s}));
       for d=1 : length(devs)
           outdata.(srcs{s}).(devs{d}).('time') = indata.(srcs{s}).(devs{d}).('time');
           outdata.(srcs{s}).(devs{d}).('data') = matfiltfilt2( ...
                indata.(srcs{s}).(devs{d}).('time')(2) - indata.(srcs{s}).(devs{d}).('time')(1), ...
                8, ...
                2, ...
                'lp', ...
                indata.(srcs{s}).(devs{d}).('data')); 
       end
    end
end

