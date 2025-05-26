"
I am a minimal application launcher for demonstrating a SpecComponentsLibrary-based example.

I inherit from `SpApplication` and serve as the entry point for opening a window that hosts an interactive component — in this case, a `LibraryTable` or other UI element.

### Instance Variables

- _mainPresenter_ — reserved for holding the root UI presenter (currently unused).

### Public API

- `ExampleApp>>#start` - instantiates the main presenter (`LibraryTable`), assigns the application context, and opens the UI in a window. The window’s control boxes (expand, collapse, menu) are removed for a cleaner appearance.

### Usage

```smalltalk
ExampleApp new start

"
Class {
	#name : 'ExampleApp',
	#superclass : 'SpApplication',
	#instVars : [
		'mainPresenter'
	],
	#category : 'SpecComponentsLibrary-Examples-SimpleExamples',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'SimpleExamples'
}

{ #category : 'initialization' }
ExampleApp >> initialize [

	super initialize.
	
]

{ #category : 'initialization' }
ExampleApp >> start [

	| window p |
	p := LibraryTable new.
	p application: self.
	window := p open.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]
