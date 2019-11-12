# ntnu-tdt4250-nginx-dsl
Nginx config DSL for NTNU course TDT4250

## Project folders

Folder name | Description
------------|------------
.generator | Acceleo model-to-text
.dsl | The grammar definition and all language-specific components (parser, lexer, linker, validation, etc.)
.ide | 	Platform-independent IDE functionality (e.g. services for content assist)
.target | no idea, xtext. Possibly maven stuff.
.tests | xtext tests
.ui | xtext ui
.ui.tests | Unit tests for the Eclipse editor


## Workflow

1. Write the xtext grammar and EMF in `.dsl/src/*/Nginx.xtext`
2. Generate language artifacts by running the `.dsl/src/*/GenerateNginx.mwe2` workflow (right-click)
3. Run the generated eclipse plug-in from `.ui` folder
4. Write in our DSL with this new eclipse window. Open an example project for this
6. Write Acceleo generator code using the DSL EMF model
7. Use the xtext code to load a EMF model instance from the DSL file and hand it to Acceleo

## Grammar

![grammar][docs/grammar.png]

## Helpful links

* https://www.eclipse.org/Xtext/documentation/102_domainmodelwalkthrough.html
* https://www.ntnu.no/wiki/display/tdt4250/Setup+for+Xtext
* https://gitlab.stud.idi.ntnu.no/TDT4250/examples/tree/master/tdt4250.ra.xtext2
* Whitespace-aware languages: https://www.eclipse.org/Xtext/documentation/307_special_languages.html
* Testing https://www.eclipsecon.org/france2015/sites/default/files/slides/presentation.pdf (there is also a video on this)
* terminals vs data types https://zarnekow.blogspot.com/2012/11/xtext-corner-6-data-types-terminals-why.html