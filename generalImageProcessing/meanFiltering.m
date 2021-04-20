function filteredIm = meanFiltering(im,wSize)

% Function Mean Filtering
%
%  [filteredIm] = meanFiltering(im,wSize)
%
%  Produces the mean-filtered image using a window of size
%	wSize centered at each pixel. The size can be expressed as
%	an scalar (then the window is squared) or as a vector with
%	two dimensions.
%
%  This function only applies to scalar-valued images. We refer
%	to Vector Order Statistics (VOS) for its portability to 
%	vector-valued images.
%
%
% [Inputs]
%   im(mandatory)- Original image. It can contain any number of
%		channels composed of either doubles in [0,1] or integers
%		in {0,...,255}.
%   wSize(mandatory)- Size of the window. It can be a scalar or 
%		a vector including the number of rows and columns.
%
% [outputs]
%   filteredIm- Resulting image, with the same size and format as the
%		original image.
%
% [usages]
%
% [note]
%
% [dependencies]
%
% [author]
%   Carlos Lopez-Molina (carlos.lopez@unavarra.es)
%
% [references]
%
%

%
%	0- Validate Arguments 
%
assert(nargin==2,'Error at meanFiltering.m>\tWrong number of arguments.');
assert(min(min(im))>=0,'Error at meanFiltering.m>\tThe image contains negative values.');
assert(length(wSize)<=2,'Error at meanFiltering.m>\tInvalid wSize.');
if length(wSize)==1
    assert(mod(wSize,2)==1,'Error at meanFiltering.m>\tInvalid wSize.');
else
    assert(min(mod(wSize,2))==1,'Error at meanFiltering.m>\tInvalid wSize.');
end
    

%
%	1- Preprocessing
%
if length(wSize)==1
	mask=ones(wSize)./(wSize*wSize);
else
	mask=ones(wSize)./(wSize(1)*wSize(2));
end

if (max(im(:))>1.001)
	mode='INT255';
	im=double(im)./255;
else
	mode='FLT01';
end

%
%	2- Processing
%
for idChannel=1:size(im,3)
    filteredIm(:,:,idChannel)=imfilter(im(:,:,idChannel),mask,'replicate');
end


%
%	3- Output formatting
%

if (strcmp(mode,'INT255'))
	filteredIm=round(filteredIm.*255);
end



