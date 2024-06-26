package ml.sijun.airmailgptapi

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
import org.springframework.boot.runApplication
import org.springframework.scheduling.annotation.EnableScheduling

@SpringBootApplication(exclude = [ DataSourceAutoConfiguration::class ])
@EnableScheduling
class AirmailGptApiApplication

fun main(args: Array<String>) {
	runApplication<AirmailGptApiApplication>(*args)
}
