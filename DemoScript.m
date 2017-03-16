load('P6.mat');
figure(1);imagesc(sample);colormap(gray);
figure(2);imagesc(newim);colormap(gray);
%subplot(2,2,3);imagesc(mask);
% if exist('roi','var')
% subplot(2,2,4);imagesc(roi);
% end

before = std(vec2)/mean(vec2)*100
after = std(vec1)/mean(vec1)*100
%before = std(vec2)
%after = std(vec1)
