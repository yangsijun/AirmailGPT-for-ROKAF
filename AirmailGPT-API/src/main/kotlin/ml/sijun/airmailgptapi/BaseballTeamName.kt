package ml.sijun.airmailgptapi

fun getBaseballShortTeamName(leagueId: Number, teamId: Number): String? {
    return when (leagueId) {
        5 -> getKboShortTeamName(teamId)
        else -> null
    }
}
fun getKboShortTeamName(teamId: Number): String? {
    return when (teamId) {
        88 -> "두산"
        89 -> "한화"
        90 -> "KIA"
        91 -> "KT"
        92 -> "키움"
        93 -> "LG"
        94 -> "롯데"
        95 -> "NC"
        97 -> "삼성"
        647 -> "SSG"
        else -> null
    }
}