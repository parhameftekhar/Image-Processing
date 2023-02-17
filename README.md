# Image-Processing course

# Project1:

- **Image morphing:** Given two images of human faces, morphed images of the two images are computed using Matlab's Delaunay built-in function and image warping in different timestamps to make a smooth video.
Correspoing points of the faces are manully selected using cpselect function. In order to avoid unfilled pixels in the morphed image, backward image warping is used.

[Image Warping and Morphing](https://groups.csail.mit.edu/graphics/classes/CompPhoto06/html/lecturenotes/14_WarpMorph.pdf)


![ezgif com-gif-maker](https://user-images.githubusercontent.com/70694845/215874195-7da7ae65-6760-45f9-b4e0-c89901f123c4.gif)

# Project2:
- **Image hole filling:** In this project a texture image with a hole is given and the task is to fill the hole using complete patches in the image. The algorithm in each iteration looks for the incomplete patch with the minimum unknown pixels and searches for the closest complete patch in the image using the sum of squares distance to fill the unknown pixels.

[Texture Synthesis by Non-parametric Sampling](https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/papers/efros-iccv99.pdf)

![alt text](https://github.com/parhameftekhar/Image-Processing/blob/main/Image%20hole%20filling/sea.jpg)

![alt text](https://github.com/parhameftekhar/Image-Processing/blob/main/Image%20hole%20filling/result.jpg)

# Project3:
- **Active contours:** Given an image with an object of interest. Active contour model is perfomed to segment the boundery of the object. The energy function consists of two energies, internal and external energies. The internal energy is related to the shape of the object and formulates the elasticity and curvature of the shape. On the other hand, the external energy is related to image structure i.e. edges, lines.

[Using Dynamic Programming For Minimizing The Energy Of Active Contours In The Presence Of Hard Constraints](https://pages.github.com/)


![ezgif com-gif-maker (1)](https://user-images.githubusercontent.com/70694845/215885259-c44fe879-22ee-4140-aa15-82ad12098281.gif)



# Requirements:
  - All codes were implemented in Matlab 2015b. Higher versions should work too.
