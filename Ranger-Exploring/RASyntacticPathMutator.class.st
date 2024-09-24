Class {
	#name : 'RASyntacticPathMutator',
	#superclass : 'Object',
	#category : 'Ranger-Exploring',
	#package : 'Ranger-Exploring'
}

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> constraintsVariationsFrom: pathConstraints [
	
	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> isMutable: aPath [

	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> mutatePath: path [

	(self isMutable: path) ifFalse: [ ^{} ].
	
	^ self variationsOf: path
]

{ #category : 'as yet unclassified' }
RASyntacticPathMutator >> variationsOf: aPath [ "should return an array of paths"

	^ ( self constraintsVariationsFrom: aPath pathConstraints ) collect: [ :constraints |
		RAPath new pathConstraints: constraints;
			parent: aPath parent;
			inputFrame: aPath input;
			exitCondition: aPath exitCondition;
		yourself
	]
]
