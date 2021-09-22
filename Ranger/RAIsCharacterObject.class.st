Class {
	#name : #RAIsCharacterObject,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #negating }
RAIsCharacterObject >> isInCharacterRangeConstraintFor: valueConstraint inInterpreter: anInterpreter [

	"See isInRangeCharacterCode:"
	^ ((valueConstraint mzConstraintOnInterpreter: anInterpreter) 
		   greaterOrEquals: 0) 
		  and:
			  ((valueConstraint mzConstraintOnInterpreter: anInterpreter) 
				   lessOrEquals: (1 << 30) - 1)
]

{ #category : #negating }
RAIsCharacterObject >> mzConstraintOnInterpreter: anInterpreter [

	^ (operands first typeTag equals: 2)
		and: (self
			   isInCharacterRangeConstraintFor: operands first integerValue
			   inInterpreter: anInterpreter)
]

{ #category : #negating }
RAIsCharacterObject >> negated [
	
	^ RAIsNonCharacterObject operands: self operands
]
