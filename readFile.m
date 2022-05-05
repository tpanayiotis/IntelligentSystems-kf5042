function file_data = readFile(FileName)
fid = fopen(FileName);
if fid
    file_data = fscanf(fid, '%c', inf);
    fclose(fid);
else
    file_data = '';
    fprintf('Unable to open %s\n', FileName);
end
end

