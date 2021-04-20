function [ft,oris] = martinColorGradientCue(colorImage,mode,radius,numOfBins)

% Function Martin et al. color edge estimator
%
%  [ft,oris] = martinColorGradientCue(colorImage,mode,radius,numOfBins)
%
%  Computes the color gradient cue from an image, as explained by Martin et al (2004).
%  It can be parameterized in the following aspects:
%       - Size of the neighbouring circle;
%       - Histogram binning mode (a+b or ab);
%       - Granularity of the histogram.
%
%   The disk separison is computed on 8 different direction, retaining the
%       maximum difference.
%
%   The images can be either RGB (so that they have to be converted to LUV)
%       or LUV.
%
%
%
% [Inputs]
%   rgbImage(mandatory)- Original image. If the number of elements in the
%       second dimension is 2, it is assumed to be LUV, otherwise it must
%       have 3 components and be an RGB image.
%   mode(mandatory)- Histogram processing mode. It can take values:
%           'joint'- A single histogram is used for chromaticity;
%           'indiv'- One histogram is used for each dimension of chromaticity;
%   radius(mandatory)- Radius of the area considered around each pixel in
%       the computation of the edge cue. Must be a positive real number.
%   numOfBins(optional, default=20)- Number of bins used for the
%       computation of the Chi dissimilarity statistic.
%
%
% [outputs]
%   ft- edge cue;
%   ori- Orientation of the maximum gradient cue at each position of the image.
%       Note that this orientation is perpendicular to the edge itself.
%
% [usages]
%
% [note]
%   The authors of the work encourage the use of the 'indiv' option,
%       claiming that 'joint' increases the computational load to little or
%       no improvement. Still, both options are offerered.
%
%
% [dependencies]
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%	Learning to detect natural image boundaries using local brightness, color, and texture cues
%	DR Martin, CC Fowlkes, J Malik
%	IEEE Trans. on Pattern Analysis and Machine Intelligence 26(5), 530-549 2004
%

%
%	0- Validate Arguments 
%
assert(3<=nargin && nargin<=4,'Error at martinColorGradientCue: Wrong number of arguments.');
assert(size(colorImage,3)==2 || size(colorImage,3)==3,'Error at martinColorGradientCue: The image must have 2 or 3 elements in the third dimension.');
assert(min(colorImage(:))>=0,'Error at martinColorEdge: No color component can be negative.');
assert(max(colorImage(:))<=1,'Error at martinColorEdge: No color component can be over 1.');
assert(radius>0,'Error at martinColorGradientCue: Radius must be a positive value.');


MODE_JOINT=1;
MODE_INDIV=2;

if (strcmp(mode,'joint'))
    qMode=MODE_JOINT;
elseif (strcmp(mode,'indiv'))
    qMode=MODE_INDIV;
else
    error('Error at vosColorEdge: Wrong mode');
end



%
%	1- Preprocessing
%

% a) converting the image to L*U*V
if (size(colorImage,3)==3)
    cform = makecform('srgb2lab');
    labImage = applycform(double(colorImage),cform); 
    abImage=labImage(:,:,2:3);
    abImage=(abImage+128)./256;
else
    abImage=colorImage;
end
clear('colorImage');

% b) orientations


radius=7;

thetas=[0:7]*pi./8;
thetaMasks=zeros(radius*2+1,radius*2+1,length(thetas));

fRow=-repmat([-radius:radius]',1,radius*2+1);
fCol=-fRow';
angles=atan2(fRow,fCol);
angles(angles<0)=angles(angles<0)+2*pi;

angles(sqrt(fRow.^2+fCol.^2)>radius)=NaN;

for idxTheta=1:length(thetas)
    theta=thetas(idxTheta);
    auxMask=zeros(radius*2+1,radius*2+1);
    auxMask(and(theta<=angles,angles<theta+pi))=1;
    auxMask(or(angles<theta,theta+pi<=angles))=-1;
    auxMask(radius+1,radius+1)=0;
    thetaMasks(:,:,idxTheta)=-rot90(auxMask);
end


%
%	2- Processing
%

ft=zeros(size(abImage,1),size(abImage,2));
oris=zeros(size(ft));

for idxRow=radius+1:size(abImage,1)-radius
    for idxCol=radius+1:size(abImage,2)-radius
        
        % get subwindow
        subWinA=abImage(idxRow-radius:idxRow+radius,...
                        idxCol-radius:idxCol+radius,1);
        subWinB=abImage(idxRow-radius:idxRow+radius,...
                        idxCol-radius:idxCol+radius,2);
                    
        % For each orientation
        for idxTheta=1:length(thetas)
            
            %get components
            oneA=subWinA(thetaMasks(:,:,idxTheta)==1);
            twoA=subWinA(thetaMasks(:,:,idxTheta)==-1);
            oneB=subWinB(thetaMasks(:,:,idxTheta)==1);
            twoB=subWinB(thetaMasks(:,:,idxTheta)==-1);
            
            %compute both hists and diff
            switch qMode
                case MODE_JOINT,
                    diff=1;
                    
                case MODE_INDIV,
                    oneAH=imhist(oneA,numOfBins);
                    twoAH=imhist(twoA,numOfBins);
                    oneBH=imhist(oneB,numOfBins);
                    twoBH=imhist(twoB,numOfBins);
                    
                    upperA=(oneAH-twoAH).^2;
                    lowerA=(oneAH+twoAH);
                    
                    upperB=(oneBH-twoBH).^2;
                    lowerB=(oneBH+twoBH);
                    
                    diff=0.5*sum(upperA(lowerA~=0)./lowerA(lowerA~=0))+...
                         0.5*sum(upperB(lowerB~=0)./lowerB(lowerB~=0));
                    
            end
            
            
            %compute diff
            
            %if max
            if (ft(idxRow,idxCol)<diff)
                ft(idxRow,idxCol)=diff;
                oris(idxRow,idxCol)=thetas(idxTheta);
            end
            
        end
    end
    
    idxRow
    
end


%
% 3- Output processing
%
   

   

%
% 4- Auxiliar functions
%






