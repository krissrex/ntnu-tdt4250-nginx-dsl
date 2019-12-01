package no.ntnu.tdt4250.validation

import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import org.eclipse.xtext.validation.Check
import java.io.File
import no.ntnu.tdt4250.nginx.NginxPackage
import org.eclipse.xtext.validation.EValidatorRegistrar
import no.ntnu.tdt4250.nginx.Include
import org.eclipse.core.runtime.Path
import org.eclipse.core.resources.ResourcesPlugin

class NginxIncludeValidator extends AbstractDeclarativeValidator {
	public static val INVALID_INCLUDE = 'no.ntnu.tdt4250.validation.ERROR_INCLUDE'

	@Check
	def void checkInclude(Include include) {
		val platformString = include.eResource.URI.toPlatformString(true);
		val dslFile = new File(platformString);
		var newpath = dslFile.parent + "/" + include.importURI;
		var file = ResourcesPlugin.getWorkspace().getRoot().getFile(new Path(newpath));
		
		if (!file.exists) {
			error(
				'Include is not valid. File ' + file.fullPath + ' not found.',
				NginxPackage.Literals.INCLUDE__IMPORT_URI,
				INVALID_INCLUDE
			)
		}
		
	}

	override register(EValidatorRegistrar registrar) {
		// not needed for classes used as ComposedCheck
	}
}