%%Return the value of the determinacy criterion. If det>0, there is a
%%unique stable equilibrium even when monetary policy is passive. Baseline
%%calibration as in Gabaix(2020)
%%Matlab version R2023b

function det = determinacy(m,theta)
    beta = 0.99;
    gamma = 5;
    phi = 1;
    R = 1/beta;
    kappa = ((1-theta)/theta)*(1-beta*theta)*(gamma+phi);
    sigma = 1/(gamma*R);
    M_f = m*(theta + (1-theta)*((1-beta*theta)/(1-beta*theta*m)));
    det = (((1-beta*M_f)*(1-m))/(kappa*sigma))-1;
end
