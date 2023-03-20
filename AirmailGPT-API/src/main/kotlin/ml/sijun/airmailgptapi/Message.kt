package ml.sijun.airmailgptapi

data class Message(
    val airmanName: String,
    val airmanBirth: String,
    val senderName: String,
    val relation: String,
    val seed: String,
    val password: String,
)