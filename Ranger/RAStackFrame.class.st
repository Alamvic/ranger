Class {
	#name : #RAStackFrame,
	#superclass : #RAAbstractStackFrame,
	#instVars : [
		'abstractOperandStack',
		'abstractTemporaryFrame'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #accessing }
RAStackFrame >> abstractOperandStack [

	^ abstractOperandStack
]

{ #category : #accessing }
RAStackFrame >> abstractOperandStack: anObject [

	abstractOperandStack := anObject
]

{ #category : #temporaries }
RAStackFrame >> abstractTemporaryAt: aString [ 
	
	^ abstractTemporaryFrame at: aString ifAbsent: [ self temporaryAt: aString ]
]

{ #category : #temporaries }
RAStackFrame >> abstractTemporaryAt: aString put: aValue [

	self haltIf: aValue isConstraint.
	abstractTemporaryFrame at: aString put: aValue
]

{ #category : #initialization }
RAStackFrame >> initialize [

	super initialize.
	abstractOperandStack := Stack new.
	abstractTemporaryFrame := Dictionary new
]

{ #category : #accessing }
RAStackFrame >> popAbstractOperand [

	^ abstractOperandStack pop
]

{ #category : #accessing }
RAStackFrame >> pushAbstractOperand: aValue [

	^ abstractOperandStack push: aValue
]
