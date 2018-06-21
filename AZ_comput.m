% --- AZ_comput ---
% Script name: AZ_comput
% Description: code to compute the size of Project AIDA ZERO
% solutions space
% Version: 01.00
% Author: Leonardo Rossi
% Latest update: June 20, 2018
% License: Freely redistributable software

% Features:
% Commented - Easy to read - Easy to modify - Modular

%% Building features
np = 4; % number of building storeys
n_corn = 4; % number of corner elements
n_ltrl = 8; % number of lateral elements
n_ctrl = 4; % number of central elements
n_beams = 2*24; % number of beams
rots = 2; % possible rotations for a vertical column

%% Options
shifton = 0; % shiftings ON
beamson = 0; % beams ON
rotson = 1; % rotations ON
dimon = 1;  % pre-design filter ON
wtapon = 1; % wall tapering ON
corn_shift = 4; % possible position shifts for a vertical column on the corner
ltrl_shift = 6; % possible position shifts for a lateral column
ctrl_shift = 9; % possible position shifts for central vertical column

if ( shifton == 0 )
    corn_shift = 1;
    ltrl_shift = 1;
    ctrl_shift = 1;
end % if

if( beamson == 0 )
    n_beams = 0;
end % if

if( rotson == 0)
    rots = 0;
end % if

%% BEAMS -----------------------------------------------------
pbea = 0; % initial number of possible beams
bw = 30:5:80; % beams width
bh = 30:5:100; % beams heigth
pbea = length(bw)*length(bh);

%% COLUMNS -----------------------------------------------------
pcol = 0; % initial number of possible columns
cmaxs = 100; % column max size

% Pre-design filter: significatively reduces the number of columns
if( dimon )
    cmaxs = 45;
end % if

p_sz = [25:5:cmaxs]; % admissible column size
pcol = mou(cmaxs, 0, np, p_sz);

%% SINGLE WALLS
lmax = 500; % max wall's length
a = 50:25:lmax;

max_spess = 40; % max wall's tickness

% Tickness is not so relevant in the end; with some pre-design we can
% significatively reduce the tickness space.
if( dimon )
    max_spess = 30; % valore di comodo, usato per fare capire che riduco
    % il range degli spessori
end % if
b = 20:5:max_spess;

% full set of combination for wall's length and tickness
all_par = combvec(a, b);
[ri, co] = size(all_par);

for j = 1:1:co
    if( all_par(1, j) <= all_par(2, j) )
        all_par(1, j) = 0;
        all_par(2, j) = 0;
    end
end % j-for
valid_walls = nnz(all_par(1, :));

log_val_walls = zeros(valid_walls, 2); % log of valid walls
plcd = 0; % placed
for i = 1:1:length( all_par(1, :) )
    if( all_par(1, i) > 0 )
        plcd = plcd + 1;
        log_val_walls(plcd, :) = all_par(:, i);
    end
end % i-for

[rh, cn] = size( log_val_walls );

matricion = zeros( rh, 2, rh );

for i = 1:1:rh
    for j = 1:1:rh
        if( wtapon ) % tapering ON
            % ---------------------------------
            if ( and(log_val_walls(i, 1) >= log_val_walls(j, 1) ...
                    , log_val_walls(i, 2) >= log_val_walls(j, 2)) )
                matricion( j, 1, i) = log_val_walls(j, 1);
                matricion( j, 2, i) = log_val_walls(j, 2);
             
            end % if
            % ---------------------------------
        else % tapering OFF
           % ---------------------------------
            if ( and(log_val_walls(i, 1) == log_val_walls(j, 1) ...
                    , log_val_walls(i, 2) == log_val_walls(j, 2)) )
                matricion( j, 1, i) = log_val_walls(j, 1);
                matricion( j, 2, i) = log_val_walls(j, 2);
             
            end % if
            % ---------------------------------
        end % if
    end
end % i-for

% number of different vertical lines we cna create using valid walls
vrt_walls = tritacarne_01(log_val_walls, 0, ...
    np, matricion, log_val_walls);

corn_vrt = ( pcol + vrt_walls^2 + 1 )*corn_shift; % corner vertical lines
ltrl_vrt = ( pcol + 2*vrt_walls + 1 )*ltrl_shift; % lateral vertical lines
ctrl_vrt = ( pcol + (vrt_walls^2)*rots + 1 )*ctrl_shift; % central vertical lines

% Project AIDA ZERO's solution space dimension:
space_dim = ( corn_vrt^n_corn )*( ltrl_vrt^n_ltrl )*...
    ( ctrl_vrt^n_ctrl )*( pbea^n_beams )

% assessed number of atoms in the Universe
aau = 10^80;

spdim_ratio = space_dim / aau;
