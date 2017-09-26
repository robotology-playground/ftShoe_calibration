function [ outdata ] = filter_force_torque_data( indata )
%FILTER_FORCE_TORQUE_DATA filters the signal by means of a Savitzy-Golay
%filter.  It implies that, within this function, the parameters of the
% filter are hard-coded (polinomial order, window).
  
% set filter SG parameters
sg.polinomialOrder = 3;
sg.window = 57;
sg.timeWaste = ((sg.window+1)/2);
    
srcs = fieldnames(indata);
for s=1 : length(srcs)
   devs = fieldnames(indata.(srcs{s}));
   for d=1 : length(devs)
       outdata.(srcs{s}).(devs{d}).('time') = indata.(srcs{s}).(devs{d}).('time');
       % get sampling time
       sg.st = indata.(srcs{s}).(devs{d}).('time')(2,1) - indata.(srcs{s}).(devs{d}).('time')(1,1);
       outdata.(srcs{s}).(devs{d}).('data') = zeros(size(indata.(srcs{s}).(devs{d}).('data')));
       for k = 1 : size(indata.(srcs{s}).(devs{d}).('data'),2)
           tmp = SgolayFilterAndDifferentiation(sg.polinomialOrder,sg.window,indata.(srcs{s}).(devs{d}).('data')(:,k)',sg.st);
           outdata.(srcs{s}).(devs{d}).('data')(:,k) = tmp(1,:)';
       end

       % remove samples fixed to zero by the SG filter (window_size+1)/2
       outdata.(srcs{s}).(devs{d}).('time') = outdata.(srcs{s}).(devs{d}).('time')(sg.timeWaste:end-sg.timeWaste,:);
       outdata.(srcs{s}).(devs{d}).('data') = outdata.(srcs{s}).(devs{d}).('data')(sg.timeWaste:end-sg.timeWaste,:);
   end
end

end
