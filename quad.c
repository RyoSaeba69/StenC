#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "quad.h"
#include "quad_op.h"

quad* quad_gen(int* label, enum quad_op op, symbol* arg1, symbol* arg2, symbol* res){

	//static int next_label = 0;

	quad* new_quad = malloc(sizeof(quad));

	if(label != NULL){
		new_quad->label = *label;
		(*label)++;	
	} else {
		new_quad->label = -1;
	}

	new_quad->op = op;
	new_quad->arg1 = arg1;
	new_quad->arg2 = arg2;
	new_quad->res = res;
	new_quad->next = NULL;
	
	return new_quad;
}

void quad_free(quad* q){

	quad* next_quad = q->next;

	while(next_quad != NULL){

		next_quad = q->next;
		free(q);
		q = next_quad;
	}
}

void quad_print(quad* q){

printf("=== Display Quad ====\n");
	while(q != NULL){
		printf("Quad: label : %d || op : %s ", q->label, quad_op_to_str(q->op));

		if(q->arg1 != NULL){
			printf("|| arg1: %d :: id : %s", q->arg1->value, q->arg1->identifier);
		}

		if(q->arg2 != NULL){
			printf("|| arg2 : %d :: id : %s", q->arg2->value, q->arg2->identifier);
		}

		if(q->res != NULL){
			printf(" || res : %s :: value : %d", q->res->identifier, q->res->value);
		}

		printf("\n");

		q = q->next;
	}
	printf("=== End Quad \n");
}


void quad_add(quad** current_quad, quad* new_quad){
	if(new_quad != NULL){
		if(*current_quad == NULL){
			*current_quad = new_quad;
		} else {
			quad* last_quad = *current_quad;
			while(last_quad->next != NULL){
				last_quad = last_quad->next;
			}
			last_quad->next = new_quad;
		}
	}
}


// QUAD LIST

quad_list* quad_list_new(quad* q){

	quad_list* list = malloc(sizeof(quad_list));

	list->node = q;
	list->next = NULL;

	return list;
}


void quad_list_add(struct quad_list** orig_quad_list, struct quad_list* new_quad_list){
	if(orig_quad_list == NULL || *orig_quad_list == NULL){
		*orig_quad_list = new_quad_list;
	} else {
		quad_list* last_quad_list = *orig_quad_list;
		while(last_quad_list->next != NULL){
			last_quad_list = last_quad_list->next;
		}

		last_quad_list->next = new_quad_list;
	}
}

void quad_list_complete(struct quad_list* list, struct symbol* label){
  while(list != NULL){
    list->node->res = label;
    list = list->next;
  }
}

void quad_list_complete_label(struct quad_list* list, int label){
	quad_list* q_list = list;

	while(q_list != NULL){
		q_list->node->res->value = label;
		q_list = q_list->next;
	}
}

void quad_list_print(quad_list* list){

	printf("=== Quad list ==== \n");
	while(list != NULL){
		printf("Quad list : Current node label : %d || OP: %c \n", list->node->label, list->node->op);
		list = list->next;
	}
	printf("=== End Quad list ===\n");

}


void gen_mips(quad* quads_list){
	printf("=======MIPS CODE========\n");

    printf("\t.text\n");	
	struct quad* current_quad = quads_list;

	while(current_quad != NULL){
		switch(current_quad->op){
			case Q_ASSIGNMENT:
				printf("\tla $a0,%s\n", current_quad->res->identifier);
			    printf("\tli $v0 %s\n", current_quad->arg1->identifier);
			    printf("\tsw $t0 $a0 \n");
				break;

			case Q_PLUS:
				printf("\tlw $t1,%s \n",current_quad->arg1->identifier); 
				printf("\tlw $t2,%s \n",current_quad->arg2->identifier); 
				printf("\tadd $t0,$t1,$t2\n");
				printf("\tsw $t0, %s \n",current_quad->res->identifier);
				break;

			case Q_MINUS:
				printf("\tlw $t1,%s\n", current_quad->arg1->identifier);
				printf("\tlw $t2,%s\n",current_quad->arg2->identifier);
				printf("\tsub $t0,$t1,$t2\n");
				printf("\tsw $t0 ,%s \n",current_quad->res->identifier);
				break;

			case Q_DIVIDE:
				 printf("\tlw $t1,%s\n",current_quad->arg1->identifier);
				printf("\tlw $t2,%s\n",current_quad->arg2->identifier);
				printf("\tdiv $t0,$t1,$t2\n");
				printf("\tsw $t0 ,%s \n",current_quad->res->identifier);
				break;

			case Q_MULTIPLY:
				printf("\tlw $t1,%s\n",current_quad->arg1->identifier);
				printf("\tlw $t2,%s\n",current_quad->arg2->identifier);
				printf("\tmul $t0,$t1,$t2\n");
				printf("\tsw $t0, %s \n",current_quad->res->identifier);
				break;

			case Q_GOTO:
		        printf("\tj_%d \n", current_quad->res->value);
				break;

			case Q_NOOP:
				printf("\tnoop \n");
			default:
				//printf("[MIPS] UNKNOWN OP");
				break;
		}
		current_quad = current_quad->next;
	}
		printf("\n\n==== END MIPS ========\n");
}
