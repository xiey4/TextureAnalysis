close all; clear all;
eval(['load D:\Myositis\C4.mat']);
im_m= double(sub.t2w.Data(:,:,6));
n = 256;
im_m = imresize(im_m,[256,256]);
figure(1);
imagesc(im_m);
title('fat->mus->marrow->vessel->bone->bckgrd');
colormap gray
%% step 1 presample the 3 groups (muscle, fat, background)
c = 3; % 3 classes
 for k =1:c
     p_v=impixel;
     vk(k) = mean(p_v(1:4,1)); % fat, mus, bone, background, each selec 4
 end
 vk = round(vk,2);
% load('vk_null');
% vk = vk_null;

%% determine H1/H2
kernel1 = [0 -1 0;-1 4 -1;0 -1 0];
kernel2 = [0 0 1 0 0;0 2 -8 2 0;1 -8 20 -8 1;0 2 -8 2 0;0 0 1 0 0];
% kernel 3x3,5x5 to 65535x65535
H1 = sparse(256^2,256^2);
H2 = sparse(256^2,256^2);
for i=1:65536 % construct H1
    H1(i,i)=4;
    % same row
    l =i-1;r = i+1;
    if mod(i,256) ==1 % left edge
        l = i+255; % switch to right edge
    end
    H1(i,l)=-1; %left
    if mod(i,256)==0 % right edge
        r = i-255; % switch to left edge
    end
    H1(i,r)=-1; %right
    % same col
     t = i-256;b=i+256;
     if t < 1 % top row
         t = t+256*255; % switch to bottom row
     end
     H1(i,t)=-1; %top
     if b > 65536 % bottom row
         b = b-256*256; % top row
     end
     H1(i,b)=-1; %bottom
end

%% step 2-4 start iteration by calculating membership functions
q = 2;% q is commonly set at 2
l1 = 2*10^4;
l2 = 2*10^5; % reference table 2
yj = im_m.';
yj_v = yj(:); % create yj, column vector of all real intensities 
gainf_v = ones(size(yj_v)); % initial gain set at 1 for each pixel
uj_v = zeros(size(yj_v)); % initial membership function for each class
uj_m = zeros(length(yj_v),c); % a matrix that stores all membership function based on class
uj_diff = 1; % jump start the while loop, maximum change of membership function is 1
vk_diff = [0 0 0]; % monitor centroid changes

%vk = vk_null; % testing only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% iteration starts here
trials = 0;
while uj_diff>=0.01 
    trials = trials+1;
abr = -2/(q-1);
uj_m_pre = uj_m; % membership function from last iteration
vk_pre = vk; % centroids from last iteration
gainfnew_v = gainf_v; % gainfield from last iteration
for k = 1:c % each class
    for i = 1:65536
        uj_v(i) = norm(yj_v(i) - gainf_v(i)*vk(k)).^abr; % calculated for each class
    end
    %disp(['number of inf pts are ',num2str(sum(sum(isinf(uj_m))))]);
    uj_m(:,k) = uj_v;
end
% normalize
uj_m_sum = sum(uj_m,2);
for i = 1:65536
    uj_m(i,:)=uj_m(i,:)./uj_m_sum(i);
end
uj_diff = max(max(abs(uj_m-uj_m_pre))); %%%%%%%%%%%%%%%%%%%%%%% max membership function variation

% step 3 update centroids

for k = 1:c
    numerator = sum((uj_m(:,k).^q).*gainf_v.*yj_v);
    denominator = sum((uj_m(:,k).^q).*gainf_v.*gainf_v);
    vk(k)=numerator./denominator;
end
vk_diff = abs(vk - vk_pre);%%%%%%%%%%%%%%%%%%%%%%% max centroid variation

% step 4 solution to the gain field
% part a construct all things
for k = 1:c
    wj_m(:,k) = (uj_m(:,k).^q).*vk(k).*vk(k);
    fj_m(:,k) = (uj_m(:,k).^q).*yj_v.*vk(k);% missing./wj
end
wj_v = sum(wj_m,2); % wj wrt all pixels
fj_v = sum(fj_m,2)./wj_v; % fj wrt all pixels
fw_v = fj_v.*wj_v; % fw wrt all pixels

% W_m is a diagonal matrix with wj as diagonal elements
W_m = sparse(1:65536,1:65536,wj_v,65536,65536);
% I_m is the identity matrix
I_m = sparse(1:65536,1:65536,ones(65536,1),65536,65536);

% construct H1 and H2
A = W_m+l1*H1;

L_m = tril(A,-1);% lower triangular
U_m = triu(A,1);% upper triangular
D_m = A-L_m-U_m;% diagonal

wght = 0.3;

gainfnew_v = ((1-0.3).*I_m +0.3.*inv(D_m)*(L_m+U_m))*gainf_v+0.3*D_m\fw_v;
end

%% image reconstruction
n=256; % size, assume square image
j = n^2; % total pixel numbers, assume 2D image

im_recon = zeros(size(im_m));
uj_recon1 = im_recon;
uj_recon2 = im_recon;
for t = 1:n
    a = (t-1)*n+1;
    b = t*n;
    im_recon(t,:)=yj_v(a:b);
    uj_recon1(t,:)=uj_m(a:b,1);% class 1 membership function image, fat
    uj_recon2(t,:)=uj_m(a:b,2);% class 2 membership function image, muscle
    uj_recon3(t,:)=uj_m(a:b,3);
    %uj_recon4(t,:)=uj_m(a:b,4);
    %uj_recon5(t,:)=uj_m(a:b,5);
    %uj_recon6(t,:)=uj_m(a:b,6);
end

figure(2);
subplot(1,3,1);
imagesc(uj_recon1); colormap gray; colorbar;
title(['fat membership image at ' num2str(trials) ' iteration']);
subplot(1,3,2);
imagesc(uj_recon2); colormap gray; colorbar;
title(['muscle membership']);
subplot(1,3,3);
imagesc(uj_recon3); colormap gray; colorbar;
title(['background membership']);
% figure(2);
% subplot(2,3,1);
% imagesc(uj_recon1); colormap gray; colorbar;
% title(['fat membership image at ' num2str(trials) ' iteration']);
% subplot(2,3,2);
% imagesc(uj_recon2); colormap gray; colorbar;
% title(['muscle membership']);
% subplot(2,3,3);
% imagesc(uj_recon3); colormap gray; colorbar;
% title(['bone marrow membership']);
% subplot(2,3,4);
% imagesc(uj_recon4); colormap gray; colorbar;
% title(['blood vessel membership']);
% subplot(2,3,5);
% imagesc(uj_recon5); colormap gray; colorbar;
% title(['bone membership']);
% subplot(2,3,6);
% imagesc(uj_recon6); colormap gray; colorbar;
% title(['background membership']);