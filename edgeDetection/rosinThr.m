function [bestThreshold] = rosinThr(originalImage,precision,gaussianSigma)

% Function Rosin Thresholding
%
%  function [threshold] = rosinThr(image,precision,gaussianSigma)
%
%  Obtains the optimal threshold using the Rosin method.
%  This methods assumes the histogram to be unimodal.
%  It relies on the histogram to be non-increasing
%       after its peak. That means that there should be no
%       zero-bins in the histogram followed by non-zero ones.
%  Furthermore, it assumes the peak of the histogram to 
%       be closer to the low intensity, rather than to the
%       high one. 
%
%  
%
% [Inputs]
%
%   image(mandatory)- Grayscale image, either [0,1] or [0,255]
%   precision(optional, default=0.01)- Threshold precision, 0.01 by default
%   gaussianSigma(optional, default=0.00)- Sigma of the Gaussian pulse used for
%       smoothing the histogram. The value 0 leads to no-smoothing 
%       at al.
%
% [outputs]
%
%   threshold- The value.
%
% [usages]
%
%   th = rosinThr(myImage);
%       [equiv. to rosinThr(myImage,0.01,0)]
%   th = rosinThr(myImage,0.005);
%       [equiv. to rosinThr(myImage,0.005,0)]
%   th = rosinThr(myImage,0.02,3);
%
% [dependencies]
%   function gaussianSmooth
%
% [author]
%
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
% 
%   Unimodal Thresholding
%   Paul L. Rosin
%   Pattern Recognition 34 (2001) 2083-2096
% 

% Versioning
%   1.00 - Released (2014, Feb)
%   1.01 - Corrected a double peak situation (2014,July)
%


%
%	0- Validate Arguments 
%

assert(1<=nargin && nargin<=3,'Error at rosinThr: Wrong number of parameters.');

if (nargin==1)
    binNumber=100;
else
    assert(precision<0.1,'Error at rosinThr: The precision is too coarse, please introduce a smaller number.');
    binNumber= round(1/precision);
end

if (nargin==3)
    assert(gaussianSigma>=0,'Error at rosinThr: Negative sigmas are not allowed.');
else
    gaussianSigma=0;
end
    

fprintf('Deprecated, please use kitt>edgeDetection>rosinUnimodalThr instead\n');

%
%	1- Preprocessing
%

originalImage = double(originalImage);
if (max(originalImage(:))>1.001)
    factor = 255;
    originalImage= originalImage./255;
else
    factor=1;
end



%
%	2- Processing
%

histogram = imhist(originalImage(:),binNumber);

if (gaussianSigma>0)
    histogram=gaussianSmooth(histogram,gaussianSigma);
end


%The mode is x, its occurrence is hx
% x is the bin #, not the value
[hx,x] = findpeaks(histogram);
if (isempty(hx))
    %No peak is found, probably the first bin is the max
    [hx,x]=max(histogram);
elseif (length(hx)>1)
    x=x(hx==max(hx));
    hx=max(hx);
    if (length(x)>1) %several peaks with same height
        x=x(1);
        hx=hx(1);
    end
end

%The first zero value is y, its occurrence is hy
% y is the bin #, not the value
aux=find(histogram==0);
if (isempty(aux))
    y=binNumber;
    hy=histogram(binNumber);
else
    y=aux(1);
    hy=histogram(y);
end

%y=binNumber;
%hy=histogram(binNumber);

%Defining the line
% (b) slope
a= (hy-hx)/(y-x);
% (a) abscises cutting point
b = hx - (x.*a);

%---------------------------
%% BEST VALUE PROCESSING
%---------------------------
distances=zeros(size(histogram));
maxDistance = 0;
bestThreshold=x;
for z=x+1:y-1
    % z is the candidate threshold
    hz = histogram(z); %z's ocurrence
    dist = abs(a*z-hz+b)/sqrt(a^2+1);
    distances(z)=dist;
    if (dist>maxDistance)
        maxDistance=dist;
        bestThreshold=z;
    end
end

%---------------------------
%% FINAL PROCEDURES
%---------------------------
perc = bestThreshold/binNumber;
bestThreshold=perc*factor;
