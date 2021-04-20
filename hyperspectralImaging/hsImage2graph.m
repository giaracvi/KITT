function graph=hsImage2graph(hsImage,vertexMode,measureName,connectMode)

% Function HyperSpectral Image to Graph
%
%  function graph=hsImage2graph(hsImage,vertexMode,measureName,connectMode)
%
% This function represents a hiperspectral (or multichannel) image 
%	as a graph. This graph has as many nodes as pixels in teh image,
%	each of then connected to its neighbours. Each pixel has either 4
%	or 8 neighbours, as determined by the invoker.
% Each vertex has a weight, which is computed also according to
%	the parameters passed to the function.
%
%
% [Inputs]
%   hsImage(mandatory)- The image itself. It can have any number of channels.
%   vertexMode(mandatory)- The class of functions used for the computation
%		of the weight of the vertices. It can be, as of today:
%			- 'fsim': Fuzzy Similarity Measure (channel to channel comparison)
%			- 'bdm': Baddeley's Delta Metric
%   measureName(mandatory)- Specific name of the function used for the comparison.
%		It has to be a parameter according to this schema.
%			- If the vertexMode is 'fsim', then it has to be composed as:
%				AGGNAME-EXPA-EXPB
%			  where AGGNAME is 'A' for arithmetic mean or 'G' for geometric mena,
%			  and EXPA and EXPB are the exponents of the automorphisms used 
%			  for the generation of the Fuzzy Similarity Measure.
%			  See [1] for details on this, or the examples down this document.
%			- If the vectexMode is 'bdm', then it has to be composed as:
%				METRIC-KVAL-NUMLUMINANCES,
%			  where METRIC is a metric acceptable by the function hspectralBDM.m (also in the KITT)
%			  KVAL is the trade-off parameter between both dimensions in the hyperspectra
%			  and NUMLUMINANCES is the number of discrete luminances considered for the Energy domain.
%			  (Again, see [1] for details).
%  connectMode (mandatory)- Whether the pixels are connected to 4 neighbours '4n' or 
%			  to 8 neighbours '8n'.
%
% [outputs]
%   graph- The graph, with the same number of rows and cols as the image. The depth 
%			is either 4 or 8, depending on the connectMode. The order of the vertices
%			is always clockwise, starting out by North (N). Hence, the second layer 
%			in the third dimension is E (for '4n' connectedness) or NE (for '8n' connectedness).
%
% [usages]
%	graph=hsImage2graph(hsImage,'fsim','A-1-1','4n')
%		Will create a graph so that each vertex has, as weight, the arithmetic mean 
%		of the absolute difference of the hyperspectra (point by point, aka wavelength by wavelength).
%	graph=hsImage2graph(hsImage,'bdm','euc-3-250','4n')
%		Will do te same, but the weight of each vertex is computed with Baddeley's Delta Metric,
%		using the Euclidean metric, and having that the distance factor luminance/wavelength
%		is 3 (see [1]), and also having 250 different energy levels in the discretization
%
% [note]
%	If not sure of what to use, go for hsImage2graph(hsImage,'fsim','A-1-1','4n'), potentially
%		changing the last argument for '8n'.
%
%
% [dependencies]
%	function hs2mat.m (from the KITT)
%	function hspectralBDM.m (from the KITT)
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%	[1]
%	Baddeleys Delta metric for local contrast computation in hyperspectral imagery
%	C. Lopez-Molina, D. Ayala-Martini. A. Lopez-Maestresalas, H. Bustince
%	Progress in Artificial Intelligence, January 2017, Pages 1-12
%



if (max(hsImage(:))>1.001)
    hsImage=hsImage./max(hsImage(:));
end


