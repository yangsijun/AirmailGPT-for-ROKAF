package ml.sijun.airmailgptapi

import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import java.time.LocalDate

@Component
class ScheduledController {

    @Scheduled(cron = "0 50 11 $MAIL_START_DAY $MAIL_START_MONTH *")
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

    @Scheduled(cron = "0 0 11 ${MAIL_START_DAY}-${MAIL_END_DAY} ${MAIL_START_MONTH}-${MAIL_END_MONTH} *")
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

    @Scheduled(cron = "0 1 11 ${MAIL_START_DAY}-${MAIL_END_DAY} ${MAIL_START_MONTH}-${MAIL_END_MONTH} *")
    fun sendFootballStanding() {
        val mailController = MailController()
        mailController.sendFootballStandingByLeagueId(
            mapOf(
                "league" to FOOTBALL_LEAGUE_ID,
                "season" to FOOTBALL_SEASON,
                "leagueName" to "EPL",
                "name" to AIRMAN_NAME,
                "birth" to AIRMAN_BIRTH,
                "password" to PASSWORD
            )
        )
    }

    @Scheduled(cron = "0 50 11 $MAIL_START_DAY $MAIL_START_MONTH *")
    fun sendBaseballFixtureOfBootcampDuration() {
        val mailController = MailController()
        mailController.sendBaseballFixturesByLeagueId(
            mapOf(
                "league" to BASEBALL_LEAGUE_ID,
                "season" to BASEBALL_SEASON,
                "from" to ENLIST_DATE,
                "to" to MAIL_START_DATE,
                "leagueName" to "KBO",
                "name" to AIRMAN_NAME,
                "birth" to AIRMAN_BIRTH,
                "password" to PASSWORD
            )
        )
    }

    @Scheduled(cron = "0 0 12 ${MAIL_START_DAY}-${MAIL_END_DAY} ${MAIL_START_MONTH}-${MAIL_END_MONTH} *")
    fun sendBaseballFixtureOfToday() {
        val mailController = MailController()
        mailController.sendBaseballFixturesByLeagueId(
            mapOf(
                "league" to BASEBALL_LEAGUE_ID,
                "season" to BASEBALL_SEASON,
                "from" to "${LocalDate.now().minusDays(1)}T00:00:00+09:00",
                "to" to "${LocalDate.now().plusDays(1)}T00:00:00+09:00",

                "leagueName" to "KBO",
                "name" to AIRMAN_NAME,
                "birth" to AIRMAN_BIRTH,
                "password" to PASSWORD
            )
        )
    }

    @Scheduled(cron = "0 1 12 ${MAIL_START_DAY}-${MAIL_END_DAY} ${MAIL_START_MONTH}-${MAIL_END_MONTH} *")
    fun sendBaseballStanding() {
        val mailController = MailController()
        mailController.sendBaseballStandingByLeagueId(
            mapOf(
                "league" to BASEBALL_LEAGUE_ID,
                "season" to BASEBALL_SEASON,
                "leagueName" to "KBO",
                "name" to AIRMAN_NAME,
                "birth" to AIRMAN_BIRTH,
                "password" to PASSWORD
            )
        )
    }
}