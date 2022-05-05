function word_indices = processEmail(econtents)
vocabList = getVocabList();
word_indices = [];
econtents = lower(econtents);
econtents = regexprep(econtents, '<[^<>]+>', ' ');
econtents = regexprep(econtents, '[0-9]+', 'number');
econtents = regexprep(econtents, ...
                           '(http|https)://[^\s]*', 'httpaddr');
econtents = regexprep(econtents, '[^\s]+@[^\s]+', 'emailaddr');
econtents = regexprep(econtents, '[$]+', 'dollar');
fprintf('\n==== Processed Email ====\n\n');
l = 0;
while ~isempty(econtents)
    [str, econtents] = ...
       strtok(econtents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
    str = regexprep(str, '[^a-zA-Z0-9]', '');
    try str = porterStemmer(strtrim(str)); 
    catch str = ''; continue;
    end;
    if length(str) < 1
       continue;
    end
for i=1:length(vocabList)
    if(strcmp(vocabList{i},str))
        word_indices = [word_indices ; i];
    end
end
    if (l + length(str) + 1) > 78
        fprintf('\n');
        l = 0;
    end
    fprintf('%s ', str);
    l = l + length(str) + 1;
end
fprintf('\n\n=========================\n');
end
