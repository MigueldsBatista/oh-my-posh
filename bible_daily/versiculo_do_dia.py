from selenium import webdriver
from selenium.webdriver.common.by import By
import os
from datetime import datetime
arquivos = os.listdir("bible_daily")

today = datetime.now().strftime("%d-%m-%Y")


found=False
for arquivo in arquivos:
    if today not in arquivo and arquivo.endswith("_versiculo.txt"):
        parent_dir = os.path.abspath("bible_daily")
        abs_filepath = os.path.join(parent_dir, arquivo)
        os.remove(abs_filepath)
         

    if today in arquivo:
        found=True

if found:
    exit()



URL="https://www.bibliaonline.com.br/"

options = webdriver.ChromeOptions()

options.add_argument("headless")
options.add_argument("disable-gpu")
options.add_argument("no-sandbox")
options.add_argument("disable-dev-shm-usage")

driver = webdriver.Chrome(options=options)

driver.get(URL)

versiculo = driver.find_element(By.XPATH, "*//div[@class='block_root__NKXYU']").text


lines = versiculo.split("\n")
verse=""
for line in range(len(lines)):
    if line == 0:
        title = lines[line]
        continue
    if line == 1:
        day_of_week = lines[line]
        continue
    if line == 2:
        day_of_month = lines[line]
        continue
    if line == 3:
        month = lines[line]
        continue

    verse += lines[line] + "\n"

full_verse = f"{title}\n{day_of_week}, {day_of_month} de {month}\n{verse}"

with open(f"bible_daily/{today}_versiculo.txt", "w") as file:
    file.write(full_verse)
