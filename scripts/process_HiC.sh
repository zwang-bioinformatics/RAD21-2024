




# juicer command for processing Hi-C data

juicer.sh -g mm10 -d /home/tliu/UK/juicer/work/WT_Sham1 -D /home/tliu/UK/juicer -s Arima -t 20




# covert from .hic to .cool
hicConvertFormat -m $fileIn --inputFormat hic --outputFormat cool -o $fileOut --resolutions $resolution



# normalize and balance .ccol data of two condtions for comparison

hicNormalize -m \
/home/tliu/UK/cooler_fromHiC_all/cool_${resolutions[$i]}/${id1}1_0_noChrM.cool \
/home/tliu/UK/cooler_fromHiC_all/cool_${resolutions[$i]}/${id1}2_0_noChrM.cool \
/home/tliu/UK/cooler_fromHiC_all/cool_${resolutions[$i]}/${id1}3_0_noChrM.cool \
/home/tliu/UK/cooler_fromHiC_all/cool_${resolutions[$i]}/${id2}1_0_noChrM.cool \
/home/tliu/UK/cooler_fromHiC_all/cool_${resolutions[$i]}/${id2}2_0_noChrM.cool \
/home/tliu/UK/cooler_fromHiC_all/cool_${resolutions[$i]}/${id2}3_0_noChrM.cool \
--normalize smallest \
-o \
$dirout/${id1}1_${rids[$i]}.cool \
$dirout/${id1}2_${rids[$i]}.cool \
$dirout/${id1}3_${rids[$i]}.cool \
$dirout/${id2}1_${rids[$i]}.cool \
$dirout/${id2}2_${rids[$i]}.cool \
$dirout/${id2}3_${rids[$i]}.cool


cooler balance -p 10 $dirout/${id1}1_${rids[$i]}.cool











