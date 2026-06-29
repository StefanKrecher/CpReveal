Class {
	#name : 'CpRevealImageContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'url',
		'alt',
		'caption'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealImageContent class >> fromFile: aPath alt: anAlt [
	"Read a local image file and answer an image content embedding it as a data: URI"

	| ref bytes mime |
	ref := aPath asFileReference.
	bytes := ref binaryReadStream upToEnd.
	mime := self mimeTypeForExtension: ref extension.
	^ self
		  url: 'data:' , mime , ';base64,' , bytes base64Encoded
		  alt: anAlt
]

{ #category : 'instance creation' }
CpRevealImageContent class >> mimeTypeForExtension: ext [

	| e |
	e := ext asLowercase.
	e = 'png' ifTrue: [ ^ 'image/png' ].
	(e = 'jpg' or: [ e = 'jpeg' ]) ifTrue: [ ^ 'image/jpeg' ].
	e = 'gif' ifTrue: [ ^ 'image/gif' ].
	e = 'svg' ifTrue: [ ^ 'image/svg+xml' ].
	e = 'webp' ifTrue: [ ^ 'image/webp' ].
	^ 'application/octet-stream'
]

{ #category : 'instance creation' }
CpRevealImageContent class >> url: aUrl alt: anAlt [

	^ self new setUrl: aUrl alt: anAlt
]

{ #category : 'accessing' }
CpRevealImageContent >> alt [

	^ alt ifNil: [ '' ]
]

{ #category : 'accessing' }
CpRevealImageContent >> caption [

	^ caption
]

{ #category : 'accessing' }
CpRevealImageContent >> caption: aString [

	caption := aString.
	^ self
]

{ #category : 'rendering' }
CpRevealImageContent >> renderRevealOn: r [

	caption isNil
		ifTrue: [
				r
					emit: '<img src="';
					emit: (r escape: url);
					emit: '" alt="';
					emit: (r escape: alt);
					emit: '">' ]
		ifFalse: [
				r
					emit: '<figure><img src="';
					emit: (r escape: url);
					emit: '" alt="';
					emit: (r escape: alt);
					emit: '"><figcaption>';
					emit: (r escape: caption);
					emit: '</figcaption></figure>' ]
]

{ #category : 'initialization' }
CpRevealImageContent >> setUrl: aUrl alt: anAlt [

	url := aUrl.
	alt := anAlt
]

{ #category : 'accessing' }
CpRevealImageContent >> url [

	^ url
]
