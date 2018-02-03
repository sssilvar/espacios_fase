%clear

namefile='GO01';
folderSave=['folder_',namefile,'/'];
file=[namefile,'_uv_','.mat'];
xd=load([folderSave,file]);
N=length(xd.optfl);

edges=[0 21 41 61 81 101 121 141 161 181 201 221 241 261 281 301 321 341 361];

for k=1:N
    dv=xd.optfl(k).u./xd.optfl(k).u;
    dangle=floor(atan2d(xd.optfl(k).v,xd.optfl(k).u))+180;
    ncount = histcounts(dangle(:),edges);
    relativefreq = ncount/length(dangle(:));
    xdata(:,k)=relativefreq;
end


%% Horjth parameters

v = xdata / norm (xdata); %media 0
my_max = max (max(xdata)); 
v2 = xdata ./ my_max;
v3 = (xdata-min(xdata(:))) ./ (max(xdata(:)-min(xdata(:))));

[m,n]=size(v2);
for k=1:m
    [ACTIVITY, MOBILITY, COMPLEXITY,m0,m1,m2] = hjorth(v3(k,:)',0);
    complexity1(k)=COMPLEXITY; 
    activity1(k)=ACTIVITY; 
    mobility1(k)=MOBILITY; 
end    
 
%figure, plot(mobility1)

figure, hold on;
plot(mobility1)
hold off;
xlabel('nbins')
ylabel('Frecuency')
title('Histogram')
hold off;

theta = xdata;
histogramapolar=polarhistogram(theta,18);

figure, hold on;
plot(histogramapolar)
hold off;