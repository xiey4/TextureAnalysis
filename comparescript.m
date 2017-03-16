
dname = 'D:\Myositis\';
load('sub_roi');
for r = 3:3
name = sprintf('P%d.mat',r);
filename = sprintf('P%d',r);
load([dname name]);

% Pick one ... (sub whoever, t2w)
origin = sub.t1w.Data(:,:,6);

% Create arrays of sampled tissue values { using vuOnePaneViewer(im), Data values cursor }
%figure(1);imagesc(sample);colormap(gray);title('circle leg');

figure(1);imagesc(sample);colormap(gray);title('original T2w');
roi = roipoly;

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