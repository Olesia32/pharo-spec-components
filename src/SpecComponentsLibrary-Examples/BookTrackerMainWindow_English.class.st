"
I am the main window of the BookTracker application.

I organize the primary user interface into notebook pages for book management, user statistics, and profile settings. I allow users to add, view, and delete books, and visualize personal reading statistics. My structure is based on `SpNotebookPresenter`, and I use various presenters from the `SpecComponentsLibrary`.

### Instance Variables
- _username_ — the currently logged-in user.
- _notebook_ — the main notebook UI container.
- _booksPage_, _statsPage_, _profilePage_ — individual tabs in the notebook.
- _logoutButton_ — a button to exit the account.
- _table_ — a paginated table displaying the user’s books.

### Responsibilities

- Display notebook with pages for books, statistics, and profile.
- Allow adding new books through a multi-step wizard.
- Show book details and delete selected entries.
- Calculate and display reading statistics over time.
- Support logout and user-switching.
"
Class {
	#name : 'BookTrackerMainWindow_English',
	#superclass : 'SpPresenter',
	#instVars : [
		'username',
		'notebook',
		'booksPage',
		'statsPage',
		'profilePage',
		'logoutButton',
		'table'
	],
	#category : 'SpecComponentsLibrary-Examples-BookTracker',
	#package : 'SpecComponentsLibrary-Examples',
	#tag : 'BookTracker'
}

