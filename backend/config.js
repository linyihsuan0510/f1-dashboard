require('dotenv').config();

module.exports = {
  port: process.env.BACKEND_PORT || 8000,
  dbHost: process.env.DB_HOST || 'localhost',
  dbUser: process.env.DB_USER || 'root',
  dbPassword: process.env.MYSQL_ROOT_PASSWORD || '',
  dbName: process.env.DB_NAME || 'f1_dashboard',
  redisHost: process.env.REDIS_HOST || 'localhost',
  redisPort: process.env.REDIS_PORT || 6379,
};