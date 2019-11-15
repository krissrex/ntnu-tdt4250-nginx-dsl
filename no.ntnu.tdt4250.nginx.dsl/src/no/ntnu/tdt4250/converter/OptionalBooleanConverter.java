package no.ntnu.tdt4250.converter;

import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.conversion.impl.AbstractToStringConverter;
import org.eclipse.xtext.nodemodel.INode;

public class OptionalBooleanConverter extends AbstractToStringConverter<Boolean> {

	protected static final String[] TRUE_VALUES = {"true", "yes"};
	protected static final String[] FALSE_VALUES = {"false", "no"};
	
	
	@Override
	protected Boolean internalToValue(String string, INode node) throws ValueConverterException {
		if ("".equals(string) || string == null) {
			return null;
		}
		
		for (int i = 0; i < TRUE_VALUES.length; i++) {
			if (TRUE_VALUES[i].equalsIgnoreCase(string)) {
				return Boolean.TRUE;
			}
		}
		for (int i = 0; i < FALSE_VALUES.length; i++) {
			if (FALSE_VALUES[i].equalsIgnoreCase(string)) {
				return Boolean.FALSE;
			}
		}
		
		throw new ValueConverterException("Failed to convert value to boolean: " + string, node,
				new IllegalArgumentException("Illegal value " + string));
	}

}
