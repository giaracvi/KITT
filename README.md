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
	*	**BDM.m**: Baddeley’s Delta Metric for binary images

	*	**boundaryMatching.m**: Boundary matching using different strategies

	*	**cosSimilarity.m**: Gimenez-Flesia cosine-based similarity for binary images

	*	**csaBasedConfusionMatrix.m**: Confusion matrix created from the comparison of two binary images. The matching between boundaries is done using UCBerkeley’s implementation of Goldberg and Kennedy’s CSA.

	*	**csaBasedConfusionMatrix.m**: Confusion matrix created from the comparison of a candidate binary image and several ground truth images. The matching between boundaries is done using UCBerkeley’s implementation of Goldberg and Kennedy’s CSA. The strategy to generate a single confusion matrix from several comparisons is slightly different than that in BSDS (see the comments to the function in the file).

	*	**Dk.m**: Distance between images, as analyzed in [LopezMolina13b].

	*	**ejmBasedConfusionMatrix.m**: Confusion matrix created from the comparison of two binary images. The matching between boundaries is done using the Estrada-Jepson algorithm (Int. Journal of Computer Vision, 2009).

	*	**estradaJepsonMatching.m**: Matching between boundary (binary) images, as presented by Estrada and Jepson (Int. Journal of Computer Vision, 2009).

	*	**haralickErrorDistance.m**: Distance between binary images, as used by Haralick (TPAMI, 1984).

	*	**martinFPR.m**: F-measure, Precision and Recall from the comparison of a candidate boundary image with several ground truth one. The strategy followed to produce a singular confusion matrix is that used by Martin in the original BSDS distribution.

	*	**prattsFOM.m**: Pratt’s Figure of Merit between two boundary images (better, between a candidate and a ground truth images), as presented by Abdou and Pratt.

	*	**qTCGT.m**: Quantitative error measure between one candidate boundary image and one (or more) ground truth solution. The method is based on the generation of a Twofold Consensus Ground-Truth (TCGT) of the images, as presented by ourselves in [LopezMolina16b].

	*	**SDk.m**: Symmetric k-powered distance between binary images.

	*	**TCGT.m**: Twofold consensus ground truth of several binary images, as presented in [LopezMolina16b].
		
		
*	**Package edgeDetection:**

	*	**canny.m**: Computes gradients in images using Canny (inverted first order Gaussian) filters.

	*	**directionalNMS.m**: Performs non-maxima suppresion (properly, maxima computation) in gradient maps.

	*	**directionalULED.m**: Computes (vector-like) gradients from images using the Upper-Lower edge detector. This is achieved by combining non-rectangular windows and OWA operators, as explained in [LopezMolina12a].

	*	**diZenzoGradientFusion.m**: Fusions multichannel gradient maps into monochannel ones using the method by Di Zenzo. Properly, it collapses down the Jacobian at each pixel to a vector (the resluting gradient).

	*	**canny.m**: Computes gradients in images using Canny (inverted first order Gaussian) filters.

	*	**doubleRosinUnimodalThr.m**: Computes the hysteresis thresholds (originally, to be used in a hysteresis-based binarization process) using the method by Xiangdong, as presented in the IEEE ICIVC-NZ (2013). The method is very similar to a double application of the Rosin method for unimodal thresholding (Pattern Recognition, 2001).

	*	**drewniokColorGradient.m**: Computes gradients in color (3-channeled) images using the method by Drewniok (Int. Journal of Remote Sensing, 1994).

	*	**FIRE.m**: Fuzzy edge detection using Fuzzi Inferente Ruled by Else-action, as proposed by Russo (1995).

	*	**floodHysteresis.m**: Performs non-directional hysteresis using a dual threshold. The term non-directional comes from the fact that the binarization can be propagated to enighbouring pixels even if such propagation is not perpendicular to the gradient orientation. The reason for this is that, although Canny imposed this restriction, it is rather a problem than a solution.

	*	**gedS.m**: Computes gradients at grayscale images using the Gravitational Edge Detection based on a T-conorm S, as presented in [LopezMolina09b].

	*	**gedT.m**: Computes gradients at grayscale images using the Gravitational Edge Detection based on a T-norm T, as presented in [LopezMolina10c].

	*	**morphologicalTV.m**: Computes a scalar estimation of the total variation at each pixel of a grayscale image using morphological operators.

	*	**multiOrientedCanny.m**: Computes gradients in an image using oriented Canny (inverted first order Gaussian) filters. The reason for using more than two filters (vertical, horizontal) is that the discretization of the Gaussian filters prevents them from being steerable, and hence the gradient is (theoretically) better computed by filtering in any possible direction and retaining the magnitude and orientation of the greatest response.

	*	**rosinUnimodalThr.m**: Computes the binarization threshold assuming a dominant, unimodal population in the rightmost part of the histogram.

	*	**sobel.m**: Computes gradients in images using Sobel masks.

	*	**susan.m**: Computes a scalar estimation of the total variation at each pixel using the SUSAN principle (aka the SUSAN method, as presented by Smith in 1990).

	*	**uled.m**: Computes a scalar estimation of the total variation at each pixel using the Upper-Lower Edge Detector (ULED).

	*	**venkateshRosinThresholding.m**: Thresholds a grayscale (also, fuzzy) edge image by evaluating the length and average intensity of each edge segment candidate, as presented by Venkatesh and Rosin (Graphical Models and Image Processing, 1995).

