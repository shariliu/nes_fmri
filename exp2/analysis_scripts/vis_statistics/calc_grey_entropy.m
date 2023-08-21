videos = dir('videos/*.mp4');

for vI = 1:length(videos)
    videofile = videos(vI);
    fileparts = strsplit(videofile.name, '.mp4');
    video_name = fileparts{1};
    
    