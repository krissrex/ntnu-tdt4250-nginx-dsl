/*
 * generated by Xtext 2.18.0.M3
 */
package no.ntnu.tdt4250.validation

import java.util.regex.Pattern
import java.util.regex.PatternSyntaxException
import no.ntnu.tdt4250.nginx.NginxPackage
import no.ntnu.tdt4250.nginx.Site
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.ComposedChecks
import no.ntnu.tdt4250.validation.NginxSslValidator
import no.ntnu.tdt4250.validation.NginxErrorValidator

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
@ComposedChecks(validators = #[NginxSslValidator, NginxErrorValidator])
class NginxValidator extends AbstractNginxValidator {

	public static val INVALID_NAME = 'no.ntnu.tdt4250.validation.SITE__NAME'
	public static val INVALID_ROOT = 'no.ntnu.tdt4250.validation.SITE__ROOT'
	public static val INVALID_TEMPLATE = 'no.ntnu.tdt4250.validation.SITE__TEMPLATE'
	public static val INVALID_INDEX = 'no.ntnu.tdt4250.validation.SITE__INDEX'
	public static val INVALID_LOG_NAME = 'no.ntnu.tdt4250.validation.SITE__LOG_NAME'
	public static val INVALID_PORT = 'no.ntnu.tdt4250.validation.SITE__PORT'
	public static val INVALID_HTTPS_REDIRECT = 'no.ntnu.tdt4250.validation.SITE__HTTPS_REDIRECT'
	public static val INVALID_GZIP = 'no.ntnu.tdt4250.validation.SITE__GZIP'

	public static val String[] PROXY_TEMPLATES = #['php7.2', 'php5.6']
	public static val String[] BOOLEANS = #['true', 'false']

	@Check
	def void checkSite(Site site) {
		checkSiteName(site.name)
		
		if (site.root !== null) {
			checkRoot(site.root)
		} else {
			checkPort(site.port)		
		}

		checkTemplate(site.template)		
		checkIndex(site.index)
		checkLogName(site.logName)
	}

	def boolean checkRegex(String testString, String regexString) {
		var foundMatch = false;
		try {
			var regex = Pattern.compile(regexString);
			var regexMatcher = regex.matcher(testString);
			foundMatch = regexMatcher.matches();
		} catch (PatternSyntaxException ex) {
			// Syntax error in the regular expression
			System.out.println(ex.localizedMessage)
		}
		return foundMatch
	}

	def boolean checkBoolean(String bool) {
		var foundMatch = false
		for (String httpsRedirect : BOOLEANS) {
			if (httpsRedirect == bool) {
				foundMatch = true
			}
		}
		return foundMatch
	}

	def void checkSiteName(String siteName) {
		val foundMatch = checkRegex(siteName, "^[a-zA-Z0-9-]+\\.[a-zA-Z0-9.-]+$")
		if (!siteName.equals("default") && (foundMatch == false)) {
			error(
				'Name of site: ' + siteName + ' is not valid',
				NginxPackage.Literals.SITE__NAME,
				INVALID_NAME
			)
		}
	}

	def void checkRoot(String root) {
		if (root === null) {
			error(
				'Root: ' + root + ' is not valid',
				NginxPackage.Literals.SITE__ROOT,
				INVALID_ROOT
			)
		}
		val foundMatch = checkRegex(root, "^\\/[a-zA-Z0-9-]+([\\/][a-zA-Z0-9-]*)*$")
		if (foundMatch == false) {
			error(
				'Root: ' + root + ' is not valid',
				NginxPackage.Literals.SITE__ROOT,
				INVALID_ROOT
			)
		}
	}

	def void checkTemplate(String template) {
		if (template !== null) {
			var valid = PROXY_TEMPLATES.contains(template);
			if (!valid) {
				error(
					'Template: ' + template + ' is not valid',
					NginxPackage.Literals.SITE__TEMPLATE,
					INVALID_TEMPLATE
				)
			}
		}
	}

	def void checkIndex(String index) {
		if (index !== null) {
			val foundMatch = checkRegex(index, "^.*\\.(html|php)$")
			if (foundMatch == false) {
				error(
					'Index: ' + index + ' is not valid',
					NginxPackage.Literals.SITE__INDEX,
					INVALID_INDEX
				)
			}
		}
	}

	def void checkLogName(String logName) {
		if (logName !== null) {
			// Absolute file path
			val foundMatch = checkRegex(logName, "^\\/[a-zA-Z0-9-]+([\\/][a-zA-Z0-9-]*)*\\.log$")

			// File name
			//val foundMatch = checkRegex(logName, "^[a-zA-Z0-9-_.]+\\.log$")
			if (foundMatch == false) {
				error(
					'Log name: ' + logName + ' is not valid. Expected "/**.log"',
					NginxPackage.Literals.SITE__LOG_NAME,
					INVALID_LOG_NAME
				)
			}
		}
	}

	def void checkPort(int port) {
		if (!(port >= 1 && port <= 65535)) {
			error(
				'Port: ' + port + ' is not valid. The port is not in the allowed range [1, 65535].',
				NginxPackage.Literals.SITE__PORT,
				INVALID_PORT
			)
		}
	}

}
