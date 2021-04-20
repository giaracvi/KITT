function [gsImage,angles]=IVBilateralDifferentiation(ivImage,mask,orientations)

%
%
%


if (nargin~=3)
    error('IVDifferentiation.m Wrong number of parameters in function IVDifferentiation: %d is an incorrect number\n',nargin);
end


%
% 0- 
%

UP=1;
DOWN=2;

maxCentroids=zeros(size(ivImage,1),size(ivImage,2));
maxGradInf=zeros(size(ivImage,1),size(ivImage,2));
maxGradSup=zeros(size(ivImage,1),size(ivImage,2));
maxAngle=zeros(size(ivImage,1),size(ivImage,2));


for idxOrientation=1:length(orientations)
   
    thisOri=orientations(idxOrientation);
    signRegion=createRegionsByOri(thisOri,size(mask,1));
    finalMask=mask.*signRegion;
    
    [ivalDiffInf,ivalDiffSup]=IVFiltering(ivImage,finalMask);
    
    centroidVal=(ivalDiffInf+ivalDiffSup)./2;
    centroidMagn=abs(centroidVal);
    
%     negPlacesIm=zeros(size(ivImage,1),size(ivImage,2));
%     posPlacesIm=zeros(size(ivImage,1),size(ivImage,2));
    
    %Positions of the image for which the image goes increasing in the
    % orientation
    [posPlaces]=find(and(and(centroidMagn>maxCentroids,...
                             centroidMagn>0.001),...
                         centroidVal>0.001));
    %Positions of the image for which the image goes decreasing in the
    % orientation
    [negPlaces]=find(and(and(centroidMagn>maxCentroids,...
                             centroidMagn>0.001),...
                         centroidVal<0.001));
    
    
    maxCentroids(posPlaces)=centroidMagn(posPlaces);
    maxCentroids(negPlaces)=centroidMagn(negPlaces);
    
    %Increase (positive differences)
    maxGradInf(posPlaces)=max(0,ivalDiffInf(posPlaces));
    maxGradSup(posPlaces)=ivalDiffSup(posPlaces);
    maxAngle(posPlaces)=thisOri;
    
    %Increase (negative differences)
    maxGradInf(negPlaces)=max(0,-ivalDiffSup(negPlaces));
    maxGradSup(negPlaces)=-ivalDiffInf(negPlaces);
    maxAngle(negPlaces)=thisOri+pi;
    
    
%     negPlacesIm(negPlaces)=1;
%     posPlacesIm(posPlaces)=1;
    
   % asdasd=4;
    
    
end

%nHalfSize=(size(mask,1)-1)/2;
%marginImage=createMarginImage(size(maxAngle),nHalfSize);
%maxGradSup(marginImage==1)=0;
%maxGradInf(marginImage==1)=0;
%maxAngle(marginImage==1)=0;



gsImage=zeros(size(ivImage,1),size(ivImage,2),2);
gsImage(:,:,UP)=maxGradSup;
gsImage(:,:,DOWN)=maxGradInf;

angles=maxAngle;

















