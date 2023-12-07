/*
addpath('/Applications/Dynare/5.5-arm64/matlab')

This version v10: passive monetary policy


the following parameters are defined in Matlab file galigabparms.mat before running:
    cogdisc, lambd, thet 
This dynare file extends the Model of Gali et al. (2007) with the 
cognitive discounting framework from Gabaix (2020).
*/

var n c pi k b g y mu_hat_p invest w nom_rate tax tobin_q r_k;
varexo epsilon_g; // government spending shock

load galigabparms.mat // load variables previously defined

parameters M M_f beta delta mu_p alpha lambda theta varphi eta phi_pi phi_b phi_g rho rho_g gamma_g gamma_c lambda_p THETA_n THETA_t sigma gamma_i Gamma phi_y rho_a;

set_param_value('M', cogdisc);       // Cognitive Discounting, Gab: 0.85
set_param_value('lambda', lambd);       // Rule-of-Thumb Share, Gali: 0.5 
set_param_value('theta', thet);       // Price Stickyness, Gali: 0.75

disp([M, lambda, theta]);
mlt =([M, lambda, theta]);
// M = cogdisc;
beta = 0.99;
mu_p = 1.2; 
delta = 0.025; 
alpha = 1/3; 
// lambda = lambd; // Gali: 0.5 
// theta = thet; // Gali: 0.75
varphi = 0.2; 
eta = 1.0; 
phi_pi = 0; // Passive mon pol
phi_y = 0;  // Passive mon pol
phi_b = 0.33; 
phi_g = 0.1; 
rho_g = 0; // persistence of gov. spending shock, Gali: 0.9 
rho_a = 0;
gamma_g = 0.2;


M_f = M*(theta + (1-theta)*((1-beta*theta)/(1-beta*theta*M)) );
lambda_p = ((1-beta*theta)*(1-theta))/theta;
rho = 1/beta - 1;
gamma_c = 1-gamma_g-((delta*alpha)/((rho+delta)*(mu_p)));
gamma_i = 1-gamma_g-gamma_c;

// Euler Equation parms: imperfect labor market setup
//PHI = 1/(gamma_c*mu_p - lambda*(1-alpha));
//THETA_n = lambda*PHI*(1-alpha)*(1+varphi);
//THETA_t = lambda*PHI*mu_p;
//sigma = gamma_c*PHI*(1-lambda)*mu_p;

// Euler Equation parms: perfect labor market setup
Gamma=1/(mu_p*varphi*gamma_c+(1-alpha)*(1-lambda*(1+varphi))); //p.244
sigma=(1-lambda)*Gamma*(mu_p*varphi*gamma_c+(1-alpha)); //p.244
THETA_n=lambda*Gamma*(1-alpha)*(1+varphi)*varphi; //p.244
THETA_t=lambda*Gamma*mu_p*varphi; //p.244 


// Forward looking variables: tobin_q, r_k, pi, c, tax, n

model(linear);

// HOUSEHOLDS: 
// tobin_q
tobin_q = beta*M*tobin_q(+1) + (1-beta*(1-delta))*r_k(+1) - (nom_rate-pi(+1)); //23

// capital adjustment elasticity
invest - k(-1) = eta*tobin_q; //24

// capital
k = delta*invest + (1-delta)*k(-1); //25

// Euler
c = M*c(+1) - sigma*(nom_rate-pi(+1)) - THETA_n*(n(+1)-n) + THETA_t*(tax(+1)-tax); //31

// wages
w = c + varphi*n; //30

// FIRMS: 
// NKPC
pi = beta*M_f*pi(+1) - lambda_p*mu_hat_p; //32

// [name = 'Markup: Average output per worker minus wages']
mu_hat_p = (y - n) - w; //

// [name = 'Markup: Output per capital minus rental cost']
mu_hat_p = (y - k(-1)) - r_k; //34

// [name = 'aggregate production']
y = (1-alpha)*n + alpha*k(-1); //35

// [name = 'Market clearing condition']
y = gamma_c*c + gamma_i*invest + g; //36 


// POLICY: 
// [name = 'Taylor Rule']
nom_rate = rho + phi_pi*pi + phi_y*y; //18

// [name = 'Government Debt Evolution']
b=(1+rho)*(b(-1)+g-tax); // 37 W/O market clearing condition

// [name = 'Fiscal Policy Rule']
tax = phi_b*b(-1) + phi_g*g; //20

// [name = 'Government Shock']
g = rho_g*g(-1)+epsilon_g;


end;


initval;
k = 0;
b = 0;
g = 0;
c = 0;
y = 0;
end;

endval;
//n = 0;
c = 0;
y = 0;
pi = 0;
//tax = 0;
tobin_q = 0;
//r_k = 0;
end;


resid(1);
steady;
check; // Check Blanchard-Kahn conditions
model_info; 

shocks;
// var epsilon_g; stderr 1;
var epsilon_g;
periods 10;
values 1;
end;



perfect_foresight_setup(periods=25); // for IRFs
// stoch_simul(order=1,irf=20) g tax y c invest n w b r_k pi k mu_hat_p nom_rate tobin_q; // for IRFs
// stoch_simul(order=1,irf=30, nocorr, nodecomposition, nofunctions, nomoments, nograph); // for Determinacy checks
perfect_foresight_solver(print);
// rplot g tax y c invest n w b r_k pi k mu_hat_p nom_rate tobin_q;
//rplot y c pi g tax b;
dynasave(mlt) y c pi g tax b;
// rplot n w r_k k tobin_q c;

