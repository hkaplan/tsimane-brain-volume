***Variable Definitions (Data Dictionary)

**BV_mm3 = Brain volume in cubic millimeters
**TICV_mm3 = Total intracranial volume in millimeters
**BV_prct = Brain volume as a percentage of intracranial volume
**norm_BV_prct = Allometrically normalized brain volume as a percent of intracranial volume
**age = Age in years
**male = 1 if male, 0 if female
**Tsimane = 1 if Tsimane, 0 if Moseten
**Moseten  = 0 if Tsimane, 1 if Moseten
**wt_kg = Body weight in Kilograms
**ht_cm = Height in centimeters
**bmi = Body Mass Index
**colesterol = Cholesterol (mg/dl)
**nonhdlcholesterol = Cholesterol – HDL (mg/dl)
**blood_glicemia = fasting blood sugar (mg/dl)
**hb = Blood hemoglobin (g/dl)
**epicardialfat = Volume of epicardial fat 
**liver = liver density in Hounsfield Units (HU)
**systolic_bp = Systolic blood pressure
**diastolic_bp = diastolic blood pressure
**arch_ca = Calcification of the aortic arch in Agagston Units (AU)
**tac = Calcification of the ascending and descending aorta in Agagston Units (AU)
**cac = Calcification of the coronary arteries in Agagston Units (AU)
**leucocitos = leukocytes or white blood cells in g/l
**crp_mgdl = High sensitivity C-reactive protein (mg/dl)
**GradeLevelReached = Years of educations completed


***Data transformation commands

***Brain Volume Transformations

gen BV_prct = BV_mm3/TICV_mm3*100
replace norm_BV_prct= 100*1189900^(.917-1)* BV_mm3/TICV_mm3^.917


*** Age Transformations
gen ageminus58 = age-58
 replace ageminus58= age-58
 gen ageminus40 = age - 40
 replace ageminus40 = age - 40
  gen ageminus40_sq = ageminus40*ageminus40
 gen ageminus58_sq = ageminus58*ageminus58

 gen ageclass = .
  replace ageclass= 35 if age >= 30 & age < 40
 replace ageclass= 45 if age >= 40 & age < 50
 replace ageclass= 55 if age >= 50 & age < 60
 replace ageclass= 65 if age >= 60 & age < 70
 replace ageclass= 75 if age >= 70 & age < 80
  replace ageclass= 85 if age >= 80 
 
*** Predictor variable transformations 

gen popsex2 = .
 replace popsex2 = 1 if male ==0 & Moseten==0
  replace popsex2 = 2 if male ==1 & Moseten==0
  replace popsex2 = 3 if male ==0 & Moseten==1
   replace popsex2 = 4 if male ==1 & Moseten==1
 
gen bmi= wt_kg/ ((ht_cm/100)*(ht_cm/100))
gen bmi_sq = bmi*bmi
 
gen tradbmiclass = .
replace tradbmiclass = 1 if bmi < 18.5
replace tradbmiclass = 2 if bmi  >= 18.5 & bmi < 25
replace tradbmiclass = 3 if bmi  >= 25 & bmi < 30
replace tradbmiclass = 4 if bmi >= 30 
replace tradbmiclass = . if bmi==.  

gen obese = .
replace obese = 0 if bmi <30
replace obese = 1 if bmi >= 30
replace obese = . if bmi ==.

gen elevated_chol  = .
replace elevated_chol = 0 if colesterol < 200
replace elevated_chol = 1 if colesterol >= 200
replace elevated_chol = . if colesterol ==.

gen nonhdlcholesterol = colesterol -hdl
gen nonhdlcholesterol_sq= nonhdlcholesterol*nonhdlcholesterol

gen nonhdlcholesterolclass2 = .
replace nonhdlcholesterolclass2 = 1 if nonhdlcholesterol <80
replace nonhdlcholesterolclass2 = 2 if nonhdlcholesterol  >= 80 & nonhdlcholesterol < 130
replace nonhdlcholesterolclass2 = 3 if nonhdlcholesterol  >= 130 & nonhdlcholesterol < 160
replace nonhdlcholesterolclass2 =4 if nonhdlcholesterol  >= 160 
replace nonhdlcholesterolclass2 = . if nonhdlcholesterol == .

gen elevate_nonhdlcholesterol  = .
replace elevate_nonhdlcholesterol = 0 if nonhdlcholesterol <130
replace elevate_nonhdlcholesterol = 1 if nonhdlcholesterol >= 130
replace elevate_nonhdlcholesterol = . if nonhdlcholesterol ==.

