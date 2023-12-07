% Plots the Plane of contemporaneous consumption response. 
% takes several minutes to compute Depending on Granularity.
%%Matlab version R2023b

addpath('/Applications/Dynare/5.5-arm64/matlab')
clc
clear

%% Initiate vectors
thet = 0.75; % Gali value of price stickyness

granularity = 0.05; 
cog_disc = 0.25:granularity:1;
lamb = 0:granularity:0.75;
results_cons = ones(2,length(lamb));
results_out = ones(length(lamb),length(cog_disc))*1.01;

err = zeros(length(lamb),length(cog_disc));

%% calculations

for l = 1:length(lamb)
    for i=1:length(cog_disc)
        lambd = lamb(l); 
        cogdisc = cog_disc(i); 
        save('galigabparms.mat', 'cogdisc', 'lambd', 'thet'); % Save the variables to a .mat file
        try
            dynare Gali_beh_v10 nograph noclearall; 
        catch
            err(l,i)= 1;
            disp(['Error: M, l, thet: ', string(cogdisc), string(lambd), string(thet)]); % Save the variables to a .mat file
        end
        results_cons(l,i) = c_epsilon_g(1); %save first-period value
        results_out(l,i) = y_epsilon_g(1);
    end
end


%% Plots
figure
mesh(cog_disc, lamb, results_cons)
grid on
% Define the colormap and set the color limits based on 'z'
colormap([1 0 0; 0 1 0]);  % Red for z <= 0, Green for z > 0
clim([-1 1]);             % Set color limits from -1 (red) to 1 (green)
%colorbar
ax = gca;
ax.XDir = 'reverse'; 
xlabel('Cognitive Discounting parameter M', 'FontSize', 19, 'Interpreter', 'latex')
ylabel('Hand-to-Mouth share $\lambda$', 'FontSize', 19, 'Interpreter', 'latex')
zlabel('Contemporaneous consumption response', 'FontSize', 19)
exportgraphics(gcf,sprintf('Plots/cons_sensitivity_theta=%.2f.png', thet),'Resolution',400) %gcf: get current file

