"
I represent one slide. I either hold content blocks (CpRevealContent) shown on a single slide, or sub-sections forming a vertical 2D stack. I provide content-adder messages (text:, bullets:, code:language:, title:subtitle:, math:, mermaid:, image:alt:, doIt:, html:, markdown:, custom:model:) used inside slide:with: blocks. Use notes: for reveal.js speaker notes and heading: for the slide heading.
"
Class {
	#name : 'CpRevealSection',
	#superclass : 'CpModel',
	#instVars : [
		'heading',
		'contents',
		'subSections',
		'notes'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealSection class >> heading: aString [

	^ self new heading: aString
]

{ #category : 'building' }
CpRevealSection >> addContent: aContent [
	"Append a CpRevealContent block; answer self for fluent chaining"

	contents add: aContent.
	^ self
]

{ #category : 'building' }
CpRevealSection >> bullets: aCollection [

	^ self addContent: (CpRevealBulletsContent items: aCollection)
]

{ #category : 'building' }
CpRevealSection >> code: aString [

	^ self code: aString language: #plaintext
]

{ #category : 'building' }
CpRevealSection >> code: aString language: aLanguage [

	^ self addContent:
		  (CpRevealCodeContent code: aString language: aLanguage)
]

{ #category : 'accessing' }
CpRevealSection >> contents [

	^ contents
]

{ #category : 'building' }
CpRevealSection >> custom: aViewClass model: aModel [

	^ self addContent:
		  (CpRevealCustomContent viewClass: aViewClass model: aModel)
]

{ #category : 'building' }
CpRevealSection >> doIt: aString [

	^ self addContent: (CpRevealDoItContent code: aString)
]

{ #category : 'testing' }
CpRevealSection >> hasContents [

	^ contents notEmpty
]

{ #category : 'testing' }
CpRevealSection >> hasNotes [

	^ notes notNil and: [ notes notEmpty ]
]

{ #category : 'testing' }
CpRevealSection >> hasSubSections [

	^ subSections notEmpty
]

{ #category : 'accessing' }
CpRevealSection >> heading [

	^ heading
]

{ #category : 'accessing' }
CpRevealSection >> heading: aString [

	heading := aString.
	^ self
]

{ #category : 'building' }
CpRevealSection >> html: aString [

	^ self addContent: (CpRevealMarkupContent html: aString)
]

{ #category : 'building' }
CpRevealSection >> image: aUrl [

	^ self addContent: (CpRevealImageContent url: aUrl alt: '')
]

{ #category : 'building' }
CpRevealSection >> image: aUrl alt: anAlt [

	^ self addContent: (CpRevealImageContent url: aUrl alt: anAlt)
]

{ #category : 'building' }
CpRevealSection >> imageFile: aPath [

	^ self addContent: (CpRevealImageContent fromFile: aPath alt: '')
]

{ #category : 'building' }
CpRevealSection >> imageFile: aPath alt: anAlt [

	^ self addContent: (CpRevealImageContent fromFile: aPath alt: anAlt)
]

{ #category : 'initialization' }
CpRevealSection >> initialize [

	super initialize.
	contents := OrderedCollection new.
	subSections := OrderedCollection new
]

{ #category : 'building' }
CpRevealSection >> markdown: aString [

	^ self addContent: (CpRevealMarkupContent markdown: aString)
]

{ #category : 'building' }
CpRevealSection >> math: aTex [

	^ self addContent: (CpRevealMathContent tex: aTex)
]

{ #category : 'building' }
CpRevealSection >> mermaid: aDiagramOrString [

	^ self addContent: (CpRevealMermaidContent diagram: aDiagramOrString)
]

{ #category : 'accessing' }
CpRevealSection >> notes [

	^ notes
]

{ #category : 'accessing' }
CpRevealSection >> notes: aString [

	notes := aString.
	^ self
]

{ #category : 'accessing' }
CpRevealSection >> subSections [

	^ subSections
]

{ #category : 'accessing' }
CpRevealSection >> subSections: aCollection [

	subSections := aCollection asOrderedCollection.
	^ self
]

{ #category : 'building' }
CpRevealSection >> text: aString [

	^ self addContent: (CpRevealTextContent text: aString)
]

{ #category : 'building' }
CpRevealSection >> title: aTitle [

	^ self addContent: (CpRevealTitleContent title: aTitle)
]

{ #category : 'building' }
CpRevealSection >> title: aTitle subtitle: aSubtitle [

	^ self addContent:
		  (CpRevealTitleContent title: aTitle subtitle: aSubtitle)
]
