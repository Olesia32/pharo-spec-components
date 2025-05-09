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
		'visibleStepCount'
	],
	#category : 'SpecComponentsLibrary',
	#package : 'SpecComponentsLibrary'
}

{ #category : 'accessing' }
WizardPresenter >> activeColor: aColor [
  |color|
  color := (Color fromHexString: aColor).
  stepHeaderPresenters activeColor: color.
  nextButton backgroundColor: aColor.
  backButton backgroundColor: aColor.
]

{ #category : 'accessing' }
WizardPresenter >> backButton [ 
^ backButton 
]

{ #category : 'as yet unclassified' }
WizardPresenter >> goToNextStep [ 
    (currentStepIndex = steps size)
        ifTrue: [ onFinished ifNotNil: [ onFinished value ] ]
        ifFalse: [ self goToStep: currentStepIndex + 1 ].
]

{ #category : 'as yet unclassified' }
WizardPresenter >> goToPreviousStep [ 
    self goToStep: currentStepIndex - 1.
]

{ #category : 'as yet unclassified' }
WizardPresenter >> goToStep: aNumber [
   |windowMorph bounds|
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
    steps := OrderedCollection new.
    currentStepIndex := 1.
    onStepExit := nil.
    onFinished := nil.
    stepHeaderPresenters := StepHeaderPresenter new.

    contentPresenter := SpPresenter new.

    nextButton := ButtonPresenter new label: 'Далі'; onClick: [ self goToNextStep ]; height: 40.
    backButton := ButtonPresenter new label: 'Повернутись'; onClick: [ self goToPreviousStep ]; height: 40.

    self updateLayout.
]

{ #category : 'accessing' }
WizardPresenter >> nextButton [
^ nextButton 
]

{ #category : 'enumerating' }
WizardPresenter >> onFinishDo: aBlock [ 
    onFinished := aBlock.
]

{ #category : 'as yet unclassified' }
WizardPresenter >> stepCircleRadius: aNumber [
    stepHeaderPresenters isNil ifTrue: [ ^ self ].
    aNumber isNil ifTrue: [ ^ self ].
    stepHeaderPresenters radius: (aNumber max: 5).
    self updateLayout 
   
]

{ #category : 'as yet unclassified' }
WizardPresenter >> stepCircleTitleColor: aColor [
stepHeaderPresenters titleColor: aColor.
    
]

{ #category : 'accessing' }
WizardPresenter >> stepPresenterAt: index [ 
    ^ (steps at: index ifAbsent: [ nil ]) ifNotNil: [ :step | step at: #content ifAbsent: [ nil ] ]
]

{ #category : 'accessing' }
WizardPresenter >> steps: aCollection [ 
    |stepTitles|
    steps := aCollection asOrderedCollection.
    stepTitles := steps collect: [ :step | step at: #title ].
    stepHeaderPresenters stepTitles: stepTitles .
    self goToStep: 1.
]

{ #category : 'accessing' }
WizardPresenter >> updateButtonStates [ 
    backButton mainPresenter enabled: currentStepIndex > 1.
    (currentStepIndex = steps size) ifTrue: [ nextButton label: 'Завершити' ] ifFalse: [ nextButton label: 'Вперед' ]
]

{ #category : 'private' }
WizardPresenter >> updateLayout [ 
    | buttonBar |
    buttonBar := SpBoxLayout newLeftToRight 
        spacing: 10;
        add: backButton;
        add: nextButton;
        yourself.

    self layout: (SpBoxLayout newTopToBottom
        spacing: 15;
        add: stepHeaderPresenters withConstraints: [:c | c height: stepHeaderPresenters headerHeight ];
        add: contentPresenter;
        add: buttonBar expand: false;
        yourself).

]

{ #category : 'as yet unclassified' }
WizardPresenter >> updateStepHeader [

	stepHeaderPresenters activeIndex: currentStepIndex 
]

{ #category : 'accessing' }
WizardPresenter >> visibleStepCount: aCount [
   stepHeaderPresenters visibleStepCount: aCount 
]

{ #category : 'enumerating' }
WizardPresenter >> whenStepChangedDo: aBlock [ 
    onStepChanged := aBlock.
]

{ #category : 'enumerating' }
WizardPresenter >> whenStepExitDo: aBlock [ 
    onStepExit := aBlock.
]

{ #category : 'accessing' }
WizardPresenter >> width: aNumber [
   width := stepHeaderPresenters width: (aNumber max: 1).
]
