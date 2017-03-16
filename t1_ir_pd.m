function s_fitted = t1_ir_pd(ie, x)

s0=ie(1);
t1=ie(2);
sf=ie(3);
s_fitted = abs(s0*(sf*(1-exp(-1500/t1))*exp(-x/t1) + 1-2*exp(-x/t1)));

return;
