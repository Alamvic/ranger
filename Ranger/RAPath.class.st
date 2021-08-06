Class {
	#name : #RAPath,
	#superclass : #Object,
	#instVars : [
		'pathConstraints',
		'parent',
		'failure',
		'inputs'
	],
	#category : #'Ranger-Exploring'
}

{ #category : #copying }
RAPath >> copyWithNumberOfSegments: anInteger [ 
	
	^ self copy
		pathConstraints: (self pathConstraints first: anInteger);
		yourself
]

{ #category : #accessing }
RAPath >> failure [

	^ failure
]

{ #category : #accessing }
RAPath >> failure: anObject [

	failure := anObject
]

{ #category : #testing }
RAPath >> initialize [

	super initialize.
	parent := self.
	inputs := pathConstraints := #().

]

{ #category : #accessing }
RAPath >> inputs [

	^ inputs
]

{ #category : #accessing }
RAPath >> inputs: anObject [

	inputs := anObject
]

{ #category : #copying }
RAPath >> inspectionItems: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Constraints'> 
	
	^ aBuilder newTable		
		addColumn: (SpStringTableColumn new  
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each prettyString ];
			sortFunction: #printString ascending;
			yourself);
		items: self pathConstraints;
		yourself
]

{ #category : #testing }
RAPath >> isEmpty [
	
	^ pathConstraints isEmpty
]

{ #category : #negating }
RAPath >> negateLastSegmentInCommonWith: aParent [ 
	
	| newPathConstraints |
	pathConstraints ifEmpty: [ ^ self ].
	
	newPathConstraints := pathConstraints copy.
	newPathConstraints
		at: pathConstraints size
		put: pathConstraints last negated.
	pathConstraints := newPathConstraints.
]

{ #category : #searching }
RAPath >> nextPath [
	
	| copy |
	copy := self copy.
	copy parent: self.
	copy negateLastSegmentInCommonWith: parent.
	^ copy
]

{ #category : #accessing }
RAPath >> parent [

	^ parent
]

{ #category : #accessing }
RAPath >> parent: aRAPath [ 
	parent := aRAPath
]

{ #category : #accessing }
RAPath >> pathConstraints [
	
	^ pathConstraints
]

{ #category : #accessing }
RAPath >> pathConstraints: anObject [

	pathConstraints := anObject
]

{ #category : #printing }
RAPath >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	pathConstraints
		do: [ :e | aStream print: e ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $).
]

{ #category : #solving }
RAPath >> solveWithInterpreter: interpreter [

	| solver |
	solver := MzSolver new.
	pathConstraints do: [ :e | 
		solver addConstraint: (e mzConstraintOnInterpreter: interpreter). ].

	solver timeout: 2 seconds.
	solver satisfy.

	^ RAConstraintSolution new
		  path: self;
		  solver: solver;
		  yourself
]
