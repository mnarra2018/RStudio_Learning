##############################################################################
# Author : Mahesh Babu Narra
# Purpose: Compile Snp into a data table
# 2018-06-25 \Narra
# 2018-07-14: Version:1.1 \Narra
# 2018-07-27: Version:1.2 time function \Narra
# 2018-08-15: Version:1.3 modular function for running seperate snps \Narra
# Packages needed to run this script 
#install.packages("subprocess")
#run all sweeps in the folder
#############################################################################
#############################################################################
require(ggplot2)
require(lattice)
rm(list = ls());
Spram_path = choose.dir(default = "", caption = "Choose the location of S parameter files");
list_Sparam_files= list.files(Spram_path, pattern = "*.snp"); #choose only snp files
count_sparam_number = NROW(list_Sparam_files); # get number of snp files
PNL_X = vector(mode = "character", length(count_sparam_number)); # ROw vector
PNL_Y = vector(mode = "character", length(count_sparam_number));# Col vector
WAFERID = vector(mode = "character", length(count_sparam_number));# WaferID vector
fname = vector(mode = "character", length(count_sparam_number));# files names vector
# Getting the ROW, COL, DUT information.
for (i in 1:count_sparam_number)
{
        PNL_Y[i] = substr(list_Sparam_files [i], nchar(list_Sparam_files[i]) -6 , nchar(list_Sparam_files[i])-4 ) ;#Column name
        PNL_X[i] = substr(list_Sparam_files [i], nchar(list_Sparam_files[i]) -10 , nchar(list_Sparam_files[i])-8 ) ;#Row name
        WAFERID[i] = substr(list_Sparam_files [i], nchar(list_Sparam_files[i]) -23 , nchar(list_Sparam_files[i])-12 ); #Wafer ID name
        fname[i] =paste(Spram_path,list_Sparam_files[i],sep = "\\") ;# filenames
}
####Complete the Extraction of R,C, WAFER ID information ####################
## plot the wafer map per DUT###
plot(PNL_Y, PNL_X, type = "p",  xlab = "PNL_Y", ylab = "PNL_X", xlim = c(0,300), ylim = c(180,0));
#############################################################################
########FUnction defintion ####################
runsweep <- function(a,b)
{
  if (a>b || a<1|| b<1) # check correctness of arguments
  {
    print("failed")
    return(NULL)
  }
  if(b>count_sparam_number)
  {
    b=count_sparam_number
  }
  for (i in a:b)
  {
    df <- read.table(file= fname[i], skip=11, header=FALSE, sep="");
    df <- df[, -c (6,7)];
    df <- cbind(WAFERID[i], PNL_X[i], PNL_Y[i], df);
    if (i==a)
    {
      newdata <- df;
    }
    else
      newdata <- rbind.data.frame (newdata, df) ;
  }
  return(newdata)
}
########FUnction defintion ends ####################
m=round(count_sparam_number/100); # 100 is the sample size for each iteration of for loop
tmp <- NULL ;
sweepdata <- NULL ;
Sys.time()
for (j in 1:m)
{
  sprintf("%d",j);
  tmp <- runsweep((100*j)-99,j*100);# 100 is the sample size for each iteration of for loop
  sweepdata <- rbind.data.frame (sweepdata,tmp) ;
}
Sys.time()
colnames(sweepdata) <- c( "WAFERID", "PNL_X", "PNL_Y", "freq", "dbS11", "angS11", "dbS21", "angS21", "dbS22", "angS22")
#############################################################################
#Save in csv format
outputfilename= paste(Spram_path,"SweepData.csv",sep = "\\");
write.csv (sweepdata, file = outputfilename );
#############################################################################
rm(list = ls());
message("Please see the location for the csv file and open in JMP/ reporting tools \n\n\n Thanks for using the script Mahesh Narra")