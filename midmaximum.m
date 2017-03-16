%% BBB
clear all;close all
load('intQt'); 
load('oriQt');
load('roi_outer');
for r = 2:3
% now start analysis
close all
eval(['load D:\Myositis\P' num2str(r) '.mat']);
eval(['load C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\P' num2str(r) '_N4BIAS.mat']);

 %% get roi of the entire tissue range
figure(1);imagesc(sub.t2w.Data(:,:,6));
% roi_outer(:,:,r) = roipoly;

%% plot masked image and histogram
collect = double(sample.*roi_outer(:,:,r));
collect = collect(collect>100);
origin = sub.t2w.Data(:,:,6);
collect2 = double(origin.*roi_outer(:,:,r));
collect2 = collect2(collect2>100);

figure(2)
subplot(2,2,1);imagesc(origin.*roi_outer(:,:,r));subplot(2,2,2);hist(collect2,64); title('origin');
subplot(2,2,3);imagesc(sample.*roi_outer(:,:,r));subplot(2,2,4);hist(collect,64); title('corrected');


  %% pick interval for corrected
   figure(3)
   hist(collect,1024);
   [N,X] = hist(collect,1024);
   plot(N)
   pts = ginput(2);pts = round(pts); % first peak then lower bound
   % take the mid line and draw it
   mid = abs(diff(pts(:,2)))/2+pts(2,2);
   hold on
   plot([0 1000], [mid mid]);
   npts = ginput(2);
   %there's ur interquatile
   intQt(r)= abs(diff(npts(2,:)))
   hold off
 %% now the original
   figure(4)
   hist(collect2,1024);
   [N,X] = hist(collect2,1024);
   plot(N)
   pts = ginput(2);pts = round(pts); % first peak then lower bound
   % take the mid line and draw it
   mid = abs(diff(pts(:,2)))/2+pts(2,2);
   hold on
   plot([0 1000], [mid mid]);
   opts = ginput(2);
   oriQt(r)= abs(diff(opts(2,:)))
   hold off

% AA = N(pts(1,2):pts(1,1));
% A_ave = mean(AA)
% A_var = var(AA)
% A_kurt = kurtosis(AA)
% A_skew = skewness(AA)
pause
end

% save roi_outer roi_outer