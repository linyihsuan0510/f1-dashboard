-- 賽道資訊表
CREATE TABLE circuit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    country VARCHAR(50),
    lat FLOAT,
    lng FLOAT,
    length_km FLOAT,
    map_url VARCHAR(255),           -- 官方地圖連結
    map_image_url VARCHAR(512)      -- 賽道圖像url（Storage, CDN等）
);

-- 分站（每場比賽）
CREATE TABLE race_event (
    id INT PRIMARY KEY AUTO_INCREMENT,
    year INT NOT NULL,
    round INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    time TIME,
    circuit_id INT NOT NULL,
    weather VARCHAR(50),
    FOREIGN KEY (circuit_id) REFERENCES circuit(id)
);

-- 車隊
CREATE TABLE team (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50),
    logo_url VARCHAR(512)           -- 車隊logo url
);

-- 車手
CREATE TABLE driver (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(5),
    number INT,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50),
    dob DATE,
    photo_url VARCHAR(512)          -- 車手照url
);

-- 每場比賽車手成績
CREATE TABLE race_result (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    team_id INT NOT NULL,
    grid INT,
    position INT,
    points FLOAT,
    status VARCHAR(50),
    fastest_lap TIME,
    penalty_seconds FLOAT,
    FOREIGN KEY (race_id) REFERENCES race_event(id),
    FOREIGN KEY (driver_id) REFERENCES driver(id),
    FOREIGN KEY (team_id) REFERENCES team(id)
);

-- 排位賽成績
CREATE TABLE qualifying_result (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    team_id INT NOT NULL,
    q1 TIME,
    q2 TIME,
    q3 TIME,
    FOREIGN KEY (race_id) REFERENCES race_event(id),
    FOREIGN KEY (driver_id) REFERENCES driver(id),
    FOREIGN KEY (team_id) REFERENCES team(id)
);

-- 每圈圈速
CREATE TABLE lap_time (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    lap_number INT NOT NULL,
    lap_time TIME,
    sector1 TIME,
    sector2 TIME,
    sector3 TIME,
    FOREIGN KEY (race_id) REFERENCES race_event(id),
    FOREIGN KEY (driver_id) REFERENCES driver(id)
);

-- 進站資料
CREATE TABLE pit_stop (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    stop_number INT NOT NULL,
    lap_number INT,
    duration FLOAT,
    tyre VARCHAR(10),             -- 進站更換輪胎（如 S/M/H/C3）
    FOREIGN KEY (race_id) REFERENCES race_event(id),
    FOREIGN KEY (driver_id) REFERENCES driver(id)
);

-- Stint 資料：每個車手每場的所有 stint（輪胎策略段）
CREATE TABLE stint (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    stint_number INT NOT NULL,
    tyre VARCHAR(10),                  -- S/M/H/C1/C2 等
    start_lap INT NOT NULL,
    end_lap INT,
    FOREIGN KEY (race_id) REFERENCES race_event(id),
    FOREIGN KEY (driver_id) REFERENCES driver(id)
);

-- 賽後新聞標題
CREATE TABLE news (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    title VARCHAR(512) NOT NULL,
    published_at DATETIME NOT NULL,
    url VARCHAR(1024),
    FOREIGN KEY (race_id) REFERENCES race_event(id)
);

-- Reddit 熱門關鍵字
CREATE TABLE reddit_keyword (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    keyword VARCHAR(64) NOT NULL,
    count INT DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (race_id) REFERENCES race_event(id)
);

-- 懲罰紀錄
CREATE TABLE penalty (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    driver_id INT,
    type VARCHAR(64),
    value FLOAT,
    lap_number INT,
    reason VARCHAR(255),
    FOREIGN KEY (race_id) REFERENCES race_event(id),
    FOREIGN KEY (driver_id) REFERENCES driver(id)
);

-- Driver of the Day
CREATE TABLE driver_of_the_day (
    race_id INT PRIMARY KEY,
    driver_id INT NOT NULL,
    FOREIGN KEY (race_id) REFERENCES race_event(id),
    FOREIGN KEY (driver_id) REFERENCES driver(id)
);

-- Tyre Allocation（每場比賽官方指定輪胎配方）
CREATE TABLE tyre_allocation (
    race_id INT PRIMARY KEY,
    soft VARCHAR(10),
    medium VARCHAR(10),
    hard VARCHAR(10),
    note VARCHAR(255),
    FOREIGN KEY (race_id) REFERENCES race_event(id)
);

CREATE TABLE minisector_time (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    driver_id INT NOT NULL,
    lap_number INT NOT NULL,
    minisector INT NOT NULL,         -- 1~N, 每圈每段
    time FLOAT,                      -- 此mini-sector花費的秒數
    distance FLOAT,                  -- 累積距離（可選，分析賽道用）
    speed FLOAT,                     -- 平均速度（可選）
    FOREIGN KEY (race_id) REFERENCES race_event(id),
    FOREIGN KEY (driver_id) REFERENCES driver(id)
);

CREATE INDEX idx_mini_race_driver_lap ON minisector_time(race_id, driver_id, lap_number);
-- 賽事焦點／語錄
CREATE TABLE race_highlight (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    content TEXT,
    type VARCHAR(32),    -- quote, headline, etc.
    author VARCHAR(64),
    FOREIGN KEY (race_id) REFERENCES race_event(id)
);

-- 國旗圖片url（如要動態自訂）
CREATE TABLE country_flag (
    country VARCHAR(50) PRIMARY KEY,
    flag_url VARCHAR(512)
);

-- 輪胎圖片（如要多樣式/動態管理）
CREATE TABLE tyre_image (
    code VARCHAR(10) PRIMARY KEY,    -- S, M, H, C1, C2, ...
    image_url VARCHAR(512)
);

-- 可依需求加 index，例如
CREATE INDEX idx_news_race ON news(race_id);
CREATE INDEX idx_reddit_keyword_race ON reddit_keyword(race_id);
CREATE INDEX idx_penalty_race ON penalty(race_id);
CREATE INDEX idx_lap_race_driver ON lap_time(race_id, driver_id);
CREATE INDEX idx_pitstop_race_driver ON pit_stop(race_id, driver_id);
CREATE INDEX idx_stint_race_driver ON stint(race_id, driver_id);