%% Question 3 HG start from 3 observations

% TO DEBUG: PROBLEM WITH PASSING IN R, NEED TO PASS IN OBS NOT LLH
% REORDER: DO ECI TRANSFORMS FIRST

% inputs: Sat_LG_polar = [R1,R2,R3;az1,az2,az3;,el1,el2,el3];
%         Sat_time    = [t1,t2,t3]
%         Gnd_LLH = [lat,long,height] of gnd station
load TakeObs
Sat_Obs = TakeObs(:,[1,3,6]);
Sat_time = Taketime([1,3,6]);
Gnd_LLH = [deg2rad(2);deg2rad(-62);0];
Gnd_ECEF = llhgd2ecef(Gnd_LLH);


% transform LG_polar to LG_cart to ECEF to ECI
% all vectorised 
Sat_LG_cart = polar2cartesian(Sat_Obs);
Sat_ECEF_local = lg2ecef(Sat_LG_cart,Gnd_LLH);
% Sat_ECI_local = ecef2eci(Sat_ECEF_local,Sat_time);

% Gnd station moves in ECI frame over time
Sat_ECEF_global = Sat_ECEF_local+Gnd_ECEF*ones(1,3);
% Gnd_ECI = ecef2eci(Gnd_ECEF*ones(1,3),Sat_time);
Sat_ECI_global = ecef2eci(Sat_ECEF_global,Sat_time);
% Take from origin of earth
% Sat_ECI_global = Sat_ECI_local+Gnd_ECI;


R = Sat_Obs(1,1:3); % R vectors
v2_Rframe = HG_velvector(R,Sat_time);
% ECI velocity vector where Sat_ECI_global = [r1,r2,r3] in x,y,z
% corrdinates in ECI frame
V2_ECI = Sat_ECI_global*v2_Rframe;   % matrix multiplication
R2_ECI = Sat_ECI_global(:,2);

%% orbital parameters
Vmag = norm(V2_ECI); % m/s
Rmag = norm(R2_ECI);

a_c = mu_earth*Rmag/(2*mu_earth-Vmag.^2.*Rmag);
W_c = cross(R2_ECI,V2_ECI)/norm(cross(R2_ECI,V2_ECI));
inc_c = acos(W_c(3));
e_vec_c = 1/mu_earth.*((Vmag.^2-mu_earth/Rmag).*R2_ECI - (dot(R2_ECI,V2_ECI).*V2_ECI));
e_c = norm(e_vec_c);
N_c = cross([0;0;1],W_c)/norm(cross([0;0;1],W_c));
Rasc_c = atan2(dot(cross([1;0;0],N_c),[0;0;1]),dot([1;0;0],N_c));
omega_c = atan2(dot(cross(N_c,e_vec_c)./e_c,W_c),dot(N_c,e_vec_c)/e_c);
theta_c = atan2(dot(cross(e_vec_c,R2_ECI)./(e_c.*Rmag),W_c) , dot(e_vec_c,R2_ECI)./(e_c.*Rmag));

%% compare with real parameters
load VanAllenepoch1
fprintf('Semimajor Axis a:\t True: %.3e \t Observed: %.3e\n',a,a_c)
fprintf('Inclination i:\t True: %.3e \t Observed: %.3e\n',inc,inc_c)
fprintf('Eccentricity e:\t True: %.3e \t Observed: %.3e\n',e,e_c)
fprintf('Right ascention node Omega:\t True: %.3e \t Observed: %.3e\n',Rasc,Rasc_c)
fprintf('Argument of Perigee omega:\t True: %.3e \t Observed: %.3e\n',omega,omega_c)
fprintf('True Anomaly theta:\t True: %.3e \t Observed: %.3e\n',theta,theta_c)