#!/bin/bash
start=$(date +%s)
echo "Current time: $start"
#Steps for QC
plink2 --bfile ldlGWAS1 --geno 0 --make-bed --out GWAStutorialgeno 
plink2 --bfile GWAStutorialgeno --mind 0.05 --make-bed --out GWAStutorialmind 
plink2 --bfile GWAStutorialmind --maf 0.01 --make-bed --out GWAStutorialmaf 
plink2 --bfile GWAStutorialmaf --hwe 1e-5 --make-bed --out GWAStutorialhwe 
plink2 --bfile GWAStutorialhwe --indep-pairwise 50000 10000 0.3 --make-bed --out GWAStutorial6 
plink2 --bfile GWAStutorialhwe --extract GWAStutorial6.prune.in --make-bed --out GWAStutorialpruned 
plink2 --bfile GWAStutorialpruned --het --out prunedHet --seed 2000
awk '{if ($6 <= -0.1) print $0 }' prunedHet.het > outliers1.txt 
awk '{if ($6 >= 0.1) print $0 }' prunedHet.het > outliers2.txt 
cat outliers1.txt outliers2.txt > HETEROZYGOSITY_OUTLIERS.txt 
cut -f 1,2 HETEROZYGOSITY_OUTLIERS.txt > all_outliers.txt
plink2 --bfile GWAStutorialpruned --remove all_outliers.txt --make-bed --out GWAS_after_heterozyg 
plink2 --bfile GWAS_after_heterozyg --king-cutoff 0.177 --make-bed --out GWAStutorialkin 
sed '/-9/d' GWAStutorialkin.fam > GWAS_after_naremove2.fam
wc -l GWAS_after_naremove2.fam
plink2 --bfile GWAStutorialkin --keep GWAS_after_naremove2.fam --make-bed --out GWASfinal
wc -l GWASfinal.bim
wc -l GWASfinal.fam
plink2 --bfile GWASfinal --pca  --out pcaGWAS
plink2 --bfile GWASfinal --adjust --glm --parameters 1 --covar pcaGWAS.eigenvec --covar-name PC1 PC2 PC3 PC4 PC5 --covar-quantile-normalize PC1 PC2 PC3 PC4 PC5 --pfilter 0.00005 --ci 0.95 --out GWASfinallambda
plink2 --bfile GWASfinal --export A --out GWAStutorialldlraw 
wc -c GWAStutorialldlraw.raw
wc -l GWAStutorialldlraw.raw  
end=$(date +%s)
result=$(($end-$start)) 
echo "Elapsed Time: $result seconds"