gen glucose_elev = .
 replace glucose_elev = 0 if blood_glicemia < 125
 replace glucose_elev = 1 if blood_glicemia >= 125
 replace glucose_elev = . if blood_glicemia ==.

gen anemic = .
replace anemic = 1 if hb < 11.6 & male==0
replace anemic = 1 if hb < 13 & male ==1
replace anemic = 0 if hb >= 11.6 & male==0
replace anemic = 0 if hb >= 13 & male ==1
replace anemic = . if hb == .

 gen epicardialfat=(axial1mm+ axial2mm+axial3mm+sag1mm+sag2mm+sag3mm)/6

gen stage1hypertensive  = .
replace stage1hypertensive = 0 if systolic_bp < 130 |~ systolic_bp >= 140 & diastolic_bp < 80 |~ diastolic_bp >=90
replace stage1hypertensive = 1 if systolic_bp >= 130 & systolic_bp < 140 |~ diastolic_bp > 80 & diastolic_bp <=90
replace stage1hypertensive = . if systolic_bp ==. |~ diastolic_bp == .
gen stage2hypertensive = .
replace stage2hypertensive = 0 if  systolic_bp <  140 & diastolic_bp < 90 
replace stage2hypertensive = 1 if systolic_bp >=  140 |~ diastolic_bp >= 90
replace stage2hypertensive = . if systolic_bp ==. |~ diastolic_bp == .
 
gen arch_ca_present = .
replace arch_ca_present = 0 if arch_ca == 0
replace arch_ca_present = 1 if arch_ca > 0
replace arch_ca_present = . if arch_ca ==.
gen tac_present = .
replace tac_present = 0 if tac ==0
replace tac_present = 1 if tac > 0
replace tac_present = . if tac ==.
gen cac_present = .
replace cac_present = 0 if cac ==0
replace cac_present = 1 if cac > 0
replace cac_present = . if cac ==.

gen elevated_leucocitos  = .
replace elevated_leucocitos = 0 if leucocitos < 10700
replace elevated_leucocitos = 1 if leucocitos >= 10700
replace elevated_leucocitos = . if leucocitos ==.
gen elevated_crp  = .
replace elevated_crp = 0 if crp_mgdl < 3
replace elevated_crp = 1 if crp_mgdl >= 3
replace elevated_crp = . if crp_mgdl ==.

***Normalizing transformations
egen float zht_cm = std(ht_cm), mean(0) std(1), if norm_B ~= .
egen float zwt_kg = std(wt_kg), mean(0) std(1), if norm_B ~= .
egen float zarch_ca = std(arch_ca), mean(0) std(1), if norm_B ~= .
egen float ztotal_tac = std(total_tac), mean(0) std(1), if norm_B ~= .
egen float ztac = std(tac), mean(0) std(1), if norm_B ~= .
egen float zhb = std(hb), mean(0) std(1), if norm_B ~= .
egen float zbmi = std(bmi), mean(0) std(1), if norm_B ~= .
egen float zcolesterol = std(colesterol), mean(0) std(1), if norm_B ~= .
egen float zepicardialfat = std(epicardialfat), mean(0) std(1), if norm_B ~= .
egen float znonhdlcholesterol = std(nonhdlcholesterol), mean(0) std(1), if norm_B ~= .
egen float zeducation  = std(GradeLevelReached), mean(0) std(1), if norm_B ~= .
egen float zFastingBloodSugar  = std(blood_glicemia), mean(0) std(1), if norm_B ~= .
egen float zliver = std(liver), mean(0) std(1), if norm_B ~= .
egen float zsystolic_bp = std(systolic_bp), mean(0) std(1), if norm_B ~= .
egen float zdiastolic_bp = std(diastolic_bp), mean(0) std(1), if norm_B ~= .
egen float zleucocitos = std(leucocitos), mean(0) std(1), if norm_B ~= .
egen float zcac = std(cac), mean(0) std(1), if norm_B ~= .
egen float zcrp_mgdl = std(crp_mgdl), mean(0) std(1), if norm_B ~= .




*** Statistical Models

*** Statistical Models for Table 1

summarize age GradeLevelReached wt_kg ht_cm bmi obese colesterol elevated_chol  nonhdlcholesterol elevate_nonhdlcholesterol  blood_glicemia diabetic hb anemic epicardialfat liver systolic_bp diastolic_bp stage1hypertensive stage2hypertensive arch_ca arch_ca_present tac tac_present cac cac_present leucocitos elevated_leucocitos crp_mgdl elevated_crp if norm_BV_prct ~= .
 

