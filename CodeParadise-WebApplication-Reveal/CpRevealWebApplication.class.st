"
I am the abstract base for reveal.js presentations built with CodeParadise.

To create a presentation, subclass me and implement #createPresentationModel to answer a CpRevealPresentation built with the slide DSL. The application identifier (and URL) is derived automatically from the class name, e.g. MyTalkWebApplication -> ?my-talk.

  MyTalkWebApplication >> createPresentationModel
    ^ (CpRevealPresentation titled: 'My Talk')
        slide: 'Hello' bullets: #('world');
        yourself

Open with 'MyTalkWebApplication register; openInBrowser'. The in-browser view inspector (Ctrl/Cmd+I) and client debugger are enabled for live editing. See CpRevealPresentation for the DSL and CpRevealExampleWebApplication for a full example.
"
Class {
	#name : 'CpRevealWebApplication',
	#superclass : 'CpMvpWebApplication',
	#instVars : [
		'presentation'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Application',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Application'
}

{ #category : 'accessing' }
CpRevealWebApplication class >> allowedPackages [
	"Allow our Reveal package (with the View classes), the view inspector and the client debugger into the client image"

	^ super allowedPackages , {
		  CpRevealPresentationView package.
		  CpViewInspectorSupport package.
		  CpClientDebuggerSupport package }
]

{ #category : 'testing' }
CpRevealWebApplication class >> isAbstractTag [
	"The presence of this method indicates the receiver is abstract.
	It is not evaluated to decide abstractness."

	
]

{ #category : 'accessing' }
CpRevealWebApplication >> applicationModel [
	"Answer the root Model for the receiver (the presentation)"

	^ self presentation
]

{ #category : 'building' }
CpRevealWebApplication >> createPresentationModel [
	"Create and answer the CpRevealPresentation for this application.
	Subclasses must override this to build their slides."

	^ self subclassResponsibility
]

{ #category : 'initialization' }
CpRevealWebApplication >> initialize [
	"Create the presentation model and start it (selects the first slide)"

	super initialize.
	presentation := self createPresentationModel.
	presentation start
]

{ #category : 'initialization' }
CpRevealWebApplication >> load [

	super load.
	self addViewInspector.
	self addDebugger
]

{ #category : 'accessing' }
CpRevealWebApplication >> presentation [
	"Answer the CpRevealPresentation of the receiver"

	^ presentation
]

{ #category : 'accessing' }
CpRevealWebApplication >> presentation: aPresentation [

	presentation := aPresentation
]
