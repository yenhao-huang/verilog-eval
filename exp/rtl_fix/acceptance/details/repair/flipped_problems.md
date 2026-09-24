# Problems that changed verdict relative to the baseline

### gemma4_26b_a4b — ReAct + compiler vs baseline

**Newly passing (20):** `2012_q2b#0`, `2013_q2bfsm#0`, `2013_q2bfsm#2`, `always_case2#0`, `always_casez#0`, `always_if#1`, `always_if#2`, `always_if2#0`, `always_if2#1`, `always_nolatches#5`, `fsm3comb#1`, `fsm3onehot#3`, `m2014_q6c#2`, `mt2015_q4#0`, `mt2015_q4#1`, `rule110#0`, `rule110#1`, `vector5#0`, `vectorr#2`, `vectorr#5`

**Newly failing (6):** `circuit6#0`, `fsm3onehot#1`, `gatesv100#1`, `kmap4#0`, `norgate#1`, `xnorgate#0`

### gemma4_26b_a4b — ReAct + compiler + RAG vs baseline

**Newly passing (12):** `always_case2#0`, `always_casez#0`, `always_casez#2`, `always_if#1`, `always_if#2`, `always_if2#0`, `always_if2#1`, `always_nolatches#5`, `fsm3comb#1`, `fsm3onehot#3`, `vectorr#2`, `vectorr#5`

**Newly failing (6):** `always_case2#3`, `always_casez#1`, `circuit6#0`, `fsm3onehot#2`, `gatesv100#0`, `lemmings1#0`

### qwen38_next — ReAct + compiler vs baseline

**Newly passing (21):** `2013_q2bfsm#1`, `2013_q2bfsm#2`, `circuit5#3`, `circuit6#3`, `ece241_2013_q12#0`, `ece241_2013_q12#1`, `edgedetect2#0`, `fsm3onehot#0`, `fsm3onehot#1`, `m2014_q4g#0`, `m2014_q4j#0`, `mt2015_q4#0`, `mt2015_q4#1`, `review2015_fsmshift#0`, `rule110#0`, `rule110#3`, `timer#0`, `vector100r#1`, `vector3#2`, `vectorr#2`, `xnorgate#0`

**Newly failing (3):** `always_nolatches#2`, `edgecapture#1`, `mt2015_eq2#0`

### qwen38_next — ReAct + compiler + RAG vs baseline

**Newly passing (24):** `2013_q2bfsm#0`, `2013_q2bfsm#1`, `2013_q2bfsm#2`, `circuit5#3`, `circuit6#3`, `ece241_2013_q12#0`, `ece241_2013_q12#1`, `edgedetect2#0`, `fsm3onehot#0`, `fsm3onehot#1`, `lfsr5#0`, `m2014_q4g#0`, `m2014_q4j#0`, `mt2015_q4#0`, `mt2015_q4#1`, `review2015_fsmshift#0`, `rule110#0`, `rule110#2`, `rule110#3`, `timer#0`, `vector100r#1`, `vector3#2`, `vectorr#2`, `xnorgate#0`

**Newly failing (2):** `2012_q2b#1`, `always_case2#2`

