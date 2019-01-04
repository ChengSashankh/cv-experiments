% Lab 4: Background Removal
close all
clear all

% Step 1: Read the video
v = VideoReader('traffic.mp4');

% Step 2: Displaying the details using VideoReader functions
disp(['Length of clip in seconds: ', num2str(v.Duration)]);
disp(['Height of video frame in pixels: ', num2str(v.Height)]);
disp(['Width of video frame in pixels: ', num2str(v.Width)]);
disp(['Bits per pixel of the video data: ', num2str(v.BitsPerPixel)]);
disp(['Video format as represented by MATLAB: ', v.VideoFormat]);
disp(['Video frame rate : ', num2str(v.FrameRate)]);

%Step 3: Averaging out pixels
avg = zeros([v.Height v.Width 3]);
for i = 1 : v.NumberOfFrames
    pic = read(v, i);
    avg = avg + (1/v.NumberOfFrames) .* im2double(pic);
end

figH = figure;
subplot(2,2,1), imshow(read(v, 1));
title('Original Image');

subplot(2,2,2), imshow(avg);
title('Background Extracted');

% Step 4: Extracting the moving objects
movingFirst = subtractFrames(read(v,1), avg);
movingLast = subtractFrames(read(v, v.NumberOfFrames), avg);

subplot(2,2,3), imshow(movingFirst);
title('First frame without background');
subplot(2,2,4), imshow(movingLast);
title('Last frame without background');

figName = 'traffic_bg_removed_results.jpg';
print(figH, '-djpeg', figName);

% Forming the video without background
vid_bg_removed = VideoWriter('sub_bg_removed.avi');
open(vid_bg_removed);
disp('Forming video without background');
lastRow = zeros(v.NumberOfFrames, 640);
for i = 1 : v.NumberOfFrames
    pic = read(v, i);
    sub = subtractFrames(pic, avg);
    sub = rgb2gray(sub);
    lastRow(i, :) = sub(480, :);
    writeVideo(vid_bg_removed, mat2gray((sub)));
end
close(vid_bg_removed);
disp('Done forming video without background');

% Step 5: Processing the last row
count = 0;
lanes = [40, 220, 440];
% Only one car per lane can cross at a time.
% No car can extend across two lanes at once.
% Hence we just watch each lane for increase in intensity.
for i = 1 : 3
    count = count + atPixel(lastRow, lanes(i));
end
fprintf("Number of cars crossing the bottom = %d\n", count);


function count = atPixel(lastRow, col)
    count = 0;
    sum  = 0;
    num = 0;
    inProgress = 0;
    for i = 1 : 300
        if inProgress == 0 && lastRow(i, col) >= 0 
            sum = sum + lastRow(i, col);
            num = num + 1;
            inProgress = 1;
        end
        
        if inProgress == 1 && lastRow(i, col) == 0 && i + 5 <= 300
            avg = double(sum) / num;
            if avg >= 0.11
                count = count + 1;
            end
            sum = 0;
            num = 0;
            inProgress = 0;
        end
    end
end

function sub = subtractFrames(frame, background)
    sub = im2double(frame) - im2double(background);
end