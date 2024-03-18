#모듈화 작업

import os
def my_memo():
    save_dir = 'save_files'
    os.makedirs(save_dir,exist_ok=True)
    
    # 파일명 입력받기
    print("저장할 파일의 이름을 입력하세요:")
    file_name = input("파일명:")
    file_path = os.path.join(save_dir, file_name)
    
    # 파일과 연결해서 출력 작업
    ## 표준 입력(input) -> p/g -> 파일에 출력
    with open(file_path, "wt", encoding = 'utf-8') as fw:
        print("파일에 저장할 내용을 한줄씩 입력하세요")
        while True:
            # 입력
            txt = input(">>>")
            # !q의 경우 종료
            if txt == '!q':
                print("종료")
                break
            fw.write(txt+"\n")
if __name__ == "__main__":
    my_memo()
Overwriting memo.py 
# 실행하는걸로 만들거면.. 메인인지 아닌지 비교하는 조건문 작성해야함
