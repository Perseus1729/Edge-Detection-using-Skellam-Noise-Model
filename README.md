# 754 PROJECT

```
Edge Detection using Skellam distribution as a sensornoise model
```
```
Hitesh Kumar Punna, Sudhansh Peddabomma
```

## Instructions

There are 2 folders in the compressed submission.
● Edge Detection

1. _Skellam.m_ is the main file which is needed to runto generate the results.
2. _Test.m_ and _Patches.m_ are used for Designing/ Constructingthe synthetic Image data set. The
    results are stored in the Tests and Patches folderrespectively.
3. _Trans.m_ is a function file used for calculating confidenceintervals.
4. _Pmf.m_ is a function file used for calculating pmfof the Skellam distribution.
5. Output Graphs and Images are added in the _Results_ folder.
● Background Subtraction
This folder has a similar structure as above and itperforms Background Subtraction. Run _Skellam.m_ to
obtain the results for a synthetically generated image(generated by this file itself).

## Intuition behind the Skellam distribution

```
We plot the histogram of the intensities of an imageand the histogram of difference of intensities ofan
image. Notice that the former histogram is randombut the latter seems to follow a specific distribution.As
we shall see, this is the Skellam distribution.
Note. We see a sudden rise in the first histogramat high intensity. This is because the image has poisson
noise over an image with random uniform patches. Thisnoise saturates at 255 and thus causes the peak.
```

## Dataset

We compiled asynthetic datasetand generated trainingimages by adding **Poissonnoise** to an image with
homogenous patches. We used “.tiff” and “.png” imagesas they utilise lossless compression algorithms.
Other typical formats like “.jpeg” use DCT coefficientsto compress the image and we lose the hypothesisof
Poisson noise followed by intensities.

The following images are examples of the picturesgenerated by our code. We used the left image to

### calculate ofμand. These values areused to estimate the Skellam parameters.

```
𝑠
σ𝑠
```
### The right image is used for edge detection viaμand values derived from the training data set.

```
𝑠
σ𝑠
```
Training images can be generated via _patch_generator.m_ and the Testing images can be generated via
_test.m_.
_Note._ As the gain parameter does not change becauseof addition of Poisson noise to homogenous uniform
patches, both the images have the same Skellam parametersfor a given intensity.

Use _patch_generator.m_ to generate images on the left.
Use _test.m_ to generate images on the right.
_Skellam.m_ generates the images by itself, or you canmanually add the images.

## Validation of Skellam distribution

As done in the Research paper we foundμ𝑠andσ𝑠by taking homogenous patches in the image.

The following are the distribution for _differencevalues_ in a particular path for different colors.They
approximately represent a Skellam distribution.


```
Color Red Color Green
```
```
Color blue Combined Histogram
```
## Disparity Plots

The Plots obtained by varying (dx, dy) to calculatethe Skellam parameters. As we can see, the linesare
almost horizontal. This means that the Skellam parametersare independent of dx and dy.


## Skellam Parameters and Mean fit (Intensity - Skellamline)

We obtain the Skellam Parametersμ 1 andμ 2 via mean of the patch. Notice that there are outlierswhen the

mean intensity is high, this is because of saturationof intensity values.

This data helps us to validate the idea of Skellamdistribution for image noise.


## Acceptance Region

We find the confidence intervals defined by a parameterαfor each intensity value in the image.

We show the confidence intervals for each intensityvalue in the above figure. Notice the clipping at
intensity 255.

## Edge Detection

The confidence intervals are used as a thresholdto remove the non edged pixels. We find the confidence
intervals via the PMF of the Skellam distributionas estimated by the intensity of the particular pixel.We
also use non-maximum suppression to reduce false positivesand makes the process robust.
The images after removing the non edged pixels looklike :

```
With Confidence Interval With Non MaximumSuppression
```
For comparison, this is how Canny edge detection looksfor the above image. Canny Edge Detection has a
rounding effect near the corners because of GaussianBlurring. Also, the internal edges inside the filled
polygons of the grid are not detected by this method.Edge Detection via Skellam noise modelling is ableto
outperform Canny algorithm as it is taking advantageof the noise distribution.


```
Low Threshold High Threshold
```
## More Results

Original Image:-

Edge Detection via Image generated using ConfidenceIntervals:-


2.Images after Non-Maximum Suppression will look likethe following

3.The canny results for above image on using low andhigh threshold will look like:-

```
Low Threshold High Threshold
```

## Observations

1. As we go towards high Intensity the poisson distributionsaturates the intensity value (The pixel
    intensity cannot go beyond 255 for 8-bit images) andlinear fit is not suitable in such scenarios.
2. Corners are detected with better accuracy. This isbecause Canny edge detection uses Gaussian
    Blurring and that distorts the corners.
3. Canny edge detection fails to give good results inmany scenarios. The following are the drawbacks
    of the Canny edge detector, when compared with SkellamNoise modelling.
       a. Some edges are missing
       b. Intersecting edges are not getting shown
       c. Edge detection is very noisy
4. Canny edge detection is mainly used for grayscaleimages whereas our method works for color
    images.

As an extension to the above ideas, we apply thismethodology for Background Subtraction as mentioned
in the next section.


## Background Subtraction

We can make us of the noise modelling and performBackground Subtraction in images. The intuition is
quite similar and the results are given below.

```
Original Image Image with an Object
```
```
Image with Background removed
```
The above image represents the background image mask.As we can see, the result is quite fantastic.


