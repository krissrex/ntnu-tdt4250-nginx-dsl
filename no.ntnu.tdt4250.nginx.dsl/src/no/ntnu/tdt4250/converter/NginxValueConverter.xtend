package no.ntnu.tdt4250.converter

import com.google.inject.Inject
import org.eclipse.xtext.common.services.DefaultTerminalConverters
import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverter

/**
 * Adds converters for our custom rules
 * @author Kristian Rekstad
 */
class NginxValueConverter extends DefaultTerminalConverters {

	@Inject
	private UnquotedStringValueConverter filePathConverter

	@ValueConverter(rule="FilePath")
	def IValueConverter<String> FilePath() {
		return filePathConverter
	}

}
