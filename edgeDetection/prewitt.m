function [out1,out2,out3] = prewitt(im)

% Function Prewitt
%
%  function [ft] = prewitt(im)
%  function [fx,fy] = prewitt(im)
%  function [ft,fx,fy] = prewitt(im)
%
%  Performs the Prewitt convolution for gradient
%       characterization. It does not smooth the image prior to the 
%       convolution and it does not binarize or skeletizes
%       the edges. It does not NORMALIZE the results.
%
%   The range of values to be obtained is
%       fx,fy -> [-3,3]
%       ft -> sqrt(18)
%
% [Inputs]
%   im(mandatory)- Greyscale image to be processed. Either in 
%       [0,1] or [0,255] scales. If using the second scale, 
%       data will be automatically converted to [0,1].
%
% [outputs]
%   ft- gradient magnitude
%   fx- gradient horizontal component (incr. to the right)
%   fy- gradient vertical component (incr. upwards)
%
% [usages]
%	[ft,fx,fy] = sobel(myImage)
%
% [see also]
%   function sobel
%
% [dependences]
%   none
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%
%	Prewitt, J. M. S.
%	Object enhancement and extraction
%	Picture Processing and Psychopictorics, 75-149 (1970)
%
%
%

%
% 0- Validate Arguments
%
assert(size(im,3)==1,'Error at function prewitt.m: the image must be monochannel');

%
% 1- Preprocessing
%
if (max(im(:))>1.0001)
    im=double(im)./255;
end
    
prewittFilterX = [-1 0 1; -1 0 1; -1 0 1];
prewittFilterY = prewittFilterX';


%
% 2- Processing
%
fx = double(imfilter(im,prewittFilterX,'replicate'));
fy = double(imfilter(im,prewittFilterY,'replicate'));
ft = sqrt(fx.^2+fy.^2);

%
% 3-  Output formatting
%
if (nargout==1)
    out1=ft;
elseif(nargout==2)
    out1=fx;
    out2=fy;
elseif(nargout==3)
    out1=ft;
    out2=fx;
    out3=fy;
end
