%% Procesa Ojos TODO EN UNO
clear, clc;
close all;

%% Librerias
addpath(genpath('../../03_optical_flow'))
addpath(genpath('../../04_phase_space'))

%% PARAMS: Dataset
% dataset_folder = 'C:\Users\bater\Documents\Dataset_riie\All';
dataset_folder = '/home/jullygh/Dataset_riie/All';
ruta = [dataset_folder, filesep, 'CP', filesep 'GoPro'];


%% Iniciar procesos en paralelo (crear pool)
LASTN = maxNumCompThreads(10);

% % Extraer frames
% if exist([dataset_folder, filesep, 'SUCCESS'], 'file') ~= 2 
% 	video2frames_folder(dataset_folder);
% end

%% Iniciar procesamiento
% Extraer la lista de sujetos
w=dir(ruta);
w=w(3:end,:);

% Procesamiento de sujetos
for carpeta= 5:8

	% Definir Carpetas
	s=[ruta, filesep, w(carpeta).name,'/','SMOOTH'];
	t=[ruta, filesep, w(carpeta).name,'/','SACCAD'];


	% Iniciar calculo flujo optico
	fprintf('Calculando opt_flow de:%s \n',s);
	calculo_optflow(s)
	fprintf('Calculando opt_flow de:%s \n',t);
	calculo_optflow(t)
   
	fprintf('Derivative calculation')
    calculo_derivadas(s)
	calculo_derivadas(t)

	% Parte 2 (No usar mas de 4 pool)
    fprintf('Phase sphase calculation')
	plot_Sphase(s)
	plot_Sphase(t)
	plot_Sphase2(s)
	plot_Sphase2(t)

	% plot_Spashe_dual_angle(s)
	% plot_Spashe_dual_angle(t)
end
