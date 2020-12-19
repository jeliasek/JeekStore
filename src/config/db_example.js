const { Pool } = require("pg")

module.exports = new Pool({
    user: "user_db",
    password: "password_db",
    host: "localhost_or_ip_db",
    port: 5432,
    database: "name_db"
})

// 1 - PUT YOUR DATA ACCESS TO THE POSTGRES DATABASE
// 2 - RENAME THE FILE "db_example.js" FOR "db.js"