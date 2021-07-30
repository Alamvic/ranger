Class {
	#name : #RAPath,
	#superclass : #Object,
	#instVars : [
		'pathConstraints',
		'parent',
		'failure'
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
	pathConstraints := #()
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
	
	| newConstraintPath i |
	newConstraintPath := OrderedCollection new.
	i := 1.
	[ pathConstraints size >= i
		and: [ aParent pathConstraints size >= i
			and: [ (pathConstraints at: i) = (aParent pathConstraints at: i) ]]]
				whileTrue: [ 
					newConstraintPath add: (pathConstraints at: i).
					i := i + 1 ].
			
	newConstraintPath ifNotEmpty: [ 
		newConstraintPath := newConstraintPath
			copyReplaceAll: { newConstraintPath last }
			with: { newConstraintPath last negated } ].
	pathConstraints := newConstraintPath.
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

	| constraintVariables solver |
	constraintVariables := pathConstraints
		                       flatCollect: [ :e | e variables ]
		                       as: Set.
	solver := MzSolver new.
	pathConstraints do: [ :e | 
		solver addConstraint: (e mzConstraintOnInterpreter: interpreter). ].

	solver satisfy.

	^ RAConstraintSolution new
		  path: self;
		  solver: solver;
		  variables: constraintVariables;
		  yourself
]
