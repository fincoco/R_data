#열은 '컬럼(Column)' 또는 '변수(Variable)', 행은 'Row' 또는 'Case'
#데이터 프레임 만들 때는 data.frame() 이용하여 변수를 쉼표로 나열
#달러 기호($)를 통해 데이터 프레임 안의 변수 지정

english = c(10, 20, 30, 40, 50)
math = c(20, 50, 60, 30, 80)
class = c(1, 2, 3, 1, 2)

df_midterm = data.frame(english, math, class)
df_midterm

#df_midterm$english
#df_midterm$math

library(readxl)
df_exam = read_excel("excel_exam.xlsx")
df_exam

#데이터 파악할 때 사용하는 함수들
#head(): 데이터 앞부분 출력(앞에서부터 6행까지)
#tail(): 데이터 뒷부분 출력(뒤에서부터 6행까지)
#View(): 뷰어 창에서 데이터 확인(R studio에서 데이터 뷰어창 팝업)
#dim(): 데이터 차원 출력
#str(): 데이터 속성 출력
#summary(): 요약 통계량 출력

exam = read.csv("csv_exam.csv")
exam

head(exam)
head(exam, 10)
tail(exam)
tail(exam, 10)
dim(exam) #행, 열 출력
str(exam)
summary(exam)

install.packages("ggplot2")
mpg = as.data.frame(ggplot2::mpg)
head(mpg)
dim(mpg)
str(mpg)
summary(mpg)

#변수명 바꾸기; dplyr 패키지의 rename()
installed.packages("dplyr")
library(dplyr)
df_raw = data.frame(var1 = c(1, 2, 3),
                    var2 = c(2, 3, 2))
df_raw
df_new = df_raw
df_new
df_new = rename(df_new, v2=var2)
df_new
df_raw

mpg_copy = mpg
head(mpg_copy, 10)
mpg_copy = rename(mpg_copy, city=cty)
mpg_copy = rename(mpg_copy, highway=hwy)
head(mpg_copy)

#파생변수 만들기
df = data.frame(var1 = c(4, 3, 8),
                var2 = c(2, 6, 1))
df
df$var_sum = df$var1 + df$var2
df$mean = (df$var1+df$var2)/2
df
mpg$total = (mpg$cty+mpg$hwy)/2
head(mpg)
summary(mpg$total)

hist(mpg$total) #히스토그램 생성

#조건문함수
mpg$test = ifelse(mpg$total>=20, "pass", "fail") 
head(mpg, 10)
table(mpg$test) #해당 열에 대한 빈도표 생성

library(ggplot2)
qplot(mpg$test) #막대그래프 생성

mpg$grade = ifelse(mpg$total>=30, "A",
                   ifelse(mpg$total>=20, "B", "C"))
head(mpg)

table(mpg$grade)
qplot(mpg$grade)

