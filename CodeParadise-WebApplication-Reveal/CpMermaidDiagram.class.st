"
I am the abstract base of the Mermaid diagram builder DSL. Subclasses (CpMermaidFlowchart, CpMermaidSequence) build Mermaid source text via #mermaidText. Pass an instance to slide:mermaid: (a raw Mermaid String is also accepted there).
"
Class {
	#name : 'CpMermaidDiagram',
	#superclass : 'Object',
	#category : 'CodeParadise-WebApplication-Reveal-Mermaid',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Mermaid'
}

{ #category : 'generating' }
CpMermaidDiagram >> mermaidText [

	^ self subclassResponsibility
]
