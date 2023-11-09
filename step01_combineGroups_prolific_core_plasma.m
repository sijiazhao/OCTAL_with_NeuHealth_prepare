clear; close all;

path_root = 'E:\GitHub\Masud_OxfordCognition';

prolific = readtable(fullfile(path_root,'Project02_prolific\OxCog_analysis_ProlificControl','octal_control_prolific.csv'));
lab = readtable(fullfile(path_root,'OxCog_analysis_LabControl','octal_lab_control_le.csv'));
plasma = readtable(fullfile(path_root,'Project03_Plasma_AD','OxCog_analysis_Plasma','octal_plasma.csv'));


plist = {'group', 'participantID','age','education','ethnicity','gender','ace',...
    'CORSI_mean','DSST_nCorrectResponse','TMT_A','TMT_B',...
    'REY_copy_score','REY_copy_nMove','REY_recall_score','REY_recall_nMove',...
    'ois_ImmediateObjectAccuracy','ois_DelayedObjectAccuracy','ois_ImmediateSemanticAccuracy','ois_DelayedSemanticAccuracy',...
    'ois_ImmediateLocationError','ois_DelayedLocationError',...
    'OMT_ProportionCorrect','OMT_AbsoluteError', 'OMT_TargetDetection','OMT_Misbinding','OMT_Guessing','OMT_Imprecision','OMT_IdentificationTime','OMT_LocalisationTime',...
    'GDS_total','GDS_ifValid','AMI_total','AMI_BehaviouralActivation','AMI_EmotionalSensitivity','AMI_SocialMotivation','AMI_ifValid'};

q = [ plasma(:,plist); lab(:,plist); prolific(:,plist)];

writetable(q,'octal_prolific_lab_plasma.csv');
