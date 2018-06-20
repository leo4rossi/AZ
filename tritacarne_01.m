% --- tritacarne ---
% Script name: tritacarne
% function called by: AZ_comput
% Description: code to compute the size of Project AIDA ZERO
% solutions space
% Version: 01.00
% Author: Leonardo Rossi
% Latest update: June 20, 2018
% License: Freely redistributable software

% Features:
% Commented - Easy to read - Easy to modify - Modular

function[possible_over] = tritacarne_01(wall_list, crrnt, np, matricion, fix_list)

possible_over = 0;

if( crrnt == np )
    possible_over = 1;
else
    
    crrnt = crrnt + 1;
    [rg, cl] = size( wall_list );
    
    % Itero sulla lista pareti
    for i = 1:1:rg
        % devi fare tante iterazioni quante sono le pareti in lista
        % devo determinare quale "fetta" di matricion che corrisponde
        % alla parete attuale. Cerco sulla lista immutabile.
        [r, c] = size( fix_list );
        pointr = 0;
        for k = 1:1:r
            if( and( wall_list(i, 1) == fix_list(k ,1), ...
                    wall_list(i, 2) == fix_list(k, 2)) )
                pointr = k;
            end
        end
        mat = nonzeros(matricion(:, :, pointr));
        mat1 = reshape(mat, length(mat)/2, 2);
        possible_over = possible_over + ...
            tritacarne_01( mat1, crrnt, np, matricion, fix_list );
    end
end
end