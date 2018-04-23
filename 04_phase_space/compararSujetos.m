%% Limpiar y cerrar todo
close all;
clear, clc;

%% Agregar librerias
addpath(genpath('../03_optical_flow/AIM'))

%% Configurar los sujetos a comparar
CP = 'C:\Users\sssilvar\Downloads\temp\cp\AnaM\SMOOTH';
CONTROL = 'C:\Users\sssilvar\Downloads\temp\cp\Control\SMOOTH';

metodoFlujoOptico = 'HS';

%% Iniciar procesamiento
% Procesar CP
[cp.left.vel.mag, cp.left.acel.mag, cp.left.vel.phase, cp.left.acel.phase, cp.left.roi] = analisisFlujoOptico(CP, 'left', metodoFlujoOptico);
[cp.right.vel.mag, cp.right.acel.mag, cp.right.vel.phase, cp.right.acel.phase, cp.right.roi] = analisisFlujoOptico(CP, 'right', metodoFlujoOptico);

% Procesar control
[control.left.vel.mag, control.left.acel.mag, control.left.vel.phase, control.left.acel.phase, control.left.roi] = analisisFlujoOptico(CONTROL, 'left', metodoFlujoOptico);
[control.right.vel.mag, control.right.acel.mag, control.right.vel.phase, control.right.acel.phase, control.right.roi] = analisisFlujoOptico(CONTROL, 'right', metodoFlujoOptico);


%% Graficar resultados
compararSujetosPlot( control, cp )
