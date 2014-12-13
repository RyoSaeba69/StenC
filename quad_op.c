
#include "quad_op.h"

char* quad_op_to_str(enum quad_op op){
	switch(op){
		case Q_ASSIGNMENT:
			return "Q_ASSIGNMENT";
			break;
		case Q_PLUS:
			return "Q_PLUS";
			break;
		case Q_MINUS:
			return "Q_MINUS";
			break;
		case Q_DIVIDE:
			return "Q_DIVIDE";
			break;
		case Q_MULTIPLY:
			return "Q_MULTIPLY";
			break;
		default:
			return "UKNOWN";
			break;
	}
}

int make_operation(enum quad_op op, int arg1, int arg2){
	switch(op){
		case Q_PLUS:
			return arg1 + arg2;
			break;
		case Q_MINUS:
			return arg1 - arg2;
			break;
		case Q_DIVIDE:
			return arg1 / arg2;
			break;
		case Q_MULTIPLY:
			return arg1 * arg2;
			break;
		default:
			return 0;
			break;
	}
}
