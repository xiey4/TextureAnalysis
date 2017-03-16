close all; clear all;
% using wout oude elferink's file
% test on all patients and controls AD
load('C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\C_correct.mat');

muscles=['VL'; 'VM'; 'VI'; 'RF'; 'SM'; 'ST'; 'BF'; 'AD'];
for kk = 1:8
    SRE_v = [];LRE_v=[];GLN_v=[];RP_v=[];RLN_v=[]; LGRE_v =[];HGRE_v=[];
for r = 1:17
    eval(['load C:\Users\ralph_000\Desktop\Roi\C' num2str(r) '\roi_' muscles(kk,:) '_res_stack.mat']);
roi=roipoly(ones(512,512), rois.t1w.xi*4,rois.t1w.yi*4);
%I = Patient(:,:,r);
 I = Control(:,:,r);
  quantize = 64;
  subplot(4,5,r); imagesc(roi);
  [SRE,LRE,GLN,RP,RLN,LGRE,HGRE]  = glrlm2(I,quantize,roi);
  SRE_v = [SRE_v,SRE];
  LRE_v = [LRE_v,LRE];
  GLN_v = [GLN_v,GLN];
  RP_v = [RP_v,RP];
  RLN_v = [RLN_v,RLN];
  LGRE_v = [LGRE_v,LGRE];
  HGRE_v = [HGRE_v,HGRE];
  pause(0.1)
end
% P_glrl_param = [SRE_v;LRE_v;GLN_v;RP_v;RLN_v; LGRE_v;HGRE_v];
 C_glrl_param = [SRE_v;LRE_v;GLN_v;RP_v;RLN_v; LGRE_v;HGRE_v];

pause(0.05)
C_rlm_8mus(:,:,kk)=C_glrl_param;
end
SRE_all_c = squeeze(C_rlm_8mus(1,:,:));
figure,
plot(SRE_all_c(:),'.')
%save C_rlm_8mus C_rlm_8mus