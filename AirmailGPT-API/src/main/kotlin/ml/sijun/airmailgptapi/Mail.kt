package ml.sijun.airmailgptapi

data class Mail(
    val sender: Sender,
    val airman: Airman,
    val body: MailBody,
    val password: String
)