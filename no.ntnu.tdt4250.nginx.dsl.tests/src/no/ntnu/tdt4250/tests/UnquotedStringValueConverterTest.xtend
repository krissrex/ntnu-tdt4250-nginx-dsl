package no.ntnu.tdt4250.tests

import no.ntnu.tdt4250.converter.UnquotedStringValueConverter
import static org.junit.Assert.assertEquals
import org.junit.jupiter.api.Test

class UnquotedStringValueConverterTest {
	
	@Test
	def testRemoveDoubleQuotes() {
		val converter = new UnquotedStringValueConverter()
		val actual = converter.toValue('"I have double quotes"', null)
		
		assertEquals("Does not remove double quotes", 'I have double quotes', actual)
	}
	
	@Test
	def testRemoveSingleQuotes() {
		val converter = new UnquotedStringValueConverter()
		val actual = converter.toValue("'I have single quotes'", null)
		
		assertEquals("Does not remove single quotes", "I have single quotes", actual)
	}

}