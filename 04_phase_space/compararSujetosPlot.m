function [ h_mag, h_phase ] = compararSujetosPlot( control, cp )
binsx = 50;
binsy = 50;

view_az = 45;
view_el = 0;
zmax = 12000;


%% Graficar Magnitud
h_mag = figure;

% Phase Graphic 3D
subplot(2,2,1)
cuales = find(control.left.vel.mag > multithresh(control.left.vel.mag));
hist3([control.left.vel.mag(cuales), control.left.vel.mag(cuales)],[binsx, binsy])
xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');
title('Control - Left Eye - Magnitude');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
view(view_az, view_el)

% Control, ojo derecho
subplot(2,2,2)
cuales = find(control.right.vel.mag > multithresh(control.right.vel.mag));
hist3([control.right.vel.mag(cuales), control.right.vel.mag(cuales)],[binsx, binsy])
xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');
title('Control - Right Eye - Magnitude');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
view(view_az, view_el)

% CP, ojo izquierdo
subplot(2,2,3)
cuales = find(cp.left.vel.mag > multithresh(cp.left.vel.mag));
hist3([cp.left.vel.mag(cuales), cp.left.vel.mag(cuales)],[binsx, binsy])
xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');
title('CP - Left Eye - Magnitude');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
view(view_az, view_el)

% CP, ojo derecho
subplot(2,2,4)
cuales = find(cp.right.vel.mag > multithresh(cp.right.vel.mag));
hist3([cp.right.vel.mag(cuales), cp.right.vel.mag(cuales)],[binsx, binsy])
xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');
title('CP - Right Eye - Magnitude');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
view(view_az, view_el)


%% Plot Phase
h_phase = figure;

% Phase Graphic 3D
subplot(2,2,1)
cuales = find(control.left.vel.mag > multithresh(control.left.vel.mag));
hist3([control.left.vel.phase(cuales), control.left.vel.phase(cuales)],[binsx, binsy])
xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');
title('Control - Left Eye - Phase');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
zlim([0, zmax])
view(view_az, view_el)

% Control, ojo derecho
subplot(2,2,2)
cuales = find(control.right.vel.mag > multithresh(control.right.vel.mag));
hist3([control.right.vel.phase(cuales), control.right.vel.phase(cuales)],[binsx, binsy])
xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');
title('Control - Right Eye - Phase');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
zlim([0, zmax])
view(view_az, view_el)

% CP, ojo izquierdo
subplot(2,2,3)
cuales = find(cp.left.vel.mag > multithresh(cp.left.vel.mag));
hist3([cp.left.vel.phase(cuales), cp.left.vel.phase(cuales)],[binsx, binsy])
xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');
title('CP - Left Eye - Phase');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
zlim([0, zmax])
view(view_az, view_el)

% CP, ojo derecho
subplot(2,2,4)
cuales = find(cp.right.vel.mag > multithresh(cp.right.vel.mag));
hist3([cp.right.vel.phase(cuales), cp.right.vel.phase(cuales)],[binsx, binsy])
xlabel('Velocity'); ylabel('Acceleration');zlabel('Occurrencies');
title('CP - Right Eye - Phase');
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
zlim([0, zmax])
view(view_az, view_el)


end

