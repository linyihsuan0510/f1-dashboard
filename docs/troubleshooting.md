## Known Issues / Troubleshooting

### Docker Compose build 於 macOS 出現 "Dockerfile cannot be empty" 錯誤

- 問題描述：  
  在 macOS 使用 Docker Desktop + Docker Compose build 時，部分服務會因 build context 問題失敗，顯示 "Dockerfile cannot be empty"。
  
- 影響範圍：  
  多數發生於 macOS 環境，特定目錄含隱藏檔或權限異常時容易出現。其他 OS（Linux、Windows）或雲端環境較少遇到。

- 臨時解決方案：  
  1. 單獨手動 build 該服務的 Docker image，如：  
     ```bash
     cd etl
     docker build -t f1-etl .
     ```
  2. 修改 `docker-compose.yml` 使該服務改用已 build 的 image，避免 compose build：  
     ```yaml
     etl:
       image: f1-etl
       depends_on:
         - db
     ```
  3. 清理 Docker cache，並完全重啟 Docker Desktop。

- 其他建議：  
  - 試著刪除並重新建立出問題的資料夾，避免 macOS 檔案系統快取異常。  
  - 等待 Docker 官方更新解決此問題。

---