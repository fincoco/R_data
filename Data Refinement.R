#데이터 정제

#결측치(Missing Value) 정제
#R에서 결측치는 NA(숫자), <NA>(문자)로 나타남

df = data.frame(sex = c("M", "F", NA, "M", "F"),
                score = c(5, 4, 3, 4, NA))

df

is.na(df) #결측치 있으면 TRUE
table(is.na(df)) #빈도표로 생성

table(is.na(df$sex))
table(is.na(df$score))

#결측치 포함되어 있는 경우 함수 계산이 제대로 되지 않음.

library(dplyr)

df %>% 
  filter(is.na(score))

df %>%
  filter(!is.na(score)) #앞에 !붙이면 not의 의미

df_nomiss = df %>% filter(!is.na(score))
df_nomiss
mean(df_nomiss$score)
sum(df_nomiss$score)

df_nomiss_2 = df %>% filter(!is.na(score) & !is.na(sex))
df_nomiss_2

df_nomiss_3 = na.omit(df) #na.omit()을 통해 변수 지정하지 않고 결측치 있는 행 한번에 모두 제거
df_nomiss_3

#함수의 결측치 제외 기능 이용(na.rm = T)
mean(df$score, na.rm= T)
sum(df$score, na.rm = T)

exam = read.csv("csv_exam.csv")
exam[c(3, 8, 15), "math"] = NA #3, 8, 15행 math에 NA 할당
exam

exam %>% summarise(mean_math = mean(math)) #결측치 포함하고 있으므로 계산 안됨
exam %>% summarise(mean_math = mean(math, na.rm = T))
exam %>%
  summarise(mean_math = mean(math, na.rm = T),
            sum_math = sum(math, na.rm = T),
            median_math = median(math, na.rm = T))

#결측치 대체(Imputation)
exam
mean(exam$math, na.rm = T)
exam$math = ifelse(is.na(exam$math), 55, exam$math) #NA면 평균값인 55, 아니면 원래값
exam

#연습문제
mpg = as.data.frame(ggplot2::mpg)
mpg[c(65, 124, 131, 153, 212), "hwy"] = NA
table(is.na(mpg))

mpg %>%
  filter(!is.na(mpg$hwy)) %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy))

#이상치(Outlier) 정제
#정상범주에서 크게 벗어난 값인 이상치. 분석 결과 왜곡할 수 있기 때문에 이상치 제거 작업 필요
outlier = data.frame(sex = c(1, 2, 1, 3, 2, 1),
                     score = c(5, 4, 3, 4, 2, 6)) #성별 이상치 3, 점수 이상치 6
outlier
table(outlier$sex)
table(outlier$score)

#이상치를 결측치로 변환
outlier$sex = ifelse(outlier$sex == 3, NA, outlier$sex)
outlier$score = ifelse(outlier$score == 6, NA, outlier$score)
outlier

outlier %>%
  filter(!is.na(sex) & !is.na(score)) %>%
  group_by(sex) %>%
  summarise(mean_score = mean(score))

#극단치 제거(기준 만들기)
boxplot(mpg$hwy)
boxplot(mpg$hwy)$stats #상자 그림 통계치 출력, 위아래로 극단치 기준

mpg$hwy = ifelse(mpg$hwy < 12 | mpg$hwy > 37, NA, mpg$hwy)
table(is.na(mpg$hwy))

mpg %>% 
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy, na.rm = T))

#연습문제 
mpg=as.data.frame(ggplot2::mpg)
mpg[c(10, 14, 58, 93), "drv"] = "k"
mpg[c(29, 43, 129, 203), "cty"] = c(3, 4, 39, 42)

table(mpg$drv)
mpg$drv = ifelse(mpg$drv %in% c(4, "f", "r"), mpg$drv, NA)
table(mpg$drv)

boxplot(mpg$cty)$stats
mpg$cty = ifelse(mpg$cty < 9 | mpg$cty > 26, NA, mpg$cty)
boxplot(mpg$cty)

mpg %>%
  filter(!is.na(drv) & !is.na(cty)) %>%
  group_by(drv) %>%
  summarise(mean_cty = mean(cty))
