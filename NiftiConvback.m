% load original image and write them into nifti
dname = 'C:\Users\ralph_000\Documents\MATLAB\N4BiasCorrected\';
load('roi_P2w_peel.mat');
cor_over_ori = zeros(1,14);
for r = 2:14
    % name = sprintf('C%d_N4BIAS.nii',r);
    % filename = sprintf('C%d_N4BIAS',r);
    name = sprintf('P%d_N4BIAS.nii',r);
    filename = sprintf('P%d_N4BIAS',r);
    
    nameori = sprintf('P%d.mat',r);
    load(['D:\Myositis\',nameori]);
    
    V = vuOpenImage([dname name]);
    
    % Pick one ... (sub whoever, t2w)
    sample = V.Data(:,:,6);
    % use the mid slice for image sampling
    % Create arrays of sampled tissue values { using vuOnePaneViewer(im), Data values cursor }
    figure(1);subplot(2,2,1);imagesc(sample);colormap(gray);title('corrected');
    subplot(2,2,2);imagesc(sub.t2w.Data(:,:,6));title('original');
    subplot(2,2,3);imagesc(A(:,:,r));
    
    % compare peeled off part of both img
    % corrected
    peelc = A(:,:,r).*sample;
    vec1 = peelc(peelc>0);
    % origin
    peelo = A(:,:,r).*sub.t2w.Data(:,:,6);
    vec2 = peelo(peelo>0);
    coev_c = std(vec1)/mean(vec1);
    coe_o = std(vec2)/mean(vec2);
    
    cor_over_ori(r) = coev_c/coe_o;
    % pause
    %     save(filename, 'sample');
end