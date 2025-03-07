Extension { #name : 'RBProgramNode' }

{ #category : '*Ranger-Exploring' }
RBProgramNode >> allSequenceNodes [

	"todo: review me"
	^ self allChildren select: #isSequence
]

{ #category : '*Ranger-Exploring' }
RBProgramNode >> childAtPath: path [

	path ifEmpty: [  ^ self ].
	
	^ (self children at: path first) childAtPath: path allButFirst
]

{ #category : '*Ranger-Exploring' }
RBProgramNode >> indexInParent [

	^ self parent children indexOf: self
]

{ #category : '*Ranger-Exploring' }
RBProgramNode >> isRoot [

	^ parent isNil
]

{ #category : '*Ranger-Exploring' }
RBProgramNode >> path [

	self isRoot ifTrue: [ ^ #(  ) ].

	^ self parent path , { self indexInParent }
]

{ #category : '*Ranger-Exploring' }
RBProgramNode >> superParent [
	
	parent ifNil: [ ^self ].
	
	^ self parent superParent
]
