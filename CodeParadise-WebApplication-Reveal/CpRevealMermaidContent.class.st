Class {
	#name : 'CpRevealMermaidContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'diagramText'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealMermaidContent class >> diagram: aDiagramOrString [
	"Accept a CpMermaidDiagram (responds to #mermaidText) or a raw mermaid String"

	^ self new setDiagram: aDiagramOrString
]

{ #category : 'accessing' }
CpRevealMermaidContent >> diagramText [

	^ diagramText
]

{ #category : 'rendering' }
CpRevealMermaidContent >> renderRevealOn: r [

	r
		emit: '<div class="cp-mermaid">';
		emit: (r escape: diagramText);
		emit: '</div>'
]

{ #category : 'initialization' }
CpRevealMermaidContent >> setDiagram: aDiagramOrString [

	diagramText := aDiagramOrString isString
		               ifTrue: [ aDiagramOrString ]
		               ifFalse: [ aDiagramOrString mermaidText ]
]
