/*
 * generated by Xtext 2.18.0.M3
 */
package no.ntnu.tdt4250.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import no.ntnu.tdt4250.nginx.Nginx

@ExtendWith(InjectionExtension)
@InjectWith(NginxInjectorProvider)
class NginxParsingTest {
	@Inject
	ParseHelper<Nginx> parseHelper
	
	@Test
	def void parseDefault() {
		val result = parseHelper.parse('''
			mycoolsite.com:
			  root: "/var/www/html"
			  template: php5.6
			  error_page: 404 "/404.html"
			  error_page: 500 501 502 "/50x.html"
			  
			othersite.no:
			  listen: 443
			  index: "index.html"
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join("\n")»''')
		
		// Test content of the model 
		
		"mycoolsite.com" <=> result.sites.get(0).name
		"othersite.no" <=> result.sites.get(1).name
		
		val coolSite = result.sites.get(0);
		"php5.6" <=> coolSite.template
		"/var/www/html" <=> coolSite.root
		404 <=> coolSite.error_page.get(0).httpCodes.get(0)
		
		// For some reason, STRING type keeps its quotes.
		println(coolSite.error_page.get(0).uri);
		"/404.html" <=> coolSite.error_page.get(0).uri	
	}
	
	/** maps the <=> 'spaceship' operator to Assert.assertEquals
	 * 
	 * https://gitlab.stud.idi.ntnu.no/TDT4250/examples/blob/master/tdt4250.ra.xtext2.tests/src/tdt4250/ra/tests/Rax2ParsingTest.xtend
	 */
	private def void operator_spaceship(Object expected, Object actual) {
		Assertions.assertEquals(expected, actual);
	}
	
}
