%% Script to define and load to workspace acquisition parameters

%% Experimental setup parameters

params.ftsPortName='ft';
params.amtiPortName='amti';

params.calibMatPath = './data/official_calibration_matrices/'; % path to where calibration matrices can be found

params.ftsNames={'ftShoe_right_front', 'ftShoe_right_rear'};
params.ftsSerialNumbers={'SN026', 'SN230'}; % should be defined in the same order of ftNames
params.amtiNames={'first', 'second'}; % should be defined in the same order of ftNames

% Special trial to remove offsets when no weight applied
params.staticOffsetExp = 'analog_o_00018';

params.staticOffsetAcqPath = './data/sept_25/right_noInSitu/dumper';
params.acqPath = './data/sept_25/right_noInSitu/dumper';
params.expList = {%'analog_o_00001', ...
                  %'analog_o_00002', ...
                  %'analog_o_00003', ...
                  %'analog_o_00004', ...
                  'analog_o_00006', ...
                  'analog_o_00007', ...
                  'analog_o_00008', ...
                  'analog_o_00009', ...
                  'analog_o_00010', ...
                  'analog_o_00011', ...
                  'analog_o_00012', ...
                  'analog_o_00013', ...
                  'analog_o_00014', ...
                  'analog_o_00015', ...
                  'analog_o_00016', ...
                  'analog_o_00017'};

% Sublist of tasks useful for calibration
params.calibExpList = {%'analog_o_00002', ...
                       %'analog_o_00003', ...
                       'analog_o_00006', ...
                       'analog_o_00007', ...
                       'analog_o_00009', ...
                       'analog_o_00010', ...
                       'analog_o_00012', ...
                       'analog_o_00013', ...
                       'analog_o_00015', ...
                       'analog_o_00016'};

%% Parameters derived from experimental setup with sketch alignment

% For front ftSensor R = Rz(pi/6) * Mirror_z() * Rz(pi)
% For rear ftSensor  R = Rz(pi/6) * Mirror_z()
params.amtiInFts_rot = {[ -0.8660, 0.5000, 0; -0.5000, -0.8660, 0; 0, 0, -1], ...
                        [  0.8660,-0.5000, 0;  0.5000,  0.8660, 0; 0, 0, -1]};

% SoR origin traslation Oamti_s = R'* Os_amti
% For front ftSensor Os_amti = (-0.116, 0.198, 0.01)
% For rear ftSensor  Os_amti = (-0.116 0.171, 0.01)

Ofts_amti_front = [0.116, 0.198, 0.01];
Ofts_amti_rear = [-0.116 0.171, 0.01];

Oamti_fts_front = Ofts_amti_front * params.amtiInFts_rot{1};
Oamti_fts_rear = Ofts_amti_rear * params.amtiInFts_rot{2};

params.amtiInFts_trasl = {Oamti_fts_front, Oamti_fts_rear};

%% Clear workspace from temporary variables

clearvars -except params