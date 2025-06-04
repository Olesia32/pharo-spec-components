"
I am a multi-step wizard presenter used to guide users through a sequential process.  
Each step presents a custom content view, and users can move forward or backward through the steps.  
I use `WizardStepHeaderPresenter` to render a horizontal progress indicator at the top of the layout.  
This component is especially useful for complex data entry, onboarding, or form flows.  
Each step is defined by a dictionary containing at least a #title and a #content presenter.

### Instance Variables

- _steps_: an `OrderedCollection` — holds dictionaries representing steps (#title, #content)  
- _currentStepIndex_: an `Integer` — 1-based index of the currently active step  
- _stepHeaderPresenters_: a `WizardStepHeaderPresenter` — renders the progress indicator (step titles and active state)  
- _contentPresenter_: a `SpPresenter` — the container where the current step’s content is shown  
- _nextButton_, _backButton_: `ButtonPresenter`s — navigation controls for going forward/backward  
- _onStepChanged_: a `BlockClosure` — optional callback triggered when the step changes  
- _onStepExit_: a `BlockClosure` — optional callback triggered when a step is exited  
- _onFinished_: a `BlockClosure` — optional callback triggered on wizard completion  
- _visibleStepCount_: an `Integer` — optional limit on how many steps are shown in the header
- _nextButtonLabel_: a `String` — custom label text for the Next button (e.g. ""Continue"")  
- _finishLabel_: a `String` — custom label for the final step's button (e.g. ""Finish"")  

### Public API

- `WizardPresenter>>#steps:` — sets the list of steps; each must be a dictionary with `#title` and `#content`
- `WizardPresenter>>#stepPresenterAt:` — returns the presenter of the step at the given index
- `WizardPresenter>>#goToStep:` — moves to a specific step and updates layout and progress
- `WizardPresenter>>#goToNextStep`, `WizardPresenter>>#goToPreviousStep` — navigates between steps
- `WizardPresenter>>#activeColor:`, `WizardPresenter>>#stepCircleTitleColor:` — customize header appearance
- `WizardPresenter>>#stepCircleRadius:` — sets the size of circles in the header
- `WizardPresenter>>#visibleStepCount:` — limits the number of visible steps in the header
- `WizardPresenter>>#nextButton`, `WizardPresenter>>#backButton` — provides access to the navigation buttons for custom configuration or styling  
- `WizardPresenter>>#nextButtonLabel:`, `WizardPresenter>>#finishButtonLabel:` — allows setting custom labels for navigation buttons depending on step context  

### Events

- `WizardPresenter>>#whenStepChangedDo:` — register callbacks for step transitions
- `WizardPresenter>>#onFinishDo:` — sets a callback to be executed when the wizard is completed

### Usage

To use a `WizardPresenter`, define a sequence of steps with titles and custom presenters:

```smalltalk
| wizard |
wizard := WizardPresenter new.
wizard steps: {
  Dictionary newFromPairs: { #title -> 'Step 1'. #content -> (LabelPresenter new text: 'Welcome') }.
  Dictionary newFromPairs: { #title -> 'Step 2'. #content -> (LabelPresenter new text: 'Details') }.
  Dictionary newFromPairs: { #title -> 'Step 3'. #content -> (LabelPresenter new text: 'Confirmation') } }.
wizard onFinishDo: [ UIManager default inform: 'Wizard completed!' ].
wizard open.


"
Class {
	#name : 'WizardPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'steps',
		'currentStepIndex',
		'stepHeaderPresenters',
		'contentPresenter',
		'nextButton',
		'backButton',
		'onStepChanged',
		'onStepExit',
		'onFinished',
		'finishLabel',
		'nextButtonLabel'
	],
	#category : 'SpecComponentsLibrary-AdvancedComponents',
	#package : 'SpecComponentsLibrary',
	#tag : 'AdvancedComponents'
}

{ #category : 'accessing' }
WizardPresenter >> activeColor: aColor [
"Sets the accent color for the step header and navigation buttons."
	| color |
	color := Color fromHexString: aColor.
	stepHeaderPresenters activeColor: color.
	nextButton backgroundColor: aColor.
	backButton backgroundColor: aColor
]

{ #category : 'accessing' }
WizardPresenter >> backButton [
"Returns the ""Back"" button presenter."
	^ backButton
]

{ #category : 'as yet unclassified' }
WizardPresenter >> finishButtonLabel: arg1 [

	finishLabel := arg1
]

{ #category : 'refresh' }
WizardPresenter >> goToNextStep [
"Advances to the next step in the sequence.
If the current step is the last one, triggers the onFinished callback."
	currentStepIndex = steps size
		ifTrue: [ onFinished ifNotNil: [ onFinished value ] ]
		ifFalse: [ self goToStep: currentStepIndex + 1 ]
]

{ #category : 'refresh' }
WizardPresenter >> goToPreviousStep [
"Moves back to the previous step."
	self goToStep: currentStepIndex - 1
]

{ #category : 'refresh' }
WizardPresenter >> goToStep: aNumber [
"Navigates to a specific step by index.
Updates the content view, step header, button states, and triggers onStepExit and onStepChanged callbacks as needed."
	| windowMorph bounds |
	(aNumber between: 1 and: steps size) ifFalse: [ ^ self ].
	onStepExit ifNotNil: [ onStepExit value: currentStepIndex ].
	currentStepIndex := aNumber.
	contentPresenter layout: ((steps at: currentStepIndex) at: #content).
	self updateButtonStates.
	self updateStepHeader.
	onStepChanged ifNotNil: [ onStepChanged value: currentStepIndex ].
	windowMorph := self owner ifNotNil: [ :o | o adapter widget ].
	windowMorph ifNotNil: [
			bounds := windowMorph bounds.
			windowMorph bounds: (bounds insetBy: 1).
			windowMorph bounds: bounds ].
	self owner ifNotNil: [ self owner ]
]

{ #category : 'initialization' }
WizardPresenter >> initializePresenters [

	| tmp2 tmp4 |
	steps := OrderedCollection new.
	currentStepIndex := 1.
	onStepExit := nil.
	onFinished := nil.
	stepHeaderPresenters := WizardStepHeaderPresenter new.
	contentPresenter := SpPresenter new.
	nextButtonLabel := 'Продовжити'.
	finishLabel := 'Завершити'.
	tmp2 := ButtonPresenter new.
	tmp2
		label: 'Вперед';
		onClick: [ self goToNextStep ].
	nextButton := tmp2 height: 40.
	tmp4 := ButtonPresenter new.
	tmp4
		label: 'Повернутись';
		onClick: [ self goToPreviousStep ].
	backButton := tmp4 height: 40.
	self updateLayout
]

{ #category : 'accessing' }
WizardPresenter >> nextButton [
"Returns the ""Next"" button presenter."
	^ nextButton
]

{ #category : 'accessing' }
WizardPresenter >> nextButtonLabel: aLabel [

	nextButtonLabel := aLabel.
	nextButton ifNotNil: [ nextButton label: aLabel ]
]

{ #category : 'events' }
WizardPresenter >> onFinishDo: aBlock [
"Registers a callback block to be executed when the wizard reaches the final step and the user confirms."
	onFinished := aBlock
]

{ #category : 'accessing' }
WizardPresenter >> stepCircleRadius: aNumber [
"Sets the radius of step circles in the header via WizardStepHeaderPresenter.
Triggers layout update."
	stepHeaderPresenters isNil ifTrue: [ ^ self ].
	aNumber isNil ifTrue: [ ^ self ].
	stepHeaderPresenters radius: (aNumber max: 5).
	self updateLayout
]

{ #category : 'accessing' }
WizardPresenter >> stepCircleTitleColor: aColor [
"Sets the text color of step titles in the step header."
	stepHeaderPresenters titleColor: aColor
]

{ #category : 'accessing' }
WizardPresenter >> stepPresenterAt: index [
"Returns the presenter for the step at the given index, or nil if unavailable."
	^ (steps at: index ifAbsent: [ nil ]) ifNotNil: [ :step |
		  step at: #content ifAbsent: [ nil ] ]
]

{ #category : 'api' }
WizardPresenter >> steps: aCollection [
"Sets the ordered collection of steps.
Each step must include a #title and a #content.
Passes the titles to the step header and displays the first step."
	| stepTitles |
	steps := aCollection asOrderedCollection.
	stepTitles := steps collect: [ :step | step at: #title ].
	stepHeaderPresenters stepTitles: stepTitles.
	self goToStep: 1
]

{ #category : 'updating' }
WizardPresenter >> updateButtonStates [

	backButton mainPresenter enabled: currentStepIndex > 1.
	currentStepIndex = steps size
		ifTrue: [ nextButton label: finishLabel ]
		ifFalse: [ nextButton label: nextButtonLabel ]
]

{ #category : 'updating' }
WizardPresenter >> updateLayout [
"Builds the layout with step header at the top, content area in the middle, and navigation buttons at the bottom."
	| buttonBar |
	buttonBar := SpBoxLayout newLeftToRight
		             spacing: 10;
		             add: backButton;
		             add: nextButton;
		             yourself.

	self layout: (SpBoxLayout newTopToBottom
			 spacing: 15;
			 add: stepHeaderPresenters
			 withConstraints: [ :c |
				 c height: stepHeaderPresenters headerHeight ];
			 add: contentPresenter;
			 add: buttonBar expand: false;
			 yourself)
]

{ #category : 'updating' }
WizardPresenter >> updateStepHeader [
"Updates the header to reflect the current active step."
	stepHeaderPresenters activeIndex: currentStepIndex
]

{ #category : 'accessing' }
WizardPresenter >> visibleStepCount: aCount [
"Limits the number of visible steps in the header for compact display."
	stepHeaderPresenters visibleStepCount: aCount
]

{ #category : 'events' }
WizardPresenter >> whenStepChangedDo: aBlock [
"Registers a callback block to be triggered when the step changes."
	onStepChanged := aBlock
]
