# README

- 最後更新時間: 2020-11-05
- Repository Name: R-tools

本專案收藏我所有的 Rcode，主要以專案的方式，收集我所寫過的所有 R 函數。  
未來希望可以一個專案就寫成一個套件，作為結案階段的步驟。  
基本上就是原本的專案，只抓取程式碼，並除去資料的部分後，放到這裡。

---

## 規則

稍微講述一下我自己的專案管理規範，
專案都會是一個一個的 repo，公司的專案放公司的 Gitlab，私人的專案(side project)就放 Github。

因為 Git 是程式碼管理，所以盡可能不要涉及到大資料的部分，  
而要學會把資料另外隔離，放到 DB or S3，除非是無機敏性的POC測試資料。

那這邊則是把程式碼的部分，手動拉取到 R-tools 這個資料夾下，  
也就是在 R-tools 下，"手動"建立該專案的名稱，"手動"把程式碼拖拉到這裡。

### 手動的原因

避免自動化執行會把機敏性的東西移過來XD。

---

## 注意事項

只是建立同樣名稱的專案資料夾，並把程式碼複製進來。  
所以不要再多撰寫 README.md 等其他動作!!

只是(備份)統一管理與收納，如果有需意更改任何東西，都要回到原本的專案資料夾，做修改後再複製過來!!

---

## 結構

所以依照我的專案資料夾管理來說，就是會抓取以下結構

- project
  - README.md (原本的專案的 README)
  - code: Rcode
  - code-explain: Rmd, html
  - data_test: 測試資料

如果專案資料夾下，是依照功能在開發的話的話

- project
  - README.md (原本的專案的 README)
  - Function01
    - README.md (是該功能開發的 README.md)

反正**千萬不要**再多撰寫多的文件，這邊只是複製程式碼，做統一個管理收納。

---

## END