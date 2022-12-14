%%%% Link budget model based on Wankai Tang work

close all

f_c = 3.58; % Frequency of interest (GHz)
lambda = 0.3/f_c; % Wavelength
N = 16; % Number of columns
M = 16; % Number of rows
Pt = 1; % Transmit power (Watts)
Gt = 10^(17/10); % Transmit antenna gain (linear)
Gr = 10^(17/10); % Receive antenna gain (linear)
dx = 30e-3; % Unit cell dimensions in x (horizontal)
dy = 30e-3; % Unit cell dimensions in y (vertical)

npoints = 150; % Number of sample points per axis
% x coordinates of plane broadside to the RIS
xmin =  -20;
xmax = 20;
% z coordinates of plane broadside to the RIS (i.e., increase z, increase distance broadside from surface)
zmin =  0;
zmax = 20; 

zs = linspace(zmin, zmax, npoints);
xs = linspace(xmin, xmax, npoints);

% Azimuth angle of transmitter (90 degrees = broadside)
phi_t = 120;
% Azimuth angles of directions to steer beam
phi_rs = 15:15:165; 
gg = figure(1); 
gg.Position = [100,100,1200,400];
tiledlayout(1,6,'TileSpacing','compact')

for a = 1:length(phi_rs)
    phi_r = phi_rs(a);
    r = 100; % Far-field to far-field
    txcoords = [r*cos(pi/180*phi_t) 0 r*sin(pi/180*phi_t)];
    rxcoords = [r*cos(pi/180*phi_r) 0 r*sin(pi/180*phi_r)];
    
    xt = txcoords(1); yt = txcoords(2); zt = txcoords(3);
    xr = rxcoords(1); yr = rxcoords(2); zr = rxcoords(3);
    
    sig = 0; % Initialise sum of paths
    d1 = sqrt(xt^2 + yt^2 + zt^2); % Distance of Tx-RIS
    d2 = sqrt(xr^2 + yr^2 + zr^2); % Distance of RIS-Rx
    
    gam = ones(N,M);
    
    PrdB_hoz = zeros(npoints,npoints);
    % Reflection coefficients of two unit cell states - these should be
    % replaced with measured values
    gam1 = j;
    gam2 = -j;

    for m = 1:M
        for n = 1:N
            % x element positions - m represents column
            xnm = dx*m + dx/2 - M*dx/2;
            % y element positions - n represents row
            ynm = dy*n + dy/2 - N*dy/2;
    
            Rtx = sqrt( (xt - xnm)^2 + (yt - ynm)^2 + zt^2 );
            Rrx = sqrt( (xr - xnm)^2 + (yr - ynm)^2 + zr^2 );
    
            dnm = sqrt(xnm^2 + ynm^2);
    
            Ftx = ( ( d1^2 + Rtx^2 - dnm^2 )/(2*d1*Rtx) )^(Gt/2 - 1);
            Frx = ( ( d2^2 + Rrx^2 - dnm^2 )/(2*d2*Rrx) )^(Gr/2 - 1);
            Fuct = (zt/Rtx);
            Fucr = (zr/Rrx);
            Fcombine = Ftx*Fuct*Fucr*Frx;
    
            s1 = sig + sqrt(Fcombine)*gam1*exp(-j*(2*pi/lambda*(Rtx + Rrx)))/(Rtx*Rrx);
            s2 = sig + sqrt(Fcombine)*gam2*exp(-j*(2*pi/lambda*(Rtx + Rrx)))/(Rtx*Rrx);
            if abs(s1) < abs(s2)
                sig = s2;
                gam(n,m) = gam2;
                gam_ind(n,m) = 1;
            else
                sig = s1;
                gam(n,m) = gam1;
                gam_ind(n,m) = 2;
            end
    
        end
    end
    configs(a, :, :) = gam_ind;
    Pr = ((Pt*Gt*Gr*dx*dy*lambda^2)/(64*pi^3))*abs(sig)^2;
    PRX(a,:) = ((Pt*Gt*Gr*dx*dy*lambda^2)/(64*pi^3))*abs(sig)^2;

    %% Received
    PrdB_ver = zeros(npoints,npoints);
    
    %% Sample received power over plane defined by zind, xind
    for zind = 1:npoints
       for xind = 1:npoints
            z = zs(zind);
            x = xs(xind);
            rxcoords = [x 0 z];    
            xr = rxcoords(1);
            yr = rxcoords(2);
            zr = rxcoords(3);
    
            sig = 0;
            d1 = sqrt(xt^2 + yt^2 + zt^2);
            d2 = sqrt(xr^2 + yr^2 + zr^2);
    
            for m = 1:M
                for n = 1:N                
                    % x element positions - m represents column
                    xnm = dx*m + dx/2 - M*dx/2;
                    % y element positions - n represents row
                    ynm = dy*n + dy/2 - N*dy/2;
    
                    Rtx = sqrt( (xt - xnm)^2 + (yt - ynm)^2 + zt^2 );
                    Rrx = sqrt( (xr - xnm)^2 + (yr - ynm)^2 + zr^2 );
    
                    dnm = sqrt(xnm^2 + ynm^2);
    
                    Ftx = ( ( d1^2 + Rtx^2 - dnm^2 )/(2*d1*Rtx) )^(Gt/2 - 1);
                    Frx = ( ( d2^2 + Rrx^2 - dnm^2 )/(2*d2*Rrx) )^(Gr/2 - 1);
                    Fuct = (zt/Rtx);
                    Fucr = (zr/Rrx);
                    Fcombine = Ftx*Fuct*Fucr*Frx;
    
                    sig = sig + sqrt(Fcombine)*gam(n,m)*exp(-j*(2*pi/lambda*(Rtx + Rrx)))/(Rtx*Rrx);
                end
            end
            Pr = ((Pt*Gt*Gr*dx*dy*lambda^2)/(64*pi^3))*abs(sig)^2;
            %% Received power in the azimuthal plane
            PrdB_hoz(xind, zind) = 10*log10(Pr);
       end
    end

    if mod(a,2) == 1
        figure(1); nexttile
        surf(zs, xs, PrdB_hoz)
        title(['\phi_{Rx} = ', num2str(a*15), '^\circ'], 'FontSize', 12)
        view(2)
        shading flat
        colormap jet
        hold on; plot(8.3*sin([0:3:180]*pi/180),8.3*cos([0:3:180]*pi/180),'.', 'MarkerSize',2);
        pbaspect([1 2 1])
    end
    
    %% Scan set of points spaced at angle phi and distance r    
    phis = 1:1:179;
    clear PrdB_rnd;
    r = 8.3;
    for g = 1:length(phis)
        phi = pi/180*phis(g);
        rxcoords = [r*cos(phi) 0 r*sin(phi)];
        xr = rxcoords(1);
        yr = rxcoords(2);
        zr = rxcoords(3);
        sig = 0;
        d1 = sqrt(xt^2 + yt^2 + zt^2);
        d2 = sqrt(xr^2 + yr^2 + zr^2);

        for m = 1:M
            for n = 1:N
                % x element positions - m represents column
                xnm = dx*m + dx/2 - M*dx/2;
                % y element positions - n represents row
                ynm = dy*n + dy/2 - N*dy/2;

                Rtx = sqrt( (xt - xnm)^2 + (yt - ynm)^2 + zt^2 );
                Rrx = sqrt( (xr - xnm)^2 + (yr - ynm)^2 + zr^2 );

                dnm = sqrt(xnm^2 + ynm^2);

                Ftx = ( ( d1^2 + Rtx^2 - dnm^2 )/(2*d1*Rtx) )^(Gt/2 - 1);
                Frx = ( ( d2^2 + Rrx^2 - dnm^2 )/(2*d2*Rrx) )^(Gr/2 - 1);
                Fuct = (zt/Rtx);
                Fucr = (zr/Rrx);
                Fcombine = Ftx*Fuct*Fucr*Frx;

                sig = sig + sqrt(Fcombine)*gam(n,m)*exp(-j*(2*pi/lambda*(Rtx + Rrx)))/(Rtx*Rrx);
            end
        end
        Pr = ((Pt*Gt*Gr*dx*dy*lambda^2)/(64*pi^3))*abs(sig)^2;
        Pr_rnd(g) = Pr;
        PrdB_rnd(g) = 10*log10(Pr);
    end
    
    PXX_NUM(a,:) = PrdB_rnd;
    
