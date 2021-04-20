function [out1,out2,out3] = carronLambertColorGradient(colorImg,mode)

% Function Carron Lambert Color Gradient
%
%  function ft = carronLambertColorGradient(rgbImg,mode)
%  function [fx,fy] = carronLambertColorGradient(rgbImg,mode)
%  function [ft,fx,fy] = carronLambertColorGradient(rgbImg,mode)
%
%  This function computes the R^2 gradient from a color image
%    according to the procedure by Carron and Lamberts (1994).
%  The user must specify the mode of the image (rgb or hsi).
%
% [Inputs]
%   colorImg(mandatory)- Original multispectral image.
%   mode(optional, default='rgb')- Mode of the image, must be either
%       'rgb' or 'hsi'.
%
% [outputs]
%   ft- gradient magnitude
%   fx- gradient horizontal component (incr. to the right)
%   fy- gradient vertical component (incr. upwards)
%   
%
% [usages]
%   [ft,fx,fy] = carronLambertColorGradient(myImage,'rgb')
%       (equiv. to [ft,fx,fy] = carronLambertColorGradient(myImage))
%   
%
% [note]
%
% [dependencies]
%   function sigmoidMapping (from utilitiesPackage)
%   function components2orientations (from utilitiesPackage)
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
%
% [references]
%	Color edge detector using jointly hue, saturation and intensity
%	Carron, Lambert
%	Proc of the IEEE Conf. on Image Processing (3) 977-981 (1994)
%

%
%	0- Validate Arguments 
%
assert(nargin==1 || nargin==2,'Error at carronLambertColorGradients: Wrong number of arguments.');
if (nargin==1)
    mode='rgb';
else
    assert(~isempty(strmatch(mode,{'rgb','hsi'})),...
            'Error at carronLambertColorGradients: Wrong mode argument.');
end


%
%	1- Preprocessing
%

if (max(colorImg(:))>1.001)
    colorImg=colorImg./max(colorImg(:));
end


if (strcmp(mode,'rgb'))
   auxImg=zeros(size(colorImg));
   auxImg(:,:,1)= mean(colorImg,3);%H
   auxImg(:,:,2)= colorImg(:,:,1)-0.5.*colorImg(:,:,2)-0.5.*colorImg(:,:,3);%S
   auxImg(:,:,3)= -(sqrt(3)/2).*colorImg(:,:,2)+(sqrt(3)/2).*colorImg(:,:,3);%I
   colorImg=auxImg;
   clear('auxImg');
end


%SO is the equilibrium point, 
param_SO=0.5;
%beta is the slope at the equilibrium point
param_beta=3;
hueSignificanceMap=sigmoidMapping(colorImg(:,:,1),[0,1],param_SO,param_beta);

param_maxH=0.5;


maskX=[-1 0 1; -2 0 2; -1 0 1];
maskY=rot90(maskX);


%
%	2- Processing
%

% a) Computing channelwise gradients

cwise_fx=zeros(size(colorImg));
cwise_fy=zeros(size(colorImg));

for iRow=2:size(colorImg,1)-1
    for iCol=2:size(colorImg,2)-1
        %Hue
        [cwise_fx(iRow,iCol,1),cwise_fy(iRow,iCol,1)]=hueDiff(colorImg(iRow-1:iRow+1,iCol-1:iCol+1,1),...
                                                                hueSignificanceMap(iRow-1:iRow+1,iCol-1:iCol+1));
        
        %Saturation
        cwise_fx(iRow,iCol,2)=sum(sum(colorImg(iRow-1:iRow+1,iCol-1:iCol+1,2).*maskX));
        cwise_fy(iRow,iCol,2)=sum(sum(colorImg(iRow-1:iRow+1,iCol-1:iCol+1,2).*maskY));
        
        %Intensity
        cwise_fx(iRow,iCol,3)=sum(sum(colorImg(iRow-1:iRow+1,iCol-1:iCol+1,3).*maskX));
        cwise_fy(iRow,iCol,3)=sum(sum(colorImg(iRow-1:iRow+1,iCol-1:iCol+1,3).*maskY));
        
    end
end

[cwise_oris,cwise_ft]=components2orientations(cwise_fx,cwise_fy);




% b) Fusioning the channelwise information
ft=sum(cwise_ft,3);
[~,maxChannelPos]=max(cwise_ft,[],3);

ori=zeros(size(ft));

% This could be done faster... but I have no time right now
for iRow=2:size(colorImg,1)-1
    for iCol=2:size(colorImg,2)-1
        ori(iRow,iCol)=cwise_oris(iRow,iCol,maxChannelPos(iRow,iCol));
    end
end


%
%   3- Output formatting
%

switch nargout
    case 1,
        out1=ft;
    case 2,
        out1=ft.*cos(ori);
        out2=ft.*sin(ori);
    case 3,
        out1=ft;
        out2=ft.*cos(ori);
        out3=ft.*sin(ori);
end
        


end





function [fx,fy]=hueDiff(hueValues,signValues)
       
    MAXH=0.5;

    fx= sqrt(signValues(1,3)*signValues(1,1))*sign(hueValues(1,3)-hueValues(1,1))*min(abs(hueValues(1,3)-hueValues(1,1)),MAXH) + ...
            2*sqrt(signValues(2,3)*signValues(2,1))*sign(hueValues(2,3)-hueValues(2,1))*min(abs(hueValues(2,3)-hueValues(2,1)),MAXH) + ...
            sqrt(signValues(3,3)*signValues(3,1))*sign(hueValues(3,3)-hueValues(3,1))*min(abs(hueValues(3,3)-hueValues(3,1)),MAXH);
    
    fy= sqrt(signValues(1,1)*signValues(3,1))*sign(hueValues(1,1)-hueValues(3,1))*min(abs(hueValues(1,1)-hueValues(3,1)),MAXH) + ...
            2*sqrt(signValues(1,2)*signValues(3,2))*sign(hueValues(1,2)-hueValues(3,2))*min(abs(hueValues(1,2)-hueValues(3,2)),MAXH) + ...
            sqrt(signValues(1,3)*signValues(3,3))*sign(hueValues(1,3)-hueValues(3,3))*min(abs(hueValues(1,3)-hueValues(3,3)),MAXH);
        
end

