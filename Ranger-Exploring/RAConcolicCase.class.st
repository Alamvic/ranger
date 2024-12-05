Class {
	#name : 'RAConcolicCase',
	#superclass : 'Object',
	#instVars : [
		'isa',
		'wordsize',
		'solution',
		'compilationResult',
		'endInstruction',
		'testToExecute'
	],
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

{ #category : 'as yet unclassified' }
RAConcolicCase >> arch [

	^ { isa . wordsize }
]

{ #category : 'running' }
RAConcolicCase >> execute [

	solution exitCondition executeTest: self
]

{ #category : 'testing' }
RAConcolicCase >> isInvalidMemoryAccessInvalid [
	
	^ false
]

{ #category : 'accessing' }
RAConcolicCase >> isa [

	^ isa
]

{ #category : 'accessing' }
RAConcolicCase >> isa: anObject [

	isa := anObject
]

{ #category : 'as yet unclassified' }
RAConcolicCase >> replicate: sol from: runner [

	^ self subclassResponsibility 
]

{ #category : 'accessing' }
RAConcolicCase >> solution [

	^ solution
]

{ #category : 'accessing' }
RAConcolicCase >> solution: anObject [

	solution := anObject
]

{ #category : 'running' }
RAConcolicCase >> tearDown [

	endInstruction := nil
]

{ #category : 'accessing' }
RAConcolicCase >> wordsize [

	^ wordsize
]

{ #category : 'accessing' }
RAConcolicCase >> wordsize: anObject [

	wordsize := anObject
]
