"
I am a configuration object that defines visual styling for form components.  
I am used by `DynamicFormBuilder` and related presenters to apply consistent appearance to labels, inputs, headers, and buttons.

By setting properties such as font sizes, colors, borders, and component sizes, you can control the visual layout and theming of a full form declaratively.

### Public API

- `FormStyle>>#fontFamily`, `FormStyle>>#fontFamily:` — sets the global font family for labels and headers  
- `FormStyle>>#labelFontSize`, `FormStyle>>#labelFontSize:` — controls the font size of field labels  
- `FormStyle>>#labelColor`, `FormStyle>>#labelColor:` — sets the text color of labels  
- `FormStyle>>#isLabelBold`, `FormStyle>>#isLabelBold:` — toggles bold style for labels  
- `FormStyle>>#isLabelItalic`, `FormStyle>>#isLabelItalic:` — toggles italic style for labels  
- `FormStyle>>#headerFontSize`, `FormStyle>>#headerFontSize:` — sets the font size of the form’s header  
- `FormStyle>>#headerColor`, `FormStyle>>#headerColor:` — sets the color of the header text  
- `FormStyle>>#isHeaderBold`, `FormStyle>>#isHeaderBold:` — toggles bold style for header  
- `FormStyle>>#isHeaderItalic`, `FormStyle>>#isHeaderItalic:` — toggles italic style for header  
- `FormStyle>>#inputFontSize`, `FormStyle>>#inputFontSize:` — sets the font size for input fields  
- `FormStyle>>#inputBackground`, `FormStyle>>#inputBackground:` — background color for text inputs  
- `FormStyle>>#inputWidth`, `FormStyle>>#inputWidth:` — sets input field width  
- `FormStyle>>#inputHeight`, `FormStyle>>#inputHeight:` — sets input field height  
- `FormStyle>>#inputBorderColor`, `FormStyle>>#inputBorderColor:` — sets input field border color  
- `FormStyle>>#inputBorderWidth`, `FormStyle>>#inputBorderWidth:` — sets border thickness  
- `FormStyle>>#buttonBackground`, `FormStyle>>#buttonBackground:` — sets the color for buttons  
- `FormStyle>>#buttonWidth`, `FormStyle>>#buttonWidth:` — sets the width of buttons  
- `FormStyle>>#buttonHeight`, `FormStyle>>#buttonHeight:` — sets the height of buttons

### Usage

```smalltalk
style := FormStyle new.
style
  labelFontSize: 12;
  inputFontSize: 14;
  headerFontSize: 16;
  inputBackground: Color white;
  buttonBackground: Color green.

form := DynamicFormBuilder new.
form style: style.

"
Class {
	#name : 'FormStyle',
	#superclass : 'Object',
	#instVars : [
		'fontFamily',
		'labelFontSize',
		'labelColor',
		'isLabelBold',
		'isLabelItalic',
		'headerFontSize',
		'headerColor',
		'isHeaderBold',
		'isHeaderItalic',
		'inputFontSize',
		'inputBackground',
		'inputWidth',
		'inputHeight',
		'inputBorderColor',
		'inputBorderWidth',
		'buttonBackground',
		'buttonWidth',
		'buttonHeight'
	],
	#category : 'SpecComponentsLibrary-Style',
	#package : 'SpecComponentsLibrary',
	#tag : 'Style'
}

{ #category : 'accessing' }
FormStyle >> buttonBackground [

	^ buttonBackground
]

{ #category : 'accessing' }
FormStyle >> buttonBackground: anObject [

	buttonBackground := anObject
]

{ #category : 'accessing' }
FormStyle >> buttonHeight [

	^ buttonHeight
]

{ #category : 'accessing' }
FormStyle >> buttonHeight: anObject [

	buttonHeight := anObject
]

{ #category : 'accessing' }
FormStyle >> buttonWidth [

	^ buttonWidth
]

{ #category : 'accessing' }
FormStyle >> buttonWidth: anObject [

	buttonWidth := anObject
]

{ #category : 'accessing' }
FormStyle >> fontFamily [

	^ fontFamily
]

{ #category : 'accessing' }
FormStyle >> fontFamily: anObject [

	fontFamily := anObject
]

{ #category : 'accessing' }
FormStyle >> headerColor [

	^ headerColor
]

{ #category : 'accessing' }
FormStyle >> headerColor: anObject [

	headerColor := anObject
]

{ #category : 'accessing' }
FormStyle >> headerFontSize [

	^ headerFontSize
]

{ #category : 'accessing' }
FormStyle >> headerFontSize: anObject [

	headerFontSize := anObject
]

{ #category : 'accessing' }
FormStyle >> inputBackground [

	^ inputBackground
]

{ #category : 'accessing' }
FormStyle >> inputBackground: anObject [

	inputBackground := anObject
]

{ #category : 'accessing' }
FormStyle >> inputBorderColor [

	^ inputBorderColor
]

{ #category : 'accessing' }
FormStyle >> inputBorderColor: anObject [

	inputBorderColor := anObject
]

{ #category : 'accessing' }
FormStyle >> inputBorderWidth [

	^ inputBorderWidth
]

{ #category : 'accessing' }
FormStyle >> inputBorderWidth: anObject [

	inputBorderWidth := anObject
]

{ #category : 'accessing' }
FormStyle >> inputFontSize [

	^ inputFontSize
]

{ #category : 'accessing' }
FormStyle >> inputFontSize: anObject [

	inputFontSize := anObject
]

{ #category : 'accessing' }
FormStyle >> inputHeight [

	^ inputHeight
]

{ #category : 'accessing' }
FormStyle >> inputHeight: anObject [

	inputHeight := anObject
]

{ #category : 'accessing' }
FormStyle >> inputWidth [

	^ inputWidth
]

{ #category : 'accessing' }
FormStyle >> inputWidth: anObject [

	inputWidth := anObject
]

{ #category : 'accessing' }
FormStyle >> isHeaderBold [

	^ isHeaderBold
]

{ #category : 'accessing' }
FormStyle >> isHeaderBold: anObject [

	isHeaderBold := anObject
]

{ #category : 'accessing' }
FormStyle >> isHeaderItalic [

	^ isHeaderItalic
]

{ #category : 'accessing' }
FormStyle >> isHeaderItalic: anObject [

	isHeaderItalic := anObject
]

{ #category : 'accessing' }
FormStyle >> isLabelBold [

	^ isLabelBold
]

{ #category : 'accessing' }
FormStyle >> isLabelBold: anObject [

	isLabelBold := anObject
]

{ #category : 'accessing' }
FormStyle >> isLabelItalic [

	^ isLabelItalic
]

{ #category : 'accessing' }
FormStyle >> isLabelItalic: anObject [

	isLabelItalic := anObject
]

{ #category : 'accessing' }
FormStyle >> labelColor [

	^ labelColor
]

{ #category : 'accessing' }
FormStyle >> labelColor: anObject [

	labelColor := anObject
]

{ #category : 'accessing' }
FormStyle >> labelFontSize [

	^ labelFontSize
]

{ #category : 'accessing' }
FormStyle >> labelFontSize: anObject [

	labelFontSize := anObject
]
