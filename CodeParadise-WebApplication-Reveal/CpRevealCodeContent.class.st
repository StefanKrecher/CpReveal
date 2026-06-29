Class {
	#name : 'CpRevealCodeContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'code',
		'language',
		'lineNumbers'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealCodeContent class >> code: aString language: aLanguage [

	^ self new setCode: aString language: aLanguage
]

{ #category : 'accessing' }
CpRevealCodeContent >> code [

	^ code
]

{ #category : 'accessing' }
CpRevealCodeContent >> language [

	^ language ifNil: [ #plaintext ]
]

{ #category : 'accessing' }
CpRevealCodeContent >> lineNumbers [

	^ lineNumbers
]

{ #category : 'accessing' }
CpRevealCodeContent >> lineNumbers: aString [
	"e.g. '1|2-3' for reveal.js progressive line highlighting; answer self"

	lineNumbers := aString.
	^ self
]

{ #category : 'rendering' }
CpRevealCodeContent >> renderRevealOn: r [

	r
		emit: '<pre><code class="language-';
		emit: self language asString;
		emit: '" data-trim'.
	lineNumbers ifNotNil: [ :ln |
			r
				emit: ' data-line-numbers="';
				emit: (r escape: ln);
				emit: '"' ].
	r emit: '>'.
	r emit: (r escape: code).
	r emit: '</code></pre>'
]

{ #category : 'initialization' }
CpRevealCodeContent >> setCode: aString language: aLanguage [

	code := aString.
	language := aLanguage
]
