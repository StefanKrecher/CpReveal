Class {
	#name : 'CpRevealMarkupContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'markup',
		'isMarkdown'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealMarkupContent class >> html: aString [

	^ self new setMarkup: aString isMarkdown: false
]

{ #category : 'instance creation' }
CpRevealMarkupContent class >> markdown: aString [

	^ self new setMarkup: aString isMarkdown: true
]

{ #category : 'accessing' }
CpRevealMarkupContent >> isMarkdown [

	^ isMarkdown == true
]

{ #category : 'accessing' }
CpRevealMarkupContent >> markup [

	^ markup
]

{ #category : 'rendering' }
CpRevealMarkupContent >> renderRevealOn: r [

	r emit: (markup ifNil: [ '' ])
]

{ #category : 'initialization' }
CpRevealMarkupContent >> setMarkup: aString isMarkdown: aBoolean [

	markup := aString.
	isMarkdown := aBoolean
]
