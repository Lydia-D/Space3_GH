%% Calculate Jacobian of Constraint fn
% L Drabsch
% 13/5/16
% inputs -> Y = [dE1,dV1,el1,az1,dE2,dV2,el2,az2]'
%           fnhandle = handle to function that the gradiant is being calculated for
%           pert = perturbation size
% outputs -> dYpert = gradient 
function dYpert = calcG(Y,eps,X0,final)

    % central differencing
    
    for each element
        dcdx = constraints(X0,Y,final)







end