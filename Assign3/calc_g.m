%% Calculate g = dcost/dy ?
% L Drabsch 
% 18/5/16

function g = calc_g(Y,fnhandle)
    global flag
%     g = [0;1;0;0;0;1;0;0];
    switch flag.hessian            
        case 'Forward Differencing'
            g = grad_fwd(Y,fnhandle);
        otherwise
            g = grad_central(Y,fnhandle);
    end
end




