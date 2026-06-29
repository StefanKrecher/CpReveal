"
I build Mermaid flowchart source.

  CpMermaidFlowchart new
    direction: #LR;     ""#TD #TB #BT #LR #RL""
    node: #a label: 'Start';
    node: #b label: 'Decision' shape: #diamond;   ""#box #round #diamond #stadium""
    edge: #a to: #b;
    edge: #b to: #c label: 'yes';
    yourself
"
Class {
	#name : 'CpMermaidFlowchart',
	#superclass : 'CpMermaidDiagram',
	#instVars : [
		'direction',
		'nodes',
		'edges'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Mermaid',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Mermaid'
}

{ #category : 'building' }
CpMermaidFlowchart >> direction: aSymbol [

	direction := aSymbol.
	^ self
]

{ #category : 'building' }
CpMermaidFlowchart >> edge: aFrom to: aTo [

	^ self edge: aFrom to: aTo label: nil
]

{ #category : 'building' }
CpMermaidFlowchart >> edge: aFrom to: aTo label: aLabel [

	edges add: (CpMermaidEdge from: aFrom to: aTo label: aLabel).
	^ self
]

{ #category : 'initialization' }
CpMermaidFlowchart >> initialize [

	super initialize.
	direction := #TD.
	nodes := OrderedCollection new.
	edges := OrderedCollection new
]

{ #category : 'generating' }
CpMermaidFlowchart >> mermaidText [

	| s |
	s := WriteStream on: String new.
	s
		nextPutAll: 'flowchart ';
		nextPutAll: direction asString;
		nextPut: Character lf.
	nodes do: [ :n |
			s
				nextPutAll: '  ';
				nextPutAll: n mermaidFragment;
				nextPut: Character lf ].
	edges do: [ :e |
			s
				nextPutAll: '  ';
				nextPutAll: e flowFragment;
				nextPut: Character lf ].
	^ s contents
]

{ #category : 'building' }
CpMermaidFlowchart >> node: anId label: aLabel [

	^ self node: anId label: aLabel shape: #box
]

{ #category : 'building' }
CpMermaidFlowchart >> node: anId label: aLabel shape: aShape [

	nodes add: (CpMermaidNode id: anId label: aLabel shape: aShape).
	^ self
]
