package ml.sijun.airmailgptapi

import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.junit.jupiter.MockitoExtension

@ExtendWith(MockitoExtension::class)
class MailServiceTest {
    @Test
    fun testSaveMailToDataBase() {
        // Arrange
        val mailService = MailService()
        val mail = Mail(
            Sender("John Doe", "friend", "12345", "123 Main St", "Apt 2B"),
            Airman("Jane Smith", "19900101"),
            MailBody("Hello", "World"),
            "1234"
        )
        val success = true

        // Act
        mailService.saveMailToDataBase(mail, success, "1234")
    }
}
