clear all; close all
% MRI params - shown underneath
load('DataByMuscleParameter.mat');
% RLM params - [SRE_v;LRE_v;GLN_v;RP_v;RLN_v; LGRE_v;HGRE_v];
load('P_rlm_8mus.mat');
load('C_rlm_8mus.mat');
% GLCM params - contrast,correlation,energy,homogeneity,ff,ave gl intensity
load('P_glcm_8mus.mat');
load('C_glcm_8mus.mat');
%%
% step 1 look at their means, overall distributions and ranges, look for
% the ones with the most variation (worth investigating)
muscles=['VL'; 'VM'; 'VI'; 'RF'; 'SM'; 'ST'; 'BF'; 'AD'];
rlm_par=strvcat('SRE','LRE','GLN','RP','RLN','LGRE','HGRE');
glcm_par=strvcat('CONT','CORR','LOGE','HOMO','AVEI');
c_num=[1 3 4 6 7 8 10 11 12 13 14 15 16];%these are the controls most similar in age and gender to the patients
p_num=2:13;
par_name=strvcat('T2', 'T2FS', 'T1', 'T1FS', 'F', 'FA', 'ADC', 'L1', 'L2', 'L3', 'SDV1', 'Ffat', 'PSR');
pars=[3 4 5 6 8 11:16 19 21];
pm_num=[1 2 3 6 9 10 12 13];
dm_num=[4 5 7 8 11];

% 1. mean T2 for all 8 muscles in patients
g = pars(1);

figure(1)
for k1 = 1:8
% ave
ave_pat=mean(stats_pat(g,:,k1));
% range
max_pat = max(squeeze(stats_pat(g,:,k1)));
min_pat = min(squeeze(stats_pat(g,:,k1)));
% disp
subplot(3,3,k1);
plot(squeeze(stats_pat(g,:,k1)),'.');
title([muscles(k1,:) ' Mean= ' num2str(ave_pat) ', Range=[' num2str(max_pat) ',' num2str(min_pat) ']']);
axis([0 13 0 max_pat*1.5])
end

% 2. mean T2 for all 8 muscles in controls
figure(2)
g=pars(1)
for k1 = 1:8
% ave
ave_pat=mean(stats_con(g,:,k1));
% range
max_pat = max(squeeze(stats_con(g,:,k1)));
min_pat = min(squeeze(stats_con(g,:,k1)));
% disp
subplot(3,3,k1);
plot(squeeze(stats_con(g,:,k1)),'.');
title([muscles(k1,:) ' Mean= ' num2str(ave_pat) ', Range=[' num2str(max_pat) ',' num2str(min_pat) ']']);
axis([0 17 0 max_pat*1.5])
end

%% 3. all 7 rlm data for all patients all muscles
for g = 1:7
figure(2+g)

for k1 = 1:8
% ave
ave_pat=round(mean(squeeze(P_rlm_8mus(g,:,k1))),1);
ave_con=round(mean(squeeze(C_rlm_8mus(g,c_num,k1))),1);
% range
max_pat = round(max(squeeze(P_rlm_8mus(g,:,k1))),1);
min_pat = round(min(squeeze(P_rlm_8mus(g,:,k1))),1);

max_con = round(max(squeeze(C_rlm_8mus(g,c_num,k1))),1);
min_con = round(min(squeeze(C_rlm_8mus(g,c_num,k1))),1);

% disp
subplot(3,3,k1);
plot(squeeze(C_rlm_8mus(g,c_num,k1)),'.');
title(['P_M= ' num2str(ave_pat) ', P_R=[' num2str(max_pat) ',' num2str(min_pat) '] C_M= ' num2str(ave_con) ', C_R=[' num2str(max_con) ',' num2str(min_con) ']']);
u = max([max_con,max_pat]);
axis([0 14 0 u*1.5])
xlabel(muscles(k1,:));
ylabel(rlm_par(g,:));
hold on
plot(squeeze(P_rlm_8mus(g,:,k1)),'*');
legend('Control','Patient');
end

end


%% 4. all 4+2 glcm data for all patients all muscles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for g = 1:5
figure(9+g)
for k1 = 1:8
% ave
ave_pat=round(mean(squeeze(P_glcm_8mus(g,:,k1))),3);
ave_con=round(mean(squeeze(C_glcm_8mus(g,c_num,k1))),3);
% range
max_pat = round(max(squeeze(P_glcm_8mus(g,:,k1))),3);
min_pat = round(min(squeeze(P_glcm_8mus(g,:,k1))),3);

