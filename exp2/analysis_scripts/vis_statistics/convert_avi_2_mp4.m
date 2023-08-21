% make each video in videos/ into a directory of images

videos = dir('videos/phys*.avi');

for vI = 1:length(videos)
    videofile = videos(vI);
    fileparts = strsplit(videofile.name, '.avi');
    video_name = fileparts{1};
    
    vidread = VideoReader(['videos/' videofile.name]);
    nframes = vidread.NumFrames;
    frames = zeros(720,1080,3,nframes);
    
    for frameI = 1:nframes
        curframe = read(vidread,frameI);
        frames(:,:,:,frameI) = im2double(curframe);
    end
    
    writerobj = VideoWriter(['videos/' video_name '.mp4'], 'MPEG-4');
    open(writerobj)
    writeVideo(writerobj, frames)
    close(writerobj)
    
    
end

