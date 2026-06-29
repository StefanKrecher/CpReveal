"
A complete example presentation demonstrating the reveal.js DSL: title, bullets, fragments, code highlighting, vertical slides, math, live doIt, Mermaid flowchart and sequence diagrams, custom HTML and speaker notes. Open at ?reveal-example. Read #createPresentationModel to learn the DSL by example.
"
Class {
	#name : 'CpRevealExampleWebApplication',
	#superclass : 'CpRevealWebApplication',
	#category : 'CodeParadise-WebApplication-Reveal-Examples',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Examples'
}

{ #category : 'building' }
CpRevealExampleWebApplication >> createPresentationModel [

	^ (CpRevealPresentation titled: 'CpReveal')
		  theme: #black;
		  transition: #slide;
		  title: 'CpReveal'
		  subtitle: 'reveal.js presentations, written in Pharo Smalltalk';
		  slide: 'What is CpReveal?' bullets: {
				  ('Beautiful reveal.js decks' -> false).
				  ('described with an elegant Smalltalk DSL' -> true).
				  ('rendered live in the browser via CodeParadise' -> true).
				  ('no JavaScript, no build step' -> true) };
		  slide: 'One message per content block'
		  bullets:
			  #( 'Bullets, code, images and math'
			     'Mermaid diagrams from a Smalltalk builder'
			     'Live Smalltalk execution, right on a slide'
			     'Fragments, vertical slides and speaker notes' );
		  slide: 'Code with syntax highlighting'
		  code:
			  'squaresUpTo: aNumber
    "Answer the squares of 1 to aNumber as an OrderedCollection"
    | result |
    result := OrderedCollection new.
    1 to: aNumber do: [ :each | result add: each squared ].
    ^ result'
		  language: #smalltalk;
		  slide: 'Embed images (URL or local file)'
		  image: 'https://picsum.photos/seed/cpreveal/960/440'
		  alt: 'Sample image';
		  slide: 'Math with KaTeX'
		  math: '\sum_{i=1}^{n} i = \frac{n(n+1)}{2}';
		  slide: 'Architecture' mermaid: (CpMermaidFlowchart new
				   direction: #LR;
				   node: #dsl label: 'Smalltalk DSL' shape: #round;
				   node: #server label: 'Pharo Server';
				   node: #ws label: 'WebSocket';
				   node: #browser label: 'Browser - reveal.js' shape: #stadium;
				   edge: #dsl to: #server;
				   edge: #server to: #ws label: 'render';
				   edge: #ws to: #browser label: 'bytecode';
				   yourself);
		  slide: 'The model (class diagram)' mermaid: (CpMermaidClass new
			   class: #CpRevealPresentation method: 'slide:bullets:';
			   class: #CpRevealPresentation method: 'verticals:';
			   class: #CpRevealSection attribute: 'contents';
			   class: #CpRevealContent;
			   relation: #CpRevealPresentation
			   association: #CpRevealSection
			   label: 'sections';
			   relation: #CpRevealSection
			   association: #CpRevealContent
			   label: 'contents';
			   relation: #CpRevealCodeContent inherits: #CpRevealContent;
			   relation: #CpRevealMermaidContent inherits: #CpRevealContent;
			   yourself);
		  slide: 'Roadmap (gantt)' mermaid: (CpMermaidGantt new
			   title: 'CpReveal';
			   section: 'Core';
			   task: 'DSL and model'
			   id: #core
			   start: '2026-06-01'
			   duration: '10d';
			   task: 'reveal.js rendering' after: #core duration: '8d';
			   section: 'Extras';
			   task: 'Mermaid and doIt' start: '2026-06-20' duration: '7d';
			   task: 'Polish and docs' start: '2026-06-28' duration: '5d';
			   yourself);
		  verticals: [ :v |
				  v
					  slide: 'Vertical slides'
					  text: 'Press the down arrow for more detail'.
				  v
					  slide: 'Drill down'
					  bullets:
					  #( 'Group related points' 'without cluttering the main flow' ) ];
		  slide: 'Run Smalltalk live'
		  doIt: '(1 to: 10) inject: 0 into: [ :a :b | a + b ]';
		  slide: 'Full flexibility' with: [ :s |
			  s
				  title: 'Need something special?'
				  subtitle: 'drop down to raw HTML anytime'.
			  s html:
				  '<p style="color:#4ec9b0;font-size:0.9em">Any <b>HTML</b>, CSS or web component fits right in.</p>' ];
		  slide: 'Get started' with: [ :s |
			  s title: 'Get started' subtitle: 'three steps'.
			  s bullets: #( 'Load CodeParadise + the Reveal package'
				     'Subclass CpRevealWebApplication'
				     'Implement #createPresentationModel and open in a browser' ) ];
		  notesForLastSlide: 'Thanks for watching - questions?';
		  yourself
]
