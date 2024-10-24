Class {
	#name : 'RAConcolicCase',
	#superclass : 'Object',
	#instVars : [
		'isa',
		'wordsize',
		'solution',
		'compilationResult',
		'endInstruction',
		'aTest'
	],
	#category : 'Ranger-Exploring-Runner',
	#package : 'Ranger-Exploring',
	#tag : 'Runner'
}

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

{ #category : 'accessing' }
RAConcolicCase >> solution [

	^ solution
]

{ #category : 'accessing' }
RAConcolicCase >> solution: anObject [

	solution := anObject
]

{ #category : 'accessing' }
RAConcolicCase >> wordsize [

	^ wordsize
]

{ #category : 'accessing' }
RAConcolicCase >> wordsize: anObject [

	wordsize := anObject
]
