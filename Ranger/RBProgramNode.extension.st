Extension { #name : 'RBProgramNode' }

{ #category : '*Ranger' }
RBProgramNode >> childAtPath: path [

	path ifEmpty: [  ^ self ].
	
	^ (self children at: path first) childAtPath: path allButFirst
]

{ #category : '*Ranger' }
RBProgramNode >> indexInParent [

	^ self parent children indexOf: self
]

{ #category : '*Ranger' }
RBProgramNode >> isRoot [

	^ parent isNil
]

{ #category : '*Ranger' }
RBProgramNode >> path [

	self isRoot ifTrue: [ ^ #(  ) ].

	^ self parent path , { self indexInParent }
]
