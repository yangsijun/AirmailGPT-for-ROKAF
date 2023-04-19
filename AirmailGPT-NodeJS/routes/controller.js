exports.sendMail = async function (req, res) {

  const puppeteer = require("puppeteer");

  const browser = await puppeteer.launch({
    args: ["--no-sandbox", "--disable-setuid-sandbox"]
  });

  const page = await browser.newPage();

  try {
    console.log(req.body);

    const mailWriteUrl = req.body.mailWriteUrl;
    console.log(mailWriteUrl);

    await page.goto(mailWriteUrl);

    const mailWritePayload = req.body.mailWritePayload;
    console.log(mailWritePayload);

    const senderZipcode = mailWritePayload.sender.zipCode;
    const senderAddr1 = mailWritePayload.sender.address1;
    const senderAddr2 = mailWritePayload.sender.address2;
    const senderName = mailWritePayload.sender.name;
    const relationship = mailWritePayload.sender.relationship;
    const title = mailWritePayload.body.title;
    const contents = mailWritePayload.body.content;
    const password = mailWritePayload.password;

    await page.evaluate(
      // (mailWritePayload) => {
      (senderZipcode, senderAddr1, senderAddr2, senderName, relationship, title, contents, password) => {
        document.querySelector("#senderZipcode").value = senderZipcode;
        document.querySelector("#senderAddr1").value = senderAddr1;
        document.querySelector("#senderAddr2").value = senderAddr2;
        document.querySelector("#senderName").value = senderName;
        document.querySelector("#relationship").value = relationship;
        document.querySelector("#title").value = title;
        document.querySelector("#contents").value = contents;
        document.querySelector("#password").value = password;
      },
      // mailWritePayload
      senderZipcode,
      senderAddr1,
      senderAddr2,
      senderName,
      relationship,
      title,
      contents,
      password
    );

    await new Promise((page) => setTimeout(page, 10000));

    await page.click(
      "#emailPic-container > form > div.UIbtn > span.wizBtn.large.Ngray.submit > input"
    );

    await browser.close();
    console.log("success");
    res.send("success");
    console.log("success!")
  } catch (error) {
    console.log(error);
    await browser.close();
    res.send("error");
  }
}

exports.test = async function (req, res) {
  const puppeteer = require("puppeteer");

  const browser = await puppeteer.launch({
    args: ["--no-sandbox", "--disable-setuid-sandbox"]
  });

  const page = await browser.newPage();

  try {
    console.log(req.body);

    const mailWriteUrl = req.body.mailWriteUrl;
    console.log(mailWriteUrl);

    await page.goto(mailWriteUrl);

    const mailWritePayload = req.body.mailWritePayload;
    console.log(mailWritePayload);

    const senderZipcode = mailWritePayload.sender.zipCode;
    const senderAddr1 = mailWritePayload.sender.address1;
    const senderAddr2 = mailWritePayload.sender.address2;
    const senderName = mailWritePayload.sender.name;
    const relationship = mailWritePayload.sender.relationship;
    const title = mailWritePayload.body.title;
    const contents = mailWritePayload.body.content;
    const password = mailWritePayload.password;

    await page.evaluate(
      // (mailWritePayload) => {
      (senderZipcode, senderAddr1, senderAddr2, senderName, relationship, title, contents, password) => {
        document.querySelector("#senderZipcode").value = senderZipcode;
        document.querySelector("#senderAddr1").value = senderAddr1;
        document.querySelector("#senderAddr2").value = senderAddr2;
        document.querySelector("#senderName").value = senderName;
        document.querySelector("#relationship").value = relationship;
        document.querySelector("#title").value = title;
        document.querySelector("#contents").value = contents;
        document.querySelector("#password").value = password;
      },
      // mailWritePayload
      senderZipcode,
      senderAddr1,
      senderAddr2,
      senderName,
      relationship,
      title,
      contents,
      password
    );

    await new Promise((page) => setTimeout(page, 10000));

    // await page.click(
    //   "#emailPic-container > form > div.UIbtn > span.wizBtn.large.Ngray.submit > input"
    // );

    await browser.close();

    console.log("success");
    res.send("success");
    console.log("success!")
  } catch (error) {
    console.log(error);
    await browser.close();
    res.send("error");
  }
}