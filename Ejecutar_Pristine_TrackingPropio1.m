clc;
close all;
clear all;

for i=19:36
    pruebas_main_Roger2(i,'blur')
end

% arreglo = [12 23 24 25 42
% for i=26:40
%     index = arreglo(i)
%     pruebas_main_Roger2(index,'Gaussian')
% end

% parfor i=1:3
%     switch i
%         case 1
%             pruebas_main_Roger2(38,'pristine')
%         case 2
%             pruebas_main_Roger2(39,'pristine')
% 
%         case 3
%             pruebas_main_Roger2(49,'pristine')
%     end
% end