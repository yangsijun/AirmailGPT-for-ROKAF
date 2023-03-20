package ml.sijun.airmailgptapi

import org.springframework.web.bind.annotation.*

@RestController
class MessageController {

    private final val messageService = MessageService()

    @PostMapping("/AirmailGPT-for-ROKAF/message")
    fun sendMessage(@RequestBody message: Message): String {

        return messageService.sendMessage(message)
    }
}