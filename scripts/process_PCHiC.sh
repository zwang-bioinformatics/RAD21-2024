

# run Arima pipeline for processing PCHiC data

Arima-CHiC-v1.4.sh \
-W 1 \
-Y 1 \
-Z 1 \
-P 1 \
-A /path/to/bowtie2 \
-X /path/to/Arima_data/reference/mm10 \
-d /path/to/Arima_data/mm10/reference/Digest_mm10_Arima.txt \
-H /path/to/HiCUP-0.8.3 \
-C /path/to/chicagoTools \
-I $1,$2 \
-o $3 \
-p 1 \
-b /path/to/Arima_data/mouse_GW_PC_S3207063_S3207103_mm10.uniq.bed \
-R /path/to/Arima_data/mm10/5kb/mm10_chicago_input_5kb.rmap \
-B /path/to/Arima_data/mm10/5kb/mm10_chicago_input_5kb.baitmap \
-D /path/to/Arima_data/mm10/5kb \
-O mm10 \
-r 5kb \
-t 30 &> $4






