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
import java.util.regex.Pattern


class MessageService {
    fun sendMessage(@RequestBody message: Message): String {
        try {
            val airman = Airman(message.airmanName, message.airmanBirth)

            val mailListUrl = getMailListUrl(airman)
            println(mailListUrl)

            val mailWriteRequestPayload = getMailWriteRequestPayload(message)
            val mailWriteURL = getMailWriteUrl(getMemberSeq(airman))
            println(mailWriteURL)

            val restTemplate = RestTemplate()
            val result = restTemplate.postForObject(
                "http://localhost:3000/AirmailGPT-for-ROKAF/message",
                mapOf(
                    "mailWriteUrl" to mailListUrl,
                    "mailWritePayload" to mailWriteRequestPayload
                ),
                String::class.java
            )

            return result.toString()
        } catch (e: IOException) {
            return e.message.toString()
        }
    }

    private fun getMailListUrl(airman: Airman): String {
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

    private fun getMailWriteRequestPayload(message: Message): Map<String, String> {
        val messageContent = makeMessageContent(message)
        return mapOf(
            "senderZipcode" to SENDER_ZIPCODE,
            "senderAddr1" to SENDER_ADDR1,
            "senderAddr2" to SENDER_ADDR2,
            "senderName" to message.senderName,
            "relationship" to message.relation,
            "title" to messageContent.title,
            "password" to message.password,
            "content" to messageContent.content,
        )
    }

    private fun makeMessageContent(message: Message): MessageContent {
        val messageContent = MessageContent()
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
                    "content" to "'${message.airmanName}'은 ${ENLIST_DATE}부터 공군 기본군사훈련단에서 훈련을 받고 있어. 나는 그의 ${message.relation}이며, 내 이름은 '${message.senderName}'이야. 그에게 편지를 보내고자 해. 아래의 단어들과 관련된 편지를 작성해줘.\n${message.seed}.\n\n첫 줄은 제목"
                )
            )
        )
        val requestEntity = HttpEntity(postData, requestHeader)
        val responseEntity = restTemplate.exchange(urlString, HttpMethod.POST, requestEntity, String::class.java)
        val response = responseEntity.body
        println("response: $response")

        val objectMapper = ObjectMapper()
        val responseMap = objectMapper.readValue(response, Map::class.java) as Map<String, Any>
        val choices = responseMap["choices"] as List<Map<String, Any>>
        val choice = choices[0]
        val contentMessage = choice["message"] as Map<String, Any>
        var content = contentMessage["content"] as String

        // remove the blank line at very beginning
        for (c in content) {
            if (c != '\n')
                break
            content = content.substring(1)
        }

        messageContent.title = content.split("\n")[0]
        messageContent.content = content.substring(messageContent.title.length + 1)

        println("title: ${messageContent.title}")
        println("content: ${messageContent.content}")

        return messageContent
    }
}

class AirmanNotFoundException(s: String, e: Exception? = null) : Exception(s, e)