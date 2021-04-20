function [out1,out2,out3] = scharcanskiColorGradient(colorImage,wSize)

% Function Scharcanski-Venetsanopoulos Color Gradient
%
%  function [ft] = scharcanskiColorGradient(colorImage,wSize)
%  function [fx,fy] = scharcanskiColorGradient(colorImage,wSize)
%  function [ft,fx,fy] = scharcanskiColorGradient(colorImage,wSize)
%
%  Computes the color 2D gradients from multispectral images according
%       to the method by Scharcanski and Venetsanopoulos.
%
% [Inputs]
%   colorImage(mandatory)- Original multispectral image.
%   wSize(mandatory)- Size of the operator. It must be any
%       integer, so that the neighbourhood around each pixel will be
%       a squared of size (wSize*2+1)
%
% [outputs]
%   ft- gradient magnitude
%   fx- gradient horizontal component (incr. to the right)
%   fy- gradient vertical component (incr. upwards)
%
% [usages]
%       [ft,fx,fy] = scharcanskiColorGradient(myImage,1)
%
% [note]
%
% [dependencies]
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%	Edge detection of color images using directional operators
%	J. Scharcanski and A.N. Venetsanopoulos
%	IEEE Trans. on Circuits and Systems for Video Technology 7 (2) 1997,
%	pp. 397-401
%
%

%
%	0- Validate Arguments 
%
assert(nargin==2,'Error at scharcanskiColorGradient: Wrong number of arguments.');
assert(wSize>=1,'Error at scharcanskiColorGradient: wSize must be a positive value.');
assert(wSize==round(wSize),'Error at scharcanskiColorGradient: wSize must be an integer.');


%
%	1- Preprocessing
%

wTotalSize=wSize*2+1;

hPlusMask=[zeros(wTotalSize,wSize+1) ones(wTotalSize,wSize)]./(wTotalSize*wSize);
hMinusMask=fliplr(hPlusMask);
vPlusMask=rot90(hPlusMask);
vMinusMask=rot90(hMinusMask);



%
%	2- Processing
%

%a) Computing H+, H-, etc.

Hplus=zeros(size(colorImage));
Hminus=zeros(size(colorImage));
Vplus=zeros(size(colorImage));
Vminus=zeros(size(colorImage));

for idxChannel=1:size(colorImage,3)
    Hplus(:,:,idxChannel)=imfilter(colorImage(:,:,idxChannel),hPlusMask);
    Hminus(:,:,idxChannel)=imfilter(colorImage(:,:,idxChannel),hMinusMask);
    Vplus(:,:,idxChannel)=imfilter(colorImage(:,:,idxChannel),vPlusMask);
    Vminus(:,:,idxChannel)=imfilter(colorImage(:,:,idxChannel),vMinusMask);
end


%b) Computing VarH and VarV

VarH=Hplus-Hminus;
VarV=Vplus-Vminus;

%c) Final computations

normH=sqrt(sum(VarH.^2,3));
normV=sqrt(sum(VarV.^2,3));


ft=sqrt(normH.^2+ normV.^2);

vFact=ones(size(colorImage,1),size(colorImage,2));
hFact=ones(size(colorImage,1),size(colorImage,2));
vFact(sqrt(sum(Vplus.^2,3))<sqrt(sum(Vminus.^2,3)))=-1;
hFact(sqrt(sum(Hplus.^2,3))<sqrt(sum(Hminus.^2,3)))=-1;
theta=atan((vFact.*normV)./(hFact.*normH));


%
% 3- Output processing
%
   
switch nargout
    case 1,
        out1=ft;
    case 2,
        out1=cos(theta).*ft;
        out2=sin(theta).*ft;
    case 3,
        out1=ft;
        out2=cos(theta).*ft;
        out3=sin(theta).*ft;
end
    

sadd=4;




