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
import org.eclipse.xtext.validation.IResourceValidator
import org.eclipse.xtext.validation.CheckMode
import org.eclipse.xtext.util.CancelIndicator

@ExtendWith(InjectionExtension)
@InjectWith(NginxInjectorProvider)
class NginxErrorValidatorTest {

	@Inject extension ParseHelper<Nginx> parseHelper
	@Inject extension ValidationTestHelper validationHelper
	@Inject IResourceValidator resourceValidator
	
	@Test
	def void testValidErrorPage() {
		val input = '''
			mycoolsite.com:
			  port: 3000
			  index: "index.html index.php"
			  error_page: 404 "/404.html"
			  error_page: 500 501 502 "/50x.html"
		'''
		val result = input.parse
		val issues = resourceValidator.validate(result.eResource, CheckMode.ALL, CancelIndicator.NullImpl)
			
		for (issue : issues) {
			switch issue.severity {
				case ERROR:
					println("ERROR: " + issue.message)
				case WARNING:
					println("WARNING: " + issue.message)
			}
		}
		result.assertNoErrors
	}
	
}
