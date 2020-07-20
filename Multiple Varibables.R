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