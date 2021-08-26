JeekStore

- npm install
- npm start

-congigurar postgres na pasta src/config

const { Pool } = require("pg")

module.exports = new Pool({
    user: "",
    password: "",
    host: "",
    port: ,
    database: ""
})

