% compute SD based on Prolific data
close all;
clear;


colour_ad = [157,2,215]/255;
colour_control = [0 0 0]/255;
colour_sci = [250,135,117]/255;
ageRange = 3;

mkdir(fullfile('figures'));

q = readtable(fullfile('EVERYTHING_meanOverVisits.csv'));

variablelist = {'AMI_total','GDS_total','REY_copy_score','REY_copy_nMove','REY_recall_score','REY_recall_nMove',...
    'OIS_ImmediateObjectAccuracy','OIS_DelayedObjectAccuracy','OIS_ImmediateSemanticAccuracy','OIS_DelayedSemanticAccuracy',...
    'OIS_ImmediateLocationError','OIS_DelayedLocationError',...
    'OMT_ProportionCorrect','OMT_AbsoluteError', 'OMT_TargetDetection','OMT_Misbinding','OMT_Guessing','OMT_Imprecision','OMT_IdentificationTime','OMT_LocalisationTime',...
    'DSST_nCorrectResponse','TMT_A','TMT_B','CORSI_mean'};

A = table;
agelist = 18:1:90; agelist = agelist';
A.age = agelist;
for j = 1:length(variablelist)
    param = variablelist{j};

    % Plot CONTROL mean + 1 std error bar
    a = [];
    b = [];
    c = [];
    for i = 1:height(A.age)
        idx = find(q.age >= A.age(i)-ageRange & q.age < A.age(i)+ageRange & strcmp(q.group,'control'));
        y2 = q.(param)(idx);
        y2(y2>nanmean(y2)+2*nanstd(y2) | y2<nanmean(y2) - 2*nanstd(y2)) = [];

        y2(isnan(y2)) = [];
        
        a = [a; A.age(i)];

        A.([param '_n'])(i) = length(y2);
        A.([param '_mean'])(i) = nanmean(y2);
        tmp = nanstd(y2);
        if tmp == 0 && A.([param '_mean'])(i) == 100
            tmp = nan;
        end
        A.([param '_SD'])(i) = tmp;
    end


    ifPlot = 1;
    if ifPlot
        figure(j);clf; hold on;
        b = A.([param '_mean']);
        c = A.([param '_SD']);

        a_wnan = a; b_wnan = b; c_wnan = c;
        ri = find(isnan(b) | isnan(c)); b(ri) = []; a(ri) = []; c(ri) = [];

        colourRGB = colour_control;
        curve1 = b+c;
        curve2 = flipud(b-c);
        X = [a; flipud(a)];
        Y = [curve1; curve2];
        figfill = fill(X,Y,colourRGB,'edgecolor','none','facealpha',0.1);
        set(get(get(figfill,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
        plot(a_wnan,b_wnan,'Color',colourRGB,'LineWidth',1.5);



        a = [];
        b = [];
        c = [];
        for i = 1:height(A.age)
            idx = find(strcmp(q.group,'AD') & q.age >= A.age(i)-ageRange & q.age < A.age(i)+ageRange);

            y2 = q.(param)(idx); y2(isnan(y2)) = [];
            if length(y2)>1
                a = [a;  A.age(i)];
                b = [b; nanmean(y2)];
                c = [c; nanstd(y2)];
            else
                a = [a; A.age(i)];
                b = [b; nan];
                c = [c; nan];
            end
        end
        a_wnan = a; b_wnan = b; c_wnan = c;
        ri = find(isnan(b) | isnan(c)); b(ri) = []; a(ri) = []; c(ri) = [];
        colourRGB = colour_ad;
        curve1 = b+c;
        curve2 = flipud(b-c);
        X = [a; flipud(a)];
        Y = [curve1; curve2];

        figfill = fill(X,Y,colourRGB,'edgecolor','none','facealpha',0.1);
        set(get(get(figfill,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend

        plot(a_wnan,b_wnan,'Color',colourRGB,'LineWidth',1.5);



        xlabel('Age');
        ylabel(strrep(param,'_',' '));

        axis square;

        xlim([min(agelist) max(agelist)]);
        lg = legend({'Control', 'AD'});
        lg.Location = 'southwest';

        %         set(findall(gcf,'-property','FontName'),'FontName','Diverda Sans Com');
        set(findall(gcf,'-property','FontName'),'FontName','Corbel');
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5]);
        title(strrep(param,'_',' '));

        saveas(gcf,fullfile('figures',['ageRunningMean_' num2str(j) '_' param '.png']));
    end
end

writetable(A,fullfile("norm.csv"));














%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q = readtable(fullfile('EVERYTHING_meanOverVisits.csv'));
q(isnan(q.age),:) = [];

%% Adjust all metrics based on this summary table => effect size (SD units away from control's mean)
for vl = 1:length(variablelist)
    variable = variablelist{vl};
    for s = 1:height(q)
        vMean = A.([variable '_mean'])(A.age == q.age(s));
        vSD = A.([variable '_SD'])(A.age == q.age(s));

        x0 = q.(variable)(s);
        x = (x0-vMean)/vSD;

        q.([variable '_z'])(s) = x;
    end
end
q = sortrows(q,"group","ascend");
writetable(q,fullfile('EVERYTHING_meanOverVisists_norm.csv'));
