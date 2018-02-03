function plot_Sphase(namefile)
folder=[namefile,'/'];
folderSave=[folder,'folder_',namefile(end-5:end),'/'];%%%nombres

load([folder,namefile(end-5:end),'_ojos.mat']);%%%recupera las variables
[cordenada, orden] = sort([as{1}(1),as{2}(1)]);%%%%coordenadas para ordenar el ojo a la izq y el ojo a la derecha

carpeta = [folderSave,'espacio_dos_ojos_magnitud/'];%%%variable -carpeta- con el nombre espacio dos ojos
mkdir(carpeta)%%% se crea un directorio con el contenido de la variable carpeta

file1=[folderSave,namefile(end-5:end),'_velacel_',num2str(orden(1)),'.mat'];%%% variable que apunta al archivo namefile_velacel_1 o 2 .mat
izq=load([file1]);%%%recupera datos de file1

file2=[folderSave,namefile(end-5:end),'_velacel_',num2str(orden(2)),'.mat'];%%%variable que apunta al archivo namefile_velacel_1 o 2 .mat
der=load([file2]);%%%recupera datos de file2

N=size(izq.acel_v,3);%%%% N es el numero de frames funcion size- tamaño de la matriz nxmxr el 3 saca el tamaño de r
iptsetpref('ImshowBorder','tight'); %%%borde alrededor de la figura, ajusta el tamaño de la figura
set(gca,'LooseInset',get(gca,'TightInset'));%%%se establecen las propiedades de la imagen looseInset?

% Extraer sujeto actual
try
    subject_name = regexp(namefile,'\','split');
    subject_name = subject_name{end};
catch
    subject_name = 'NA';
end

% Calcular espacios de fase
for k=1:N-1%%%%%ciclo q empieza en 1 hasta el ultimo frame menos uno
	fprintf('%d de %d \t Subject: %s\n', [k,(N-1)], subject_name)%%%%escribe los datos desde la primera imagen 

	%%%direccion
	izq_mag_vel=((izq.vel_v(:,:,k)).^2 + (izq.vel_u(:,:,k)).^2).^(1/2); %%%angulo de la vel ojo izq en el frame k
	izq_mag_acel=((izq.acel_u(:,:,k)).^2 +(izq.acel_v(:,:,k)).^2).^(1/2);%%%angulo de la acel ojo izq en el frame k

	subplot(1,2,1);%%% primera grafica ojo izquierdo
	plotFlow(izq_mag_vel, izq_mag_acel, [],10,10);%%%% grafica espacio de fase ojo izq plotflow(x,y,imagen,rsize,scale)
	set(gca,'XAxisLocation','top')
	xlabel('Velocity')
	ylabel('Acceleration')

	der_mag_vel=((der.vel_v(:,:,k)).^2 +(der.vel_u(:,:,k)).^2).^(1/2);%%%%angulo de la vel ojo der
	der_mag_acel=((der.acel_v(:,:,k)).^2 +(der.acel_u(:,:,k)).^2).^(1/2);%%%%angulo de la acel ojo der

	subplot(1,2,2); %%%%segunda grafica ojo derecho
	plotFlow(der_mag_vel, der_mag_acel, [],10,10);%%%grafica espacio de fase ojo der en direccion
	set(gca,'XAxisLocation','top')
	xlabel('Velocity')
	ylabel('Acceleration')

	set(gca,'LooseInset',get(gca,'TightInset')); %%% se establecen de nuevo propiedades
	saveas(gca,[carpeta,num2str(k),'.png']); %%%guarda datos en la carpeta

	close all
    clear gca
end
end
