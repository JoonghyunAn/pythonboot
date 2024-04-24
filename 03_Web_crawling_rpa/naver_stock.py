# finance.naver.com(네이버>증권>국내증시>시가총액)
# 시가총액 정보(표)의 내용을 크롤링
# (N(번호), 토론실 빼고 조회
# 1	삼성전자	80,000	상승 200	+0.25%	100	4,775,826	5,969,783	55.10	10,005,130	37.54	4.15

# 1. url ==> 페이지번호
#   : https://finance.naver.com/sise/sise_market_sum.naver?&page={NO}
#   : page 번호 : 1~44
# 2. 조회할 항목 -> SELECTOR
#   : TR SELECT: #contentarea > div.box_type_l > table.type_2 > tbody > tr
# 3. 저장방식 (CSV)
# 비동기적? 동기적? table tag? 
# #contentarea > div.box_type_l > table.type_2 > tbody > tr

import time
import datetime
import os
import asyncio
import aiohttp
import pandas as pd 
from bs4 import BeautifulSoup

user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
url_layout = "https://finance.naver.com/sise/sise_market_sum.naver?&page={}"
# url_layout.format()
tr_selector = "#contentarea > div.box_type_l > table.type_2 > tbody > tr"

async def get_page_info(url, session):
    """
    naver stock info 개별  page url 받아서 그 페이지 내용을 조회 코루틴 
    Return:
        list: 중첩 리스트로 정의. 한 줄의 내용을 리스트로 묶고 그것들 모두 담은 리스트.
        [
            [td1,td2,...,td11], # 1줄
            [td1,td2,...,td11], # 2줄
            ...
        ]

    """
    async with session.get(url) as res:
        if res.status == 200:
            html = await res.text()
            soup = BeautifulSoup(html, "lxml") # 코루틴이 아니고 함수이기 때문에 await 붙이지 않아도 됨 
            # page내의 모든 tr(행)들을 조회
            tr_list = soup.select(tr_selector)

            result_list = [] # 모든 행들의 정보를 담을 리스트
            ## 개별 행(tr) 처리
            for tr in tr_list: # 각 행 tr(element) 안의 자손인 td를 찾는 것  # 이 for문은 tr을 돌리는거고.. 하나 돌리면 리스트가 [[1],[2],...]
                # 개별 행(tr) 안의 td들을 조회 
                td_list = tr.find_all("td")
                if len(td_list) == 1: # td가 1개인 tr -> 5개당 하나씩 나오는 구분선 
                    continue
                tr_content_list = [] # 한 행의 cell 정보(td들의 값)들을 담을 리스트.
                for idx,td in enumerate(td_list): # cell별로 따로 처리하는 것들이 있으므로 enumerate 사용 
                    if idx == 0 or idx == 12: # 첫번째 (n) 항목과 마지막(토론식) 내용은 저장하지 않음.
                        continue 
                    txt = td.get_text().strip().replace(",","") # 쉼표제거 #왼쪽부터 오른쪽으로 순차적 수행 .. 체인방식
                    ## 전일비. 이미지를 이용해서 상승인지 하락인지 조회 #요소복사 시 태그내용 그대로 복사가능 
                    if idx == 3:  
                        # td 자식으로 이미지 태그 조회.(있으면 상한/하한,없으면 보합)
                        img = td.find("img")
                        alt_txt = ""
                        if img != None: #하위에 img태그가 있으면
                            image_name = img.get("src") # image의 src 속성값 조회
                            if image_name.endswith("ico_up.gif") or image_name.endswith("ico_up02.gif"):
                                alt_txt = '+'
                            else:
                                alt_txt = "-"
                        txt = alt_txt + txt
                    tr_content_list.append(txt) # for문 빠져나오면 한 줄에 대한 처리가 끝나서 tr_content_list에 넣고.. 
                result_list.append(tr_content_list) # tr_content_list 처리 끝나면 result_list에 넣기 
            return result_list








async def main():
    """
    조회할 page들의 url을 이용해서 get_page_info 코루틴들을 생성해서 start
    결과를 취합해서 반환. 
    """
    # url_layout. format(page_no)
    async with aiohttp.ClientSession(headers={"user-agent":user_agent}) as session:
        result = await asyncio.gather(*[get_page_info(url_layout.format(page_no),session) for page_no in range(1,45)]) # 44개가 만들어짐

    return result


if __name__ == "__main__" : # 다른데서 import 할 일 없으면 이거 필요없음. 근데 여기서부터 메인이에요 라고 표시해주는 것이기도 함!
    s = time.time()
    result = asyncio.run(main())
    e = time.time()
    print(f"걸린시간: {e-s}초")
    print(len(result))
    print(len(result[0]))
    print(result)


    ### 받아온 결과를 파일로 저장 
    ### stock_info/실행날짜.csv
    ### 리스트 중첩 3번 되어있음 
    ### result 형태 (44, 50, 11) (페이지수,페이지 당 행수, 행당 컬럼수)
    #### 테이블 형태의 리스트로 만들기. (44,50,11)  -> (44*50,11)
    result_list = []
    for page_list in result:
        result_list += page_list
    
    column_name = ["종목명","현재가","전일비","등락률","액면가","시가총액","상장주식","외국인비","거래량","PER","ROE"]
    ## list -> DataFrame
    df = pd.DataFrame(result_list, columns=column_name)

    ##저장 디렉토리 생성
    os.makedirs('stock_info',exist_ok=True)
    
    ## 파일명 - %Y-$m-$d
    c_day = datetime.date.today().strftime("%Y-%m-%d")
    file_path = f"stock_info/{c_day}.csv"
    df.to_csv(file_path, index=False)
    print(">>>>>>>>>>>complete<<<<<<<<<<<")










#### what I did 
# import requests
# from bs4 import BeautifulSoup
# import os 
# import pandas as pd 

# url = "https://finance.naver.com/sise/sise_market_sum.naver?&page=1"

# # 칼럼 잘 뽑아내면, 셀렉터 대체하기 
# "#contentarea > div.box_type_l > table.type_2 > tbody > tr > td"
# a_selector = "#contentarea > div.box_type_l > table.type_2 > tbody > tr:nth-child(2) > td"
# user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"

# def get_stock_list():
#     """_summary_
#     this is to check stock market status 

#     Raises:
#         Exception: _description_

#     Returns:
#         _type_: _description_
#     """
    
#     res = requests.get(url, headers={"user-agent":user_agent})
#     if res.status_code == 200:
#         soup = BeautifulSoup(res.text,"lxml")
#         tbb = soup.find_all('td')
        
#         result_list = []
#         for  in da:
            
            
#             result_list.append(da)
#         return result_list

#     else:
#         raise Exception(f"REQUEST FAILED. RESPONSE CODE : {res.status_code}")

# if __name__ == "__main__":
#     result = get_stock_list()
#     from datetime import datetime
#     os.makedirs("stock_price", exist_ok=True)
#     d = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
#     file_path = f"stock_price/{d}.csv"
#     result_df = pd.DataFrame(result, columns=["comp",1])
#     result_df.to_csv(file_path, index=False)
