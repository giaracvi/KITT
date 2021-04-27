# KITT
Kermit Image Toolkit (KITT)

This set of folders contain a long list of methods and utilities for image processing, as they have been gathered over the years. All code is distributed as functions, so no runnable code for specific experiments will be included in this project.

Feel free to use any of the code, or to build upon it.

carlos lopez-molina (carlos.lopez@unavarra.es)


## Main information

**What is is, the KITT?** The Kermit Image ToolkiT (KITT) is a collection of code pieces in Matlab aimed at easing Image Processing tasks. The KITT is (as of today) distributed in four different packages, each of them containing different functions in Matlab. Some of these functions implement our own methods, while other embody well-known tasks in literature.

As long as some interdependences exist, we recommend users to download the whole KITT (which is only some KB’s), even if readers shall be interested in just a subset of them.

**How to use the KITT?**  The KITT is very simple to use. Researchers only need to download and unzip the file below (in this same page). Then, they only need to configure Matlab’s path to include the folders of the KITT. This is normally done by using the command path(path,X), where X needs to be replaced by the (local or global) path of the folders in which the KITT has been deployed/unzipped.

**Which is the license of the KITT?** The KITT is distributed under the GNU GPL license. This is individually stated in every single file of the KITT. However, interested researchers must be aware that intellectual rights, as well as rights of many other types, might apply on the algorithms, the names or the code itself. Please be careful with this.

**How to cite or reference the KITT?** If using the KITT, please cite it as

*	KERMIT Research Unit (Ghent University), The Kermit Image Toolkit (KITT), B. De Baets, C. Lopez-Molina (Eds.), Available online at https://github.com/giaracvi/KITT.
	
Additionally, please review the documentation at each of the files to find out the papers that should be cited regarding the authorship of the file.

## Contents (alphabetical order)

*	**Package boundaryImageComparison:**
	*	BDM.m: Baddeley’s Delta Metric for binary images

	*	**boundaryMatching.m**: Boundary matching using different strategies

	*	cosSimilarity.m: Gimenez-Flesia cosine-based similarity for binary images

	*	csaBasedConfusionMatrix.m: Confusion matrix created from the comparison of two binary images. The matching between boundaries is done using UCBerkeley’s implementation of Goldberg and Kennedy’s CSA.

	*	csaBasedConfusionMatrix.m: Confusion matrix created from the comparison of a candidate binary image and several ground truth images. The matching between boundaries is done using UCBerkeley’s implementation of Goldberg and Kennedy’s CSA. The strategy to generate a single confusion matrix from several comparisons is slightly different than that in BSDS (see the comments to the function in the file).

	*	Dk.m: Distance between images, as analyzed in [LopezMolina13b].

	*	ejmBasedConfusionMatrix.m: Confusion matrix created from the comparison of two binary images. The matching between boundaries is done using the Estrada-Jepson algorithm (Int. Journal of Computer Vision, 2009).

	*	estradaJepsonMatching.m: Matching between boundary (binary) images, as presented by Estrada and Jepson (Int. Journal of Computer Vision, 2009).

	*	haralickErrorDistance.m: Distance between binary images, as used by Haralick (TPAMI, 1984).

	*	martinFPR.m: F-measure, Precision and Recall from the comparison of a candidate boundary image with several ground truth one. The strategy followed to produce a singular confusion matrix is that used by Martin in the original BSDS distribution.

	*	prattsFOM.m: Pratt’s Figure of Merit between two boundary images (better, between a candidate and a ground truth images), as presented by Abdou and Pratt.

	*	qTCGT.m: Quantitative error measure between one candidate boundary image and one (or more) ground truth solution. The method is based on the generation of a Twofold Consensus Ground-Truth (TCGT) of the images, as presented by ourselves in [LopezMolina16b].

	*	SDk.m: Symmetric k-powered distance between binary images.

	*	TCGT.m: Twofold consensus ground truth of several binary images, as presented in [LopezMolina16b].
		
*	**Package edgeDetection:**

*		canny.m: Computes gradients in images using Canny (inverted first order Gaussian) filters.

*        directionalNMS.m: Performs non-maxima suppresion (properly, maxima computation) in gradient maps.

*        directionalULED.m: Computes (vector-like) gradients from images using the Upper-Lower edge detector. This is achieved by combining non-rectangular windows and OWA operators, as explained in [LopezMolina12a].

*        diZenzoGradientFusion.m: Fusions multichannel gradient maps into monochannel ones using the method by Di Zenzo. Properly, it collapses down the Jacobian at each pixel to a vector (the resluting gradient).

*        canny.m: Computes gradients in images using Canny (inverted first order Gaussian) filters.

*        doubleRosinUnimodalThr.m: Computes the hysteresis thresholds (originally, to be used in a hysteresis-based binarization process) using the method by Xiangdong, as presented in the IEEE ICIVC-NZ (2013). The method is very similar to a double application of the Rosin method for unimodal thresholding (Pattern Recognition, 2001).

*        drewniokColorGradient.m: Computes gradients in color (3-channeled) images using the method by Drewniok (Int. Journal of Remote Sensing, 1994).

*        FIRE.m: Fuzzy edge detection using Fuzzi Inferente Ruled by Else-action, as proposed by Russo (1995).

*        floodHysteresis.m: Performs non-directional hysteresis using a dual threshold. The term non-directional comes from the fact that the binarization can be propagated to enighbouring pixels even if such propagation is not perpendicular to the gradient orientation. The reason for this is that, although Canny imposed this restriction, it is rather a problem than a solution.

*        gedS.m: Computes gradients at grayscale images using the Gravitational Edge Detection based on a T-conorm S, as presented in [LopezMolina09b].

*        gedT.m: Computes gradients at grayscale images using the Gravitational Edge Detection based on a T-norm T, as presented in [LopezMolina10c].

*        morphologicalTV.m: Computes a scalar estimation of the total variation at each pixel of a grayscale image using morphological operators.

*        multiOrientedCanny.m: Computes gradients in an image using oriented Canny (inverted first order Gaussian) filters. The reason for using more than two filters (vertical, horizontal) is that the discretization of the Gaussian filters prevents them from being steerable, and hence the gradient is (theoretically) better computed by filtering in any possible direction and retaining the magnitude and orientation of the greatest response.

*        rosinUnimodalThr.m: Computes the binarization threshold assuming a dominant, unimodal population in the rightmost part of the histogram.

*        sobel.m: Computes gradients in images using Sobel masks.

*        susan.m: Computes a scalar estimation of the total variation at each pixel using the SUSAN principle (aka the SUSAN method, as presented by Smith in 1990).

*        uled.m: Computes a scalar estimation of the total variation at each pixel using the Upper-Lower Edge Detector (ULED).

*        venkateshRosinThresholding.m: Thresholds a grayscale (also, fuzzy) edge image by evaluating the length and average intensity of each edge segment candidate, as presented by Venkatesh and Rosin (Graphical Models and Image Processing, 1995).
