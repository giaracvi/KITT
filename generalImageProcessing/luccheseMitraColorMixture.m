function [uvYColor,rgbColor]=luccheseMitraColorMixture(rgbColors,weights)


% Function Lucchese-Mitra Color Mixture
%
%  function [uvYColor,rgbColor] = luccheseMitraColorMixture(colorImage,wSize)
%
%  Computes the resulting color mixture from a set of normalized RGB colors, 
%       according to the method by Lucchese-Mitra (2010).
%  The colors are defined row-wise, so that the matrix 'colors' must have
%       as many columns as 3.
%
%  In case the 'weights' are not defined, all the vectors in 'colors' are
%       supposed to have the same relevance.
%
%  Note that 'rgbColors' might have a single row, so that the function can be 
%       used to transform a color to uvZ representation
%
%  IMPORTANT: According to the formulation in the original paper, a
%       zero-valued color (black) will lead to undetermined quotients. They
%       will all be replaced by 0.001-valued vectors.
%
%
% [Inputs]
%   rgbColors(mandatory)- Matrix with the rgb colors. They can be repeated.
%       The matrix must have 3 columns, representing the RGB components.
%   weights(optional)- Relevance of the weights. The values must sum up to
%       1, and cannot be negative. In case the parameter is missing, all
%       the weights are considered equal. In case its length does not match
%       the number of rows of 'rgbColors', an error will be raised.
%
% [outputs]
%   uvYColor- Final color in uvZ system.
%   rgbColor- Final color in RGB system.
%
% [usages]
%
% [note]
%
% [dependencies]
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%	A new class of chromatic filters for color image processing. Theory and applications
%   Lucchese, L., & Mitra, S. K. 
%   IEEE Trans. on Image Processing 13(4), 534-548, 2004
%

%
%	0- Validate Arguments 
%

assert(1<=nargin && nargin<=2,'Error at luccheseMitraColorMixture: Wrong number of arguments.');
assert(size(rgbColors,2)==3,'Error at luccheseMitraColorMixture: The first argument should have 3 columns.');
assert(min(rgbColors(:))>=0,'Error at luccheseMitraColorMixture: No color component can be negative.');
assert(max(rgbColors(:))<=1,'Error at luccheseMitraColorMixture: No color component can be over 1.');
if (nargin==2)
    assert(min(weights)>=0,'Error at luccheseMitraColorMixture: The weights cannot be negative.');
    assert(abs(sum(weights))<=0.001,'Error at luccheseMitraColorMixture: The weights should sum up to 1.');
else
    weights=ones(1,size(rgbColors,1))./size(rgbColors,1);
end


%
%	1- Preprocessing
%

aMatrix=[0.49 0.31 0.20;
         0.17697 0.81240 0.01063;
         0 0.01 0.99];
         
rgbColors(max(rgbColors,[],2)==0,:)=0.001;
         


%
%	2- Processing
%


% a) Conversion to xyz; From Eq. (14)

xyzColors=(aMatrix*rgbColors')';

% b) Computing uP, vP; From Eq. (15)

divisorVect=(xyzColors(:,1)+15.*xyzColors(:,2)+3*xyzColors(:,3));

uP=(4.*xyzColors(:,1))./divisorVect;
vP=(9.*xyzColors(:,2))./divisorVect;

%Doesn't, matter, since the y channel will also be zero
uP(isnan(uP))=0;
vP(isnan(vP))=0;

clear('divisorVect');

% c) Computing final coordinates

divisorVect=sum(weights'.*xyzColors(:,2)./vP);
finalUp=(sum(weights'.*(xyzColors(:,2).*uP./vP) ))./ divisorVect;
finalVp=(sum(weights'.*(xyzColors(:,2)) ))./ divisorVect;
finalY=sum(weights'.* xyzColors(:,2));

clear('divisorVect');

%
% 3- Output processing
%

uvYColor=[finalUp finalVp finalY];

if (nargout==2)
    xyzColor=[(9/4)*(finalUp/finalVp)*finalY ...
              finalY ...
              ((12-3*finalUp-20*finalVp)/(4*finalVp))*finalY];
    rgbColor=aMatrix\xyzColor';
end
























