exports.sendMail = async function (req, res) {

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
        document.querySelector("#senderZipcode").value = mailWritePayload.sender.Zipcode;
        document.querySelector("#senderAddr1").value = mailWritePayload.sender.address1;
        document.querySelector("#senderAddr2").value = mailWritePayload.sender.address2;
        document.querySelector("#senderName").value = mailWritePayload.sender.name;
        document.querySelector("#relationship").value = mailWritePayload.sender.relationship;
        document.querySelector("#title").value = mailWritePayload.body.title;
        document.querySelector("#content").value = mailWritePayload.body.content;
        document.querySelector("#password").value = mailWritePayload.password;
      },
      mailWritePayload.sender.zipcode,
      mailWritePayload.sender.address1,
      mailWritePayload.sender.address2,
      mailWritePayload.sender.Name,
      mailWritePayload.sender.relationship,
      mailWritePayload.body.title,
      mailWritePayload.body.content,
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