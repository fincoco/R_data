#R 내장 함수 활용과 변수타입

exam = read.csv("csv_exam.csv")
exam[] #전체 데이터 출력
exam[1, ] #n행 추출
exam[exam$class ==1, ] #class가 1인 행 추출
exam[exam$math >= 80, ]
exam[exam$class == 1 & exam$math >= 50, ]
exam[ , 1] #첫 번째 열 추출
exam[ , "class"] #class 변수 추출출
exam[ , c("class", "math", "english")]
exam[1, 3] #1행 3열 추출, 부등호 조건 등도 모두 가능

#연속 변수(Continuous Variable); 연속적이고 크기를 의미하는 값으로 구성 (=양적변수, numeric)
#범주 변수(Categorical Varivable); 대상을 분류하는 의미 (=명목 변수, factor)

var1 = c(1, 2, 3, 1, 2)
var2 = factor(c(1, 2, 3, 1, 2))

var1
var2 #factor이기 때문에 Levels가 출력(어떤 범주로 구성되어 있는지 표시), 연산 불가능

class(var1)
class(var2)

levels(var1) #factor가 아니면 NULL 출력
levels(var2)

#변수 타입 바꾸기; as.numeric(), as.factor(), as.character(), as.Date(), as.data.frame()
var2 = as.numeric(var2)
mean(var2)
class(var2)

#데이터 구조
a = matrix(c(1:12), ncol = 2) #데이터프레임과 달리 변수 타입 한 가지
b = array(1:20, dim = c(2, 5, 2)) #2차원 이상으로 구성된 매트릭스, 변수 타입 한 가지

