# Image-Processing
This repository contains three projects for the Image Processing course I took at the department of computer science at Sharif University of Technology.

- **Image morphing:** Given two images of human faces, morphed images of the two images are computed using Matlab's Delaunay built-in function and image warping in different timestamps to make a smooth video.
Correspoing points of the faces are manully selected using cpselect function. In order to avoid unfilled pixels in the morphed image, backward image warping is used.

- **Image hole filling:** In this project a texture image with a hole is given and the task is to fill the hole using complete patches in the image. The algorithm in each iteration looks for the incomplete patch with the minimum unknown pixels and searches for the closest complete patch in the image using the sum of squares distance to fill the unknown pixels.

# Requirements:
  - All codes were implemented in Matlab 2015b. Higher versions should work too.
