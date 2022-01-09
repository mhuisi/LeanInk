import Mathlib.Tactic.Basic

set_option trace.Elab.info true

example : ∀ a b : Nat, a = b → b = a := by
  introv h
  exact h.symm

example (n : Nat) : n = n := by
  induction n
  exacts [rfl, rfl]
  exacts []

example (n : Nat) : Nat := by
  guard_hyp n : Nat
  let m : Nat := 1
  guard_hyp m := 1
  guard_hyp m : Nat := 1
  guard_target == Nat
  exact 0

example (a b : Nat) : a ≠ b → ¬ a = b := by
  intros
  by_contra H
  contradiction

example (a b : Nat) : ¬¬ a = b → a = b := by
  intros
  by_contra H
  contradiction

example (p q : Prop) : ¬¬ p → p := by
  intros
  by_contra H
  contradiction

-- Test `iterate n ...`
example (n m : Nat) : Unit := by
  cases n
  cases m
  iterate 3 exact ()

-- Test `iterate ...`, which should repeat until failure.
example (n m : Nat) : Unit := by
  cases n
  cases m
  iterate exact ()

example (n : Nat) : Nat := by
  iterate exact () -- silently succeeds, after iterating 0 times
  iterate exact n

example (p q r s : Prop) : p → q → r → s → (p ∧ q) ∧ (r ∧ s ∧ p) ∧ (p ∧ r ∧ q) := by
  intros
  repeat' constructor
  repeat' assumption

example (p q : Prop) : p → q → (p ∧ q) ∧ (p ∧ q ∧ p) := by
  intros
  constructor
  fail_if_success any_goals assumption
  all_goals constructor
  any_goals assumption
  constructor
  any_goals assumption

-- Verify correct behaviour of `work_on_goal`.
example (p q r : Prop) : p → q → r → p ∧ q ∧ r := by
  intros
  constructor
  work_on_goal 1
    guard_target == q ∧ r
    constructor
    assumption
    -- Note that we have not closed all the subgoals here.
  guard_target == p
  assumption
  guard_target == r
  assumption