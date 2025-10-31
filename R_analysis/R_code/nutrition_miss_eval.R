library(tidyverse)   # xử lý, trực quan hóa dữ liệu
library(readxl)      # đọc file Excel (.xlsx)
library(openxlsx)    # ghi/xuất Excel
library(psych)       # thống kê mô tả, kiểm định tâm lý
library(car)         # hồi quy, kiểm định mở rộng
library(mice)        # bù dữ liệu thiếu
library(naniar)      # kiểm tra & trực quan hóa dữ liệu thiếu
library(writexl)     # một package khác để xuất file excel

# Tùy chọn hiển thị
options(dplyr.width = Inf)
options(tibble.print_max = Inf)
options(digits = 4)

# Đường dẫn dữ liệu
final_data_path <- "data/final_data.xlsx"
imputed_data_path <- "data/imputed_data.xlsx"
nutrition_data_path <- "data/nutrition_data.xlsx"

# Đọc dữ liệu từ các sheet
final_df <- read_excel(final_data_path, sheet = "Sheet2")
imputed_df <- read_excel(imputed_data_path, sheet = "Sheet1")  
nutrition_df <- read_excel(nutrition_data_path, sheet = "Sheet1")

imputed_df <- imputed_df %>%
  mutate(number = final_df$number) %>%
  relocate(number, .before = 1)

nutrition_df <- nutrition_df %>%
  rename(
    number = Number,
    energy_kcal = `Energy(kcal)`,
    crude_protein_g = `Crude_Protein(g)`,
    crude_fat_g = `Crude_Fat(g)`,
    total_carbohydrate_g = `Total_Carbohydrate(g)`,
    water_g = `Water(g)`,
    fruits = Fruits,
    vegetables = Vegetables,
    whole_grains_roots = WholeGrainsAndRoots,
    protein_low_fat = `protein(LowFat)`,
    protein_medium_fat = `protein(MediumFat)`,
    protein_high_fat = `protein(HighFat)`,
    protein_superhigh_fat = `protein(SuperHighFat)`,
    dairy_skim = `Dairy(Skim)`,
    dairy_low_fat = `Dairy(LowFat)`,
    dairy_whole_fat = `Dairy(WholeFat)`,
    oils_nuts_and_seeds = Oils_Nuts_And_Seeds,
    total_polyunsaturated_fatty_acids_g = `Total_Polyunsaturated_Fatty_Acids(g)`,
    total_monounsaturated_fatty_acids_g = `Total_Monounsaturated_Fatty_Acids(g)`,
    total_saturated_fatty_acids_g = `Total_Saturated_Fatty_Acids(g)`,
    crude_fiber_g = `CrudeFiber(g)`,
    dietary_fiber_g = `Dietary_Fiber(g)`,
    total_sugar_g = `Total_Sugar(g)`,
    glucose_g = `Glucose(g)`,
    fructose_g = `Fructose(g)`,
    maltose_g = `Maltose(g)`,
    sucrose_g = `Sucrose(g)`,
    lactose_g = `Lactose(g)`,
    cholesterol_mg = `Cholesterol(mg)`,
    sodium_mg = `Sodium(mg)`,
    potassium_mg = `Potassium(mg)`,
    calcium_mg = `Calcium(mg)`,
    magnesium_mg = `Magnesium(mg)`,
    phosphorus_mg = `Phosphorus(mg)`,
    iron_mg = `Iron(mg)`,
    zinc_mg = `Zinc(mg)`,
    vitamin_b1_mg = `VitaminB1(Thiamin)(mg)`,
    vitamin_b2_mg = `VitaminB2(Riboflavin)(mg)`,
    niacin_mg = `Niacin(mg)`,
    vitamin_b6_mg = `VitaminB6(mg)`,
    vitamin_b12_ug = `VitaminB12(ug)`,
    folicacid_ug = `FolicAcid(ug)`,
    vitaminc_mg = `VitaminC(mg)`,
    totalVitaminA_ui = `TotalVitaminA(I.U.)`,
    totalVitaminE_mg = `TotalVitaminE(mg)`,
    trans_fat = trans_fat,
    threonine_mg = `Threonine(mg)`,
    valine_mg = `Valine(mg)`,
    methionine_mg = `Methionine(mg)`,
    isoleucine_mg = `Isoleucine(mg)`,
    leucine_mg = `Leucine(mg)`,
    phenylalanine_mg = `Phenylalanine(mg)`,
    lysine_mg = `Lysine(mg)`,
    histidine_mg = `Histidine(mg)`,
    tryptophan_mg = `Tryptophan(mg)`,
    alanine_mg = `Alanine(mg)`,
    arginine_mg = `Arginine(mg)`,
    aspartic_mg = `AsparticAcid(mg)`,
    glutamic_mg = `GlutamicAcid(mg)`,
    glycine_mg = `Glycine(mg)`,
    proline_mg = `Proline(mg)`,
    serine_mg = `Serine(mg)`,
    tyrosine_mg = `Tyrosine(mg)`,
    cystine_mg = `Cystine(mg)`
  )


nutrition_df <- nutrition_df %>%
  mutate(across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))

merged_df <- imputed_df %>%
  left_join(nutrition_df, by = "number")

mcar_test(merged_df)


anti_join(imputed_df, nutrition_df, by = "number")





