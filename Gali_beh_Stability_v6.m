%% Replicate the Uniqueness region plot with cognitive discounting (Figure 2, Gali et al. 2007)   
% This version: Distinguish Indeterminacy / stable equilibrium
% To only check for Determinacy, comment out the elseif-statement in the loop 
% Run with Gali_beh_v10_PhiY for Monetary policy with Output Gap Response
% Run with Gali_beh_v10 for Monetary policy as in Gali
%%Matlab version R2023b

addpath('/Applications/Dynare/5.3/matlab')
clc, tic
%% Initiate vectors %%
%plottype = ["Subplots", "Multiline"];
increment = 25; % define granularity of linspace
    lamb = linspace(0,1,increment + 1); % share of rot-consumers
    the = linspace(0,1,increment + 1);
% Cogdis: Adjust Subplot-Grid!
    cogdis = [1, 0.85, 0.65];
lambdacrit = ones(length(cogdis),length(the))*1.01;  % preallocate lambdacrit: save critical values where model turns indeterminate
%% calculations %%
for l=1:length(cogdis)
    for j=1:length(the)
        cogdisc = cogdis(l); %iterate through M
        thet = the(j); %iterate through theta
        indeterminacy_error_occurred = false; 
        if indeterminacy_error_occurred == false %Iterate through lambda only while there is no indeterminacy
            for i=1:length(lamb)          
                lambd = lamb(i); %iterate through lambda
                save('galigabparms.mat', 'cogdisc', 'lambd', 'thet'); % Save the variables to a .mat file
                try
                   % dynare Gali_beh_v10_PhiY nograph noclearall notime nopreprocessoroutput; 
                   dynare Gali_beh_v10 nograph noclearall notime nopreprocessoroutput; 
                catch ME
                    fprintf('Error for lambda=%.2f, theta =:%.2f %s\n', lambd, thet, ME.message);
                    lasterrorparms = [cogdisc, lambd, thet];
                    %Comment this elseIf-statement to only check for
                    %Determinacy
                    if strcmp(ME.message, 'Blanchard & Kahn conditions are not satisfied: no stable equilibrium.')
                        % Save lambda to lambda_crit when the specific error occurs
                        lambdacrit(l,j) = lamb(i); %catch LAMBDA that leads to Indeterminacy
                        fprintf('Error for lambda=%.2f, theta =:%.2f %s\n', lambd, thet, ME.message);
                        indeterminacy_error_occurred = true; % Set the flag to true
                        break; % Break out of the lambda-loop
                    end
                end
            end
        end
    end 
end
toc

%% Plots
% %% Multiple Lines
% figure
% legend_labels = cell(1, length(cogdis));% n = 1;
% c = [zeros(1,3); hsv(length(cogdis))];
% for i=1:length(cogdis) 
%     plot(the, lambdacrit(i,:),'--.', 'color', c(i,:), 'MarkerSize',20); 
%     legend_labels{i} = sprintf('M=%.3f', cogdis(i));   
%     hold on;
%     %plot(the,lambdacrit(2,:),'--ob','LineWidth',1.5);
%     %plot(the,lambdacrit(3,:),'--o','LineWidth',1.5);
%     %plot(the,lambdacrit(4,:),'--o','LineWidth',1.5);
% end
% legend(legend_labels, 'Location', 'southwest', 'Fontsize', 15)
% title('Indeterminacy Region','FontSize', 20)
% xlabel('Price Stickyness $\theta$','FontSize', 15, 'Interpreter', 'latex')
% ylabel('Share of rule of thumb-households $\lambda$','FontSize', 15, 'Interpreter', 'latex')
% ylim([0 1])
% xlim([0 1])
% grid on
% exportgraphics(gcf,sprintf('Plots/determ_lines_m_in_=%.3f,%.3f.png', cogdis(1),cogdis(length(cogdis))),'Resolution',300) %gcf: get current file

%% Multiple Subplots w/ coloring
C = {'m','b','r','g','k','c'};
legend_labels = cell(1, length(cogdis));% n = 1;
n = 1;
m = 3;
fig = figure;
    for i=1:length(cogdis)
    subplot(n,m,i)
    patch([the fliplr(the)], [lambdacrit(i,:) max(ylim)*ones(size(lambdacrit(i,:)))], C{i}, 'FaceAlpha',.1) % Above Upper Curve
    legend(sprintf('M=%.3f', cogdis(i)), 'Location', 'southwest', 'Fontsize', 15)
    grid on
    ylim([0 1])
    hold on
    end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel(han,'Price Stickiness $\theta$','FontSize', 18, 'Interpreter', 'latex');
ylabel(han,'rule of thumb-share $\lambda$','FontSize', 18, 'Interpreter', 'latex');
title(han,'','FontSize', 17);
%title(han,'Indeterminacy Regions','FontSize', 18);
% xlabel('Price Stickyness $\theta$','FontSize', 15, 'Interpreter', 'latex')
% ylabel('rule of thumb-share $\lambda$','FontSize', 15, 'Interpreter', 'latex')
%exportgraphics(gcf,sprintf('Plots/determ_subplots_m_in_=%.3f,%.3f.png', cogdis(1),cogdis(length(cogdis))),'Resolution',300) %gcf: get current file
