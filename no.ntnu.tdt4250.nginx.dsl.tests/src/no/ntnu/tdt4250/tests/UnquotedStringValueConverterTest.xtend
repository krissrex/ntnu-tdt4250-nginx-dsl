package no.ntnu.tdt4250.tests

import no.ntnu.tdt4250.converter.UnquotedStringValueConverter
import org.junit.jupiter.api.Test
import static org.junit.jupiter.api.Assertions.assertEquals

class UnquotedStringValueConverterTest {
	
	@Test
	def testRemoveDoubleQuotes() {
		val converter = new UnquotedStringValueConverter()
		val actual = converter.toValue('"I have double quotes"', null)
		
		assertEquals('I have double quotes', actual, "Does not remove double quotes")
	}
	
	@Test
	def testRemoveSingleQuotes() {
		val converter = new UnquotedStringValueConverter()
		val actual = converter.toValue("'I have single quotes'", null)
		
		assertEquals("I have single quotes", actual, "Does not remove single quotes")
	}

}