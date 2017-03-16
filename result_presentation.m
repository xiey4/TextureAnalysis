close all
load('C_glcm_SM_binsiz.mat');
% P_glcm(1:6,:,:) - Contrast, Correlation, Energy, Homogeneity, Fat
% Fraction, Average bin image Intensity
figure(1)
title('Contrast vs. Fat Fraction - BF');
hold on
siz = size(P_glcm);
for i = 1:5
    plot(P_glcm(5,:,i),P_glcm(1,:,i),'*');
%     myfit = polyfit(squeeze(P_glcm(5,:,i)),squeeze(P_glcm(1,:,i)),1);
%     plot(myfit);
end
legend('binsiz8','binsiz16','binsiz32','binsiz64','binsiz128')
hold off