##############################################################################
# Author : Mahesh Babu Narra
# Purpose: Compile Snp into a data table
# 2018-06-25 \Narra
# 2018-07-14: Version:1.1 \Narra
# 2018-07-27: Version:1.2 time function \Narra
# 2018-08-15: Version:1.3 modular function for running seperate snps \Narra
# 2019-02-04: matrix operation for optimized view and ease in analysis in csv/JMP \Narra
# Packages needed to run this script 
#install.packages("subprocess")
#run all sweeps in the folder
#############################################################################
#############################################################################
require(ggplot2)
require(lattice)
rm(list = ls());
#Die based snps extraction
Sweep_path <- choose.files(default = "", caption = "Choose the location of correct variant & waferID Sweep file");
pos_file_loc <- choose.files(default = "", caption = "Choose the location of taped bin pos file that particular wafer");
output_snp_directory=choose.dir(default = "", caption = "Choose which directory to save the snps");
df_pos <- read.table(file= pos_file_loc, skip=13, header=FALSE, sep=","); ## read the PNL_X, PNL_Y information
count_dies_number <- NROW(df_pos); # Count how many dies are in pos file
##generate a neeeded cmd line or txt
df_batch <- NULL;
df_batch <- mat.or.vec(1,count_dies_number);
for (i in 1:count_dies_number)
{
  df_tmp <- paste0("C:\\Users\\ED5654\\Documents\\TDK_Projects\\Projects_2018\\JMP_Tool_Dev\\PliTsConvert64.exe -fo TS -ts_val_type DB " , sprintf("%s", Sweep_path), " -row ", df_pos[i,1], " -col ", df_pos[i,2]," -o ", sprintf("%s", output_snp_directory) , "\\%p_%3r_%3c.snp &");
  df_tmp;
  df_batch[1,i] <- df_tmp ; 
}
df_batch <- t(df_batch);
df_batch;
#Save in csv format
outputfilename= paste(output_snp_directory,"batch_bin.bat",sep = "\\");
##print(df_batch, digits = NULL, quote = FALSE, row.names = FALSE, max = NULL);
write.csv (df_batch, file = outputfilename, quote = FALSE, row.names = FALSE);
#############################################################################
#rm(list = ls());
message("Please see the location for the csv file and open in JMP/ reporting tools \n\n\n Thanks for using the script Mahesh Narra")

