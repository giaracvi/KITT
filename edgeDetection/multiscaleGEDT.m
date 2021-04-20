function bnMap = multiscaleGEDT(im,tnorm,sigmas,maxDisp)

% Function Multiscale Gravitational Edge Detection with a t-norm T
%
%  bnMap = multiscaleGEDT(im,tnorm,sigmas)
%  bnMap = multiscaleGEDT(im,tnorm,sigmas,maxDisp)
%
%   This approach makes use of a t-norm T to extract the 
%       estimations of the gradient a each point of the image.
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
%   tnorm- char representation of the t-norm. So far, the
%		available options are:
%           'T_P'- Product
%           'T_M'- Minimum
%           'T_L'- Lukasiewicz t-norm
%           'T_nM'- Nilpotent minimum t-norm
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
%	> [ft] = multiscaleGEDT(image,'T_M',[0.5 1 1.5 2 2.5 3])
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
%   function gedT
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
%
%
% [references]
%
%   A Gravitational Approach to Edge Detection based on triangular norms
%   Lopez-Molina, C; Bustince, H; Fernandez, J; Couto, P; De Baets, B
%   Pattern Recognition, 
%   Vol. 43, Issue 11, Pages 3730-3741
%
%   Multiscale Extension of the Gravitational Approach to Edge Detection
%   Lopez-Molina,C, De Baets,B, Bustince,H, Barrenechea,E, Galar,M.
%   Lecture Notes in Computer Science- Advances in Artificial Intelligence,
%   2011, 7023, 283-292
%
%

%
%	0- Validate Arguments 
%

assert(nargin==3 || nargin==4,'Error at multiscaleGEDT: Wrong number of arguments.');
assert(min(sigmas)>0,'Error at multiscaleGEDT: Sigmas cant be negative.');
assert(ischar(tnorm),'Error at multiscaleGEDT: Wrong invokation of the GEDT function');
assert(~isempty(strmatch(tnorm,{'T_M','T_P','T_L','T_nM'})), 'Error at multiscaleGEDT: Invalid t-norm selection');
assert(min(im(:))>=0,'Error at multiscaleGEDT: The image should not contain pixel values below 0');

%
%   1- Preprocessing
%
bnMaps=zeros(size(im,1),size(im,2),length(sigmas));


%
%   2- Processing
%

for idxScales=1:length(sigmas)
    
    smooImg=gaussianSmooth(im,sigmas(idxScales));
    [fx,fy]=gedT(smooImg,tnorm);
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



























