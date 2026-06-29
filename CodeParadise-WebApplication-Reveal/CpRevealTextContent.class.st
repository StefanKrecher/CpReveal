Class {
	#name : 'CpRevealTextContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'text'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealTextContent class >> text: aString [

	^ self new setText: aString
]

{ #category : 'rendering' }
CpRevealTextContent >> renderRevealOn: r [

	r
		emit: '<p>';
		emit: (r escape: text);
		emit: '</p>'
]

{ #category : 'initialization' }
CpRevealTextContent >> setText: aString [

	text := aString
]

{ #category : 'accessing' }
CpRevealTextContent >> text [

	^ text
]
