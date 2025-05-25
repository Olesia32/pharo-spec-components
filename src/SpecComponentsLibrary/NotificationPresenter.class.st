"
I am a lightweight presenter used to display notification messages as overlay morphs in a Pharo window.  
I support positioning relative to a target window, customizable appearance (color, font, size), and different message types such as info, success, warning, and error.  
Notifications disappear automatically after a given duration and are displayed using standard Morphic primitives.  
I am not a Spec presenter, but can be used inside Spec-based applications for transient feedback.

### Instance Variables

- _title_: a `String` — the title displayed at the top of the notification  
- _message_: a `String` or `Text` — the body content of the notification  
- _type_: a `Symbol` — defines the notification type (`#info`, `#success`, `#warning`, `#error`)  
- _duration_: a `Number` — how long the notification stays visible, in seconds  
- _window_: a `SpWindowPresenter` — the window relative to which the notification is positioned  
- _position_: a `Symbol` — one of `#topLeft`, `#topRight`, `#bottomLeft`, `#bottomRight`, `#center`  
- _font_: a `Font` — font used for both title and message  
- _backgroundColor_: a `Color` — background fill of the notification box  
- _textColor_: a `Color` — color of the title and message text  
- _width_: an `Integer` — width of the notification morph  
- _height_: an `Integer` — height of the notification morph

### Public API

- `NotificationPresenter>>#title:`, `NotificationPresenter>>#message:`, `NotificationPresenter>>#type:`, `NotificationPresenter>>#duration:` — basic content and style setters  
- `NotificationPresenter>>#backgroundColor:`, `NotificationPresenter>>#textColor:`, `NotificationPresenter>>#font:` — appearance customization  
- `NotificationPresenter>>#width:`, `NotificationPresenter>>#height:` — set dimensions of the notification morph  
- `NotificationPresenter>>#position:` — sets the relative screen position  
- `NotificationPresenter>>#window:` — sets the window relative to which the notification is anchored  
- `NotificationPresenter>>#show` — displays the notification morph and schedules it for automatic removal

### Usage

To show a simple info notification in the bottom-right of the active window:

