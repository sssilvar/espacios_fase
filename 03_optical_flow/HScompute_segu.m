% HScompute
% Horn-Schunck optical flow method 
% Horn, B.K.P., and Schunck, B.G., Determining Optical Flow, AI(17), No.
% 1-3, August 1981, pp. 185-203 http://dspace.mit.edu/handle/1721.1/6337
%
% Usage:
% [u, v] = HS(im1, im2, alpha, ite, uInitial, vInitial, displayFlow)
% For an example, run this file from the menu Debug->Run or press (F5)
%
% -im1,im2 : two subsequent frames or images.
% -alpha : a parameter that reflects the influence of the smoothness term.
% -ite : number of iterations.
% -uInitial, vInitial : initial values for the flow. If available, the
% flow would converge faster and hence would need less iterations ; default is zero. 
% -displayFlow : 1 for display, 0 for no display ; default is 1.
% -displayImg : specify the image on which the flow would appear ( use an
% empty matrix "[]" for no image. )
%
% Author: Mohd Kharbat at Cranfield Defence and Security
% mkharbat(at)ieee(dot)org , http://mohd.kharbat.com
% Published under a Creative Commons Attribution-Non-Commercial-Share Alike
% 3.0 Unported Licence http://creativecommons.org/licenses/by-nc-sa/3.0/
%
% October 2008
% Rev: Jan 2009

clear
close all
clc


addpath(genpath('/home/users/jpgonzalezh/experimentosmayo/Librerias/'))
%% Parameters of optical flow
alpha=70;
ite=1000;
finitial=1;


%% Paramterers of AIM
resizesize=0.5;
convolve=1;
thebasis='21jade950.mat';
showoutput=0;
method=1;
dispthresh=80; % How much is the cutoff percentage wise in the hard threshold


%% Data

folder='/home/users/jpgonzalezh/videogo04/';
cd (folder)

ext='.MP4';
namefile='GO04';
file=[folder,namefile,ext];
folderSave=['folder_',namefile,'/'];
mkdir(folderSave);
%PDvideoObj = VideoReader (file); % Nombre del Video, recuerda que molesta mucho por el formato entonces tendras que hacer mucho intentos.

nFrames=size(dir('muestra/*.tif'))
%nFrames = PDvideoObj.NumberOfFrames;



%%  RoI
k=1;
%k=120 video Aleja
im3 = imread(['muestra/',num2str(k),'.tif']);
%B1 = imrotate(im3,180);
B1=im3;
%[as]=eyes_detect_points(B1);

load([namefile,'_ojos.mat'])

X=[abs(as{2}(1)),abs(as{1}(1)+as{1}(3)-as{2}(1))];
Y=[min(as{1}(2),as{2}(2)),abs(as{2}(2)-as{1}(2))+max(as{2}(4),as{1}(4))];
pos=[X(1),Y(1), X(2), Y(2)];
%figure, imshow(B1)
%H=imrect;
%pos=floor(getPosition(H));
im1=B1((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);
%pause;
%im1=B1(145:305,174:574,:);
%im1=B1(185:305,250:554,:);

figure();
%imshow(im1);
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
%figure, imshow(imb)

%%
cont=1;
%finitial=1;
ffinal=nFrames-1;
nameSave=[folderSave, namefile,'_uv_','.mat'];
for k=finitial:ffinal%1000 %Fragmento del video que se va a procesar
    fprintf('....k = %d\n',k);
        fprintf('..total k = %d\n',ffinal);

   % im3 = read(PDvideoObj,k);
   %im4 = read(PDvideoObj,k+1);
	im3=imread(['muestra/',num2str(k),'.tif']);
	im4=imread(['muestra/',num2str(k+1),'.tif']);   
%B1 = imrotate(im3,180);
   % B2 = imrotate(im4,180);
    %im1=B1(145:305,174:574,:);
    %im2=B2(145:305,174:574,:);
	B1=im3;
	B2=im4;  
  im1=B1((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);
    im2=B2((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);
    %im1=B1(185:305,250:554,:);
    %im2=B2(185:305,250:554,:);
    im1b=im2double(im1).*imb;
    im2b=im2double(im2).*imb;
    [u,v] = HS(im1b,im2b,alpha,ite);
    optfl(cont).u=u;
    optfl(cont).v=v;
    cont=cont+1;
    clearvars im1 im2 im1b im2b B1 B2 im3 im4 u v
end
optfldata.initial=finitial;
optfldata.final=ffinal;
optfldata.pos=pos;
save(nameSave,'optfl','optfldata','-v7.3');

