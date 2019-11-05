package no.ntnu.tdt4250.tests

import javax.inject.Inject
import no.ntnu.tdt4250.nginx.Nginx
import no.ntnu.tdt4250.nginx.NginxPackage
import no.ntnu.tdt4250.validation.NginxSslValidator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

@ExtendWith(InjectionExtension)
@InjectWith(NginxInjectorProvider)
class NginxSslValidatorTest {

	@Inject extension ParseHelper<Nginx> parseHelper
	@Inject extension ValidationTestHelper validationHelper

	@Test
	def void testFailsInvalidSslCertificate() {
		val input = '''
			mysite.com:
				port: 3000
				ssl_certificate: "invalid"
				ssl_certificate_key: "/etc/somepath/cert_key.pem"
				ssl_dhparam: "/etc/somepath/dhparam.pem"
		'''
		val result = input.parse
		
		result.assertError(
			NginxPackage.Literals.SSL_CERT,
			NginxSslValidator.INVALID_SSL_CERT_PATH,
			'"invalid" is not a valid file path'
		)
	}
	
	@Test
	def void testValidSslCertificate() {
		val input = '''
			mysite.com:
				port: 3000
				ssl_certificate: "/etc/somepath/cert.pem"
				ssl_certificate_key: "/etc/somepath/cert_key.pem"
				ssl_dhparam: "/etc/somepath/dhparam.pem"
		'''
		val result = input.parse
		
		result.assertNoErrors
	}
}
