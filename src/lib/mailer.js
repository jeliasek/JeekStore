const nodemailer = require('nodemailer')

module.exports = nodemailer.createTransport({
    host: "smtp.mailtrap.io",
    port: 2525,
    auth: {
      user: "159ddbb80a9458",
      pass: "b70b54e5cc6d4c"
    }
  })