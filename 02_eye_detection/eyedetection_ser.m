clear
clear
close all
clc
% addpath('C:\Users\Jully\Desktop\Escritorio\matlab\')
addpath('c:\dev\mexopencv\')
addpath('c:\dev\mexopencv\opencv_contrib')

%% Data

k='2100';
[folder, namefile, ext] = fileparts('E:\Mi Bella\Dataset_riie\All\CP\GoPro\Federico Abril\SMOOTH\GOPR0303.MP4');
%% ROI

im3 = imread([folder, '/muestra/',k,'.tif']);
B1=im3;
[as]=eyes_detect_points(B1);
pos=as{1};
im1=B1((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);

figure();
imshow(im1);

pos=as{2};
im2=B1((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);

figure();
imshow(im2);

save([folder, filesep, namefile,'_ojos.mat'],'as','B1');