diary on
close all
clear all

% Task 1 Part 1
FNames = {'meteora_gray.jpg';
'penang_hill_gray.jpg';
'foggy_carpark_gray.jpg'};

low = {19; 6; 53};
high = {217; 212; 228};

% Performing with full images
for p = 1 : size(FNames)
    figH = figure;
    A = FNames{p};
    pic = imread(A);
    subplot(2,2,1), imshow(pic, [0 255]);
    title('original image');
    
    z = calc_hist(pic);
    subplot(2,2,2), bar(z);
    title('Original histogram');
    
    l = low{p};
    h = high{p};
    new_im = scale_image(pic, l, h);
    
    subplot(2,2,3), imshow(new_im, [0 255]);
    title('Contrast stretched image');
    
    z2 = calc_hist(new_im);
    subplot(2,2,4), bar(z2);
    title('Stretched histogram');
    
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_histogram_stretched_results.jpg');
    print(figH, '-djpeg', figName);
end

% Task 1 Part 2
% Performing with cropped images
low = {15; 4; 36};
high = {204; 217; 151};
for p = 1 : size(FNames)
    figH = figure;
    A = FNames{p};
    pic = imread(A);
    [r, c] = size(pic);
    
    % Finding array limits for cropping
    lower = round(r/2);
    upper = r;
    
    % Performing the actual crop
    pic = pic(lower:upper, :);
    subplot(2,2,1), imshow(pic, [0 255]);
    title('original image');
    
    z = calc_hist(pic);
    subplot(2,2,2), bar(z);
    title('Original histogram');
    
    l = low{p};
    h = high{p};
    new_im = scale_image(pic, l, h);
    
    subplot(2,2,3), imshow(new_im, [0 255]);
    title('Contrast stretched image');
    
    z2 = calc_hist(new_im);
    subplot(2,2,4), bar(z2);
    title('Stretched histogram'); 
    
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_cropped_histogram_stretched_results.jpg');
    print(figH, '-djpeg', figName);
end

%Task 2
h = [-1 0 1 0 0 0 0 0 0 0];
x = [5 5 5 5 5 0 0 0 0 0];

figure

paddedH  = [zeros(1,9) h];
paddedX  = [zeros(1,9) x];
flippedH = [fliplr(h) zeros(1,9)];

subplot(4,1,1), stem([-9:9], paddedH, 'k'), title('h');
subplot(4,1,2), stem([-9:9], paddedX, 'r'), title('x');
subplot(4,1,3), stem([-9:9], flippedH, 'b'), title('h flipped');

% to implement the convolution equation  g[m] = sum_t ( x[m-t]*h[t] )

conv_result = zeros(1,19);

temp = flippedH;

for m = 0 : 9
    
    csum = sum(paddedX .* temp);
    conv_result(m+10) = csum;
    
    subplot(4,1,4), stem([-9:9], conv_result, 'k'), ylim([0 50]), title('convolution result');
   
    pause(5)
    
    temp = [0 temp(1:length(temp)-1)];
    subplot(4,1,3), stem([-9:9], temp, 'b'), title('h flipped');
    
end


%Task 3
FNames = {'carmanBox.jpg';
'checker.jpg';
'pipe.jpg';
'letterBox.jpg'};

filterX = [-1 0 1; -2 0 2; -1 0 1];
filterY = [-1 -2 -1; 0 0 0; 1 2 1];

for p = 1 : size(FNames)
    figH = figure;
    A = FNames{p};
    pic = imread(A);
    grayPic = double(rgb2gray(pic));
    
    % Convolving X and Y filters
    xConvolved = convolveFunc(grayPic, filterX);
    yConvolved = convolveFunc(grayPic, filterY);
    
    % Combining
    combined = sqrt(xConvolved.^2 + yConvolved.^2);

    subplot(2, 2, 1), imshow(xConvolved, [0 255]);
    title('X convolved')
    subplot(2, 2, 2), imshow(yConvolved, [0 255]);
    title('Y convolved')
    subplot(2, 2, 3), imshow(combined, [0 255]);
    title('Combined')
    subplot(2, 2, 4), imshow(max(combined, 80), [0 255]);
    title('Combined with threshold')
    
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_convolution_results.jpg');
    print(figH, '-djpeg', figName);
end
diary off

function z = calc_hist(pic)
    % Constructing the histogram
    [r,c]=size(pic);
    z = zeros(1,256);
    
    for i=1:r
        for j=1:c
            b = round(pic(i,j));
            z(b+1) = z(b+1) + 1;
        end
    end
end

function new_im = scale_image(pic, low, high)
    [r, c] = size(pic);
    new_im = zeros(r, c);
    k = double(255) / double(high - low);
    for i = 1 : r
        for j = 1 : c
            new_im(i, j) = min(round(max(0, pic(i, j) - low) * k), double(255));
        end
    end
end

function avg = weightedAvg(splicedMat, filter)
    [r, c] = size(splicedMat);
    avg = 0;
    for i = 1 : r
        for j = 1 : c
            avg = avg + splicedMat(i,j) * filter(i, j);
        end
    end
end

function res = convolveFunc(A, filter)
    [r, c] = size(A);
    res = zeros(r, c);
    
    for i = 1 : r
        for j = 1 : c
            if j <= c - 2 && i <= r - 2
                splicedMat = A(i:i+2, j:j+2);
                res(i+1, j+1) = weightedAvg(splicedMat, filter);
            end
        end
    end
end
