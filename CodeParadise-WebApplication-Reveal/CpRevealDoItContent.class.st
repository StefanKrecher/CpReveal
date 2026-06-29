Class {
	#name : 'CpRevealDoItContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'code',
		'result',
		'isError',
		'hasResult'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealDoItContent class >> code: aString [

	^ self new setCode: aString
]

{ #category : 'accessing' }
CpRevealDoItContent >> code [

	^ code
]

{ #category : 'accessing' }
CpRevealDoItContent >> code: aString [

	code := aString
]

{ #category : 'accessing' }
CpRevealDoItContent >> hasResult [

	^ hasResult == true
]

{ #category : 'accessing' }
CpRevealDoItContent >> isError [

	^ isError == true
]

{ #category : 'rendering' }
CpRevealDoItContent >> renderRevealOn: r [

	| idx |
	idx := r nextDoItIndex.
	r
		emit: '<div class="cp-doit" data-doit="';
		emit: idx printString;
		emit: '">'.
	r
		emit: '<textarea class="cp-doit-code" spellcheck="false" rows="4">';
		emit: (r escape: code);
		emit: '</textarea>'.
	r emit:
		'<button class="cp-doit-run" type="button">Ausfuehren</button>'.
	r emit: '<pre class="cp-doit-result"></pre>'.
	r emit: '</div>'
]

{ #category : 'accessing' }
CpRevealDoItContent >> result [

	^ result
]

{ #category : 'accessing' }
CpRevealDoItContent >> result: aString isError: aBoolean [

	result := aString.
	isError := aBoolean.
	hasResult := true.
	self valueChanged
]

{ #category : 'initialization' }
CpRevealDoItContent >> setCode: aString [

	code := aString.
	isError := false.
	hasResult := false
]
