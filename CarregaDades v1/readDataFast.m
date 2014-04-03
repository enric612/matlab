function [data,name,fi,si,ti,headers] = readDataFast(file)

string = fileread(file);
string = strrep(string,',','.');
lines = strsplit(string,char(10));
aux = strsplit(lines{1},char(9));

%Intervals
fi = str2num(aux{2}); %First Interval
si = str2num(aux{3})+fi; %Second Interval 
ti =  str2num(aux{4})+si; %Third Interval

%Folder Name

aux = strsplit(lines{2},'_');
name = aux{1};

% Headers
headers = lines{3};

%Number of lines

[f,nlines] = size(lines);

for i=4:nlines %lines with data
   
    data(i,:) = strsplit(lines{i},char(9)); 
    
end

%data = cellfun(@str2num,m); 

T = data(:,1);

[f,c] = size(data);
data = data(:,2:c);

end