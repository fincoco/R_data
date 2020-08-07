#그래프 표현
#gglot2 문법은 레이어 구조; 배경>그래프 형태(점, 막대, 선)>축범위, 색, 표식 등 설정 추가)

library(ggplot2)
library(dplyr)

#산점도(Scater Plot) geom_point()
ggplot(data = mpg, aes(x = displ, y =hwy)) #배경설정, aes에 x, y축 변수 지정
ggplot(data = mpg, aes(x = displ, y =hwy)) + geom_point() #산점도 추가
ggplot(data = mpg, aes(x = displ, y =hwy)) + geom_point() + xlim(3, 6) + ylim(20, 30) #축 범위 조정

#막대 그래프(Bar Chart) geom_col()
df_mpg = mpg %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy))

df_mpg

ggplot(data= df_mpg, aes(x = drv, y = mean_hwy)) + geom_col()
ggplot(data= df_mpg, aes(x = reorder(drv, -mean_hwy), y = mean_hwy)) + geom_col() #reorder(x축 변수, 정렬 기준)

#빈도 막대그래프 geom_bar()
ggplot(data = mpg, aes(x = drv)) + geom_bar() #세로축이 count, x축만 지정

#연습문제
mpg_q1 = mpg %>%
  filter(class == "suv") %>%
  group_by(manufacturer) %>%
  summarise(mean_cty = mean(cty)) %>%
  arrange(desc(mean_cty)) %>%
  head(5)
ggplot(data = mpg_q1, aes(x = reorder(manufacturer, -mean_cty), y = mean_cty)) +geom_col()

ggplot(data = mpg, aes(x = class)) + geom_bar()

#선 그래프(Line Chart) geom_line()
ggplot(data = economics, aes(x = date, y = unemploy)) + geom_line()
ggplot(data = economics, aes(x = date, y = psavert)) + geom_line()

#상자 그림(Box Plot) geom_boxplot()
ggplot(data = mpg, aes(x = drv, y = hwy)) + geom_boxplot()

mpg_class = mpg %>%
  filter(class %in% c("compact", "subcompact", "suv")) %>%
  select(class, cty)
mpg_class
ggplot(data = mpg_class, aes(x = class, y = cty)) +geom_boxplot()
