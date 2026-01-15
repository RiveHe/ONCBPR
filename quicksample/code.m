figure;

% --- Subplot 1: HYCOM ESPC vs BPR ---
subplot(311); cla; hold on

model1 = TT_pcalc.Pcalc_hPa + demean_filter_slp;
bpr1 = (mefdata_godin - nanmean(mefdata_godin)) * 100;

% Trim to same time span
[model1_trim, bpr1_trim] = synchronizeTimelines(TT_pcalc.Time, model1, time_m, bpr1);

% Plot
plot(TT_pcalc.Time, model1, 'LineWidth', 1);    % HYCOM
plot(time_m, bpr1, 'LineWidth', 1);             % BPR

% RMS
rms_model1 = sqrt(mean(model1_trim.^2, 'omitnan'));
rms_bpr1   = sqrt(mean(bpr1_trim.^2, 'omitnan'));

% Labels
legend('HYCOM ESPC-D-V02','BPR','Location','northwest'); grid on
xlabel('Time'); ylabel('Pressure (hPa)');
xlim([datetime(2024,8,10,'TimeZone',tz) datetime(2025,6,13,'TimeZone',tz)]);
ylim([-15 15]); ax = gca; ax.FontSize = 14;
title('Bottom Pressure: HYCOM ESPC vs BPR')

% Annotate RMS
txt1 = sprintf('RMS(HYCOM) = %.2f hPa\nRMS(BPR) = %.2f hPa', rms_model1, rms_bpr1);
text(ax.XLim(2), ax.YLim(1)+1, txt1, ...
    'HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',12);

% --- Subplot 2: HYCOM GOFS vs BPR ---
subplot(312); cla; hold on

model2 = TT.pressure_godin * 100 - nanmean(TT.pressure_godin) * 100;
bpr2 = (mefdata_godin - nanmean(mefdata_godin)) * 100;

[model2_trim, bpr2_trim] = synchronizeTimelines(dataTable.time, model2, time_m, bpr2);

plot(dataTable.time, model2, 'LineWidth', 1)
plot(time_m, bpr2, 'LineWidth', 1)

rms_model2 = sqrt(mean(model2_trim.^2, 'omitnan'));
rms_bpr2   = sqrt(mean(bpr2_trim.^2, 'omitnan'));

legend('HYCOM GOFS 3.1','BPR','Location','southwest'); grid on
xlabel('Time'); ylabel('Pressure (hPa)');
xlim([datetime(2022,7,1,'TimeZone',tz) datetime(2023,6,30,'TimeZone',tz)]);
ylim([-15 15]); ax = gca; ax.FontSize = 14;
title('Bottom Pressure: HYCOM GOFS vs BPR')

txt2 = sprintf('RMS(HYCOM) = %.2f hPa\nRMS(BPR) = %.2f hPa', rms_model2, rms_bpr2);
text(ax.XLim(2), ax.YLim(1)+1, txt2, ...
    'HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',12);

% --- Subplot 3: GLORYS vs BPR ---
subplot(313); cla; hold on

model3 = bp2_N_nearest;
bpr3 = (mefdata_godin - nanmean(mefdata_godin)) * 100;

[model3_trim, bpr3_trim] = synchronizeTimelines(timedate, model3, time_m, bpr3);

plot(timedate, model3, 'LineWidth', 1)
plot(time_m, bpr3, 'LineWidth', 1)

rms_model3 = sqrt(mean(model3_trim.^2, 'omitnan'));
rms_bpr3   = sqrt(mean(bpr3_trim.^2, 'omitnan'));

legend('GLORYS','BPR','Location','northwest'); grid on
xlabel('Time'); ylabel('Pressure (hPa)');
xlim([datetime(2024,8,10,'TimeZone',tz) datetime(2025,6,13,'TimeZone',tz)]);
ylim([-15 15]); ax = gca; ax.FontSize = 14;
title('Bottom Pressure: GLORYS vs BPR')

txt3 = sprintf('RMS(GLORYS) = %.2f hPa\nRMS(BPR) = %.2f hPa', rms_model3, rms_bpr3);
text(ax.XLim(2), ax.YLim(1)+1, txt3, ...
    'HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',12);

%%
addpath("C:\Users\River\Downloads\pmtmPH_cmtm")
figure;
offset_step_spec = 2.0;
nw = 1;  % Time-bandwidth product
t_zone = 'UTC';

% ---------- Subplot 1: HYCOM ESPC + BPR ----------
subplot(311); cla; hold on

% Time range
t_start1 = datetime(2024,8,10,'TimeZone',t_zone);
t_end1   = datetime(2025,6,13,'TimeZone',t_zone);

% Extract HYCOM ESPC
hycom = TT_pcalc.Pcalc_hPa + demean_filter_slp;
mask_hycom = TT_pcalc.Time >= t_start1 & TT_pcalc.Time <= t_end1;
x1 = hycom(mask_hycom);
x1 = fillmissing(x1,'linear','EndValues','nearest');
x1 = x1 - nanmean(x1);
dt1 = 1/24;  % hourly in days
[P1, f1] = pmtmPH_ori(x1, dt1, nw, 0, numel(x1));
plot(f1, log10(P1), 'LineWidth',1.2, 'DisplayName','HYCOM ESPC');

