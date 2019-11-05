package no.ntnu.tdt4250.nginx.dsl.generator.main;

import javax.inject.Inject;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;

import no.ntnu.tdt4250.nginx.Nginx;
import no.ntnu.tdt4250.nginx.dsl.generator.XtextInitializer;
import no.ntnu.tdt4250.parser.antlr.NginxParser;

public class DslFileLoader {

	protected NginxParser parser;

	@Inject
	public DslFileLoader(NginxParser parser) {
		this.parser = parser;
	}

	public Nginx loadModel(URI modelUri) {
		System.out.println("Loading from DSL file: " + modelUri.toString());
		if (!modelUri.isFile()) {
			throw new IllegalArgumentException("DSL path is not a file: " + modelUri.toString());
		}

		Resource resource = XtextInitializer.getResourceSet().getResource(modelUri, true);

		if (!resource.getErrors().isEmpty()) {
			System.err.println("Model has " + resource.getErrors().size() + " errors:");
			for (Resource.Diagnostic error : resource.getErrors()) {
				System.err.println(
						"DSL error: " + error.getLine() + ":" + error.getColumn() + " --> " + error.getMessage());
			}
		}

		if (!resource.getWarnings().isEmpty()) {
			System.err.println("Model has " + resource.getWarnings().size() + " warnings:");
			for (Resource.Diagnostic error : resource.getWarnings()) {
				System.err.println(
						"DSL warning: " + error.getLine() + ":" + error.getColumn() + " --> " + error.getMessage());
			}
		}

		Nginx model = (Nginx) resource.getContents().get(0);

		if (model == null) {
			throw new RuntimeException("The loaded model was null");
		}

		return model;
	}

}
