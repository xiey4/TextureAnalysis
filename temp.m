Control = zeros(512,512,17);
for r = 1:17
    eval(['load C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\C' num2str(r) '_N4BIAS.mat']);
Control(:,:,r) = double(sample);
end

save C_correct Control