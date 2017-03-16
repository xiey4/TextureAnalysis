%dname = 'C:\Users\ralph_000\Desktop\Dr.DamonLabWork\trial1\';
dname = 'C:\Users\ralph_000\Documents\MATLAB\vuTools_2012_Win_64\';
A = [];
m = [];
s = [];
for r = 2:14
%name = sprintf('P%d_n.mat',r);
name = sprintf('P%d.mat',r);
load([dname name]);
m = [m,[mean(vec2);mean(vec1)]];
s = [s,[std(vec2);std(vec1)]];

before = std(vec2)/mean(vec2)*100;
after = std(vec1)/mean(vec1)*100;
x = [before;after];
A = [A,x];
end
