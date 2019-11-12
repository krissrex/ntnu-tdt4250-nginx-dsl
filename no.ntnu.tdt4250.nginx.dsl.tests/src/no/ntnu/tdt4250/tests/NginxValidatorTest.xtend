/*
 * generated by Xtext 2.18.0.M3
 */
package no.ntnu.tdt4250.tests

import com.google.inject.Inject
import java.util.regex.Pattern
import java.util.regex.PatternSyntaxException
import no.ntnu.tdt4250.nginx.Nginx
import no.ntnu.tdt4250.nginx.NginxPackage
import no.ntnu.tdt4250.validation.NginxValidator
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.eclipse.xtext.validation.IResourceValidator
import org.eclipse.xtext.validation.CheckMode
import org.eclipse.xtext.util.CancelIndicator

@ExtendWith(InjectionExtension)
@InjectWith(NginxInjectorProvider)
class NginxValidatorTest {
	@Inject
	extension ParseHelper<Nginx> parseHelper

	@Inject
	extension ValidationTestHelper validationTestHelper

	@Inject IResourceValidator resourceValidator


	@Test
	def void testSiteName() {
		val input = '''
			mycoolsite.com:
			  root: "/var/www/html"
			  index: "index.html index.php"
			  template: php5.6
			  error_page: 404 "/404.html"
			  error_page: 500 501 502 "/50x.html"
			  ssl_certificate: "/etc/somepath/cert.pem"
			  ssl_certificate_key: "/etc/somepath/cert_key.pem"
			  ssl_dhparam: "/etc/somepath/dhparam.pem"
			  log_name: "/var/log/nginx/access.log"
			  include: "fastcgi_params"
			  https_redirect: true

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

	}


	/** maps the <=> 'spaceship' operator to Assert.assertEquals
	 * 
	 * https://gitlab.stud.idi.ntnu.no/TDT4250/examples/blob/master/tdt4250.ra.xtext2.tests/src/tdt4250/ra/tests/Rax2ParsingTest.xtend
	 */
	private def void operator_spaceship(Object expected, Object actual) {
		Assertions.assertEquals(expected, actual);
	}

	private def String toPrettyString(EList<Resource.Diagnostic> errors) {
		return errors.map['''«it.line»:«it.column» ->«it.message»   --- «it.toString»'''].join("\n")
	}

}