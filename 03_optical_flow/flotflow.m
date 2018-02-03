namefile='GO01';
folderSave=['folder_',namefile,'\'];
file=[namefile,'_uv_','.mat'];
xd=load([folderSave,file]);
N=length(xd.optfl);

folder='C:\Users\Chulita\Desktop\EXPERIMENTOS\videos\';
ext='.MP4';
file=[folder,namefile,ext];
PDvideoObj = VideoReader (file);
nFrames = PDvideoObj.NumberOfFrames;
fprintf('el video tiene %d frames \n', nFrames);

imagen=N;
im3 = read(PDvideoObj,imagen);
B1 = imrotate(im3,0);
pos=xd.optfldata.pos;
im1=B1((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);


for imagen=2:N
    iptsetpref('ImshowBorder','tight');
       %set(gca,'LooseInset',get(gca,'TightInset'));
 figure; 
plotFlow(xd.optfl(imagen).u, xd.optfl(imagen).u, im1)
 %fig = gcf;
%fig.InvertHardcopy = 'off';
       %iptsetpref('ImshowBorder','tight');
  %set(gca,'LooseInset',get(gca,'TightInset'));
       saveas(fig,['Flujo/primero',num2str(imagen),'.png'],'png');
       %close(hc)
       close all
end

