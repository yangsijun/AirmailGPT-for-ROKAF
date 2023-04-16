package ml.sijun.airmailgptapi

import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import java.time.LocalDate

@Component
class ScheduledController {

    @Scheduled(cron = "0 50 11 $MAIL_START_DAY $MAIL_START_MONTH $MAIL_START_YEAR")
    fun sendFootballFixtureOfBootcampDuration() {
        val mailController = MailController()
        mailController.sendFootballFixturesByLeagueId(
            mapOf(
                "league" to FOOTBALL_LEAGUE_ID,
                "season" to FOOTBALL_SEASON,
                "from" to ENLIST_DATE,
                "to" to BOOTCAMP_END_DATE,
                "leagueName" to "EPL",
                "name" to AIRMAN_NAME,
                "birth" to AIRMAN_BIRTH,
                "password" to PASSWORD
            )
        )
    }
    @Scheduled(cron = "0 0 12 ${MAIL_START_DAY}-${MAIL_END_DAY} ${MAIL_START_MONTH}-${MAIL_END_MONTH} ${MAIL_START_YEAR}-${MAIL_END_YEAR}")
    fun sendFootballFixtureOfToday() {
        val mailController = MailController()
        mailController.sendFootballFixturesByLeagueId(
            mapOf(
                "league" to FOOTBALL_LEAGUE_ID,
                "season" to FOOTBALL_SEASON,
                "from" to LocalDate.now().minusDays(1),
                "to" to LocalDate.now().plusDays(1),
                "leagueName" to "EPL",
                "name" to AIRMAN_NAME,
                "birth" to AIRMAN_BIRTH,
                "password" to PASSWORD
            )
        )
    }
}