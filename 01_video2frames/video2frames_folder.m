%% VIDEO2FRAMES
%   This code goes over every folder looking for videos and converting them
%   into frames. 

%% Add libraries and files separator (f)
addpath(genpath('lib'));
f = filesep;

%% Set dataset folder
% dataset_folder = 'C:\Users\bater\Documents\Dataset_riie\All';
dataset_folder = '/home/jullygh/Dataset_riie/All';

%% Start looking for videos inside dataset_folder

% Control processing
control_folder = [dataset_folder, f, 'Controls/GoPro/'];
control_dir = new_dir(control_folder);

for i = 1:1%length(control_dir)
    if ~isequal(control_dir(i).name, '.') && ~isequal(control_dir(i).name, '..')        

        smooth_dir = new_dir([control_dir(i).path, f, control_dir(i).name, f, 'SMOOTH/*.MP4']);
        saccad_dir = new_dir([control_dir(i).path, f, control_dir(i).name, f, 'SACCAD/*.MP4']);

        % process SMOOTH directory
        for j = 1:length(smooth_dir)
            video_file = [smooth_dir(j).path, f, smooth_dir(j).name];
            disp(['Processing: ', video_file])
            video2frames(video_file, 'tif')

        end

        % process SACCAD directory
        for j = 1:length(saccad_dir)
            video_file = [saccad_dir(j).path, f, saccad_dir(j).name];
            disp(['Processing: ', video_file])
            video2frames(video_file, 'tif')
        end
    end
end


% CP processing
cp_folder = [dataset_folder, f, 'CP/GoPro/'];
cp_dir = new_dir(cp_folder);

for i = 1:length(cp_dir)
    if ~isequal(cp_dir(i).name, '.') && ~isequal(cp_dir(i).name, '..')

        smooth_dir = new_dir([cp_dir(i).path, f, cp_dir(i).name, f, 'SMOOTH/*.MP4']);
        saccad_dir = new_dir([cp_dir(i).path, f, cp_dir(i).name, f, 'SACCAD/*.MP4']);

        % process SMOOTH directory
        for j = 1:length(smooth_dir)
            video_file = [smooth_dir(j).path, f, smooth_dir(j).name];
            disp(['Processing: ', video_file])
            video2frames(video_file, 'tif')

        end

        % process SACCAD directory
        for j = 1:length(saccad_dir)
            video_file = [saccad_dir(j).path, f, saccad_dir(j).name];
            disp(['Processing: ', video_file])
            video2frames(video_file, 'tif')

        end
    end
end

save([dataset_folder, filesep, 'SUCCESS'], '-ascii')