```smalltalk
| n |
n := NotificationPresenter new
title: 'Saved';
message: 'Your data has been successfully saved.';
type: '#success';
duration: 4;
width: 200;
position: '#center';
window: World activeWindow;
show.

"
Class {
	#name : 'NotificationPresenter',
	#superclass : 'Object',
	#instVars : [
		'title',
		'message',
		'type',
		'duration',
		'window',
		'position',
		'font',
		'backgroundColor',
		'textColor',
		'width',
		'height'
	],
	#category : 'SpecComponentsLibrary-AdvancedComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'AdvancedComponents'
}

{ #category : 'accessing' }
NotificationPresenter >> backgroundColor [

	^ backgroundColor
]

{ #category : 'accessing' }
NotificationPresenter >> backgroundColor: anObject [

	backgroundColor := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> computePositionFor: morph in: window [
"Calculates the position (top-left corner) where the notification should appear within the given window.
Supports predefined positions like #topRight, #bottomLeft, #center, etc., with a margin offset."
	| margin container containerBounds x y |
	margin := 3.
	containerBounds := window adapter widget bounds origin.
	container := window adapter widget.

	^ position
		  caseOf: {
				  (#topRight -> [
					   x := container width + containerBounds x - morph width
					        - margin.
					   y := containerBounds y + margin.
					   x @ y ]).

				  (#topLeft -> [
					   x := containerBounds x + margin.
					   y := containerBounds y + margin.
					   x @ y ]).

				  (#bottomLeft -> [
					   x := containerBounds x + margin.
					   y := container height + containerBounds y - morph height
					        - margin.
					   x @ y ]).

				  (#bottomRight -> [
					   x := container width + containerBounds x - morph width
					        - margin.
					   y := container height + containerBounds y - morph height
					        - margin.
					   x @ y ]).

				  (#center -> [
					   x := container width + containerBounds x // 2
					        - (morph width // 2).
					   y := container height + containerBounds y // 2
					        - (morph height // 2).
					   x @ y ]) }
		  otherwise: [ "За замовчуванням — як #topRight"
				  x := container width + containerBounds x - morph width - margin.
				  y := containerBounds y + margin.
				  x @ y ]
]

{ #category : 'accessing' }
NotificationPresenter >> duration [

	^ duration
]

{ #category : 'accessing' }
NotificationPresenter >> duration: anObject [

	duration := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> font [

	^ font
]

{ #category : 'accessing' }
NotificationPresenter >> font: anObject [

	font := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> height [

	^ height
]

{ #category : 'accessing' }
NotificationPresenter >> height: anObject [

	height := anObject
]

{ #category : 'initialization' }
NotificationPresenter >> initialize [
   super initialize.
	title := 'Сповіщення'.
	message := ''.
	type := #info.
	duration := 3.
	position := #bottomRight.
	font := TextStyle defaultFont.
	backgroundColor := Color gray.
	textColor := Color white.
	width := 300.
	height := 80
]

{ #category : 'accessing' }
NotificationPresenter >> message [

	^ message
]

{ #category : 'accessing' }
NotificationPresenter >> message: anObject [

	message := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> position [

	^ position
]

{ #category : 'accessing' }
NotificationPresenter >> position: anObject [

	position := anObject
]

{ #category : 'private' }
NotificationPresenter >> resolveColorFromType [
"Sets the backgroundColor depending on the type.
Supports types: #info, #success, #warning, #error.
Falls back to a neutral gray color if no type matches or no custom color is set."
	type = '#info'
		ifTrue: [ backgroundColor := Color r: 0.40 g: 0.60 b: 0.85 ]
		ifFalse: [
				type = '#success'
					ifTrue: [ backgroundColor := Color r: 0.50 g: 0.75 b: 0.50 ]
					ifFalse: [
							type = '#warning'
								ifTrue: [ backgroundColor := Color r: 0.95 g: 0.75 b: 0.40 ]
								ifFalse: [
										type = '#error'
											ifTrue: [ backgroundColor := Color r: 0.85 g: 0.45 b: 0.45 ]
											ifFalse: [
													backgroundColor ifNil: [
														backgroundColor := Color r: 0.75 g: 0.75 b: 0.75 ] ] ] ] ]
]

{ #category : 'accessing' }
NotificationPresenter >> show [
"Creates a Morph that displays the notification with title and message.
The morph is positioned relative to the window, based on the specified position.
After the specified duration, the morph is automatically removed from the world in a background process."
	| tmp1 tmp2 tmp3 tmp5 tmp6 |
	tmp2 := StringMorph contents: title.
	tmp2
		font: font;
		color: textColor.
	tmp3 := (message isKindOf: Text)
		        ifTrue: [ TextMorph new contents: message ]
		        ifFalse: [ StringMorph contents: message asString ].
	tmp1 := Morph new.
	tmp1
		color: backgroundColor;
		borderWidth: 0;
		cornerStyle: #rounded;
		layoutPolicy: ProportionalLayout new;
		extent: width @ height;
		addMorph: tmp2.
	tmp2 position: 10 @ 5.
	tmp1 addMorph: tmp3.
	tmp3 position: 10 @ 35.
	World addMorph: tmp1.
	tmp6 := self computePositionFor: tmp1 in: window.
	tmp1 position: tmp6.
	tmp5 := Delay forSeconds: duration.
	[
		tmp5 wait.
		tmp1 ifNotNil: [ tmp1 delete ] ] fork
]

{ #category : 'accessing' }
NotificationPresenter >> textColor [

	^ textColor
]

{ #category : 'accessing' }
NotificationPresenter >> textColor: anObject [

	textColor := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> title [

	^ title
]

{ #category : 'accessing' }
NotificationPresenter >> title: anObject [

	title := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> type [

	^ type
]

{ #category : 'accessing' }
NotificationPresenter >> type: anObject [
"Sets the type of the notification and resolves the background color automatically using resolveColorFromType."
	type := anObject.
	self resolveColorFromType
]

{ #category : 'accessing' }
NotificationPresenter >> width [

	^ width
]

{ #category : 'accessing' }
NotificationPresenter >> width: anObject [

	width := anObject
]

{ #category : 'accessing' }
NotificationPresenter >> window: anObject [

	window := anObject
]
