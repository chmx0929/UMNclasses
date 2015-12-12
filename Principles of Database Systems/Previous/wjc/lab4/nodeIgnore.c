#include "postgres.h"

#include "executor/executor.h"
#include "executor/nodeIgnore.h"
#include "nodes/nodeFuncs.h"

static void recompute_ignores(IgnoreState *node);
static void pass_down_bound(IgnoreState *node, PlanState *child_node);

TupleTableSlot *				/* return: a tuple or NULL */
ExecIgnore(IgnoreState *node)
{
	ScanDirection direction;
	TupleTableSlot *slot;
	PlanState  *outerPlan;

	direction = node->ps.state->es_direction;
	outerPlan = outerPlanState(node);


	switch (node->lstate)
	{
		case IGNORE_INITIAL:

			recompute_ignores(node);


		case IGNORE_RESCAN:

			/*
			 * If backwards scan, just return NULL without changing state.
			 */
			if (!ScanDirectionIsForward(direction))
				return NULL;

			for (;;)
			{
				slot = ExecProcNode(outerPlan);
				if (TupIsNull(slot))
				{
					node->lstate = IGNORE_EMPTY;
					return NULL;
				}
				node->subSlot = slot;
				if (++node->position > node->offset)
					break;
			}

			/*
			 * Okay, we have the first tuple of the window.
			 */
			node->lstate = IGNORE_INWINDOW;
			break;

		case IGNORE_EMPTY:

			return NULL;

		case IGNORE_INWINDOW:
			if (ScanDirectionIsForward(direction))
			{

				slot = ExecProcNode(outerPlan);
				if (TupIsNull(slot))
				{
					node->lstate = IGNORE_SUBPLANEOF;
					return NULL;
				}
				node->subSlot = slot;
				node->position++;
			}
			else
			{
				if (node->position <= node->offset + 1)
				{
					node->lstate = IGNORE_WINDOWSTART;
					return NULL;
				}

				/*
				 * Get previous tuple from subplan; there should be one!
				 */
				slot = ExecProcNode(outerPlan);
				if (TupIsNull(slot))
					elog(ERROR, "IGNORE subplan failed to run backwards");
				node->subSlot = slot;
				node->position--;
			}
			break;

		case IGNORE_SUBPLANEOF:
			if (ScanDirectionIsForward(direction))
				return NULL;

			/*
			 * Backing up from subplan EOF, so re-fetch previous tuple; there
			 * should be one!  Note previous tuple must be in window.
			 */
			slot = ExecProcNode(outerPlan);
			if (TupIsNull(slot))
				elog(ERROR, "IGNORE subplan failed to run backwards");
			node->subSlot = slot;
			node->lstate = IGNORE_INWINDOW;
			/* position does not change 'cause we didn't advance it before */
			break;

		case IGNORE_WINDOWEND:
			if (ScanDirectionIsForward(direction))
				return NULL;

			slot = node->subSlot;
			node->lstate = IGNORE_INWINDOW;
			/* position does not change 'cause we didn't advance it before */
			break;

		case IGNORE_WINDOWSTART:
			if (!ScanDirectionIsForward(direction))
				return NULL;

			slot = node->subSlot;
			node->lstate = IGNORE_INWINDOW;
			/* position does not change 'cause we didn't change it before */
			break;

		default:
			elog(ERROR, "impossible IGNORE state: %d",
				 (int) node->lstate);
			slot = NULL;		/* keep compiler quiet */
			break;
	}

	/* Return the current tuple */
	Assert(!TupIsNull(slot));

	return slot;
}

IgnoreState *
ExecInitIgnore(Ignore *node, EState *estate, int eflags)
{
	IgnoreState *ignorestate;
	Plan	   *outerPlan;

	/* check for unsupported flags */
	Assert(!(eflags & EXEC_FLAG_MARK));

	ignorestate = makeNode(IgnoreState);
	ignorestate->ps.plan = (Plan *) node;
	ignorestate->ps.state = estate;

	ignorestate->lstate = IGNORE_INITIAL;

	ExecAssignExprContext(estate, &ignorestate->ps);

	/*
	 * initialize child expressions
	 */
	ignorestate->ignoreOffset = ExecInitExpr((Expr *) node->ignoreOffset,
										   (PlanState *) ignorestate);

	ExecInitResultTupleSlot(estate, &ignorestate->ps);

	outerPlan = outerPlan(node);
	outerPlanState(ignorestate) = ExecInitNode(outerPlan, estate, eflags);

	ExecAssignResultTypeFromTL(&ignorestate->ps);
	ignorestate->ps.ps_ProjInfo = NULL;

	return ignorestate;
}

void
ExecEndIgnore(IgnoreState *node)
{
	ExecFreeExprContext(&node->ps);
	ExecEndNode(outerPlanState(node));
}


void
ExecReScanIgnore(IgnoreState *node)
{
	recompute_ignores(node);

	if (node->ps.lefttree->chgParam == NULL)
		ExecReScan(node->ps.lefttree);
}
