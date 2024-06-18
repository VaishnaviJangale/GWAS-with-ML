# GWAS-with-ML
This GitHub repository provides a code of the research paper titled "Enhancing genotype-phenotype association with optimized machine learning and biological enrichment methods". 

## **Table of Contents:**
* [Getting started](#Getting-started) 
* [Users guide](#Users-guide)
* [QC script](#QC-script)
* [Machine learning model file](#Machine-learning-model-file)
   * [Feature selection of data](#Feature-selection-of-data)
   * [Association analysis SNPs](#Association-analysis-SNPs)
   * [SNP enrichment of selected SNP](#SNP-enrichment-of-selected-SNP)
  

### Getting started
### Users guide 
This GitHub repository provides an overview of the GenomeIndia project focused on Genome Wide Association Studies (GWAS). The proposed pipeline replaced stringent p-value threshold problem, take into account SNP-SNP interaction, and also address the problem of "Curse of dimensionality". By incorporationg machine learning in the pipeline enhances statistical power of GWAS. The pipeline comprises steps for Quality Control of GWAS data using the Plink2.0, machine learning models for feature selection, association analysis and SNP enrichment of selected SNPs. The input file for pipeline is  `.bed` `.bim` and `.fam` and output file after doing SNP enrichment is `.csv` of selected SNPs. For further validation of feature selection method, we have used linear regression model on data after qc.

**Data availability**: The PennCATH cohort study is available at [PennCATH dataset](https://pbreheny.github.io/adv-gwas-tutorial/quality_control.html) or could be dowloaded from
(https://d1ypx1ckp5bo16.cloudfront.net/penncath/penncath.zip).


### QC script 
Quality Control is the most crucial step for GWAS. Here, we had performed QC using Plink2.0, a widely used tool for GWAS data preprocessing. Input data has 861,473 SNPs and 1401 samples. The QC process includes steps such as SNP call rate, Sample call rate, Minor Allele Frequency (MAF), Hardy-Weinberg equilibrium (HWE), LD pruning, Heterozygosity, and Relatedness. After quality control, samples with null phenotype values are properly excluded or removed. So finally the samples remained are 1201 and SNPs are 69,902. 

```bash
bash GI_plinkscript.sh
```

### Machine learning model file 
Machine learning models are employed for feature selection to identify the most relevant genetic variants for the subsequent association analysis and most associated features are then used for SNP enrichment with the help of pybiomart and some additional tools can be used like GRASP, gprofiler, fumaGWAS etc. Pyhton script for feature selection, association of SNPs and SNP enrichment is given below:

```
python GI_Final_script.ipynb
```

#### Feature selection of data 
We had performed hyperparameter tuning in such a way that nearly 5000 SNPs should be selected. ML models are used to perform feature selections are LASSO, Ridge, Elastic-net, and Mutual information. 
- **LASSO**: LASSO is a L1 regularization technique that uses the shrinkage method to make less important features's coefficient zero. Here we have used the value of alpha 0.00045. SNPs selected are 5003.
- **Ridge**: Ridge regression is majorly used for multicollinear data. This method doesn't shrink the coefficient of the feature to zero. It used L2 penalty. According to the coefficients give by L2 we have selected top 5000 SNPs.
- **Elastic-Net**: A hybrid of LASSO and Ridge, providing a compromise between the two regularization methods. Here 0.5 L1 ratio is used and value of alpha is 0.0033. SNPs selected are 5037.
- **Mutual Information**: A statistical measure capturing the dependency between random variables, helping identify informative features. From this method, the top 5000 features are selected to proceed to the association analysis phase

#### Association analysis SNPs 
To check most associated SNPs among all feature selection method, we have applied ML models like Linear Regression, Random Forest, and Support Vector Regressor. Special criterias were applied for each association method like p-value, recursive feature elimination and permutation score method respectively. 
- **Linear Regression**: A basic method to model the linear relationship between features and traits. After run linear regression model on 5037 SNP selected from Elastic-net we have calculated their p-value and to select significant SNPs, p-value threshold of 5e-03 is used. From this 252 SNPs are selected. To know the biological importance of significant SNPs we have used GRASP tool to check p-value of SNPs according to literature. It is seen that highest p-value obtained is 3.6e-80. 
- **Random Forest (RF)**: A versatile ensemble method utilizing decision trees for complex associations. Thresholds used for this methods are: The number of trees in the forest (n_estimators) is 100, The function to measure the quality of a split (criterion) is 'squared_error', The maximum depth of the tree (max_depth) is 20. After that RFE is used to select top 100 important SNPs.
- **Support Vector Regressor (SVR)**: A supervised learning model that identifies relationships between variables. Threshold used for diiferent parameters are:  kernel = 'sigmoid' , Regularization parameter (C) is 100, Epsilon is 0.01 which specifies epsilon-tube within which no penalty is associated in the training loss function with points predicted within a distance epsilon from the actual value, Kernel coefficient for sigmoid (gamma) is scale.  After that permutation importance score is used to select top 100 important SNPs.
- **XGBoost** : XGBoost is a proficient machine learning method with great efficiency and predicted accuracy. It is a tree-boosting methodology,which sequentially creates an ensemble of decision trees to correct errors from previous trees, making it highly successful for a wide range of predictive modelling problems.

#### SNP enrichment of selected SNP 
Post-GWAS analysis of top 100 SNPs identified using PennCATH-real dataset. 

**Imputed data with Impute5 python script**:

Processed imputed data (Impute5) can be downloaded from: 

https://iitjacin-my.sharepoint.com/:f:/g/personal/sharma_51_iitj_ac_in/EiMvKmp77eVAsZLzViyxs5sB2GVR7j5TyOIfh68PQJBm5A?e=DGtMyQ
```
Imputed_data_pyscript.ipynb
```
**Imputed data with Beagle5.4 python script**:

Processed imputed data (Beagle5.4) can be downloaded from: 

https://iitjacin-my.sharepoint.com/:f:/g/personal/sharma_51_iitj_ac_in/EkfZW7PM5SlOgtLP_NIWqOQBAqjiX0FiZNusrzCivR5pig?e=MCJ3wg

```
Imputed_data_pyscript.ipynb
```
**Rare variants python script**:

Processed Rare-variants data can be downloaded from: 

https://iitjacin-my.sharepoint.com/:f:/g/personal/sharma_51_iitj_ac_in/EqqZSLR8OYJGoeCHE6Rsma8BTdjq20ZviLRmpBvzlsQB7A?e=JUGWof

```
Rare_variants.ipynb
```
**Simulated dataset python script**:

Processed simulated data can be downloaded from: 

https://iitjacin-my.sharepoint.com/:f:/g/personal/sharma_51_iitj_ac_in/Ek1cBIWb3G9Gvc99ti7OV8kBBFWud1agdYhBOhcnQI-pYA?e=wbsesD
```
Simulated_pyscript.ipynb
```


