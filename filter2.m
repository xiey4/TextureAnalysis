dname = 'D:\Myositis\';
load('sub_roi');
for r = 2:14
name = sprintf('P%d.mat',r);
filename = sprintf('P%d',r);
load([dname name]);

% Pick one ... (sub whoever, t2w)
im = sub.t2w.Data;
sample = im(:,:,6); % use the mid slice for image sampling
% Create arrays of sampled tissue values { using vuOnePaneViewer(im), Data values cursor }
% figure(1);imagesc(sample);colormap(gray);title('circle leg');
roi = sub_roi(:,:,r);
sample=sample.*roi;
figure(1);imagesc(sample);colormap(gray);title('original T2w, first muscle');
% pixel_muscle = impixel;% select 10 muscle samples
% muscle = pixel_muscle(1:10,1);
% pixel_fat = impixel;% select 10 fat samples
% fat = pixel_fat(1:10,1);
% 
% % Create mean and std array
% meanArray = [mean(muscle) mean(fat)];
% stdArray = [std(muscle) std(fat)];

% Run Correction
options.MaskThres = 200;
%
%[newim,mask] = vuParametricBiasFieldCorrection(sample, meanArray, stdArray, options);
[newim,mask] = vuLowPassBiasFieldCorrection(sample, options);
% this one is the new image
figure(2);imagesc(newim);colormap(gray);title(['corrected T2w ',name]);

% evaluation
figure(3);imagesc(newim);colormap(gray);title('cover all tissue');
roin = bwmorph(roi,'erode');
% patients corrected
fign1 = roin.*newim;
figure(4);imagesc(fign1);
peel1 = newim.*roi - fign1;
vec1 = peel1(:);vec1 = vec1(vec1>0);
%patients sample
fign2 = roin.*sample;
figure(5);imagesc(fign2);
peel2 = sample.*roi - fign2;
vec2 = peel2(:);vec2 = vec2(vec2>0);
% saving
%save(filename, 'sample','newim','mask','vec1','vec2')  % EDITED
save(filename, 'sample','newim','mask','vec1','vec2','roi')  % EDITED
close all
end