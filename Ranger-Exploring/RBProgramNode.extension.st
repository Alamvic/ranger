Extension { #name : 'RBProgramNode' }

{ #category : '*Ranger-Exploring' }
RBProgramNode >> allSequenceNodes [

	"todo: review me"
	^ self allChildren select: #isSequence
]
