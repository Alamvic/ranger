Class {
	#name : 'TestClassToCover',
	#superclass : 'Object',
	#category : 'Ranger-Exploring-Collector',
	#package : 'Ranger-Exploring',
	#tag : 'Collector'
}

{ #category : 'as yet unclassified' }
TestClassToCover >> aMethodWithTwoReturnBlocks: returnWithFirstStatement returnWithIter: iteration [

	returnWithFirstStatement ifTrue: [ ^true ].
	
	1 to: iteration + 1
		do: [ :i |
			i = iteration ifTrue: [ ^true ]
		].
	
	^false


]
