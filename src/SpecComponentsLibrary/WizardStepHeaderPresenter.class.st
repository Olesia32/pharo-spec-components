"
I am a visual presenter used to render the step headers in a multi-step wizard.  
I show circular indicators with step numbers (or titles), and visually highlight the currently active step.  
I am used by `WizardPresenter` to render the horizontal progress bar above the step content.  
The display is based on Roassal and dynamically adapts to the number of steps and current selection.

### Instance Variables

- _roassalPresenter_: a `Roassal2Presenter` — responsible for visual drawing on the canvas  
- _radius_: an `Integer` — radius of each step circle  
- _stepSpacing_: an `Integer` — horizontal distance between steps  
- _activeIndex_: an `Integer` — the currently selected (highlighted) step  
- _stepTitles_: an `OrderedCollection` — list of step titles to display under the circles  
- _activeColor_: a `Color` — fill color of the active step and progress lines  
- _defaultColor_: a `Color` — fill color of inactive steps  
- _borderColor_: a `Color` — border color of inactive steps  
- _titleFontSize_: an `Integer` — font size of the text below each step  
- _titleColor_: a `Color` — text color of step titles  
- _labelFontSize_: an `Integer` — font size of the number inside the step circle  
- _visibleStepCount_: an `Integer` — maximum number of steps visible at once

### Public API

- `WizardStepHeaderPresenter>>#stepTitles:` — sets the list of step titles  
- `WizardStepHeaderPresenter>>#activeIndex:` — sets the currently selected step and re-renders  
- `WizardStepHeaderPresenter>>#activeColor:` — sets the color for the active step and completed segments  
- `WizardStepHeaderPresenter>>#radius:` — sets the step circle size and recomputes spacing  
- `WizardStepHeaderPresenter>>#visibleStepCount:` — limits the number of steps shown at once  
- `WizardStepHeaderPresenter>>#titleFontSize:`, `>>#titleColor:` — style customization for step labels  
- `WizardStepHeaderPresenter>>#labelFontSize:` — sets the font size for step numbers inside circles 
- `WizardStepHeaderPresenter>>#canvas` — returns the underlying Roassal canvas

### Usage

This presenter is not used on its own. It is integrated automatically by `WizardPresenter`, which sets the step titles and updates the active index:

