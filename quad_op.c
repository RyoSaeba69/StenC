
#include "quad_op.h"

char* quad_op_to_str(enum quad_op op){
	switch(op){
		case ASSIGNMENT:
			return "ASSIGNMENT";
		break;
		default:
			return "UKNOWN";
		break;
	}
}
