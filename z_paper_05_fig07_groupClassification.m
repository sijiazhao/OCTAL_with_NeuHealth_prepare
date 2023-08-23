clear; close all;

a = readtable('EVERYTHING_meanOverVisists_norm.csv');

tbl = a;
tbl(isnan(tbl.pTau_181),:) = [];
tbl(tbl.age<50,:) = [];

tbl.group = categorical(tbl.group);
% tbl = tbl(tbl.group == 'control' | tbl.group == 'AD' | tbl.group == 'SCI and MCI',:);
tbl = tbl(tbl.group == 'control' | tbl.group == 'AD',:);
tbl = tbl(:,{'AMI_total_z','GDS_total_z','REY_copy_score_z','REY_recall_score_z',...
    'OIS_ImmediateObjectAccuracy','OIS_DelayedObjectAccuracy_z','OIS_ImmediateSemanticAccuracy','OIS_DelayedSemanticAccuracy_z',...
    'OIS_ImmediateLocationError_z','OIS_DelayedLocationError_z',...
    'OMT_ProportionCorrect_z','OMT_AbsoluteError_z', 'OMT_TargetDetection_z','OMT_Misbinding_z','OMT_Guessing_z','OMT_Imprecision_z','OMT_IdentificationTime_z','OMT_LocalisationTime_z',...
    'DSST_nCorrectResponse_z','TMT_A','TMT_B','CORSI_mean_z','AB40','AB42','AB42_42Ratio','GFAP','NFL','pTau_181','group'});
% X = [a.srt_mean_z, a.rt_mean_z, a.responseRate, a.fatigue_mean];
% Y = a.group;
[idx,scores] = fscchi2(tbl,'group');



figure;
bp = bar(scores(idx));
bp.FaceColor = [255, 127, 80]/255;
bp.EdgeColor = 'none';
xlabel('Predictor rank')
ylabel('Predictor importance score')

plist = tbl.Properties.VariableNames(idx);
plist = strrep(plist,'_',' ');

for i = 1:length(plist)
    tpp = text(i,1,plist{i});
    tpp.Rotation = 90;
    tpp.Color = 'k';
    tpp.FontName = 'Corbel';
    tpp.FontSize = 12;
end

yl = ylim;xl=xlim;
y = -log(0.01);
line(xl,[y y],'Color','k','LineStyle','--');

y = -log(0.001);
line(xl,[y y],'Color','k','LineStyle','--');

xlim(xl);
PVALS = exp(-scores(idx))
significantIdx = find(PVALS<0.05)

sig = cell(1,length(plist));
sig(significantIdx) = {'*'};
xticks(1:1:length(sig));
xticklabels(sig)
% hold on
% bar(scores(idx(length(idxInf)+1))*ones(length(idxInf),1))
% legend('Finite Scores','Inf Scores')
% hold off

axis square;

set(findall(gcf,'-property','FontName'),'FontName','Diverda Sans Com');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 8]);

filename = 'figure_bar_predictor';
% saveas(gcf,fullfile('figures_paper', [filename '.png']));
saveas(gcf,fullfile('figures', [filename '.svg']));
