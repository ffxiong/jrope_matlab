function val_est = calculate_temporal_average( mlp_posteriors, val_name, jrope_typ, avg_mode, window_len )
% temporal averaging based on the neural network output
%
% Input:
%   mlp_posteriors:     MLP output posteriors (dim x frames)
%   val_name:           'rt' or 'elr'
%   jrope_typ:          jROPE type from I to IV, default: 'jropeII'
%   avg_mode:           'utterance': utterance-based mode, 'window':
%                       temporal window based with window_len
%   window_len:         window length since the first frame
%
%
% Output:
%   val_est:            estimated room parameter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

window_len = 170;   % if subband, then 300 frames!
if nargin < 5
    window_len = 1; % without subband results
    avg_mode = 'utterance';
end
if nargin < 4
    avg_mode = 'utterance';
end
if nargin < 3
    window_len = 1; % without subband results
    avg_mode = 'utterance';
    jrope_typ = 'jropeII';
end

if strcmp( avg_mode, 'utterance' )
    mean_val = mean( mlp_posteriors, 2 );
end

if strcmp( avg_mode, 'frame' )
    frame_total = min( window_len, size(mlp_posteriors,2) );
    mean_val = mean( mlp_posteriors(:, 1:frame_total), 2 );
end


% winner-take-all
[~, ind_max] = max(mean_val);
ind_max = ind_max(1);   % only take one value if equal prob.

% label
%lab_dim = size(mlp_posteriors, 1);
if strcmp(jrope_typ, 'jropeII')
    lab_info = nan(217, 3);
    lab_info(:,1) = 1:1:217;
    lab_info(1:16,2) = 200*ones(16,1);
    lab_info(1:16,3) = 15:1:30;
    lab_info(17:33,2) = 300*ones(17,1);
    lab_info(17:33,3) = 10:1:26;
    lab_info(34:51,2) = 400*ones(18,1);
    lab_info(34:51,3) = 7:1:24;
    lab_info(52:69,2) = 500*ones(18,1);
    lab_info(52:69,3) = 4:1:21;
    lab_info(70:87,2) = 600*ones(18,1);
    lab_info(70:87,3) = 3:1:20;
    lab_info(88:104,2) = 700*ones(17,1);
    lab_info(88:104,3) = 2:1:18;
    lab_info(105:121,2) = 800*ones(17,1);
    lab_info(105:121,3) = 1:1:17;
    lab_info(122:136,2) = 900*ones(15,1);
    lab_info(122:136,3) = 1:1:15;
    lab_info(137:151,2) = 1000*ones(15,1);
    lab_info(137:151,3) = 0:1:14;
    lab_info(152:165,2) = 1100*ones(14,1);
    lab_info(152:165,3) = -1:1:12;
    lab_info(166:178,2) = 1200*ones(13,1);
    lab_info(166:178,3) = -1:1:11;
    lab_info(179:191,2) = 1300*ones(13,1);
    lab_info(179:191,3) = -2:1:10;
    lab_info(192:204,2) = 1400*ones(13,1);
    lab_info(192:204,3) = -2:1:10;
    lab_info(205:217,2) = 1500*ones(13,1);
    lab_info(205:217,3) = -3:1:9;
    if strcmp(val_name, 'rt')
        val_est = lab_info(ind_max, 2);
    end
    if strcmp(val_name, 'elr')
        val_est = lab_info(ind_max, 3);
    end
end

end