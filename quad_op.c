
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
