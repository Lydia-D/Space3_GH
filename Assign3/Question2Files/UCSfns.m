% Create function handles for Universal Conic Section
% L Drabsch
% 14/5/16
% vectorised
function fnhandle = UCSfns(X0,dt,dE)
    global mu_earth
    
    norm_r0 = sqrt(X0(1,:).^2 + X0(2,:).^2 +X0(3,:).^2); % row
    norm_v0 = sqrt(X0(4,:).^2 + X0(5,:).^2 +X0(6,:).^2);
    v0sd    = X0(4,:).^2 + X0(5,:).^2 +X0(6,:).^2;
    rdotv   = diag(X0(1:3,:)'*X0(4:6,:))';

    % only used the v from the orbit transfer? not the inclination change?
    a = ((2./norm_r0) - (v0sd./mu_earth)).^(-1);  
    
    if isnan(dE)    % calculating dE from dt
        fnhandle.phifn = @(phi,i_t) sqrt(a.^3./mu_earth).*(phi-(1-norm_r0./a)*sin(phi) + rdotv./(sqrt(mu_earth).*a).*(1-cos(phi))) - dt(i_t);
        fnhandle.dphifn = @(phi) sqrt(a.^3./mu_earth).*(1-(1-norm_r0./a)*cos(phi) + rdotv./(sqrt(mu_earth).*a).*sin(phi));
    else            % calculating dt from dE
        fnhandle.dt = @(phi) sqrt(a.^3./mu_earth).*(phi-(1-norm_r0./a)*sin(phi) + rdotv./(sqrt(mu_earth).*a).*(1-cos(phi)));
        dt = fnhandle.dt(dE);
    end
    
    fnhandle.f = @(phi) 1-a.*(1-cos(phi))./norm_r0;
    fnhandle.g = @(phi) dt - sqrt(a.^3./mu_earth).*(phi - sin(phi));
    fnhandle.rapprox = @(phi) a.*(1-(1-norm_r0./a).*cos(phi)) + rdotv.*sqrt(a./mu_earth).*sin(phi);
    fnhandle.dg = @(phi) 1- a.*(1-cos(phi))./fnhandle.rapprox(phi);
    fnhandle.df = @(phi) -sqrt(mu_earth.*a).*sin(phi)./(fnhandle.rapprox(phi).*norm_r0);
    
end