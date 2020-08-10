#지도시각화

#미국 주별 강력 범죄율 단계 구분도

install.packages("ggiraphExtra")
install.packages("maps")
install.packages("mapproj")

library(ggiraphExtra)

str(USArrests) #R에 내장된 데이터. 1973년 미국 주별 강력 범죄율 정보
head(USArrests)

library(tibble) #dplyr 내 패키지
crime = rownames_to_column(USArrests, var = "state") #행이름을 변수로 바꾸는 패키지
crime$state = tolower(crime$state) #소문자로 수정
str(crime)

library(ggplot2)
states_map = map_data("state")
str(states_map)

ggChoropleth(data = crime,         
             aes(fill = Murder,    #색깔로 표현할 변수
                 map_id = state),  #지역 기준 변수
             map = states_map)     #지도 데이터

#인터랙티브 단계 구분도
ggChoropleth(data = crime,         
             aes(fill = Murder,    
                 map_id = state),  
             map = states_map,
             interactive = T)      #인터랙티브 설정(마우스 움직임에 반응)


#대한민국 시도별 인구 수 단계 구분도

install.packages("stringi")
install.packages("devtools")
devtools::install_github("cardiomoon/kormaps2014") #깃허브에 공유된 패키지 설치
library(kormaps2014) 
library(dplyr)

options(encoding = "UTF-8")
str(changeCode(korpop1)) #CP949로 인코딩

korpop1 = rename(korpop1,
                 pop = 총인구_명,
                 name = 행정구역별_읍면동)
str(changeCode(kormap1))

ggChoropleth(data = korpop1,
             aes(fill = pop,
                 map_id = code,    #지역 기준 변수
                 tooltip = name),  #지도 위에 표시할 지역명
             map = kormap1,
             interactive = T)

#대한민국 시도별 결핵 환자 수 단계 구분도
tbc = kormaps2014::tbc
str(changeCode(tbc)) #지역별 결핵 환자 수에 대한 데이터

ggChoropleth(data = kormaps2014::tbc,
             aes(fill = NewPts,
                 map_id = code,
                 tooltip = name),
             map = kormap1,
             interactive = T)
