# daum_news_list 폴더의 csv 파일의 뉴스 링크를 이용해서
# 뉴스 상세 정보 크롤링 
# 뉴스 내용(기자, 제목,...)
# 비동기적 처리가 효율적일듯
import pandas as pd 
import asyncio
import aiohttp
from bs4 import BeautifulSoup



df = pd.read_csv(r"C:\Classes\eddie_python\03_Web_crawling_rpa\daum_news_list\2024-03-27-11-40-26.csv")
article_selector = "#mArticle > div.news_view.fs_type1 > div.article_view > section > p"
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"

async def get_news(url, session):
    """
    개별뉴스기사 내용을 조회하는 co-routine. 
    arguments:
        url: str- daum news url 
        session: ClientSession - aiohttp session
    Return:
        str: news article 
    """
    async with session.get(url) as res:
        if res.status == 200:
            html = await res.text()
            soup = BeautifulSoup(html,"lxml")
            p_list = soup.select(article_selector) # 여러개니까 select_one 말고 select
            article = [] # 뉴스기사 문단들을 저장할 리스트 
            for p in p_list :
                article.append(p.get_text())
            # 리스트 안에 문단들을 하나의 string 으로 합치기 
            # "구분자문자열".join(리스트)
            return '\n.join(article)'


async def main(links):
    """_summary_
    get_news co-routines will run as task, created with url of individual articles. 


    Args:
        links (list): url for crawling
    Return:
        list: all articles crawled
    """
    async with aiohttp.ClientSession(headers={"user-agent":user_agent}) as session:
        result = await asyncio.gather[*get_news(url,session) for url in links] # 가변인자 args.. 리스트 안에 있는걸 풀어서 넣어줘야.. *   # gather는 create task 할 필요 없음 알아서 해줌
    return result# await 하다가 값을 다 모아서 return


if __name__ == "__main__":
    import time
    #뉴스기사 링크 조회 
    news_list_path = r"daum_news_list/2024-03-27-11-40-26.csv"
    df = pd.read_csv(news_list_path)
    links = df['링크주소'] # file's column name
    s = time.time() 
    result = asyncio.run(main(links)) # run main co-routine 

    e = time.time()
    print(f"걸린시간:{e-s}초")
    print("기사개수:", len(result))
    print(result[0])
    df['기사내용'] = result
    # DataFrame(테이블-표) 기사내용 컬럼 추가. 그 컬럼의 값으로 result를 대입. 
    # 데이터프레임의 내용을 csv 파일로 저장. 
    df.to_csv(news_list_path, index=False)







# links = df['링크주소']
# #print(links)
# for link in links:
#     print(link)
