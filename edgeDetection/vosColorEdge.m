function ft = vosColorEdge(colorImage,wSize,mode)

% Function Vector Order Statistics Color Edge
%
%  function [ft] = vosColorEdge(colorImage,wSize)
%
%  Computes the color edge estimators from multispectral images according
%       to the method by Trahanias and Venetsanopoulos.
%
% [Inputs]
%   colorImage(mandatory)- Original multispectral image.
%   wSize(mandatory)- Size of the operator. It must be any
%       integer, so that the neighbourhood around each pixel will be
%       a squared of size (wSize*2+1)
%   mode(mandatory)- Specific Vector Order Statistic to be used, together
%       with the parameter settings used in its computation. Admissible
%       values are:
%           'VR'- Vector Range, as in Eq. (4);
%           'MVR-k'- Minimum VR, as in Eq. (7), where k is an integer;
%           'VD-l'- Vector dispersion, as in Eq. (8), where l is an integer;
%           'MVD-k-l'- Minimum VD, a in Eq. (9), where k,l are integers.
%           'NNVR'- As explained in Zhu et al, Eq. (41)
%
%
% [outputs]
%   ft- gradient estimation
%
% [usages]
%       ft = vosColorEdge(myImage,1,'VR');
%       ft = vosColorEdge(myImage,2,'MVR-3');
%       ft = vosColorEdge(myImage,2,'VD-3');
%       ft = vosColorEdge(myImage,4,'MVD-5-5');
%
% [note]
%
% [dependencies]
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%	Vector Order Statistics Operators as Color Edge Detectors
%	P.E. Trahanias, A.N. Venetsanopoulos
%	IEEE Trans. on Systems, Man and Cybernetics, Part B, 26 (1) 1996
%
%   A comprehensive analysis of edge detection for color images
%   Zhu, Plataniotis, Venetsanopoulos
%   ptical Engineering, 38(4), 612-625 1999
%

%
%	0- Validate Arguments 
%
assert(nargin==3,'Error at vosColorEdge: Wrong number of arguments.');
assert(wSize>0,'Error at vosColorEdge: wSize must be a positive integer.');


MODE_VR=1;
MODE_MVR=2;
MODE_VD=3;
MODE_MVD=4;
MODE_NNVR=5;



    


%
%	1- Preprocessing
%

if (strcmp(mode,'VR'))
    qMode=MODE_VR;
elseif (~isempty(strfind(mode,'MVR-')))
    qMode=MODE_MVR;
    params.k=str2num(regexprep(mode,'MVR-',''));
elseif(~isempty(strfind(mode,'MVD'))) % this check must be before VD's
    qMode=MODE_MVD;
    paramString=regexprep(mode,'MVD-','');
    params.k=str2num(paramString(1:strfind(paramString,'-')-1));
    params.l=str2num(paramString(strfind(paramString,'-')+1:end));
    factMatrix=repmat([1:params.l]',1,size(colorImage,3))./sum([1:params.l]);
elseif (~isempty(strfind(mode,'VD')))
    qMode=MODE_VD;
    params.l=str2num(regexprep(mode,'VD-',''));
    factMatrix=repmat([1:params.l]',1,size(colorImage,3))./sum([1:params.l]);
elseif (~isempty(strfind(mode,'NNVR')))
    qMode=MODE_NNVR;
else
    error('Error at vosColorEdge: Wrong mode');
end
   

wTotalSize=((2*wSize)+1);
wTotalArea=(wTotalSize)^2;


%
%	2- Processing
%

ft=zeros(size(colorImage,1),size(colorImage,2));

for idxRow=wSize+1:size(colorImage,1)-wSize
    
    for idxCol=wSize+1:size(colorImage,2)-wSize
        
        %a) Obtain the neighbourhood
        neigh=zeros(wTotalArea,size(colorImage,3));
        for idxChannel=1:size(colorImage,3)
            neigh(:,idxChannel)=reshape(colorImage(idxRow-wSize:idxRow+wSize,idxCol-wSize:idxCol+wSize,idxChannel),1,wTotalArea);
        end
        
        %b) Compute the differences 
        accDiffs=zeros(1,wTotalArea);
        for idxInstanceA=1:wTotalArea
            for idxInstanceB=1:wTotalArea
                accDiffs(idxInstanceA)=accDiffs(idxInstanceA)+...
                            sqrt(sum( (neigh(idxInstanceA,:)-neigh(idxInstanceB,:)).^2));
            end
        end
        [~,sortedPos]=sort(accDiffs,'descend');
        accDiffs=accDiffs(sortedPos);
        neigh=neigh(sortedPos,:);
        
        clear('sortedPos')
        
        
        %c) Compute the statistic
        switch qMode,
            case MODE_VR,
                ft(idxRow,idxCol)=sqrt(sum((neigh(1,:)-neigh(wTotalArea,:)).^2));
                
            case MODE_MVR,
                diffs=sum((neigh(wTotalArea-params.k+1:wTotalArea,:)-...
                            repmat(neigh(1,:),params.k,1)).^2,2);
                ft(idxRow,idxCol)=min(diffs);
                clear('diffs');
                
            case MODE_VD,
                cands=neigh(1:params.l,:);
                aggCand=sum(cands.*factMatrix,1);
                ft(idxRow,idxCol)=sqrt(sum( ( neigh(end,:)-aggCand ).^2));
                clear('cands','aggCand');
                
            case MODE_MVD,
                currentVal=inf;
                cands=neigh(1:params.l,:);
                aggCand=sum(cands.*factMatrix,1);
                for idxCand=1:params.k
                    thisVal=sqrt(sum((neigh(end-idxCand+1,:)-aggCand).^2));
                    currentVal=min(currentVal,thisVal);
                end
                ft(idxRow,idxCol)=currentVal;%idxRow==176 && idxCol==372
                clear('cands','aggCand');
                
            case MODE_NNVR,
                
                wVector=(accDiffs(end)-accDiffs)./...
                            (wTotalArea*accDiffs(end)-sum(accDiffs));
                aggCand=sum(neigh.*repmat(wVector',1,size(neigh,2)),1);  
                ft(idxRow,idxCol)=sqrt(sum((neigh(end,:)-aggCand).^2));
                
        end
    end
    
end

%
% 3- Output processing
%
   

    




