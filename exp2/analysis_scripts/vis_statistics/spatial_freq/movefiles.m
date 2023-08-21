

folder1 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xPresentationScripts/experiment/Stills/dynStat/2final_stills/';
% folder2 = '/Users/fkamps/Documents/Projects/MIT/infantSceneMotionfNIRS/xPresentationScripts/experiment/Stills/dynStat/2final_stills/';


home = cd;

movies = dir([folder1 '*.mov']);
eval(['cd ',folder1])
mkdir('allStills')

for movie = 1:length(movies)
    
    movieFolder = [movies(movie).name,'/'];
     
    stills = dir([movieFolder, '*.jpg']);
    
    for still = 1:length(stills)
        
        stillFile = [movieFolder,stills(still).name];
        
        destination = [folder1,'allStills'];
        
        eval(['copyfile ',stillFile, ' ',destination, '/', [movies(movie).name,stills(still).name]])
        
    end
    
    
end