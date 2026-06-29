Class {
	#name : 'CpRevealTitleContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'title',
		'subtitle'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealTitleContent class >> title: aTitle [

	^ self title: aTitle subtitle: nil
]

{ #category : 'instance creation' }
CpRevealTitleContent class >> title: aTitle subtitle: aSubtitle [

	^ self new setTitle: aTitle subtitle: aSubtitle
]

{ #category : 'rendering' }
CpRevealTitleContent >> renderRevealOn: r [

	r
		emit: '<h1>';
		emit: (r escape: title);
		emit: '</h1>'.
	subtitle ifNotNil: [ :s |
			r
				emit: '<h3>';
				emit: (r escape: s);
				emit: '</h3>' ]
]

{ #category : 'initialization' }
CpRevealTitleContent >> setTitle: aTitle subtitle: aSubtitle [

	title := aTitle.
	subtitle := aSubtitle
]

{ #category : 'accessing' }
CpRevealTitleContent >> subtitle [

	^ subtitle
]

{ #category : 'accessing' }
CpRevealTitleContent >> title [

	^ title
]
