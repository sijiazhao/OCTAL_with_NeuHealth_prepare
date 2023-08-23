plist = {'group', 'participantID','age','education','gender','ace',...
    'REY_copy_score','REY_copy_nMove','REY_recall_score','REY_recall_nMove',...
    'OIS_ImmediateObjectAccuracy','OIS_DelayedObjectAccuracy','OIS_ImmediateSemanticAccuracy','OIS_DelayedSemanticAccuracy',...
    'OIS_ImmediateLocationError','OIS_DelayedLocationError',...
    'OMT_ProportionCorrect','OMT_AbsoluteError', 'OMT_TargetDetection','OMT_Misbinding','OMT_Guessing','OMT_Imprecision','OMT_IdentificationTime','OMT_LocalisationTime',...
    'DSST_nCorrectResponse','TMT_A','TMT_B','CORSI_mean'};


%% lab (mostly) controls + LE
lab = readtable(fullfile('E:\GitHub\Masud_OxfordCognition\OxCog_analysis_LabControl','a_labcontrol.csv'));
lab.REY_copy_score = lab.copy_score;
lab.REY_recall_score = lab.recall_score;
lab.REY_copy_nMove = lab.copy_nMove;
lab.REY_recall_nMove = lab.recall_nMove;

write(lab,fullfile('control_lab.csv'));

prolific = readtable(fullfile('E:\GitHub\Masud_OxfordCognition\OxCog_analysis_ProlificControl','a_prolificcontrol.csv'));
prolific.group = repmat({'control'},height(prolific),1);
write(prolific,fullfile('control_prolific.csv'));

ad = readtable(fullfile('E:\GitHub\Masud_OxfordCognition\Project03_Plasma_AD\OxCog_analysis_Plasma\outputs','a.csv'));
write(ad,fullfile('ad.csv'));

lump = [ad(:,plist);lab(:,plist); prolific(:,plist)];

%% Manually exclude participant, correct ID/group,
x = lump;
t = readtable('CORRECT_PARTICIPANT_ID_GROUP.xlsx');
t1 = t(t.exclude==1,:);
for i = 1:height(t1)
    x(strcmp(x.participantID,t1.participantID{i}),:) = [];
end
t1 = t(t.replaceName==1,:);
for i = 1:height(t1)
    x.participantID(strcmp(x.participantID,t1.participantID{i})) = t1.new(i);
end
t1 = t(~cellfun(@isempty, t.group),:);
for i = 1:height(t1)
    x.group(strcmp(x.participantID,t1.participantID{i})) = t1.group(i);
end
lump  = x;

%% add questionnaires
plist = {'GDS_total','AMI_total'}; %,'AMI_BehaviouralActivation','AMI_EmotionalSensitivity','AMI_SocialMotivation'
for i = 1:length(plist)
    lump.(plist{i}) = nan(height(lump),1);
end
tbl = ad;
for s = 1:height(lump)
    subject = lump.participantID{s};
    idx = find(strcmp(tbl.participantID,subject));
    if length(idx)>1
        idx = idx(1);
    end
    if ~isempty(idx)
        for i = 1:length(plist)
            lump.(plist{i})(s) = tbl.(plist{i})(idx);
        end
    end
end

tbl = readtable(fullfile('E:\GitHub\Masud_OxfordCognition\Project02_GiantProlific\demographics_oxcog_prolific\qualtrics\OxCog_prolific','result_Questionnaire.csv'));
for s = 1:height(lump)
    subject = lump.participantID{s};
    idx = find(strcmp(tbl.participantID,subject));
    if length(idx)>1
        idx = idx(1);
    end
    if ~isempty(idx)
        for i = 1:length(plist)
            lump.(plist{i})(s) = tbl.(plist{i})(idx);
        end
    end
end
tbl = readtable(fullfile('E:\GitHub\Masud_OxfordCognition\Project01_core\demographics_oxcog_core','result_Questionnaire.csv'));
for s = 1:height(lump)
    subject = lump.participantID{s};
    idx = find(strcmp(tbl.participantID,subject));
    if length(idx)>1
        idx = idx(1);
    end
    if ~isempty(idx)
        for i = 1:length(plist)
            lump.(plist{i})(s) = tbl.(plist{i})(idx);
        end
    end
end
lump = movevars(lump,'AMI_total','After','gender');lump = movevars(lump,'GDS_total','After','gender');

%% ADD PLASMA BIOMARKER DATA
plist = {'AB40Conc__pg_ml_','AB42Conc__pg_ml_','AB42_20Ratio','GFAPConc__pg_ml_','NFLConc__pg_ml_','pTau_181Conc__pg_ml_'};
for i = 1:length(plist)
    lump.(plist{i}) = nan(height(lump),1);
end

tbl = readtable('plasma.xlsx');
tbl.participantID = tbl.Kcode_data1;

for s = 1:height(tbl)
    idx = find(strcmp(lump.participantID,tbl.participantID{s}));
    if length(idx)>1
        disp('?');
        idx = idx(1);
    end
    if ~isempty(idx)
        for i = 1:length(plist)
            lump.(plist{i})(idx) = tbl.(plist{i})(s);
        end
    end
end

% plist_new = {'AB40_pg_ml','AB42_pg_ml','AB42_42Ratio','GFAP_pg_ml','NFL_pg_ml','pTau_181_pg_ml'};
plist_new = {'AB40','AB42','AB42_42Ratio','GFAP','NFL','pTau_181'};
lump = renamevars(lump,plist,plist_new);

lump.gender = categorical(lump.gender);
lump.gender(lump.gender == 'Male') = 'male';
lump.gender(lump.gender == 'Female') = 'female';
writetable(lump,'EVERYTHING.csv');


%% Average across visist
l = lump;

l.id = l.participantID; l = movevars(l, "id", "Before", "participantID");
l.visit = ones(height(l),1); l = movevars(l, "visit", "Before", "participantID");
for i = 1:height(l)

    tmp = split(l.participantID{i},'_');
    if length(tmp)>1 && length(tmp{2})<2
        l.id{i} = tmp{1};
        l.visit(i) = str2num(tmp{2});
    end
end

sublist = unique(l.id);
plist = {'group', 'id','age','education','gender'};
plist2 = {'GDS_total','AMI_total','ace','REY_copy_score','REY_copy_nMove','REY_recall_score','REY_recall_nMove','OIS_ImmediateObjectAccuracy','OIS_DelayedObjectAccuracy','OIS_ImmediateSemanticAccuracy','OIS_DelayedSemanticAccuracy','OIS_ImmediateLocationError','OIS_DelayedLocationError','OMT_ProportionCorrect','OMT_AbsoluteError','OMT_TargetDetection','OMT_Misbinding','OMT_Guessing','OMT_Imprecision','OMT_IdentificationTime','OMT_LocalisationTime','DSST_nCorrectResponse','TMT_A','TMT_B','CORSI_mean','AB40','AB42','AB42_42Ratio','GFAP','NFL','pTau_181'};

a = table;

for s = 1:length(sublist)
    idx = find(strcmp(l.id,sublist{s}));
    b = l(idx,plist2);
    b = varfun(@mean,b, 'InputVariables', @isnumeric);
    a(s,:) = [l(idx(1),plist),b];
end

for i = 1:length(a.Properties.VariableNames)
a.Properties.VariableNames{i} = strrep(a.Properties.VariableNames{i},'mean_','');
end
writetable(a,'EVERYTHING_meanOverVisits.csv');

