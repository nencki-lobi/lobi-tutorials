%%
%This short script calculates additional parameters proposed by Friston et
%al. (1996):%6 head motion parameters, 6 head motion parameters one time point before, and the 12 corresponding squared items), 
%based on recent reports that higher-order models demonstrate benefits in
%removing head motion effects (Satterthwaite et al., 2013; Yan et al., 2013).
%%
%The script should be run on rp***.txt files obtained during realignment

if ispc
    path = 'D:\projectx\scans\';
elseif ismac
    path = '/Users/cynamon/Downloads/CONN_Demo/'; 
end

%List all files, based on an expression, in a given directory and its subsfolders
%enter your directory and expression matching subjects filenames
files = dir(fullfile(path, '**/*rp_sub-*task-rest*.txt'));
 
% loops through the files 
for file=1:size(files,1)
    
    folder = files(file).folder;
    fname = files(file).name;
    
    %cd to subfolder of index file
    cd (folder);
    
    %opens file as an array
    R = dlmread(fname);
       
    %adds 6 head motion parameters one time point before    
    shifted_R = [zeros(1,6); R(1:end-1,:)]; 
    R = [R shifted_R];

    %calculcates the quadratic term of head movements parameters
    quad_R = R.^2;
    R = [R quad_R];

   %renames and saves the file 
    out = [fname(1:end-4) '_24reg.mat'];
    save(out, 'R');    
end