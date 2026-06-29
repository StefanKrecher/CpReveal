# CpReveal

**Beautiful [reveal.js](https://revealjs.com) presentations, written entirely in Pharo Smalltalk.**

CpReveal is an extension for [CodeParadise](https://github.com/ErikOnBike/CodeParadise) that lets
you describe slide decks with a small, elegant Smalltalk DSL and render them live in the browser —
no JavaScript, no build step. It adds a few things plain reveal.js doesn't give you out of the box:
**Mermaid diagrams built with a Smalltalk DSL** and a **live code component** that runs Smalltalk on
the server and shows the result on the slide.

---

## Features

- Clean slide-building DSL — a bullet list is just an array of strings
- All the reveal.js essentials: themes, transitions, keyboard/touch navigation, slide overview
- **Fragments** (step-by-step reveals) and **vertical slides** (2D navigation)
- **Speaker notes** view (press `S`)
- **Code** with syntax highlighting (highlight.js) and **math** with KaTeX
- **Mermaid diagrams** from a Smalltalk builder: flowchart, sequence, class diagram, gantt
- **Live `doIt`**: evaluate Smalltalk on the server and display the result on the slide
- **Images** by URL or embedded from a local file
- Edit live in the browser with CodeParadise's view inspector; presentations are stored in the image
- Full escape hatch: raw HTML and custom web components anywhere

---

## Requirements

- Pharo 10–13 (developed on Pharo 13)
- [CodeParadise](https://github.com/ErikOnBike/CodeParadise)

---

## Installation

Load CodeParadise first:

```smalltalk
Metacello new
    repository: 'github://ErikOnBike/CodeParadise';
    baseline: 'CodeParadise';
    load.
```

Then load this package (adjust the repository to your fork):

```smalltalk
Metacello new
    repository: 'github://StefanKrecher/CpReveal';
    baseline: 'CpReveal';
    load.
```

Start the CodeParadise development server:

```smalltalk
CpDevTools start.
```

---

## Quickstart

Subclass `CpRevealWebApplication` and implement `#createPresentationModel`:

```smalltalk
CpRevealWebApplication subclass: #MyTalkWebApplication
    instanceVariableNames: ''
    classVariableNames: ''
    package: 'MyTalk'.

MyTalkWebApplication >> createPresentationModel
    ^ (CpRevealPresentation titled: 'My First Talk')
        theme: #black;
        transition: #slide;
        title: 'My First Talk' subtitle: 'Made with CpReveal';
        slide: 'Why Smalltalk?' bullets: #('Live' 'Simple' 'Powerful');
        slide: 'Run it live' doIt: '42 factorial';
        yourself
```

Register and open it:

```smalltalk
MyTalkWebApplication register; openInBrowser.
```

The URL is derived automatically from the class name
(`MyTalkWebApplication` → `http://localhost:8080/static/app.html?my-talk`).

---

## The DSL

A presentation is an ordered list of slides. Every `slide:…:` message appends one slide; the
messages all return the presentation, so you build it with a cascade ending in `yourself`.

```smalltalk
(CpRevealPresentation titled: 'Demo')
    theme: #black;                  "black white league beige sky night serif simple solarized moon dracula"
    transition: #slide;             "none fade slide convex concave zoom"

    "Title slide (centered h1 + optional subtitle)"
    title: 'Main Title' subtitle: 'Subtitle';

    "Bullets: just an array of strings"
    slide: 'Heading' bullets: #('one' 'two' 'three');

    "Bullets with fragments: text -> appearsAsFragment"
    slide: 'Step by step' bullets: { 'shown first' -> false. 'as fragment' -> true };

    "Code with highlighting"
    slide: 'Code' code: 'foo ^ 42' language: #smalltalk;

    "Math (KaTeX)"
    slide: 'Math' math: 'E = mc^2';

    "Image by URL, or from a local file"
    slide: 'Photo' image: 'https://example.org/pic.png' alt: 'A picture';
    slide: 'Logo'  imageFile: '/path/to/logo.png';

    "Live Smalltalk execution"
    slide: 'Live' doIt: '(1 to: 10) inject: 0 into: [ :a :b | a + b ]';

    "Vertical 2D stack"
    verticals: [ :v |
        v slide: 'Top' text: 'press down for more'.
        v slide: 'Below' bullets: #('a' 'b') ];

    "Multi-content slide — compose freely"
    slide: 'Mixed' with: [ :s |
        s title: 'Header' subtitle: 'sub'.
        s bullets: #('point').
        s code: 'self halt' language: #smalltalk.
        s html: '<b>raw HTML too</b>' ];

    "Speaker notes for the slide just added (press S in the browser)"
    notesForLastSlide: 'Remember to smile';
    yourself
```

### Content types

| Message (on a slide builder) | Content |
|---|---|
| `title:subtitle:` | Big title + subtitle |
| `text:` | A paragraph |
| `bullets:` | Unordered list (strings, or `text -> isFragment` associations) |
| `code:language:` | Highlighted code block |
| `math:` | KaTeX formula |
| `image:alt:` / `imageFile:` | Image by URL / embedded local file |
| `mermaid:` | Mermaid diagram (builder or raw string) |
| `doIt:` | Live server-side Smalltalk evaluation |
| `html:` / `markdown:` | Raw HTML markup |
| `custom:model:` | Your own CodeParadise view |

`slide:KIND:` creates a one-block slide; `slide:with:` and `verticals:` take a block for richer
composition. Send `beFragment` to any content to reveal the whole block as a fragment.

---

## Mermaid diagrams

Build diagrams with a Smalltalk DSL (or pass a raw mermaid `String`):

```smalltalk
"Flowchart"
CpMermaidFlowchart new
    direction: #LR;                                "#TD #TB #BT #LR #RL"
    node: #a label: 'Start';
    node: #b label: 'Decision' shape: #diamond;    "#box #round #diamond #stadium"
    edge: #a to: #b;
    edge: #b to: #c label: 'yes';
    yourself.

"Sequence"
CpMermaidSequence new
    participant: #u as: 'User';
    participant: #s as: 'Server';
    message: #u to: #s text: 'request';
    reply: #s to: #u text: 'response';
    yourself.

"Class diagram"
CpMermaidClass new
    class: #Animal attribute: 'String name';
    class: #Animal method: 'makeSound';
    relation: #Dog inherits: #Animal;
    yourself.

"Gantt"
CpMermaidGantt new
    title: 'Roadmap';
    section: 'Phase 1';
    task: 'Design' id: #d1 start: '2024-01-01' duration: '7d';
    task: 'Build' after: #d1 duration: '14d';
    yourself.
```

Pass any of these to a slide: `slide: 'Architecture' mermaid: aDiagram`.

---

## Live code execution (`doIt`)

`slide: 'Live' doIt: '42 factorial'` renders an editable code area, a **Run** button and a result
area. Clicking **Run** sends the (possibly edited) code to the Pharo server, evaluates it and shows
the result — or a red error message.

> ⚠️ `doIt` evaluates arbitrary Smalltalk on the server. Use it as a local presentation/authoring
> tool only; do not expose it to untrusted users.

---

## Authoring in the browser

**Edit the deck without leaving the browser.** Click the **Edit deck** button (bottom-right) to open
an editor showing the Smalltalk source of your `#createPresentationModel`. Edit the DSL, hit
**Apply & reload**, and the method is recompiled on the server and the deck re-renders live. Compile
errors are shown inline.

For the web components themselves (templates / CSS), CodeParadise's view inspector is also enabled:

- `Ctrl/Cmd+I` — open the view inspector
- `Ctrl/Cmd+B` — pick a web component
- `Ctrl/Cmd+S` — apply changes in the browser
- `Shift+Ctrl/Cmd+S` — save changes back into the Pharo image

Presentation content lives in your `#createPresentationModel` method and is stored with the image
(`Smalltalk snapshot: true andQuit: false`).

---

## Example

`CpRevealExampleWebApplication` is a complete demo of every feature. Open it at:

```
http://localhost:8080/static/app.html?reveal-example
```

Read its `#createPresentationModel` to learn the DSL by example.

---

## How it works

CpReveal reuses CodeParadise's MVP model. The presentation model
(`CpRevealPresentation` → `CpRevealSection` → `CpRevealContent`) is rendered to the reveal.js
`.reveal > .slides` HTML by `CpRevealHtmlRenderer` on the server and handed to a single client view
(`CpRevealPresentationView`), which loads reveal.js + plugins + Mermaid from a CDN and manages the
deck lifecycle. reveal.js runs in the light DOM so its stylesheet applies. Interactive widgets
(`doIt`) talk back to the server via CodeParadise announcements.

---

## Limitations (v1)

- `custom:model:` (live child views inside a slide) currently renders a placeholder
- `markdown:` is treated as raw HTML (the reveal.js markdown plugin is not wired up)
- External assets (reveal.js, plugins, Mermaid) are loaded from a CDN, so an internet connection is
  needed unless you mirror them locally

---

## License

MIT (or your preference).
