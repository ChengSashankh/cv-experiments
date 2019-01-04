% Sashankh Chengavalli Kumar - A0162363J
close all

FNames = {'letterBox.jpg';
'checker.jpg';
'pipe.jpg';
'carmanBox.jpg'};

for p = 1 : size(FNames)
    figH = figure;
    A = FNames{p};
    pic_original = imread(A);
    pic = double(rgb2gray(pic_original));
    
    % Step 1 - Get horizontal edge strength
    Ix = computeIx(pic);
    
    % Step 2 - Get vertical edge strength
    Iy = computeIy(pic);
    
    % Step 3 - Perform edge detection 
    imshow(pic_original);
    eig_min = getEigMin(Ix, Iy);
    threshold = top200(eig_min);
    [r, c] = size(pic);
    
    %Plot box around it
    for i = 7 : 7 : r
        for j = 7 : 7 : c
            if eig_min(i, j) >= threshold
                rectangle('Position', [j-6, i-6, 13, 13], 'EdgeColor', 'r');
            end
        end
    end
    
    % Step 4 - Write to file 
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_result.jpg');
    print(figH, '-djpeg', figName);
    
end

% Computes Ix Matrix
function Ix = computeIx(pic)
    [r, c] = size(pic);
    Ix = zeros(r, c);
    
    for i = 1 : r
        for j = 1 : c
            if i == r
                Ix(i, j) = 0;
            else
                Ix(i, j) = pic(i + 1, j) - pic(i, j);
            end
        end
    end
end

% Computes Iy matrix
function Iy = computeIy(pic)
    [r, c] = size(pic);
    Iy = zeros(r, c);
    
    for i = 1 : r
        for j = 1 : c
            if j == c
                Iy(i, j) = 0;
            else
                Iy(i, j) = pic(i, j + 1) - pic(i, j);
            end
        end
    end
end

function eig_min = getEigMin(Ix, Iy)
    [r, c] = size(Ix);
    eig_min = zeros(r, c);
    eig_min(:, :) = -99999;
    for i = 7 : 7 : r - 6
        for j = 7 : 7 : c - 6
            mat = computeSum(i, j, Ix, Iy);
            e = min(eig(mat));
            eig_min(i, j) = e;
        end
    end
end

% Compute the sum of Ix Iy matrix around point x, y
function mat = computeSum(x, y, Ix, Iy)
    mat = zeros(2,2);
    for i = x-6 : x+6
        for j = y-6 : y+6
            temp = [Ix(i, j)*Ix(i,j) Ix(i, j)*Iy(i, j); Ix(i, j)*Iy(i, j) Iy(i, j)*Iy(i, j)];
            mat = mat + temp;
        end
    end
end

function threshold = top200(eig_min)
    [r, c] = size(eig_min);
    row = reshape(eig_min, 1, r*c);
    row = sort(row);
    threshold = row(1, r*c - 199);
end