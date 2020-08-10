#텍스트 마이닝

#한글 자연어 분석 패키지인 KoNLP 활용한 한글 데이터 형태소 분석(자바 설치 필요)

getwd()
install.packages("rJava")
install.packages("memoise")

#RStudio에서 KoNLP 설치 시 나타나는 오류 해결 방법(출처; https://r-pyomega.tistory.com/12)
install.packages("multilinguer")
library(multilinguer)
install_jdk()
install.packages(c('stringr', 'hash', 'tau', 'Sejong', 'RSQLite', 'devtools'), type = "binary")
install.packages("remotes")

remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))
library(KoNLP) #최종적으로 "KoNLP" 패키지를 불러옵니다

devtools::install_github('haven-jeon/NIADic/NIADic', build_vignettes = TRUE)
Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_251')  # 설치한 JAVA version에 따라 달라집니다
buildDictionary(ext_dic = "woorimalsam")  # "woorimalsam" dic을 불러옵니다
useNIADic()  # "NIADic" dic 로드. 98만개 단어로 구성된 사전


#데이터 불러오기
txt = readLines("hiphop.txt") 
head(txt)

#특수문자 제거(데이터 전처리)
library(stringr)
txt = str_replace_all(txt, "\\W", " ") #'\\W'는 특수문자 의미하는 정규표현식

#가장 많이 사용된 단어 추출
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")

nouns = extractNoun(txt)
unlist(nouns)
wordcount = table(unlist(nouns)) #unlist는 리스트를 문자열 벡터로 전환
df_word = as.data.frame(wordcount, stringsAsFactors = F)
df_word = rename(df_word, word = Var1,
                 freq = Freq)
nouns
wordcount
df_word

#두 글자 이상 단어 추출
df_word = filter(df_word, nchar(word) >= 2) #단어는 두 글자 이상으로 된 것이 기본
top20 = df_word %>%
  arrange(desc(freq)) %>%
  head(20)
top20

#워드클라우드 만들기
install.packages("wordcloud")
library(wordcloud)
library(RColorBrewer) #글자색깔 표현

pal = brewer.pal(8, "Dark2") #RColorBrewer 패키지. 단어 색깔 지정 시 사용할 색상 코드 목록. Dark2 목록에서 8개 추출
set.seed(1234) #워드클라우드는 함수 실행할 때마다 난수 이용해 매번 다른 모양으로 워드 클라우드 생성. 항상 동일한 모양 생성되도록 실행 전 난수를 고정하는 역할

wordcloud(words = df_word$word, #단어
          freq = df_word$freq,  #빈도
          min.freq = 2,         
          max.words = 200,
          random.order = F,     #고빈도 단어 중앙 배치
          rot.per = 0.1,         #회전 단어 비율
          scale = c(4, 0.3),    #단어 크기 범위
          colors = pal)         #색상 목록

#색상바꾸기
pal = brewer.pal(9, "Blues")[5:9]
set.seed(1234)
wordcloud(words = df_word$word, 
          freq = df_word$freq,
          min.freq = 2,         
          max.words = 200,
          random.order = F,     
          rot.per = 0.1,         
          scale = c(4, 0.3),    
          colors = pal)         

#국정원 트윗 텍스트 마이닝
twitter = read.csv("twitter.csv",
                   header = T,
                   stringsAsFactors = F,
                   fileEncoding = "UTF-8")


twitter = rename(twitter,
                 no = 번호,
                 id = 계정이름,
                 date = 작성일,
                 tw = 내용)
twitter = str_replace_all(twitter$tw, "\\W", " ")
head(twitter)

nouns = extractNoun(twitter)
wordcount = table(unlist(nouns))
df_word = as.data.frame(wordcount, stringsAsFactors = F)
df_word = rename(df_word,
                   word = Var1,
                   freq = Freq)
df_word = filter(df_word, nchar(word) >= 2)
top20 = df_word %>%
  arrange(desc(freq)) %>%
  head(20)
top20

library(ggplot2)

order = arrange(top20, freq)$word #빈도 순서 변수 생성
ggplot(data = top20, aes(x = word, y = freq)) +
  ylim(0, 2500) +
  geom_col() +
  coord_flip() +
  scale_x_discrete(limit = order) +
  geom_text(aes(label = freq), hjust = -0.3) #그래프에 빈도 표시, hjust는 띄어진 정도

pal = brewer.pal(8, "Dark2")
set.seed(1234)
wordcloud(words = df_word$word, 
          freq = df_word$freq,
          min.freq = 10,         
          max.words = 200,
          random.order = F,     
          rot.per = 0.1,         
          scale = c(6, 0.2),    
          colors = pal)     
