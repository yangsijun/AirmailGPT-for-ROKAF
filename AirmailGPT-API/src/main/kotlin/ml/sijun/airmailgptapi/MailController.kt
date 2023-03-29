package ml.sijun.airmailgptapi

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.web.bind.annotation.*

@RestController
class MailController {

    private final val service = MailService()

    @PostMapping("/AirmailGPT-for-ROKAF/mails")
    fun sendMail(@RequestBody mail: Mail): String {
        return service.sendMail(mail)
    }

    @PostMapping("/AirmailGPT-for-ROKAF/mails/generate")
    fun generateAiMail(@RequestBody generator: AiMailGenerator): MailBody {
        val response = service.requestToChatGPT(generator)
        val mailBody = processResponse(response)

        println("title: ${mailBody.title}")
        println("content: ${mailBody.content}")

        return mailBody
    }

    // processing the response from ChatGPT
    private fun processResponse(response: String): MailBody {
        try {
            val objectMapper = ObjectMapper()
            val responseMap = objectMapper.readValue(response, Map::class.java) as Map<String, Any>
            val choices = responseMap["choices"] as List<Map<String, Any>>
            val choice = choices[0]
            val message = choice["message"] as Map<String, Any>
            var content = message["content"] as String

            // remove the blank line at very beginning
            for (c in content) {
                if (c != '\n')
                    break
                content = content.substring(1)
            }

            val mailBodyTitle = content.split("\n")[0]
            val mailBodyContent = content.substring(mailBodyTitle.length + 1)

            return MailBody(
                title = mailBodyTitle,
                content = mailBodyContent
            )
        } catch (e: Exception) {
            throw AiMailGeneratorException("ChatGPT API 응답 처리 중 오류가 발생했습니다.", e)
        }
    }
}