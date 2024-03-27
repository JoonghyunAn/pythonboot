## news.daum.net
## 뉴스목록에서 '뉴스제목', '링크주소' 조회
# 美中日 금리 변동기···‘파킹형 자금’ 1년 9개월만에 최대
# https://v.daum.net/v/20240326171359564
# body > div.container-doc > main > section > div > div.content-article > div.box_g.box_news_issue > ul > li

#내 시도
# from bs4 import BeautifulSoup
# import requests
# from pprint import pprint
# url = "https://news.daum.net/"
# user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
# ## 요청 
# res = requests.get(url, headers={'user-agent':user_agent})
# ## 응답 데이터 처리 
# if res.status_code == 200:
#     # 2. 내가 필요한 데이터를 어떻게 가져올지(css selector)
#     ### BeautifulSoup을 이용해서 원하는 정보 조회 
#     soup = BeautifulSoup(res.text, 'lxml')
#     green_list = soup.select('body > div.container-doc > main > section > div > div.content-article > div.box_g.box_news_issue > ul > li')
#     search_names = []
#     for tag in green_list: 
#         search_names.append(tag.text.strip())
#         result = [name.replace("\n", " ")for name in search_names]
        
# else:
#     print("실패:", res.status_code)

# pprint(result)

import requests
from bs4 import BeautifulSoup
import os 
import pandas as pd 

url = "https://news.daum.net"
# 뉴스제목 : a's content, link address : a's href attribute 
a_selector =  "body > div.container-doc > main > section > div > div.content-article > div.box_g.box_news_issue > ul > li> div > div > strong > a" 


# user-agent : 개발자도구>콘솔 : navigator.userAgent
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"

def get_daum_news_list(): 
    """
    Daum news list will be crawled
    
    arguments(or parameter)
    return
        DataFrame: 조회결과들을 담은 DataFrame(표)
    raise
        Exception: 처리 실패 시 발생
    """
    # 1. 요청 
    res = requests.get(url, headers={"user-agent":user_agent})
    if res.status_code ==200:
        # 2. 응답결과 html을 BS4에 넣어서 instance 생성 
        soup = BeautifulSoup(res.text, "lxml") # ctrl + enter 
        # 3. selector 이용해서 조회 
        a_list = soup.select(a_selector)
        result_list = []
        # 4. 원하는 값들 추출(title, link)
        for a_tag in a_list:
            title = a_tag.get_text() # tag의 text 내용  # alt + up or down - 줄 바꿔줌 
            link = a_tag.get("href") # href 속성 값
            result_list.append([title.strip(), link])
        return result_list # 반복문 끝났으니, 이걸 리턴해
    
    else:
        raise Exception(f"요청실패. 응답코드:{res.status_code}")


    
    

if __name__ == "__main__": # 메인모듈이니 서브모듈이니.. import가 서브모듈 
    result = get_daum_news_list()
    #print(result)
    print(len(result))
    print(result)
    from datetime import datetime
    os.makedirs("daum_news_list",exist_ok=True)
    # 저장할 파일명 - 특정 주기마다 크롤링 수행할 경우 실행 날짜/시간을 이용해서 만들어 준다. 
    d = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    file_path = f"daum_news_list/{d}.csv" # 이런식으로 저장해야겠다
    # dataframe 생성
    result_df = pd.DataFrame(result,columns=["제목","링크주소"] )
    # save as csvfile 
    result_df.to_csv(file_path, index=False ) # file_path에 저장할거
    


# save as CSV file 
# Comma Seperate Value 
# write tables on text file 
#  row(enter) column(,) 
# hong,20,incheon
# Kim,30,LA
# Davis,32,Davis
    
# pandas module(library) to save as csv file

# daum_news_list 폴더의 csv 파일의 뉴스 링크를 이용해서
# 뉴스 상세 정보 크롤링 
#뉴스 내용(기자, 제목,...)