by Moseten, sort : summarize age GradeLevelReached wt_kg ht_cm bmi obese colesterol elevated_chol  nonhdlcholesterol elevate_nonhdlcholesterol  blood_glicemia diabetic hb anemic epicardialfat liver systolic_bp diastolic_bp stage1hypertensive stage2hypertensive arch_ca arch_ca_present tac tac_present cac cac_present leucocitos elevated_leucocitos crp_mgdl elevated_crp if norm_BV_prct ~= .

by popsex, sort : summarize age GradeLevelReached wt_kg ht_cm bmi obese colesterol elevated_chol nonhdlcholesterol elevate_nonhdlcholesterol blood_glicemia diabetic hb anemic epicardialfat liver systolic_bp diastolic_bp stage1hypertensive stage2hypertensive arch_ca arch_ca_present tac tac_present cac cac_present leucocitos elevated_leucocitos crp_mgdl elevated_crp if norm_BV_prct ~= .

reg ageminus40 male Moseten if norm_BV_prct ~= .
reg GradeLevelReached ageminus40 male Moseten if norm_BV_prct ~= .
reg wt_kg ageminus40 male Moseten if norm_BV_prct ~= .
reg ht_cm ageminus40 male Moseten if norm_BV_prct ~= .
reg bmi ageminus40 male Moseten if norm_BV_prct ~= .
reg obese ageminus40 male Moseten if norm_BV_prct ~= .
reg colesterol ageminus40 male Moseten if norm_BV_prct ~= .
logistic  elevated_chol ageminus40 male Moseten if norm_BV_prct ~= .
reg nonhdlcholesterol ageminus40 male Moseten if norm_BV_prct ~= .
logistic  elevate_nonhdlcholesterol ageminus40 male Moseten if norm_BV_prct ~= .
reg blood_glicemia ageminus40 male Moseten if norm_BV_prct ~= .
logistic diabetic ageminus40 male Moseten if norm_BV_prct ~= .
reg hb ageminus40 male Moseten if norm_BV_prct ~= .
logistic anemic ageminus40 male Moseten if norm_BV_prct ~= .
reg epicardialfat ageminus40 male Moseten if norm_BV_prct ~= .
reg liver ageminus40 male Moseten if norm_BV_prct ~= .
reg systolic_bp ageminus40 male Moseten if norm_BV_prct ~= .
reg diastolic_bp ageminus40 male Moseten if norm_BV_prct ~= .
logistic stage1hypertensive ageminus40 male Moseten if norm_BV_prct ~= .
logistic stage2hypertensive ageminus40 male Moseten if norm_BV_prct ~= .
reg arch_ca ageminus40 male Moseten if norm_BV_prct ~= .
logistic arch_ca_present ageminus40 male Moseten if norm_BV_prct ~= .
reg tac ageminus40 male Moseten if norm_BV_prct ~= .
logistic tac_present ageminus40 male Moseten if norm_BV_prct ~= .
reg cac ageminus40 male Moseten if norm_BV_prct ~= .
logistic cac_present ageminus40 male Moseten if norm_BV_prct ~= .
reg leucocitos ageminus40 male Moseten if norm_BV_prct ~= .
logistic elevated_leucocitos ageminus40 male Moseten if norm_BV_prct ~= .
reg crp_mgdl ageminus40 male Moseten if norm_BV_prct ~= . 
logistic elevated_crp ageminus40 male Moseten if norm_BV_prct ~= .


***Statistical Models for Table S1 and corresponding Figures 2a and 2b.

**Table S1
reg norm_BV_prct ageminus40  if Tsimane==1 & age >= 40 & male == 0
reg norm_BV_prct ageminus40 ageminus40_sq if Tsimane==1 & age >= 40 & male == 0
reg norm_BV_prct ageminus40  if Tsimane==1 & age >= 40 & male == 1
reg norm_BV_prct ageminus40 ageminus40_sq if Tsimane==1 & age >= 40 & male == 1

reg norm_BV_prct ageminus40  if Moseten==1 & age >= 40 & male == 0
reg norm_BV_prct ageminus40 ageminus40_sq if Moseten==1 & age >= 40 & male == 0
reg norm_BV_prct ageminus40  if Moseten==1 & age >= 40 & male == 1
reg norm_BV_prct ageminus40 ageminus40_sq if Moseten==1 & age >= 40 & male == 1

