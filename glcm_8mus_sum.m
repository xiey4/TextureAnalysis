close all
par_name=strvcat('T2', 'T2FS', 'T1', 'T1FS', 'F', 'FA', 'ADC', 'L1', 'L2', 'L3', 'SDV1', 'Ffat', 'PSR');
pars=[3 4 5 6 8 11:16 19 21];
n=1; %BD
for tp = 4:4
p1 = pars(tp);
for t=1:5 % rlm params 7
tempC = C_glcm_8mus(t,c_num,:);
tempC = tempC(:);

tempP = P_glcm_8mus(t,p_num,:);
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
ylabel(glcm_par(t,:));
hold on
plot(tempP,'*');
legend('Control','Patient');

% regression ana
x_PC = [tempC;tempP];
ff_P = stats_pat(p1,p_num,:);ff_P = ff_P(:);
ff_C = stats_con(p1,c_num,:);ff_C = ff_C(:);
Cglcm_PC(:,t) = [tempC;tempP];
Y_PC = [ff_C;ff_P];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot(1,2,2);
% plot(x_PC,Y_PC, '.');
% xlabel(glcm_par(t,:));
% ylabel(par_name(tp,:));
subplot(1,2,2);
plot(Yrlm_PC,x_PC, '.');
xlabel(par_name(tp,:));
ylabel(glcm_par(t,:));
% p = polyfit(x_PC,y_PC,1
end
Cglcm_PC(:,6)=[ff_C;ff_P];
Coef_glcm(p1,:,:)=corrcoef(Cglcm_PC);

LENE_TisPar(:,1)=Cglcm_PC(:,3);  %BD
LENE_TisPar(:,n+1)=Cglcm_PC(:,6);  %BD
Text_Ffat(:,1:5)=Cglcm_PC(:,1:5); %BD
if tp==12 %BD
    Text_Ffat(:,6)=Cglcm_PC(:,6); %BD
end %BD
n=n+1; %BD

corrcoef(Cglcm_PC)
disp(par_name(tp,:));
%pause
end

