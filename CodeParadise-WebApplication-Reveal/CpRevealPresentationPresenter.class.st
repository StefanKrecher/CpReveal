"
I am the server-side presenter for a CpRevealPresentation. #renderView builds the slides HTML via CpRevealHtmlRenderer and hands it to the view, applying theme and transition. I handle CpRevealRunCode announcements from doIt widgets by evaluating the submitted Smalltalk code on the server (OpalCompiler) and returning the result (or error) to the view.
"
Class {
	#name : 'CpRevealPresentationPresenter',
	#superclass : 'CpPresenter',
	#category : 'CodeParadise-WebApplication-Reveal-Presenter',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Presenter'
}

{ #category : 'event handling' }
CpRevealPresentationPresenter >> applySource: anAnnouncement [
	"Recompile createPresentationModel on the application class, rebuild the model and re-render"

	[
		| newModel |
		newModel := nil.
		self application class
			compile: anAnnouncement code
			classified: 'building'.
		newModel := self application createPresentationModel.
		self application presentation: newModel.
		self model: newModel.
		self renderView.
		self view showEditorStatus: 'Applied successfully' isError: false ]
		on: Error
		do: [ :e |
				self view
					showEditorStatus:
					e class name , ': ' , (e messageText ifNil: [ '' ])
					isError: true ]
]

{ #category : 'rendering' }
CpRevealPresentationPresenter >> renderView [
	"Render the full presentation: build slides HTML from the model and hand it to the view"

	self view applyTheme: self model theme.
	self view renderSlides:
		(CpRevealHtmlRenderer new htmlFor: self model).
	self view applyTransition: self model transition
]

{ #category : 'event handling' }
CpRevealPresentationPresenter >> runDoIt: anAnnouncement [
	"Evaluate the submitted Smalltalk code on the server and send the result back to the view"

	| text isError |
	isError := false.
	text := [
	        (Smalltalk compiler evaluate: anAnnouncement code)
		        printString ]
		        on: Error
		        do: [ :e |
				        isError := true.
				        e class name , ': ' , (e messageText ifNil: [ '' ]) ].
	self view
		showDoItResult: anAnnouncement index
		text: text
		isError: isError
]

{ #category : 'event handling' }
CpRevealPresentationPresenter >> sendEditorSource [
	"Send the current createPresentationModel source to the in-browser editor"

	| src |
	src := (self application class lookupSelector:
		        #createPresentationModel)
		       ifNotNil: [ :mth | mth sourceCode ]
		       ifNil: [ 'createPresentationModel' ].
	self view showEditorSource: src
]

{ #category : 'view' }
CpRevealPresentationPresenter >> viewCreated [

	super viewCreated.
	self view when: CpRevealRunCode send: #runDoIt: to: self.
	self view when: CpRevealEditRequest send: #sendEditorSource to: self.
	self view when: CpRevealApplySource send: #applySource: to: self
]
