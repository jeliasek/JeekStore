const nodemailer = require('nodemailer')

module.exports = nodemailer.createTransport({
    host: "smtp.mailtrap.io",
    port: 2525,
    auth: {
      user: "9576804c092271",
      pass: "0f0ea18f7cd827"
    }
  });

  
