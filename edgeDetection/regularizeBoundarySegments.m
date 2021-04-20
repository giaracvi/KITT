function finalMap=regularizeBoundarySegments(binaryBoundaries,intensityMap,discMethod,aggMethod)

% Function regularize boundary segments
%
% Isolates each of the segments in bnImage (which should be a binary,
%   thin boundary image). 
% Then, each of the elements at each segments will be assigned the same
% edge value. Otherwise said, the whole boundary will have an homogenous
% intensity.
%
% [Parameters]
%   bnImage- Should be a binary edge image in which edges are thin and are
%       indicated as 1's.
%   ft- Edge intensity map (aka toval variation map, gradient magnitude
%       map, edginess map,...) in which intensity is expressed as a
%       positive real. Only the positions tagged with 1's in bnImage will
%       be used, so the remaining positions can have any value.
%   discMethod- Boundary discrimination method. It can be set to
%       'connected', so that two pixels belong to the same boundary segment
%       if and only if are connected. It can also be set to 'region', so
%       that pixels belong to the same boundary segment if and only if they
%       split the same two regions.
%   aggMethod- Can be 'min','mean' or 'max', and define the operator used
%       to compute the final boundary segment intensity from the individual
%       intensities at each of the pixels. 
%
%

if (nargin==2)
    discMethod='connected';
    aggMethod='mean';
elseif (nargin==3)
    aggMethod='mean';
elseif(nargin<2) || (nargin>4)
    error('Error at regularizeBoundarySegments.m> Wrong number of parameters');
end

if (strcmp(aggMethod,'max'))
    AGG_METHOD=1;
elseif (strcmp(aggMethod,'min'))
    AGG_METHOD=2;
elseif (strcmp(aggMethod,'mean'))
    AGG_METHOD=3;
else
    error('Error at regularizeBoundarySegments.m> The discMethod is unkwnown');
end

boundaryLabels=boundaries2labels(binaryBoundaries,discMethod);

finalMap=zeros(size(binaryBoundaries));

for idxLabel=1:max(boundaryLabels(:))
    
    if (AGG_METHOD==1)
        finalMap(boundaryLabels==idxLabel)=max(intensityMap(boundaryLabels==idxLabel));
    elseif(AGG_METHOD==2)
        finalMap(boundaryLabels==idxLabel)=min(intensityMap(boundaryLabels==idxLabel));
    elseif(AGG_METHOD==3)
        finalMap(boundaryLabels==idxLabel)=mean(intensityMap(boundaryLabels==idxLabel));
    end
    
end

