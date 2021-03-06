%%Function to get the matrix
function [X, newX, newY] = getSubwindowData(mapTraining, img, window)
%MATRIX Gets X-matrix and Y-matrix for parts (windows) of the whole image.
% This function allows the selection of a small window of the whole image
% and work on that part. At the same time the number of training samples is
% conserved.
% 
% Input
% =====
% # mapTraining - same training map as for normal algorithm
%
% # img - The whole hyperspectral cube.
%
% # window - An array [4x1] defining the corner points of the window we want to
%            work on. It is structured as follows:
%           
%            window(1,2) - y and x coordinates of the left upper corner (or
%            x1 and x2 as in Matlab notation)
%            window(3,4) - y and x coordinates of the right bottom corner (or
%            x1 and x2 as in Matlab notation)

%get all the classes for the training set
c = length(unique(mapTraining)) - 1;
%get the size of the whole image
[a, b, d] = size(img);
%build X, Y matrix with the coressponding size
X = reshape(img, a*b, d);

% Y = zeros(a*b, c);
% Y_window = zeros((window(3)-window(1)+1)*(window(4)-window(2)+1), c);
% Y_out = zeros(a*b-(window(3)-window(1)+1)*(window(4)-window(2)+1), c(length(c)));

width  = window(4) - window(2) + 1;
height = window(3) - window(1) + 1;

imgWindow = img(window(1):window(3), window(2):window(4), :);

X_window = reshape(imgWindow, height*width, d);

Y_window = getLabelMatrixY( mapTraining(window(1):window(3), window(2):window(4)), c );

% for m = window(1):window(3)
%     for n = window(2):window(4)
%         X_window(sub2ind([window(3)-window(1)+1,window(4)-window(2)+1], m-window(1)+1,n-window(2)+1),:) = img(m,n,:);
%         if(mapTraining(m,n) ~= 0)
%             Y_window(sub2ind([window(3)-window(1)+1,window(4)-window(2)+1], m-window(1)+1,n-window(2)+1),mapTraining(m,n)) = 1;
%         end
%     end
% end %ok

outerTrainingMap = mapTraining;
outerTrainingMap(window(1):window(3), window(2):window(4)) = 0; %block out the training samples in the window

% n_outer = nnz(outerTrainingMap ~= 0);

X_outer = X(outerTrainingMap ~= 0,:);
Y_outer = getLabelMatrixY( outerTrainingMap(outerTrainingMap ~= 0), c );

% num = 0;
% newTrainData = [];
% Y_out = [];
% 
% for i = 1:a
%     for j = 1:b     
%         X(sub2ind([a,b], i, j),:) = img(i,j,:);
%         if(mapTraining(i,j) ~= 0)      
%             Y(sub2ind([a,b], i, j), mapTraining(i,j)) = 1;  
%             if(i<window(1) || i<window(2) || j>window(3) || j>window(4)) %Add training point if not in window
%                 num = num + 1;
%                 Y_out(num, mapTraining(i,j)) = 1;
%                 newTrainData(num,:) = img(i,j,:);
%             end 
%         end
%     end
% end
% 
% newX = [X_window; newTrainData];
% newY = [Y_window; Y_out(1:num,:)];

newX = [X_window; X_outer];
newY = [Y_window; Y_outer];
end