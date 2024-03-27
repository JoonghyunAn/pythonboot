# daum_news_list 폴더의 csv 파일의 뉴스 링크를 이용해서
# 뉴스 상세 정보 크롤링 
# 뉴스 내용(기자, 제목,...)
# 비동기적 처리가 효율적일듯
import pandas as pd 
df = pd.read_csv(r"C:\Classes\eddie_python\03_Web_crawling_rpa\daum_news_list\2024-03-27-11-40-26.csv")
links = df['링크주소']
#print(links)
for link in links:
    print(link)
