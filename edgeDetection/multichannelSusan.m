function [ft,ori] = multichannelSusan(im,wSize,threshold,norm,mode)

% Function Multichannel SUSAN
%
%  function [ft] = multichannelSusan(im,wSize,threshold,norm,mode)
%  function [ft,ori] = multichannelSusan(im,wSize,threshold,norm,mode)
%
%  Follows the SUSAN algorithm for edge detection.
%       It does not smooth the image prior to the 
%       convolution and it does not binarize or skeletizes
%       the edges. It does not BINARIZE or NORMALIZE the results.
%  The output is the inverted USAN area (i.e. scalar edge estimator) and
%       the estimated gradient orientation.
%
%  This function differs from multichannelSusan.m in the fact that it admits
%       multichannel images. The algorithm only varies from the original in
%       the fact that the difference between a pixel and its neigbbours is
%       taken as a norm of their arithmetic difference.
%  The norm can be fixed by the user, but is typicaly the L2 norm.
%
%   The range of values to be obtained is
%       ft -> [0,1]
%       ori -> [0,2*pi[
%
% [Inputs]
%   im(mandatory)- Greyscale image to be processed. Either in 
%       [0,1] or [0,255] scales. If using the second scale, 
%       data will be automatically converted to [0,1].
%   wSize(mandatory)- Size of the sliding window used to compute the USAN
%       area at each pixel. It must be an odd, positive integer.
%   threshold(mandatory)- Value in the same scale as the image,
%       representing the maximum difference between a pixel and its
%       neighbour for the latter to be considered to belong to the USAN
%       area.
%   norm(optinal, default='L2')- Norm used to collapse the vectorial
%       difference between pixels to a single number in the computatio of
%       the USAN area. It can be 'L1' (1-pow minkowski/manhattan), 'L2' (2-pow Minkowski),
%       'CH' (Chebyshev).
%
%   mode(optional, default='exp')- A value in {'nlin','exp'}, representing
%       whether the method has to use the stepwise function ('nlin'), or
%       the continuous exponential funcion ('exp') in computing the USAN
%       area.
%
% [outputs]
%   ft- gradient magnitude
%   ori- orientation map in radians (E=0, then increases counterclockwise, e.g. NE=pi/4)
%       Pixels for which no gradient exist (ft==0), it is arbitrarily set
%       to 0.
%
% [usages]
%	[ft,ori] = susan(myImage,5,0.2)
%           (equiv. to susan(myImage,5,0.2,'L2','exp')
%
% [see also]
%
% [notes]
%   The horizontal components are positive to the right, while the 
%       vertical component increases upwards.
%
%   Note that, due to the double strategy for the computation of the
%       gradient orientation, the ori matrix has weird situations. That's
%       the algorithm itself, and the fact that small modifications in the
%       USAN area make it consider the situation as intra- or inter-edge.
%       Since the transition between both cases is not smooth, small
%       changes in the image can produce large modifications. We recommend
%       to use the ft with some scalar NMS procedure.
%
% [dependences]
%   none
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%
%	Smith and Brady
%	SUSAN- A new approach to low level image processing
%	International Journal of Computer Vision, 1995
%
%
%

%
% 0- Validate Arguments
%

assert(mod(wSize,2)==1,'Error at function multichannelSusan.m: nSize must be an odd integer.');
assert(wSize>1,'Error at function multichannelSusan.m: nSize must be greater than 1.');
assert(threshold>0,'Error at function multichannelSusan.m: threshold must be greater than 1.');
assert(ischar(norm),'Error at function multichannelSusan.m: The norm is not a char value.');
if (nargin<4)
    normName='L2';
else
    assert(~isempty(strmatch(norm,{'L1','L2','CH'})),'Error at function multichannelSusan.m: The mode should be either [L1], [L2] or [CH].');
end
if (nargin<5)
    mode='exp';
else
    assert(~isempty(strmatch(mode,{'nlin','exp'})),'Error at function multichannelSusan.m: The mode should be either [nlin] or [exp].');
end

%
% 1- Preprocessing
%
if (max(im(:))>1.001)
    im=double(im)./255;
    threshold=double(threshold)./255;
end

wHalfSize=(wSize-1)/2;
xMask=repmat([-wHalfSize:wHalfSize],wSize,1);
yMask=-xMask';
areaMask=zeros(wSize);
areaMask(sqrt(xMask.^2+yMask.^2)<=wHalfSize)=1;
wTotalArea=sum(areaMask(:));

%
% 2- Processing
%
ft=ones(size(im,1),size(im,2)).*(wTotalArea);%that number for the boundary regions to be 0 later on
if (nargout==2)
    ori=zeros(size(im));
end



% b) Piecewise weighing, generating directional info
for idxRow=wHalfSize+1:size(im,1)-wHalfSize
    for idxCol=wHalfSize+1:size(im,2)-wHalfSize
        
        area=im(idxRow-wHalfSize:idxRow+wHalfSize,...
                          idxCol-wHalfSize:idxCol+wHalfSize,:);
        for idxChannel=1:size(area,3)
            area(:,:,idxChannel)=area(:,:,idxChannel)-im(idxRow,idxCol,idxChannel);
        end
        area=computeNorm(area,norm);
        
                      
        if (strcmp(mode,'nlin'))
            area=1-im2bw(abs(area),threshold);
        elseif(strcmp(mode,'exp'))
            area=exp(-(area./threshold).^6);
        end
        
        ft(idxRow,idxCol)=sum(sum(area.*areaMask));

        if (nargout==2)
            %In directional info there's 3 cases:
            %   No gradient, intra-pixel, inter-pixel
            if (ft(idxRow,idxCol)==wTotalArea || ft(idxRow,idxCol)==1)
                ori(idxRow,idxCol)=0;
            else
                if (ft(idxRow,idxCol)<=wSize)
                    %intra-pixel
                    ori(idxRow,idxCol)=intraPixelOrientation(area);

                else
                    %inter-pixel
                    ori(idxRow,idxCol)=interPixelOrientation(area);

                end

            end
        end
    end
end


%
% 3-  Output formatting
%
ft=1-ft./(wTotalArea);

end

%
% Z-  Auxiliar functions
%

%Note: if looking for high-performance, please substitute this into the 
%   main function, so that masks and so are not re-configured each time.

function diffMatrix=computeNorm(arithDiff,norm)

    switch norm
        case 'L1',
            diffMatrix=sum(abs(arithDiff),3);
        case 'L2',
            diffMatrix=sqrt(sum(arithDiff.^2,3));
        case 'CH',
            diffMatrix=max(abs(arithDiff),[],3);
        otherwise 
           error('Error multichannelSusan: Wrong norma name');
    end

end

function ori=intraPixelOrientation(area)

    wHalfSize=(size(area,1)-1)/2;
    xMask=repmat([-wHalfSize:wHalfSize],size(area,1),1);
    yMask=-xMask';

    ft=sum(sum(area));
    fx=sum(sum(area.*(xMask.^2)))./ft;
    fy=sum(sum(area.*(yMask.^2)))./ft;

    ori= atan(fy./fx);
    ori=ori+pi/2;

    if(sum(sum(area.*yMask.*xMask))<0)
        ori=ori+pi/2;
    end

    if (ori>=pi)
        ori=ori-pi;
    end

end

function ori=interPixelOrientation(area)

    ft=sum(sum(area));
    wHalfSize=(size(area,1)-1)/2;

    xMask=repmat([-wHalfSize:wHalfSize],size(area,1),1);
    yMask=-xMask';

    fx=sum(sum(area.*xMask))./ft;
    fy=sum(sum(area.*yMask))./ft;

    if ((ft<=2*size(area,1)) && sqrt(fx.^2+fy.^2)<1)
        %we correct, that's the second case for intra-pixel:
        %   having the CoG less than 1 pixel away from center
        ori=intraPixelOrientation(area);
    else
        ori= atan(fy./fx);
        if (fx<0)
            ori=ori+pi;
        elseif (fx>=0 && fy<0)
            ori=ori+2*pi;
        end
    end

end