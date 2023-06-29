# Hybrid Streamflow Modelling using Machine Learning and Multi-Model Combination
**Master thesis Applied Data Science Utrecht University** 

June 2023

This repository contains the code and data for the research study titled "Hybrid Streamflow Modelling using Machine Learning and Multi-Model Combination." 

## Data

The raw and preprocessed input data for the study can be accessed [here](https://doi.org/10.5281/zenodo.8097461). This dataset includes the necessary input variables for the streamflow modelling process.

The training and validation datasets used in the study are available [here](https://doi.org/10.5281/zenodo.8092323). These datasets were used for training and evaluating the models.

## Code

The code in this repository implements Random Forest and Multiple Linear Regression analysis for streamflow modelling. It takes the provided input data and generates the corresponding results.

The R code is structured as follows:
``` bash
├── 1_randomForest
│   ├── 00_RF_tune.Rmd
│   ├── 01_Train_test_RF_MMC.Rmd
│   ├── 03_Train_test_RF__MMC_elbe_maas.Rmd
│   ├── 04_Train_test_rhine_benchmark.Rmd
│   ├── 05_Train_test_elbe_maas_benchmark.Rmd
│   ├── fun_2_1_hyperTuning.R
│   ├── fun_2_2_trainRF.R
│   └── fun_2_3_apply_optimalRF_avg.R
├── 2_multilinearRegression
│   ├── 01_MLR_train_test.Rmd
│   ├── 02_MLR_train_test_one_sample.Rmd
│   ├── MLR_train_test.Rmd
│   ├── fun_apply_MLR.R
│   └── fun_trainMLR.R
└── 3_visualization
    ├── 0_Vis_HyperTuning.Rmd
    ├── 1_VarImportance.Rmd
    ├── 2_Vis_KGE.Rmd
    ├── 3_Vis_KGE_one_sample.Rmd
    ├── 4_Hydrograph_all.Rmd
    ├── 5_Hydrograph_benchmark.Rmd
    ├── fun_3_4_hydrograph_benchmark.R
    └── fun_3_4_hydrograph_fdc_residuals_all.R
```
## Results

The output and results of the Random Forest and Multiple Linear Regression analysis can be found [here](https://doi.org/10.5281/zenodo.8097495). These results showcase the performance and accuracy of the implemented models.

Please refer to the provided DOI links to access the respective data and results.

For any inquiries or issues, please contact the repository owner.

Note: Make sure to properly cite the relevant data sources and this repository if you use the code or data for your own research purposes.

Enjoy exploring the study and experimenting with the code!
