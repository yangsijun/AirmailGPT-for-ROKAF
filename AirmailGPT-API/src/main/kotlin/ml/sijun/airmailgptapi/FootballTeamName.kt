package ml.sijun.airmailgptapi

fun getFootballShortTeamName(leagueId: Number, teamId: Number): String? {
    return when (leagueId) {
        39 -> getEplShortTeamName(teamId)
        else -> null
    }
}
fun getEplShortTeamName(teamId: Number): String? {
    return when (teamId) {
        33 -> "MUN"
        34 -> "NEW"
        35 -> "BOU"
        36 -> "FUL"
        39 -> "WOL"
        40 -> "LIV"
        41 -> "SOU"
        42 -> "ARS"
        45 -> "EVE"
        46 -> "LEI"
        47 -> "TOT"
        48 -> "WHU"
        49 -> "CHE"
        50 -> "MCI"
        51 -> "BHA"
        52 -> "CRY"
        55 -> "BRE"
        63 -> "LEE"
        65 -> "NFO"
        66 -> "AVL"
        else -> null
    }
}