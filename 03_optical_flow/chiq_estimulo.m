%%control_4años  control_6años  control_9años  CP ESTIMULO
addpath('/home/users/jpgonzalezh/frechet/');
A={'CP','control_4years','control_6years','control_9years','ESTIMULO'}
eye_1=[];
eye_2=[];


for C=1:size(A,2)
S=A{C};

if isequal(S,'ESTIMULO')
figure ();
load(['/home/users/jpgonzalezh/videos2/',S,'/SMOOTH/folder_SMOOTH/SMOOTH_velacel_1.mat'])
mag_vel=(vel_u.^2+vel_v.^2).^1/2;
mag_acel=(acel_u.^2+acel_v.^2).^1/2;
ang=atan2d(mag_acel,mag_vel);
subplot(1,2,1)
h=histogram(ang(:,:,1287),'BinLimits',[0,90],'NumBins',18,'normalization','probability') 
xlabel('Angle')
ylabel('Frequency')
eye_1(:,C)=h.Values';
eye_2(:,C)=eye_1(:,C);

else

load(['/home/users/jpgonzalezh/videos2/',S,'/SMOOTH/SMOOTH_ojos.mat'])
[cordena,orden]=sort([as{1}(1),as{2}(1)]);
figure ();
load(['/home/users/jpgonzalezh/videos2/',S,'/SMOOTH/folder_SMOOTH/SMOOTH_velacel_',num2str(orden(1)),'.mat'])
mag_vel=(vel_u.^2+vel_v.^2).^1/2;
mag_acel=(acel_u.^2+acel_v.^2).^1/2;
ang=atan2d(mag_acel,mag_vel);
subplot(1,2,1)
h=histogram(ang(:,:,1287),'BinLimits',[0,90],'NumBins',18,'normalization','probability') 
xlabel('Angle')
ylabel('Frequency')
eye_1(:,C)=h.Values';
load(['/home/users/jpgonzalezh/videos2/',S,'/SMOOTH/folder_SMOOTH/SMOOTH_velacel_',num2str(orden(2)),'.mat'])
mag_vel=(vel_u.^2+vel_v.^2).^1/2;
mag_acel=(acel_u.^2+acel_v.^2).^1/2;
ang=atan2d(mag_acel,mag_vel);
subplot(1,2,2)
h=histogram(ang(:,:,1287),'BinLimits',[0,90],'NumBins',18,'normalization','probability') 
xlabel('Angle')
ylabel('Frequency')
eye_2(:,C)=h.Values';
end
end


for L=1:size(A,2)
f1=eye_1(:,L);

for D=1:size(A,2)
f2=eye_1(:,D);
[cm1(L,D)]=distChiSq(f1,f2);


end
end

for L=1:size(A,2)
f1=eye_2(:,L);

for D=1:size(A,2)
f2=eye_2(:,D);
[cm2(L,D)]=distChiSq(f1,f2);

end
end
