"
I hold an ordered list of slides (CpRevealSection) and provide the slide-building DSL shared by CpRevealPresentation and vertical stacks. Each slide:KIND: message appends a slide with a single content block; slide:with: yields a fresh section for free composition; verticals: builds a vertical 2D stack from a nested builder.
"
Class {
	#name : 'CpRevealSectionList',
	#superclass : 'CpModel',
	#instVars : [
		'sections'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'building' }
CpRevealSectionList >> addSection: aSection [
	"Append a CpRevealSection; answer the section"

	sections add: aSection.
	^ aSection
]

{ #category : 'initialization' }
CpRevealSectionList >> initialize [

	super initialize.
	sections := OrderedCollection new
]

{ #category : 'accessing' }
CpRevealSectionList >> lastSection [

	^ sections ifNotEmpty: [ sections last ] ifEmpty: [ nil ]
]

{ #category : 'building - slides' }
CpRevealSectionList >> notesForLastSlide: aString [
	"Attach reveal.js speaker notes to the most recently added slide"

	self lastSection ifNotNil: [ :s | s notes: aString ].
	^ self
]

{ #category : 'accessing' }
CpRevealSectionList >> sections [

	^ sections
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading bullets: aCollection [
	"aCollection: Strings, or Associations text -> isFragmentBoolean"

	self addSection:
		((CpRevealSection heading: aHeading) bullets: aCollection).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading code: aString [

	^ self slide: aHeading code: aString language: #plaintext
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading code: aString language: aLanguage [

	self addSection:
		((CpRevealSection heading: aHeading)
			 code: aString
			 language: aLanguage).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading doIt: aString [

	self addSection: ((CpRevealSection heading: aHeading) doIt: aString).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading image: aUrl [

	self addSection: ((CpRevealSection heading: aHeading) image: aUrl).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading image: aUrl alt: anAlt [

	self addSection:
		((CpRevealSection heading: aHeading) image: aUrl alt: anAlt).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading imageFile: aPath [

	self addSection:
		((CpRevealSection heading: aHeading) imageFile: aPath).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading imageFile: aPath alt: anAlt [

	self addSection:
		((CpRevealSection heading: aHeading) imageFile: aPath alt: anAlt).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading math: aTex [

	self addSection: ((CpRevealSection heading: aHeading) math: aTex).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading mermaid: aDiagramOrString [

	self addSection:
		((CpRevealSection heading: aHeading) mermaid: aDiagramOrString).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading text: aString [

	self addSection: ((CpRevealSection heading: aHeading) text: aString).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slide: aHeading with: aBlock [
	"Multi-content slide: the block receives the CpRevealSection for free composition"

	| section |
	section := CpRevealSection heading: aHeading.
	aBlock value: section.
	self addSection: section.
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slideHtml: aString [

	self addSection: (CpRevealSection new html: aString).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slideMarkdown: aString [

	self addSection: (CpRevealSection new markdown: aString).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> slideWith: aBlock [
	"Multi-content slide without heading"

	| section |
	section := CpRevealSection new.
	aBlock value: section.
	self addSection: section.
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> title: aTitle [

	^ self title: aTitle subtitle: nil
]

{ #category : 'building - slides' }
CpRevealSectionList >> title: aTitle subtitle: aSubtitle [
	"A centered title slide (h1 + optional h3 subtitle)"

	self addSection:
		(CpRevealSection new title: aTitle subtitle: aSubtitle).
	^ self
]

{ #category : 'building - slides' }
CpRevealSectionList >> verticals: aBlock [
	"A vertical 2D stack: the block receives a section-list builder; each slide:... is a vertical slide"

	| stack |
	stack := CpRevealSectionList new.
	aBlock value: stack.
	self addSection: (CpRevealSection new subSections: stack sections).
	^ self
]
