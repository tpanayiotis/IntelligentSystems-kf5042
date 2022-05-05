function volist = getVocabList()
fid = fopen('vocab.txt');
w = 1899;
volist = cell(w, 1);
for i = 1:w
    fscanf(fid, '%d', 1);
    volist{i} = fscanf(fid, '%s', 1);
end
fclose(fid);
end
