"
I am the client-side reveal.js container (custom element cp-reveal-presentation, runs in the browser).

On class install #postInstallOnce calls #loadLibrary which loads reveal.js + plugins (highlight, notes, math) and helper JS from CDN. #initializeShadowRoot builds a light-DOM .reveal>.slides structure and initialises reveal.js exactly once (guarded against double-init). #renderSlides: replaces the slides inner HTML, re-syncs reveal.js, wires doIt buttons and triggers Mermaid rendering.

Important: reveal.js lives in the LIGHT DOM (not the shadow root) because the CDN stylesheet cannot cross the shadow boundary.
"
Class {
	#name : 'CpRevealPresentationView',
	#superclass : 'CpView',
	#category : 'CodeParadise-WebApplication-Reveal-View',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'View'
}

{ #category : 'web resources' }
CpRevealPresentationView class >> globalStyle [

	<webResource: #css>
	^ 'html, body { height: 100%; margin: 0; padding: 0; }
cp-reveal-presentation { display: block; width: 100vw; height: 100vh; }
cp-reveal-presentation .reveal { width: 100%; height: 100%; }
.reveal h1, .reveal h2, .reveal h3 { letter-spacing: -0.01em; }
.reveal section img { border-radius: 10px; box-shadow: 0 10px 35px rgba(0,0,0,.55); max-height: 460px; }
.reveal pre { box-shadow: 0 8px 28px rgba(0,0,0,.45); width: 92%; margin: 0 auto; }
.reveal pre code.hljs { color: #f8f8f2; background: #272822; }
.reveal pre code .hljs-keyword, .reveal pre code .hljs-selector-tag, .reveal pre code .hljs-literal, .reveal pre code .hljs-section, .reveal pre code .hljs-link, .reveal pre code .hljs-name { color: #f92672; }
.reveal pre code .hljs-string, .reveal pre code .hljs-attr, .reveal pre code .hljs-meta-string { color: #e6db74; }
.reveal pre code .hljs-number, .reveal pre code .hljs-variable, .reveal pre code .hljs-template-variable, .reveal pre code .hljs-symbol, .reveal pre code .hljs-bullet { color: #ae81ff; }
.reveal pre code .hljs-comment, .reveal pre code .hljs-quote, .reveal pre code .hljs-meta { color: #75715e; font-style: italic; }
.reveal pre code .hljs-class, .reveal pre code .hljs-title, .reveal pre code .hljs-type, .reveal pre code .hljs-built_in { color: #66d9ef; font-style: italic; }
.reveal pre code .hljs-function .hljs-title, .reveal pre code .hljs-params { color: #a6e22e; }
.reveal .cp-mermaid { margin: 0 auto; }
.reveal .cp-mermaid svg { max-height: 480px; }
.cp-doit { display: flex; flex-direction: column; gap: 10px; max-width: 820px; margin: 0 auto; text-align: left; }
.cp-doit-code { width: 100%; box-sizing: border-box; font-family: monospace; font-size: 0.45em; line-height: 1.45; padding: 10px; border-radius: 8px; border: 1px solid #444; background: #1e1e1e; color: #d4d4d4; }
.cp-doit-run { align-self: flex-start; padding: 7px 20px; font-size: 0.45em; cursor: pointer; border-radius: 8px; border: none; background: #4ec9b0; color: #06231d; font-weight: bold; }
.cp-doit-run:hover { background: #6fe3cc; }
.cp-doit-result { width: 100%; box-sizing: border-box; min-height: 1.4em; font-family: monospace; font-size: 0.45em; padding: 10px; border-radius: 8px; background: #11211d; color: #8be9c4; white-space: pre-wrap; margin: 0; border-left: 3px solid #4ec9b0; }
.cp-doit-error { color: #ff7b72; border-left-color: #ff7b72; }
.cp-edit-toggle { position: fixed; bottom: 14px; right: 14px; z-index: 1000; padding: 8px 14px; font: bold 13px sans-serif; border: none; border-radius: 8px; background: rgba(78,201,176,.9); color: #06231d; cursor: pointer; opacity: .35; transition: opacity .2s; }
.cp-edit-toggle:hover { opacity: 1; }
.cp-editor { position: fixed; inset: 0; z-index: 1001; display: none; background: rgba(0,0,0,.6); }
.cp-editor.cp-editor-open { display: flex; align-items: center; justify-content: center; }
.cp-editor-panel { width: min(940px, 92vw); height: 82vh; display: flex; flex-direction: column; background: #1e1e1e; border-radius: 12px; box-shadow: 0 20px 60px rgba(0,0,0,.6); overflow: hidden; }
.cp-editor-head { padding: 11px 16px; font: 13px sans-serif; color: #9cdcfe; background: #11211d; }
.cp-editor-source { flex: 1; width: 100%; box-sizing: border-box; border: none; padding: 14px; font-family: monospace; font-size: 14px; line-height: 1.5; background: #1e1e1e; color: #d4d4d4; resize: none; outline: none; tab-size: 4; }
.cp-editor-bar { display: flex; align-items: center; gap: 12px; padding: 10px 16px; background: #11211d; }
.cp-editor-apply { padding: 7px 16px; border: none; border-radius: 7px; background: #4ec9b0; color: #06231d; font-weight: bold; cursor: pointer; }
.cp-editor-close { padding: 7px 16px; border: 1px solid #555; border-radius: 7px; background: transparent; color: #ccc; cursor: pointer; }
.cp-editor-status { font: 13px monospace; color: #8be9c4; }
.cp-editor-status.cp-editor-error { color: #ff7b72; }'
]

{ #category : 'library loading' }
CpRevealPresentationView class >> helperScript [

	^ '
window.cpRevealState = function(host) { if (!host.__cpReveal) { host.__cpReveal = { deck: null, ready: false, pendingConfig: null }; } return host.__cpReveal; };
window.cpRevealEnsure = function(host, cb) {
  if (window.Reveal && window.RevealNotes && window.RevealMath) { cb(); return; }
  window.requestAnimationFrame(function() { window.cpRevealEnsure(host, cb); });
};
window.cpRevealInit = function(host, cfgJson) {
  var st = window.cpRevealState(host);
  if (st.deck) { return; }
  window.cpRevealEnsure(host, function() {
    var el = host.querySelector(".reveal");
    if (!el) { return; }
    var cfg = {};
    try { cfg = JSON.parse(cfgJson || "{}"); } catch (e) {}
    cfg.embedded = true;
    cfg.plugins = [ window.RevealNotes, window.RevealMath.KaTeX ];
    var deck = new window.Reveal(el, cfg);
    deck.initialize().then(function() {
      st.deck = deck; st.ready = true;
      if (st.pendingConfig) { deck.configure(st.pendingConfig); }
      deck.on("slidechanged", function(ev) {
        host.dispatchEvent(new CustomEvent("cp-reveal-slidechanged", { detail: { indexh: ev.indexh, indexv: ev.indexv } }));
      });
      deck.layout();
    });
  });
};
window.cpRevealSync = function(host) { var st = window.cpRevealState(host); if (st.deck && st.ready) { st.deck.sync(); st.deck.layout(); } };
window.cpRevealHighlight = function(host) {
  var doHl = function(hl) {
    var blocks = host.querySelectorAll(".reveal pre code");
    Array.prototype.forEach.call(blocks, function(block) {
      if (block.dataset.cpHl) { return; }
      block.dataset.cpHl = "1";
      try { hl.highlightElement(block); } catch (e) {}
    });
  };
  if (window.__cpHljs) { doHl(window.__cpHljs); return; }
  if (!window.__cpHljsPromise) {
    window.__cpHljsPromise = import("https://cdn.jsdelivr.net/npm/@highlightjs/cdn-assets@11/es/highlight.min.js").then(function(core) {
      var hl = core.default;
      return import("https://cdn.jsdelivr.net/npm/@highlightjs/cdn-assets@11/es/languages/smalltalk.min.js").then(function(st) {
        hl.registerLanguage("smalltalk", st.default);
        window.__cpHljs = hl;
        return hl;
      });
    });
  }
  window.__cpHljsPromise.then(function(hl) { doHl(hl); }).catch(function(e) { console.error("hljs load failed", e); });
};
window.cpRevealConfigure = function(host, cfgJson) {
  var st = window.cpRevealState(host);
  var cfg = {};
  try { cfg = JSON.parse(cfgJson || "{}"); } catch (e) {}
  st.pendingConfig = Object.assign(st.pendingConfig || {}, cfg);
  if (st.deck && st.ready) { st.deck.configure(st.pendingConfig); }
};
window.cpRevealGoTo = function(host, h, v) { var st = window.cpRevealState(host); if (st.deck) { st.deck.slide(h, v || 0); } };
window.cpMermaidRender = function(host) {
  var els = host.querySelectorAll(".cp-mermaid");
  if (!els || els.length === 0) { return; }
  var run = function(mermaid) {
    Array.prototype.forEach.call(els, function(el) {
      if (el.getAttribute("data-rendered")) { return; }
      var code = el.textContent;
      el.setAttribute("data-rendered", "1");
      window.__cpMermaidSeq = (window.__cpMermaidSeq || 0) + 1;
      mermaid.render("cpm-" + window.__cpMermaidSeq, code).then(function(res) { el.innerHTML = res.svg; }).catch(function(e) {
        el.textContent = "Mermaid error: " + (e && e.message ? e.message : e);
        el.removeAttribute("data-rendered");
      });
    });
  };
  if (window.__cpMermaid) { run(window.__cpMermaid); return; }
  import("https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs").then(function(mod) {
    var mermaid = mod.default;
    mermaid.initialize({ startOnLoad: false, theme: "dark", securityLevel: "loose" });
    window.__cpMermaid = mermaid;
    run(mermaid);
  }).catch(function(e) { console.error("mermaid load failed", e); });
};
'
]

{ #category : 'library loading' }
CpRevealPresentationView class >> loadLibrary [
	"Load reveal.js core, plugins and helpers from CDN (once per client image). Theme via #applyTheme:, code highlighting via own highlight.js in #cpRevealHighlight."

	CpHtmlElement documentAddStylesheet:
		'https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/dist/reveal.css'.
	CpHtmlElement documentAddStylesheet:
		'https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/plugin/highlight/monokai.css'.
	CpHtmlElement
		documentAddExternalScript:
			'https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/dist/reveal.js'
		type: nil
		id: #cpRevealCore;
		documentAddExternalScript:
			'https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/plugin/notes/notes.js'
		type: nil
		id: #cpRevealNotes;
		documentAddExternalScript:
			'https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/plugin/math/math.js'
		type: nil
		id: #cpRevealMath;
		documentAddScript: self helperScript type: nil id: #cpRevealHelpers
]

{ #category : 'class initialization' }
CpRevealPresentationView class >> postInstallOnce [

	<clientEnvironment>
	self loadLibrary
]

{ #category : 'web resources' }
CpRevealPresentationView class >> style [

	<webResource: #css>
	^ ':host { display: block; width: 100vw; height: 100vh; }'
]

{ #category : 'web resources' }
CpRevealPresentationView class >> template [

	<webResource: #html>
	^ '<slot></slot>'
]

{ #category : 'editor' }
CpRevealPresentationView >> applyEditor [

	| src |
	src := (self firstDescendantMatching: '.cp-editor-source')
		       propertyAt: #value.
	self serverAnnounce: (CpRevealApplySource code: src)
]

{ #category : 'rendering' }
CpRevealPresentationView >> applyTheme: aSymbol [
	"Load/replace the reveal.js theme stylesheet in the document head"

	| head link url |
	url := 'https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/dist/theme/'
	       , aSymbol asString , '.css'.
	head := CpHtmlElement documentHead.
	link := head firstDescendantMatching: '#cpRevealTheme'.
	link ifNil: [
			link := CpHtmlElement newWithTag: #link.
			link attributeAt: #id put: 'cpRevealTheme'.
			link attributeAt: #rel put: 'stylesheet'.
			head appendChild: link ].
	link attributeAt: #href put: url
]

{ #category : 'rendering' }
CpRevealPresentationView >> applyTransition: aSymbol [

	CpDomElement globalApply: #cpRevealConfigure withArguments: {
			self.
			('{"transition":"' , aSymbol asString , '"}') }
]

{ #category : 'editor' }
CpRevealPresentationView >> buildEditor [
	"Build the floating Edit button and the (hidden) editor overlay in the light DOM"

	| toggle overlay |
	toggle := CpHtmlElement newWithTag: #button.
	toggle
		attributeAt: #class put: 'cp-edit-toggle';
		attributeAt: #type put: 'button';
		textContent: 'Edit deck'.
	toggle when: CpClickEvent basicPrimary send: #openEditor to: self.
	self appendChild: toggle.
	overlay := CpHtmlElement newWithTag: #div.
	overlay attributeAt: #class put: 'cp-editor'.
	overlay
		propertyAt: #innerHTML
		put:
		'<div class="cp-editor-panel"><div class="cp-editor-head">createPresentationModel &mdash; edit the Smalltalk DSL and apply</div><textarea class="cp-editor-source" spellcheck="false"></textarea><div class="cp-editor-bar"><button class="cp-editor-apply" type="button">Apply &amp; reload</button><button class="cp-editor-close" type="button">Close</button><span class="cp-editor-status"></span></div></div>'.
	self appendChild: overlay.
	(overlay firstDescendantMatching: '.cp-editor-apply')
		when: CpClickEvent basicPrimary
		send: #applyEditor
		to: self.
	(overlay firstDescendantMatching: '.cp-editor-close')
		when: CpClickEvent basicPrimary
		send: #closeEditor
		to: self
]

{ #category : 'rendering' }
CpRevealPresentationView >> buildRevealSkeleton [
	"Build the empty .reveal > .slides structure in the light DOM"

	| reveal slides |
	reveal := CpHtmlElement newWithTag: #div.
	reveal attributeAt: #class put: 'reveal'.
	slides := CpHtmlElement newWithTag: #div.
	slides attributeAt: #class put: 'slides'.
	reveal appendChild: slides.
	self appendChild: reveal
]

{ #category : 'editor' }
CpRevealPresentationView >> closeEditor [

	self editorOverlay ifNotNil: [ :o |
		o attributeAt: #class put: 'cp-editor' ]
]

{ #category : 'rendering' }
CpRevealPresentationView >> configJsonString [

	^ '{}'
]

{ #category : 'editor' }
CpRevealPresentationView >> editorOverlay [

	^ self firstDescendantMatching: '.cp-editor'
]

{ #category : 'doit' }
CpRevealPresentationView >> handleDoItRun: anEvent [
	"Read the code from the textarea next to the clicked button and ask the server to run it"

	| button container code idx |
	button := anEvent target.
	container := button firstAncestorMatching: '.cp-doit'.
	container ifNil: [ ^ self ].
	idx := container attributeAt: 'data-doit'.
	code := (container firstDescendantMatching: '.cp-doit-code')
		        propertyAt: #value.
	self serverAnnounce: (CpRevealRunCode index: idx code: code)
]

{ #category : 'initialization' }
CpRevealPresentationView >> initializeShadowRoot [

	super initializeShadowRoot.
	self buildRevealSkeleton.
	self buildEditor.
	CpDomElement globalApply: #cpRevealInit withArguments: {
			self.
			self configJsonString }
]

{ #category : 'editor' }
CpRevealPresentationView >> openEditor [

	self editorOverlay ifNotNil: [ :o |
		o attributeAt: #class put: 'cp-editor cp-editor-open' ].
	self serverAnnounce: CpRevealEditRequest new
]

{ #category : 'rendering' }
CpRevealPresentationView >> renderSlides: aString [
	"Set the inner HTML of the .slides container, re-sync reveal.js and wire interactive widgets"

	(self firstDescendantMatching: '.slides') ifNotNil: [ :slides |
		slides propertyAt: #innerHTML put: aString ].
	CpDomElement globalApply: #cpRevealSync withArguments: { self }.
	CpDomElement globalApply: #cpRevealHighlight withArguments: { self }.
	self wireDoItButtons.
	CpDomElement globalApply: #cpMermaidRender withArguments: { self }
]

{ #category : 'doit' }
CpRevealPresentationView >> showDoItResult: idx text: aString isError: aBoolean [
	"Display the evaluation result in the matching doIt result area"

	| container pre |
	container := self firstDescendantMatching:
		             '.cp-doit[data-doit="' , idx , '"]'.
	container ifNil: [ ^ self ].
	pre := container firstDescendantMatching: '.cp-doit-result'.
	pre ifNil: [ ^ self ].
	pre textContent: aString.
	pre attributeAt: 'class' put: (aBoolean
			 ifTrue: [ 'cp-doit-result cp-doit-error' ]
			 ifFalse: [ 'cp-doit-result' ])
]

{ #category : 'editor' }
CpRevealPresentationView >> showEditorSource: aString [

	(self firstDescendantMatching: '.cp-editor-source') ifNotNil: [ :ta |
		ta propertyAt: #value put: aString ].
	self editorOverlay ifNotNil: [ :o |
		o attributeAt: #class put: 'cp-editor cp-editor-open' ]
]

{ #category : 'editor' }
CpRevealPresentationView >> showEditorStatus: aString isError: aBoolean [

	(self firstDescendantMatching: '.cp-editor-status') ifNotNil: [ :st |
			st textContent: aString.
			st attributeAt: #class put: (aBoolean
					 ifTrue: [ 'cp-editor-status cp-editor-error' ]
					 ifFalse: [ 'cp-editor-status' ]) ]
]

{ #category : 'doit' }
CpRevealPresentationView >> wireDoItButtons [
	"Attach click handlers to all doIt run buttons in the current slides"

	(self allDescendantsMatching: '.cp-doit-run') do: [ :button |
		button
			when: CpClickEvent basicPrimary
			send: #handleDoItRun:
			to: self ]
]
