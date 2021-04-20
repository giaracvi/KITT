function [out1,out2,out3] = roberts(im)

% Function Roberts
%
%  function [ft] = roberts(im)
%  function [fx,fy] = roberts(im)
%  function [ft,fx,fy] = roberts(im)
%
%  Performs the roberts convolution for gradient
%       characterization. It does not smooth the image prior to the 
%       convolution and it does not binarize or skeletizes
%       the edges. It does not NORMALIZE the results.
%
%   The range of values to be obtained is
%       fx,fy -> [-1,1]
%       ft -> sqrt(2)
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
%	[ft,fx,fy] = roberts(myImage)
%
% [see also]
%   function canny
%
% [dependences]
%   none
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%   -
%

%
% 0- Validate Arguments
%
assert(size(im,3)==1,'Error at function roberts.m: the image must be monochannel');

%
% 1- Preprocessing
%


robertsFilterX = [1 0; 0 -1];
robertsFilterY = [0 1; -1 0];


%
% 2- Processing
%

fx = double(imfilter(im,robertsFilterX,'replicate'));
fy = double(imfilter(im,robertsFilterY,'replicate'));
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



