load('C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\P6.mat');
%load('C:\Users\ralph_000\Desktop\Dr.DamonLabWork\trial1\P6_n.mat');
load('D:\Myositis\P6.mat');
figure(1);imagesc(sample.*roi);colormap(gray);
figure(2);imagesc(newim.*roi);colormap(gray);
figure(3);imagesc(sub.B1map.Data(:,:,28));
imageB1 = sub.B1map.Data(:,:,28).*roib1;