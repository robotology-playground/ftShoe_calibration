%% Script to define and load to workspace acquisition parameters

%% Experimental setup parameters

params.ftsPortName='ft';
params.amtiPortName='amti';

params.calibMatPath = './data/official_calibration_matrices/'; % path to where calibration matrices can be found

params.ftsNames={'ftShoe_left_front', 'ftShoe_left_rear'};
params.ftsSerialNumbers={'SN229', 'SN242'}; % should be defined in the same order of ftNames
params.amtiNames={'first', 'second'}; % should be defined in the same order of ftNames

% Special trial to remove offsets when no weight applied
params.staticOffsetExp = 'analog_o_00001';

params.staticOffsetAcqPath = './data/sept_26/dumper';
params.acqPath = './data/sept_26/dumper';
params.expList = {'analog_o_00004', ...
                  'analog_o_00005'};

% Sublist of tasks useful for calibration
params.calibExpList = {'analog_o_00004', ...
                       'analog_o_00005'};

%% Parameters derived from experimental setup with sketch alignment

% For front ftSensor R = Rz(pi/6) * Mirror_z() * Rz(pi)
% For rear ftSensor  R = Rz(pi/6) * Mirror_z()
params.amtiInFts_rot = {[ -0.8660, 0.5000, 0; -0.5000, -0.8660, 0; 0, 0, -1], ...
                        [  0.8660,-0.5000, 0;  0.5000,  0.8660, 0; 0, 0, -1]};

% SoR origin traslation Oamti_s = R'* Os_amti
% For front ftSensor Os_amti = (-0.116, 0.198, 0.01)
% For rear ftSensor  Os_amti = (-0.116 0.171, 0.01)

Ofts_amti_front = [-0.116, 0.198, 0.01];
Ofts_amti_rear = [0.116 0.171, 0.01];

Oamti_fts_front = Ofts_amti_front * params.amtiInFts_rot{1};
Oamti_fts_rear = Ofts_amti_rear * params.amtiInFts_rot{2};

params.amtiInFts_trasl = {Oamti_fts_front, Oamti_fts_rear};

%% Clear workspace from temporary variables

clearvars -except params