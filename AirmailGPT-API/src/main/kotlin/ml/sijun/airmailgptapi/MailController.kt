package ml.sijun.airmailgptapi

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.web.bind.annotation.*

@CrossOrigin
@RestController
class MailController {

    private final val service = MailService()

    @PostMapping(value = ["/mails"], produces = ["application/json;charset=UTF-8"])
    fun sendMail(@RequestBody mail: Mail): Map<String, String> {
        return mapOf("isSuccess" to service.sendMail(mail))
    }

    @PostMapping(value = ["/test"], produces = ["application/json;charset=UTF-8"])
    fun testSendMail(@RequestBody mail: Mail): Map<String, String> {
        return mapOf("isSuccess" to service.testSendMail(mail))
    }

    @PostMapping(value = ["/mails/generate"], produces = ["application/json;charset=UTF-8"])
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

    @GetMapping(value = ["/"], produces = ["application/json;charset=UTF-8"])
    fun getHello(): String {
        return "Hello, World!"
    }

    @PostMapping(value = ["/mails/listUrl"], produces = ["application/json;charset=UTF-8"])
    fun getMailListUrl(@RequestBody airman: Airman): Map<String, String> {
        println("airman: ${airman.name}, ${airman.birth}")
        return mapOf("mailListUrl" to service.getMailListUrl(airman))
    }

    @PostMapping(value = ["/football/fixtures"], produces = ["application/json;charset=UTF-8"])
    fun sendFootballFixturesByLeagueId(@RequestBody param: Map<String, Any>): Map<String, String> {
        try {
            val fixtures = service.getFootballFixture(
                param["league"] as Number,
                param["season"] as Number,
                param["from"] as String,
                param["to"] as String
            )
            service.sendMail(
                Mail(
                    sender = Sender(
                        name = "AirMailGPT Football",
                        relationship = "Auto Generated",
                        zipCode = "00000",
                        address1 = "AirMailGPT",
                        address2 = "Football"
                    ),
                    airman = Airman(
                        name = param["name"] as String,
                        birth = param["birth"] as String
                    ),
                    body = MailBody(
                        title = "${param["from"] as String} ~ ${param["to"] as String} ${param["leagueName"] as String? ?: "축구"} 경기 일정 및 결과",
                        content = fixtures
                    ),
                    password = param["password"] as String
                )
            )
            return mapOf("isSuccess" to "success")
        } catch (e: Exception) {
            e.printStackTrace()
            return mapOf("isSuccess" to "fail")
        }
    }

    @PostMapping(value = ["/football/standing"], produces = ["application/json;charset=UTF-8"])
    fun sendFootballStandingByLeagueId(@RequestBody param: Map<String, Any>): Map<String, String> {
        try {
            val standing = service.getFootballStanding(
                param["league"] as Number,
                param["season"] as Number
            )
            service.sendMail(
                Mail(
                    sender = Sender(
                        name = "AirMailGPT Football",
                        relationship = "Auto Generated",
                        zipCode = "00000",
                        address1 = "AirMailGPT",
                        address2 = "Football"
                    ),
                    airman = Airman(
                        name = param["name"] as String,
                        birth = param["birth"] as String
                    ),
                    body = MailBody(
                        title = "${param["season"] as Number} ${param["leagueName"] as String? ?: "축구"} 순위",
                        content = standing
                    ),
                    password = param["password"] as String
                )
            )
            return mapOf("isSuccess" to "success")
        } catch (e: Exception) {
            e.printStackTrace()
            return mapOf("isSuccess" to "fail")
        }
    }

    @PostMapping(value = ["/baseball/fixtures"], produces = ["application/json;charset=UTF-8"])
    fun sendBaseballFixturesByLeagueId(@RequestBody param: Map<String, Any>): Map<String, String> {
        try {
            val fixtures = service.getBaseballFixture(
                param["league"] as Number,
                param["season"] as Number,
                "${param["from"] as String}T00:00:00+09:00",
                "${param["to"] as String}T23:59:59+09:00"
            )
            service.sendMail(
                Mail(
                    sender = Sender(
                        name = "AirMailGPT Baseball",
                        relationship = "Auto Generated",
                        zipCode = "00000",
                        address1 = "AirMailGPT",
                        address2 = "Baseball"
                    ),
                    airman = Airman(
                        name = param["name"] as String,
                        birth = param["birth"] as String
                    ),
                    body = MailBody(
                        title = "${param["from"] as String} ~ ${param["to"] as String} ${param["leagueName"] as String? ?: "야구"} 경기 일정 및 결과",
                        content = fixtures
                    ),
                    password = param["password"] as String
                )
            )
            return mapOf("isSuccess" to "success")
        } catch (e: Exception) {
            e.printStackTrace()
            return mapOf("isSuccess" to "fail")
        }
    }

    @PostMapping(value = ["/baseball/standing"], produces = ["application/json;charset=UTF-8"])
    fun sendBaseballStandingByLeagueId(@RequestBody param: Map<String, Any>): Map<String, String> {
        try {
            val standing = service.getBaseballStanding(
                param["league"] as Number,
                param["season"] as Number
            )
            service.sendMail(
                Mail(
                    sender = Sender(
                        name = "AirMailGPT Baseball",
                        relationship = "Auto Generated",
                        zipCode = "00000",
                        address1 = "AirMailGPT",
                        address2 = "Baseball"
                    ),
                    airman = Airman(
                        name = param["name"] as String,
                        birth = param["birth"] as String
                    ),
                    body = MailBody(
                        title = "${param["season"] as Number} ${param["leagueName"] as String? ?: "야구"} 순위",
                        content = standing
                    ),
                    password = param["password"] as String
                )
            )
            return mapOf("isSuccess" to "success")
        } catch (e: Exception) {
            e.printStackTrace()
            return mapOf("isSuccess" to "fail")
        }
    }
}