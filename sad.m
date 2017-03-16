A = zeros(512,512,14);
for r = 2:14
    nameori = sprintf('P%d.mat',r);
    load(['D:\Myositis\',nameori]); 
    imagesc(sub.t2w.Data(:,:,6));title('original');
    roi = roipoly;
    roin = roi - bwmorph(roi,'erode');
    A(:,:,r) = roin;
end

save roi_P2w_peel A