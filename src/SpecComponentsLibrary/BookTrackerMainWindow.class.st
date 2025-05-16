Class {
	#name : 'BookTrackerMainWindow',
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
	#category : 'SpecComponentsLibrary-Examples',
	#package : 'SpecComponentsLibrary',
	#tag : 'Examples'
}

{ #category : 'accessing' }
BookTrackerMainWindow >> booksPage [

	^ SpNotebookPage
		  title: 'Мої книги'
		  icon: (self iconNamed: #book)
		  provider: [ self buildBooksPanel ]
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow >> buildBooksPanel [

	| tmp2 tmp3 tmp4 tmp5 tmp7 tmp9 tmp11 |
	table := PaginatedTablePresenter new itemsPerPage: 8.
	table columns: {
			('Назва' -> #title).
			('Автор' -> #author).
			('Жанр' -> #genre).
			('Рік' -> #year).
			('Оцінка' -> #rating) }.
	tmp2 := ButtonPresenter new
		        label: 'Додати';
		        backgroundColor: '#8ca08b';
		        height: 50.
	tmp3 := ButtonPresenter new
		        label: 'Деталі';
		        backgroundColor: '#8ca08b';
		        height: 50.
	tmp4 := ButtonPresenter new
		        label: 'Видалити';
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
	tmp11 := BasePresenter new mainPresenter: (SpPresenter new layout: tmp5; yourself ).
	tmp11 backgroundColor: '#e7ebe7'.
	^ tmp11 yourself
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow >> buildProfilePanel [

	| tmp1 tmp2 tmp4 tmp6 |
	tmp1 := LabelPresenter new text: 'Вітаємо, ' , username.
	tmp1
		fontSize: 14;
		bold;
		color: '#013220'.
	tmp2 := ButtonPresenter new label: 'Вийти з акаунту'.
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
	^ (BasePresenter new mainPresenter: tmp4; backgroundColor: '#e7ebe7'; yourself)
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow >> buildStatsPanel [

	| books count avg first last days favoriteBook monthStats monthNames grid row |
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
	monthNames := #( 'Січень' 'Лютий' 'Березень' 'Квітень' 'Травень'
	                 'Червень' 'Липень' 'Серпень' 'Вересень' 'Жовтень'
	                 'Листопад' 'Грудень' ).

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
				 text: 'Прочитано книг:';
				 bold)
		atPoint: 1 @ row.
	grid add: (LabelPresenter new text: count asString) atPoint: 2 @ row.
	row := row + 1.

	(first notNil and: [ last notNil ]) ifTrue: [
			grid
				add: (LabelPresenter new
						 text: 'Період активності:';
						 bold)
				atPoint: 1 @ row.
			grid
				add: (LabelPresenter new text:
						 first asDate asString , ' – ' , last asDate asString , ' ('
						 , days asString , ' днів)')
				atPoint: 2 @ row.
			row := row + 1 ].

	grid
		add: (LabelPresenter new
				 text: 'Середня оцінка:';
				 bold)
		atPoint: 1 @ row.
	grid add: (LabelPresenter new text: avg asString) atPoint: 2 @ row.
	row := row + 1.

	favoriteBook ifNotNil: [
			grid
				add: (LabelPresenter new
						 text: 'Улюблена книга:';
						 bold)
				atPoint: 1 @ row.
			grid
				add: (LabelPresenter new text:
						 favoriteBook title , ' (' , favoriteBook rating asString , ')')
				atPoint: 2 @ row.
			row := row + 1 ].

	grid
		add: (LabelPresenter new
				 text: 'Динаміка по місяцях:';
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

	^ BasePresenter new mainPresenter: (SpPresenter new
		  layout: grid;
		  yourself); backgroundColor: '#e7ebe7'; yourself 
]

{ #category : 'layout' }
BookTrackerMainWindow >> defaultLayout [

	| tmp2 |
	tmp2 := SpBoxLayout new.
	tmp2 add: notebook.
	^ tmp2 yourself
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow >> deleteBookFrom: aTable [ 
	| selected confirmed book repository |

	selected := aTable selectedItem.
	selected ifNil: [ ^ self ].

	confirmed := UIManager default confirm: 'Видалити книгу "', (selected at: #title), '"?'.	
	confirmed ifFalse: [ ^ self ].

	book := selected at: #model ifAbsent: [ nil ].
	book ifNotNil: [
		repository := owner application repository.
		repository deleteBook: book.
		self reloadBooksInto: aTable
	].

]

{ #category : 'initialization - deprecated' }
BookTrackerMainWindow >> initializePresenter [

	notebook := SpNotebookPresenter new.
	notebook
		addPage: self booksPage;
		addPage: self statsPage;
		addPage: self profilePage
]

{ #category : 'initialization' }
BookTrackerMainWindow >> initializeWindow: arg1 [

	arg1
		title: 'Читацький щоденник';
		initialExtent: 650 @ 400
]

{ #category : 'login' }
BookTrackerMainWindow >> logout [

	| tmp1 tmp3 |
	owner application openLoginWindow.
	tmp3 := tmp1 := self window.
	tmp3 ifNotNil: [ tmp1 delete ]
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow >> openAddBook [

	| wizard steps rules styles repository form1 genreGroup ratingInput reviewInput now book values window |
	repository := owner application repository.
	now := DateAndTime now.
	rules := ValidationRules new addRulePair: ValidationRules nonEmpty.
	styles := FormStyle new inputHeight: 40.
	"=== КРОК 1 ==="
	form1 := DynamicFormBuilder new
		         hideButtons;
		         hideHeader;
		         style: styles;
		         height: 180;
		         textField: #title
		         label: 'Назва'
		         placeholder: ''
		         rules: rules;
		         textField: #author
		         label: 'Автор'
		         placeholder: ''
		         rules: rules;
		         textField: #year
		         label: 'Рік'
		         placeholder: ''
		         rules: (ValidationRules new
				          addRule: [ :txt |
						          [ txt asInteger between: 1000 and: 2025 ]
							          on: Error
							          do: [ false ] ]
				          message: 'Некоректний рік';
				          yourself);
		         yourself.

	"=== КРОК 2 ==="
	genreGroup := RadioGroupPresenter new
		              title: 'Жанр';
		              showFrame: true;
		              items:
			              #( 'Історичний роман' 'Пригодницький роман'
			                 'Психологічний роман' 'Драма' 'Фантастика'
			                 'Сучасна проза' 'Поезія' 'Повість' 'Сатира'
			                 'Фентезі' 'Антиутопія' 'Нонфікшн' );
		              сolumnCount: 3.

	"=== КРОК 3 ==="
	reviewInput := self newText placeholder: 'Ваш відгук'.

	ratingInput := SpSliderPresenter new
		               label: 'Оцінка';
		               min: 1;
		               max: 10.

	"=== СПИСОК КРОКІВ ==="
	steps := {
		         (Dictionary newFrom: {
				          (#title -> 'Крок 1: Основне').
				          (#content -> form1 layout) }).
		         (Dictionary newFrom: {
				          (#title -> 'Крок 2: Жанр').
				          (#content -> genreGroup layout) }).
		         (Dictionary newFrom: {
				          (#title -> 'Крок 3: Враження').
				          (#content -> (SpBoxLayout newVertical
					            spacing: 10;
					            add: reviewInput;
					            add: ratingInput expand: false;
					            yourself)) }) }.



	"=== СТВОРЕННЯ ВІЗАРДА ==="
	wizard := WizardPresenter new.
	wizard steps: steps.
	wizard activeColor: '#8ca08b'.
	wizard stepCircleRadius: 18.
	wizard stepCircleTitleColor: Color black.

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
							message: 'Будь ласка, заповніть усі поля';
							type: '#error';
							position: '#topLeft';
							window: wizard window;
							show ] ].
	window := wizard open.
	window title: 'Додавання книги'.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow >> openBookDetails: aRow [

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
				         text: 'Назва:';
				         bold)
		        atPoint: 1 @ 1;
		        add: (LabelPresenter new text: book title) atPoint: 2 @ 1;
		        add: (LabelPresenter new
				         text: 'Автор:';
				         bold)
		        atPoint: 1 @ 2;
		        add: (LabelPresenter new text: book author) atPoint: 2 @ 2;
		        add: (LabelPresenter new
				         text: 'Жанр:';
				         bold)
		        atPoint: 1 @ 3;
		        add: (LabelPresenter new text: book genre) atPoint: 2 @ 3;
		        add: (LabelPresenter new
				         text: 'Рік:';
				         bold)
		        atPoint: 1 @ 4;
		        add: (LabelPresenter new text: book year asString)
		        atPoint: 2 @ 4;
		        add: (LabelPresenter new
				         text: 'Оцінка:';
				         bold)
		        atPoint: 1 @ 5;
		        add: (LabelPresenter new text: book rating asString)
		        atPoint: 2 @ 5;
		        add: (LabelPresenter new
				         text: 'Дата додавання:';
				         bold)
		        atPoint: 1 @ 6;
		        add:
		        (LabelPresenter new text: book dateAdded asDate asString)
		        atPoint: 2 @ 6;
		        yourself;
		        add: (LabelPresenter new
				         text: 'Враження:';
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

	window title: 'Деталі книги'.
	window window
		removeExpandBox;
		removeCollapseBox;
		removeMenuBox
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow >> openEditBookFrom: arg1 [

	
]

{ #category : 'accessing' }
BookTrackerMainWindow >> profilePage [

	^ SpNotebookPage
		  title: 'Профіль'
		  icon: (self iconNamed: #user)
		  provider: [ self buildProfilePanel ]
]

{ #category : 'as yet unclassified' }
BookTrackerMainWindow >> reloadBooksInto: aTable [ 
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
BookTrackerMainWindow >> statsPage [

	^ SpNotebookPage
		  title: 'Статистика'
		  icon: (self iconNamed: #chart)
		  provider: [ self buildStatsPanel ]
]

{ #category : 'accessing' }
BookTrackerMainWindow >> username: arg1 [

	username := arg1
]
