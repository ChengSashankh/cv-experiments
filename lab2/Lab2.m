% Sashankh Chengavalli Kumar - A0162363J 
diary on
close all
clear all

FNames = {'meteora_gray.jpg';
'penang_hill_gray.jpg';
'foggy_carpark_gray.jpg'};

for p = 1 : size(FNames)
    figH = figure;
    A = FNames{p};
    pic = imread(A);
    
    % Task 1:
    
    h_before = calc_hist(pic);
    c_before = calc_cdf(h_before);
    hPic = eq_pic(c_before , pic);
    h_after = calc_hist(hPic);
    c_after = calc_cdf(h_after);
    
    subplot(3,2,1), imshow(pic, [0 255]);
    title('original image');
    subplot(3,2,2), imshow(hPic, [0 255]);
    title('hist equalized image');
    subplot(3,2,3), bar(h_before);
    title('original histogram');
    subplot(3,2,4), bar(h_after);
    title('equalized hist');
    subplot(3,2,5), bar(c_before);
    title('original cumu hist');
    subplot(3,2,6), bar(c_after);  
    title('equalized cumu hist');
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_histogram_eq_results.jpg');
    print(figH, '-djpeg', figName);
    
    % Task 2:
    [r, c] = size(pic);
    
    % Finding array limits for cropping
    lower = round(r/2);
    upper = r;
    
    % Performing the actual crop
    pic = pic(lower:upper, :);
    
    h_before = calc_hist(pic);
    c_before = calc_cdf(h_before);
    hPic = eq_pic(c_before , pic);
    h_after = calc_hist(hPic);
    c_after = calc_cdf(h_after);
    
    subplot(3,2,1), imshow(pic, [0 255]);
    title('original image');
    subplot(3,2,2), imshow(hPic, [0 255]);
    title('hist equalized image');
    subplot(3,2,3), bar(h_before);
    title('original histogram');
    subplot(3,2,4), bar(h_after);
    title('equalized hist');
    subplot(3,2,5), bar(c_before);
    title('original cumu hist');
    subplot(3,2,6), bar(c_after);  
    title('equalized cumu hist');
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_histogram_eq_results_cropped.jpg');
    print(figH, '-djpeg', figName);
end

diary off

function z = calc_hist(pic)
    % Constructing the histogram
    [r,c]=size(pic);
    z = zeros(1,256);
    
    for i=1:r
        for j=1:c
            b = pic(i,j);
            z(b+1) = z(b+1) + 1;
        end
    end
end

% function pr = calc_prob(pic, z)
%     % Calculating the probabilities
%     [r, c] = size(pic);
%     pr = zeros(1, 256);
%     
%     for i = 1:256
%         pr(i) = z(i) / r * c * 1.0;
%     end
% end

function c = calc_cdf(pr)
    % Calculating cdf
    c = zeros(1, 256);
    for i = 1 : 256
        if i == 1
            c(i) = pr(i);
        else
            c(i) = c(i-1) + pr(i);
        end
    end 
end

function new_pic = eq_pic(cdf, pic)
    [r,c] = size(pic);
    new_pic = zeros(r,c);
    sum = cdf(256);
    
    new_pic = pic;
    for i = 1 : r
        for j = 1 : c
            new_pic(i,j) = (cdf(pic(i,j) + 1)/sum) * 255;
        end
    end
end
