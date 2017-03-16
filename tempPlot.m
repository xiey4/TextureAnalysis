close all
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
figure(t)
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
end