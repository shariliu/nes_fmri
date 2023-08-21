% make each video in videos/ into a directory of images
% file names should include all condition level information, eg.
    % phys_solid-barrier_cube_UNEXP.mp4
    
videos = dir('videos/*.mp4');

for vI = 1:length(videos)
    videofile = videos(vI);
    fileparts = strsplit(videofile.name, '.mp4');
    video_name = fileparts{1};
    
    mkdir(['stills/' video_name])

    vidread = VideoReader(['videos/' videofile.name]);
    nframes = vidread.NumFrames;
    frames = zeros(720,1080,3,nframes);
    
    for frameI = 1:nframes
        curframe = read(vidread,frameI);
        
        % IRRELEVANT NOW, VIDEOS ARE CORRECT SIZE: 
        % trim videos: 
        %if (vidread.Height == 780)
        %    outframe = curframe(31:end-30,:,:);
        %    size(outframe)
        %    imwrite(outframe,['videos/' video_name '/frame_' int2str(frameI) '.jpg']);
        %    frames(:,:,:,frameI) = im2double(outframe);
        %write to video as well
        
        %else
        imwrite(curframe,['stills/' video_name '/frame_' int2str(frameI) '.jpg']);
        %end
        
        
        %end
        
        % IRRELEVANT NOW, VIDEOS ARE CORRECT SIZE: 
        % save trimmed videos: 
        %if (vidread.Height == 780)
        %    writerobj = VideoWriter(['TRIMMED_' videofile.name], 'MPEG-4');
        %    open(writerobj)
        %    writeVideo(writerobj, frames)
        %    close(writerobj)
        %end
        
    end
end
