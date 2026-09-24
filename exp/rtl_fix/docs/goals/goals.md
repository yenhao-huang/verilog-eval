background: 看完 RTLFix 論文後，我了解到 ReACT prompt 與 RAG error tooling 的重要性，但還未實驗分析。
goal: 現在我希望量化得到確切實驗數據，來證實論文的有效性。
workflow: 
1. 從論文中複製原有的 ReAct prompt 到目錄內
2. 建立簡易 agentic 框架，能夠執行 2 種工具 (1. 能夠使用 compiler 工具 2. 能夠 RAG 來取得 compiler error 的實際解決方法)
3. 實驗: 1. 驗證不同 models 使用 compiler 工具下的 A/B Test (測試模型: qwen38_next、gemmas-a4-26b)，測試指標包含準確率、時間、消耗 token 數、錯誤題型分布。
4. 匯出 acceptance/reports.md、acceptance/reproduce.md、acceptance/details/。reports.md 要遵守 a. 內容要簡單清晰 b. 內容至少包含實驗設定、實驗結果 c. 重要實驗結果擺上面 d. 盡量多組態比較使用表格比較。reproduce.md: 人類能夠一步一步重現你的實驗的檔案。


環境
model: /home/wingene/howard/models/
vllm docker compose file: /home/wingene/howard/vllm/


git 版本管理
https://github.com/yenhao-huang/verilog-eval/tree/main
1. 開始前發 issue、結束後發 PR

注意
1. 實驗相關檔案必須寫在 exp/rtl_fix 
2. 注意分層
