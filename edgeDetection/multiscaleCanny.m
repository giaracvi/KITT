function bnMap = multiscaleCanny(im,cannySigma,sigmas,maxDisp)

% Function Multiscale Canny
%
%  bnMap = multiscaleCanny(im,sigmas)
%  bnMap = multiscaleCanny(im,sigmas,maxDisp)
%
%   This approach makes use Canny operators to compute
%       estimations of the gradient a each point of the image.
%   The sigma after which the operators are generated must be set by the
%       user
%
%   It considers several scales in the Gaussian Scale-space to generate 
%       a multiscale representation of the edges. A final map is created
%       by using top-down tracking.
%   Note that the edges must be binarized. We use in the process NMS and
%       hysteresis, whose thresholds are determined by the double Rosin
%       method.
%
% [Inputs]
%
%   image- Grayscale image, either in the interval [0,1] or
%		in the scale {1,...,255}. In any case, both are
%		normalized in the calculus.
%
%   cannySigma- Standard deviation of the firts order Gaussian operators
%       (aka Canny masks).
%
%   sigmas- Values of sigma in the projection into the GSS.
%
%   maxDisp (optional,default=sqrt(2))- Maximum displacement of an edge
%       between two consecutive scales.
%
% [outputs]
%	[bnMap]- Binary edge map.
%
% [usages]
%
%	> [bnMap] = multiscaleCanny(image,[0.5 1 1.5 2 2.5 3])
%
% [note]
%
% [dependencies]
%
%   function gaussianSmoothing (from filteringPackage)
%   function edgeTracking
%   function doubleRosinThr
%   function floodHysteresis
%   function directionalNMS
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
%
%
% [references]
%
%   Multiscale Edge Detection Based on Gaussian Smoothing and Edge Tracking
%   Lopez-Molina, C; De Baets, B; Bustince, H; Sanz, J & Barrenechea, E
%   Knowledge-Based Systems, 2013, 44, 101-111
%
%

% [versioning]
%   1.00  /2014-08-01/ Initial version
%

%
%	0- Validate Arguments 
%

assert(nargin==3 || nargin==4,'Error at multiscaleCanny: Wrong number of arguments.');
assert(min(sigmas)>0,'Error at multiscaleCanny: Sigmas cant be negative.');
assert(min(im(:))>=0,'Error at multiscaleCanny: The image should not contain pixel values below 0');
%default
if (nargin==3)
    maxDisp=sqrt(2);
end

%
%   1- Preprocessing
%

bnMaps=zeros(size(im,1),size(im,2),length(sigmas));


%
%   2- Processing
%

for idxScales=1:length(sigmas)
    
    smooImg=gaussianSmooth(im,sigmas(idxScales));
    [fx,fy]=canny(smooImg,cannySigma);
    bnMaps(:,:,idxScales)=binarize(fx,fy);
end

bnMap=edgeTracking(bnMaps(:,:,end:-1:1),maxDisp);

end

function bnImage=binarize(fx,fy)

    %Normalize & stretch
    ft=sqrt(fx.^2+fy.^2);
    fx=fx./max(ft(:));
    fy=fy./max(ft(:));
    ft=ft./max(ft(:));
    
    %Thin & binarize
    thrss=doubleRosinThr(ft,0.005,2);
    thinMap=directionalNMS(fx,fy);
    bnImage=floodHysteresis(thinMap.*ft,thrss(2),thrss(1));

end



























