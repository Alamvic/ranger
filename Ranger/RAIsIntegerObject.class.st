Class {
	#name : #RAIsIntegerObject,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #microzinc }
RAIsIntegerObject >> isInSmallIntegerRangeConstraintFor: aConstraint inInterpreter: anInterpreter [

	^ ((aConstraint mzConstraintOnInterpreter: anInterpreter) 
		   greaterOrEquals: anInterpreter objectMemory minSmallInteger) 
		  and:
			  ((aConstraint mzConstraintOnInterpreter: anInterpreter) 
				   lessOrEquals: anInterpreter objectMemory maxSmallInteger)
]

{ #category : #microzinc }
RAIsIntegerObject >> mzConstraintOnInterpreter: anInterpreter [

	^ (operands first typeTag equals: 1) and: (self
			   isInSmallIntegerRangeConstraintFor: operands first integerValue
			   inInterpreter: anInterpreter)
]

{ #category : #negating }
RAIsIntegerObject >> negated [
	
	^ RAIsNonIntegerObject operands: self operands
]
