#데이터 분석 프로젝트-한국인의 삶을 파악하라

install.packages("foreign")

library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

raw_welfare = read.spss(file = "Koweps_hpc10_2015_beta1.sav",
                        to.data.frame = T) #spss 파일을 데이터 프레임 형태로 변환
welfare = raw_welfare
head(welfare)
tail(welfare)
View(welfare)
dim(welfare)
str(welfare)
summary(welfare)

welfare = rename(welfare,
                 sex = h10_g3,
                 birth = h10_g4,
                 marriage = h10_g10,
                 religion = h10_g11,
                 income = p1002_8aq1,
                 code_job = h10_eco9,
                 code_region = h10_reg7)

#성별에 따른 월급 차이
class(welfare$sex) #변수 성격 파악
table(welfare$sex)

welfare$sex = ifelse(welfare$sex == 9, NA, welfare$sex) #이상치 결측 처리
table(is.na(welfare$sex)) #결측치 확인

welfare$sex = ifelse(welfare$sex == 1, "male", "female")
table(welfare$sex)
qplot(welfare$sex) #간단한 막대그래프
ggplot(data = welfare, aes(x=sex)) + geom_bar()

class(welfare$income)
summary(welfare$income)
qplot(welfare$income) + xlim(0, 1000) #qplot은 기본적으로 최댓값까지 나오게 되어 있음.
boxplot(welfare$income)$stats

welfare$income = ifelse(welfare$income %in% c(0, 9999), NA, welfare$income) #이상치 결측 처리
table(is.na(welfare$income)) #결측치 확인

sex_income = welfare %>%
  filter(!is.na(income)) %>%
  group_by(sex) %>%
  summarise(mean_income = mean(income))
sex_income

ggplot(data = sex_income, aes(x = sex, y = mean_income)) + geom_col()

#나이에 따른 월급 차이
class(welfare$birth) #1900~2014사이, 9999는 무응답
table(welfare$birth)
summary(welfare$birth)
table(welfare$birth)

welfare$birth = ifelse(welfare$birth == 9999, NA, welfare$birth)
table(is.na(welfare$birth))

welfare$age = 2020 - welfare$birth + 1 #파생변수 생성
qplot(welfare$age)

age_income = welfare %>%
  filter(!is.na(income)) %>%
  group_by(age) %>%
  summarise(mean_income = mean(income))
age_income
ggplot(data = age_income, aes(x = age, y = mean_income)) + geom_line()

#연령대에 따른 월급 차이
welfare = welfare %>%
  mutate(ageg = ifelse(age < 30, "young",
                       ifelse(age < 60, "middle", "old"))) #변수 추가
table(welfare$ageg)
qplot(welfare$ageg)

ageg_income = welfare %>%
  filter(!is.na(income)) %>%
  group_by(ageg) %>%
  summarise(mean_income = mean(income))
ageg_income
ggplot(data = ageg_income, aes(x = ageg, y = mean_income)) + 
  geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old")) #보통은 알파벳순 정렬. 막대 정렬 순서 설정시 활용

#연령대 및 성별 월급 차이
sex_ageg_income = welfare %>%
  filter(!is.na(income)) %>%
  group_by(ageg, sex) %>%
  summarise(mean_income = mean(income))
sex_ageg_income

ggplot(data = sex_ageg_income, aes(x = ageg, y = mean_income, fill = sex)) +
  geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old")) #성별에 따라 그래프 색상 다르게 설정하는 fill

ggplot(data = sex_ageg_income, aes(x = ageg, y = mean_income, fill = sex)) +
  geom_col(position = "dodge") +
  scale_x_discrete(limits = c("young", "middle", "old")) #막대그래프 분리하는 position파라미터

#직업별 월급 차이
class(welfare$code_job)
table(welfare$code_job)

library(readxl)
list_job = read_excel("Koweps_Codebook.xlsx", col_name = T, sheet = 2) #첫행 변수명 가져옴
head(list_job)
dim(list_job)

welfare = left_join(welfare, list_job, id = "code_job")
welfare %>%
  filter(!is.na(code_job)) %>%
  select(code_job, job) %>%
  head(10)

job_income = welfare %>%
  filter(!is.na(income) & !is.na(job)) %>%
  group_by(job) %>%
  summarise(mean_income = mean(income))
job_income

top10 = job_income %>%
  arrange(desc(mean_income)) %>%
  head(10)
top10

ggplot(data = top10, aes(x = reorder(job, mean_income), y = mean_income)) + 
  geom_col() +
  coord_flip() #그래프 오른쪽으로 90도 회전

