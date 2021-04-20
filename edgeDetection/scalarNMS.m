
function [maxMap,oris] = scalarNMS(ft,sigmas,thetas,rhos)

% Function Scalar Non-Maximum Suppression
%
%  function [maxMap] = scalarNMS(ft)
%  function [ftMap,maxMap] = scalarNMS(ft)
%
%  	Performs NMS on a scalar tone variation map ft. This map is usually
%		referred to as scalar gradient, gradient magnitude, local contrast, etc.
%		
%	In order to perform NMS it considers the maximum fitting of the negated second 
%		derivative of a Gaussian to detect the orientation of the edge segment
%		at each pixel. Once an orientation is computed for each pixel,
%		standard directional NMS is carried out.
%
%   The Gaussian filters used are any possible combination the values in
%       sigmas, thetas and rhos. The is, the number of filters used in the 
%       procedure is card(sigmas)x card(thetas) x card(rhos).%
%       The user can choose to use the default
%       values for those variables by introducing an empty list [].
%
% [Inputs]
%   ft(mandatory)- Scalar (non-binary) edge map. Must contain positive values only.
%   sigmas(mandatory)- Standard deviations used in the filtering process.
%       If left empty ([]), the values will be [1:4].
%   thetas(mandatory)- Orientations of the filter. They should cover the
%       range [0,pi[. If left empty, the values will be [0:9].*(pi/10).
%   rhos(mandatory)- Anisotropy indices used in the filters. 1 stands for
%       isotropy, while values below 1 produce elongated filters.
%
% [outputs]
%   maxMap- Binary map with the maxima pixels.
%   ftMap- Version of ft at which the non-maxima pixels 
%		have been removed (set to 0).
%
% [usages]
%
% [note]
%
% [dependencies]
%   function createGaussianFilter
%   function directional NMS
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
%
% [references]
%


%
%	0- Validate Arguments 
%
assert(nargin>=1,'Error at scalarNMS: Wrong number of arguments.');
assert(nargin<=4,'Error at scalarNMS: Wrong number of arguments.');
assert(min(ft(:))>=0,'Error at scalarNMS: The map ft contains negative values.');

%
%	1- Preprocessing
%
if (nargin<4)
	rhos=[1];
end
if (nargin<3)
	thetas=[0:9].*(pi/10);
end
if (nargin<2)
	sigmas=[1 2 3 4 5 6 8 10];
end


%
%	2- Processing
%
maxFit=ones(size(ft)).*(-inf);
oris=zeros(size(ft));

for idxTheta=1:length(thetas);
    
    params.theta=thetas(idxTheta);
    
    for idxRho=1:length(rhos);
        
        params.rho=rhos(idxRho);
        
        for idxSigma=1:length(sigmas);
            
            filter=createGaussianFilter('2d',sigmas(idxSigma),params);
            matchMap=imfilter(ft,-filter,'replicate');
            oris(matchMap>maxFit)=thetas(idxTheta);
            maxFit=max(maxFit,matchMap);
            
        end
    end
end

fx=ft.*cos(oris);
fy=ft.*sin(oris);



%
%	3- Final procedures
%

maxMap=directionalNMS(fx,fy);





