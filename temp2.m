Patient = zeros(512,512,14);
for r = 2:14
% now start analysis
close all
eval(['load D:\Myositis\P' num2str(r) '.mat']);
eval(['load C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\P' num2str(r) '_N4BIAS.mat']);
if r ==3 || r == 7 || r == 10
    Patient(:,:,r) = sub.t2w.Data(:,:,6);
else
    Patient(:,:,r) = sample;
end
end

