#통계적 가설 검정

#기술 통계: 데이터 요약해 설명하는 통계 기법
#추론 통계: 어떤 값이 발생할 확률을 계산하는 통계 기법
#유의 확률(Significance prob, p-value): 실제로는 집단 간 차이가 없는데 우연히 차이가 있는 데이터가 추출될 확률

#t-test; 두 집단의 평균에 통계쩍으로 유의한 차이가 있는가?
mpg = as.data.frame(ggplot2::mpg)
library(dplyr)
mpg_diff = mpg %>%
  select(class, cty) %>%
  filter(class %in% c("compact", "suv"))
head(mpg_diff)
table(mpg_diff)

t.test(data = mpg_diff, cty~class, var.equal = T) 
#비교할 값~비교할 집단(기준)/var.equal은 집단 간 분산이 같은지 다른지
#일반적으로 p-value 5%를 판단 기준으로 삼고 유의 확률 파악. 5%보다 작으면 유의한 것으로 해석

mpg_diff2 = mpg %>%
  select(fl, cty) %>%
  filter(fl %in% c("r", "p"))

table(mpg_diff2$fl)

t.test(data = mpg_diff2, cty~fl, var.equal = T)

#상관분석(Correlation Analysis); 두 연속 변수가 서로 관련이 있는가? 0~1 사이의 상관계수(1에 가까울수록 관련성이 큼)
economics = as.data.frame(ggplot2::economics)
cor.test(economics$unemploy, economics$pce) 
#R에 내장된 cor.test 함수 활용/실업자 수와 개인 소비 지출의 상관관계 
#p-value가 0.05보다 작으므로 상관이 유의하다고 보이며 상관관계가 양수 0.61이므로 정비계 관계

#상관행렬 히트맵
head(mtcars) #R 내장 데이터;자동차 32종의 11개 속성 데이터
car_cor = cor(mtcars) #cor()이용하여 상관행렬 생성(상관계수)
round(car_cor, 2)

install.packages("corrplot")
library(corrplot)
corrplot(car_cor) #상관계수가 클수록 원이 크기가 크고 색깔이 진함. 양수면 파랑, 음수면 빨강 계열
corrplot(car_cor, method = "number") #상관계수가 숫자로 표시

col = colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(car_cor,
         method = "color",       #색깔로 표현
         col = col(200),         #색상 200개 선정
         type = "lower",         #왼쪽 아래 행렬만 표시
         order = "hclust",       #유사한 상관계수끼리 군집화
         addCoef.col = "black",  #상관계수 색깔
         tl.col = "black",       #변수명 색깔
         tl.srt = 45,            #변수명 45도 기울임
         diag = F)               #대각 행렬 제외
