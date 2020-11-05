# README

最後更新時間: 2020-11-05

收集雲育鏈上面的 AWS 證照考題，包括中文與英文，  
然後再自己花時間做題目練習、解析，以及中英文對照。

上面有的證照考提包括

- Solution Architect Associate, SAA (架構師)
- Developer Associate (開發人員)
- SysOps Administrator Associate (維運人員): 仍在開發中。
- Cloud Practitioner (從業人員)

---

## 收集流程

反正沒事就點一點手機。  
正確的點法是先選「課程 or 證照類型」 > 選擇語言(點選作為 metadata 和 textdata 的分界，但其實有些不準) > 瘋狂點擊「考題練習」。

---

## 資料夾結構

- code: Rcode
- code-explain: Rmd, html
- data_original: 各種 LINE 對話的 txt 檔案 from 手機
- data-format: 清理結果。
  - filename: [category]-[cht|eng]-[update datetime]
  - table schema: [question, OptionA, OptionB, OptionC, OptionD, language, category, answer(目前沒有，需手動加入)]
- dict
  - category: 證照類別
  - language: 語言
  - metadata-example: metadata infomation 範例

---

## chatbot 機器人可改進的地方

- 題目編號: 增加題目編號，目的如下。
  - 讓使用者知道做過沒
  - 追蹤自己的學習狀況
  - 可以和別人討論時有一個依據
  - 增加功能: 指定題目去做。
- 切換語言時，rich menu 的文字應該要跟著改為該語言。
- 切換語言時，顯示提示的文字應該改成該語言。
  - 比如：「您的語系已改為英文」，應該要是 change language setting to English。這樣該母語的人才看得懂阿XD
  - 然後這樣改的話，各類別的介紹文字可能也要更著改。
- 有些題目的語系不對。就是設定改成英文了，但還是會出現中文的題目XD
- 一些格式問題
  - 全形半形
  - 選項樣式要統一。(這個很麻煩，我目前盡可能客製化全面清理了)

---

## 資料清理

儲存方式就是用存成資料表，欄位設計如下:  
[question, OptionA, OptionB, OptionC, OptionD, language, category, answer(目前沒有，需手動加入)]

- language: cht, eng
- category:
  - Solutions Architect - Associate(SAA-C02、助理架構師)
  - Developer – Associate(DVA-C01、雲端開發人員)
  - Cloud Practitioner(CLF-C01雲端從業人員)

在這樣的架構下，之後不管是要提取[語言:中文英文]，或是[不同證照:category]，都可以輕易 filter 出來。  

- crawler chatbot data from cellphone, then for-loop to do following steps
  - read data_original
  - read dict
- split data to metadata and textdata
- clean metadata
  - remove utf-8-bom
  - find language by dict-language.txt
  - find category by dict-category.txt
  - update datetime
  - filename = [category]-[language]-[update datetime]
- clean textdata
  - multi-line combine in one
  - clean option format
    - to "(A|B|C|D) "
    - delete begin and end '"'
    - clean \n and lot \n problem
  - check rows length is right or not, alert and DO NOT delete file if wrong
  - transfer to table: [question, OptionA, OptionA, OptionA, OptionA, language, category, answer(目前沒有，需手動加入)]
  - judge it has cht or all-eng
- append to last table
  - remove duplicate
- application
  - filter [category, language]
  - question.csv2txt
    - transer to txt: transpose -> unlist
    - txt2quiz: txt 可以變成空多行的題目筆記格式。
    - p.s.有一種方式是多給空的空欄位，tanspose後，直接轉。

--

目前題目都是選擇題，並有四個選項的形式。  
check rows length 就是在說這一件事。

```{txt}
題目
(A)
(B)
(C)
(D)
```

---

## 可以寫成 function 的功能

- remove utf-8-bom
- judge it has cht or all-eng
- question.csv2txt

---

## END
