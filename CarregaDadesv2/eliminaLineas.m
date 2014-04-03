function eliminaLineas(file)

fid = fopen(file, 'r') ;              % Open source file.
 fgetl(fid) ;                                  % Read/discard line.
 fgetl(fid) ;                                  % Read/discard line.
 buffer = fread(fid, Inf) ;                    % Read rest of the file.
 fclose(fid);
 delete(file); % Delite file
 fclose('all');
 [fid2,m]= fopen(file, 'w');   % Open destination file.
 
 while ~isempty(m)
    
     fclose('all');
     
     [fid2,m]= fopen(file, 'w');
 end
 fwrite(fid2, buffer) ;                         % Save to file.
 fclose(fid2) ;


end