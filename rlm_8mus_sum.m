close all
par_name=strvcat('T2', 'T2FS', 'T1', 'T1FS', 'F', 'FA', 'ADC', 'L1', 'L2', 'L3', 'SDV1', 'Ffat', 'PSR');
pars=[3 4 5 6 8 11:16 19 21];
n=1; %BD
for tp = 2:2 % ffat
% for tp = 1:13
p1 = pars(tp);
for t=1:7 % rlm params 7
tempC = C_rlm_8mus(t,c_num,:);
tempC = tempC(:);

tempP = P_rlm_8mus(t,p_num,:);
tempP = tempP(:);

ave_pat(t) = mean(tempP);
ave_con(t) = mean(tempC);

std_pat(t) = std(tempP);
std_con(t) = std(tempC);
std_pooled(t) = std([tempC;tempP]);
ES(t)=(ave_pat(t)-ave_con(t))/std_pooled(t);
figure
subplot(1,2,1)
plot(tempC,'.');
% title(['P_M= ' num2str(ave_pat(t)) ', P_s_t_d=' num2str(std_pat(t)) ', C_M= ' num2str(ave_con(t)) ', C_s_t_d=' num2str(std_con(t))]);
title(['ES= ' num2str((round(100*ES(t)))/100)])
%u = max([max_con,max_pat]);
%axis([0 14 0 u*1.5])
%xlabel(muscles(k1,:));
ylabel(rlm_par(t,:));
hold on
plot(tempP,'*');
legend('Control','Patient');

% regression ana
x_PC = [tempC;tempP];
ff_P = stats_pat(p1,p_num,:);ff_P = ff_P(:);
ff_C = stats_con(p1,c_num,:);ff_C = ff_C(:);
Crlm_PC(:,t) = [tempC;tempP];
Yrlm_PC=[ff_C;ff_P];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% switched x y label and content
subplot(1,2,2);
plot(Yrlm_PC,x_PC, '.');
xlabel(par_name(tp,:));
ylabel(rlm_par(t,:));
% p = polyfit(x_PC,y_PC,1]
end
Crlm_PC(:,8)=[ff_C;ff_P];
Coef_rlm(tp,:,:)=corrcoef(Crlm_PC);
LGRE_TisPar(:,1)=Crlm_PC(:,6);  %BD
LGRE_TisPar(:,n+1)=Crlm_PC(:,8);  %BD
Text_Ffat(:,1:7)=Crlm_PC(:,1:7); %BD
if tp==12 %BD
    Text_Ffat(:,8)=Crlm_PC(:,8); %BD
end %BD
n=n+1; %BD
corrcoef(Crlm_PC)
disp(par_name(tp,:));
% pause
end

%% Step 2 is mult regression predicting LGRE from tissue/MR parameters
%[b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(LGRE_TisPar(:,2:end),LGRE_TisPar(:,1));

%% step 3 generalized linear model test