max_con = round(max(squeeze(C_glcm_8mus(g,c_num,k1))),3);
min_con = round(min(squeeze(C_glcm_8mus(g,c_num,k1))),3);

% disp
subplot(3,3,k1);
plot(squeeze(C_glcm_8mus(g,c_num,k1)),'.');
title(['P_M= ' num2str(ave_pat) ', P_R=[' num2str(max_pat) ',' num2str(min_pat) '] C_M= ' num2str(ave_con) ', C_R=[' num2str(max_con) ',' num2str(min_con) ']']);
% u = max([max_con,max_pat]);
% axis([0 14 0 u*1.5])
xlabel(muscles(k1,:));
ylabel(glcm_par(g,:));
hold on
plot(squeeze(P_glcm_8mus(g,:,k1)),'*');
legend('Control','Patient');
end

end
%% part 5 single regression analysis for glcm
gcount=0;
for g = pars % all params of mri stats
gcount = gcount+1;
for k1 = 1:8 % all 8 muscles
for t1 = 1:5 % all 5 glcm stats
% y, response values - mri stats
y_pat=squeeze(stats_pat(g,:,k1))';
y_con=squeeze(stats_con(g,c_num,k1))';

y_s = [y_pat;y_con];
% X, predicative terms - texture analysis stats
% X_pat = [P_glcm_8mus(1:4,:,k1);P_rlm_8mus(:,:,k1)]';
% X_con = [C_glcm_8mus(1:4,c_num,k1);C_rlm_8mus(:,c_num,k1)]';
X_pat = P_glcm_8mus(t1,:,k1)';
X_con = C_glcm_8mus(t1,c_num,k1)';
X_s = [X_pat;X_con];

% find b the coefficient term
p = polyfit(X_s,y_s,1);
yfit = polyval(p,X_s);
yresid = y_s - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y_s)-1) * var(y_s);
rsq = 1 - SSresid/SStotal;
rsq_adj = 1 - SSresid/SStotal * (length(y_s)-1)/(length(y_s)-length(p));

% display results
if rsq_adj >=0.4
disp([par_name(gcount,:) ' ' glcm_par(t1,:) ' ' muscles(k1,:) ',R^2= ' num2str(rsq_adj)]);
end

end
end
end
%% part 6 single regression analysis for rlm
gcount=0;
for g = pars % all params of mri stats
gcount = gcount+1;
for k1 = 1:8 % all 8 muscles
for t1 = 1:7 % all 7 rlm stats
% y, response values - mri stats
y_pat=squeeze(stats_pat(g,:,k1))';
y_con=squeeze(stats_con(g,c_num,k1))';

y_s = [y_pat;y_con];
% X, predicative terms - texture analysis stats
% X_pat = [P_glcm_8mus(1:4,:,k1);P_rlm_8mus(:,:,k1)]';
% X_con = [C_glcm_8mus(1:4,c_num,k1);C_rlm_8mus(:,c_num,k1)]';
X_pat = P_rlm_8mus(t1,:,k1)';
X_con = C_rlm_8mus(t1,c_num,k1)';
X_s = [X_pat;X_con];

% find b the coefficient term
p = polyfit(X_s,y_s,1);
yfit = polyval(p,X_s);
yresid = y_s - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y_s)-1) * var(y_s);
rsq = 1 - SSresid/SStotal;
rsq_adj = 1 - SSresid/SStotal * (length(y_s)-1)/(length(y_s)-length(p));

% display results
if rsq_adj >=0.6
disp([par_name(gcount,:) ' ' rlm_par(t1,:) ' ' muscles(k1,:) ',R^2= ' num2str(rsq_adj)]);
end

end
end
end

%% part 7 stepwise regression for all params..?

%for g = pars % all params of mri stats

%for k1 = 1:8 % all 8 muscles
% y, response values - mri stats
y_pat=squeeze(stats_pat(g,p_num,k1))';
y_con=squeeze(stats_con(g,c_num,k1))';

y_a = [y_pat;y_con];
% X, predicative terms - texture analysis stats
X_pat = [P_glcm_8mus(1:4,p_num,k1);P_rlm_8mus(:,p_num,k1)]';
X_con = [C_glcm_8mus(1:4,c_num,k1);C_rlm_8mus(:,c_num,k1)]';

X_a = [X_pat;X_con];

% find b the coefficient term
[b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(X_a,y_a);

% save b

%end
%end