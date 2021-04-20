
function [val,dtA,dtB]=hspectralBDM(spectraA,spectraB,ks,distMode)

% Function Hyperspectral Baddeley's Delta Metric
%
%  function [val,dtA,dtB]=hspectralBDM(spectraA,spectraB,ks,distMode)
%
% 	Compares two hyperspectrum using 
%
% [Inputs]
%   spectraA(mandatory)- Hyperspectrum represented as a discrete (binary) matrix 
%		(a binary matrix with same dimensions as spectraB)
%   spectraB(mandatory)- Hyperspectrum represented as a discrete (binary) matrix 
%		(a binary matrix with same dimensions as spectraA)
%   ks(mandatory)- Factors to multiply each dimension (must be a 2-place vector) before
%		computing the distance transformation.
%	distMode(mandatory)- Can be 'euc' (Euclidean), 'mnh' (Manhattan),
%		'che' (Chebyshev) or 'teuc_X' (Euclidean with max value of X).
%
% [outputs]
%   val- Distance (a scalar value)
%   dtA- Distance transform of the first hyperspectrum
%   dtB- Distance transform of the second hyperspectrum
%
% [usages]
%
% [note]
%	IMPORTANT: If not knowing how to convert a regular hyperspectrum (a vector)
%		into a discrete, binary matrix, use hs2mat, which is also distributed in the KITT).
%
% [dependencies]
%	dist=hspectralBDM(spectraA,spectraB,[1 3],'teuc_15')
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%	[1]
%	Baddeley’s Delta metric for local contrast computation in hyperspectral imagery
%	C. Lopez-Molina, D. Ayala-Martini. A. Lopez-Maestresalas, H. Bustince
%	Progress in Artificial Intelligence, January 2017, Pages 1-12
%

if (min(ks)<1)
    ks=ks./min(ks);
end


spectraAp=zeros(ceil(size(spectraA,1)*ks(1)), ceil(size(spectraA,2)*ks(2)));
spectraBp=zeros(ceil(size(spectraB,1)*ks(1)), ceil(size(spectraB,2)*ks(2)));

[pR,pC]=find(spectraA==1);
pR=round(pR.*ks(1));
pC=round(pC.*ks(2));
for idxPoint=1:length(pR)
    spectraAp(pR(idxPoint),pC(idxPoint))=1;
end

[pR,pC]=find(spectraB==1);
pR=round(pR.*ks(1));
pC=round(pC.*ks(2));
for idxPoint=1:length(pR)
    spectraBp(pR(idxPoint),pC(idxPoint))=1;
end

if (strcmp(distMode,'euc') ||...
    strcmp(distMode,'che') ||...
    strcmp(distMode,'mnh'))
        dtAp=bwdist(spectraAp,distMode);
        dtBp=bwdist(spectraBp,distMode);
elseif(~isempty(strfind(distMode,'teuc_')))
    limit=str2double(regexprep(distMode,'teuc_',''));% must be checked twt parameters
    
    dtAp=min(limit,bwdist(spectraAp,'euc'));
    dtBp=min(limit,bwdist(spectraBp,'euc'));
end

dtA=zeros(size(spectraA));
dtB=zeros(size(spectraB));

for idxR=1:size(spectraA,1)
    for idxC=1:size(spectraA,2)
        dtA(idxR,idxC)=dtAp(round(idxR*ks(1)),round(idxC*ks(2)));
        dtB(idxR,idxC)=dtBp(round(idxR*ks(1)),round(idxC*ks(2)));
    end
end


val=sum(sum(abs(dtA-dtB)))/numel(dtA);