```smalltalk
wizard := WizardPresenter new.
wizard steps: {
  Dictionary newFromPairs: { #title -> 'Start'. #content -> MyStep1 new }.
  Dictionary newFromPairs: { #title -> 'Details'. #content -> MyStep2 new } }.
wizard stepCircleRadius: 18.
wizard stepCircleTitleColor: Color gray.
wizard open.


"
Class {
	#name : 'WizardStepHeaderPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter',
		'radius',
		'stepSpacing',
		'activeIndex',
		'stepTitles',
		'activeColor',
		'defaultColor',
		'borderColor',
		'titleFontSize',
		'titleColor',
		'labelFontSize',
		'visibleStepCount'
	],
	#category : 'SpecComponentsLibrary-AdvancedComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'AdvancedComponents'
}

{ #category : 'accessing' }
WizardStepHeaderPresenter >> activeColor: aColor [
"Sets the color used for the active step and triggers a re-render."
	activeColor := aColor.
	self render
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> activeIndex: anInteger [
"Updates the currently selected (active) step and refreshes the header display."
	activeIndex := anInteger.
	self render
]

{ #category : 'building' }
WizardStepHeaderPresenter >> buildOuterCircleAt: x y: y color: aColor [
"Creates a slightly larger transparent circle with a colored border to highlight the active step."
	^ RSEllipse new
		  radius: radius + 4;
		  color: Color transparent;
		  borderColor: aColor darker;
		  borderWidth: 2;
		  position: x @ y;
		  yourself
]

{ #category : 'building' }
WizardStepHeaderPresenter >> buildStepCircleAt: x y: y color: fillColor borderColor: strokeColor [
"Creates a circular shape representing a step, filled and bordered with the specified colors."
	^ RSEllipse new
		  radius: radius;
		  color: fillColor;
		  borderColor: strokeColor;
		  borderWidth: 1;
		  position: x @ y;
		  yourself
]

{ #category : 'building' }
WizardStepHeaderPresenter >> buildStepLabelAt: x y: y text: aString fontSize: aSize color: aColor [
"Builds the label to be placed inside a step circle (usually a step number)."
	^ RSLabel new
		  text: aString;
		  fontSize: aSize;
		  color: aColor;
		  position: x @ y;
		  yourself
]

{ #category : 'building' }
WizardStepHeaderPresenter >> buildStepTitleAt: x y: y text: aString [
"Builds the label below the step circle that displays the title of the step."
	^ RSLabel new
		  text: aString;
		  fontSize: titleFontSize;
		  color: titleColor;
		  position: x @ y;
		  yourself
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> canvas [
"Returns the Roassal canvas that this presenter uses for drawing."
	^ roassalPresenter canvas
]

{ #category : 'building' }
WizardStepHeaderPresenter >> centerXOfStep: i plusRadius: aBool [
"Computes the X-coordinate of the center (or edge) of a step based on its index and whether to add radius offset."
	| x |
	x := i * stepSpacing.
	^ aBool
		  ifTrue: [ x + radius ]
		  ifFalse: [ x - radius ]
]

{ #category : 'layout' }
WizardStepHeaderPresenter >> defaultLayout [ 
    ^ SpBoxLayout newTopToBottom
        spacing: 0;
        add: roassalPresenter;
        yourself
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> headerHeight [
"Calculates and returns the total vertical height of the header view including step circles and titles."
	^ radius + 4 * 2 + 20 + titleFontSize
]

{ #category : 'initialization' }
WizardStepHeaderPresenter >> initialize [

	super initialize.
	radius := 20.
	stepSpacing := 120.
	activeIndex := 1.
	activeColor := Color r: 0.95 g: 0.4 b: 0.4.
	defaultColor := Color white.
	borderColor := Color lightGray.
	labelFontSize := 12.
	titleFontSize := 10.
	titleColor := Color black.
	stepTitles := #( 'Step 1' 'Step 2' 'Step 3' ).
	visibleStepCount := 5.
	roassalPresenter := self newRoassal.
	roassalPresenter canvas background: Color transparent .
	self render
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> labelFontSize: aNumber [
"Sets the font size for the step number inside the circle and re-renders the layout."
	labelFontSize := aNumber.
	self render
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> radius: aNumber [
"Sets the radius for step circles, adjusts spacing, centers the view, and re-renders the header."
	| totalWidth stepCount |
	radius := aNumber.
	stepSpacing := radius * 2 + 100.
	stepCount := visibleStepCount min: stepTitles size.
	totalWidth := stepCount - 1 * stepSpacing.
	roassalPresenter canvas camera translateBy:
		(totalWidth / 2 @ (radius - 10)) negated.
	self render
]

{ #category : 'rendering' }
WizardStepHeaderPresenter >> render [
"Removes all existing shapes and redraws the step circles, titles, and connecting lines."
	| view |
	view := roassalPresenter canvas.
	view shapes do: [ :each | view removeShape: each ].

	self renderStepsOn: view.
	self renderStepLinesOn: view
]

{ #category : 'rendering' }
WizardStepHeaderPresenter >> renderStepLinesOn: view [
"Draws lines connecting each pair of steps.
Completed steps are shown with activeColor; others with borderColor."
	| indexes linesCount |
	indexes := self visibleStepIndexes.
	linesCount := indexes size.

	1 to: linesCount - 1 do: [ :i |
			| start end lineColor line globalLeftIndex |
			globalLeftIndex := indexes at: i.

			start := self centerXOfStep: i - 1 plusRadius: true.
			end := self centerXOfStep: i plusRadius: false.

			lineColor := globalLeftIndex < activeIndex
				             ifTrue: [ activeColor ]
				             ifFalse: [ borderColor ].

			line := RSLine newFrom: start @ 0 to: end @ 0.
			line color: lineColor.
			line width: 2.
			view add: line ]
]

{ #category : 'rendering' }
WizardStepHeaderPresenter >> renderStepsOn: view [
"Draws each step in the header: the circle, step number, title, and ellipsis if necessary."
	| startX startY visibleIndexes i xPos stepColor circle label title outerCircle textSize textColor |
	startX := 0.
	startY := 0.
	visibleIndexes := self visibleStepIndexes.

	i := 0.
	visibleIndexes do: [ :idx |
			xPos := startX + (i * stepSpacing).
			i := i + 1.

			idx = #ellipsis
				ifTrue: [
						title := self
							         buildStepTitleAt: xPos
							         y: startY + (radius + 4) + 15
							         text: '…'.
						view add: title ]
				ifFalse: [
						stepColor := idx <= activeIndex
							             ifTrue: [ activeColor ]
							             ifFalse: [ defaultColor ].
						textSize := (radius * 0.6) rounded.
						textColor := stepColor luminance < 0.7
							             ifTrue: [ Color white ]
							             ifFalse: [ Color black ].

						idx = activeIndex ifTrue: [
								outerCircle := self
									               buildOuterCircleAt: xPos
									               y: startY
									               color: activeColor.
								view add: outerCircle ].

						circle := self
							          buildStepCircleAt: xPos
							          y: startY
							          color: stepColor
							          borderColor: (idx = activeIndex
									           ifTrue: [ activeColor darker ]
									           ifFalse: [ borderColor ]).
						label := self
							         buildStepLabelAt: xPos
							         y: startY
							         text: idx asString
							         fontSize: textSize
							         color: textColor.
						title := self
							         buildStepTitleAt: xPos
							         y: startY + (radius + 4) + 15
							         text: (self stepTitleForIndex: idx).

						view addAll: {
								circle.
								label.
								title } ] ]
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> stepTitleForIndex: index [
"Returns the title for the given step index. Returns '…' if the index is the #ellipsis symbol."
	index = #ellipsis ifTrue: [ ^ '…' ].
	^ stepTitles at: index ifAbsent: [ '' ]
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> stepTitles: aCollection [
"Sets the collection of step titles and refreshes the display."
	stepTitles := aCollection.
	self render
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> titleColor: aColor [
"Sets the color of the step titles below the circles and triggers a re-render."
	titleColor := aColor.
	self render
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> titleFontSize: aNumber [
"Sets the font size for the titles under each step and refreshes the layout."
	titleFontSize := aNumber.
	self render
]

{ #category : 'accessing' }
WizardStepHeaderPresenter >> visibleStepCount: aNumber [
"Sets the maximum number of step indicators that will be visible in the header."
	visibleStepCount := aNumber max: 1
]

{ #category : 'private' }
WizardStepHeaderPresenter >> visibleStepIndexes [
"Determines and returns which step indexes should be visible in the header, based on the active step and visible count.
Adds ellipsis where appropriate to collapse hidden steps."
	| totalSteps maxSteps halfWindow startIdx endIdx |
	totalSteps := stepTitles size.
	maxSteps := visibleStepCount.

	totalSteps <= maxSteps ifTrue: [
		^ (1 to: totalSteps) asOrderedCollection ].

	halfWindow := maxSteps // 2.
	startIdx := activeIndex - halfWindow max: 1.
	endIdx := startIdx + maxSteps - 1 min: totalSteps.
	startIdx := endIdx - maxSteps + 1 max: 1.

	^ (startIdx to: endIdx) asOrderedCollection
]
