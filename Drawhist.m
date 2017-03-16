% C%d_fullhist - histogram of the entire image (threshold cuts off noise)
% C%d_mushist - histogram of all muscles (without subcutaneous fat)
% C%d_VLhist - histogram of VL from patient 5,6,7,10 vs. sum of ff in VL
for r = [5,6]
    name = sprintf('C%d_N4BIAS.mat',r);
    nameori = sprintf('C%d.mat',r);
    nameh = sprintf('C%d_VLhist',r);
    load(name);
    load(['D:\Myositis\',nameori]);
    sample = double(sample);
    figure(1)
    imagesc(sample); colormap gray;
    roi = roipoly();
    dat = sample.*roi;
    dat = dat(dat>20);
    figure(2)
    hist(dat,64);
    [N,X] = hist(dat,64);
    
    % fat frac
    dix6 = sub.dixon6.fat(:,:,6);
    dix6 = imresize(dix6,[512,512]);
    ff = mean(dix6.*roi);
    pause
    save(nameh, 'N','X','roi','dix6','ff');
    % bar(X,N) can recreat the histogram
end