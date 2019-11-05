package no.ntnu.tdt4250.nginx.dsl.generator;

import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.resource.XtextResourceSet;

import com.google.inject.Injector;

import no.ntnu.tdt4250.NginxStandaloneSetup;

public class XtextInitializer {

	private static Injector injector = null;
	private static XtextResourceSet resourceSet = null;

	public static Injector getInjector() {
		if (injector == null) {
			synchronized (XtextInitializer.class) {
				if (injector == null) {
					new org.eclipse.emf.mwe.utils.StandaloneSetup().setPlatformUri("../");
					Injector injector = new NginxStandaloneSetup().createInjectorAndDoEMFRegistration();
					XtextResourceSet resourceSet = injector.getInstance(XtextResourceSet.class);
					resourceSet.addLoadOption(XtextResource.OPTION_RESOLVE_ALL, Boolean.TRUE);
					XtextInitializer.resourceSet = resourceSet;
					XtextInitializer.injector = injector;
				}
			}
		}

		return injector;
	}
	
	public static XtextResourceSet getResourceSet() {
		getInjector(); // ensure singleton initialization
		return resourceSet;
	}
}
