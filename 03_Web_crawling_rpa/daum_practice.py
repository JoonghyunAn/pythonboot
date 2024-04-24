import requests
from bs4 import BeautifulSoup
import os 
import pandas as pd 

url = "https://news.daum.net"

a_selector = "body > div.container-doc > main > section > div > div.content-article > div.box_g.box_news_issue > ul > li > div > div > strong > a"

user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"

def get_daum_news_list1():
    """
    This will crawl news list from Daum portal site. 
    return
        Dataframe

    raise
        Exception
    """
    res= requests.get(url,headers={"user-agent":user_agent})
    if res.status_code ==200:
        soup = BeautifulSoup(res.text, "lxml")
        a_list = soup.select(a_selector)
        result_list = []
        for a_tag in a_list:
            title = a_tag.get_text()
            link = a_tag.get("href")
            result_list.append([title.strip(),link])
        return result_list 
    else: 
        raise Exception(f"REQUEST FAILED. RESPONSE CODE :{res.satus_code}")

if __name__ == "__main__":
    result = get_daum_news_list1()
    print(len(result))
    print(result)
    from datetime import datetime
    os.makedirs("2nd_daum_news_list",exist_ok=True)
    d = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    file_path = f"2nd_daum_news_list/{d}.csv"
    result_df = pd.DataFrame(result,columns=["Title","Link"])
    result_df.to_csv(file_path, index=False)