if (strcmp(vertexMode,'fsim'))

	%We check whether the sim is valid
	%Name processing
    dashPos=strfind(measureName,'-');
	aggName=measureName(1:dashPos(1)-1);
    expA=str2num(measureName(dashPos(1)+1:dashPos(2)-1));
    expB=str2num(measureName(dashPos(2)+1:end));
    
	
	hsImage=hsImage.^expA;
	
    if (strcmp(aggName,'A'))
    
        if (strcmp(connectMode,'4n'))
            graph=zeros(size(hsImage,1),size(hsImage,2),4);
        elseif(strcmp(connectMode,'8n'))
            graph=zeros(size(hsImage,1),size(hsImage,2),8);
        end 
        
        for idxSpectrum=1:size(hsImage,1);
            if (strcmp(connectMode,'4n'))
                graph(:,:,1)=graph(:,:,1)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 1 0; 0 -1 0; 0 0 0])).^expB;% N
                graph(:,:,2)=graph(:,:,2)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 1; 0 0 0])).^expB;% E
                graph(:,:,3)=graph(:,:,3)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 0; 0 1 0])).^expB;% S
                graph(:,:,4)=graph(:,:,4)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 1 -1 0; 0 0 0])).^expB;% W
            elseif (strcmp(connectMode,'8n'))
                graph(:,:,1)=graph(:,:,1)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 1 0; 0 -1 0; 0 0 0])).^expB;% N
                graph(:,:,2)=graph(:,:,2)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 1; 0 -1 0; 0 0 0])).^expB;% NE
                graph(:,:,3)=graph(:,:,3)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 1; 0 0 0])).^expB;% E
                graph(:,:,4)=graph(:,:,4)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 0; 0 0 1])).^expB;% SE
                graph(:,:,5)=graph(:,:,5)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 0; 0 1 0])).^expB;% S
                graph(:,:,6)=graph(:,:,6)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 0; 1 0 0])).^expB;% SW
                graph(:,:,7)=graph(:,:,7)+abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 1 -1 0; 0 0 0])).^expB;% W
                graph(:,:,8)=graph(:,:,8)+abs(imfilter(hsImage(:,:,idxSpectrum),[1 0 0; 0 -1 0; 0 0 0])).^expB;% NW
            end
        end
        
        graph=graph./(size(hsImage,1));
        
    elseif (strcmp(aggName,'M'))
    
    
        if (strcmp(connectMode,'4n'))
            graph=zeros(size(hsImage,1),size(hsImage,2),4);
        elseif(strcmp(connectMode,'8n'))
            graph=zeros(size(hsImage,1),size(hsImage,2),8);
        end 
        
        for idxSpectrum=1:size(hsImage,1);
            if (strcmp(connectMode,'4n'))
                graph(:,:,1)=max(graph(:,:,1),abs(imfilter(hsImage(:,:,idxSpectrum),[0 1 0; 0 -1 0; 0 0 0])).^expB);% N
                graph(:,:,2)=max(graph(:,:,2),abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 1; 0 0 0])).^expB);% E
                graph(:,:,3)=max(graph(:,:,3),abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 0; 0 1 0])).^expB);% S
                graph(:,:,4)=max(graph(:,:,4),abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 1 -1 0; 0 0 0])).^expB);% W
            elseif (strcmp(connectMode,'8n'))
                graph(:,:,1)=max(graph(:,:,1),abs(imfilter(hsImage(:,:,idxSpectrum),[0 1 0; 0 -1 0; 0 0 0])).^expB);% N
                graph(:,:,2)=max(graph(:,:,2),abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 1; 0 -1 0; 0 0 0])).^expB);% NE
                graph(:,:,3)=max(graph(:,:,3),abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 1; 0 0 0])).^expB);% E
                graph(:,:,4)=max(graph(:,:,4),abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 0; 0 0 1])).^expB);% SE
                graph(:,:,5)=max(graph(:,:,5),abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 0; 0 1 0])).^expB);% S
                graph(:,:,6)=max(graph(:,:,6),abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 0 -1 0; 1 0 0])).^expB);% SW
                graph(:,:,7)=max(graph(:,:,7),abs(imfilter(hsImage(:,:,idxSpectrum),[0 0 0; 1 -1 0; 0 0 0])).^expB);% W
                graph(:,:,8)=max(graph(:,:,8),abs(imfilter(hsImage(:,:,idxSpectrum),[1 0 0; 0 -1 0; 0 0 0])).^expB);% NW
            end
        end
        
        graph=graph.^(1/size(hsImage,1));
        
        
    else
        error('Sorry, but by now we only support arith-mean based similarities');
    end
	
