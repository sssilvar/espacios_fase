%%Federico Abril  control21 
%%addpath('E:/Mi Bella/code/FLUJO');
clear;
close all;
clc;

f = filesep;
%% Parametros
sujeto_control = 'control21';
sujeto_cp = 'Federico Abril';

control_folder = 'C:\Users\Smith\Downloads\temp\Pruebachiq\';
cp_folder = 'C:\Users\Smith\Downloads\temp\Pruebachiq\';

log_file = ['log', f, sujeto_cp, '_vs_', sujeto_control, '.log'];

%% Programa: NO TOCAR
% Calcula metrica
folders = {'SACCAD', 'SMOOTH'};
A = {[cp_folder, sujeto_cp], [control_folder, sujeto_control]};
eye_1=[];
eye_2=[];

for fi= 1 : numel(folders)
    current_folder = folders{fi};
    for C=1:2
    S=A{C};
    
    disp(['[  OK  ] Processing', S, ' (Eye 1)'])
    mat_file = [S, f, current_folder, f, current_folder, '_ojos.mat'];
    load(mat_file)

    [cordena,orden]=sort([as{1}(1),as{2}(1)]);
    
    mat_file = [S, f, current_folder, f, 'folder_', current_folder, f,...
        current_folder, '_velacel_',num2str(orden(1)),'.mat'];
    load(mat_file)
    
    mag_vel=(vel_u.^2+vel_v.^2).^1/2;
    mag_acel=(acel_u.^2+acel_v.^2).^1/2;
    ang=atan2d(mag_acel,mag_vel);
    
    % figure ();
    % title(['distchiq: ', S])
    % subplot(1,2,1)
    % h=histogram(ang(:,:,1360),'BinLimits',[0,90],'NumBins',18,'normalization','probability') 
    % xlabel('Angle')
    % ylabel('Frequency')
    h = histcounts(ang(:,:,1360),'BinLimits',[0,90],'NumBins',18,'normalization','probability');
    eye_1(:,C)=h';


    disp(['[  OK  ] Processing', S, ' (Eye 2)'])
    mat_file = [S, f, current_folder, f, 'folder_', current_folder, f,...
        current_folder, '_velacel_',num2str(orden(2)),'.mat'];
    load(mat_file)
    mag_vel=(vel_u.^2+vel_v.^2).^1/2;
    mag_acel=(acel_u.^2+acel_v.^2).^1/2;
    ang=atan2d(mag_acel,mag_vel);
    % subplot(1,2,2)
    % h=histogram(ang(:,:,1360),'BinLimits',[0,90],'NumBins',18,'normalization','probability')
    % xlabel('Angle')
    % ylabel('Frequency')
    h=histcounts(ang(:,:,1360),'BinLimits',[0,90],'NumBins',18,'normalization','probability');
    eye_2(:,C)=h';
    end


    % Calculate Chi-Square Distance
    for L=1:2
        f1=eye_1(:,L);
        
        for D=1:2
            f2=eye_1(:,D);
            [cm1(L,D)]=distChiSq(f1,f2);
        end
    end

    for L=1:2
        f1=eye_2(:,L);
        
        for D=1:2
        f2=eye_2(:,D);
        [cm2(L,D)]=distChiSq(f1,f2);
        end
    end
    diary on
    diary(log_file);
    disp(datetime('now'))
    disp(['[  OK  ] ', current_folder, ' processing has been made'])
    disp(cm1)
    disp(cm2)
    diary off
end