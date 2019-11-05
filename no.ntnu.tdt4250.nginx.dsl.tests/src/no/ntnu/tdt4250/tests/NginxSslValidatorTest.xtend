package no.ntnu.tdt4250.tests

import org.eclipse.xtext.testing.extensions.InjectionExtension
import no.ntnu.tdt4250.nginx.Nginx
import org.eclipse.xtext.testing.util.ParseHelper
import javax.inject.Inject
import org.junit.jupiter.api.^extension.ExtendWith
import org.eclipse.xtext.testing.InjectWith
import no.ntnu.tdt4250.nginx.NginxPackage
import no.ntnu.tdt4250.nginx.NginxFactory
import org.junit.jupiter.api.Test
import no.ntnu.tdt4250.validation.NginxSslValidator
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import static org.junit.Assert.assertEquals
import static org.junit.Assert.assertNotNull
import org.eclipse.xtext.validation.IResourceValidator
import org.eclipse.xtext.validation.CheckMode
import org.eclipse.xtext.util.CancelIndicator

@ExtendWith(InjectionExtension)
@InjectWith(NginxInjectorProvider)
class NginxSslValidatorTest {

	@Inject extension ParseHelper<Nginx> parseHelper
	@Inject extension ValidationTestHelper validationHelper

	@Test
	def void checkSslCertIsFile() {
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
}
