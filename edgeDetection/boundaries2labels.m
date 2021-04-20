function labelMap=boundaries2labels(boundariesImage,method)

% Function Boundaries to Labels
%
% Isolates each of the segments in bnImage (which should be a binary,
%   thin boundary image). 
%
% [Parameters]
%   bnImage- Should be a binary edge image in which edges are thin and are
%       indicated as 1's.
%   method- Boundary discrimination method. It can be set to
%       'connected', so that two pixels belong to the same boundary segment
%       if and only if are connected. It can also be set to 'region', so
%       that pixels belong to the same boundary segment if and only if they
%       split the same two regions.
%

%% params
junctionScope=1;

if (nargin==1)
    method='connected';
end

if (~strcmp(method,'connected')) && (~strcmp(method,'region'))
    error('Error at boundary2labels.m> Unknown method');
end



if (strcmp(method,'connected'))
     %% imageLimits
    limitsImage=zeros(size(boundariesImage));
    limitsImage(1,:)=1;
    limitsImage(end,:)=1;
    limitsImage(:,1)=1;
    limitsImage(:,end)=1;

    endPointsImage=boundariesImage.*limitsImage;
    [posX,posY]=find(endPointsImage==1);
    endPoints=[posX posY];

    regionsImage=boundaries2regions(boundariesImage);

    [eR,eC]=find(boundariesImage==1);
    for idxEPixel=1:length(eR)

        pR=eR(idxEPixel);
        pC=eC(idxEPixel);

        regions=unique(regionsImage(max(1,pR-junctionScope):min(pR+junctionScope,size(regionsImage,1)),...
                                    max(1,pC-junctionScope):min(pC+junctionScope,size(regionsImage,2))));

        if length(regions)>3
            rowsSoFar=size(endPoints,1);
            endPoints(rowsSoFar+1,1)=pR;
            endPoints(rowsSoFar+1,2)=pC;
        end
    end

    %% labelling
    auxBoundariesImage=boundariesImage;

    for idxRow=1:size(endPoints,1)
        pR=endPoints(idxRow,1);
        pC=endPoints(idxRow,2);
        auxBoundariesImage(max(1,pR-junctionScope):min(size(boundariesImage,1),pR+junctionScope),...
                      max(1,pC-junctionScope):min(size(boundariesImage,2),pC+junctionScope))=0;
    end

    connectedBoundaries=bwconncomp(auxBoundariesImage);

    labelMap=zeros(size(auxBoundariesImage));

    for idxComponent=1:connectedBoundaries.NumObjects
        labelMap(connectedBoundaries.PixelIdxList{idxComponent})=idxComponent;
    end


    %% map completion

    unassignedPixels=boundariesImage.*(labelMap==0);

    numTimes=1;%Greater than 3 means non-reachable, all-in-image-margin boundary

    while (sum(unassignedPixels(:))>0) && numTimes<3
        newLabels=ordfilt2(labelMap,9,ones(3));
        labelMap(unassignedPixels==1)=newLabels(unassignedPixels==1);
        unassignedPixels=boundariesImage.*(labelMap==0);    
        numTimes=numTimes+1;
    end
    
elseif(strcmp(method,'region'))

    %% regionJunction

    regionsImage=boundaries2regions(boundariesImage);

    maxRegion=ordfilt2(regionsImage,9,ones(3,3),'symmetric');
    regionsImage(regionsImage==0)=Inf;
    minRegion=ordfilt2(regionsImage,1,ones(3,3),'symmetric');
    regionsImage(isinf(regionsImage))=0;

    numRegions=max(regionsImage(:));
    regionMat=vec2mat([1:numRegions*numRegions],numRegions,numRegions);

    regionMat(eye(size(regionMat))==1)=0;

    [eR,eC]=find(boundariesImage==1);

    labelMap=zeros(size(boundariesImage));

    for idxEPixel=1:length(eR)

        pR=eR(idxEPixel);
        pC=eC(idxEPixel);

        labelMap(pR,pC)=regionMat(minRegion(pR,pC),maxRegion(pR,pC));

    end

    %% labelling
    labels=sort(unique(labelMap(:)));

    for idxLabel=2:length(labels)
        labelMap(labelMap==labels(idxLabel))=idxLabel;
    end

end
















