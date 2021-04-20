
function matSpectra=hs2mat(spectra,maxVal)

% Function Hyperspectrum to Matrix
%
%  function [dirMap] = hs2mat(spectra,maxVal)
%
%  Transforms the hyperspectrum to a discrete matrix. Otherwise said,
%	it converts it into an image in which
%		a) The number of rows is the number of wavelengths in the hyperspectrum
%		b) The number of columns is maxVal
%		c) there is 1's representing the discrete values of the hyperspectrum.
%
% [Inputs]
%   spectra(mandatory)- Original Hyperspectrum
%   maxVal(mandatory)- Number of discrete energy values
%
% [outputs]
%   matSpectra- Image (also, binary matrix) representation of the hyperspectrum.
%   out2-
%
% [usages]
%	matSpectra=hs2mat(spectra,200)
%
% [dependencies]
%	none
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

if (max(spectra(:))<=1)
    spectraB=round(spectra.*maxVal);
end

matSpectra=zeros(maxVal+1,length(spectra));

for idxSignalPoint=1:length(spectra)
    matSpectra(spectraB(idxSignalPoint)+1,idxSignalPoint)=1;
end