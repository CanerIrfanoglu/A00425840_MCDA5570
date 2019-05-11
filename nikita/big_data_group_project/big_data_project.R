library(sqldf)
library(dplyr)
library(Hmisc)
##### Setting Path ################################################################################
setwd("/Users/Caner/Desktop/SMU_Class/Managing_Info_Tech_5570/nikita/big_data_group_project/")

###################################################################################################

################## Reading Files ##################################################################
os_order <- read.table("./OS_ORDER.txt", stringsAsFactors=FALSE, header = TRUE, sep="\t")
os_order_items <- read.table("./OS_ORDER_ITEMS.txt", stringsAsFactors=FALSE, 
                             header = TRUE, sep="\t")
###################################################################################################

################## Data Wrangling ################################################################# 
os_order$ORDER_CODE <- as.character(os_order$ORDER_CODE)
os_order$BUYER_ID <- as.character(os_order$BUYER_ID)
# Converted ORDER_CODE & BUYER_ID to character

os_order$PAY_DT <- as.POSIXct(os_order$PAY_DT, format = "%d-%m-%Y %H:%M:%OS")
# Converted PAY_DT to date type

os_order <- os_order[, !(names(os_order) %in% c("CREATE_DT", "EXCEPTION_STATUS"))]
# Dropped CREATE_DT & EXCEPTION_STATUS. It was `0000-00-00` & 0 all rows

os_order_items$ITEM_ID <- as.character(os_order_items$ITEM_ID)
os_order_items$ORDER_ID <- as.character(os_order_items$ORDER_ID)
os_order_items$GOODS_ID <- as.character(os_order_items$GOODS_ID)
# Converted item df ID columns to character type

order_df  <- sqldf("SELECT * FROM os_order 
                    INNER JOIN os_order_items ON os_order.ORDER_ID = os_order_items.ORDER_ID")
# Joined the datasets on ORDER_ID

order_df <- order_df[, !(names(order_df) %in% c("ORDER_ID..8"))]
# Dropped duplicated ORDER_ID Column

###################################################################################################

################## Exploratory #################################################################### 

# What is the meaning of different order status in os_order?

order_NA <-sapply(order_df, function(y) sum(length(which(is.na(y)))))
# NA Counts 

order_desc <- describe(order_df)
# Order Descriptions | Takes around 3 secs to run









