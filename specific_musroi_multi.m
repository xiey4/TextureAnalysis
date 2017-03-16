%% draw roi of VL, save it all, then reduce image sizes to minimal necessity
clear all;close all
%load('C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\C_correct.mat');
load('C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\P_correct.mat');

% contrast, correlation, energy, homogeneity, ff, average
P_glcm = zeros([6,14]);
roi_VL=zeros(512,512,14);
dx6roi_VL = zeros(256,256,14);
%%
for r = 6:6
%for r = 1:17
    close all
    eval(['load D:\Myositis\P' num2str(r) '.mat']);
%    eval(['load D:\Myositis\C' num2str(r) '.mat']);
    % load ROI
%    eval(['load C:\Users\ralph_000\Desktop\reserachRoi\C' num2str(r) '\roi_VL_res_stack.mat']);
    eval(['load C:\Users\ralph_000\Desktop\reserach\Roi\P' num2str(r) '\roi_VL_res_stack.mat']);
    
    % get roi of target muscle -
    % VL-----------------------------------------------------------------------------------------------
    figure(1);
    colormap gray
    subplot(2,3,1);
%    imagesc(Control(:,:,r));
    imagesc(Patient(:,:,r));
    line(rois.t1w.xi*4,rois.t1w.yi*4);
    roi_VL(:,:,r)=roipoly(ones(512,512), rois.t1w.xi*4,rois.t1w.yi*4);
    %roi_VL(:,:,r)= imresize(rois.t1w.roi,[512,512]); % VL, VL, hamstring
    sample = Patient(:,:,r).*roi_VL(:,:,r);
%    sample = Control(:,:,r).*roi_VL(:,:,r);
    subplot(2,3,2);imagesc(sample);
    % not quite necessary anymore
    [rows,cols,vals] = find(sample>0);
    lx = min(rows);ux = max(rows);ly = min(cols);uy = max(cols);
    newim = sample(lx:ux,ly:uy);
    subplot(2,3,3);imagesc(newim);
    tempmax = max(max(Patient(:,:,r)));tempmin = min(min(Patient(:,:,r)));
%    tempmax = max(max(Control(:,:,r)));tempmin = min(min(Control(:,:,r)));
    %% 2nd part
    [glcm, SI] = graycomatrix(sample,'NumLevels',129,'GrayLimits',[tempmin tempmax]);
    subplot(2,3,4);imagesc(SI(lx:ux,ly:uy));colormap gray;
%    eval(['title 64binControl' num2str(r)]);
    eval(['title 16binPatient' num2str(r)]);
    % dixon6 ff change here -
    % ------------------------------------------------------------------------------------------------
   subplot(2,3,5);
    imagesc(sub.dixon6.fat(:,:,6))
    dx6roi_VL(:,:,r) = roipoly(ones(256,256), rois.dixon6.xi*2,rois.dixon6.yi*2);colormap gray;
    line(rois.dixon6.xi*2,rois.dixon6.yi*2)

    VLfat = sub.dixon6.fat(:,:,6).*dx6roi_VL(:,:,r);
    fat_f = mean(mean(VLfat(VLfat>0)));
    % crop unnecessary data
    glcm_64 = glcm(2:end,2:end);
    stats = graycoprops(glcm_64);
    subplot(2,3,6);imagesc(glcm_64);colormap gray;
    title(['P' num2str(r) ' ctst=',num2str(stats.Contrast),' crr=',num2str(stats.Correlation),' En=',num2str(stats.Energy),' Homo=',num2str(stats.Homogeneity),' ff=',num2str(fat_f)]);
    
    % save every thing
    P_glcm(1,r)=stats.Contrast;P_glcm(2,r)=stats.Correlation;P_glcm(3,r)=stats.Energy;P_glcm(4,r)=stats.Homogeneity;P_glcm(5,r)=fat_f;
    P_glcm(6,r)= mean(SI(SI>1));
   %
end

%save C_glcm_VL P_glcm
%save P_glcm_VL P_glcm
%save dx6roiC_VL dx6roi_VL
%save dx6roiP_VL dx6roi_VL
%save roiC_VL roi_VL
%save roiP_VL roi_VL