## Publications


*	**2018**
	*	**[LopezMaestresalas18a]**– A. Lopez-Maestresalas, L. De Miguel, C. Lopez-Molina, S. Arazuri, H. Bustince and C. Jarén, “Hyperspectral imaging using notions from Type-2 Fuzzy Sets”, Soft Computing, in press (2018). ([Link](https://www.springerprofessional.de/en/hyperspectral-imaging-using-notions-from-type-2-fuzzy-sets/15722962))
		
	*	**[LopezMolina18a]**– C. Lopez-Molina, J. Montero, H. Bustince and B. De Baets, “Self-adapting weighted operators for multiscale gradient fusion”, Information Fusion, in press (2018). ([Link](https://www.sciencedirect.com/science/article/pii/S1566253517304736))


*	**2017**

    *	**[LopezMaestresalas17a]**– A. Lopez-Maestresalas, C. Lopez-Molina, C. Perez-Roncal, S. Arazuri, H. Bustince and C. Jarén, “Fuzzy edge detection on hyperspectral images using Upper and Lower operators”,  presented at the conference of the European Society for Fuzzy Logic and Technology (Eusflat), Warsaw (Poland), 2017. ([Link](https://link.springer.com/book/10.1007%2F978-3-319-66824-6))
		
    *	**[LopezMolina17a]**– C. Lopez-Molina, D. Ayala-Martini, A. Lopez-Maestresalas and H. Bustince, “Baddeley’s Delta metric for local contrast computation in hyperspectral imagery”, Progress in Artificial Intelligence, 1-12 (2017). ([Link](http://link.springer.com/article/10.1007/s13748-017-0111-y))

    *	**[LopezMolina17b]**– C. Lopez-Molina, “Ambiguity and Hesitancy in Quality Assesment: The case of Image segmentation”, plenary talk at the Symposia on Mathematical Techniques Applied to Data Analysis and Processing (SMATAD), Fuengirola (Spain), 2017. ([Link]())

    *	**[LopezMolina17c]**– C. Lopez-Molina, C. Marco-Detchart, H. Bustince, J. Fernandez, A. Lopez-Maestresalas and D. Ayala-Martini, “Hyperspectrum comparison using similarity measures”, presented at the conference of the International Fuzzy Set Association (IFSA), Otsu (Pref. Shiga, Japan), 2017. ([Link]())

    *	**[LopezMolina17d]**– C. Lopez-Molina, J. Montero, H. Bustince and B. De Baets, “Gradient fusion operators for image processing”,  presented at the conference of the European Society for Fuzzy Logic and Technology (Eusflat), Warsaw (Poland), 2017. ([Link]())
	
    *	**[Madrid17a]**– N. Madrid and C. Lopez-Molina, “Scale-Space defined from Image Fuzzy Sharpening”, Presented at the conference of the International Fuzzy Set Association (IFSA), Otsu (Pref. Shiga, Japan), 2017. ([Link]())


*	**2016**

	*	**[LopezMolina16a]**– C. Lopez-Molina, H. Bustince and B. De Baets, “Separability criteria for the evaluation of boundary detection benchmarks”, IEEE Trans. on Image Processing, 25 (3), 1047-1055 (2016). ([Link]())

    *	**[LopezMolina16b]**– C. Lopez-Molina, B. De Baets, H. Bustince, “Twofold consensus for boundary detection ground truth”, Knowledge-Based Systems, 98, 162-171 (2016). ([Link]())

    *	**[LopezMolina16c]**– C. Lopez-Molina, C. Marco-Detchart, L. De Miguel, H. Bustince, J. Fernandez, B. De Baets, “A bilateral schema for interval-valued image differentiation”, Presented at the WCCI/Fuzz’IEEE 2016 conference, Vancouver (BC, Canada). ([Link]())

    *	**[LopezMolina16d]**– C. Lopez-Molina, “Evaluación de Técnicas de Segmentación de Imágenes”, seminar at the Universidad Complutense de Madrid (Spain), May 2016. ([Link]())

    *	**[LopezMolina16e]**– C. Lopez-Molina, “Beyond Pixels: When Visual Information Escapes the Matrix”, plenary talk at the International Symposium on Aggregation of Structures (ISAS’16), Luxemboug (G.D. of Luxembourg), 2016. ([Link]())

    *	**[Wang16]**– G. Wang, C. Lopez-Molina, B. De Baets, “Blob Noise Reduction using Unilateral Second Order Gaussian Kernels and the Non-local Means Algorithm”, Proc. of the Second International Conference on Intelligent Decision science (IDS-2016), Dubai (UAE), 2016. ([Link]())


*	**2015**

	*	**[LopezMolina15]**– C. Lopez-Molina, G. Vidal-Diez de Ulzurrun, J.M. Baetens, J. Van den Bulcke, B. De Baets, “Unsupervised ridge detection using second order anisotropic Gaussian kernels, Signal Processing, 116, 55–67 (2015). ([Link]())

	*	**[LopezMolina15b]**– C. Lopez-Molina, C. Marco-Detchart, J. Cerron, H. Bustince and B. De Baets, “Gradient extraction operators for discrete interval-valued data”, in Proc. of the IFSA-Eusflat 2015 Conference. ([Link]())

    *	**[VidalDiezDeUlzurrun15]**– G. Vidal-Diez de Ulzurrun, J.M. Baetens, J. Van den Bulcke, C. Lopez-Molina, I. De Windt, B. De Baets, “Automated image-based analysis of spatio-temporal fungal dynamics”, Fungal Genetics and Biology, 84, 12-25 (2015) ([Link]())


*	**[2014]**

    *	**[Guerra14]**– C. Guerra, A. Jurio, H. Bustince, C. Lopez-Molina, “Multichannel generalization of the Upper-Lower Edge Detector using ordered weighted averaging operators”, Journal of Intelligent and Fuzzy Systems, 27, 1433-1443 (2014). ([Link]())

    *	**[LopezMolina14a]**– C. Lopez-Molina, M. Galar, H. Bustince, B. De Baets, “On the impact of anisotropic diffusion on edge detection”, Pattern Recognition, 47, 270-281 (2014). ([Link]())

    *	**[LopezMolina14b]**– C. Lopez-Molina, M. Galar, H. Bustince, B. De Baets, “A framework for edge detection based on relief functions”, Information Sciences, 278, 127-140 (2014). ([Link]())


*	**[2013]**

    *	**[LopezMolina13a]**– C. Lopez-Molina, B. De Baets, M. Galar, and Bustince, “A generalization of the Perona-Malik anisotropic diffusion method using restricted dissimilarity functions” International Journal of Computational Intelligent Systems, 6, 14-28 (2013). ([Link]())

    *	**[LopezMolina13b]**– C. Lopez-Molina, H. Bustince, B. De Baets, “Quantitative error measures for edge detection”, Pattern Recognition 46 (4), 1125–1139 (2013). ([Link]())

    *	**[LopezMolina13c]**– C. Lopez-Molina, B. De Baets, H. Bustince, J. Sanz and E. Barrenechea, “Multiscale Edge Detection Based on Gaussian Smoothing and Edge Tracking”, Knowledge-based Systems, 44 101-111, (2013). ([Link]())

    *	**[LopezMolina13e]**– C. Lopez-Molina, H. Barrenechea, H. Bustince and B. De Baets, “Multichannel gradient fusion based on ordered weighted aggregation operators” in Proc. of the Eurofuse Workshop, 2013. ([Link]())


*	**[2012]**

    *	**[LopezMolina12]**– C. Lopez-Molina, M. Galar, H. Bustince, B. De Baets, “Extending the upper-lower edge detector by means of directional masks and OWA operators”, Progress in Artificial Intelligence, 1, 267-276 (2012). ([Link]())


*	**[2011]**

    *	**[Barrenechea11]**– E. Barrenechea, H. Bustince, B. De Baets, and C. Lopez-Molina, “Construction of Interval-valued Fuzzy Relations With Application to the Generation of Fuzzy Edge Images”, IEEE Trans. on Fuzzy Systems, 19, 819-830 (2011);

    *	**[LopezMolina11a]**– C. Lopez-Molina, B. De Baets, and H. Bustince, “Generating fuzzy edge images from gradient magnitudes”, Computer Vision and Image Understanding, 115, 1571-1580 (2011);

    *	**[LopezMolina11b]**– C. Lopez-Molina, H. Bustince, J. Fernandez, and B. De Baets, “Generation of fuzzy edge images using trapezoidal membership functions”, in Proc. of the Conf. of the European Society of Fuzzy Logic and Technology (EUSFLAT), 2011, 327-333. ([Link]())

    *	**[LopezMolina11c]**–  C. Lopez-Molina, H. Bustince, E. Barrenechea, A. Jurio and B. De Baets, “Multiscale edge detection based on the Sobel method” , In Proc. of the International Systems Design and Application (ISDA) conference, Cordoba (Spain), (2011). ([Link]())

    *	**[LopezMolina11d]**–  C. Lopez-Molina, B. De Baets, H. Bustince, E. Barrenechea, and M. Galar, “Multiscale extension of the gravitational approach to edge detection”, Lecture Notes in Computer Science, 7023 LNCS 283-292 (2011). ([Link]())

    *	**[LopezMolina11e]**–C.  Lopez-Molina, B. De Baets; E. Barrenechea and H. Bustince, “Edge Detection on Interval-Valued Images”, in Advances in Intelligent and Soft Computing, Springer Berlin, 2011, 107, 325-337. ([Link]())


*	**[2010]**

    *	**[LopezMolina10a]**– C. Lopez-Molina, H. Bustince, B. De Baets, “On the parameterization of Baddeley’s error metric”, in Proc. of the Internation Student Conf. on Applied Mathematics and Informatics (ISCAMI), 2010. ([Link]())
	
    *	**[LopezMolina10b]**– C. Lopez-Molina, J. Fernandez,  A. Jurio, M. Galar, M. Pagola, M. and B. De Baets, “On the Use of Quasi-arithmetic Means for the Generation of Edge Detection Blending Functions” in  Proc. of the IEEE International Conf. on Fuzzy Systems, 2010, 2462-2469. ([Link]())

    *	**[LopezMolina10c]**– C. Lopez-Molina, H. Bustince, J. Fernandez, P. Couto, B. De Baets, “A gravitational approach to edge detection based on triangular norms”. Pattern Recognition 43(11), 3730–3741 (2010). ([Link]())


*	**[2009]**

    *	**[LopezMolina09a]**– C. Lopez-Molina, H. Bustince, J. Fernández, E. Barrenechea, P. Couto, and B. De Baets, “A t-Norm Based Approach to Edge Detection”, Lecture Notes in Computer Science, 5517 LNCS (1) 302-309; ([Link]())

    *	**[LopezMolina09b]**– C. Lopez-Molina, H. Bustince, H.; M. Galar, J. Fernández and B. De Baets, “On the use of t-conorms in the gravity-based approach to edge detection”, in Proc. of the International Conf. on Intelligent Systems Design and Applications (ISDA), 2009, 1347-1352. ([Link]())
