package ml.sijun.airmailgptapi

import com.fasterxml.jackson.databind.ObjectMapper
import org.jsoup.Jsoup
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.client.RestTemplate
import java.io.IOException
import java.sql.DriverManager
import java.util.regex.Pattern


class MailService {

    fun sendMail(@RequestBody mail: Mail): String {
        val result: String?
        try {
            val mailWriteURL = getMailWriteUrl(getMemberSeq(mail.airman))
            println(mailWriteURL)

            val restTemplate = RestTemplate()
            result = restTemplate.postForObject(
                "${NODEJS_URL}/AirmailGPT-for-ROKAF/mails",
                mapOf(
                    "mailWriteUrl" to mailWriteURL,
                    "mailWritePayload" to mail,
                ),
                String::class.java
            )
        } catch (e: IOException) {
            try {
                saveMailToDataBase(mail, false)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return e.message.toString()
        }
        try {
            saveMailToDataBase(mail, result == "success")
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return result.toString()
    }

    fun saveMailToDataBase(mail: Mail, success: Boolean) {
        val connection = DriverManager.getConnection("jdbc:mysql://${DB_URL}/airmailgpt-for-rokaf", DB_USER, DB_PASSWORD)
        val statement = connection.createStatement()
        val sql = "INSERT INTO mail (sender_name, sender_relationship, sender_zip_code, sender_address1, sender_address2, airman_name, airman_birth, title, content, password, success, timestamp) VALUES ('${mail.sender.name}', '${mail.sender.relationship}', '${mail.sender.zipCode}', '${mail.sender.address1}', '${mail.sender.address2}', '${mail.airman.name}', '${mail.airman.birth}', '${mail.body.title}', '${mail.body.content}', '${mail.password}', ${success}, NOW())"
        statement.executeUpdate(sql)
    }

    fun getMailListUrl(airman: Airman): String {
        val memberSeq = getMemberSeq(airman)

        return "https://www.airforce.mil.kr/user/indexSub.action?" + "codyMenuSeq=156893223&siteId=last2&dum=dum&command2=getEmailList" + "&searchName=${airman.name}" + "&searchBirth=${airman.birth}" + "&memberSeq=${memberSeq}"
    }

    private fun getMemberSeq(airman: Airman): String {
        val memberListUrl = getMemberListUrl(airman)
        val jsoup = getJsoup(memberListUrl)

        try {
            val onclickFunc = jsoup.body().select("li > input").attr("onclick")
            val pattern = Pattern.compile("\\d+")
            val onclickFuncParams = pattern.matcher(onclickFunc).results().map { it.group().toInt() }.toList()
            return onclickFuncParams.maxOrNull().toString()
        } catch (e: Exception) {
            throw AirmanNotFoundException("${airman.name} (생년월일: ${airman.birth})에 해당하는 군인을 찾을 수 없습니다.", e)
        }
    }

    private fun getMemberListUrl(airman: Airman): String {
        return "https://www.airforce.mil.kr/user/emailPicViewSameMembers.action?" +
                "siteId=last2" +
                "&searchName=${airman.name}" +
                "&searchBirth=${airman.birth}"
    }

    private fun getMailWriteUrl(memberSeq: String): String {
        return "https://www.airforce.mil.kr/user/indexSub.action?" +
                "codyMenuSeq=156893223&siteId=last2&menuUIType=sub&dum=dum&command2=writeEmail&searchCate=&searchVal=&page=1" +
                "&memberSeqVal=${memberSeq}"
    }

    private fun getJsoup(url: String): org.jsoup.nodes.Document {
        val response = Jsoup.connect(url).execute()
        val statusCode = response.statusCode()
        if (statusCode != 200) {
            throw RuntimeException("Failed to connect to URL: $url (status code: $statusCode)")
        }
        return response.parse()
    }

    // request to ChatGPT
    fun requestToChatGPT(generator: AiMailGenerator): String {
        try {
            val openaiApiKey = OPENAI_API_KEY
            val urlString = "https://api.openai.com/v1/chat/completions"

            val restTemplate = RestTemplate()
            val requestHeader = HttpHeaders()
            requestHeader.contentType = MediaType.APPLICATION_JSON
            requestHeader.setBearerAuth(openaiApiKey)

            val postData = mapOf(
                "model" to "gpt-3.5-turbo",
                "messages" to listOf(
                    mapOf(
                        "role" to "user",
                        "content" to "편지를 받을 사람의 이름은 '${generator.airmanName}'이고, 그는 ${ENLIST_DATE}부터 공군 기본군사훈련단에서 훈련을 받고 있어. 나는 그의 ${generator.relationship}이며, 내 이름은 '${generator.senderName}'이야. 그에게 편지를 보내고자 해. 아래의 단어들과 관련된 편지를 작성해줘.\n${generator.keyword}.\n\n첫 줄은 제목"
                    )
                )
            )
            val requestEntity = HttpEntity(postData, requestHeader)
            val responseEntity = restTemplate.exchange(urlString, HttpMethod.POST, requestEntity, String::class.java)
            val response = responseEntity.body
            println("response: $response")

            return response.toString()
        } catch (e: Exception) {
            throw AiMailGeneratorException("ChatGPT API 요청 중 오류가 발생했습니다.", e)
        }
    }

    fun getFootballFixture(league: Number, season: Number, from: String, to: String): String {
        val restTemplate = RestTemplate()
        val requestHeader = HttpHeaders()
        requestHeader.set("X-RapidAPI-Key", RAPID_API_KEY)
        requestHeader.set("X-RapidAPI-Host", "api-football-v1.p.rapidapi.com")

        val urlString = "https://api-football-v1.p.rapidapi.com/v3/fixtures?league=$league&season=$season&from=$from&to=$to"
        val requestEntity = HttpEntity<Any>(requestHeader)
        val responseEntity = restTemplate.exchange(urlString, HttpMethod.GET, requestEntity, String::class.java)
        val response = responseEntity.body
        println("response: $response")

        val objectMapper = ObjectMapper()

        val responseMap = objectMapper.readValue(response, Map::class.java)
        val matchList = responseMap["response"] as List<Map<String, Any>>

        val fixtureString = StringBuilder()
        for (match in matchList) {
            val fixture = match["fixture"] as Map<String, Any>
            val teams = match["teams"] as Map<String, Any>
            val home = teams["home"] as Map<String, Any>
            val away = teams["away"] as Map<String, Any>
            val goals = match["goals"] as Map<String, Any>
            fixtureString.append(
                """
                    ${fixture["timezone"]} ${fixture["date"]} /
                    ${home["name"]} vs ${away["name"]} /
                    ${goals["home"] ?: "_"} : ${goals["away"] ?: "_"} ///
                """.trimIndent()
            )
            fixtureString.append("${fixture["timezone"]} ${fixture["date"]}\n")
            fixtureString.append("${home["name"]} vs ${away["name"]}\n")
            fixtureString.append("${goals["home"] ?: "_"} : ${goals["away"] ?: "_"}\n\n")
        }
        println(fixtureString.toString())
        return fixtureString.toString()
    }
}

class AirmanNotFoundException(s: String, e: Exception? = null) : Exception(s, e)
class AiMailGeneratorException(s: String, e: Exception? = null) : Exception(s, e)