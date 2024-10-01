Class {
	#name : 'RAPath',
	#superclass : 'Object',
	#instVars : [
		'pathConstraints',
		'parent',
		'inputs',
		'exitCondition'
	],
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'copying' }
RAPath >> copyWithNumberOfSegments: anInteger [ 
	
	^ self copy
		pathConstraints: (self pathConstraints first: anInteger);
		yourself
]

{ #category : 'accessing' }
RAPath >> exitCondition [
	^ exitCondition
]

{ #category : 'accessing' }
RAPath >> exitCondition: anError [ 
	
	exitCondition := anError
]

{ #category : 'testing' }
RAPath >> initialize [

	super initialize.
	parent := self.
	inputs := pathConstraints := #().

]

{ #category : 'accessing' }
RAPath >> inputFrame: anObject [

	inputs := anObject
]

{ #category : 'accessing' }
RAPath >> inputs [

	^ inputs
]

{ #category : 'copying' }
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

{ #category : 'testing' }
RAPath >> isEmpty [
	
	^ pathConstraints isEmpty
]

{ #category : 'accessing' }
RAPath >> isFailure [

	^ exitCondition isFailure
]

{ #category : 'negating' }
RAPath >> negateLastSegmentInCommonWith: aParent [ 
	
	| newPathConstraints |
	pathConstraints ifEmpty: [ ^ self ].
	
	newPathConstraints := pathConstraints copy.
	newPathConstraints
		at: pathConstraints size
		put: pathConstraints last negated.
	pathConstraints := newPathConstraints.
]

{ #category : 'searching' }
RAPath >> nextPath [
	
	| copy |
	copy := self copy.
	copy parent: self.
	copy negateLastSegmentInCommonWith: parent.
	^ copy
]

{ #category : 'accessing' }
RAPath >> parent [

	^ parent
]

{ #category : 'accessing' }
RAPath >> parent: aRAPath [

	parent := aRAPath
]

{ #category : 'accessing' }
RAPath >> pathConstraints [
	
	^ pathConstraints
]

{ #category : 'accessing' }
RAPath >> pathConstraints: anObject [

	pathConstraints := anObject
]

{ #category : 'printing' }
RAPath >> printOn: aStream [

	super printOn: aStream.
	aStream nextPut: $(.
	pathConstraints
		do: [ :constraint | aStream print: constraint ]
		separatedBy: [ aStream nextPutAll: ', ' ].
	aStream nextPut: $).
]

{ #category : 'solving' }
RAPath >> solveWithInterpreter: interpreter [

	| solver |
	solver := MzSolver new.
	pathConstraints do: [ :constraint | 
		solver addConstraint: (constraint mzConstraintOnInterpreter: interpreter).
	].

	solver timeout: 2 seconds.
	solver satisfy.

	^ RAConstraintSolution new
		  path: self;
		  solver: solver;
		  yourself
]

{ #category : 'printing' }
RAPath >> toString [
	
	"To improve, this is the first iteration to see easily path patterns"
	^ (pathConstraints collect: [ :constraint | constraint toString ]) joinUsing: '; '
]
