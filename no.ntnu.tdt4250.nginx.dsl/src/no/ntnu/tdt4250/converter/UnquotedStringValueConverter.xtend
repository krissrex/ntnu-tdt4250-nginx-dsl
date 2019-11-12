package no.ntnu.tdt4250.converter

import org.eclipse.xtext.conversion.impl.AbstractToStringConverter
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.conversion.ValueConverterException

class UnquotedStringValueConverter extends AbstractToStringConverter<String> {

	override protected internalToValue(String string, INode node) throws ValueConverterException {
		return string.unquote
	}

	def private static String unquote(String value) {
		if ((value.startsWith("'") && value.endsWith("'")) 
			|| (value.startsWith('"') && value.endsWith('"'))
		) {
			return value.substring(1, value.length-1)
		}
		return value
	}
}
