# Nạp toàn bộ các gói cần thiết
library(tidyverse)   # xử lý, trực quan hóa dữ liệu
library(readxl)      # đọc file Excel (.xlsx)
library(openxlsx)    # ghi/xuất Excel
library(psych)       # thống kê mô tả, kiểm định tâm lý
library(car)         # hồi quy, kiểm định mở rộng
library(mice)        # bù dữ liệu thiếu
library(naniar)      # kiểm tra & trực quan hóa dữ liệu thiếu
library(writexl)     # một package khác để xuất file excel

df <- read_excel("../data/risk_factors.xlsx")
head(df)

glimpse(df)
str(df)
View(miss_var_summary(df))

# mcar_test(df) # test gặp lỗi không rõ lí do

pool_df = mice(df, seed = 1234, printFlag = F)
pool_df$imp$gestational_weight_gain
a
imputed_df <- complete(pool_df, action=1)
glimpse(imputed_df)
View(miss_var_summary(imputed_df))

# không thể nào impute được các biến: CES_D, PSS, RSE

# write.csv(imputed_df, "imputed_data.csv", row.names = FALSE)
# write_xlsx(imputed_df, "../data/imputed_data.xlsx")

### thử cách khác 

df_imp <- mice(
  df,
  pred = quickpred(df, mincor = 0.2, minpuc = 0.4),
  seed = 38788, m = 10, maxit = 10, printFlag = FALSE
)