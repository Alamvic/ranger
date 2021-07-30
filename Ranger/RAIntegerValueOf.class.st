Class {
	#name : #RAIntegerValueOf,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #adding }
RAIntegerValueOf >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand |
	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.

	^ (RAObject named: UUID new asString)
		  typeTag: 2;
		  integerValue: leftOperand integerValue;
		  yourself "a native integer"
]

{ #category : #microzinc }
RAIntegerValueOf >> mzConstraintOnInterpreter: interpreter [ 
	
	| leftOperand |
	leftOperand := operands first mzConstraintOnInterpreter: interpreter.

	^ (RAObject named: UUID new asString)
		  typeTag: 2;
		  integerValue: leftOperand integerValue;
		  yourself "a native integer"
]

{ #category : #adding }
RAIntegerValueOf >> prettyIdentifier [

	^ 'integerValueOf'
]
