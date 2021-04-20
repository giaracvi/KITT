function [out1,out2,out3] = gedS(im,tconorm)

% Function Gravitational Edge Detection with a t-conorm T
%
%  function [ft] = gedS(im,tconorm)
%  function [fx,fy] = gedS(im,tconorm)
%  function [ft,fx,fy] = gedS(im,tconorm)
%
%   This approach makes use of a t-conorm S to extract the 
%       estimations of the gradient a each point of the image.
%
% [Inputs]
%   image- Grayscale image, either in the interval [0,1] or
%		in the scale {1,...,255}. In any case, both are
%		normalized in the calculus.
%
%   tconorm- char representation of the t-conorm. So far, the
%		available options are:
%           'S_P'- Probabilistic Sum
%           'S_M'- Maximum
%           'S_L'- Lukasiewicz t-conorm
%
% [outputs]
%	[ft]- Euclidean magnitude of the gradient estimations
%	[fx,fy]- Horizontal and vertical components of the 
%		gradients at each pixel.
%	[ft,fx,fy]- Euclidean magnitude and horizontal and vertical 
%		components of the gradients at each pixel.
%
% [usages]
%
%       [ft] = gedS(image,'S_M')
%       [fx,fy] = gedS(image,'S_L')
%       [fx,fy,ft] = gedS(image,'S_P')
%
% [note]
%
%   The intelectual properties associated to the publication are
%       owned by Elsevier B.V. (www.elsevier.com)
%
% [dependencies]
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
%   On the use of t-conorms in the gravity-based approach to edge detection
%   Lopez-Molina, C. , Bustince, H. , Galar, M. , Fernandez, J. , De
%   Baets, B.
%   ISDA 2009 - 9th International Conference on Intelligent Systems Design
%   and Applications
%
%

%
%	0- Validate Arguments 
%
assert(nargin==2,'Error at gedS: Wrong number of arguments.');
assert(ischar(tnorm),'Error at gedS: Wrong invokation of the gedS function');
assert(~isempty(strmatch(tconorm,{'S_M','S_P','S_L'})), 'Error at gedS: Invalid t-conorm selection');
assert(min(im(:))>=0,'Error at gedS: The image should not contain pixel values below 0');


%
%	1- Preprocessing
%

% Image Pre-Processing including 0-values removal
if (max(max(im))>1)
    if (min(min(im))==0)
        procImage = (double(im)+1)./256;
    else
        procImage = (double(im))./255;
    end
else
    if (min(min(im))==0)
        procImage = (im+(1/255))/(256/255);
    else
        procImage=im;
        %else nothing to be done
    end
end

%Gradient components declaring
fx = zeros(size(procImage));
fy = zeros(size(procImage));

%Horizontal and vertical mask declaring
maskX=[-0.1787 0 0.1787; -0.5054 0 0.5054; -0.1787    0.0000    0.1787];
maskX=maskX.*(0.5547/0.5054);
maskY=-maskX';


%
%	2- Processing
%

%Product t-conorm
if (strcmp(tconorm,'S_P'))
    
    for i=2:size(procImage,1)-1
        for j=2:size(procImage,2)-1
            appZone = procImage(i,j)+procImage(i-1:i+1,j-1:j+1)-procImage(i,j).*procImage(i-1:i+1,j-1:j+1);
            fx(i,j) = sum(sum(appZone.*maskX));
            fy(i,j) = sum(sum(appZone.*maskY));
        end
    end
%Minimum t-norm
elseif(strcmp(tconorm,'S_M'))
    for i=2:size(procImage,1)-1
        for j=2:size(procImage,2)-1
            appZone = max(procImage(i,j),procImage(i-1:i+1,j-1:j+1));
            fx(i,j) = sum(sum(appZone.*maskX));
            fy(i,j) = sum(sum(appZone.*maskY));
        end
    end
%Lukasiewicz t-norm
elseif(strcmp(tconorm,'S_L'))
    for i=2:size(procImage,1)-1
        for j=2:size(procImage,2)-1
            appZone = min(1,procImage(i,j)+procImage(i-1:i+1,j-1:j+1));
            fx(i,j) = sum(sum(appZone.*maskX));
            fy(i,j) = sum(sum(appZone.*maskY));
        end
    end
    
end

%
% 3-  Output formatting
%
if (nargout==1)
    out1=sqrt(fx.^2+fy.^2);
elseif(nargout==2)
    out1=fx;
    out2=fy;
else
    out1=fx;
    out2=fy;
    out3=sqrt(fx.^2+fy.^2);
end


