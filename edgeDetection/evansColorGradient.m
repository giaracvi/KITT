function [magn,oris]=evansColorGradient(colorIm,wSize,rejectedPairs,distance)


% Function Evans Color Gradient
%
%  function [magn,ori]=evansColorGradient(im,size,rejectedPairs,distance)
%  function [magn,ori]=evansColorGradient(im,size,rejectedPairs)
%
%   Computes the gradient at each image after the algorithm
%       proposed by Evans and Liu. This function implements the
%       robust version, despite the original one can be recovered
%       by setting rejectedPairs to 0.
%   The distance is the specific distance used to measure dissimilarity
%       between pairs of colors.
%   This function does NOT perform NMS or hysteresis.
%  
%
% [Inputs]
%   im(mandatory)- Color image. According to the work by Evans and Liu, it
%       should be RGB.
%   wSize(mandatory)- Size of the squared masks used in the algorithm
%   rejectedPairs(optional, default=1.5*size)- Number of pairs of pixels to
%       be removed.
%   distance(optional, default='L2')- Distance used to compute the
%       dissimilarity the possible values are 'L1' (1-powered Minkowski),
%       'L2' (2-powered Mikowski), 'Canberra' (canberra distance, as
%       explained by Androutsos et al. and 'AngMag' (angular and magnitude
%       distance used by Evans and Liu). Note that the latest, despite
%       being used in the paper is wrong. First, it's unstable for colors
%       near the 0, because the angular distance suffers from severe
%       output changes wrt small input ones. Second, produces a 0/0
%       operation (indetermination) if the black color appears. So, use
%       'AngMag' under your own responsability.
%
% [outputs]
%   magn- Magnitude of the gradient at each pixel. It is measured in the
%       range [0,1].
%   ori- Orientation of the gradient at each pixel. It is measured in the
%       range [0,pi[.
%
% [usages]
%   [magn,ori]=evansColorGradient(im,5)
%       (equiv. to [magn,ori]=evansColorGradient(im,5,8,'L2'))
%
% [notes]
%
%   The angular convention used takes the East (E) as 0 degrees,
%       and increases counterclockwise.
%   Hence, pi/2 is N, pi is W and 3*pi/2 is S.
%
%   The distance used to measure the dissimilarity of the colors is not the
%       one used by Evans and Liu. The reason is that it is not defined for
%       0-valued vectors (that is, the black). Why this was published that
%       way, I don't know, but I replaced it by Minkowski's L2. Dig the
%       code to modify it and leave it with L2-norm or Canberras distance.
%   By the way, the measure itself was presented (for RGB!) by Androutsos et al.
%   Still, no clue why did Evans and Liu use it.
%
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
%	A morphological gradient approach to color edge detection
%	A.N. Evans and X.U. Liu
%	IEEE Trans. on Image Processing, 2006, 15, 1454-1463
%
%   Distance measures for color image retrieval
%   Androutsos, D., Plataniotis, K. N., and Venetsanopoulos, A. N.
%   International Conference on Image Processing, 1998
%


%
%	0- Validate Arguments 
%
assert(2<=nargin & nargin<=4,'Error at evansColorGradient: Wrong number of arguments.');
assert(mod(wSize,2)==1,'Error at evansColorGradient: The wSize must be an odd integer.');
if (nargin<3)
    if (wSize==3) 
        rejectedPairs=2;
    elseif(wSize==5) 
        rejectedPairs=8;
    else
        rejectedPairs=round(1.5*wSize);
    end
else
    assert(rejectedPairs==floor(rejectedPairs),'Error at evansColorGradient: rejectedPairs must be an integer.');
    assert(rejectedPairs>=0,'Error at evansColorGradient: rejectedPairs must be positive.');
end

if (nargin<4)
    distance='L2';
else
    assert(~isempty(strmatch(distance,{'L1','L2','Canberra','AngMag'})),'Error at evansColorGradient: the distance is unknown.');
end

if (strcmp(distance,'L1'))
    dist_code=1;
elseif (strcmp(distance,'L2'))
    dist_code=2;
elseif (strcmp(distance,'Canberra'))
    dist_code=3;
elseif (strcmp(distance,'AngMag'))
    dist_code=4;
else
    error('Error at evansColorGradient: the distance is unknown.');
end

%
%	1- Preprocessing
%
wSizeHalf=(wSize-1)/2;

colorIm=double(colorIm);
if (max(colorIm(:))>1.001)
    colorIm=colorIm./255;
end

PI_FRAC=2/pi;
SQR_THREE=sqrt(3);

%
%	2- Processing
%

magn=zeros(size(colorIm,1),size(colorIm,2));
oris=zeros(size(colorIm,1),size(colorIm,2));



for i=wSizeHalf+1:size(colorIm,1)-wSizeHalf
    
    for j=wSizeHalf+1:size(colorIm,2)-wSizeHalf
        
        aux=colorIm(i-wSizeHalf:i+wSizeHalf,j-wSizeHalf:j+wSizeHalf,:);
         
        area=zeros(wSize*wSize,size(colorIm,3));
        for idChannel=1:size(colorIm,3)
             channelData=aux(:,:,idChannel);
             area(:,idChannel)=channelData(:);
        end
        clear('aux');
        %norms=sqrt(sum((area.^2),2)); 
        
        one2oneDists=zeros(size(area,1));
         for idxCandA=1:size(area,1)
             for idxCandB=idxCandA+1:size(area,1)

                 switch dist_code
                     case 1,
                         one2oneDists(idxCandA,idxCandB)=sum(abs(area(idxCandA,:)-area(idxCandB,:)))./3;
                     case 2,
                         one2oneDists(idxCandA,idxCandB)=sqrt(sum((area(idxCandA,:)-area(idxCandB,:)).^2))./SQR_THREE;
                     case 3,
                         one2oneDists(idxCandA,idxCandB)=sum(abs(area(idxCandA,:)-area(idxCandB,:))./(area(idxCandA,:)+area(idxCandB,:)));
                     case 4,  
                         % This metric is the one originally used by Evans and Liu.
                         % Is not suitable for RGB because it cannot handle
                         % zero-valued colors (i.e. black).
                         % Use under your own responsability
                         one2oneDists(idxCandA,idxCandB)=1 - ...
                                        (1-PI_FRAC*acos((area(idxCandA,:)*area(idxCandB,:)')/(norms(idxCandA)*norms(idxCandB))))*...
                                        (1-sqrt(sum((area(idxCandA,:)-area(idxCandB,:)).^2))/SQR_THREE);
                 end
             end
         end
         
         
         % Evans and Liu state that in the comparison, in order the
         % gradient to be robust, as many as rejectedPairs have to be
         % removed. This is, we remove the two most dissimilar pixels 
         % as many as rejectedPairs times.
		 
         
         for idxPair=1:rejectedPairs
            [~,pos]=max(one2oneDists(:));
            [x y]=ind2sub(size(one2oneDists),pos);
            one2oneDists(x,:)=-1;
            one2oneDists(:,y)=-1;
        end
        
        [maxVal maxPos]=max(one2oneDists(:));
        [pixelA pixelB]= ind2sub(size(one2oneDists),maxPos);
        magn(i,j)=maxVal;

        %for pixel A
        fromCoords=zeros(1,2);
        [fromCoords(1) fromCoords(2)]=ind2sub([wSize wSize],pixelA);
        
        %for pixel B
        toCoords=zeros(1,2);
        [toCoords(1) toCoords(2)]=ind2sub([wSize wSize],pixelB);
        
        
        oris(i,j)=atan(-(toCoords(1)-fromCoords(1))/(toCoords(2)-fromCoords(2)));
        if (oris(i,j)<0)
            oris(i,j)=oris(i,j)+pi;
        end
        if (isnan(oris(i,j)))
            oris(i,j)=0;
        end
    end
    %fprintf('row i=%d (%.2f secs)\n',i,toc);
end


end




