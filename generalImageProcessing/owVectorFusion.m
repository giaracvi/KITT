function [fusedX,fusedY]=owVectorFusion(fxs,fys,weights)


%
% Function Ordered Weighted Vector Fusion
%
%  This function fuses vectors according to the psoposal depicted in [1].
%
%  Regarding the use of magnitudes, vectors are assumed to belong to an
%  Euclidean space.
%
% [Inputs]
%   fxs(mandatory)- Vector of horizontal components
%   fys(mandatory)- Vector of vertical components
%   weights(optional)- Weights for the vectors. If missing, all of the
%   vectors are meant to have the same weight.
%
% [outputs]
%   fusedX- Horizontal component of the resulting vector
%   fusedY- Vertical component of the resulting vector
%
% [usages]
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)



%---------------------------
%% INTERNAL PARAMETERS
%---------------------------

error('There is ongoing work in project 041. Please use that code, and do not use this function');

%---------------------------
%% ARGUMENTS
%---------------------------
assert(nargin==2 || nargin==3,'Error at owVectorFusion: Wrong number of parameters');
assert(prod(size(fxs)==size(fys))==1,'Error at owVectorFusion: Horz and Vert components have different size');


%---------------------------
%% PREPROCESSING
%---------------------------
numVectors=length(fxs);
if (nargin==2)
    weights=ones(1,numVectors)./numVectors;
end
oris=atan2(fys,fxs);
mags=sqrt(fxs.^2+fys.^2);

%---------------------------
%% PROCESSING
%---------------------------
[sortedMags,poss]=sort(mags);
correctedWeights=redistributeWeights(sortedMags,weights);
sortedOris=oris(poss);

fusedTheta=0.5*sum(correctedWeights.*(sortedOris.*2));
fusedMag=sum(correctedWeights.*sorgedMagns);

fusedX=fusedMag.*cos(fusedTheta);
fusedY=fusedMag.*sin(fusedTheta);

%---------------------------
%% FINAL PROCEDURES
%---------------------------


return;

function correctedWeights=redistributeWeights(sortedMagns,weights)

correctedWeights=weights;

for idxVal=1:length(sortedMagns)-1
    %Finding the tied vectors
    equalPoss=find(sortedMagns==idxVal);
    if (length(equalPoss)>1)
        correctedWeights(equalPoss)=sum(weights(equalPoss))./length(equalPoss);
    end
end

%
% This functions redistributes the weights associated to the vectors. The
% idea can be broked down as follows:
%   a) The problem: When sorting vector according to their magnitude, some
%   of them are indistinguishable, but need to be sorted somehow. This
%   sorting is not defined, so our fusion operator would become ill-posed.
%   b) Instead of imposing a deterministic sorting for such in-sortable
%   situations, we identify those situations and give the same weight to
%   all the "tied" vectors. That is, we correct the weighing vector so that
%   any of the possible sortings used for the equal-magnitude vectors
%   produces the same result.
%