% Extract BPR
mask_bpr1 = time_m >= t_start1 & time_m <= t_end1;
xB1 = mefdata_godin(mask_bpr1)*100;
xB1 = fillmissing(xB1,'linear','EndValues','nearest');
xB1 = xB1 - nanmean(xB1);
dtB1 = double(days(median(diff(time_m(mask_bpr1)))));
if ~isfinite(dtB1) || dtB1 <= 0, dtB1 = 1/24; end
[PB1, fB1] = pmtmPH_ori(xB1, dtB1, nw, 0, numel(xB1));
plot(fB1, log10(PB1),  'LineWidth',1.2, 'DisplayName','BPR');
ax = gca;
ax.FontSize = 14;

xlim([1e-2 0.5]);
% xlabel('Frequency (cpd)');
set(gca, 'XScale', 'log')
xticks([1e-2, 1e-1, 1e0])
xticklabels({'10^{-2}', '10^{-1}', '10^{0}'})
%xlim([1e-2 1e0])
xlabel('Cycle / Day')  % or use 'Frequency (cpd)' if you prefer


ylabel('log_{10} Power');
title('Spectrum: HYCOM ESPC vs BPR from 2024-8-10 to 2025-6-13');
legend('show','Location','southwest'); grid on;

% ---------- Subplot 2: HYCOM GOFS + BPR ----------
subplot(312); cla; hold on

t_start2 = datetime(2022,8,3,'TimeZone',t_zone);
t_end2   = datetime(2023,6,30,'TimeZone',t_zone);

mask_gofs = dataTable.time >= t_start2 & dataTable.time <= t_end2;
x2 = TT.pressure_godin(mask_gofs)*100;
x2 = fillmissing(x2,'linear','EndValues','nearest');
x2 = x2 - nanmean(x2);
dt2 = double(days(median(diff(dataTable.time(mask_gofs)))));
if ~isfinite(dt2) || dt2 <= 0, dt2 = 1/24; end
[P2, f2] = pmtmPH_ori(x2, dt2, nw, 0, numel(x2));
plot(f2, log10(P2),  'LineWidth',1.2, 'DisplayName','HYCOM GOFS');

mask_bpr2 = time_m >= t_start2 & time_m <= t_end2;
xB2 = mefdata_godin(mask_bpr2)*100;
xB2 = fillmissing(xB2,'linear','EndValues','nearest');
xB2 = xB2 - nanmean(xB2);
dtB2 = double(days(median(diff(time_m(mask_bpr2)))));
if ~isfinite(dtB2) || dtB2 <= 0, dtB2 = 1/24; end
[PB2, fB2] = pmtmPH_ori(xB2, dtB2, nw, 0, numel(xB2));
plot(fB2, log10(PB2), 'LineWidth',1.2, 'DisplayName','BPR');
ax = gca;
ax.FontSize = 14;

xlim([1e-2 0.5]);
% xlabel('Frequency (cpd)');
set(gca, 'XScale', 'log')
xticks([1e-2, 1e-1, 1e0])
xticklabels({'10^{-2}', '10^{-1}', '10^{0}'})
%xlim([1e-2 1e0])
xlabel('Cycle / Day')  % or use 'Frequency (cpd)' if you prefer

ylabel('log_{10} Power');
title('Spectrum: HYCOM GOFS vs BPR from 2022-8-3 to 2023-6-30');
legend('show','Location','southwest'); grid on;

% ---------- Subplot 3: GLORYS vs BPR ----------
subplot(313); cla; hold on

% t_start3 = datetime(2022,8,3,'TimeZone',t_zone);
% t_end3   = datetime(2023,6,30,'TimeZone',t_zone);
t_start3 = datetime(2024,8,10,'TimeZone',t_zone);
t_end3   = datetime(2025,6,13,'TimeZone',t_zone);

mask_glorys = timedate >= t_start3 & timedate <= t_end3;
x3 = bp2_N_nearest(mask_glorys);
x3 = fillmissing(x3,'linear','EndValues','nearest');
x3 = x3 - nanmean(x3);
dt3 = double(days(median(diff(timedate(mask_glorys)))));
if ~isfinite(dt3) || dt3 <= 0, dt3 = 1/24; end
[P3, f3] = pmtmPH_ori(x3, dt3, nw, 0, numel(x3));
plot(f3, log10(P3),'LineWidth',1.2, 'DisplayName','GLORYS');

mask_bpr3 = time_m >= t_start3 & time_m <= t_end3;
xB3 = mefdata_godin(mask_bpr3)*100;
xB3 = fillmissing(xB3,'linear','EndValues','nearest');
xB3 = xB3 - nanmean(xB3);
dtB3 = double(days(median(diff(time_m(mask_bpr3)))));
if ~isfinite(dtB3) || dtB3 <= 0, dtB3 = 1/24; end
[PB3, fB3] = pmtmPH_ori(xB3, dtB3, nw, 0, numel(xB3));
plot(fB3, log10(PB3), 'LineWidth',1.2, 'DisplayName','BPR');
ax = gca;
ax.FontSize = 14;

xlim([1e-2 0.5]);
set(gca,'XScale','log');

% xlabel('Frequency (cpd)');
% === X-axis formatting ===
set(gca, 'XScale', 'log')
xticks([1e-2, 1e-1, 1e0])
xticklabels({'10^{-2}', '10^{-1}', '10^{0}'})
%xlim([1e-2 1e0])
xlabel('Cycle / Day')  % or use 'Frequency (cpd)' if you prefer


ylabel('log_{10} Power');
title('Spectrum: GLORYS vs BPR from 2024-8-10 to 2025-6-13');
legend('show','Location','southwest'); grid on;