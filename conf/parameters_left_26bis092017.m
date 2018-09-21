%% Script to define and load to workspace acquisition parameters

%% Experimental setup parameters

params.ftsPortName='ft';
params.amtiPortName='amti';

params.calibMatPath = 'your-path-to-the-calibration-matrices'; % path to where calibration matrices can be found

params.ftsNames={'ftShoe_left_front', 'ftShoe_left_rear'};
params.ftsSerialNumbers={'SN229', 'SN242'}; % should be defined in the same order of ftNames
params.amtiNames={'first', 'second'}; % should be defined in the same order of ftNames

% Special trial to remove offsets when no weight applied
params.staticOffsetExp = 'analog_o';

params.staticOffsetAcqPath = 'your-path-to-the-dataset';
params.acqPath = 'your-path-to-the-dataset';
params.expList = {'analog_o_00016', ...
                  'analog_o_00017', ...
                  'analog_o_00018', ...
                  'analog_o_00019', ...
                  'analog_o_00020', ...
                  'analog_o_00021', ...
                  'analog_o_00022', ...
                  'analog_o_00023', ...
                  'analog_o_00024', ...
                  'analog_o_00025', ...
                  'analog_o_00026', ...
                  'analog_o_00027', ...
                  'analog_o_00028', ...
                  'analog_o_00029', ...
                  'analog_o_00030'};

% Sublist of tasks useful for calibration
params.calibExpList = {'analog_o_00016', ...
                       'analog_o_00017', ...
                       'analog_o_00019', ...
                       'analog_o_00020', ...
                       'analog_o_00022', ...
                       'analog_o_00023', ...
                       'analog_o_00025', ...
                       'analog_o_00026', ...
                       'analog_o_00028', ...
                       'analog_o_00029'};

%% Parameters derived from experimental setup with sketch alignment
%
% Experimental assumption: The sketch should be placed to have the forefoot
% on the first force platform, while the heel should be in the second force
% platform
%
% Structure logic: the first field refers to the transformation between
% first platform and forefoot fts, the second to the one between second
% first platform and heel
%
% Naming convention: fts - force torque sensor SoR
%                    fp  - force platform SoR
%                    fake_fts - fake SoR placed on top of the fts but
%                               oriented like fp
%

% ***********
% % Rotations section
% ***********

Rz_150 = [cos(150/180*pi), -sin(150/180*pi), 0;
          sin(150/180*pi),  cos(150/180*pi), 0;
          0              ,  0              , 1];
Rz_m30 = [cos(-30/180*pi), -sin(-30/180*pi), 0;
          sin(-30/180*pi),  cos(-30/180*pi), 0;
           0              ,  0              , 1];
Ry_180 = [ cos(180/180*pi),  0, sin(180/180*pi);
           0              ,  1, 0              ;
          -sin(180/180*pi),  0, cos(180/180*pi)];
Rx_180 = [ 1              ,  0             ,  0              ;
           0              , cos(180/180*pi), -sin(180/180*pi);
           0              , sin(180/180*pi),  cos(180/180*pi)];

params.fp_R_fake_fts = {Rz_m30, ...  % front
                        Rz_150};     % rear

% Rotation matrices to express fp in fake_fts
params.fake_fts_R_fp{1} =  inv(params.fp_R_fake_fts{1});
params.fake_fts_R_fp{2} =  inv(params.fp_R_fake_fts{2});

% Rotation matrices to express fp in fts
params.fts_R_fp{1} = params.fake_fts_R_fp{1} * eye(3);
params.fts_R_fp{2} = params.fake_fts_R_fp{2} * eye(3);

% ***********
% % Translations section
% ***********

% Express fp in (seen from) fake_fts (retrieved from CAD sketch)
params.fake_fts_O_fp{1} = [-0.116; -0.198; 0.01];
params.fake_fts_O_fp{2} = [0.116; -0.171; 0.01];

% Express fp in (seen from) fts
params.fp_O_fts{1} = params.fts_R_fp{1} * params.fake_fts_O_fp{1};
params.fp_O_fts{2} = params.fts_R_fp{2} * params.fake_fts_O_fp{2};


% Rz_m30 = [cos(-30/180*pi), -sin(-30/180*pi), 0;
%           sin(-30/180*pi),  cos(-30/180*pi), 0;
%           0              ,  0              , 1];
% Ry_180 = [ cos(180/180*pi),  0, sin(180/180*pi);
%            0              ,  1, 0              ;
%           -sin(180/180*pi),  0, cos(180/180*pi)];
% Rx_180 = [ 1              ,  0             ,  0              ;
%            0              , cos(180/180*pi), -sin(180/180*pi);
%            0              , sin(180/180*pi),  cos(180/180*pi)];
%
% params.fp_R_fake_fts = {Rz_m30*Ry_180, ...  % front
%                         Rz_m30*Rx_180};     % rear
%
% % Rotation matrices to express fp in fake_fts
% params.fake_fts_R_fp{1} =  inv(params.fp_R_fake_fts{1});
% params.fake_fts_R_fp{2} =  inv(params.fp_R_fake_fts{2});
%
% % Rotation matrices to express fp in fts
% params.fts_R_fp{1} = params.fake_fts_R_fp{1} * eye(3);
% params.fts_R_fp{2} = params.fake_fts_R_fp{2} * eye(3);
%
% % ***********
% % % Translations section
% % ***********
%
% % Express fp in (seen from) fake_fts (retrieved from CAD sketch)
% params.fake_fts_O_fp{1} = [ 0.116; -0.198; -0.01];
% params.fake_fts_O_fp{2} = [-0.116; -0.171; -0.01];
%
% % Express fp in (seen from) fts
% params.fp_O_fts{1} = params.fts_R_fp{1} * params.fake_fts_O_fp{1};
% params.fp_O_fts{2} = params.fts_R_fp{2} * params.fake_fts_O_fp{2};

% ***********


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