{ #category : 'accessing' }
BookTrackerMainWindow_English >> booksPage [

	^ SpNotebookPage
		  title: 'My books'
		  icon: (self iconNamed: #book)
		  provider: [ self buildBooksPanel ]
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow_English >> buildBooksPanel [

	| tmp2 tmp3 tmp4 tmp5 tmp7 tmp9 tmp11 |
	table := PaginatedTablePresenter new itemsPerPage: 8.
	table columns: {
		('Title' -> #title).
		('Author' -> #author).
		('Genre' -> #genre).
		('Year' -> #year).
		('Rating' -> #rating) }.
	tmp2 := ButtonPresenter new
		        label: 'Add';
		        backgroundColor: '#8ca08b';
		        height: 50.
	tmp3 := ButtonPresenter new
		        label: 'Details';
		        backgroundColor: '#8ca08b';
		        height: 50.
	tmp4 := ButtonPresenter new
		        label: 'Delete';
		        backgroundColor: '#8ca08b';
		        height: 50.
	tmp2 onClick: [ self openAddBook ].
	tmp3 onClick: [ self openBookDetails: table table selectedItem ].
	tmp4 onClick: [ self deleteBookFrom: table ].
	tmp7 := SpBoxLayout newVertical.
	tmp7
		spacing: 10;
		add: table.
	tmp9 := SpBoxLayout newHorizontal.
	tmp9
		spacing: 10;
		add: tmp2;
		add: tmp3.
	tmp7 add: (tmp9 add: tmp4) expand: false.
	tmp5 := tmp7 yourself.
	self reloadBooksInto: table.
	tmp11 := PresenterDecorator wrap: (SpPresenter new
			          layout: tmp5;
			          yourself).
	tmp11 backgroundColor: '#e7ebe7'.
	^ tmp11 yourself
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow_English >> buildProfilePanel [

	| tmp1 tmp2 tmp4 tmp6 |
	tmp1 := LabelPresenter new text: 'Welcome, ' , username.
	tmp1
		fontSize: 14;
		bold;
		color: '#013220'.
	tmp2 := ButtonPresenter new label: 'Log out'.
	tmp2
		backgroundColor: '#8ca08b';
		bold;
		width: 200;
		height: 50;
		onClick: [ self logout ].
	tmp4 := SpPresenter new.
	tmp6 := SpBoxLayout newVertical.
	tmp6
		spacing: 20;
		hAlignCenter;
		vAlignCenter;
		add: tmp1 expand: false;
		add: tmp2 expand: false.
	tmp4 layout: tmp6 yourself.
	tmp4 := PresenterDecorator wrap: tmp4.
	^ tmp4
		backgroundColor: '#e7ebe7';
		yourself

]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow_English >> buildStatsPanel [

	| books count avg first last days favoriteBook monthStats monthNames grid row panel |
	books := owner application repository getBooksForUser: username.
	count := books size.
	avg := count = 0
		ifTrue: [ 0 ]
		ifFalse: [
			(books collect: #rating) average asFloat roundTo: 0.1 ].
	first := books
		ifEmpty: [ nil ]
		ifNotEmpty: [ (books collect: #dateAdded) min ].
	last := books
		ifEmpty: [ nil ]
		ifNotEmpty: [ (books collect: #dateAdded) max ].
	days := (first notNil and: [ last notNil ])
		ifTrue: [ (last - first) days ]
		ifFalse: [ 0 ].
	favoriteBook := books
		ifEmpty: [ nil ]
		ifNotEmpty: [ books detectMax: #rating ].

	monthStats := Dictionary new.
	monthNames := #( 'January' 'February' 'March' 'April' 'May'
	                 'June' 'July' 'August' 'September' 'October'
	                 'November' 'December' ).

	books do: [ :book |
		| monthName |
		monthName := monthNames at: book dateAdded monthIndex.
		monthStats at: monthName ifAbsentPut: [ 0 ].
		monthStats at: monthName put: (monthStats at: monthName) + 1 ].

	grid := SpGridLayout new
		columnSpacing: 20;
		beColumnNotHomogeneous;
		rowSpacing: 6.

	row := 1.
	grid
		add: (LabelPresenter new
				 text: 'Books read:';
				 bold)
		atPoint: 1 @ row.
	grid add: (LabelPresenter new text: count asString) atPoint: 2 @ row.
	row := row + 1.

	(first notNil and: [ last notNil ]) ifTrue: [
		grid
			add: (LabelPresenter new
					 text: 'Activity period:';
					 bold)
			atPoint: 1 @ row.
		grid
			add: (LabelPresenter new text:
					 first asDate asString , ' – ' , last asDate asString , ' (' ,
					 days asString , ' days)')
			atPoint: 2 @ row.
		row := row + 1 ].

	grid
		add: (LabelPresenter new
				 text: 'Average rating:';
				 bold)
		atPoint: 1 @ row.
	grid add: (LabelPresenter new text: avg asString) atPoint: 2 @ row.
	row := row + 1.

	favoriteBook ifNotNil: [
		grid
			add: (LabelPresenter new
					 text: 'Favorite book:';
					 bold)
			atPoint: 1 @ row.
		grid
			add: (LabelPresenter new text:
					 favoriteBook title , ' (' , favoriteBook rating asString , ')')
			atPoint: 2 @ row.
		row := row + 1 ].

	grid
		add: (LabelPresenter new
				 text: 'Monthly stats:';
				 bold)
		atPoint: 1 @ row.
	row := row + 1.

	monthNames do: [ :month |
		(monthStats includesKey: month) ifTrue: [
			grid add: (LabelPresenter new text: month) atPoint: 1 @ row.
			grid
				add: (LabelPresenter new text: (monthStats at: month) asString)
				atPoint: 2 @ row.
			row := row + 1 ] ].

	panel := PresenterDecorator wrap: (SpPresenter new
		layout: grid;
		yourself).
	^ panel
		backgroundColor: '#e7ebe7';
		yourself

]

{ #category : 'layout' }
BookTrackerMainWindow_English >> defaultLayout [

	| tmp2 |
	tmp2 := SpBoxLayout new.
	tmp2 add: notebook.
	^ tmp2 yourself
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow_English >> deleteBookFrom: aTable [

	| selected confirmed book repository |
	selected := aTable selectedItem.
	selected ifNil: [ ^ self ].

	confirmed := UIManager default confirm:
             'Delete the book "' , (selected at: #title) , '"?'. 

	confirmed ifFalse: [ ^ self ].

	book := selected at: #model ifAbsent: [ nil ].
	book ifNotNil: [
			repository := owner application repository.
			repository deleteBook: book.
			self reloadBooksInto: aTable ]
]

{ #category : 'initialization - deprecated' }
BookTrackerMainWindow_English >> initializePresenter [

	notebook := SpNotebookPresenter new.
	notebook
		addPage: self booksPage;
		addPage: self statsPage;
		addPage: self profilePage
]

{ #category : 'initialization' }
BookTrackerMainWindow_English >> initializeWindow: arg1 [

	arg1
		title: 'Reading Journal';
		initialExtent: 650 @ 400

]

{ #category : 'login' }
BookTrackerMainWindow_English >> logout [

	| tmp1 tmp3 |
	owner application openLoginWindow.
	tmp3 := tmp1 := self window.
	tmp3 ifNotNil: [ tmp1 delete ]
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow_English >> openAddBook [

	| wizard steps rules styles repository form1 genreGroup ratingInput reviewInput now book values window |
	repository := owner application repository.
	now := DateAndTime now.
	rules := ValidationRules new addRulePair: ValidationRules nonEmpty.
	styles := FormStyle new inputHeight: 40.

	"=== STEP 1 ==="
	form1 := DynamicFormBuilder new
		         hideButtons;
		         hideHeader;
		         style: styles;
		         height: 180;
		         textField: #title
		         label: 'Title'
		         placeholder: ''
		         rules: rules;
		         textField: #author
		         label: 'Author'
		         placeholder: ''
		         rules: rules;
		         textField: #year
		         label: 'Year'
		         placeholder: ''
		         rules: (ValidationRules new
				          addRule: [ :txt |
						          [ txt asInteger between: 1000 and: 2025 ]
							          on: Error
							          do: [ false ] ]
				          message: 'Invalid year';
				          yourself);
		         yourself.

	"=== STEP 2 ==="
	genreGroup := RadioGroupPresenter new
		              title: 'Genre';
		              showFrame: true;
		              items:
			              #( 'Historical Novel' 'Adventure Novel'
			                 'Psychological Novel' 'Drama' 'Science Fiction'
			                 'Contemporary Prose' 'Poetry' 'Novella' 'Satire'
			                 'Fantasy' 'Dystopia' 'Nonfiction' );
		              сolumnCount: 3.

	"=== STEP 3 ==="
	reviewInput := self newText placeholder: 'Your review'.

	ratingInput := SpSliderPresenter new
		               label: 'Rating';
		               min: 1;
		               max: 10.

	"=== STEP LIST ==="
	steps := {
		         (Dictionary newFrom: {
				          (#title -> 'Step 1: Basic Info').
				          (#content -> form1 layout) }).
		         (Dictionary newFrom: {
				          (#title -> 'Step 2: Genre').
				          (#content -> genreGroup layout) }).
		         (Dictionary newFrom: {
				          (#title -> 'Step 3: Impressions').
				          (#content -> (SpBoxLayout newVertical
					            spacing: 10;
					            add: reviewInput;
					            add: ratingInput expand: false;
					            yourself)) }) }.

	"=== CREATE WIZARD ==="
	wizard := WizardPresenter new.
	wizard steps: steps.
	wizard activeColor: '#8ca08b'.
	wizard stepCircleRadius: 18.
	wizard stepCircleTitleColor: Color black.
	wizard nextButtonLabel: 'Next'.
	wizard finishButtonLabel: 'Finish'.
	wizard backButton label: 'Back'.

	wizard onFinishDo: [
			form1 validateFields
				ifTrue: [
						values := form1 collectValues.
						book := UserBook new.
						book username: username.
						book title: (values at: #title).
						book author: (values at: #author).
						book year: (values at: #year) asInteger.
						book genre: genreGroup itemSelected.
						book impression: reviewInput text.
						book rating: ratingInput value asInteger.
						book dateAdded: now.

						repository addBook: book.
						self reloadBooksInto: table.
						self defaultLayout.
						wizard window ifNotNil: [ :w | w delete ] ]
				ifFalse: [
						NotificationPresenter new
							message: 'Please fill in all fields';
							type: '#error';
							position: '#topLeft';
							window: wizard window;
							show ] ].
	window := wizard open.
	window title: 'Add a Book'.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow_English >> openBookDetails: aRow [

	| book layout textPresenter grid window |
	aRow ifNil: [ ^ self ].
	book := aRow at: #model ifAbsent: [ ^ self ].

	textPresenter := SpTextPresenter new.
	textPresenter
		beNotEditable;
		text: book impression.

	grid := SpGridLayout new
		columnSpacing: 15;
		rowSpacing: 6;
		add: (LabelPresenter new
		         text: 'Title:';
		         bold)
		atPoint: 1 @ 1;
		add: (LabelPresenter new text: book title) atPoint: 2 @ 1;
		add: (LabelPresenter new
		         text: 'Author:';
		         bold)
		atPoint: 1 @ 2;
		add: (LabelPresenter new text: book author) atPoint: 2 @ 2;
		add: (LabelPresenter new
		         text: 'Genre:';
		         bold)
		atPoint: 1 @ 3;
		add: (LabelPresenter new text: book genre) atPoint: 2 @ 3;
		add: (LabelPresenter new
		         text: 'Year:';
		         bold)
		atPoint: 1 @ 4;
		add: (LabelPresenter new text: book year asString)
		atPoint: 2 @ 4;
		add: (LabelPresenter new
		         text: 'Rating:';
		         bold)
		atPoint: 1 @ 5;
		add: (LabelPresenter new text: book rating asString)
		atPoint: 2 @ 5;
		add: (LabelPresenter new
		         text: 'Date added:';
		         bold)
		atPoint: 1 @ 6;
		add: (LabelPresenter new text: book dateAdded asDate asString)
		atPoint: 2 @ 6;
		yourself;
		add: (LabelPresenter new
		         text: 'Impression:';
		         bold)
		atPoint: 1 @ 7.

	layout := SpBoxLayout newVertical
		spacing: 5;
		add: grid;
		add: textPresenter;
		yourself.

	window := (BasePresenter new
		mainPresenter: (SpPresenter new
			layout: layout;
			yourself);
		backgroundColor: '#e7ebe7') open.

	window title: 'Book Details'.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox.

]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow_English >> openEditBookFrom: arg1 [

	
]

{ #category : 'accessing' }
BookTrackerMainWindow_English >> profilePage [

	^ SpNotebookPage
		  title: 'Profile'
		  icon: (self iconNamed: #user)
		  provider: [ self buildProfilePanel ]
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow_English >> reloadBooksInto: aTable [ 
	| books tableItems |
	books := owner application repository getBooksForUser: username.

	tableItems := books collect: [ :book |
		Dictionary newFrom: {
			#title -> book title.
			#author -> book author.
			#genre -> book genre.
			#year -> book year.
			#rating -> book rating.
			#model -> book  
		}
	].

	aTable items: tableItems

]

{ #category : 'accessing' }
BookTrackerMainWindow_English >> statsPage [

	^ SpNotebookPage
		title: 'Statistics'
		icon: (self iconNamed: #chart)
		provider: [ self buildStatsPanel ]

]

{ #category : 'accessing' }
BookTrackerMainWindow_English >> username: arg1 [

	username := arg1
]
