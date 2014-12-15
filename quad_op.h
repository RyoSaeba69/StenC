#ifndef QUAD_OP_H
#define QUAD_OP_H

// Enum representing all quad operation

enum quad_op{
	Q_ASSIGNMENT,
	Q_PLUS,
	Q_MINUS,
	Q_DIVIDE,
	Q_MULTIPLY,
	Q_GOTO,
	Q_NOOP
};

char* quad_op_to_str(enum quad_op);

int make_operation(enum quad_op, int arg1, int arg2);



#endif
