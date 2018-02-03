%%%%% HALLAR VELOCIDAD Y ACELERACION DE LOS DATOS DEL FLUJO OPTICO%%%%%%%%

function calculo_derivadas(H)
%H='GO04';
alfa=0.5;
folder=[H,'/'];%%%% ruta del video

for T=1:2 

    load ([folder,'folder_',H(end-5:end),'/',H(end-5:end),'_uv_',num2str(T),'.mat'])%%%%% abrir el .mat de un ojo
    
        vel_u=[];
        vel_v=[];
        acel_u=[];
        acel_v=[];
        Vr=[];
        Ar=[];
        P=[];
    for R=1:(size(optfl,2)-2)%%%%%paso para obtener las derivadas, empieza por el primer frame hasta el número total que tiene la variable optfldata,menos 1 para la derivada
        
       vel_u(:,:,R)=optfl(R+1).u-optfl(R).u;%%%%% elementos de las filas, columnas y tercera dimension q es R, segunda posicion menos la primera posicion en u
       vel_v(:,:,R)=optfl(R+1).v-optfl(R).v;
       
       acel_u(:,:,R)=optfl(R+2).u-2*optfl(R+1).u-optfl(R).u;%%%% segunda derivada (a1,a2,a3) primera (a2-a1)-(a3-a2) segunda deriv a3-2a2-a1
       acel_v(:,:,R)=optfl(R+2).v-2*optfl(R+1).v-optfl(R).v;
   
       %Vm(R)=mean2((vel_u(:,:,R).^2+vel_v(:,:,R).^2).^(1/2));%%%% media de
       %Am(R)=mean2((acel_u(:,:,R).^2+acel_v(:,:,R).^2).^(1/2));
       %Tao=alfa.*Vm(R);

   %    Vr(:,:,R)=((vel_u(:,:,R).^2+vel_v(:,:,R).^2).^(1/2));%%%% media de la velmagnitud del vector velocidad, hipotenusa(raiz de x al cuadrado mas y al cuadrado)
       
    %   Ar(:,:,R)=((acel_u(:,:,R).^2+acel_v(:,:,R).^2).^(1/2));
    %Vr(R)=mean2(((vel_u(:,:,R).^2+vel_v(:,:,R).^2).^(1/2)));%%%% media de la velmagnitud del vector velocidad, hipotenusa(raiz de x al cuadrado mas y al cuadrado)

%       Indices=find(Vr(:,:,R)<Tao);
%       
%       Aux=Vr(:,:,R);
%       Aux(Indices)=0;
%       
%       Vr(:,:,R)=Aux;
%       
%       Aux=Ar(:,:,R);
%       Aux(Indices)=0;
%       
%       Ar(:,:,R)=Aux;
%       
    %  P1=[Vr(:,:,R);Ar(:,:,R);ones(size(Ar,1),size(Ar,2)).*R];
    %  P=[P,P1];
       
    end
    %plot3(Vm,Am, [1:size(Vm,2)])
    %xlabel('velocidad')
%ylabel('Aceleracion')
%zlabel('#Frame')
%title(['video ',H,'ojo ',num2str(T)])
 
    datos=[folder,'folder_',H(end-5:end),'/',H(end-5:end),'_velacel_',num2str(T),'.mat'];
    save(datos,'vel_u','vel_v','acel_u','acel_v','Vr','Ar','-v7.3')
   % saveas(gcf,[folder,'folder_',H(end-5:end),'/',H,'_velacel_grafica',num2str(T),'.fig'])
   % saveas(gcf,[folder,'folder_',H(end-5:end),'/',H(end-5:end),'_velacel_grafica',num2str(T),'.png'])
  
  %  plot3(P(:,1),P(:,2),P(:,3));
end
   
