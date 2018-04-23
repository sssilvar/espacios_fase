function [mag_vel, mag_acel, phase_vel, phase_acel, roi] = analisisFlujoOptico(directorioSujeto, ojoAProcesar, metodoFlujoOptico)
%% Configurar parámetros
% ojoAProcesar: 'left' o 'right'
% metodoFlujoOptico: 'HS' o 'LK'
%
% Agregar en el código principal el directorio del AIM
% Ej: addpath(genpath('C:\Users\sssilvar\GitHub\espacios_fase\03_optical_flow\AIM'))

%% Definir nombres de archivos
if strfind(directorioSujeto, 'SMOOTH')
    ojosMat = fullfile(directorioSujeto, 'SMOOTH_ojos.mat'); % Segmentación ojos
elseif strfind(directorioSujeto, 'SACCAD')
    ojosMat = fullfile(directorioSujeto, 'SACCAD_ojos.mat'); % Segmentación ojos
end
carpetaMuestra = fullfile(directorioSujeto, 'muestra');

% Definir archivos de salida
flujoMat = fullfile(directorioSujeto, ... % Archivo .mat de flujo óptico (ej. lk_left_eye_FLUJO.mat)
    [metodoFlujoOptico, '_', ojoAProcesar, '_eye_FLUJO.mat']);

%% Leer archivos de datos
load(ojosMat)   % Segmentación de ojos
vidReader = dir([carpetaMuestra, filesep, '*.tif']);   % Carpeta con el video en frames

%% Flujo óptico
if strcmp(metodoFlujoOptico, 'HS')      % Elegir entre Lucas y Horn
    opticFlow = opticalFlowHS;
elseif strcmp(metodoFlujoOptico, 'LK')
    opticFlow=opticalFlowLK ;
end

%%Paramterers of AIM
resizesize=0.5;
convolve=1;
thebasis='21jade950.mat';
showoutput=0;
method=1;
dispthresh=80; 
%%cuadro de los ojos
as_aux = [as{1}(3:4),as{2}(3:4)];
as_aux = max(as_aux);
as{1}(3) = as_aux;
as{1}(4) = as_aux;
as{2}(3) = as_aux;
as{2}(4) = as_aux;

%%  encontrar la region de interes
% nn=2 %% se indica el nÃºmero 1 o 2 para el flujo de cada ojo

if strcmp(ojoAProcesar, 'left')
    disp('Se va a procesar el ojo izquierdo')
    nn = 1;
elseif strcmp(ojoAProcesar, 'right')
    disp('Se va a procesar el ojo derecho')
    nn = 2;
end

pos=as{nn};


A=as{1}(1);
B=as{2}(1);

if A>B
    p_mayor=1;%izquierdo
else
    p_mayor=2;%derecho
end 

if nn==p_mayor
    ojo='left eye';
    disp(ojo)
else
    ojo='right eye';    
    disp(ojo)
end


im = imread([carpetaMuestra, filesep, num2str(1,'%03d'),'.tif']);



