% Plot IRFS for an announced transitory fiscal policy shock with different parameters, baseline M=0.85
% Set phi_pi and phi_y in Gali_beh_v9_fiscal_announcement.mod first
% plot1: phi_pi=1.2, phi_y=0.5 // plot2: phi_pi=1.2, phi_y=0 // plot3: phi_pi=0, phi_y=0
% this version: Different parameter values (M=0.85)
%%Matlab version R2023b

addpath('/Applications/Dynare/5.5-arm64/matlab')
fig = figure;
%scheme = [zeros(1,3); hsv(5)]; %create color scheme
scheme = hsv(6);
% xlabel('Period','FontSize', 15, 'Interpreter', 'latex')
% ylabel('Variable','FontSize', 15, 'Interpreter', 'latex')
t = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');  
xlabel(t,'Period','FontSize', 15);
ylabel(t,'Deviation from Steady State','FontSize', 15);
nexttile
    setparms([1,0,0.75])
    dynare Gali_beh_v9_fiscal_announcement
    periods = 0:length(c)-1;
    load("mlt.mat")
        plot(periods, c, 'm', 'LineWidth', 1.5, 'LineStyle','-'); 
        hold on;
        plot(periods, pi, 'r', 'LineWidth', 1.5, 'LineStyle','-'); 
        plot(periods, y, 'k', 'LineWidth', 1.5, 'LineStyle','-'); 
    xlim([1 length(c)-1]),ylim([-0.6,1.2])
    title('$M=1,\lambda=0,\theta=0.75$','FontSize', 15, 'Interpreter', 'latex', 'Fontsize', 20)
    grid on
nexttile
    setparms([1,0.5,0.75])
    dynare Gali_beh_v9_fiscal_announcement
    load("mlt.mat")
        plot(periods, c, 'm', 'LineWidth', 1.5, 'LineStyle','-'); 
        hold on;
        plot(periods, pi, 'r', 'LineWidth', 1.5, 'LineStyle','-'); 
        plot(periods, y, 'k', 'LineWidth', 1.5, 'LineStyle','-'); 
        plot(periods, g, 'c', 'LineWidth', 1.5, 'LineStyle','-.');
        plot(periods, tax, 'g', 'LineWidth', 1.5, 'LineStyle','-.');
        plot(periods, b, 'b', 'LineWidth', 1.5, 'LineStyle','-.');
    xlim([1 length(c)-1]),ylim([-0.6,1.2])
    legend(["Aggregate Consumption","Inflation","Output","Government Spending","Taxes","Debt"], 'Location', 'NorthWest', 'Fontsize', 14)
    title('$M=1,\lambda=0.5,\theta=0.75$','FontSize', 15, 'Interpreter', 'latex', 'Fontsize', 20)
    grid on
nexttile
    setparms([1,0.5,0.875])
    dynare Gali_beh_v9_fiscal_announcement
    load("mlt.mat")
        plot(periods, c, 'm', 'LineWidth', 1.5, 'LineStyle','-'); 
        hold on;
        plot(periods, pi, 'r', 'LineWidth', 1.5, 'LineStyle','-'); 
        plot(periods, y, 'k', 'LineWidth', 1.5, 'LineStyle','-'); 
    xlim([1 length(c)-1]),ylim([-0.6,1.2])
    title('$M=1,\lambda=0.5,\theta=0.875$','FontSize', 15, 'Interpreter', 'latex', 'Fontsize', 20)
    grid on
nexttile
    setparms([0.85,0,0.75])
    dynare Gali_beh_v9_fiscal_announcement
    load("mlt.mat")
        plot(periods, c, 'm', 'LineWidth', 1.5, 'LineStyle','-'); 
        hold on;
        plot(periods, pi, 'r', 'LineWidth', 1.5, 'LineStyle','-'); 
        plot(periods, y, 'k', 'LineWidth', 1.5, 'LineStyle','-'); 
    xlim([1 length(c)-1]),ylim([-0.6,1.2])
    title('$M=0.85,\lambda=0,\theta=0.75$','FontSize', 15, 'Interpreter', 'latex', 'Fontsize', 20)
    grid on
nexttile
    setparms([0.85,0.5,0.75])
    dynare Gali_beh_v9_fiscal_announcement
    load("mlt.mat")
        plot(periods, c, 'm', 'LineWidth', 1.5, 'LineStyle','-'); 
        hold on;
        plot(periods, pi, 'r', 'LineWidth', 1.5, 'LineStyle','-'); 
        plot(periods, y, 'k', 'LineWidth', 1.5, 'LineStyle','-'); 
    xlim([1 length(c)-1]),ylim([-0.6,1.2])
    %legend(["Aggregate Consumption","Inflation","Output"], 'Location', 'NorthEast', 'Fontsize', 15)
    title('$M=0.85,\lambda=0.5,\theta=0.75$','FontSize', 15, 'Interpreter', 'latex', 'Fontsize', 20)
    grid on
nexttile
    setparms([0.85,0.5,0.875])
    dynare Gali_beh_v9_fiscal_announcement
    load("mlt.mat")
        plot(periods, c, 'm', 'LineWidth', 1.5, 'LineStyle','-'); 
        hold on;
        plot(periods, pi, 'r', 'LineWidth', 1.5, 'LineStyle','-'); 
        plot(periods, y, 'k', 'LineWidth', 1.5, 'LineStyle','-'); 
    xlim([1 length(c)-1]),ylim([-0.6,1.2])
    title('$M=0.85,\lambda=0.5,\theta=0.875$','FontSize', 15, 'Interpreter', 'latex', 'Fontsize', 20)
    grid on
