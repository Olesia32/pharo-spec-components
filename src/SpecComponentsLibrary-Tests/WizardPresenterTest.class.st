Class {
	#name : 'WizardPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'wizard'
	],
	#category : 'SpecComponentsLibrary-Tests',
	#package : 'SpecComponentsLibrary-Tests'
}

{ #category : 'running' }
WizardPresenterTest >> setUp [
	super setUp.
	wizard := WizardPresenter new.
	wizard initializePresenters 
]

{ #category : 'tests' }
WizardPresenterTest >> testGoToNextStep [

	| called step1 step2 |
	called := false.
	step1 := Dictionary newFromPairs: {
			         #title.
			         'First'.
			         #content.
			         (LabelPresenter new text: '1') }.
	step2 := Dictionary newFromPairs: {
			         #title.
			         'Second'.
			         #content.
			         (LabelPresenter new text: '2') }.
	wizard steps: {
			step1.
			step2 }.
	wizard onFinishDo: [ called := true ].
	wizard goToNextStep.
	self assert: (wizard instVarNamed: 'currentStepIndex') equals: 2.
	wizard goToNextStep.
	self assert: called
]

{ #category : 'tests' }
WizardPresenterTest >> testGoToPreviousStep [

	| step1 step2 |
	wizard := WizardPresenter new.
	step1 := Dictionary newFromPairs: {
			         #title.
			         'First'.
			         #content.
			         (LabelPresenter new text: '1') }.
	step2 := Dictionary newFromPairs: {
			         #title.
			         'Second'.
			         #content.
			         (LabelPresenter new text: '2') }.
	wizard steps: {
			step1.
			step2 }.
	wizard goToStep: 2.
	wizard goToPreviousStep.
	self assert: (wizard instVarNamed: 'currentStepIndex') equals: 1
]

{ #category : 'tests' }
WizardPresenterTest >> testGoToStep [

	| step1 step2 |
	step1 := Dictionary newFromPairs: {
			         #title.
			         'First'.
			         #content.
			         (LabelPresenter new text: '1') }.
	step2 := Dictionary newFromPairs: {
			         #title.
			         'Second'.
			         #content.
			         (LabelPresenter new text: '2') }.
	wizard steps: {
			step1.
			step2 }.
	wizard goToStep: 2.
	self assert: (wizard instVarNamed: 'currentStepIndex') equals: 2.
	self
		assert: (wizard instVarNamed: 'contentPresenter') layout text
		equals: '2'
]

{ #category : 'tests' }
WizardPresenterTest >> testOnFinishDo [ 
	| finished |
	finished := false.
	wizard steps: {
		(Dictionary new at: #title put: 'Step 1'; at: #content put: (LabelPresenter new); yourself).
		(Dictionary new at: #title put: 'Step 2'; at: #content put: (LabelPresenter new); yourself)
	}.
	wizard onFinishDo: [ finished := true ].
	wizard goToStep: 2.
	wizard goToNextStep.

	self assert: finished
]

{ #category : 'tests' }
WizardPresenterTest >> testStepCircleRadius [

	| presenter |
	presenter := wizard instVarNamed: 'stepHeaderPresenters'.
	wizard stepCircleRadius: 20.
	self assert: (presenter instVarNamed: 'radius') equals: 20
]

{ #category : 'tests' }
WizardPresenterTest >> testStepPresenterAt [
    |step1 presenter |
    step1 := Dictionary newFromPairs: { #title. 'Intro'. #content. LabelPresenter new text: 'Hello'}.
    wizard steps: { step1 }.
    presenter := wizard stepPresenterAt: 1.
    self assert: presenter text equals: 'Hello'
]

{ #category : 'tests' }
WizardPresenterTest >> testSteps [

	| step1 step2 headerTitles |
	step1 := Dictionary newFromPairs: { #title. 'Step 1'. #content. LabelPresenter new text: 'A'}.
	step2 := Dictionary newFromPairs: { #title. 'Step 2'. #content. LabelPresenter new text: 'B'}.
	wizard steps: {
			step1.
			step2 }.
	headerTitles := wizard instVarNamed: 'stepHeaderPresenters'.
	self assert: (headerTitles instVarNamed: 'stepTitles') asArray equals: #( 'Step 1' 'Step 2' ).
	self assert: (wizard instVarNamed: 'currentStepIndex') equals: 1
]

{ #category : 'tests' }
WizardPresenterTest >> testUpdateButtonStates [ 
	| next back |
	wizard steps: {
		(Dictionary new at: #title put: '1'; at: #content put: LabelPresenter new; yourself).
		(Dictionary new at: #title put: '2'; at: #content put: LabelPresenter new; yourself) }.

	next := wizard nextButton mainPresenter.
	back := wizard backButton mainPresenter.

	wizard goToStep: 1.
	self assert: back isEnabled not.
	self assert: wizard nextButton label equals: 'Вперед'.

	wizard goToStep: 2.
	self assert: back isEnabled.
	self assert: wizard nextButton label equals: 'Завершити'
]

{ #category : 'tests' }
WizardPresenterTest >> testUpdateLayout [ 
	| layoutComponents |
	wizard := WizardPresenter new.
	wizard updateLayout.
	layoutComponents := wizard layout allPresenters.
	self assert: (layoutComponents anySatisfy: [ :c | c = (wizard instVarNamed: 'stepHeaderPresenters') ]).
	self assert: (layoutComponents anySatisfy: [ :c | c = (wizard instVarNamed: 'contentPresenter') ]).
]

{ #category : 'tests' }
WizardPresenterTest >> testUpdateStepHeader [ 
	| stepHeader |
	wizard steps: {
		(Dictionary new at: #title put: 'A'; at: #content put: LabelPresenter new; yourself).
		(Dictionary new at: #title put: 'B'; at: #content put: LabelPresenter new; yourself) }.
	stepHeader := wizard instVarNamed: 'stepHeaderPresenters'.

	wizard goToStep: 2.
	self assert: (stepHeader instVarNamed: 'activeIndex') equals: 2
]

{ #category : 'tests' }
WizardPresenterTest >> testVisibleStepCount [

	wizard visibleStepCount: 4.
	self
		assert:
			((wizard instVarNamed: 'stepHeaderPresenters') instVarNamed:
				 'visibleStepCount')
		equals: 4
]

{ #category : 'tests' }
WizardPresenterTest >> testWhenStepChangedDo [

	| newIndex |
	newIndex := nil.
	wizard steps: {
			(Dictionary new
				 at: #title put: 'Step 1';
				 at: #content put: LabelPresenter new;
				 yourself).
			(Dictionary new
				 at: #title put: 'Step 2';
				 at: #content put: LabelPresenter new;
				 yourself) }.
	wizard whenStepChangedDo: [ :idx | newIndex := idx ].
	wizard goToStep: 2.
	self assert: newIndex equals: 2
]
