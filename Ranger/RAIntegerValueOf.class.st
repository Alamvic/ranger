Class {
	#name : #RAIntegerValueOf,
	#superclass : #RAValueConstraint,
	#category : #Ranger
}

{ #category : #adding }
RAIntegerValueOf >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand |
	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.

	^ (RAObject named: UUID new asString)
		  typeTag: 17;
		  integerValue: leftOperand integerValue;
		  yourself "a native integer"
]

{ #category : #adding }
RAIntegerValueOf >> prettyIdentifier [

	^ 'integerValueOf'
]
