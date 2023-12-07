%Set parameters to run the Dynare code with these values
%%Matlab version R2023b


function parms = setparms(mlt_array)
 % Define the three parameters M, lambda and theta 
    cogdisc = mlt_array(1);
    lambd = mlt_array(2);
    thet = mlt_array(3);
    save('galigabparms.mat', 'cogdisc', 'lambd', 'thet'); % Save the variables to a .mat file
    disp('Setting M, lambda and theta to ')
    disp([cogdisc, lambd, thet])
end