#plotly 패키지로 인터랙티브 그래프 만들기

install.packages("plotly")
library(plotly)
library(ggplot2)

p = ggplot(data = mpg, aes(x = displ, y = hwy, col = drv)) + geom_point()
ggplotly(p)

q = ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")
ggplotly(q)

#dygraphs 패키지로 인터랙티브 시계열 그래프 만들기
install.packages("dygraphs")
library(dygraphs)

economics = ggplot2::economics
head(economics)

library(xts) #시간 순서 속성을 지니는 xts데이터 타입
eco = xts(economics$unemploy, order.by = economics$date)
head(eco)
dygraph(eco)
dygraph(eco) %>% dyRangeSelector() #그래프 아래 날짜 범위 선택 기능 추가

#여러 값 동시에 시계열 데이터 나타내기
eco_a = xts(economics$psavert, order.by = economics$date)
eco_b = xts(economics$unemploy/1000, order.by = economics$date) #100만 명 단위

eco2 = cbind(eco_a, eco_b) #가로로 결합
colnames(eco2) = c("psavert", "unemploy")
head(eco2)
dygraph(eco2) %>% dyRangeSelector()
