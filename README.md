# Content

The following code snippets provide a solution for incorporating DTI tracts into skeletal muscle models using MATLAB within the FEBIO software environment.

One of the challenges faced in most finite element analysis (FEA) muscle models was the lack of realistic muscle fiber direction, primarily due to the difficulty of integrating muscle fiber data from MR imaging techniques like DTI into the muscle models. These scripts aim to address this issue by facilitating the incorporation of DTI data into the muscle models.

The main concept behind these scripts is to assign a fiber direction to each element of the mesh based on the DTI data. This is achieved by employing the KNN (k-nearest neighbors) algorithm to identify the most suitable match from the DTI tracts for each element.

Here is a brief overview of the included files in the folder and their respective purposes:

1. `febio_to_elem_coords.m`: This script generates a script that extracts element data from FEBIO format files.
2. `find_directions_for_elements.m`: This script is of utmost importance as it assigns muscle fiber directions to each element.
3. `readFEBIOText.m`: This function is developed to read FEBIO script contents and extract relevant element data from it.
4. `readmrtrix_tracts.m`: This automated script reads fiber tracts from the MRtrix environment into MATLAB. MRtrix is utilized for generating fiber tracts.
5. `tracts_to_direction.m`: DTI tractography data typically contains dominant eigen vector values for each pixel. This script utilizes that information to assign a direction to each tract, which is subsequently assigned to an element in the subsequent step.

These scripts collectively enable the integration of DTI tracts into skeletal muscle models, improving the realism and accuracy of the fiber direction representation within the models.
