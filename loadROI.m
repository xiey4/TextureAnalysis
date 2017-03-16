dname = 'C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\';

k = 1;
for r = 2:14
    k = k+1;
name = sprintf('P%d.mat',r);

load([dname name],'roi');
sub_roi(:,:,k) = roi;
end

for c =1:5
    k = k+1;
name = sprintf('C%d.mat',c);

load([dname name],'roi');
sub_roi(:,:,k) = roi;
end
save('sub_roi','sub_roi');