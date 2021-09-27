function parsave(fname,  LADCF_Results, time)
%se usa para guardar un .mat en cada iteración de un ciclo parfor
%Se pueden cambiar los dos ultimos nombres segun se quiera 
  save(fname, 'LADCF_Results', 'time')
end