% --- mou ---
% Script name: mou
% function called by: AZ_comput
% Description: code to compute the size of Project AIDA ZERO
% solutions space
% Version: 01.00
% Author: Leonardo Rossi
% Latest update: June 20, 2018
% License: Freely redistributable software

% Features:
% Commented - Easy to read - Easy to modify - Modular

function[seguono] = mou(param, passo, np, p_sz)
seguono = 0;
if (passo == np)
    
    seguono = 1;
    
else
    passo = passo + 1;
    temp = p_sz( find( p_sz <= param) );
    
    for i = 1:1:length(temp)
        
        seguono = seguono + mou(temp(i), passo, np, p_sz);
        
    end % if
        
end % i-for

end