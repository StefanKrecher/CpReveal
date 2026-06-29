"
I turn a CpRevealPresentation model into the reveal.js .slides inner HTML. I walk sections and content blocks (double-dispatch via #renderRevealOn:), HTML-escape text, wrap fragments and assign indices to doIt widgets. Entry point: #htmlFor:.
"
Class {
	#name : 'CpRevealHtmlRenderer',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'doItIndex'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Support',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Support'
}

{ #category : 'building' }
CpRevealHtmlRenderer >> emit: aString [

	stream nextPutAll: aString.
	^ self
]

{ #category : 'building' }
CpRevealHtmlRenderer >> escape: aString [
	"HTML-escape a string for safe insertion as text/attribute"

	^ (((aString asString copyReplaceAll: '&' with: '&amp;')
		    copyReplaceAll: '<'
		    with: '&lt;') copyReplaceAll: '>' with: '&gt;')
		  copyReplaceAll: '"'
		  with: '&quot;'
]

{ #category : 'building' }
CpRevealHtmlRenderer >> htmlFor: aPresentation [
	"Answer the inner HTML for the .slides container (the <section> elements)"

	aPresentation sections do: [ :each | self renderSection: each ].
	^ stream contents
]

{ #category : 'initialization' }
CpRevealHtmlRenderer >> initialize [

	super initialize.
	stream := WriteStream on: String new.
	doItIndex := 0
]

{ #category : 'building' }
CpRevealHtmlRenderer >> nextDoItIndex [

	doItIndex := doItIndex + 1.
	^ doItIndex
]

{ #category : 'building' }
CpRevealHtmlRenderer >> renderContent: aContent [
	"Render a content block, wrapping the whole block as a fragment if marked"

	aContent isFragment ifTrue: [ self emit: '<div class="fragment">' ].
	aContent renderRevealOn: self.
	aContent isFragment ifTrue: [ self emit: '</div>' ]
]

{ #category : 'building' }
CpRevealHtmlRenderer >> renderSection: aSection [

	self emit: '<section>'.
	aSection hasSubSections
		ifTrue: [
		aSection subSections do: [ :sub | self renderSection: sub ] ]
		ifFalse: [
				aSection heading ifNotNil: [ :h |
						self
							emit: '<h2>';
							emit: (self escape: h);
							emit: '</h2>' ].
				aSection contents do: [ :c | self renderContent: c ] ].
	aSection hasNotes ifTrue: [
			self
				emit: '<aside class="notes">';
				emit: (self escape: aSection notes);
				emit: '</aside>' ].
	self emit: '</section>'
]
