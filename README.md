# 3D-Reconstruction-with-Plane-Homography-Constraint
3D Reconstruction and Plane Segmentation under Manhattan World Assumption, which consists of three main orthogonal planes.
Given two image from different perspective, without any calibation parameter, reconstruct the scene up to scale.

## Pipiline
![Reconstruction Pipeline](/images/demo/3D_reconstruction.jpg)

## Sample Results
<img src="https://github.com/fei123ilike/3D-Reconstruction-with-Plane-Homography-Constraint/tree/master/images/input/1_001.jpg" width=425/> <img src="https://github.com/fei123ilike/3D-Reconstruction-with-Plane-Homography-Constraint/tree/master/images/input/1_002.jpg" width=425/> 

![Reconstruction Results](/images/demo/demo.gif)

## How to Run
### Prerequisites
MATLAB 2018 or Higher
### 3D reconstruction
Run
./code/test3DReconstruction.m

### Vanishing Points Detection and adjustment
Run
./code/testVP.m

