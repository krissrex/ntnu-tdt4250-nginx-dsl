/*
 * generated by Xtext 2.18.0.M3
 */
package no.ntnu.tdt4250.tests

import com.google.inject.Inject
import no.ntnu.tdt4250.nginx.Model
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
	def void loadModel() {
		val result = parseHelper.parse('''
			Hello Xtext!
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
}
