# Nạp toàn bộ các gói cần thiết
library(tidyverse)   # xử lý, trực quan hóa dữ liệu
library(readxl)      # đọc file Excel (.xlsx)
library(openxlsx)    # ghi/xuất Excel
library(psych)       # thống kê mô tả, kiểm định tâm lý
library(car)         # hồi quy, kiểm định mở rộng
library(writexl)     # một package khác để xuất file excel

df <- read_excel("data/imputed_data.xlsx")
head(df)
View(glimpse(df))

df$homa_ir <- (df$insulin * df$glucose_ac) / 405
df$insulin_re <- ifelse(df$homa_ir <= 3.16, 0, 1)


cpp_code <- c("0" = "no", "1" = "yes")
sex_code <- c("0" = "female", "1" = "male")
pregnancy_smoking_code <- c("0" = "no", "1" = "yes")
# GDM_code <- c("no-dia" = 1, "gmd" = 2, "other-dia" = 3)
GDM_code <- c("1" = "no", "2" = "yes", "3" = "no")
preterm_birth_code <- c("0" = "no", "1" = "yes")
father_diabetes_code <- c("0" = "no", "1" = "yes")
mother_diabetes_code <- c("0" = "no", "1" = "yes")
# education_level_code <- c("senior high" = 1, "vocational" = 2, "graduate" = 3, "college" = 4)
education_level_code <- c("1" = "low", "2" = "low", "3" = "high", "4" = "medium")
insulin_re_code <- c("0" = "no", "1" = "yes")


df$CPP <- factor(cpp_code[as.character(df$CPP)])
df$sex <- factor(sex_code[as.character(df$sex)])
df$pregnancy_smoking <- factor(pregnancy_smoking_code[as.character(df$pregnancy_smoking)])
df$GDM <- factor(GDM_code[as.character(df$GDM)])
df$preterm_birth <- factor(preterm_birth_code[as.character(df$preterm_birth)])
df$father_diabetes <- factor(father_diabetes_code[as.character(df$father_diabetes)])
df$mother_diabetes <- factor(mother_diabetes_code[as.character(df$mother_diabetes)])
df$education_level <- factor(education_level_code[as.character(df$education_level)],
                             levels = c("low", "medium", "high"), ordered = TRUE)
df$insulin_re <- factor(insulin_re_code[as.character(df$insulin_re)])

# Danh sách các biến nguy cơ
risk_factors <- c(
  # Các confounder
  "sex",
  "age",
  "education_level", # biến số học, cộng điểm cha và mẹ
  "zbmi",
  # Các yếu tố nguy cơ prenatal
  "gestational_weight_gain",
  "pregnancy_smoking",
  "GDM",
  # Các yếu tố nguy cơ perinatal
  "birth_weight_gram",
  "preterm_birth", # ngưỡng chọn preterm là 36 tuần
  "gestational_age_week",
  "exclusive_breastfeeding_month",
  "mixed_breastfeeding_month"
)



# Chuyển biến 'insulin_re' thành dạng nhị phân (0, 1)
df$insulin_re_bin <- ifelse(df$insulin_re == "yes", 1, 0)

# Tạo công thức mô hình (giống "insulin_re_bin ~ var1 + var2 + ...")
formula <- as.formula(paste("insulin_re_bin ~", paste(risk_factors, collapse = " + ")))

# Ước lượng mô hình GLM nhị phân (Binomial family, link = logit)
model <- glm(formula = formula, data = df, family = binomial())

# Xem tóm tắt kết quả mô hình
View(summary(model))