elseif(strcmp(vertexMode,'bdm'))
        
    if (strcmp(connectMode,'4n'))
        graph=zeros(size(hsImage,1),size(hsImage,2),4);
    elseif(strcmp(connectMode,'8n'))
        graph=zeros(size(hsImage,1),size(hsImage,2),8);
    end 

    dashPos=strfind(measureName,'-');
    distMode=measureName(1:dashPos(1)-1);
    kSecondVal=str2num(measureName(dashPos(1)+1:dashPos(2)-1));
    numLuminances=str2num(measureName(dashPos(2)+1:end));
    
    
    if (strcmp(connectMode,'4n') || strcmp(connectMode,'8n'))
        
        %prevRowPanel=[];
        
        thisRowPanel=zeros(numLuminances+1,size(hsImage,3),size(graph,2));
        for idxCb=1:size(graph,2)
            auxData=hsImage(1,idxCb,:);
            thisRowPanel(:,:,idxCb)=hs2mat(auxData(:),numLuminances);
        end
        
        nextRowPanel=zeros(numLuminances+1,size(hsImage,3),size(graph,2));
        for idxCb=1:size(graph,2)
            auxData=hsImage(2,idxCb,:);
            nextRowPanel(:,:,idxCb)=hs2mat(auxData(:),numLuminances);
        end
        
        
        for idxR=2:size(graph,1)-1
            
            prevRowPanel=thisRowPanel;
            thisRowPanel=nextRowPanel;

            nextRowPanel=zeros(numLuminances+1,size(hsImage,3),size(graph,2));
            for idxCb=1:size(graph,2)
                auxData=hsImage(idxR+1,idxCb,:);
                nextRowPanel(:,:,idxCb)=hs2mat(auxData(:),numLuminances);
            end
            
            for idxC=2:size(graph,2)-1
                
                if (strcmp(connectMode,'4n'))
                
                    graph(idxR,idxC,1)=hspectralBDM(thisRowPanel(:,:,idxC),...
                                                    prevRowPanel(:,:,idxC),...
                                                    [1 kSecondVal],distMode);
                    graph(idxR-1,idxC,3)=graph(idxR,idxC,1);%It's also the S-directed in the upper row

                    graph(idxR,idxC,2)=hspectralBDM(thisRowPanel(:,:,idxC),...
                                                    thisRowPanel(:,:,idxC+1),...
                                                    [1 kSecondVal],distMode);
                    graph(idxR,idxC+1,4)=graph(idxR,idxC,2);%It's also the W-directed in the upper row
                
                else
               
                    graph(idxR,idxC,1)=hspectralBDM(thisRowPanel(:,:,idxC),...
                                                    prevRowPanel(:,:,idxC),...
                                                    [1 kSecondVal],distMode);
                    graph(idxR-1,idxC,5)=graph(idxR,idxC,1);%It's also the S-directed in the upper row

                    graph(idxR,idxC,2)=hspectralBDM(thisRowPanel(:,:,idxC),...
                                                    prevRowPanel(:,:,idxC+1),...
                                                    [1 kSecondVal],distMode);
                    graph(idxR-1,idxC+1,6)=graph(idxR,idxC,1);%It's also the SW-directed in the upper row

                    graph(idxR,idxC,3)=hspectralBDM(thisRowPanel(:,:,idxC),...
                                                    thisRowPanel(:,:,idxC+1),...
                                                    [1 kSecondVal],distMode);
                    graph(idxR,idxC+1,7)=graph(idxR,idxC,1);%It's also the W-directed in the upper row

                    graph(idxR,idxC,4)=hspectralBDM(thisRowPanel(:,:,idxC),...
                                                    nextRowPanel(:,:,idxC+1),...
                                                    [1 kSecondVal],distMode);
                    graph(idxR+1,idxC+1,8)=graph(idxR,idxC,1);%It's also the NW-directed in the upper row
                    
                end
                
                
                
            end
            
           
        end
        
    end
	
end












