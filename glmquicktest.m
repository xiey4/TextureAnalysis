close all; clear all;
test1_m = readtable('test1.xlsx');
d_test1 = table2array(test1_m);
y = d_test1(:,4);
dmatrix = d_test1(:,1:3);
%% first test distribution see if it's normal
figure(1)
subplot(1,3,1);
qqplot(y) % normal
title('sample vs standard normal distribution');
k = makedist('Poisson'); % Poisson
subplot(1,3,2);
qqplot(y,k);
title('sample vs Poisson distribution');
k = makedist('Binomial'); % Binomial
subplot(1,3,3);
qqplot(y,k);
title('sample vs Binomial distribution');
% so it seems to be normal
%% then fixed and mixed analysis
glme_fxd = fitglme(test1_m,'ffat ~ 1 + lgre');
glme_mxd = fitglme(test1_m,'ffat ~ 1 + lgre + (1|patient) +(1|muscle)');
%% plot the design table
for t = 1:3
    dmatrix_n(:,t) = dmatrix(:,t)./max(dmatrix(:,t));
end
%%
figure(2)
imagesc(dmatrix_n); colormap gray;
title('design matrix for mixed effect analysis'); 