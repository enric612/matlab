function WriteToFile(filename, text)
%open file with write permission
fid = fopen(filename, 'a+');
%write a line of text
fprintf(fid, '%s\n', text);
%close file
fclose(fid);