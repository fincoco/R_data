#c()함수를 이용하여 여러 값으로 구성된 변수 생성 가능
var1 = c(1, 2, 3, 4, 5)
var2 = c(1:5)
var3 = (1:5)
var4 = seq(1, 5)
var5 = seq(1, 10, by=2)

var1
var2
var3
var4
var5

#문자로 된 변수 생성은 따옴표 "를 붙여야 하며 문자로 된 변수는 계산할 수 없음.문자로 된 변수 합치는 함수 paste(), 구분자는 collapse로 지정
str1 = "hello"
str2 = c("hello!", "world", "is", "good")
str2

paste(str2, collapse = ",")

#패키지 설치는 install.packages("패키지이름"), 패키지 로드는 library()

#R에서 엑셀 파일 읽기 위해서는 패키지 설치 필요
install.packages("readxl")
library(readxl)

#첫 번째 행이 변수명이 아닐 때에는 파라미터 설정 col_names = F
#시트가 여러 개 있다면 불러올 시트 지정 sheet = 3
library(readxl)
df_exam = read_excel("excel_exam.xlsx")
df_exam_novar = read_excel("excel_exam_novar.xlsx", col_names = F)

#CSV파일은 내장된 함수 사용 read.csv(), 변수명이 없는 경우 header = F 파라미터 지정
#문자가 들어있는 CSV파일은 stringsAsFactors = F 파라미터 설정
#CSV파일 저장은 함수 사용 write.csv()
df_csv_exam = read.csv("csv_exam.csv")
write.csv(df_midterm, file = "df_midterm.csv")

#데이터 프레임을 RData로 저장하기 위해서는 save() 함수 이용, rda 파일 로드는 load()
save(df_midterm, file = "df_midterm.rda")
load("df_midterm.rda")
