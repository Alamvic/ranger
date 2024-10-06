Class {
	#name : 'RASyntacticPathMutator',
	#superclass : 'Object',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'testing' }
RASyntacticPathMutator >> isGreaterThan: aConstraint [
	
	^ aConstraint class = RAGreaterConstraint
]

{ #category : 'testing' }
RASyntacticPathMutator >> isInt: aConstraint [

	^ (aConstraint class = RAConstant) and: aConstraint value class = SmallInteger 
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> isMutable: aRAPath [

	self subclassResponsibility 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isVar: aConstraint [

	^ aConstraint class = MzVariable 
]

{ #category : 'testing' }
RASyntacticPathMutator >> isVarOpInt: aConstraint [

	| x1 x2 |
	x1 := aConstraint operands first.
	x2 := aConstraint operands second.
	
	^ ((self isVar: x1 ) and: (self isInt: x2) ) or: ((self isVar: x2 ) and: (self isInt: x1))
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> mutatePath: path [

	^ (self isMutable: path) ifTrue: [ self mutationsFrom: path ] ifFalse: [ {} ].
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> mutations: constraints [
	
	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> mutationsFrom: aRAPath [ "return an array of paths"

	^ ( self mutations: aRAPath pathConstraints ) collect: [ :constraints |
		RAPath new pathConstraints: constraints;
			parent: aRAPath parent;
			inputFrame: aRAPath input;
			exitCondition: aRAPath exitCondition;
		yourself
	]
]

{ #category : 'testing' }
RASyntacticPathMutator >> varIsGreaterThan: aConstraint [
	(self isGreaterThan: aConstraint) ifFalse: [ ^ false ].
	
	^ self isVarOpInt: aConstraint
]
