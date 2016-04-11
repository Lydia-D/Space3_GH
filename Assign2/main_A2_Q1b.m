%% Question 1 Part 2
% position trajectory of UAV
% Data: GPSsat_ephem - orbital parameters of satellites
%       GPS_pseudorange_F1 - logged data of UAV as [time,SatNo,Psrange] in
%                           (s, #, m) no errors or clock bias
%       UAVPosition_F1 - true position relative to Gnd station

% To Do:
%       Trajectory wrt ground station
%           - divide up data in time sections?
%    done       - identify which satellite to which data
%    done       - ECEF coords of satellites at time t
%                    - take emperical parameters and time t to output ECEF
%                    coords (Part A)
%                    - start with keplerian model, maybe do J2 model?
%    done   - use NLLS to calculate [x,y,z] ECEF coordinates of UAV
%           - convert ECEF to LGCV 
%           - plot polar 
%           - compare with UAVPosition_F1
clear


%% Identify sat data
% ideaA: function that takes in time and vector of satellite numbers and
% outputs PosSat = [xrow;yrow;zrow] only for the sats in range then loop
% through time 
%   - is there a way to vectorise in time? or use previous location as inital guess
%   - need inital data processing, go from txt file?

% ideaB: have sats that arent in range filled with NaN?

%% gather data 
GPS_pseudorange_F1 = dlmread('GPS_pseudorange_F1.txt');
F1_time = GPS_pseudorange_F1(:,1);
F1_sat = GPS_pseudorange_F1(:,2);
F1_R = GPS_pseudorange_F1(:,3);

%% isolate different times
% have row vector of single times Timevec
% have matrix of obervable sats, row = time , columns of sat numbers 
startindex = 1;
i = 1;
while startindex <= length(F1_time)
    index = F1_time == F1_time(startindex);
    Timevec(1,i) = F1_time(startindex);
    Observables(1:length(F1_sat(index)),i) = F1_sat(index);
    startindex = startindex+length(index(index));
    i = i+1;
end

% 
[X_ECI,X_ECEF] = keplerorbit(ClassPara(:,Observables),Timevec);
