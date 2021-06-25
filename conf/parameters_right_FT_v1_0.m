%% Script to define and load to workspace acquisition parameters

%% Experimental setup parameters

params.ftsPortName='ft';
params.amtiPortName='amti';

params.calibMatPath = 'your-path-to-the-calibration-matrices'; % path to where calibration matrices can be found

params.ftsNames={'ftShoe_right_front', 'ftShoe_right_rear'};
params.ftsSerialNumbers={'SN005', 'SN004'}; % should be defined in the same order of ftNames
params.amtiNames={'first', 'second'}; % should be defined in the same order of ftNames

% Special trial to remove offsets when no weight applied
params.staticOffsetExp = 'analog_o';

params.staticOffsetAcqPath = 'your-path-to-the-dataset';
params.acqPath = 'your-path-to-the-dataset';

params.expList = {'analog_o_00001', ...
                  'analog_o_00002', ...
                  'analog_o_00003', ...
                  'analog_o_00004', ...
                  'analog_o_00005', ...
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
                  'analog_o_00016'};

% Sublist of tasks useful for calibration
params.calibExpList = {'analog_o_00002', ...
                       'analog_o_00003', ...
                       'analog_o_00005', ...
                       'analog_o_00006', ...
                       'analog_o_00008', ...
                       'analog_o_00009', ...
                       'analog_o_00011', ...
                       'analog_o_00012', ...
                       'analog_o_00014', ...
                       'analog_o_00015'};

%% Parameters derived from experimental setup with sketch alignment
%
% Experimental assumption: The sketch for FT_v1.0 (i.e., the new iFeelShoes) 
% should be placed to have 
% the front sensor on the first force platform, while the rear sensor should 
% be in the second force platform.
%
% Sketch from
% https://github.com/dic-iit/element_sandals/blob/master/FTSensors/fixtures/iit_sketch_calibration-FT_v1.0.pdf
%
% -------------------------------------------------------------------------
% LEGEND:
% fts          - force torque sensor SoR (i.e.,System of Reference)
% fp           - force platform SoR
% -------------------------------------------------------------------------

%% 1 STEP
% ***********
% % Rotations section
% ***********
Rz_90 = [cos(90/180*pi) , -sin(90/180*pi), 0 ;
         sin(90/180*pi) ,  cos(90/180*pi), 0 ;
         0               ,   0           , 1];
% 1) ftsFront_R_fp1
params.fts_R_fp{1} = Rz_90;
% 2) ftsRear_R_fp2
params.fts_R_fp{2} = Rz_90;

%% 2 STEP
% ***********
% % Translations section
% ***********
% Express fp in (seen from) fts (from CAD sketch)
% 1) position of FP1 seen from ftsFront
params.fp_O_fts{1} = [0.1797; 0.1003; 0.020];
% 2) position of FP2 seen from ftsRear
params.fp_O_fts{2} = [0.1800; -0.101; 0.023];

%% 3 STEP
gravityZero = iDynTree.Vector3();
gravityZero.zero();

iDynTree_fts_R_fp{1} = iDynTree.Rotation();
iDynTree_fts_R_fp{1}.fromMatlab(params.fts_R_fp{1});
iDynTree_fts_R_fp{2} = iDynTree.Rotation();
iDynTree_fts_R_fp{2}.fromMatlab(params.fts_R_fp{2});

iDynTree_fp_O_fts{1} = iDynTree.Position();
iDynTree_fp_O_fts{1}.fromMatlab(params.fp_O_fts{1});
iDynTree_fp_O_fts{2} = iDynTree.Position();
iDynTree_fp_O_fts{2}.fromMatlab(params.fp_O_fts{2});

params.fts_T_fp{1} = iDynTree.Transform(iDynTree_fts_R_fp{1}, iDynTree_fp_O_fts{1});
params.fts_T_fp{2} = iDynTree.Transform(iDynTree_fts_R_fp{2}, iDynTree_fp_O_fts{2});

% Just as remember on how to print transforms
% params.fts_T_fp{1}.asAdjointTransformWrench().toMatlab();

%% Clear workspace from temporary variables

clearvars -except params
