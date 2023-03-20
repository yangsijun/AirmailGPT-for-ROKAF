exports.sendMessage = async function (req, res) {

  const puppeteer = require("puppeteer");

  const browser = await puppeteer.launch({
    args: ["--no-sandbox", "--disable-setuid-sandbox"]
  });

  const page = await browser.newPage();

  try {
    const mailWriteUrl = req.body.mailWriteUrl;
    console.log(mailWriteUrl);

    await page.goto(mailWriteUrl);

    const mailWritePayload = req.body.mailWritePayload;
    console.log(mailWritePayload);

    await page.evaluate(
      (mailWritePayload) => {
        document.querySelector("#senderZipcode").value = mailWritePayload.senderZipcode;
        document.querySelector("#senderAddr1").value = mailWritePayload.senderAddr1;
        document.querySelector("#senderAddr2").value = mailWritePayload.senderAddr2;
        document.querySelector("#senderName").value = mailWritePayload.senderName;
        document.querySelector("#relationship").value = mailWritePayload.relationship;
        document.querySelector("#title").value = mailWritePayload.title;
        document.querySelector("#content").value = mailWritePayload.content;
        document.querySelector("#password").value = mailWritePayload.password;
      },
      mailWritePayload.senderZipcode,
      mailWritePayload.senderAddr1,
      mailWritePayload.senderAddr2,
      mailWritePayload.senderName,
      mailWritePayload.relationship,
      mailWritePayload.title,
      mailWritePayload.content,
      mailWritePayload.password
    );

    await new Promise((page) => setTimeout(page, 10000));

    await page.click(
      "#emailPic-container > form > div.UIbtn > span.wizBtn.large.Ngray.submit > input"
    );

    await browser.close();

    res.send("success");

  } catch (error) {
    console.log(error);
    await browser.close();
    res.send("error");
  }
}