im1=im((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);

infomap = AIM(im1,resizesize,convolve,thebasis,showoutput, method);
threshmap1=(infomap > prctile(infomap(:),dispthresh));
inimage = (imresize(im2double((im1)),resizesize));
tempim(:,:,1)=threshmap1.*inimage(:,:,1);
tempim(:,:,2)=threshmap1.*inimage(:,:,2);
tempim(:,:,3)=threshmap1.*inimage(:,:,3);


% test with gbvs
%out = gbvs(im2double(im1));
%figure,imshow((out.master_map_resized>0.3).*im2double(im1(:,:,1)))
fs=imresize(imfill(tempim(:,:,1)>0.01,'holes'),size(im1(:,:,1)));
imb(:,:,1)=fs;
imb(:,:,2)=fs;
imb(:,:,3)=fs;
imb=im2double(imb);


% Verificar si *_FLUJO.mat existe
if exist(flujoMat,'file')
    load (flujoMat)
else 
    flow_total=double.empty(size(vidReader,1),0);
    acel_total=double.empty(size(vidReader,1)-1,0);
    
    % Selecciona cuadro aleatorio para mostrar la roi
    roi_i = randi(size(vidReader,1));
    roiRGB = imread([carpetaMuestra, filesep, num2str(roi_i,'%03d'),'.tif']);
    roiRGB=roiRGB((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);
    roiGray=rgb2gray(roiRGB);
    roiGray=im2double(roiGray).*imb;
    roiGray=rgb2gray(roiGray);

    [roix, roiy, ~] = find(roiGray > 0);
    roi = roiGray(min(roix):max(roix), min(roiy):max(roiy));
    % FIN: Extraccion ROI

    parfor n=1:size(vidReader,1)
        fprintf('Calculando OPTFLOW frame %d de %d\n',n,size(vidReader,1));
       % flow_anterior=flow;
        frameRGB = imread([carpetaMuestra, filesep, num2str(n,'%03d'),'.tif']);
        frameRGB=frameRGB((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);

        frameRGB=im2double(frameRGB).*imb;
        frameGray=rgb2gray(frameRGB);

        [roix, roiy, ~] = find(frameGray > 0);
        roiGray = frameGray(min(roix):max(roix), min(roiy):max(roiy));
       
       % frameRGB = readFrame(vidReader);
       % frameGray = rgb2gray(frameRGB);

       %%%% cortar ojos %%%%
        flow = estimateFlow(opticFlow,roiGray);
        flow_total=[flow_total,flow];
    end
    

    for n=1:size(flow_total,2)-1
        acel.Vx = flow_total(n+1).Vx-flow_total(n).Vx;
        acel.Vy = flow_total(n+1).Vy-flow_total(n).Vy;
        acel_total=[acel_total,acel];
    end

    flow_total=flow_total(2:end);

    save(flujoMat,'flow_total','acel_total', 'roi');
end
    %imshow(frameRGB) 
    %hold on
    %plot(flow,'DecimationFactor',[5 5],'ScaleFactor',25)
    %hold off 
    %pause (1/120)


%%%%%%%%%%%%%%%%%%%%%%%%%%%5 graficas %%%%%%%%%%%%%%5

phase_vel=[];
phase_acel=[];

%%%phase

mag_vel=double.empty(size(acel_total,1),0);
mag_acel=double.empty(size(acel_total,1),0);

for n=1:size(acel_total,2)
    fprintf('Calculando espacios de fase %d de %d\n',n,size(acel_total,2))
    acel_Vx_aux=acel_total(n).Vx;
    acel_Vy_aux=acel_total(n).Vy;
    acel_Vx_aux=acel_Vx_aux(:);
    acel_Vy_aux=acel_Vy_aux(:);

    vel_aux_Vx=flow_total(n).Vx;
    vel_aux_Vy=flow_total(n).Vy;
    vel_aux_Vx=vel_aux_Vx(:);
    vel_aux_Vy=vel_aux_Vy(:);

%     phase_vel_aux = atan2(vel_aux_Vy, vel_aux_Vx);
%     phase_acel_aux = atan2(acel_Vy_aux,acel_V_aux);    
% 
%     mag_vel_aux = ((vel_aux_Vx).^2+(vel_aux_Vy).^2).^0.5;
%     mag_acel_aux = ((acel_Vx_aux).^2+(acel_Vy_aux).^2).^0.5;  

    % Make a test
    [phase_vel_aux, mag_vel_aux] = cart2pol(vel_aux_Vx, vel_aux_Vy);
    [phase_acel_aux, mag_acel_aux] = cart2pol(vel_aux_Vx, vel_aux_Vy);

    % Concatenar con la información anterior
    mag_vel = [mag_vel;mag_vel_aux];
    mag_acel=[mag_acel;mag_acel_aux];

    phase_vel = [phase_vel;phase_vel_aux];
    phase_acel=[phase_acel;phase_acel_aux];

end


% %% Calcular umbral (OTSU's Method)
% cuales = find(mag_vel > multithresh(mag_vel));
% % cuales = find(mag_vel > 0);
% 
% 
% %% Plot results
% figure;
% group = 'CP ';
% 
% % Magnitude Graphic 3D
% subplot(2,1,1)
% hist3([mag_vel(cuales),mag_acel(cuales)],[200 200])
% xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');title([group,ojo ,' Magnitude']);
% set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
% view(20,30)
% 
% % Phase Graphic 3D
% subplot(2,1,2)
% %clear phase_vel phase_vel_aux phase_acel
% hist3([phase_vel(cuales),phase_acel(cuales)],[200 200])
% xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');title([group, ojo, ' Phase']);
% set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
% view(20,30)

% FIN DE LA FUNCIÓN
end