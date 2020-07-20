#Data Manipulation, Data Handling, Data Wrangling, Data Munging
#데이터 전처리. dplyr 패키지는 데이터 전처리 작업에 가장 많이 사용되는 패키지.
#%>% 기호를 이용해 코드 작성

#filter(): 행 추출
#select(): 열(변수) 추출
#arrange(): 정렬
#mutate(): 변수 추가
#summarise(): 통계치 산출
#group_by(): 집단별로 나누기
#left_join(): 데이터 합치기(열)
#bind_rows(): 데이터 합치기(행)

library(dplyr)

exam = read.csv("csv_exam.csv")
exam

#filter함수 사용하기
# 나눗셈 몫 %/%, 나눗셈 나머지 %%

exam %>% filter(class==1) # 같을 때는 ==, 아닐 때는 !=
exam %>% filter(class==1 & math>=50) # 조건이 여러 개인 경우(and, &)
exam %>% filter(math>=90 | english>=90) # 조건이 여러 개인 경우(or, |)
exam %>% filter(class %in% c(1, 3, 5)) # %in% 매칭 확인, c() 함수와 함께 매칭 조건 목록

#select함수 사용하기
exam %>% select(math)
exam %>% select(class, english, math)
exam %>% select(-math) #제외할 변수명 앞에는 -기호

#dplyr함수 조합하기
exam %>% 
  filter(class==1) %>% 
  select(english) %>%
  head

mpg_filter= mpg %>% 
  select(class, cty) %>%
  filter(class=="suv"|class=="compact")
mpg_filter

mpg_compact = mpg_filter %>% filter(class=="compact")
mpg_suv = mpg_filter %>% filter(class=="suv")
mean(mpg_compact$cty)
mean(mpg_suv$cty)

#arrange()함수 사용하기
exam %>% arrange(math) #오름차순 정렬
exam %>% arrange(desc(math)) #내림차순 정렬
exam %>% arrange(class, math)

mpg
mpg_audi = mpg %>% filter(manufacturer=="audi") %>% arrange(desc(hwy)) %>% head(5)
mpg_audi

#mutate()함수 활용하기
exam %>%
  mutate(total=math+english+science,
         mean=(math+english+science)/3) %>%
  head

exam %>%
  mutate(test = ifelse(science >= 60, "pass", "fail")) %>%
  head

mpg_new = as.data.frame(ggplot2::mpg)
mpg_new %>% 
  mutate(sum=cty+hwy,
         avg=sum/2) %>%
  arrange(desc(avg)) %>%
  head(3)

#group_by(): 분리, summarise(): 집단요약함수 이용하기
exam %>% summarise(mean_math=mean(math))
exam %>% 
  group_by(class) %>%
  summarise(mean_math=mean(math))

exam %>%
  group_by(class) %>%
  summarise(mean_math=mean(math),
            sum_math=sum(math),
            median_math=median(math),
            n=n()) #빈도함수

mpg %>%
  group_by(manufacturer) %>%
  filter(class=="suv") %>%
  mutate(tot=(cty+hwy)/2) %>%
  summarise(mean_tot=mean(tot)) %>%
  arrange(desc(mean_tot)) %>%
  head(5)

mpg %>%
  group_by(class) %>%
  summarise(mean_cty=mean(cty)) %>%
  arrange(desc(mean_cty))

mpg %>%
  group_by(manufacturer) %>%
  summarise(mean_hwy=mean(hwy)) %>%
  arrange(desc(mean_hwy)) %>%
  head(3)

mpg %>%
  filter(class=="compact") %>%
  group_by(manufacturer) %>%
  summarise(count=n()) %>%
  arrange(desc(count))

#가로로 합치는 left_join()함수 이용하기
test1 = data.frame(id = c(1, 2, 3, 4, 5),
                   midterm = c(60, 80, 70, 90, 85))
test2 = data.frame(id=c(1, 2, 3, 4, 5),
                   final = c(70, 83, 65, 95, 80))
test1
test2

total = left_join(test1, test2, by="id")
total

#세로로 합치는 bind_rows()함수 이용하기
group_a = data.frame(id=c(1, 2, 3, 4, 5),
                     test = c(60, 80, 70, 90, 85))
group_b = data.frame(id=c(6, 7, 8, 9, 10),
                     test=c(70, 83, 65, 95, 80))
group_all = bind_rows(group_a, group_b)
group_all

mpg = as.data.frame(ggplot2::mpg)
mpg
fuel = data.frame(fl = c("c", "d", "e", "p", "r"),
                  price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22),
                  stringsAsFactors = F) #문자를 Factor타입으로 변경하지 않도록 설정
fuel
mpg_re = left_join(mpg, fuel, by="fl")
mpg_re %>% 
  select(model, fl, price_fl) %>%
  head(5)

#연습문제
midwest = as.data.frame(ggplot2::midwest)
midwest = midwest %>%
  mutate(popchild = (poptotal-popadults)/poptotal*100) 

midwest %>%
  arrange(desc(popchild)) %>%
  select(county, popchild) 

midwest = midwest %>%
  mutate(grade = ifelse(popchild >= 40, "large",
                        ifelse(popchild >=30, "middle", "small"))) 
table(midwest$grade)

midwest %>%
  mutate(ratio_asian = (popasian/poptotal)*100) %>%
  arrange(ratio_asian) %>%
  select(state, county, ratio_asian) %>%
  head(10)
