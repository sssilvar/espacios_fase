namefile='GO01';
folderSave=['folder_',namefile,'\'];
file=[namefile,'_uv_','.mat'];
xd=load([folderSave,file]);
N=length(xd.optfl);

folder='C:\Users\Chulita\Desktop\EXPERIMENTOS\videos\';
ext='.MP4';
file=[folder,namefile,ext];
PDvideoObj = VideoReader (file);
iptsetpref('ImshowBorder','tight');
set(gca,'LooseInset',get(gca,'TightInset'));

for k=xd.optfldata.initial:N-1

im3 = read(PDvideoObj,k+1);
B1 = imrotate(im3,0);
pos=xd.optfldata.pos;
im1=B1((pos(2):(pos(2)+pos(4))),(pos(1):(pos(1)+pos(3))),:);
plotFlow(xd.optfl(k+1).u, xd.optfl(k+1).u, im1)
set(gca,'LooseInset',get(gca,'TightInset'));
saveas(gca,[folderSave,'/frame_',num2str(k+1),'.png']);
close all
end
