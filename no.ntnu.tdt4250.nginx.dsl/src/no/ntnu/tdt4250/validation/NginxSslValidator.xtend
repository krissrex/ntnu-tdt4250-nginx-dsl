package no.ntnu.tdt4250.validation

import org.eclipse.xtext.validation.Check
import no.ntnu.tdt4250.nginx.SslCert
import no.ntnu.tdt4250.nginx.NginxPackage
import org.eclipse.xtext.validation.EValidatorRegistrar
import org.eclipse.xtext.validation.AbstractDeclarativeValidator

class NginxSslValidator extends AbstractDeclarativeValidator {

	public static val INVALID_SSL_CERT_PATH = "no.ntnu.tdt4250.validation.INVALID_SSL_CERT_PATH"

	@Check
	def void checkSslParam(SslCert cert) {
		if (! cert.sslCert.isFilePath) {
			error(
				cert.sslCert + " is not a valid file path",
				NginxPackage.Literals.SSL_CERT__SSL_CERT,
				INVALID_SSL_CERT_PATH
			)
		}
	}

	def boolean isFilePath(String path) {
		return false
	}

	override register(EValidatorRegistrar registrar) {
		// not needed for classes used as ComposedCheck
	}
}
