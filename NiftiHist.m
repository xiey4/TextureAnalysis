% load original image and write them into nifti
dname = 'C:\Users\ralph_000\Documents\MATLAB\N4BiasCorrected\';

for r = 2:14
% name = sprintf('C%d_N4BIAS.nii',r);
% filename = sprintf('C%d_N4BIAS',r);
name = sprintf('P%d_N4BIAS.nii',r);
filename = sprintf('P%d_N4BIAS',r);
hist_str = sprintf('P%d_fullhist',r);
V = vuOpenImage([dname name]);

% Pick one ... (sub whoever, t2w)
sample = V.Data(:,:,6);
% use the mid slice for image sampling
% Create arrays of sampled tissue values { using vuOnePaneViewer(im), Data values cursor }
figure(1);imagesc(sample);colormap(gray);title('example');

pause

% save(filename, 'sample');
% stage 1 loading the file completed; stage 2 - fitler signals and create
% 1. whole histogram 2. no outer fat histogram 3.specific muscle histogram 
% 4. specific muscle fat fraction
collect = double(sample);
collect = collect(collect>500);
figure(2)
hist(collect,512);
[N,X] = hist(collect,512);
% comparison
% load(['D:\Myositis\P%d.mat'],);
eval(['load D:\Myositis\P' num2str(r) '.mat'])
origin = sub.t2w.Data(:,:,6);
subplot(1,2,1);imagesc(origin);
collect2 = origin(origin>500);
subplot(1,2,2);hist(collect2,64);
end