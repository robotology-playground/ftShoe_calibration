function [ outdata ] = change_sor( indata, params )

    devs = fieldnames(indata);
        for d=1 : length(devs)
            outdata.(devs{d}).('time') = indata.(devs{d}).('time');
            outdata.(devs{d}).('data') = zeros(size(indata.(devs{d}).('data')));
            forces = indata.(devs{d}).('data')(:,1:3);
            moments = indata.(devs{d}).('data')(:,4:6);
            forcesInFtsSoR = ((params.amtiInFts_rot{d})'*forces')';
            outdata.(devs{d}).('data')(:,1:3) = forcesInFtsSoR;
            tmp = zeros(size(moments));
            for t =1:length(moments)
                tmp(t,:) = cross((params.amtiInFts_trasl{d})', forcesInFtsSoR(t,:)')';
            end
            
            momentsInFtsSoR = ((params.amtiInFts_rot{d})'* moments')' + tmp;
            outdata.(devs{d}).('data')(:,4:6) = momentsInFtsSoR;
        end
end
