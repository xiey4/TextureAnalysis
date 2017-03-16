dname = 'D:\Myositis\';

r = 3;
name = sprintf('P%d.mat',r);
filename = sprintf('P%d',r);
load([dname name]);

TI=[50, 100, 200, 500, 1000, 2000, 6000]';
PD=1500;
T1map=zeros(128,128);
S0map=zeros(128,128);
Sfmap=zeros(128,128);
threshold=mean(mean(sub.sirT1.Data(:, :, 5, 1, 7)));
for r=1:128
    for c=1:128
        if sub.sirT1.Data(r, c, 5, 1, 7)>threshold
            signal=double(squeeze(sub.sirT1.Data(r, c, 5, 1, :)));
            ie=[signal(7) 1300 0.75];
            fe = lsqcurvefit('t1_ir_pd', ie, TI, signal, [.8*ie(1) 250 .25], [2*ie(1) 2000 2]);
            T1map(r,c)=fe(2);
            S0map(r,c)=fe(1);
            Sfmap(r,c)=fe(3);
        end
    end
end
S0map_512=imresize(S0map, [512 512]);
S0map_512=S0map_512/max(max(S0map_512));
figure(1),imagesc(S0map_512)
corrected_t1w=sub.t1w.Data(:,:,6)./S0map_512;
corrected_t1w(isinf(corrected_t1w))=0;
corrected_t1w(isnan(corrected_t1w))=0;
corrected_t1w(corrected_t1w>1*10^5) = 1*10^5;
corrected_t1w(corrected_t1w<0) = 0;
corrected_t1w = double(corrected_t1w);
%%
figure(2)
% subplot(1,2,1)
imagesc(sub.t1w.Data(:,:,6))

% subplot(1,2,2)
figure(3)
imagesc(corrected_t1w)  %adjust colormap as needed