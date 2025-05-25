"
I am a utility class responsible for generating and installing styles for Spec components at runtime.  
I convert a dictionary of visual style properties (such as font size, color, width, etc.) into the STON format used by `SpStyleVariableSTONReader`, and install the resulting style into the active application's style sheet.

I am primarily used by `BasePresenter` and its subclasses to dynamically apply user-defined or programmatically generated style configurations.


### Public API

- `StyleManager class>>#installGeneratedStyleFrom:in:` — creates a new style from the given dictionary and installs it into the style sheet of the specified application. Returns the generated style name.
- `StyleManager>>#stonFromProperties:` — converts a dictionary of style attributes into a STON-style Spec block with categorized sections (e.g., Font, Draw, Container).

### Usage

```smalltalk
| props styleName |
props := Dictionary newFromPairs: {
  #fontSize -> 14.
  #bold -> true.
  #color -> Color black.
  #backgroundColor -> Color veryLightGray.
  #width -> 200 }.

styleName := StyleManager installGeneratedStyleFrom: props in: self application.
presenter mainPresenter addStyle: styleName.


"
Class {
	#name : 'StyleManager',
	#superclass : 'Object',
	#category : 'SpecComponentsLibrary-Style',
	#package : 'SpecComponentsLibrary',
	#tag : 'Style'
}

{ #category : 'adding' }
StyleManager class >> installGeneratedStyleFrom: dict in: app [
"Generates a unique style name and creates a STON style definition from the given dictionary of properties.
Parses it into a Spec style using SpStyleVariableSTONReader, and installs it into the application's style sheet (app styleSheet).
Returns the generated style name as a string."
	| styleManager styleName stonString parsed |
	styleManager := self new.
	styleName := '' , UUID new asString first: 8.
	stonString := styleManager stonFromProperties: dict.
	parsed := SpStyleVariableSTONReader fromString: '
.application [ .' , styleName , ' [ ' , stonString , ' ] ]'.
	parsed styles do: [ :style | app styleSheet addStyle: style ].
	^ styleName
]

{ #category : 'style' }
StyleManager >> stonFromProperties: dict [
"Converts a dictionary of style properties into a STON-style string representation.
Groups the properties into logical Spec categories:

Font: for font-related attributes (fontSize, bold, italic, name)

Draw: for visual appearance (color, backgroundColor)

Geometry: for sizing and layout (width, height, etc.)

Container: for borders and padding

Text: for text-specific flags (textColor, readOnly, etc.)
Each section is output as a STON block, ready to be parsed by Spec."

	| container font draw geometry text sections |
	container := OrderedCollection new.
	font := OrderedCollection new.
	draw := OrderedCollection new.
	geometry := OrderedCollection new.
	text := OrderedCollection new.
	sections := OrderedCollection new.

	dict keysAndValuesDo: [ :k :v |
			(k = #borderColor or: [ k = #borderWidth or: [ k = #padding ] ])
				ifTrue: [ container add: k -> v ].

			(k = #fontSize or: [
				 k = #bold or: [ k = #italic or: [ k = #name ] ] ]) ifTrue: [
					| targetKey |
					targetKey := k = #fontSize
						             ifTrue: [ #size ]
						             ifFalse: [ k ].
					font add: targetKey -> v ].

			(k = #color or: [ k = #backgroundColor ]) ifTrue: [
				draw add: k -> v ].

			(#( height width minHeight maxHeight hResizing vResizing )
				 includes: k) ifTrue: [ geometry add: k -> v ].

			(#( alignment textColor readOnly textWrapping ) includes: k)
				ifTrue: [ text add: k -> v ] ].

	container isEmpty ifFalse: [
		sections add: 'Container { ' , (self stonMap: container) , ' }' ].
	font isEmpty ifFalse: [
		sections add: 'Font { ' , (self stonMap: font) , ' }' ].
	draw isEmpty ifFalse: [
		sections add: 'Draw { ' , (self stonMap: draw) , ' }' ].
	geometry isEmpty ifFalse: [
		sections add: 'Geometry { ' , (self stonMap: geometry) , ' }' ].
	text isEmpty ifFalse: [
		sections add: 'Text { ' , (self stonMap: text) , ' }' ].

	^ String streamContents: [ :stream |
			  sections doWithIndex: [ :part :i |
					  stream nextPutAll: part.
					  i < sections size ifTrue: [ stream nextPutAll: ', ' ] ] ]
]

{ #category : 'style' }
StyleManager >> stonMap: assocCollection [
"Takes a collection of associations (key → value) and returns a formatted string in STON syntax for inclusion in a style block.
Used internally by stonFromProperties: to format each section."
	| strings |
	strings := assocCollection collect: [ :each |
			           | keyStr valStr |
			           keyStr := each key storeString.
			           valStr := each value storeString.
			           (valStr beginsWith: '''') & (valStr endsWith: '''')
				           ifTrue: [
				           valStr := valStr copyFrom: 2 to: valStr size - 1 ].

			           keyStr , ': ' , valStr ].

	^ String streamContents: [ :s |
			  strings doWithIndex: [ :str :i |
					  s nextPutAll: str.
					  i < strings size ifTrue: [ s nextPutAll: ', ' ] ] ]
]
