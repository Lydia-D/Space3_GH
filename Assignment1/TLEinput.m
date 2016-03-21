%% L Drabsch
% importing TLEs
% inputs: TLE = matrix of Two line elements
% line 1: line number, sat number, ID, epochyear&day fraction, 1st der, 2nd
% der, drag term, ephemeris, element number and check sum
% line 2: line number, sat number, inclination, Rasc, e, omega, M0, MM,
% revolution number and check sum
function [Output,times] = TLEinput(TLE)

    global secs_per_day mu_earth

    index = 1;
    while index <= size(TLE, 1)
        if TLE(index,1) == 1 % if first line of TLE
            Epochyr = floor(TLE(index,4)/1000);
            Epochday = TLE(index,4) - Epochyr*1000;
            t0 = Epochday*secs_per_day;

            index = index+1;
            if TLE(index,1) == 2 % check second line
                inc = deg2rad(TLE(index,3));
                Rasc = deg2rad(TLE(index,4));
                e = TLE(index,5)*10^-7;
                omega = deg2rad(TLE(index,6));
                M0 = deg2rad(TLE(index,7));
                MM = TLE(index,8);
            else
                fprintf('Error with TLE, next line isnt sync at index %f',index);
                break;
            end
        else
            fprintf('Error next line not in sync at index %f',index);
            break;
        end

        % calculate other parameters
        a = (mu_earth/(MM*2*pi/secs_per_day).^2).^(1/3); % m from mean motion TLE 
        p = a*(1-e^2);% semilatus rectum
        n = MM*2*pi/secs_per_day;  % mean motion per second

        % solve for initial theta at t = t0
        t = t0;
        Mt = M0 + n*(t-t0);
        % solve kepler equation
        E = newtown(Mt,e);
        % solve for true anomaly using eccentric anomaly
        theta = 2*atan(sqrt(1+e)/sqrt(1-e)*tan(E/2));

        Output(:,index/2) = [Rasc;omega;inc;a;e;theta];
        
        times(1,index/2) = t0;
%         eval(['Output.X_c' num2str(index/2) ' = [Rasc,omega,inc,a,e,theta]'';'])
%         eval(['Output.X_e ' num2str(index/2) ' = class2equin(Output.X_c' num2str(index/2) ');'])
        index = index + 1;

    end
    
end