%% draw roi of VL, save it all, then reduce image sizes to minimal necessity
clear all;close all

load('C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\P_correct.mat');
%load('C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\roi_VL.mat');
load('C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\dx6roi.mat');
% contrast, correlation, energy, homogeneity
P_glcm = zeros([5,14]);
roi_BF = zeros(512,512,14);
for r = 2:14
    close all
    eval(['load D:\Myositis\P' num2str(r) '.mat']);
    % get roi of VL
    figure(1);
    
    subplot(2,2,1);imagesc(Patient(:,:,r));
    roi_BF(:,:,r)= roipoly; % RF, VM, hamstring
    %sample = Patient(:,:,r).*roi_VL(:,:,r);
    sample = Patient(:,:,r).*roi_BF(:,:,r);
    subplot(2,2,2);imagesc(sample);
    [BW,thresh]=edge(roi_BF(:,:,r));
    
    [rows,cols,vals] = find(sample>0);
    lx = min(rows);ux = max(rows);ly = min(cols);uy = max(cols);
    newim = sample(lx:ux,ly:uy);
    subplot(2,2,3);imagesc(newim);
    
    % create 64 bins
    % bin_ct = 64;
    % [N,X] = hist(newim,bin_ct);
    % bin_siz = sum(abs(X(2:bin_ct)-X(1:bin_ct-1)))/(bin_ct);
    % binimg = zeros(size(newim));
    % for t = 1:bin_ct
    %     thres = (t-1)*bin_siz;
    %     binimg = binimg+(newim>thres);
    % end
    % subplot(2,2,4);imagesc(binimg);colormap gray;
    % eval(['title 64binPatient' num2str(r)]);
    
    %% 2nd part
    %[glcm, SI] = graycomatrix(newim,'NumLevels',65);
    [glcm, SI] = graycomatrix(newim,'NumLevels',65,'GrayLimits',[]);
    subplot(2,2,4);imagesc(SI);colormap gray;
    eval(['title 64binPatient' num2str(r)]);
    % dixon6 ff
    figure(2);
    imagesc(sub.dixon6.fat(:,:,6))
    %dx6BF = roipoly;
    %dx6roi(:,:,r) = roipoly;
    BFfat = sub.dixon6.fat(:,:,6).*dx6BF;
    fat_f = mean(mean(BFfat(BFfat>0)));
    % crop unnecessary data
    glcm_a = glcm(2:end,2:end);
    stats = graycoprops(glcm_a);
    eval(['Patient' num2str(r) 'stats = graycoprops(glcm_a)']);
    figure(3);imagesc(glcm_a);colormap gray;
    title(['P' num2str(r) ' ctst=',num2str(stats.Contrast),' crr=',num2str(stats.Correlation),' En=',num2str(stats.Energy),' Homo=',num2str(stats.Homogeneity),' ff=',num2str(fat_f)]);
    
    % save every thing
    P_glcm(1,r)=stats.Contrast;P_glcm(2,r)=stats.Correlation;P_glcm(3,r)=stats.Energy;P_glcm(4,r)=stats.Homogeneity;P_glcm(5,r)=fat_f;
    pause(0.01)
end

% Contrast,Corr, Ene,Homog,ff

