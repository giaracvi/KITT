function [out1,out2,out3] = laligant(im)

% Function laligant
%
%  function [ft] = laligant(im)
%  function [fx,fy] = laligant(im)
%  function [ft,fx,fy] = laligant(im)
%
%  Performs the Laligant-Truchelet convolution for gradient
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
%	[ft,fx,fy] = laligant(myImage)
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
%
%	Laligant, Olivier and Truchetet, Frederic
%	A Nonlinear Derivative Scheme Applied to Edge Detection
%	IEEE Trans. on Pattern Analysis and Machine Intelligence 32 (2) 242-257
%	2010
%
%

%
% 0- Validate Arguments
%
assert(size(im,3)==1,'Error at function laligant.m: the image must be monochannel');

%
% 1- Preprocessing
%
laligantFilterX = [0 0 0; 0 -1 1; 0 0 0];
laligantFilterY = rot90(laligantFilterX);


%
% 2- Processing
%
fx = double(imfilter(im,laligantFilterX,'replicate'));
fy = double(imfilter(im,laligantFilterY,'replicate'));
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