end

cb = colorbar; 
cb.Label.String = 'Received power (dB)';
cb.Label.FontSize = 15

gf = figure(2);  gf.Position = [100,100,1200,600];
title('Received power versus RIS configuration'); tiledlayout(2,6, 'TileSpacing','compact')
xlabel('Azimuth angle (degrees)')
tiledlayout(2,6,"TileSpacing","compact")
a = size(configs);
for k = 1:2:a(1)
    loaded_configs(k,:,:) = flipud(squeeze(configs(k,:,:)));
    nexttile
    imagesc(squeeze(loaded_configs(k,:,:)))
    title(['\phi_{Rx} = ', num2str(k*15), '^\circ'], 'FontSize', 12)
    pbaspect([1 1 1])
end
hold on
qw{1} = plot(nan, 'rs','MarkerFaceColor','blue', 'MarkerSize', 15);
qw{2} = plot(nan, 'bs','MarkerFaceColor','yellow', 'MarkerSize', 15);
legend([qw{:}], {'V_{bias} = V^B_1','V_{bias} = V^B_2'}, 'FontSize', 12, 'orientation', 'horizontal', 'position', [0.5-0.23/2 0.92 0.23 0.06])
for k = 1:2:a(1)
    nexttile

    plot(linspace(0,180,length(PXX_NUM(k,:))), PXX_NUM(k,:))
    if k == 1
        ylabel('Received power (dB)', 'FontSize',15);
    end
    box on
    axis([0 180 -100 -60])
    xline(k*15)
    xlabel('\phi', 'FontSize', 15)
end
