#ifndef QUAD_H
#define QUAD_H

#include "symbol.h"
#include "quad_op.h"

typedef struct quad {
	int label;
	enum quad_op op;
	struct symbol* arg1;
	struct symbol* arg2;
	struct symbol* res;
	struct quad* next;
} quad;

typedef struct quad_list {
	struct quad* node;
	struct quad_list* next;
} quad_list;

quad* quad_gen(int* label, enum quad_op op, symbol* arg1, symbol* arg2, symbol* res);
void quad_free(struct quad*);
void quad_add(struct quad**, struct quad*);
void quad_print(struct quad*);
void gen_mips(quad* quad);

struct quad_list* quad_list_new(struct quad*);
void quad_list_add(struct quad_list**, struct quad_list*);
void quad_list_complete(struct quad_list*, struct symbol*);
void quad_list_print(struct quad_list*);
void quad_list_complete_label(struct quad_list* list, int label);

#endif
