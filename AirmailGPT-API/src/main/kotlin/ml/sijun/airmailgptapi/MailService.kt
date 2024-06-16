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
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.regex.Pattern


class MailService {

    fun sendMail(@RequestBody mail: Mail): String {
        val result: String?
        val memberSeq: String
        try {
            memberSeq = getMemberSeq(mail.airman)
            val mailWriteUrl = getMailWriteUrl(memberSeq)
            println(mailWriteUrl)

            val restTemplate = RestTemplate()
            result = restTemplate.postForObject(
                "${NODEJS_URL}/mails",
                mapOf(
                    "mailWriteUrl" to mailWriteUrl,
                    "mailWritePayload" to mail,
                ),
                String::class.java
            )
        } catch (e: IOException) {
            try {
                saveMailToDataBase(mail, false, "dummy")
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return e.message.toString()
        }
        try {
            saveMailToDataBase(mail, result == "success", memberSeq)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return result.toString()
    }

    fun testSendMail(@RequestBody mail: Mail): String {
        val result: String?
        val memberSeq: String
        try {
            memberSeq = getMemberSeq(mail.airman)
            val mailWriteUrl = getMailWriteUrl(memberSeq)
            println(mailWriteUrl)

            val restTemplate = RestTemplate()
            result = restTemplate.postForObject(
                "${NODEJS_URL}/test",
                mapOf(
                    "mailWriteUrl" to mailWriteUrl,
                    "mailWritePayload" to mail,
                ),
                String::class.java
            )
        } catch (e: IOException) {
            try {
                saveMailToDataBase(mail, false, "dummy")
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return e.message.toString()
        }
        try {
            saveMailToDataBase(mail, result == "success", memberSeq)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return result.toString()
    }

    fun saveMailToDataBase(mail: Mail, success: Boolean, memberSeq: String) {
        try {
            // DEMO
//            val connection = DriverManager.getConnection("${DB_URL}", DB_USER, DB_PASSWORD)
//            val statement = connection.createStatement()
//            val sql = "INSERT INTO mail (sender_name, sender_relationship, sender_zip_code, sender_address1, sender_address2, airman_name, airman_birth, title, content, password, success, timestamp) VALUES ('${mail.sender.name}', '${mail.sender.relationship}', '${mail.sender.zipCode}', '${mail.sender.address1}', '${mail.sender.address2}', '${mail.airman.name}', '${mail.airman.birth}', '${mail.body.title}', '${mail.body.content}', '${mail.password}', ${success}, NOW())"
//            statement.executeUpdate(sql)
//            if (success) {
//                val sql2 = "INSERT INTO airman (member_seq, name, birth) VALUES ('${memberSeq}', '${mail.airman.name}', '${mail.airman.birth}')"
//                statement.executeUpdate(sql2)
//            }
        } catch (e: Exception) {
            throw RuntimeException("Failed to save mail to database", e)
        }
    }

    fun getMailListUrl(airman: Airman): String {
        val memberSeq = getMemberSeq(airman)

        return "https://www.airforce.mil.kr/user/indexSub.action?" + "codyMenuSeq=156893223&siteId=last2&dum=dum&command2=getEmailList" + "&searchName=${airman.name}" + "&searchBirth=${airman.birth}" + "&memberSeq=${memberSeq}"
    }

    private fun getMemberSeq(airman: Airman): String {
        try {
            val memberSeq = findMemberSeq(airman)
            if (memberSeq != null) {
                return memberSeq
            }
        } catch (_: Exception) {
        }

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

    private fun findMemberSeq(airman: Airman): String? {
        try {
            return "DEMO_memberSeq"
            // DEMO
//            // find memberSeq from DB
//            val connection =
//                DriverManager.getConnection("${DB_URL}", DB_USER, DB_PASSWORD)
//            val statement = connection.createStatement()
//            val sql = "SELECT member_seq FROM airman WHERE name='${airman.name}' AND birth='${airman.birth}'"
//            val resultSet = statement.executeQuery(sql)
//            return if (resultSet.next()) {
//                resultSet.getString("member_seq")
//            } else {
//                null
//            }
        } catch (e: Exception) {
            throw RuntimeException("Failed to find memberSeq from database", e)
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
                "model" to "gpt-3.5-turbo-0125",
                "messages" to listOf(
                    mapOf(
                        "role" to "user",
                        "content" to "너는 편지 대필 작가야. 편지를 받을 사람의 이름은 '${generator.airmanName}'이고, 그는 공군 기본군사훈련단에서 훈련을 받고 있어. 그에게 편지를 보내고자 해. 나는 그의 ${generator.relationship}이며, 내 이름은 '${generator.senderName}'이야. 아래의 단어들과 관련된 편지를 작성해줘.\n${generator.keyword}.\n\n첫 줄은 제목"
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

        val urlString = "https://api-football-v1.p.rapidapi.com/v3/fixtures?league=$league&season=$season&from=$from&to=$to&timezone=${FOOTBALL_TIMEZONE}"
        val requestEntity = HttpEntity<Any>(requestHeader)
        val responseEntity = restTemplate.exchange(urlString, HttpMethod.GET, requestEntity, String::class.java)
        val response = responseEntity.body
        println("response: $response")

        val objectMapper = ObjectMapper()

        val responseMap = objectMapper.readValue(response, Map::class.java)
        val matchList = responseMap["response"] as List<Map<String, Any>>

        val dateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss+09:00")

        val fixtureString = StringBuilder()

        matchList.sortedBy {
            (it["fixture"] as Map<String, Any>)["date"] as String
        }

        for (match in matchList) {
            val fixture = match["fixture"] as Map<String, Any>
            val date = LocalDateTime.parse(fixture["date"] as String, dateFormat)
            val teams = match["teams"] as Map<String, Any>
            val home = teams["home"] as Map<String, Any>
            val away = teams["away"] as Map<String, Any>
            val goals = match["goals"] as Map<String, Any>
            fixtureString.append(
                "%02d-%02d %02d:%02d/".format(date.monthValue, date.dayOfMonth, date.hour, date.minute)
            )
            fixtureString.append("${getFootballShortTeamName(league, home["id"] as Number) ?: home["name"]} vs ${getFootballShortTeamName(league, away["id"] as Number) ?: away["name"]}/")
            fixtureString.append("${goals["home"] ?: "_"} : ${goals["away"] ?: "_"}//")
        }
        println(fixtureString.toString())
        return fixtureString.toString()
    }

    fun getFootballStanding(league: Number, season: Number): String {
        val restTemplate = RestTemplate()
        val requestHeader = HttpHeaders()
        requestHeader.set("X-RapidAPI-Key", RAPID_API_KEY)
        requestHeader.set("X-RapidAPI-Host", "api-football-v1.p.rapidapi.com")

        val urlString = "https://api-football-v1.p.rapidapi.com/v3/standings?league=$league&season=$season"
        val requestEntity = HttpEntity<Any>(requestHeader)
        val responseEntity = restTemplate.exchange(urlString, HttpMethod.GET, requestEntity, String::class.java)
        val response = responseEntity.body
        println("response: $response")

        val objectMapper = ObjectMapper()

        val responseMap = objectMapper.readValue(response, Map::class.java)
        val responseList = responseMap["response"] as List<Map<String, Any>>
        val leagueList = responseList[0]["league"] as Map<String, Any>
        val standingList = leagueList["standings"] as List<List<Map<String, Any>>>
        val standing = standingList[0]
        val standingString = StringBuilder()

        standingString.append("순위 팀 경기 승 무 패 승점 득실차 최근경기// ")
        for (rank in standing) {
            val team = rank["team"] as Map<String, Any>
            val match = rank["all"] as Map<String, Any>
            standingString.append(
                """
                    ${rank["rank"]}. ${team["name"]} ${match["played"]} ${match["win"]} ${match["draw"]} ${match["lose"]} ${rank["points"]} ${rank["goalsDiff"]} ${rank["form"]}/
                """.trimIndent()
            )
        }
        println(standingString.toString())
        return standingString.toString()
    }

    fun getBaseballFixture(league: Number, season: Number, from: String, to: String): String {
        val restTemplate = RestTemplate()
        val requestHeader = HttpHeaders()
        requestHeader.set("X-RapidAPI-Key", RAPID_API_KEY)
        requestHeader.set("X-RapidAPI-Host", "api-baseball.p.rapidapi.com")

        val urlString = "https://api-baseball.p.rapidapi.com/games?league=$league&season=$season&timezone=${BASEBALL_TIMEZONE}"
        val requestEntity = HttpEntity<Any>(requestHeader)
        val responseEntity = restTemplate.exchange(urlString, HttpMethod.GET, requestEntity, String::class.java)
        val response = responseEntity.body
        println("response: $response")

        val objectMapper = ObjectMapper()

        val responseMap = objectMapper.readValue(response, Map::class.java)
        val matchList = responseMap["response"] as List<Map<String, Any>>

        val dateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss+09:00")
        val fromDate = LocalDateTime.parse(from, dateFormat)
        val toDate = LocalDateTime.parse(to, dateFormat)
        val fixtureString = StringBuilder()

        var dateIter = LocalDateTime.MIN
        for (match in matchList) {
            val dateString = match["date"] as String
            val date = LocalDateTime.parse(dateString, dateFormat)
            // date check
            if (date < fromDate || date > toDate) {
                continue
            }
            if (dateIter != date) {
                fixtureString.append(
                    "%02d-%02d// ".format(date.monthValue, date.dayOfMonth)
                )
                dateIter = date
            }
            val status = match["status"] as Map<String, Any>
            val teams = match["teams"] as Map<String, Any>
            val home = teams["home"] as Map<String, Any>
            val away = teams["away"] as Map<String, Any>
            val scores = match["scores"] as Map<String, Any>
            val homeScore = scores["home"] as Map<String, Any>
            val homeInnings = homeScore["innings"] as Map<String, Any>
            val awayScore = scores["away"] as Map<String, Any>
            val awayInnings = awayScore["innings"] as Map<String, Any>

            // home vs away
            fixtureString.append(
                """
                    ${getBaseballShortTeamName(league, home["id"] as Number) ?: home["name"]} vs ${getBaseballShortTeamName(league, away["id"] as Number) ?: away["name"]}/
                """.trimIndent()
            )
            if (status["long"] == "Finished") { // finished
                // total score
                fixtureString.append("${homeScore["total"] ?: "_"} : ${awayScore["total"] ?: "_"}//")
                if (home["id"] == BASEBALL_MY_TEAM_ID || away["id"] == BASEBALL_MY_TEAM_ID) { // my team
                    // inning score
                    fixtureString.append(
                        """
                            ${getBaseballShortTeamName(league, away["id"] as Number) ?: away["name"]} : ${awayInnings["1"] ?: "_"} ${awayInnings["2"] ?: "_"} ${awayInnings["3"] ?: "_"} ${awayInnings["4"] ?: "_"} ${awayInnings["5"] ?: "_"} ${awayInnings["6"] ?: "_"} ${awayInnings["7"] ?: "_"} ${awayInnings["8"] ?: "_"} ${awayInnings["9"] ?: "_"} ${awayInnings["extra"] ?: ""}/
                            ${getBaseballShortTeamName(league, home["id"] as Number) ?: home["name"]} : ${homeInnings["1"] ?: "_"} ${homeInnings["2"] ?: "_"} ${homeInnings["3"] ?: "_"} ${homeInnings["4"] ?: "_"} ${homeInnings["5"] ?: "_"} ${homeInnings["6"] ?: "_"} ${homeInnings["7"] ?: "_"} ${homeInnings["8"] ?: "_"} ${homeInnings["9"] ?: "_"} ${homeInnings["extra"] ?: ""}//
                        """.trimIndent()
                    )
                }
            } else { // not finished
                // print status
                fixtureString.append("${status["short"]}//")
            }
        }
        println(fixtureString.toString())
        return fixtureString.toString()
    }

    fun getBaseballStanding(league: Number, season: Number): String {
        val restTemplate = RestTemplate()
        val requestHeader = HttpHeaders()
        requestHeader.set("X-RapidAPI-Key", RAPID_API_KEY)
        requestHeader.set("X-RapidAPI-Host", "api-baseball.p.rapidapi.com")

        val urlString = "https://api-baseball.p.rapidapi.com/standings?league=$league&season=$season"
        val requestEntity = HttpEntity<Any>(requestHeader)
        val responseEntity = restTemplate.exchange(urlString, HttpMethod.GET, requestEntity, String::class.java)
        val response = responseEntity.body
        println("response: $response")

        val objectMapper = ObjectMapper()

        val responseMap = objectMapper.readValue(response, Map::class.java)
        val responseList = responseMap["response"] as List<List<Map<String, Any>>>
        val standing = responseList[0]
        val standingString = StringBuilder()

        standingString.append("순위 팀 경기 승 패 승률 최근경기// ")
        for (rank in standing) {
            val team = rank["team"] as Map<String, Any>
            val games = rank["games"] as Map<String, Any>
            val win = games["win"] as Map<String, Any>
            val lose = games["lose"] as Map<String, Any>
            standingString.append(
                """
                    ${rank["position"]}. ${getKboShortTeamName(team["id"] as Number)} ${games["played"]} ${win["total"]} ${lose["total"]} ${win["percentage"]} ${rank["form"]}/
                """.trimIndent()
            )
        }
        println(standingString.toString())
        return standingString.toString()
    }
}

class AirmanNotFoundException(s: String, e: Exception? = null) : Exception(s, e)
class AiMailGeneratorException(s: String, e: Exception? = null) : Exception(s, e)