**Figure 2a
scatter norm_BV_prct ageminus40  if Tsimane==1 & age >=40 & male==0 || lfitci norm_BV_prct ageminus40 if Tsimane==1 || qfit norm_BV_prct ageminus40 if Tsimane==1

**Figure 2b
scatter norm_BV_prct ageminus40  if Moseten==1 & age >=40 || lfitci norm_BV_prct ageminus40 if Moseten==1  || qfit norm_BV_prct ageminus40 if Moseten==1 


***Statistical Models for Tables 2 and S2 and Figures 3a-3d

***Model 1

   reg norm_BV_prct c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten  
  estat ic
     reg norm_BV_prct c.ageminus58##c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten  
  estat ic

***Model 2
 reg norm_BV_prct   c.ageminus58##c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten zht_cm zbmi znonhdlcholesterol zhb zepicardialfat  zarch_ca ztac
  estat ic

*** Model 3 and Figures 3a, 3b.
***Model 3
  reg norm_BV_prct c.ageminus58##c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten zht_cm c.zbmi##c.zbmi c.znonhdlcholesterol##c.znonhdlcholesterol    zhb  zepicardialfat  zarch_ca ztac
estat ic

***Figure 3a
margins, at (zbmi = (-3.5 (.5) 3.5) zht_cm=0 znonhdlcholesterol = 0 zhb=0 zepicardialfat =0 zarch_ca=0 ztac= 0 ageminus58 = 0 male = 0 Moseten=0)
marginsplot, name (zbmi,replace) 
***Figure 3b
margins, at (znonhdlcholesterol = (-3.5 (.5) 3.5) zht_cm=0 zbmi = 0 zhb=0 zepicardialfat =0 zarch_ca=0 ztac= 0 ageminus58 = 0 male = 0 Moseten=0)
marginsplot, name (znonhdlcholesterol,replace)

***Model 4 and Figures 3c,3d

 ***Model 4
reg norm_BV_prct c.ageminus58##c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten zht_cm   zepicardialfat  zarch_ca ztac i.ib(2).tradbmiclass ib(2).nonhdlcholesterolclass2 i.anemic 
estat ic 
*** Figure 3c
pwcompare tradbmiclass, effects
margins r.tradbmiclass, asbalanced plot(recast(bar)) 
***Figure 3d
pwcompare nonhdlcholesterolclass2, effects
margins r.nonhdlcholesterolclass2, asbalanced plot(recast(bar))

***Additional Statistical Models for the Supplement
*** Models for Table S3 
reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zeducation
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zwt_kg
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zht_cm
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zbmi
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zcolesterol
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 znonhdlcholesterol
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zFastingBloodSugar
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zhb
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zepicardialfat
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zliver
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zsystolic_bp
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zdiastolic_bp
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zarch_ca
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 ztac
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zcac
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zleucocitos
estat ic

reg norm_BV_prct ageminus58 i.male i.Moseten i.male#c.ageminus58 i.Moseten#c.ageminus58 zcrp_mgdl
estat ic
*** Statistical Model for Table S4
 reg norm_BV_prct c.ageminus58##c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten zht_cm c.zbmi##c.zbmi c.znonhdlcholesterol##c.znonhdlcholesterol    zhb  zepicardialfat  zarch_ca ztac c.zht_cm#c.ageminus58 i.male#c.zbmi     c.zht_cm#c.ageminus58  Moseten#c.zarch_ca#male
estat ic

***Statistical Model for Table S5

reg lnBV lnTICV
estat ic

***Statistical Models for Table S6

***Model 1
 reg BV_prct c.ageminus58##c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten  
  estat ic
***Model2
 reg BV_prct   c.ageminus58##c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten zht_cm zbmi znonhdlcholesterol zhb zepicardialfat  zarch_ca ztac
  estat ic
***Model 3
  reg BV_prct c.ageminus58##c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten zht_cm c.zbmi##c.zbmi c.znonhdlcholesterol##c.znonhdlcholesterol    zhb  zepicardialfat  zarch_ca ztac
estat ic
***Model 4
  reg BV_prct c.ageminus58##c.ageminus58 i.male i.Moseten c.ageminus58#i.male c.ageminus58#i.Moseten zht_cm   zepicardialfat  zarch_ca ztac i.ib(2).tradbmiclass ib(2).nonhdlcholesterolclass2 i.anemic 
estat ic 