bottom10 = job_income %>%
  arrange(mean_income) %>%
  head(10)
bottom10

ggplot(data = bottom10, aes(x = reorder(job, -mean_income), y = mean_income)) +
  geom_col() +
  coord_flip() +
  ylim(0, 850)

#성별 직업 빈도
job_male = welfare %>%
  filter(!is.na(job) & sex == "male") %>%
  group_by(job) %>%
  summarise(n=n()) %>% #빈도 셀 때
  arrange(desc(n)) %>%
  head(10)
job_male

job_female = welfare %>%
  filter(!is.na(job) & sex == "female") %>%
  group_by(job) %>%
  summarise(n=n()) %>%
  arrange(desc(n)) %>%
  head(10)
job_female

ggplot(data = job_male, aes(x = reorder(job, n), y = n)) +
  geom_col() +
  coord_flip()

ggplot(data = job_female, aes(x = reorder(job, n), y = n)) +
  geom_col() +
  coord_flip()

#종교 유무에 따른 이혼율
class(welfare$religion)
table(welfare$religion) #1 있음, 2 없음

welfare$religion = ifelse(welfare$religion == 1, "yes", "no")
table(welfare$religion)
qplot(welfare$religion)

class(welfare$marriage)
table(welfare$marriage)

welfare$marriage = ifelse(welfare$marriage == 1, "marriage",
                          ifelse(welfare$marriage == 3, "divorce", NA))
table(welfare$marriage) #빈도표에는 NA 값 산출되지 않음. 
table(is.na(welfare$marriage))
qplot(welfare$marriage)

religion_marriage = welfare %>%
  filter(!is.na(marriage)) %>%
  group_by(religion, marriage) %>%
  summarise(n= n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100, 1))
religion_marriage

religion_marriage_2 = welfare %>%
  filter(!is.na(marriage)) %>%
  count(religion, marriage) %>%
  group_by(religion) %>%
  mutate(pct = round(n/sum(n)*100, 1))
religion_marriage_2

#연령대 및 종교 유무에 따른 이혼율 분석
ageg_marriage = welfare %>%
  filter(!is.na(marriage)) %>%
  group_by(ageg, marriage) %>%
  summarise(n = n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100, 1))
ageg_marriage

ageg_divore = ageg_marriage %>%
  filter(ageg != "young" & marriage == "divorce") %>% #young 연령대 제외한 이혼값만 추출
  select(ageg, pct)
ageg_divore

ggplot(data = ageg_divore, aes(x = ageg, y = pct)) +
  geom_col()

ageg_religion_marriage = welfare %>%
  filter(!is.na(marriage) & ageg != "young") %>%
  group_by(ageg, religion, marriage) %>%
  summarise(n = n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100, 1))
ageg_religion_marriage

df_divorce = ageg_religion_marriage %>%
  filter(marriage == "divorce") %>%
  select(ageg, religion, pct)
df_divorce

ggplot(data = df_divorce, aes(x = ageg, y = pct, fill = religion)) + #fill은 막대그래프 색깔 다르게 지정
  geom_col(position = "dodge") #막대그래프 서로 분리

#지역별 연령대 비율
class(welfare$code_region)
table(welfare$code_region)

list_region = data.frame(code_region = c(1: 7),
                         region = c("서울", 
                                    "수도권(인천/경기)",
                                    "부산/경남/울산",
                                    "대구/경북",
                                    "대전/충남",
                                    "강원/충북",
                                    "광주/전남/전북/제주도"))
list_region
welfare = left_join(welfare, list_region, id = "code_region")
welfare %>%
  select(code_region, region)

region_ageg = welfare %>%
  group_by(region, ageg) %>%
  summarise(n = n()) %>%
  mutate(tot_group = sum(n)) %>%
  mutate(pct = round(n/tot_group*100, 1))
region_ageg

ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip()

list_order_old = region_ageg %>%
  filter(ageg == "old") %>%
  arrange(pct)
list_order_old

order = list_order_old$region
order

ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order) #새로 추가한 order변수 순서로 정렬/가로로 누운 모양이므로 arrange할 때 desc() 설정하지 않음

class(region_ageg$ageg)
levels(region_ageg$ageg) #character 타입이기 때문에 레벨이 없으므로 지정해야 함
region_ageg$ageg = factor(region_ageg$ageg,
                          level = c("old", "middle", "young"))
class(region_ageg$ageg) #factor로 레벨 설정 후 클래스도 변경
levels(region_ageg$ageg)

ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limits = order)

