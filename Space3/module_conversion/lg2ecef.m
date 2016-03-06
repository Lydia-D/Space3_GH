%% function 'lg2ecef'
%
% Transforms coordinates in LG to coordinates in ECEF
% LG  : Local Geocentric Vertical Frame OR Local Geodetic Vertical Frame
% ECEF: Earth Centered Earth Fixed Frame
%
% Inputs:   ->  Sat_LG              = [N, E, D]' in LG frame of Observer
%           ->  Obs_LLH           = [lat, lon, h]'|Observer
%
% Outputs:  ->  Pos_ECEF            = [x, y, z]' in ECEF frame
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited: Lydia Drabsch 6/3/16
% 1) transform Sat_LG to Sat_ECEF by rotating about y (+ve)  by pi-theta
% then about z (-ve) by phi
% 2) transform Obs_LLH to Obs_ECEF using llhgc2ecef
% 3) get position vector Pos_ECEF=Obs_ECEF+Sat_ECEF
function pos_ecef = lg2ecef(pos_lg, pos_llh_ground)
    

end