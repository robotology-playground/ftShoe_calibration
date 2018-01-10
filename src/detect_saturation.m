function [ saturation ] = detect_saturation( data )
%DETECT_SATURATION finds if in the signal there is a 'hole' during teh
% acquisition.  

saturation = 'False'; 
ftsNames = fieldnames(data);
ftsNames
T = data.(ftsNames{1}).('time')(2) - data.(ftsNames{1}).('time')(1);

for k=1:length(ftsNames)
    for t = 2 : length(data.(ftsNames{k}).('time'))
        if (data.(ftsNames{k}).('time')(t) - data.(ftsNames{k}).('time')(t-1) > 1.5*T)
            saturation = 'True';
            disp('[WARNING]: saturation detected in the signal!');
            return
        end
    end
end

end
