function [data, time] = readDataDumper(s)

allData = load(s);
time = allData(:,3);
data = allData(:,4:end);

