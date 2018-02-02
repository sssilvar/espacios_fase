

clear
close all
clc
addpath('C:\Users\Chulita\Desktop\matlab\')

%% Data

folder='C:\Users\Chulita\Desktop\EXPERIMENTOS\videos\';
ext='.MP4';
 namefile='GOPR0077';
% file=[folder,namefile,ext];
% folderSave=['folder_',namefile,'\'];
% mkdir(folderSave);
% PDvideoObj = VideoReader (file); % Nombre del Video, recuerda que molesta mucho por el formato entonces tendras que hacer mucho intentos.
% nFrames = PDvideoObj.NumberOfFrames;

%%  RoI
k=1;
%k=120 video Aleja
im3 = imread(['muestra/',num2str(k),'.tif']);
%B1 = imrotate(im3,180);
B1=im3;
[as]=eyes_detect_points(B1);
%X=[abs(as{2}(1)),abs(as{1}(1)+as{1}(3)-as{2}(1))];
%Y=[min(as{1}(2),as{2}(2)),abs(as{2}(2)-as{1}(2))+max(as{2}(4),as{1}(4))];
%pos=[X(1),Y(1), X(2), Y(2)];

pos=as{1};
%figure, imshow(B1)
%H=imrect;
%pos=floor(getPosition(H));
im1=B1((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);
%pause;
%im1=B1(145:305,174:574,:);
%im1=B1(185:305,250:554,:);

figure();
imshow(im1);

pos=as{2};
im2=B1((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);

figure();
imshow(im2);

save([namefile,'_ojos.mat'],'as','B1');
